
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 04 02 00 00       	call   800235 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	6a 04                	push   $0x4
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	e8 53 15 00 00       	call   8015a4 <readn>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 04             	cmp    $0x4,%eax
  800057:	75 4b                	jne    8000a4 <primeproc+0x71>
	cprintf("%d\n", p);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	ff 75 e0             	pushl  -0x20(%ebp)
  80005f:	68 a1 27 80 00       	push   $0x8027a1
  800064:	e8 07 03 00 00       	call   800370 <cprintf>
	if ((i=pipe(pfd)) < 0)
  800069:	89 3c 24             	mov    %edi,(%esp)
  80006c:	e8 ec 1f 00 00       	call   80205d <pipe>
  800071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	85 c0                	test   %eax,%eax
  800079:	78 49                	js     8000c4 <primeproc+0x91>
		panic("pipe: %e", i);
	if ((id = fork()) < 0)
  80007b:	e8 f1 0f 00 00       	call   801071 <fork>
  800080:	85 c0                	test   %eax,%eax
  800082:	78 52                	js     8000d6 <primeproc+0xa3>
		panic("fork: %e", id);
	if (id == 0) {
  800084:	85 c0                	test   %eax,%eax
  800086:	75 60                	jne    8000e8 <primeproc+0xb5>
		close(fd);
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	53                   	push   %ebx
  80008c:	e8 50 13 00 00       	call   8013e1 <close>
		close(pfd[1]);
  800091:	83 c4 04             	add    $0x4,%esp
  800094:	ff 75 dc             	pushl  -0x24(%ebp)
  800097:	e8 45 13 00 00       	call   8013e1 <close>
		fd = pfd[0];
  80009c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb a1                	jmp    800045 <primeproc+0x12>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	85 c0                	test   %eax,%eax
  8000a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ae:	0f 4e d0             	cmovle %eax,%edx
  8000b1:	52                   	push   %edx
  8000b2:	50                   	push   %eax
  8000b3:	68 60 27 80 00       	push   $0x802760
  8000b8:	6a 15                	push   $0x15
  8000ba:	68 8f 27 80 00       	push   $0x80278f
  8000bf:	e8 d1 01 00 00       	call   800295 <_panic>
		panic("pipe: %e", i);
  8000c4:	50                   	push   %eax
  8000c5:	68 a5 27 80 00       	push   $0x8027a5
  8000ca:	6a 1b                	push   $0x1b
  8000cc:	68 8f 27 80 00       	push   $0x80278f
  8000d1:	e8 bf 01 00 00       	call   800295 <_panic>
		panic("fork: %e", id);
  8000d6:	50                   	push   %eax
  8000d7:	68 ae 27 80 00       	push   $0x8027ae
  8000dc:	6a 1d                	push   $0x1d
  8000de:	68 8f 27 80 00       	push   $0x80278f
  8000e3:	e8 ad 01 00 00       	call   800295 <_panic>
	}

	close(pfd[0]);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ee:	e8 ee 12 00 00       	call   8013e1 <close>
	wfd = pfd[1];
  8000f3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f6:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f9:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 04                	push   $0x4
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	e8 9c 14 00 00       	call   8015a4 <readn>
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	83 f8 04             	cmp    $0x4,%eax
  80010e:	75 42                	jne    800152 <primeproc+0x11f>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800113:	99                   	cltd   
  800114:	f7 7d e0             	idivl  -0x20(%ebp)
  800117:	85 d2                	test   %edx,%edx
  800119:	74 e1                	je     8000fc <primeproc+0xc9>
			if ((r=write(wfd, &i, 4)) != 4)
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 04                	push   $0x4
  800120:	56                   	push   %esi
  800121:	57                   	push   %edi
  800122:	e8 c4 14 00 00       	call   8015eb <write>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	83 f8 04             	cmp    $0x4,%eax
  80012d:	74 cd                	je     8000fc <primeproc+0xc9>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	85 c0                	test   %eax,%eax
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	0f 4e d0             	cmovle %eax,%edx
  80013c:	52                   	push   %edx
  80013d:	50                   	push   %eax
  80013e:	ff 75 e0             	pushl  -0x20(%ebp)
  800141:	68 d3 27 80 00       	push   $0x8027d3
  800146:	6a 2e                	push   $0x2e
  800148:	68 8f 27 80 00       	push   $0x80278f
  80014d:	e8 43 01 00 00       	call   800295 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	85 c0                	test   %eax,%eax
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	0f 4e d0             	cmovle %eax,%edx
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	53                   	push   %ebx
  800162:	ff 75 e0             	pushl  -0x20(%ebp)
  800165:	68 b7 27 80 00       	push   $0x8027b7
  80016a:	6a 2b                	push   $0x2b
  80016c:	68 8f 27 80 00       	push   $0x80278f
  800171:	e8 1f 01 00 00       	call   800295 <_panic>

00800176 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	53                   	push   %ebx
  80017a:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017d:	c7 05 00 30 80 00 ed 	movl   $0x8027ed,0x803000
  800184:	27 80 00 

	if ((i=pipe(p)) < 0)
  800187:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 cd 1e 00 00       	call   80205d <pipe>
  800190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	85 c0                	test   %eax,%eax
  800198:	78 23                	js     8001bd <umain+0x47>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80019a:	e8 d2 0e 00 00       	call   801071 <fork>
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	78 2c                	js     8001cf <umain+0x59>
		panic("fork: %e", id);

	if (id == 0) {
  8001a3:	85 c0                	test   %eax,%eax
  8001a5:	75 3a                	jne    8001e1 <umain+0x6b>
		close(p[1]);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 2f 12 00 00       	call   8013e1 <close>
		primeproc(p[0]);
  8001b2:	83 c4 04             	add    $0x4,%esp
  8001b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b8:	e8 76 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001bd:	50                   	push   %eax
  8001be:	68 a5 27 80 00       	push   $0x8027a5
  8001c3:	6a 3a                	push   $0x3a
  8001c5:	68 8f 27 80 00       	push   $0x80278f
  8001ca:	e8 c6 00 00 00       	call   800295 <_panic>
		panic("fork: %e", id);
  8001cf:	50                   	push   %eax
  8001d0:	68 ae 27 80 00       	push   $0x8027ae
  8001d5:	6a 3e                	push   $0x3e
  8001d7:	68 8f 27 80 00       	push   $0x80278f
  8001dc:	e8 b4 00 00 00       	call   800295 <_panic>
	}

	close(p[0]);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e7:	e8 f5 11 00 00       	call   8013e1 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001ec:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f3:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f6:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	6a 04                	push   $0x4
  8001fe:	53                   	push   %ebx
  8001ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800202:	e8 e4 13 00 00       	call   8015eb <write>
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	83 f8 04             	cmp    $0x4,%eax
  80020d:	75 06                	jne    800215 <umain+0x9f>
	for (i=2;; i++)
  80020f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800213:	eb e4                	jmp    8001f9 <umain+0x83>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	ba 00 00 00 00       	mov    $0x0,%edx
  80021f:	0f 4e d0             	cmovle %eax,%edx
  800222:	52                   	push   %edx
  800223:	50                   	push   %eax
  800224:	68 f8 27 80 00       	push   $0x8027f8
  800229:	6a 4a                	push   $0x4a
  80022b:	68 8f 27 80 00       	push   $0x80278f
  800230:	e8 60 00 00 00       	call   800295 <_panic>

00800235 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	56                   	push   %esi
  800239:	53                   	push   %ebx
  80023a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80023d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800240:	e8 05 0b 00 00       	call   800d4a <sys_getenvid>
  800245:	25 ff 03 00 00       	and    $0x3ff,%eax
  80024a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80024d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800252:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800257:	85 db                	test   %ebx,%ebx
  800259:	7e 07                	jle    800262 <libmain+0x2d>
		binaryname = argv[0];
  80025b:	8b 06                	mov    (%esi),%eax
  80025d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	e8 0a ff ff ff       	call   800176 <umain>

	// exit gracefully
	exit();
  80026c:	e8 0a 00 00 00       	call   80027b <exit>
}
  800271:	83 c4 10             	add    $0x10,%esp
  800274:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <exit>:

#include <inc/lib.h>

void exit(void)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800281:	e8 86 11 00 00       	call   80140c <close_all>
	sys_env_destroy(0);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	6a 00                	push   $0x0
  80028b:	e8 79 0a 00 00       	call   800d09 <sys_env_destroy>
}
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80029a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80029d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002a3:	e8 a2 0a 00 00       	call   800d4a <sys_getenvid>
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 0c             	pushl  0xc(%ebp)
  8002ae:	ff 75 08             	pushl  0x8(%ebp)
  8002b1:	56                   	push   %esi
  8002b2:	50                   	push   %eax
  8002b3:	68 1c 28 80 00       	push   $0x80281c
  8002b8:	e8 b3 00 00 00       	call   800370 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002bd:	83 c4 18             	add    $0x18,%esp
  8002c0:	53                   	push   %ebx
  8002c1:	ff 75 10             	pushl  0x10(%ebp)
  8002c4:	e8 56 00 00 00       	call   80031f <vcprintf>
	cprintf("\n");
  8002c9:	c7 04 24 a3 27 80 00 	movl   $0x8027a3,(%esp)
  8002d0:	e8 9b 00 00 00       	call   800370 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d8:	cc                   	int3   
  8002d9:	eb fd                	jmp    8002d8 <_panic+0x43>

008002db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	53                   	push   %ebx
  8002df:	83 ec 04             	sub    $0x4,%esp
  8002e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e5:	8b 13                	mov    (%ebx),%edx
  8002e7:	8d 42 01             	lea    0x1(%edx),%eax
  8002ea:	89 03                	mov    %eax,(%ebx)
  8002ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f8:	74 09                	je     800303 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002fa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800301:	c9                   	leave  
  800302:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	68 ff 00 00 00       	push   $0xff
  80030b:	8d 43 08             	lea    0x8(%ebx),%eax
  80030e:	50                   	push   %eax
  80030f:	e8 b8 09 00 00       	call   800ccc <sys_cputs>
		b->idx = 0;
  800314:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	eb db                	jmp    8002fa <putch+0x1f>

0080031f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800328:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032f:	00 00 00 
	b.cnt = 0;
  800332:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800339:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80033c:	ff 75 0c             	pushl  0xc(%ebp)
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800348:	50                   	push   %eax
  800349:	68 db 02 80 00       	push   $0x8002db
  80034e:	e8 1a 01 00 00       	call   80046d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800353:	83 c4 08             	add    $0x8,%esp
  800356:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80035c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800362:	50                   	push   %eax
  800363:	e8 64 09 00 00       	call   800ccc <sys_cputs>

	return b.cnt;
}
  800368:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800376:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800379:	50                   	push   %eax
  80037a:	ff 75 08             	pushl  0x8(%ebp)
  80037d:	e8 9d ff ff ff       	call   80031f <vcprintf>
	va_end(ap);

	return cnt;
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 1c             	sub    $0x1c,%esp
  80038d:	89 c7                	mov    %eax,%edi
  80038f:	89 d6                	mov    %edx,%esi
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80039d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003a8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003ab:	39 d3                	cmp    %edx,%ebx
  8003ad:	72 05                	jb     8003b4 <printnum+0x30>
  8003af:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003b2:	77 7a                	ja     80042e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	ff 75 18             	pushl  0x18(%ebp)
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c0:	53                   	push   %ebx
  8003c1:	ff 75 10             	pushl  0x10(%ebp)
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d3:	e8 38 21 00 00       	call   802510 <__udivdi3>
  8003d8:	83 c4 18             	add    $0x18,%esp
  8003db:	52                   	push   %edx
  8003dc:	50                   	push   %eax
  8003dd:	89 f2                	mov    %esi,%edx
  8003df:	89 f8                	mov    %edi,%eax
  8003e1:	e8 9e ff ff ff       	call   800384 <printnum>
  8003e6:	83 c4 20             	add    $0x20,%esp
  8003e9:	eb 13                	jmp    8003fe <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	56                   	push   %esi
  8003ef:	ff 75 18             	pushl  0x18(%ebp)
  8003f2:	ff d7                	call   *%edi
  8003f4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003f7:	83 eb 01             	sub    $0x1,%ebx
  8003fa:	85 db                	test   %ebx,%ebx
  8003fc:	7f ed                	jg     8003eb <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	56                   	push   %esi
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	ff 75 e4             	pushl  -0x1c(%ebp)
  800408:	ff 75 e0             	pushl  -0x20(%ebp)
  80040b:	ff 75 dc             	pushl  -0x24(%ebp)
  80040e:	ff 75 d8             	pushl  -0x28(%ebp)
  800411:	e8 1a 22 00 00       	call   802630 <__umoddi3>
  800416:	83 c4 14             	add    $0x14,%esp
  800419:	0f be 80 3f 28 80 00 	movsbl 0x80283f(%eax),%eax
  800420:	50                   	push   %eax
  800421:	ff d7                	call   *%edi
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800429:	5b                   	pop    %ebx
  80042a:	5e                   	pop    %esi
  80042b:	5f                   	pop    %edi
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    
  80042e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800431:	eb c4                	jmp    8003f7 <printnum+0x73>

00800433 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800439:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80043d:	8b 10                	mov    (%eax),%edx
  80043f:	3b 50 04             	cmp    0x4(%eax),%edx
  800442:	73 0a                	jae    80044e <sprintputch+0x1b>
		*b->buf++ = ch;
  800444:	8d 4a 01             	lea    0x1(%edx),%ecx
  800447:	89 08                	mov    %ecx,(%eax)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	88 02                	mov    %al,(%edx)
}
  80044e:	5d                   	pop    %ebp
  80044f:	c3                   	ret    

00800450 <printfmt>:
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800456:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800459:	50                   	push   %eax
  80045a:	ff 75 10             	pushl  0x10(%ebp)
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	ff 75 08             	pushl  0x8(%ebp)
  800463:	e8 05 00 00 00       	call   80046d <vprintfmt>
}
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    

0080046d <vprintfmt>:
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	57                   	push   %edi
  800471:	56                   	push   %esi
  800472:	53                   	push   %ebx
  800473:	83 ec 2c             	sub    $0x2c,%esp
  800476:	8b 75 08             	mov    0x8(%ebp),%esi
  800479:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80047c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80047f:	e9 c1 03 00 00       	jmp    800845 <vprintfmt+0x3d8>
		padc = ' ';
  800484:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800488:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80048f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800496:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80049d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8d 47 01             	lea    0x1(%edi),%eax
  8004a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a8:	0f b6 17             	movzbl (%edi),%edx
  8004ab:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004ae:	3c 55                	cmp    $0x55,%al
  8004b0:	0f 87 12 04 00 00    	ja     8008c8 <vprintfmt+0x45b>
  8004b6:	0f b6 c0             	movzbl %al,%eax
  8004b9:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004c7:	eb d9                	jmp    8004a2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004cc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004d0:	eb d0                	jmp    8004a2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	0f b6 d2             	movzbl %dl,%edx
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004e7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ea:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004ed:	83 f9 09             	cmp    $0x9,%ecx
  8004f0:	77 55                	ja     800547 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004f2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004f5:	eb e9                	jmp    8004e0 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8d 40 04             	lea    0x4(%eax),%eax
  800505:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800508:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80050b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050f:	79 91                	jns    8004a2 <vprintfmt+0x35>
				width = precision, precision = -1;
  800511:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80051e:	eb 82                	jmp    8004a2 <vprintfmt+0x35>
  800520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800523:	85 c0                	test   %eax,%eax
  800525:	ba 00 00 00 00       	mov    $0x0,%edx
  80052a:	0f 49 d0             	cmovns %eax,%edx
  80052d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800533:	e9 6a ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
  800538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80053b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800542:	e9 5b ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
  800547:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80054a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054d:	eb bc                	jmp    80050b <vprintfmt+0x9e>
			lflag++;
  80054f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800555:	e9 48 ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 78 04             	lea    0x4(%eax),%edi
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	ff 30                	pushl  (%eax)
  800566:	ff d6                	call   *%esi
			break;
  800568:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80056e:	e9 cf 02 00 00       	jmp    800842 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8d 78 04             	lea    0x4(%eax),%edi
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	99                   	cltd   
  80057c:	31 d0                	xor    %edx,%eax
  80057e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800580:	83 f8 0f             	cmp    $0xf,%eax
  800583:	7f 23                	jg     8005a8 <vprintfmt+0x13b>
  800585:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  80058c:	85 d2                	test   %edx,%edx
  80058e:	74 18                	je     8005a8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800590:	52                   	push   %edx
  800591:	68 05 2d 80 00       	push   $0x802d05
  800596:	53                   	push   %ebx
  800597:	56                   	push   %esi
  800598:	e8 b3 fe ff ff       	call   800450 <printfmt>
  80059d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a3:	e9 9a 02 00 00       	jmp    800842 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8005a8:	50                   	push   %eax
  8005a9:	68 57 28 80 00       	push   $0x802857
  8005ae:	53                   	push   %ebx
  8005af:	56                   	push   %esi
  8005b0:	e8 9b fe ff ff       	call   800450 <printfmt>
  8005b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005bb:	e9 82 02 00 00       	jmp    800842 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	83 c0 04             	add    $0x4,%eax
  8005c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005ce:	85 ff                	test   %edi,%edi
  8005d0:	b8 50 28 80 00       	mov    $0x802850,%eax
  8005d5:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005dc:	0f 8e bd 00 00 00    	jle    80069f <vprintfmt+0x232>
  8005e2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005e6:	75 0e                	jne    8005f6 <vprintfmt+0x189>
  8005e8:	89 75 08             	mov    %esi,0x8(%ebp)
  8005eb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005ee:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005f1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f4:	eb 6d                	jmp    800663 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8005fc:	57                   	push   %edi
  8005fd:	e8 6e 03 00 00       	call   800970 <strnlen>
  800602:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800605:	29 c1                	sub    %eax,%ecx
  800607:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80060a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80060d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800611:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800614:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800617:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800619:	eb 0f                	jmp    80062a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	ff 75 e0             	pushl  -0x20(%ebp)
  800622:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800624:	83 ef 01             	sub    $0x1,%edi
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	85 ff                	test   %edi,%edi
  80062c:	7f ed                	jg     80061b <vprintfmt+0x1ae>
  80062e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800631:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800634:	85 c9                	test   %ecx,%ecx
  800636:	b8 00 00 00 00       	mov    $0x0,%eax
  80063b:	0f 49 c1             	cmovns %ecx,%eax
  80063e:	29 c1                	sub    %eax,%ecx
  800640:	89 75 08             	mov    %esi,0x8(%ebp)
  800643:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800646:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800649:	89 cb                	mov    %ecx,%ebx
  80064b:	eb 16                	jmp    800663 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80064d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800651:	75 31                	jne    800684 <vprintfmt+0x217>
					putch(ch, putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	ff 75 0c             	pushl  0xc(%ebp)
  800659:	50                   	push   %eax
  80065a:	ff 55 08             	call   *0x8(%ebp)
  80065d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800660:	83 eb 01             	sub    $0x1,%ebx
  800663:	83 c7 01             	add    $0x1,%edi
  800666:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80066a:	0f be c2             	movsbl %dl,%eax
  80066d:	85 c0                	test   %eax,%eax
  80066f:	74 59                	je     8006ca <vprintfmt+0x25d>
  800671:	85 f6                	test   %esi,%esi
  800673:	78 d8                	js     80064d <vprintfmt+0x1e0>
  800675:	83 ee 01             	sub    $0x1,%esi
  800678:	79 d3                	jns    80064d <vprintfmt+0x1e0>
  80067a:	89 df                	mov    %ebx,%edi
  80067c:	8b 75 08             	mov    0x8(%ebp),%esi
  80067f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800682:	eb 37                	jmp    8006bb <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800684:	0f be d2             	movsbl %dl,%edx
  800687:	83 ea 20             	sub    $0x20,%edx
  80068a:	83 fa 5e             	cmp    $0x5e,%edx
  80068d:	76 c4                	jbe    800653 <vprintfmt+0x1e6>
					putch('?', putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	6a 3f                	push   $0x3f
  800697:	ff 55 08             	call   *0x8(%ebp)
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	eb c1                	jmp    800660 <vprintfmt+0x1f3>
  80069f:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ab:	eb b6                	jmp    800663 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 20                	push   $0x20
  8006b3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	85 ff                	test   %edi,%edi
  8006bd:	7f ee                	jg     8006ad <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c5:	e9 78 01 00 00       	jmp    800842 <vprintfmt+0x3d5>
  8006ca:	89 df                	mov    %ebx,%edi
  8006cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d2:	eb e7                	jmp    8006bb <vprintfmt+0x24e>
	if (lflag >= 2)
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7e 3f                	jle    800718 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 50 04             	mov    0x4(%eax),%edx
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 08             	lea    0x8(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f4:	79 5c                	jns    800752 <vprintfmt+0x2e5>
				putch('-', putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 2d                	push   $0x2d
  8006fc:	ff d6                	call   *%esi
				num = -(long long) num;
  8006fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800701:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800704:	f7 da                	neg    %edx
  800706:	83 d1 00             	adc    $0x0,%ecx
  800709:	f7 d9                	neg    %ecx
  80070b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80070e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800713:	e9 10 01 00 00       	jmp    800828 <vprintfmt+0x3bb>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	75 1b                	jne    800737 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	89 c1                	mov    %eax,%ecx
  800726:	c1 f9 1f             	sar    $0x1f,%ecx
  800729:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	eb b9                	jmp    8006f0 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073f:	89 c1                	mov    %eax,%ecx
  800741:	c1 f9 1f             	sar    $0x1f,%ecx
  800744:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 04             	lea    0x4(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
  800750:	eb 9e                	jmp    8006f0 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800752:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800755:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800758:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075d:	e9 c6 00 00 00       	jmp    800828 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800762:	83 f9 01             	cmp    $0x1,%ecx
  800765:	7e 18                	jle    80077f <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 10                	mov    (%eax),%edx
  80076c:	8b 48 04             	mov    0x4(%eax),%ecx
  80076f:	8d 40 08             	lea    0x8(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800775:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077a:	e9 a9 00 00 00       	jmp    800828 <vprintfmt+0x3bb>
	else if (lflag)
  80077f:	85 c9                	test   %ecx,%ecx
  800781:	75 1a                	jne    80079d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 10                	mov    (%eax),%edx
  800788:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800793:	b8 0a 00 00 00       	mov    $0xa,%eax
  800798:	e9 8b 00 00 00       	jmp    800828 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b2:	eb 74                	jmp    800828 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8007b4:	83 f9 01             	cmp    $0x1,%ecx
  8007b7:	7e 15                	jle    8007ce <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 10                	mov    (%eax),%edx
  8007be:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c1:	8d 40 08             	lea    0x8(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8007cc:	eb 5a                	jmp    800828 <vprintfmt+0x3bb>
	else if (lflag)
  8007ce:	85 c9                	test   %ecx,%ecx
  8007d0:	75 17                	jne    8007e9 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 10                	mov    (%eax),%edx
  8007d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007e7:	eb 3f                	jmp    800828 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 10                	mov    (%eax),%edx
  8007ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f3:	8d 40 04             	lea    0x4(%eax),%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8007fe:	eb 28                	jmp    800828 <vprintfmt+0x3bb>
			putch('0', putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	53                   	push   %ebx
  800804:	6a 30                	push   $0x30
  800806:	ff d6                	call   *%esi
			putch('x', putdat);
  800808:	83 c4 08             	add    $0x8,%esp
  80080b:	53                   	push   %ebx
  80080c:	6a 78                	push   $0x78
  80080e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8b 10                	mov    (%eax),%edx
  800815:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80081a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80081d:	8d 40 04             	lea    0x4(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800823:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800828:	83 ec 0c             	sub    $0xc,%esp
  80082b:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80082f:	57                   	push   %edi
  800830:	ff 75 e0             	pushl  -0x20(%ebp)
  800833:	50                   	push   %eax
  800834:	51                   	push   %ecx
  800835:	52                   	push   %edx
  800836:	89 da                	mov    %ebx,%edx
  800838:	89 f0                	mov    %esi,%eax
  80083a:	e8 45 fb ff ff       	call   800384 <printnum>
			break;
  80083f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800842:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800845:	83 c7 01             	add    $0x1,%edi
  800848:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80084c:	83 f8 25             	cmp    $0x25,%eax
  80084f:	0f 84 2f fc ff ff    	je     800484 <vprintfmt+0x17>
			if (ch == '\0')
  800855:	85 c0                	test   %eax,%eax
  800857:	0f 84 8b 00 00 00    	je     8008e8 <vprintfmt+0x47b>
			putch(ch, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	50                   	push   %eax
  800862:	ff d6                	call   *%esi
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	eb dc                	jmp    800845 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800869:	83 f9 01             	cmp    $0x1,%ecx
  80086c:	7e 15                	jle    800883 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8b 10                	mov    (%eax),%edx
  800873:	8b 48 04             	mov    0x4(%eax),%ecx
  800876:	8d 40 08             	lea    0x8(%eax),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087c:	b8 10 00 00 00       	mov    $0x10,%eax
  800881:	eb a5                	jmp    800828 <vprintfmt+0x3bb>
	else if (lflag)
  800883:	85 c9                	test   %ecx,%ecx
  800885:	75 17                	jne    80089e <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8b 10                	mov    (%eax),%edx
  80088c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800891:	8d 40 04             	lea    0x4(%eax),%eax
  800894:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800897:	b8 10 00 00 00       	mov    $0x10,%eax
  80089c:	eb 8a                	jmp    800828 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8b 10                	mov    (%eax),%edx
  8008a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a8:	8d 40 04             	lea    0x4(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b3:	e9 70 ff ff ff       	jmp    800828 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	53                   	push   %ebx
  8008bc:	6a 25                	push   $0x25
  8008be:	ff d6                	call   *%esi
			break;
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	e9 7a ff ff ff       	jmp    800842 <vprintfmt+0x3d5>
			putch('%', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	53                   	push   %ebx
  8008cc:	6a 25                	push   $0x25
  8008ce:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	89 f8                	mov    %edi,%eax
  8008d5:	eb 03                	jmp    8008da <vprintfmt+0x46d>
  8008d7:	83 e8 01             	sub    $0x1,%eax
  8008da:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008de:	75 f7                	jne    8008d7 <vprintfmt+0x46a>
  8008e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e3:	e9 5a ff ff ff       	jmp    800842 <vprintfmt+0x3d5>
}
  8008e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5f                   	pop    %edi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 18             	sub    $0x18,%esp
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ff:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800903:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800906:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090d:	85 c0                	test   %eax,%eax
  80090f:	74 26                	je     800937 <vsnprintf+0x47>
  800911:	85 d2                	test   %edx,%edx
  800913:	7e 22                	jle    800937 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800915:	ff 75 14             	pushl  0x14(%ebp)
  800918:	ff 75 10             	pushl  0x10(%ebp)
  80091b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091e:	50                   	push   %eax
  80091f:	68 33 04 80 00       	push   $0x800433
  800924:	e8 44 fb ff ff       	call   80046d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800932:	83 c4 10             	add    $0x10,%esp
}
  800935:	c9                   	leave  
  800936:	c3                   	ret    
		return -E_INVAL;
  800937:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80093c:	eb f7                	jmp    800935 <vsnprintf+0x45>

0080093e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800944:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800947:	50                   	push   %eax
  800948:	ff 75 10             	pushl  0x10(%ebp)
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	ff 75 08             	pushl  0x8(%ebp)
  800951:	e8 9a ff ff ff       	call   8008f0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb 03                	jmp    800968 <strlen+0x10>
		n++;
  800965:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800968:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80096c:	75 f7                	jne    800965 <strlen+0xd>
	return n;
}
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	eb 03                	jmp    800983 <strnlen+0x13>
		n++;
  800980:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800983:	39 d0                	cmp    %edx,%eax
  800985:	74 06                	je     80098d <strnlen+0x1d>
  800987:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80098b:	75 f3                	jne    800980 <strnlen+0x10>
	return n;
}
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	53                   	push   %ebx
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800999:	89 c2                	mov    %eax,%edx
  80099b:	83 c1 01             	add    $0x1,%ecx
  80099e:	83 c2 01             	add    $0x1,%edx
  8009a1:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009a5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a8:	84 db                	test   %bl,%bl
  8009aa:	75 ef                	jne    80099b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009ac:	5b                   	pop    %ebx
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	53                   	push   %ebx
  8009b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b6:	53                   	push   %ebx
  8009b7:	e8 9c ff ff ff       	call   800958 <strlen>
  8009bc:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	01 d8                	add    %ebx,%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 c5 ff ff ff       	call   80098f <strcpy>
	return dst;
}
  8009ca:	89 d8                	mov    %ebx,%eax
  8009cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009dc:	89 f3                	mov    %esi,%ebx
  8009de:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e1:	89 f2                	mov    %esi,%edx
  8009e3:	eb 0f                	jmp    8009f4 <strncpy+0x23>
		*dst++ = *src;
  8009e5:	83 c2 01             	add    $0x1,%edx
  8009e8:	0f b6 01             	movzbl (%ecx),%eax
  8009eb:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ee:	80 39 01             	cmpb   $0x1,(%ecx)
  8009f1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009f4:	39 da                	cmp    %ebx,%edx
  8009f6:	75 ed                	jne    8009e5 <strncpy+0x14>
	}
	return ret;
}
  8009f8:	89 f0                	mov    %esi,%eax
  8009fa:	5b                   	pop    %ebx
  8009fb:	5e                   	pop    %esi
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	56                   	push   %esi
  800a02:	53                   	push   %ebx
  800a03:	8b 75 08             	mov    0x8(%ebp),%esi
  800a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a0c:	89 f0                	mov    %esi,%eax
  800a0e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a12:	85 c9                	test   %ecx,%ecx
  800a14:	75 0b                	jne    800a21 <strlcpy+0x23>
  800a16:	eb 17                	jmp    800a2f <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a18:	83 c2 01             	add    $0x1,%edx
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a21:	39 d8                	cmp    %ebx,%eax
  800a23:	74 07                	je     800a2c <strlcpy+0x2e>
  800a25:	0f b6 0a             	movzbl (%edx),%ecx
  800a28:	84 c9                	test   %cl,%cl
  800a2a:	75 ec                	jne    800a18 <strlcpy+0x1a>
		*dst = '\0';
  800a2c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a2f:	29 f0                	sub    %esi,%eax
}
  800a31:	5b                   	pop    %ebx
  800a32:	5e                   	pop    %esi
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    

00800a35 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a3e:	eb 06                	jmp    800a46 <strcmp+0x11>
		p++, q++;
  800a40:	83 c1 01             	add    $0x1,%ecx
  800a43:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a46:	0f b6 01             	movzbl (%ecx),%eax
  800a49:	84 c0                	test   %al,%al
  800a4b:	74 04                	je     800a51 <strcmp+0x1c>
  800a4d:	3a 02                	cmp    (%edx),%al
  800a4f:	74 ef                	je     800a40 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a51:	0f b6 c0             	movzbl %al,%eax
  800a54:	0f b6 12             	movzbl (%edx),%edx
  800a57:	29 d0                	sub    %edx,%eax
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	89 c3                	mov    %eax,%ebx
  800a67:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a6a:	eb 06                	jmp    800a72 <strncmp+0x17>
		n--, p++, q++;
  800a6c:	83 c0 01             	add    $0x1,%eax
  800a6f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a72:	39 d8                	cmp    %ebx,%eax
  800a74:	74 16                	je     800a8c <strncmp+0x31>
  800a76:	0f b6 08             	movzbl (%eax),%ecx
  800a79:	84 c9                	test   %cl,%cl
  800a7b:	74 04                	je     800a81 <strncmp+0x26>
  800a7d:	3a 0a                	cmp    (%edx),%cl
  800a7f:	74 eb                	je     800a6c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a81:	0f b6 00             	movzbl (%eax),%eax
  800a84:	0f b6 12             	movzbl (%edx),%edx
  800a87:	29 d0                	sub    %edx,%eax
}
  800a89:	5b                   	pop    %ebx
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    
		return 0;
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a91:	eb f6                	jmp    800a89 <strncmp+0x2e>

00800a93 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9d:	0f b6 10             	movzbl (%eax),%edx
  800aa0:	84 d2                	test   %dl,%dl
  800aa2:	74 09                	je     800aad <strchr+0x1a>
		if (*s == c)
  800aa4:	38 ca                	cmp    %cl,%dl
  800aa6:	74 0a                	je     800ab2 <strchr+0x1f>
	for (; *s; s++)
  800aa8:	83 c0 01             	add    $0x1,%eax
  800aab:	eb f0                	jmp    800a9d <strchr+0xa>
			return (char *) s;
	return 0;
  800aad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800abe:	eb 03                	jmp    800ac3 <strfind+0xf>
  800ac0:	83 c0 01             	add    $0x1,%eax
  800ac3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ac6:	38 ca                	cmp    %cl,%dl
  800ac8:	74 04                	je     800ace <strfind+0x1a>
  800aca:	84 d2                	test   %dl,%dl
  800acc:	75 f2                	jne    800ac0 <strfind+0xc>
			break;
	return (char *) s;
}
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	57                   	push   %edi
  800ad4:	56                   	push   %esi
  800ad5:	53                   	push   %ebx
  800ad6:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800adc:	85 c9                	test   %ecx,%ecx
  800ade:	74 13                	je     800af3 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae0:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ae6:	75 05                	jne    800aed <memset+0x1d>
  800ae8:	f6 c1 03             	test   $0x3,%cl
  800aeb:	74 0d                	je     800afa <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	fc                   	cld    
  800af1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800af3:	89 f8                	mov    %edi,%eax
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    
		c &= 0xFF;
  800afa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800afe:	89 d3                	mov    %edx,%ebx
  800b00:	c1 e3 08             	shl    $0x8,%ebx
  800b03:	89 d0                	mov    %edx,%eax
  800b05:	c1 e0 18             	shl    $0x18,%eax
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	c1 e6 10             	shl    $0x10,%esi
  800b0d:	09 f0                	or     %esi,%eax
  800b0f:	09 c2                	or     %eax,%edx
  800b11:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b13:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b16:	89 d0                	mov    %edx,%eax
  800b18:	fc                   	cld    
  800b19:	f3 ab                	rep stos %eax,%es:(%edi)
  800b1b:	eb d6                	jmp    800af3 <memset+0x23>

00800b1d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	57                   	push   %edi
  800b21:	56                   	push   %esi
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b28:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b2b:	39 c6                	cmp    %eax,%esi
  800b2d:	73 35                	jae    800b64 <memmove+0x47>
  800b2f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b32:	39 c2                	cmp    %eax,%edx
  800b34:	76 2e                	jbe    800b64 <memmove+0x47>
		s += n;
		d += n;
  800b36:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b39:	89 d6                	mov    %edx,%esi
  800b3b:	09 fe                	or     %edi,%esi
  800b3d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b43:	74 0c                	je     800b51 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b45:	83 ef 01             	sub    $0x1,%edi
  800b48:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b4b:	fd                   	std    
  800b4c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b4e:	fc                   	cld    
  800b4f:	eb 21                	jmp    800b72 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b51:	f6 c1 03             	test   $0x3,%cl
  800b54:	75 ef                	jne    800b45 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b56:	83 ef 04             	sub    $0x4,%edi
  800b59:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b5c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b5f:	fd                   	std    
  800b60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b62:	eb ea                	jmp    800b4e <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b64:	89 f2                	mov    %esi,%edx
  800b66:	09 c2                	or     %eax,%edx
  800b68:	f6 c2 03             	test   $0x3,%dl
  800b6b:	74 09                	je     800b76 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b6d:	89 c7                	mov    %eax,%edi
  800b6f:	fc                   	cld    
  800b70:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b72:	5e                   	pop    %esi
  800b73:	5f                   	pop    %edi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b76:	f6 c1 03             	test   $0x3,%cl
  800b79:	75 f2                	jne    800b6d <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b7e:	89 c7                	mov    %eax,%edi
  800b80:	fc                   	cld    
  800b81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b83:	eb ed                	jmp    800b72 <memmove+0x55>

00800b85 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b88:	ff 75 10             	pushl  0x10(%ebp)
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 87 ff ff ff       	call   800b1d <memmove>
}
  800b96:	c9                   	leave  
  800b97:	c3                   	ret    

00800b98 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba3:	89 c6                	mov    %eax,%esi
  800ba5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba8:	39 f0                	cmp    %esi,%eax
  800baa:	74 1c                	je     800bc8 <memcmp+0x30>
		if (*s1 != *s2)
  800bac:	0f b6 08             	movzbl (%eax),%ecx
  800baf:	0f b6 1a             	movzbl (%edx),%ebx
  800bb2:	38 d9                	cmp    %bl,%cl
  800bb4:	75 08                	jne    800bbe <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb6:	83 c0 01             	add    $0x1,%eax
  800bb9:	83 c2 01             	add    $0x1,%edx
  800bbc:	eb ea                	jmp    800ba8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bbe:	0f b6 c1             	movzbl %cl,%eax
  800bc1:	0f b6 db             	movzbl %bl,%ebx
  800bc4:	29 d8                	sub    %ebx,%eax
  800bc6:	eb 05                	jmp    800bcd <memcmp+0x35>
	}

	return 0;
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bda:	89 c2                	mov    %eax,%edx
  800bdc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bdf:	39 d0                	cmp    %edx,%eax
  800be1:	73 09                	jae    800bec <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be3:	38 08                	cmp    %cl,(%eax)
  800be5:	74 05                	je     800bec <memfind+0x1b>
	for (; s < ends; s++)
  800be7:	83 c0 01             	add    $0x1,%eax
  800bea:	eb f3                	jmp    800bdf <memfind+0xe>
			break;
	return (void *) s;
}
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	57                   	push   %edi
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
  800bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfa:	eb 03                	jmp    800bff <strtol+0x11>
		s++;
  800bfc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bff:	0f b6 01             	movzbl (%ecx),%eax
  800c02:	3c 20                	cmp    $0x20,%al
  800c04:	74 f6                	je     800bfc <strtol+0xe>
  800c06:	3c 09                	cmp    $0x9,%al
  800c08:	74 f2                	je     800bfc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c0a:	3c 2b                	cmp    $0x2b,%al
  800c0c:	74 2e                	je     800c3c <strtol+0x4e>
	int neg = 0;
  800c0e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c13:	3c 2d                	cmp    $0x2d,%al
  800c15:	74 2f                	je     800c46 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c17:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c1d:	75 05                	jne    800c24 <strtol+0x36>
  800c1f:	80 39 30             	cmpb   $0x30,(%ecx)
  800c22:	74 2c                	je     800c50 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c24:	85 db                	test   %ebx,%ebx
  800c26:	75 0a                	jne    800c32 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c28:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c2d:	80 39 30             	cmpb   $0x30,(%ecx)
  800c30:	74 28                	je     800c5a <strtol+0x6c>
		base = 10;
  800c32:	b8 00 00 00 00       	mov    $0x0,%eax
  800c37:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c3a:	eb 50                	jmp    800c8c <strtol+0x9e>
		s++;
  800c3c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c44:	eb d1                	jmp    800c17 <strtol+0x29>
		s++, neg = 1;
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	bf 01 00 00 00       	mov    $0x1,%edi
  800c4e:	eb c7                	jmp    800c17 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c50:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c54:	74 0e                	je     800c64 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c56:	85 db                	test   %ebx,%ebx
  800c58:	75 d8                	jne    800c32 <strtol+0x44>
		s++, base = 8;
  800c5a:	83 c1 01             	add    $0x1,%ecx
  800c5d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c62:	eb ce                	jmp    800c32 <strtol+0x44>
		s += 2, base = 16;
  800c64:	83 c1 02             	add    $0x2,%ecx
  800c67:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c6c:	eb c4                	jmp    800c32 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c6e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	80 fb 19             	cmp    $0x19,%bl
  800c76:	77 29                	ja     800ca1 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c78:	0f be d2             	movsbl %dl,%edx
  800c7b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c7e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c81:	7d 30                	jge    800cb3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c83:	83 c1 01             	add    $0x1,%ecx
  800c86:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c8a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c8c:	0f b6 11             	movzbl (%ecx),%edx
  800c8f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c92:	89 f3                	mov    %esi,%ebx
  800c94:	80 fb 09             	cmp    $0x9,%bl
  800c97:	77 d5                	ja     800c6e <strtol+0x80>
			dig = *s - '0';
  800c99:	0f be d2             	movsbl %dl,%edx
  800c9c:	83 ea 30             	sub    $0x30,%edx
  800c9f:	eb dd                	jmp    800c7e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ca1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca4:	89 f3                	mov    %esi,%ebx
  800ca6:	80 fb 19             	cmp    $0x19,%bl
  800ca9:	77 08                	ja     800cb3 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800cab:	0f be d2             	movsbl %dl,%edx
  800cae:	83 ea 37             	sub    $0x37,%edx
  800cb1:	eb cb                	jmp    800c7e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb7:	74 05                	je     800cbe <strtol+0xd0>
		*endptr = (char *) s;
  800cb9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cbc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cbe:	89 c2                	mov    %eax,%edx
  800cc0:	f7 da                	neg    %edx
  800cc2:	85 ff                	test   %edi,%edi
  800cc4:	0f 45 c2             	cmovne %edx,%eax
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	89 c3                	mov    %eax,%ebx
  800cdf:	89 c7                	mov    %eax,%edi
  800ce1:	89 c6                	mov    %eax,%esi
  800ce3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_cgetc>:

int
sys_cgetc(void)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cfa:	89 d1                	mov    %edx,%ecx
  800cfc:	89 d3                	mov    %edx,%ebx
  800cfe:	89 d7                	mov    %edx,%edi
  800d00:	89 d6                	mov    %edx,%esi
  800d02:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
  800d0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d17:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1f:	89 cb                	mov    %ecx,%ebx
  800d21:	89 cf                	mov    %ecx,%edi
  800d23:	89 ce                	mov    %ecx,%esi
  800d25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	7f 08                	jg     800d33 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	50                   	push   %eax
  800d37:	6a 03                	push   $0x3
  800d39:	68 3f 2b 80 00       	push   $0x802b3f
  800d3e:	6a 23                	push   $0x23
  800d40:	68 5c 2b 80 00       	push   $0x802b5c
  800d45:	e8 4b f5 ff ff       	call   800295 <_panic>

00800d4a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_yield>:

void
sys_yield(void)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d74:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d79:	89 d1                	mov    %edx,%ecx
  800d7b:	89 d3                	mov    %edx,%ebx
  800d7d:	89 d7                	mov    %edx,%edi
  800d7f:	89 d6                	mov    %edx,%esi
  800d81:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d91:	be 00 00 00 00       	mov    $0x0,%esi
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	b8 04 00 00 00       	mov    $0x4,%eax
  800da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da4:	89 f7                	mov    %esi,%edi
  800da6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da8:	85 c0                	test   %eax,%eax
  800daa:	7f 08                	jg     800db4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db4:	83 ec 0c             	sub    $0xc,%esp
  800db7:	50                   	push   %eax
  800db8:	6a 04                	push   $0x4
  800dba:	68 3f 2b 80 00       	push   $0x802b3f
  800dbf:	6a 23                	push   $0x23
  800dc1:	68 5c 2b 80 00       	push   $0x802b5c
  800dc6:	e8 ca f4 ff ff       	call   800295 <_panic>

00800dcb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dda:	b8 05 00 00 00       	mov    $0x5,%eax
  800ddf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de5:	8b 75 18             	mov    0x18(%ebp),%esi
  800de8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dea:	85 c0                	test   %eax,%eax
  800dec:	7f 08                	jg     800df6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	50                   	push   %eax
  800dfa:	6a 05                	push   $0x5
  800dfc:	68 3f 2b 80 00       	push   $0x802b3f
  800e01:	6a 23                	push   $0x23
  800e03:	68 5c 2b 80 00       	push   $0x802b5c
  800e08:	e8 88 f4 ff ff       	call   800295 <_panic>

00800e0d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 06 00 00 00       	mov    $0x6,%eax
  800e26:	89 df                	mov    %ebx,%edi
  800e28:	89 de                	mov    %ebx,%esi
  800e2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7f 08                	jg     800e38 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	50                   	push   %eax
  800e3c:	6a 06                	push   $0x6
  800e3e:	68 3f 2b 80 00       	push   $0x802b3f
  800e43:	6a 23                	push   $0x23
  800e45:	68 5c 2b 80 00       	push   $0x802b5c
  800e4a:	e8 46 f4 ff ff       	call   800295 <_panic>

00800e4f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	b8 08 00 00 00       	mov    $0x8,%eax
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 08                	push   $0x8
  800e80:	68 3f 2b 80 00       	push   $0x802b3f
  800e85:	6a 23                	push   $0x23
  800e87:	68 5c 2b 80 00       	push   $0x802b5c
  800e8c:	e8 04 f4 ff ff       	call   800295 <_panic>

00800e91 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	b8 09 00 00 00       	mov    $0x9,%eax
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	89 de                	mov    %ebx,%esi
  800eae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	7f 08                	jg     800ebc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	83 ec 0c             	sub    $0xc,%esp
  800ebf:	50                   	push   %eax
  800ec0:	6a 09                	push   $0x9
  800ec2:	68 3f 2b 80 00       	push   $0x802b3f
  800ec7:	6a 23                	push   $0x23
  800ec9:	68 5c 2b 80 00       	push   $0x802b5c
  800ece:	e8 c2 f3 ff ff       	call   800295 <_panic>

00800ed3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eec:	89 df                	mov    %ebx,%edi
  800eee:	89 de                	mov    %ebx,%esi
  800ef0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7f 08                	jg     800efe <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	6a 0a                	push   $0xa
  800f04:	68 3f 2b 80 00       	push   $0x802b3f
  800f09:	6a 23                	push   $0x23
  800f0b:	68 5c 2b 80 00       	push   $0x802b5c
  800f10:	e8 80 f3 ff ff       	call   800295 <_panic>

00800f15 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f26:	be 00 00 00 00       	mov    $0x0,%esi
  800f2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f31:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4e:	89 cb                	mov    %ecx,%ebx
  800f50:	89 cf                	mov    %ecx,%edi
  800f52:	89 ce                	mov    %ecx,%esi
  800f54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	7f 08                	jg     800f62 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	50                   	push   %eax
  800f66:	6a 0d                	push   $0xd
  800f68:	68 3f 2b 80 00       	push   $0x802b3f
  800f6d:	6a 23                	push   $0x23
  800f6f:	68 5c 2b 80 00       	push   $0x802b5c
  800f74:	e8 1c f3 ff ff       	call   800295 <_panic>

00800f79 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f84:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f89:	89 d1                	mov    %edx,%ecx
  800f8b:	89 d3                	mov    %edx,%ebx
  800f8d:	89 d7                	mov    %edx,%edi
  800f8f:	89 d6                	mov    %edx,%esi
  800f91:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800fa0:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800fa2:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fa6:	74 7f                	je     801027 <pgfault+0x8f>
  800fa8:	89 d8                	mov    %ebx,%eax
  800faa:	c1 e8 0c             	shr    $0xc,%eax
  800fad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb4:	f6 c4 08             	test   $0x8,%ah
  800fb7:	74 6e                	je     801027 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800fb9:	e8 8c fd ff ff       	call   800d4a <sys_getenvid>
  800fbe:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800fc0:	83 ec 04             	sub    $0x4,%esp
  800fc3:	6a 07                	push   $0x7
  800fc5:	68 00 f0 7f 00       	push   $0x7ff000
  800fca:	50                   	push   %eax
  800fcb:	e8 b8 fd ff ff       	call   800d88 <sys_page_alloc>
  800fd0:	83 c4 10             	add    $0x10,%esp
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	78 64                	js     80103b <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800fd7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800fdd:	83 ec 04             	sub    $0x4,%esp
  800fe0:	68 00 10 00 00       	push   $0x1000
  800fe5:	53                   	push   %ebx
  800fe6:	68 00 f0 7f 00       	push   $0x7ff000
  800feb:	e8 2d fb ff ff       	call   800b1d <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800ff0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ff7:	53                   	push   %ebx
  800ff8:	56                   	push   %esi
  800ff9:	68 00 f0 7f 00       	push   $0x7ff000
  800ffe:	56                   	push   %esi
  800fff:	e8 c7 fd ff ff       	call   800dcb <sys_page_map>
  801004:	83 c4 20             	add    $0x20,%esp
  801007:	85 c0                	test   %eax,%eax
  801009:	78 42                	js     80104d <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  80100b:	83 ec 08             	sub    $0x8,%esp
  80100e:	68 00 f0 7f 00       	push   $0x7ff000
  801013:	56                   	push   %esi
  801014:	e8 f4 fd ff ff       	call   800e0d <sys_page_unmap>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	78 3f                	js     80105f <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  801020:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  801027:	83 ec 04             	sub    $0x4,%esp
  80102a:	68 6c 2b 80 00       	push   $0x802b6c
  80102f:	6a 1d                	push   $0x1d
  801031:	68 fb 2b 80 00       	push   $0x802bfb
  801036:	e8 5a f2 ff ff       	call   800295 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  80103b:	50                   	push   %eax
  80103c:	68 94 2b 80 00       	push   $0x802b94
  801041:	6a 28                	push   $0x28
  801043:	68 fb 2b 80 00       	push   $0x802bfb
  801048:	e8 48 f2 ff ff       	call   800295 <_panic>
		panic("pgfault:page map failed: %e", r);
  80104d:	50                   	push   %eax
  80104e:	68 06 2c 80 00       	push   $0x802c06
  801053:	6a 2c                	push   $0x2c
  801055:	68 fb 2b 80 00       	push   $0x802bfb
  80105a:	e8 36 f2 ff ff       	call   800295 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  80105f:	50                   	push   %eax
  801060:	68 b8 2b 80 00       	push   $0x802bb8
  801065:	6a 2e                	push   $0x2e
  801067:	68 fb 2b 80 00       	push   $0x802bfb
  80106c:	e8 24 f2 ff ff       	call   800295 <_panic>

00801071 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	57                   	push   %edi
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
  801077:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  80107a:	68 98 0f 80 00       	push   $0x800f98
  80107f:	e8 d2 12 00 00       	call   802356 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801084:	b8 07 00 00 00       	mov    $0x7,%eax
  801089:	cd 30                	int    $0x30
  80108b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  80108e:	83 c4 10             	add    $0x10,%esp
  801091:	85 c0                	test   %eax,%eax
  801093:	78 2f                	js     8010c4 <fork+0x53>
  801095:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801097:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  80109c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a0:	75 6e                	jne    801110 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010a2:	e8 a3 fc ff ff       	call   800d4a <sys_getenvid>
  8010a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010b4:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8010b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  8010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  8010c4:	50                   	push   %eax
  8010c5:	68 d8 2b 80 00       	push   $0x802bd8
  8010ca:	6a 6e                	push   $0x6e
  8010cc:	68 fb 2b 80 00       	push   $0x802bfb
  8010d1:	e8 bf f1 ff ff       	call   800295 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8010d6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010dd:	83 ec 0c             	sub    $0xc,%esp
  8010e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8010e5:	50                   	push   %eax
  8010e6:	56                   	push   %esi
  8010e7:	57                   	push   %edi
  8010e8:	56                   	push   %esi
  8010e9:	6a 00                	push   $0x0
  8010eb:	e8 db fc ff ff       	call   800dcb <sys_page_map>
  8010f0:	83 c4 20             	add    $0x20,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fa:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	78 bb                	js     8010bc <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801101:	83 c3 01             	add    $0x1,%ebx
  801104:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80110a:	0f 84 a6 00 00 00    	je     8011b6 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  801110:	89 d8                	mov    %ebx,%eax
  801112:	c1 e8 0a             	shr    $0xa,%eax
  801115:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80111c:	a8 01                	test   $0x1,%al
  80111e:	74 e1                	je     801101 <fork+0x90>
  801120:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801127:	a8 01                	test   $0x1,%al
  801129:	74 d6                	je     801101 <fork+0x90>
  80112b:	89 de                	mov    %ebx,%esi
  80112d:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  801130:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801137:	f6 c4 04             	test   $0x4,%ah
  80113a:	75 9a                	jne    8010d6 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  80113c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801143:	a8 02                	test   $0x2,%al
  801145:	75 0c                	jne    801153 <fork+0xe2>
  801147:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80114e:	f6 c4 08             	test   $0x8,%ah
  801151:	74 42                	je     801195 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	68 05 08 00 00       	push   $0x805
  80115b:	56                   	push   %esi
  80115c:	57                   	push   %edi
  80115d:	56                   	push   %esi
  80115e:	6a 00                	push   $0x0
  801160:	e8 66 fc ff ff       	call   800dcb <sys_page_map>
  801165:	83 c4 20             	add    $0x20,%esp
  801168:	85 c0                	test   %eax,%eax
  80116a:	0f 88 4c ff ff ff    	js     8010bc <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	68 05 08 00 00       	push   $0x805
  801178:	56                   	push   %esi
  801179:	6a 00                	push   $0x0
  80117b:	56                   	push   %esi
  80117c:	6a 00                	push   $0x0
  80117e:	e8 48 fc ff ff       	call   800dcb <sys_page_map>
  801183:	83 c4 20             	add    $0x20,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	b9 00 00 00 00       	mov    $0x0,%ecx
  80118d:	0f 4f c1             	cmovg  %ecx,%eax
  801190:	e9 68 ff ff ff       	jmp    8010fd <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	6a 05                	push   $0x5
  80119a:	56                   	push   %esi
  80119b:	57                   	push   %edi
  80119c:	56                   	push   %esi
  80119d:	6a 00                	push   $0x0
  80119f:	e8 27 fc ff ff       	call   800dcb <sys_page_map>
  8011a4:	83 c4 20             	add    $0x20,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011ae:	0f 4f c1             	cmovg  %ecx,%eax
  8011b1:	e9 47 ff ff ff       	jmp    8010fd <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8011b6:	83 ec 04             	sub    $0x4,%esp
  8011b9:	6a 07                	push   $0x7
  8011bb:	68 00 f0 bf ee       	push   $0xeebff000
  8011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8011c3:	57                   	push   %edi
  8011c4:	e8 bf fb ff ff       	call   800d88 <sys_page_alloc>
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	0f 88 e8 fe ff ff    	js     8010bc <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	68 bb 23 80 00       	push   $0x8023bb
  8011dc:	57                   	push   %edi
  8011dd:	e8 f1 fc ff ff       	call   800ed3 <sys_env_set_pgfault_upcall>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	0f 88 cf fe ff ff    	js     8010bc <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  8011ed:	83 ec 08             	sub    $0x8,%esp
  8011f0:	6a 02                	push   $0x2
  8011f2:	57                   	push   %edi
  8011f3:	e8 57 fc ff ff       	call   800e4f <sys_env_set_status>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	78 08                	js     801207 <fork+0x196>
	return eid;
  8011ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801202:	e9 b5 fe ff ff       	jmp    8010bc <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  801207:	50                   	push   %eax
  801208:	68 22 2c 80 00       	push   $0x802c22
  80120d:	68 87 00 00 00       	push   $0x87
  801212:	68 fb 2b 80 00       	push   $0x802bfb
  801217:	e8 79 f0 ff ff       	call   800295 <_panic>

0080121c <sfork>:

// Challenge!
int sfork(void)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801222:	68 40 2c 80 00       	push   $0x802c40
  801227:	68 8f 00 00 00       	push   $0x8f
  80122c:	68 fb 2b 80 00       	push   $0x802bfb
  801231:	e8 5f f0 ff ff       	call   800295 <_panic>

00801236 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	05 00 00 00 30       	add    $0x30000000,%eax
  801241:	c1 e8 0c             	shr    $0xc,%eax
}
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    

00801246 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801251:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801256:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    

0080125d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801263:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801268:	89 c2                	mov    %eax,%edx
  80126a:	c1 ea 16             	shr    $0x16,%edx
  80126d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801274:	f6 c2 01             	test   $0x1,%dl
  801277:	74 2a                	je     8012a3 <fd_alloc+0x46>
  801279:	89 c2                	mov    %eax,%edx
  80127b:	c1 ea 0c             	shr    $0xc,%edx
  80127e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801285:	f6 c2 01             	test   $0x1,%dl
  801288:	74 19                	je     8012a3 <fd_alloc+0x46>
  80128a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80128f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801294:	75 d2                	jne    801268 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801296:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80129c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012a1:	eb 07                	jmp    8012aa <fd_alloc+0x4d>
			*fd_store = fd;
  8012a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012b2:	83 f8 1f             	cmp    $0x1f,%eax
  8012b5:	77 36                	ja     8012ed <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012b7:	c1 e0 0c             	shl    $0xc,%eax
  8012ba:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	c1 ea 16             	shr    $0x16,%edx
  8012c4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cb:	f6 c2 01             	test   $0x1,%dl
  8012ce:	74 24                	je     8012f4 <fd_lookup+0x48>
  8012d0:	89 c2                	mov    %eax,%edx
  8012d2:	c1 ea 0c             	shr    $0xc,%edx
  8012d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012dc:	f6 c2 01             	test   $0x1,%dl
  8012df:	74 1a                	je     8012fb <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e4:	89 02                	mov    %eax,(%edx)
	return 0;
  8012e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    
		return -E_INVAL;
  8012ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f2:	eb f7                	jmp    8012eb <fd_lookup+0x3f>
		return -E_INVAL;
  8012f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f9:	eb f0                	jmp    8012eb <fd_lookup+0x3f>
  8012fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801300:	eb e9                	jmp    8012eb <fd_lookup+0x3f>

00801302 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130b:	ba d8 2c 80 00       	mov    $0x802cd8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801310:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801315:	39 08                	cmp    %ecx,(%eax)
  801317:	74 33                	je     80134c <dev_lookup+0x4a>
  801319:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80131c:	8b 02                	mov    (%edx),%eax
  80131e:	85 c0                	test   %eax,%eax
  801320:	75 f3                	jne    801315 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801322:	a1 08 40 80 00       	mov    0x804008,%eax
  801327:	8b 40 48             	mov    0x48(%eax),%eax
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	51                   	push   %ecx
  80132e:	50                   	push   %eax
  80132f:	68 58 2c 80 00       	push   $0x802c58
  801334:	e8 37 f0 ff ff       	call   800370 <cprintf>
	*dev = 0;
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    
			*dev = devtab[i];
  80134c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
  801356:	eb f2                	jmp    80134a <dev_lookup+0x48>

00801358 <fd_close>:
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	57                   	push   %edi
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	83 ec 1c             	sub    $0x1c,%esp
  801361:	8b 75 08             	mov    0x8(%ebp),%esi
  801364:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801367:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80136a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80136b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801371:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801374:	50                   	push   %eax
  801375:	e8 32 ff ff ff       	call   8012ac <fd_lookup>
  80137a:	89 c3                	mov    %eax,%ebx
  80137c:	83 c4 08             	add    $0x8,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 05                	js     801388 <fd_close+0x30>
	    || fd != fd2)
  801383:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801386:	74 16                	je     80139e <fd_close+0x46>
		return (must_exist ? r : 0);
  801388:	89 f8                	mov    %edi,%eax
  80138a:	84 c0                	test   %al,%al
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
  801391:	0f 44 d8             	cmove  %eax,%ebx
}
  801394:	89 d8                	mov    %ebx,%eax
  801396:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801399:	5b                   	pop    %ebx
  80139a:	5e                   	pop    %esi
  80139b:	5f                   	pop    %edi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	ff 36                	pushl  (%esi)
  8013a7:	e8 56 ff ff ff       	call   801302 <dev_lookup>
  8013ac:	89 c3                	mov    %eax,%ebx
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 15                	js     8013ca <fd_close+0x72>
		if (dev->dev_close)
  8013b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b8:	8b 40 10             	mov    0x10(%eax),%eax
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	74 1b                	je     8013da <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8013bf:	83 ec 0c             	sub    $0xc,%esp
  8013c2:	56                   	push   %esi
  8013c3:	ff d0                	call   *%eax
  8013c5:	89 c3                	mov    %eax,%ebx
  8013c7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	56                   	push   %esi
  8013ce:	6a 00                	push   $0x0
  8013d0:	e8 38 fa ff ff       	call   800e0d <sys_page_unmap>
	return r;
  8013d5:	83 c4 10             	add    $0x10,%esp
  8013d8:	eb ba                	jmp    801394 <fd_close+0x3c>
			r = 0;
  8013da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013df:	eb e9                	jmp    8013ca <fd_close+0x72>

008013e1 <close>:

int
close(int fdnum)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ea:	50                   	push   %eax
  8013eb:	ff 75 08             	pushl  0x8(%ebp)
  8013ee:	e8 b9 fe ff ff       	call   8012ac <fd_lookup>
  8013f3:	83 c4 08             	add    $0x8,%esp
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 10                	js     80140a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013fa:	83 ec 08             	sub    $0x8,%esp
  8013fd:	6a 01                	push   $0x1
  8013ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801402:	e8 51 ff ff ff       	call   801358 <fd_close>
  801407:	83 c4 10             	add    $0x10,%esp
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <close_all>:

void
close_all(void)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	53                   	push   %ebx
  801410:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801413:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801418:	83 ec 0c             	sub    $0xc,%esp
  80141b:	53                   	push   %ebx
  80141c:	e8 c0 ff ff ff       	call   8013e1 <close>
	for (i = 0; i < MAXFD; i++)
  801421:	83 c3 01             	add    $0x1,%ebx
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	83 fb 20             	cmp    $0x20,%ebx
  80142a:	75 ec                	jne    801418 <close_all+0xc>
}
  80142c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	57                   	push   %edi
  801435:	56                   	push   %esi
  801436:	53                   	push   %ebx
  801437:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80143a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	ff 75 08             	pushl  0x8(%ebp)
  801441:	e8 66 fe ff ff       	call   8012ac <fd_lookup>
  801446:	89 c3                	mov    %eax,%ebx
  801448:	83 c4 08             	add    $0x8,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	0f 88 81 00 00 00    	js     8014d4 <dup+0xa3>
		return r;
	close(newfdnum);
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	ff 75 0c             	pushl  0xc(%ebp)
  801459:	e8 83 ff ff ff       	call   8013e1 <close>

	newfd = INDEX2FD(newfdnum);
  80145e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801461:	c1 e6 0c             	shl    $0xc,%esi
  801464:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80146a:	83 c4 04             	add    $0x4,%esp
  80146d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801470:	e8 d1 fd ff ff       	call   801246 <fd2data>
  801475:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801477:	89 34 24             	mov    %esi,(%esp)
  80147a:	e8 c7 fd ff ff       	call   801246 <fd2data>
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801484:	89 d8                	mov    %ebx,%eax
  801486:	c1 e8 16             	shr    $0x16,%eax
  801489:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801490:	a8 01                	test   $0x1,%al
  801492:	74 11                	je     8014a5 <dup+0x74>
  801494:	89 d8                	mov    %ebx,%eax
  801496:	c1 e8 0c             	shr    $0xc,%eax
  801499:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014a0:	f6 c2 01             	test   $0x1,%dl
  8014a3:	75 39                	jne    8014de <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a8:	89 d0                	mov    %edx,%eax
  8014aa:	c1 e8 0c             	shr    $0xc,%eax
  8014ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014b4:	83 ec 0c             	sub    $0xc,%esp
  8014b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8014bc:	50                   	push   %eax
  8014bd:	56                   	push   %esi
  8014be:	6a 00                	push   $0x0
  8014c0:	52                   	push   %edx
  8014c1:	6a 00                	push   $0x0
  8014c3:	e8 03 f9 ff ff       	call   800dcb <sys_page_map>
  8014c8:	89 c3                	mov    %eax,%ebx
  8014ca:	83 c4 20             	add    $0x20,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 31                	js     801502 <dup+0xd1>
		goto err;

	return newfdnum;
  8014d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014d4:	89 d8                	mov    %ebx,%eax
  8014d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5e                   	pop    %esi
  8014db:	5f                   	pop    %edi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ed:	50                   	push   %eax
  8014ee:	57                   	push   %edi
  8014ef:	6a 00                	push   $0x0
  8014f1:	53                   	push   %ebx
  8014f2:	6a 00                	push   $0x0
  8014f4:	e8 d2 f8 ff ff       	call   800dcb <sys_page_map>
  8014f9:	89 c3                	mov    %eax,%ebx
  8014fb:	83 c4 20             	add    $0x20,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	79 a3                	jns    8014a5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801502:	83 ec 08             	sub    $0x8,%esp
  801505:	56                   	push   %esi
  801506:	6a 00                	push   $0x0
  801508:	e8 00 f9 ff ff       	call   800e0d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80150d:	83 c4 08             	add    $0x8,%esp
  801510:	57                   	push   %edi
  801511:	6a 00                	push   $0x0
  801513:	e8 f5 f8 ff ff       	call   800e0d <sys_page_unmap>
	return r;
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	eb b7                	jmp    8014d4 <dup+0xa3>

0080151d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	53                   	push   %ebx
  801521:	83 ec 14             	sub    $0x14,%esp
  801524:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801527:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	53                   	push   %ebx
  80152c:	e8 7b fd ff ff       	call   8012ac <fd_lookup>
  801531:	83 c4 08             	add    $0x8,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 3f                	js     801577 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153e:	50                   	push   %eax
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	ff 30                	pushl  (%eax)
  801544:	e8 b9 fd ff ff       	call   801302 <dev_lookup>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 27                	js     801577 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801553:	8b 42 08             	mov    0x8(%edx),%eax
  801556:	83 e0 03             	and    $0x3,%eax
  801559:	83 f8 01             	cmp    $0x1,%eax
  80155c:	74 1e                	je     80157c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80155e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801561:	8b 40 08             	mov    0x8(%eax),%eax
  801564:	85 c0                	test   %eax,%eax
  801566:	74 35                	je     80159d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	ff 75 10             	pushl  0x10(%ebp)
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	52                   	push   %edx
  801572:	ff d0                	call   *%eax
  801574:	83 c4 10             	add    $0x10,%esp
}
  801577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80157c:	a1 08 40 80 00       	mov    0x804008,%eax
  801581:	8b 40 48             	mov    0x48(%eax),%eax
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	53                   	push   %ebx
  801588:	50                   	push   %eax
  801589:	68 9c 2c 80 00       	push   $0x802c9c
  80158e:	e8 dd ed ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159b:	eb da                	jmp    801577 <read+0x5a>
		return -E_NOT_SUPP;
  80159d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a2:	eb d3                	jmp    801577 <read+0x5a>

008015a4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	57                   	push   %edi
  8015a8:	56                   	push   %esi
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b8:	39 f3                	cmp    %esi,%ebx
  8015ba:	73 25                	jae    8015e1 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	89 f0                	mov    %esi,%eax
  8015c1:	29 d8                	sub    %ebx,%eax
  8015c3:	50                   	push   %eax
  8015c4:	89 d8                	mov    %ebx,%eax
  8015c6:	03 45 0c             	add    0xc(%ebp),%eax
  8015c9:	50                   	push   %eax
  8015ca:	57                   	push   %edi
  8015cb:	e8 4d ff ff ff       	call   80151d <read>
		if (m < 0)
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	78 08                	js     8015df <readn+0x3b>
			return m;
		if (m == 0)
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	74 06                	je     8015e1 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015db:	01 c3                	add    %eax,%ebx
  8015dd:	eb d9                	jmp    8015b8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015df:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015e1:	89 d8                	mov    %ebx,%eax
  8015e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5f                   	pop    %edi
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    

008015eb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 14             	sub    $0x14,%esp
  8015f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f8:	50                   	push   %eax
  8015f9:	53                   	push   %ebx
  8015fa:	e8 ad fc ff ff       	call   8012ac <fd_lookup>
  8015ff:	83 c4 08             	add    $0x8,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	78 3a                	js     801640 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160c:	50                   	push   %eax
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	ff 30                	pushl  (%eax)
  801612:	e8 eb fc ff ff       	call   801302 <dev_lookup>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	85 c0                	test   %eax,%eax
  80161c:	78 22                	js     801640 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801625:	74 1e                	je     801645 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162a:	8b 52 0c             	mov    0xc(%edx),%edx
  80162d:	85 d2                	test   %edx,%edx
  80162f:	74 35                	je     801666 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	ff 75 10             	pushl  0x10(%ebp)
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	50                   	push   %eax
  80163b:	ff d2                	call   *%edx
  80163d:	83 c4 10             	add    $0x10,%esp
}
  801640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801643:	c9                   	leave  
  801644:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801645:	a1 08 40 80 00       	mov    0x804008,%eax
  80164a:	8b 40 48             	mov    0x48(%eax),%eax
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	53                   	push   %ebx
  801651:	50                   	push   %eax
  801652:	68 b8 2c 80 00       	push   $0x802cb8
  801657:	e8 14 ed ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801664:	eb da                	jmp    801640 <write+0x55>
		return -E_NOT_SUPP;
  801666:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166b:	eb d3                	jmp    801640 <write+0x55>

0080166d <seek>:

int
seek(int fdnum, off_t offset)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801673:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	ff 75 08             	pushl  0x8(%ebp)
  80167a:	e8 2d fc ff ff       	call   8012ac <fd_lookup>
  80167f:	83 c4 08             	add    $0x8,%esp
  801682:	85 c0                	test   %eax,%eax
  801684:	78 0e                	js     801694 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	53                   	push   %ebx
  80169a:	83 ec 14             	sub    $0x14,%esp
  80169d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a3:	50                   	push   %eax
  8016a4:	53                   	push   %ebx
  8016a5:	e8 02 fc ff ff       	call   8012ac <fd_lookup>
  8016aa:	83 c4 08             	add    $0x8,%esp
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	78 37                	js     8016e8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b1:	83 ec 08             	sub    $0x8,%esp
  8016b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b7:	50                   	push   %eax
  8016b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bb:	ff 30                	pushl  (%eax)
  8016bd:	e8 40 fc ff ff       	call   801302 <dev_lookup>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 1f                	js     8016e8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016d0:	74 1b                	je     8016ed <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d5:	8b 52 18             	mov    0x18(%edx),%edx
  8016d8:	85 d2                	test   %edx,%edx
  8016da:	74 32                	je     80170e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	ff 75 0c             	pushl  0xc(%ebp)
  8016e2:	50                   	push   %eax
  8016e3:	ff d2                	call   *%edx
  8016e5:	83 c4 10             	add    $0x10,%esp
}
  8016e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016ed:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016f2:	8b 40 48             	mov    0x48(%eax),%eax
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	53                   	push   %ebx
  8016f9:	50                   	push   %eax
  8016fa:	68 78 2c 80 00       	push   $0x802c78
  8016ff:	e8 6c ec ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170c:	eb da                	jmp    8016e8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80170e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801713:	eb d3                	jmp    8016e8 <ftruncate+0x52>

00801715 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	53                   	push   %ebx
  801719:	83 ec 14             	sub    $0x14,%esp
  80171c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801722:	50                   	push   %eax
  801723:	ff 75 08             	pushl  0x8(%ebp)
  801726:	e8 81 fb ff ff       	call   8012ac <fd_lookup>
  80172b:	83 c4 08             	add    $0x8,%esp
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 4b                	js     80177d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173c:	ff 30                	pushl  (%eax)
  80173e:	e8 bf fb ff ff       	call   801302 <dev_lookup>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	78 33                	js     80177d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801751:	74 2f                	je     801782 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801753:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801756:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80175d:	00 00 00 
	stat->st_isdir = 0;
  801760:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801767:	00 00 00 
	stat->st_dev = dev;
  80176a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	53                   	push   %ebx
  801774:	ff 75 f0             	pushl  -0x10(%ebp)
  801777:	ff 50 14             	call   *0x14(%eax)
  80177a:	83 c4 10             	add    $0x10,%esp
}
  80177d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801780:	c9                   	leave  
  801781:	c3                   	ret    
		return -E_NOT_SUPP;
  801782:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801787:	eb f4                	jmp    80177d <fstat+0x68>

00801789 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	6a 00                	push   $0x0
  801793:	ff 75 08             	pushl  0x8(%ebp)
  801796:	e8 e7 01 00 00       	call   801982 <open>
  80179b:	89 c3                	mov    %eax,%ebx
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 1b                	js     8017bf <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	50                   	push   %eax
  8017ab:	e8 65 ff ff ff       	call   801715 <fstat>
  8017b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b2:	89 1c 24             	mov    %ebx,(%esp)
  8017b5:	e8 27 fc ff ff       	call   8013e1 <close>
	return r;
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	89 f3                	mov    %esi,%ebx
}
  8017bf:	89 d8                	mov    %ebx,%eax
  8017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    

008017c8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	56                   	push   %esi
  8017cc:	53                   	push   %ebx
  8017cd:	89 c6                	mov    %eax,%esi
  8017cf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017d1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017d8:	74 27                	je     801801 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017da:	6a 07                	push   $0x7
  8017dc:	68 00 50 80 00       	push   $0x805000
  8017e1:	56                   	push   %esi
  8017e2:	ff 35 00 40 80 00    	pushl  0x804000
  8017e8:	e8 5b 0c 00 00       	call   802448 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ed:	83 c4 0c             	add    $0xc,%esp
  8017f0:	6a 00                	push   $0x0
  8017f2:	53                   	push   %ebx
  8017f3:	6a 00                	push   $0x0
  8017f5:	e8 e7 0b 00 00       	call   8023e1 <ipc_recv>
}
  8017fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5e                   	pop    %esi
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	6a 01                	push   $0x1
  801806:	e8 91 0c 00 00       	call   80249c <ipc_find_env>
  80180b:	a3 00 40 80 00       	mov    %eax,0x804000
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	eb c5                	jmp    8017da <fsipc+0x12>

00801815 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8b 40 0c             	mov    0xc(%eax),%eax
  801821:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
  801833:	b8 02 00 00 00       	mov    $0x2,%eax
  801838:	e8 8b ff ff ff       	call   8017c8 <fsipc>
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <devfile_flush>:
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	8b 40 0c             	mov    0xc(%eax),%eax
  80184b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801850:	ba 00 00 00 00       	mov    $0x0,%edx
  801855:	b8 06 00 00 00       	mov    $0x6,%eax
  80185a:	e8 69 ff ff ff       	call   8017c8 <fsipc>
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <devfile_stat>:
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	53                   	push   %ebx
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	8b 40 0c             	mov    0xc(%eax),%eax
  801871:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801876:	ba 00 00 00 00       	mov    $0x0,%edx
  80187b:	b8 05 00 00 00       	mov    $0x5,%eax
  801880:	e8 43 ff ff ff       	call   8017c8 <fsipc>
  801885:	85 c0                	test   %eax,%eax
  801887:	78 2c                	js     8018b5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	68 00 50 80 00       	push   $0x805000
  801891:	53                   	push   %ebx
  801892:	e8 f8 f0 ff ff       	call   80098f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801897:	a1 80 50 80 00       	mov    0x805080,%eax
  80189c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018a2:	a1 84 50 80 00       	mov    0x805084,%eax
  8018a7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <devfile_write>:
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 0c             	sub    $0xc,%esp
  8018c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018c8:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8018cd:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d3:	8b 52 0c             	mov    0xc(%edx),%edx
  8018d6:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8018dc:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018e1:	50                   	push   %eax
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	68 08 50 80 00       	push   $0x805008
  8018ea:	e8 2e f2 ff ff       	call   800b1d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8018ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8018f9:	e8 ca fe ff ff       	call   8017c8 <fsipc>
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <devfile_read>:
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	8b 40 0c             	mov    0xc(%eax),%eax
  80190e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801913:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	b8 03 00 00 00       	mov    $0x3,%eax
  801923:	e8 a0 fe ff ff       	call   8017c8 <fsipc>
  801928:	89 c3                	mov    %eax,%ebx
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 1f                	js     80194d <devfile_read+0x4d>
	assert(r <= n);
  80192e:	39 f0                	cmp    %esi,%eax
  801930:	77 24                	ja     801956 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801932:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801937:	7f 33                	jg     80196c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	50                   	push   %eax
  80193d:	68 00 50 80 00       	push   $0x805000
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	e8 d3 f1 ff ff       	call   800b1d <memmove>
	return r;
  80194a:	83 c4 10             	add    $0x10,%esp
}
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    
	assert(r <= n);
  801956:	68 ec 2c 80 00       	push   $0x802cec
  80195b:	68 f3 2c 80 00       	push   $0x802cf3
  801960:	6a 7b                	push   $0x7b
  801962:	68 08 2d 80 00       	push   $0x802d08
  801967:	e8 29 e9 ff ff       	call   800295 <_panic>
	assert(r <= PGSIZE);
  80196c:	68 13 2d 80 00       	push   $0x802d13
  801971:	68 f3 2c 80 00       	push   $0x802cf3
  801976:	6a 7c                	push   $0x7c
  801978:	68 08 2d 80 00       	push   $0x802d08
  80197d:	e8 13 e9 ff ff       	call   800295 <_panic>

00801982 <open>:
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	56                   	push   %esi
  801986:	53                   	push   %ebx
  801987:	83 ec 1c             	sub    $0x1c,%esp
  80198a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80198d:	56                   	push   %esi
  80198e:	e8 c5 ef ff ff       	call   800958 <strlen>
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80199b:	7f 6c                	jg     801a09 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	e8 b4 f8 ff ff       	call   80125d <fd_alloc>
  8019a9:	89 c3                	mov    %eax,%ebx
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 3c                	js     8019ee <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	56                   	push   %esi
  8019b6:	68 00 50 80 00       	push   $0x805000
  8019bb:	e8 cf ef ff ff       	call   80098f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8019c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d0:	e8 f3 fd ff ff       	call   8017c8 <fsipc>
  8019d5:	89 c3                	mov    %eax,%ebx
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 19                	js     8019f7 <open+0x75>
	return fd2num(fd);
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e4:	e8 4d f8 ff ff       	call   801236 <fd2num>
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
}
  8019ee:	89 d8                	mov    %ebx,%eax
  8019f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    
		fd_close(fd, 0);
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ff:	e8 54 f9 ff ff       	call   801358 <fd_close>
		return r;
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	eb e5                	jmp    8019ee <open+0x6c>
		return -E_BAD_PATH;
  801a09:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a0e:	eb de                	jmp    8019ee <open+0x6c>

00801a10 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a16:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1b:	b8 08 00 00 00       	mov    $0x8,%eax
  801a20:	e8 a3 fd ff ff       	call   8017c8 <fsipc>
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a2d:	68 1f 2d 80 00       	push   $0x802d1f
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 55 ef ff ff       	call   80098f <strcpy>
	return 0;
}
  801a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <devsock_close>:
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	53                   	push   %ebx
  801a45:	83 ec 10             	sub    $0x10,%esp
  801a48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a4b:	53                   	push   %ebx
  801a4c:	e8 84 0a 00 00       	call   8024d5 <pageref>
  801a51:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a54:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a59:	83 f8 01             	cmp    $0x1,%eax
  801a5c:	74 07                	je     801a65 <devsock_close+0x24>
}
  801a5e:	89 d0                	mov    %edx,%eax
  801a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a65:	83 ec 0c             	sub    $0xc,%esp
  801a68:	ff 73 0c             	pushl  0xc(%ebx)
  801a6b:	e8 b7 02 00 00       	call   801d27 <nsipc_close>
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	eb e7                	jmp    801a5e <devsock_close+0x1d>

00801a77 <devsock_write>:
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	ff 75 10             	pushl  0x10(%ebp)
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	ff 70 0c             	pushl  0xc(%eax)
  801a8b:	e8 74 03 00 00       	call   801e04 <nsipc_send>
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <devsock_read>:
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 10             	pushl  0x10(%ebp)
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	ff 70 0c             	pushl  0xc(%eax)
  801aa6:	e8 ed 02 00 00       	call   801d98 <nsipc_recv>
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <fd2sockid>:
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ab3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	e8 ef f7 ff ff       	call   8012ac <fd_lookup>
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 10                	js     801ad4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac7:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801acd:	39 08                	cmp    %ecx,(%eax)
  801acf:	75 05                	jne    801ad6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ad1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801adb:	eb f7                	jmp    801ad4 <fd2sockid+0x27>

00801add <alloc_sockfd>:
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	56                   	push   %esi
  801ae1:	53                   	push   %ebx
  801ae2:	83 ec 1c             	sub    $0x1c,%esp
  801ae5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ae7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aea:	50                   	push   %eax
  801aeb:	e8 6d f7 ff ff       	call   80125d <fd_alloc>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	78 43                	js     801b3c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	68 07 04 00 00       	push   $0x407
  801b01:	ff 75 f4             	pushl  -0xc(%ebp)
  801b04:	6a 00                	push   $0x0
  801b06:	e8 7d f2 ff ff       	call   800d88 <sys_page_alloc>
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 28                	js     801b3c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b17:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b1d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b22:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b29:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b2c:	83 ec 0c             	sub    $0xc,%esp
  801b2f:	50                   	push   %eax
  801b30:	e8 01 f7 ff ff       	call   801236 <fd2num>
  801b35:	89 c3                	mov    %eax,%ebx
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	eb 0c                	jmp    801b48 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	56                   	push   %esi
  801b40:	e8 e2 01 00 00       	call   801d27 <nsipc_close>
		return r;
  801b45:	83 c4 10             	add    $0x10,%esp
}
  801b48:	89 d8                	mov    %ebx,%eax
  801b4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4d:	5b                   	pop    %ebx
  801b4e:	5e                   	pop    %esi
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <accept>:
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	e8 4e ff ff ff       	call   801aad <fd2sockid>
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 1b                	js     801b7e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	ff 75 10             	pushl  0x10(%ebp)
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	50                   	push   %eax
  801b6d:	e8 0e 01 00 00       	call   801c80 <nsipc_accept>
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 05                	js     801b7e <accept+0x2d>
	return alloc_sockfd(r);
  801b79:	e8 5f ff ff ff       	call   801add <alloc_sockfd>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <bind>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	e8 1f ff ff ff       	call   801aad <fd2sockid>
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 12                	js     801ba4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	50                   	push   %eax
  801b9c:	e8 2f 01 00 00       	call   801cd0 <nsipc_bind>
  801ba1:	83 c4 10             	add    $0x10,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <shutdown>:
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	e8 f9 fe ff ff       	call   801aad <fd2sockid>
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 0f                	js     801bc7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	e8 41 01 00 00       	call   801d05 <nsipc_shutdown>
  801bc4:	83 c4 10             	add    $0x10,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <connect>:
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	e8 d6 fe ff ff       	call   801aad <fd2sockid>
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	78 12                	js     801bed <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	ff 75 10             	pushl  0x10(%ebp)
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	50                   	push   %eax
  801be5:	e8 57 01 00 00       	call   801d41 <nsipc_connect>
  801bea:	83 c4 10             	add    $0x10,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <listen>:
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	e8 b0 fe ff ff       	call   801aad <fd2sockid>
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	78 0f                	js     801c10 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c01:	83 ec 08             	sub    $0x8,%esp
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	50                   	push   %eax
  801c08:	e8 69 01 00 00       	call   801d76 <nsipc_listen>
  801c0d:	83 c4 10             	add    $0x10,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c18:	ff 75 10             	pushl  0x10(%ebp)
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 3c 02 00 00       	call   801e62 <nsipc_socket>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 05                	js     801c32 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c2d:	e8 ab fe ff ff       	call   801add <alloc_sockfd>
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c3d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c44:	74 26                	je     801c6c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c46:	6a 07                	push   $0x7
  801c48:	68 00 60 80 00       	push   $0x806000
  801c4d:	53                   	push   %ebx
  801c4e:	ff 35 04 40 80 00    	pushl  0x804004
  801c54:	e8 ef 07 00 00       	call   802448 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c59:	83 c4 0c             	add    $0xc,%esp
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	e8 7a 07 00 00       	call   8023e1 <ipc_recv>
}
  801c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c6c:	83 ec 0c             	sub    $0xc,%esp
  801c6f:	6a 02                	push   $0x2
  801c71:	e8 26 08 00 00       	call   80249c <ipc_find_env>
  801c76:	a3 04 40 80 00       	mov    %eax,0x804004
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	eb c6                	jmp    801c46 <nsipc+0x12>

00801c80 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c90:	8b 06                	mov    (%esi),%eax
  801c92:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c97:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9c:	e8 93 ff ff ff       	call   801c34 <nsipc>
  801ca1:	89 c3                	mov    %eax,%ebx
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 20                	js     801cc7 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	ff 35 10 60 80 00    	pushl  0x806010
  801cb0:	68 00 60 80 00       	push   $0x806000
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 60 ee ff ff       	call   800b1d <memmove>
		*addrlen = ret->ret_addrlen;
  801cbd:	a1 10 60 80 00       	mov    0x806010,%eax
  801cc2:	89 06                	mov    %eax,(%esi)
  801cc4:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801cc7:	89 d8                	mov    %ebx,%eax
  801cc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ccc:	5b                   	pop    %ebx
  801ccd:	5e                   	pop    %esi
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    

00801cd0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 08             	sub    $0x8,%esp
  801cd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ce2:	53                   	push   %ebx
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	68 04 60 80 00       	push   $0x806004
  801ceb:	e8 2d ee ff ff       	call   800b1d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cf0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cf6:	b8 02 00 00 00       	mov    $0x2,%eax
  801cfb:	e8 34 ff ff ff       	call   801c34 <nsipc>
}
  801d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d16:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d1b:	b8 03 00 00 00       	mov    $0x3,%eax
  801d20:	e8 0f ff ff ff       	call   801c34 <nsipc>
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <nsipc_close>:

int
nsipc_close(int s)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d35:	b8 04 00 00 00       	mov    $0x4,%eax
  801d3a:	e8 f5 fe ff ff       	call   801c34 <nsipc>
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	53                   	push   %ebx
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d53:	53                   	push   %ebx
  801d54:	ff 75 0c             	pushl  0xc(%ebp)
  801d57:	68 04 60 80 00       	push   $0x806004
  801d5c:	e8 bc ed ff ff       	call   800b1d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d61:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d67:	b8 05 00 00 00       	mov    $0x5,%eax
  801d6c:	e8 c3 fe ff ff       	call   801c34 <nsipc>
}
  801d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d87:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d8c:	b8 06 00 00 00       	mov    $0x6,%eax
  801d91:	e8 9e fe ff ff       	call   801c34 <nsipc>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801da8:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dae:	8b 45 14             	mov    0x14(%ebp),%eax
  801db1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801db6:	b8 07 00 00 00       	mov    $0x7,%eax
  801dbb:	e8 74 fe ff ff       	call   801c34 <nsipc>
  801dc0:	89 c3                	mov    %eax,%ebx
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	78 1f                	js     801de5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801dc6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801dcb:	7f 21                	jg     801dee <nsipc_recv+0x56>
  801dcd:	39 c6                	cmp    %eax,%esi
  801dcf:	7c 1d                	jl     801dee <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dd1:	83 ec 04             	sub    $0x4,%esp
  801dd4:	50                   	push   %eax
  801dd5:	68 00 60 80 00       	push   $0x806000
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	e8 3b ed ff ff       	call   800b1d <memmove>
  801de2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801de5:	89 d8                	mov    %ebx,%eax
  801de7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dea:	5b                   	pop    %ebx
  801deb:	5e                   	pop    %esi
  801dec:	5d                   	pop    %ebp
  801ded:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801dee:	68 2b 2d 80 00       	push   $0x802d2b
  801df3:	68 f3 2c 80 00       	push   $0x802cf3
  801df8:	6a 62                	push   $0x62
  801dfa:	68 40 2d 80 00       	push   $0x802d40
  801dff:	e8 91 e4 ff ff       	call   800295 <_panic>

00801e04 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	53                   	push   %ebx
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e16:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e1c:	7f 2e                	jg     801e4c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	53                   	push   %ebx
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	68 0c 60 80 00       	push   $0x80600c
  801e2a:	e8 ee ec ff ff       	call   800b1d <memmove>
	nsipcbuf.send.req_size = size;
  801e2f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e35:	8b 45 14             	mov    0x14(%ebp),%eax
  801e38:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e3d:	b8 08 00 00 00       	mov    $0x8,%eax
  801e42:	e8 ed fd ff ff       	call   801c34 <nsipc>
}
  801e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    
	assert(size < 1600);
  801e4c:	68 4c 2d 80 00       	push   $0x802d4c
  801e51:	68 f3 2c 80 00       	push   $0x802cf3
  801e56:	6a 6d                	push   $0x6d
  801e58:	68 40 2d 80 00       	push   $0x802d40
  801e5d:	e8 33 e4 ff ff       	call   800295 <_panic>

00801e62 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e78:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e80:	b8 09 00 00 00       	mov    $0x9,%eax
  801e85:	e8 aa fd ff ff       	call   801c34 <nsipc>
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	56                   	push   %esi
  801e90:	53                   	push   %ebx
  801e91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	e8 a7 f3 ff ff       	call   801246 <fd2data>
  801e9f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ea1:	83 c4 08             	add    $0x8,%esp
  801ea4:	68 58 2d 80 00       	push   $0x802d58
  801ea9:	53                   	push   %ebx
  801eaa:	e8 e0 ea ff ff       	call   80098f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801eaf:	8b 46 04             	mov    0x4(%esi),%eax
  801eb2:	2b 06                	sub    (%esi),%eax
  801eb4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801eba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ec1:	00 00 00 
	stat->st_dev = &devpipe;
  801ec4:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ecb:	30 80 00 
	return 0;
}
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed6:	5b                   	pop    %ebx
  801ed7:	5e                   	pop    %esi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	53                   	push   %ebx
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ee4:	53                   	push   %ebx
  801ee5:	6a 00                	push   $0x0
  801ee7:	e8 21 ef ff ff       	call   800e0d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801eec:	89 1c 24             	mov    %ebx,(%esp)
  801eef:	e8 52 f3 ff ff       	call   801246 <fd2data>
  801ef4:	83 c4 08             	add    $0x8,%esp
  801ef7:	50                   	push   %eax
  801ef8:	6a 00                	push   $0x0
  801efa:	e8 0e ef ff ff       	call   800e0d <sys_page_unmap>
}
  801eff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <_pipeisclosed>:
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	57                   	push   %edi
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 1c             	sub    $0x1c,%esp
  801f0d:	89 c7                	mov    %eax,%edi
  801f0f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f11:	a1 08 40 80 00       	mov    0x804008,%eax
  801f16:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	57                   	push   %edi
  801f1d:	e8 b3 05 00 00       	call   8024d5 <pageref>
  801f22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f25:	89 34 24             	mov    %esi,(%esp)
  801f28:	e8 a8 05 00 00       	call   8024d5 <pageref>
		nn = thisenv->env_runs;
  801f2d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f33:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	39 cb                	cmp    %ecx,%ebx
  801f3b:	74 1b                	je     801f58 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f3d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f40:	75 cf                	jne    801f11 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f42:	8b 42 58             	mov    0x58(%edx),%eax
  801f45:	6a 01                	push   $0x1
  801f47:	50                   	push   %eax
  801f48:	53                   	push   %ebx
  801f49:	68 5f 2d 80 00       	push   $0x802d5f
  801f4e:	e8 1d e4 ff ff       	call   800370 <cprintf>
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	eb b9                	jmp    801f11 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f58:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f5b:	0f 94 c0             	sete   %al
  801f5e:	0f b6 c0             	movzbl %al,%eax
}
  801f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f64:	5b                   	pop    %ebx
  801f65:	5e                   	pop    %esi
  801f66:	5f                   	pop    %edi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    

00801f69 <devpipe_write>:
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	57                   	push   %edi
  801f6d:	56                   	push   %esi
  801f6e:	53                   	push   %ebx
  801f6f:	83 ec 28             	sub    $0x28,%esp
  801f72:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f75:	56                   	push   %esi
  801f76:	e8 cb f2 ff ff       	call   801246 <fd2data>
  801f7b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	bf 00 00 00 00       	mov    $0x0,%edi
  801f85:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f88:	74 4f                	je     801fd9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8a:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8d:	8b 0b                	mov    (%ebx),%ecx
  801f8f:	8d 51 20             	lea    0x20(%ecx),%edx
  801f92:	39 d0                	cmp    %edx,%eax
  801f94:	72 14                	jb     801faa <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f96:	89 da                	mov    %ebx,%edx
  801f98:	89 f0                	mov    %esi,%eax
  801f9a:	e8 65 ff ff ff       	call   801f04 <_pipeisclosed>
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	75 3a                	jne    801fdd <devpipe_write+0x74>
			sys_yield();
  801fa3:	e8 c1 ed ff ff       	call   800d69 <sys_yield>
  801fa8:	eb e0                	jmp    801f8a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fad:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fb1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fb4:	89 c2                	mov    %eax,%edx
  801fb6:	c1 fa 1f             	sar    $0x1f,%edx
  801fb9:	89 d1                	mov    %edx,%ecx
  801fbb:	c1 e9 1b             	shr    $0x1b,%ecx
  801fbe:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fc1:	83 e2 1f             	and    $0x1f,%edx
  801fc4:	29 ca                	sub    %ecx,%edx
  801fc6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fca:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fce:	83 c0 01             	add    $0x1,%eax
  801fd1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fd4:	83 c7 01             	add    $0x1,%edi
  801fd7:	eb ac                	jmp    801f85 <devpipe_write+0x1c>
	return i;
  801fd9:	89 f8                	mov    %edi,%eax
  801fdb:	eb 05                	jmp    801fe2 <devpipe_write+0x79>
				return 0;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe5:	5b                   	pop    %ebx
  801fe6:	5e                   	pop    %esi
  801fe7:	5f                   	pop    %edi
  801fe8:	5d                   	pop    %ebp
  801fe9:	c3                   	ret    

00801fea <devpipe_read>:
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	57                   	push   %edi
  801fee:	56                   	push   %esi
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 18             	sub    $0x18,%esp
  801ff3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ff6:	57                   	push   %edi
  801ff7:	e8 4a f2 ff ff       	call   801246 <fd2data>
  801ffc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	be 00 00 00 00       	mov    $0x0,%esi
  802006:	3b 75 10             	cmp    0x10(%ebp),%esi
  802009:	74 47                	je     802052 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80200b:	8b 03                	mov    (%ebx),%eax
  80200d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802010:	75 22                	jne    802034 <devpipe_read+0x4a>
			if (i > 0)
  802012:	85 f6                	test   %esi,%esi
  802014:	75 14                	jne    80202a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802016:	89 da                	mov    %ebx,%edx
  802018:	89 f8                	mov    %edi,%eax
  80201a:	e8 e5 fe ff ff       	call   801f04 <_pipeisclosed>
  80201f:	85 c0                	test   %eax,%eax
  802021:	75 33                	jne    802056 <devpipe_read+0x6c>
			sys_yield();
  802023:	e8 41 ed ff ff       	call   800d69 <sys_yield>
  802028:	eb e1                	jmp    80200b <devpipe_read+0x21>
				return i;
  80202a:	89 f0                	mov    %esi,%eax
}
  80202c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802034:	99                   	cltd   
  802035:	c1 ea 1b             	shr    $0x1b,%edx
  802038:	01 d0                	add    %edx,%eax
  80203a:	83 e0 1f             	and    $0x1f,%eax
  80203d:	29 d0                	sub    %edx,%eax
  80203f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802044:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802047:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80204a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80204d:	83 c6 01             	add    $0x1,%esi
  802050:	eb b4                	jmp    802006 <devpipe_read+0x1c>
	return i;
  802052:	89 f0                	mov    %esi,%eax
  802054:	eb d6                	jmp    80202c <devpipe_read+0x42>
				return 0;
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
  80205b:	eb cf                	jmp    80202c <devpipe_read+0x42>

0080205d <pipe>:
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	56                   	push   %esi
  802061:	53                   	push   %ebx
  802062:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802065:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 ef f1 ff ff       	call   80125d <fd_alloc>
  80206e:	89 c3                	mov    %eax,%ebx
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	85 c0                	test   %eax,%eax
  802075:	78 5b                	js     8020d2 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	68 07 04 00 00       	push   $0x407
  80207f:	ff 75 f4             	pushl  -0xc(%ebp)
  802082:	6a 00                	push   $0x0
  802084:	e8 ff ec ff ff       	call   800d88 <sys_page_alloc>
  802089:	89 c3                	mov    %eax,%ebx
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 40                	js     8020d2 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802098:	50                   	push   %eax
  802099:	e8 bf f1 ff ff       	call   80125d <fd_alloc>
  80209e:	89 c3                	mov    %eax,%ebx
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 1b                	js     8020c2 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	68 07 04 00 00       	push   $0x407
  8020af:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 cf ec ff ff       	call   800d88 <sys_page_alloc>
  8020b9:	89 c3                	mov    %eax,%ebx
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	79 19                	jns    8020db <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8020c2:	83 ec 08             	sub    $0x8,%esp
  8020c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c8:	6a 00                	push   $0x0
  8020ca:	e8 3e ed ff ff       	call   800e0d <sys_page_unmap>
  8020cf:	83 c4 10             	add    $0x10,%esp
}
  8020d2:	89 d8                	mov    %ebx,%eax
  8020d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    
	va = fd2data(fd0);
  8020db:	83 ec 0c             	sub    $0xc,%esp
  8020de:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e1:	e8 60 f1 ff ff       	call   801246 <fd2data>
  8020e6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e8:	83 c4 0c             	add    $0xc,%esp
  8020eb:	68 07 04 00 00       	push   $0x407
  8020f0:	50                   	push   %eax
  8020f1:	6a 00                	push   $0x0
  8020f3:	e8 90 ec ff ff       	call   800d88 <sys_page_alloc>
  8020f8:	89 c3                	mov    %eax,%ebx
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	0f 88 8c 00 00 00    	js     802191 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	ff 75 f0             	pushl  -0x10(%ebp)
  80210b:	e8 36 f1 ff ff       	call   801246 <fd2data>
  802110:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802117:	50                   	push   %eax
  802118:	6a 00                	push   $0x0
  80211a:	56                   	push   %esi
  80211b:	6a 00                	push   $0x0
  80211d:	e8 a9 ec ff ff       	call   800dcb <sys_page_map>
  802122:	89 c3                	mov    %eax,%ebx
  802124:	83 c4 20             	add    $0x20,%esp
  802127:	85 c0                	test   %eax,%eax
  802129:	78 58                	js     802183 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802134:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802139:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802143:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802149:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	ff 75 f4             	pushl  -0xc(%ebp)
  80215b:	e8 d6 f0 ff ff       	call   801236 <fd2num>
  802160:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802163:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802165:	83 c4 04             	add    $0x4,%esp
  802168:	ff 75 f0             	pushl  -0x10(%ebp)
  80216b:	e8 c6 f0 ff ff       	call   801236 <fd2num>
  802170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802173:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	bb 00 00 00 00       	mov    $0x0,%ebx
  80217e:	e9 4f ff ff ff       	jmp    8020d2 <pipe+0x75>
	sys_page_unmap(0, va);
  802183:	83 ec 08             	sub    $0x8,%esp
  802186:	56                   	push   %esi
  802187:	6a 00                	push   $0x0
  802189:	e8 7f ec ff ff       	call   800e0d <sys_page_unmap>
  80218e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802191:	83 ec 08             	sub    $0x8,%esp
  802194:	ff 75 f0             	pushl  -0x10(%ebp)
  802197:	6a 00                	push   $0x0
  802199:	e8 6f ec ff ff       	call   800e0d <sys_page_unmap>
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	e9 1c ff ff ff       	jmp    8020c2 <pipe+0x65>

008021a6 <pipeisclosed>:
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021af:	50                   	push   %eax
  8021b0:	ff 75 08             	pushl  0x8(%ebp)
  8021b3:	e8 f4 f0 ff ff       	call   8012ac <fd_lookup>
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 18                	js     8021d7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021bf:	83 ec 0c             	sub    $0xc,%esp
  8021c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c5:	e8 7c f0 ff ff       	call   801246 <fd2data>
	return _pipeisclosed(fd, p);
  8021ca:	89 c2                	mov    %eax,%edx
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	e8 30 fd ff ff       	call   801f04 <_pipeisclosed>
  8021d4:	83 c4 10             	add    $0x10,%esp
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021e9:	68 72 2d 80 00       	push   $0x802d72
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	e8 99 e7 ff ff       	call   80098f <strcpy>
	return 0;
}
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <devcons_write>:
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	57                   	push   %edi
  802201:	56                   	push   %esi
  802202:	53                   	push   %ebx
  802203:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802209:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80220e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802214:	eb 2f                	jmp    802245 <devcons_write+0x48>
		m = n - tot;
  802216:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802219:	29 f3                	sub    %esi,%ebx
  80221b:	83 fb 7f             	cmp    $0x7f,%ebx
  80221e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802223:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	53                   	push   %ebx
  80222a:	89 f0                	mov    %esi,%eax
  80222c:	03 45 0c             	add    0xc(%ebp),%eax
  80222f:	50                   	push   %eax
  802230:	57                   	push   %edi
  802231:	e8 e7 e8 ff ff       	call   800b1d <memmove>
		sys_cputs(buf, m);
  802236:	83 c4 08             	add    $0x8,%esp
  802239:	53                   	push   %ebx
  80223a:	57                   	push   %edi
  80223b:	e8 8c ea ff ff       	call   800ccc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802240:	01 de                	add    %ebx,%esi
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	3b 75 10             	cmp    0x10(%ebp),%esi
  802248:	72 cc                	jb     802216 <devcons_write+0x19>
}
  80224a:	89 f0                	mov    %esi,%eax
  80224c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5f                   	pop    %edi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    

00802254 <devcons_read>:
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 08             	sub    $0x8,%esp
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80225f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802263:	75 07                	jne    80226c <devcons_read+0x18>
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    
		sys_yield();
  802267:	e8 fd ea ff ff       	call   800d69 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80226c:	e8 79 ea ff ff       	call   800cea <sys_cgetc>
  802271:	85 c0                	test   %eax,%eax
  802273:	74 f2                	je     802267 <devcons_read+0x13>
	if (c < 0)
  802275:	85 c0                	test   %eax,%eax
  802277:	78 ec                	js     802265 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802279:	83 f8 04             	cmp    $0x4,%eax
  80227c:	74 0c                	je     80228a <devcons_read+0x36>
	*(char*)vbuf = c;
  80227e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802281:	88 02                	mov    %al,(%edx)
	return 1;
  802283:	b8 01 00 00 00       	mov    $0x1,%eax
  802288:	eb db                	jmp    802265 <devcons_read+0x11>
		return 0;
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
  80228f:	eb d4                	jmp    802265 <devcons_read+0x11>

00802291 <cputchar>:
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80229d:	6a 01                	push   $0x1
  80229f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022a2:	50                   	push   %eax
  8022a3:	e8 24 ea ff ff       	call   800ccc <sys_cputs>
}
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <getchar>:
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022b3:	6a 01                	push   $0x1
  8022b5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022b8:	50                   	push   %eax
  8022b9:	6a 00                	push   $0x0
  8022bb:	e8 5d f2 ff ff       	call   80151d <read>
	if (r < 0)
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	78 08                	js     8022cf <getchar+0x22>
	if (r < 1)
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	7e 06                	jle    8022d1 <getchar+0x24>
	return c;
  8022cb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    
		return -E_EOF;
  8022d1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022d6:	eb f7                	jmp    8022cf <getchar+0x22>

008022d8 <iscons>:
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022e1:	50                   	push   %eax
  8022e2:	ff 75 08             	pushl  0x8(%ebp)
  8022e5:	e8 c2 ef ff ff       	call   8012ac <fd_lookup>
  8022ea:	83 c4 10             	add    $0x10,%esp
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	78 11                	js     802302 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022fa:	39 10                	cmp    %edx,(%eax)
  8022fc:	0f 94 c0             	sete   %al
  8022ff:	0f b6 c0             	movzbl %al,%eax
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <opencons>:
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80230a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80230d:	50                   	push   %eax
  80230e:	e8 4a ef ff ff       	call   80125d <fd_alloc>
  802313:	83 c4 10             	add    $0x10,%esp
  802316:	85 c0                	test   %eax,%eax
  802318:	78 3a                	js     802354 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80231a:	83 ec 04             	sub    $0x4,%esp
  80231d:	68 07 04 00 00       	push   $0x407
  802322:	ff 75 f4             	pushl  -0xc(%ebp)
  802325:	6a 00                	push   $0x0
  802327:	e8 5c ea ff ff       	call   800d88 <sys_page_alloc>
  80232c:	83 c4 10             	add    $0x10,%esp
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 21                	js     802354 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80233c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802348:	83 ec 0c             	sub    $0xc,%esp
  80234b:	50                   	push   %eax
  80234c:	e8 e5 ee ff ff       	call   801236 <fd2num>
  802351:	83 c4 10             	add    $0x10,%esp
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  80235c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802363:	74 0a                	je     80236f <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  80236f:	a1 08 40 80 00       	mov    0x804008,%eax
  802374:	8b 40 48             	mov    0x48(%eax),%eax
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	6a 07                	push   $0x7
  80237c:	68 00 f0 bf ee       	push   $0xeebff000
  802381:	50                   	push   %eax
  802382:	e8 01 ea ff ff       	call   800d88 <sys_page_alloc>
  802387:	83 c4 10             	add    $0x10,%esp
  80238a:	85 c0                	test   %eax,%eax
  80238c:	78 1b                	js     8023a9 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80238e:	a1 08 40 80 00       	mov    0x804008,%eax
  802393:	8b 40 48             	mov    0x48(%eax),%eax
  802396:	83 ec 08             	sub    $0x8,%esp
  802399:	68 bb 23 80 00       	push   $0x8023bb
  80239e:	50                   	push   %eax
  80239f:	e8 2f eb ff ff       	call   800ed3 <sys_env_set_pgfault_upcall>
  8023a4:	83 c4 10             	add    $0x10,%esp
  8023a7:	eb bc                	jmp    802365 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  8023a9:	50                   	push   %eax
  8023aa:	68 7e 2d 80 00       	push   $0x802d7e
  8023af:	6a 22                	push   $0x22
  8023b1:	68 96 2d 80 00       	push   $0x802d96
  8023b6:	e8 da de ff ff       	call   800295 <_panic>

008023bb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023bb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023bc:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8023c1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023c3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8023c6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8023ca:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8023cd:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8023d1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8023d5:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8023d7:	83 c4 08             	add    $0x8,%esp
	popal
  8023da:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8023db:	83 c4 04             	add    $0x4,%esp
	popfl
  8023de:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8023df:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8023e0:	c3                   	ret    

008023e1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	56                   	push   %esi
  8023e5:	53                   	push   %ebx
  8023e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8023e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023ef:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023f1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023f6:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	50                   	push   %eax
  8023fd:	e8 36 eb ff ff       	call   800f38 <sys_ipc_recv>
	if (from_env_store)
  802402:	83 c4 10             	add    $0x10,%esp
  802405:	85 f6                	test   %esi,%esi
  802407:	74 14                	je     80241d <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802409:	ba 00 00 00 00       	mov    $0x0,%edx
  80240e:	85 c0                	test   %eax,%eax
  802410:	78 09                	js     80241b <ipc_recv+0x3a>
  802412:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802418:	8b 52 74             	mov    0x74(%edx),%edx
  80241b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80241d:	85 db                	test   %ebx,%ebx
  80241f:	74 14                	je     802435 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802421:	ba 00 00 00 00       	mov    $0x0,%edx
  802426:	85 c0                	test   %eax,%eax
  802428:	78 09                	js     802433 <ipc_recv+0x52>
  80242a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802430:	8b 52 78             	mov    0x78(%edx),%edx
  802433:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802435:	85 c0                	test   %eax,%eax
  802437:	78 08                	js     802441 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802439:	a1 08 40 80 00       	mov    0x804008,%eax
  80243e:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802441:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802444:	5b                   	pop    %ebx
  802445:	5e                   	pop    %esi
  802446:	5d                   	pop    %ebp
  802447:	c3                   	ret    

00802448 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
  80244b:	57                   	push   %edi
  80244c:	56                   	push   %esi
  80244d:	53                   	push   %ebx
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	8b 7d 08             	mov    0x8(%ebp),%edi
  802454:	8b 75 0c             	mov    0xc(%ebp),%esi
  802457:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80245a:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  80245c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802461:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802464:	ff 75 14             	pushl  0x14(%ebp)
  802467:	53                   	push   %ebx
  802468:	56                   	push   %esi
  802469:	57                   	push   %edi
  80246a:	e8 a6 ea ff ff       	call   800f15 <sys_ipc_try_send>
		if (ret == 0)
  80246f:	83 c4 10             	add    $0x10,%esp
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1e                	je     802494 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802476:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802479:	75 07                	jne    802482 <ipc_send+0x3a>
			sys_yield();
  80247b:	e8 e9 e8 ff ff       	call   800d69 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802480:	eb e2                	jmp    802464 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802482:	50                   	push   %eax
  802483:	68 a4 2d 80 00       	push   $0x802da4
  802488:	6a 3d                	push   $0x3d
  80248a:	68 b8 2d 80 00       	push   $0x802db8
  80248f:	e8 01 de ff ff       	call   800295 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802494:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802497:	5b                   	pop    %ebx
  802498:	5e                   	pop    %esi
  802499:	5f                   	pop    %edi
  80249a:	5d                   	pop    %ebp
  80249b:	c3                   	ret    

0080249c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024a7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024aa:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024b0:	8b 52 50             	mov    0x50(%edx),%edx
  8024b3:	39 ca                	cmp    %ecx,%edx
  8024b5:	74 11                	je     8024c8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8024b7:	83 c0 01             	add    $0x1,%eax
  8024ba:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024bf:	75 e6                	jne    8024a7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c6:	eb 0b                	jmp    8024d3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8024c8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024cb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024d0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024db:	89 d0                	mov    %edx,%eax
  8024dd:	c1 e8 16             	shr    $0x16,%eax
  8024e0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024ec:	f6 c1 01             	test   $0x1,%cl
  8024ef:	74 1d                	je     80250e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024f1:	c1 ea 0c             	shr    $0xc,%edx
  8024f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024fb:	f6 c2 01             	test   $0x1,%dl
  8024fe:	74 0e                	je     80250e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802500:	c1 ea 0c             	shr    $0xc,%edx
  802503:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80250a:	ef 
  80250b:	0f b7 c0             	movzwl %ax,%eax
}
  80250e:	5d                   	pop    %ebp
  80250f:	c3                   	ret    

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80251b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80251f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802523:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802527:	85 d2                	test   %edx,%edx
  802529:	75 35                	jne    802560 <__udivdi3+0x50>
  80252b:	39 f3                	cmp    %esi,%ebx
  80252d:	0f 87 bd 00 00 00    	ja     8025f0 <__udivdi3+0xe0>
  802533:	85 db                	test   %ebx,%ebx
  802535:	89 d9                	mov    %ebx,%ecx
  802537:	75 0b                	jne    802544 <__udivdi3+0x34>
  802539:	b8 01 00 00 00       	mov    $0x1,%eax
  80253e:	31 d2                	xor    %edx,%edx
  802540:	f7 f3                	div    %ebx
  802542:	89 c1                	mov    %eax,%ecx
  802544:	31 d2                	xor    %edx,%edx
  802546:	89 f0                	mov    %esi,%eax
  802548:	f7 f1                	div    %ecx
  80254a:	89 c6                	mov    %eax,%esi
  80254c:	89 e8                	mov    %ebp,%eax
  80254e:	89 f7                	mov    %esi,%edi
  802550:	f7 f1                	div    %ecx
  802552:	89 fa                	mov    %edi,%edx
  802554:	83 c4 1c             	add    $0x1c,%esp
  802557:	5b                   	pop    %ebx
  802558:	5e                   	pop    %esi
  802559:	5f                   	pop    %edi
  80255a:	5d                   	pop    %ebp
  80255b:	c3                   	ret    
  80255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802560:	39 f2                	cmp    %esi,%edx
  802562:	77 7c                	ja     8025e0 <__udivdi3+0xd0>
  802564:	0f bd fa             	bsr    %edx,%edi
  802567:	83 f7 1f             	xor    $0x1f,%edi
  80256a:	0f 84 98 00 00 00    	je     802608 <__udivdi3+0xf8>
  802570:	89 f9                	mov    %edi,%ecx
  802572:	b8 20 00 00 00       	mov    $0x20,%eax
  802577:	29 f8                	sub    %edi,%eax
  802579:	d3 e2                	shl    %cl,%edx
  80257b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80257f:	89 c1                	mov    %eax,%ecx
  802581:	89 da                	mov    %ebx,%edx
  802583:	d3 ea                	shr    %cl,%edx
  802585:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802589:	09 d1                	or     %edx,%ecx
  80258b:	89 f2                	mov    %esi,%edx
  80258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802591:	89 f9                	mov    %edi,%ecx
  802593:	d3 e3                	shl    %cl,%ebx
  802595:	89 c1                	mov    %eax,%ecx
  802597:	d3 ea                	shr    %cl,%edx
  802599:	89 f9                	mov    %edi,%ecx
  80259b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80259f:	d3 e6                	shl    %cl,%esi
  8025a1:	89 eb                	mov    %ebp,%ebx
  8025a3:	89 c1                	mov    %eax,%ecx
  8025a5:	d3 eb                	shr    %cl,%ebx
  8025a7:	09 de                	or     %ebx,%esi
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	f7 74 24 08          	divl   0x8(%esp)
  8025af:	89 d6                	mov    %edx,%esi
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	f7 64 24 0c          	mull   0xc(%esp)
  8025b7:	39 d6                	cmp    %edx,%esi
  8025b9:	72 0c                	jb     8025c7 <__udivdi3+0xb7>
  8025bb:	89 f9                	mov    %edi,%ecx
  8025bd:	d3 e5                	shl    %cl,%ebp
  8025bf:	39 c5                	cmp    %eax,%ebp
  8025c1:	73 5d                	jae    802620 <__udivdi3+0x110>
  8025c3:	39 d6                	cmp    %edx,%esi
  8025c5:	75 59                	jne    802620 <__udivdi3+0x110>
  8025c7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025ca:	31 ff                	xor    %edi,%edi
  8025cc:	89 fa                	mov    %edi,%edx
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	8d 76 00             	lea    0x0(%esi),%esi
  8025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8025e0:	31 ff                	xor    %edi,%edi
  8025e2:	31 c0                	xor    %eax,%eax
  8025e4:	89 fa                	mov    %edi,%edx
  8025e6:	83 c4 1c             	add    $0x1c,%esp
  8025e9:	5b                   	pop    %ebx
  8025ea:	5e                   	pop    %esi
  8025eb:	5f                   	pop    %edi
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    
  8025ee:	66 90                	xchg   %ax,%ax
  8025f0:	31 ff                	xor    %edi,%edi
  8025f2:	89 e8                	mov    %ebp,%eax
  8025f4:	89 f2                	mov    %esi,%edx
  8025f6:	f7 f3                	div    %ebx
  8025f8:	89 fa                	mov    %edi,%edx
  8025fa:	83 c4 1c             	add    $0x1c,%esp
  8025fd:	5b                   	pop    %ebx
  8025fe:	5e                   	pop    %esi
  8025ff:	5f                   	pop    %edi
  802600:	5d                   	pop    %ebp
  802601:	c3                   	ret    
  802602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802608:	39 f2                	cmp    %esi,%edx
  80260a:	72 06                	jb     802612 <__udivdi3+0x102>
  80260c:	31 c0                	xor    %eax,%eax
  80260e:	39 eb                	cmp    %ebp,%ebx
  802610:	77 d2                	ja     8025e4 <__udivdi3+0xd4>
  802612:	b8 01 00 00 00       	mov    $0x1,%eax
  802617:	eb cb                	jmp    8025e4 <__udivdi3+0xd4>
  802619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802620:	89 d8                	mov    %ebx,%eax
  802622:	31 ff                	xor    %edi,%edi
  802624:	eb be                	jmp    8025e4 <__udivdi3+0xd4>
  802626:	66 90                	xchg   %ax,%ax
  802628:	66 90                	xchg   %ax,%ax
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__umoddi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	53                   	push   %ebx
  802634:	83 ec 1c             	sub    $0x1c,%esp
  802637:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80263b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80263f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802647:	85 ed                	test   %ebp,%ebp
  802649:	89 f0                	mov    %esi,%eax
  80264b:	89 da                	mov    %ebx,%edx
  80264d:	75 19                	jne    802668 <__umoddi3+0x38>
  80264f:	39 df                	cmp    %ebx,%edi
  802651:	0f 86 b1 00 00 00    	jbe    802708 <__umoddi3+0xd8>
  802657:	f7 f7                	div    %edi
  802659:	89 d0                	mov    %edx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	83 c4 1c             	add    $0x1c,%esp
  802660:	5b                   	pop    %ebx
  802661:	5e                   	pop    %esi
  802662:	5f                   	pop    %edi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	39 dd                	cmp    %ebx,%ebp
  80266a:	77 f1                	ja     80265d <__umoddi3+0x2d>
  80266c:	0f bd cd             	bsr    %ebp,%ecx
  80266f:	83 f1 1f             	xor    $0x1f,%ecx
  802672:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802676:	0f 84 b4 00 00 00    	je     802730 <__umoddi3+0x100>
  80267c:	b8 20 00 00 00       	mov    $0x20,%eax
  802681:	89 c2                	mov    %eax,%edx
  802683:	8b 44 24 04          	mov    0x4(%esp),%eax
  802687:	29 c2                	sub    %eax,%edx
  802689:	89 c1                	mov    %eax,%ecx
  80268b:	89 f8                	mov    %edi,%eax
  80268d:	d3 e5                	shl    %cl,%ebp
  80268f:	89 d1                	mov    %edx,%ecx
  802691:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802695:	d3 e8                	shr    %cl,%eax
  802697:	09 c5                	or     %eax,%ebp
  802699:	8b 44 24 04          	mov    0x4(%esp),%eax
  80269d:	89 c1                	mov    %eax,%ecx
  80269f:	d3 e7                	shl    %cl,%edi
  8026a1:	89 d1                	mov    %edx,%ecx
  8026a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026a7:	89 df                	mov    %ebx,%edi
  8026a9:	d3 ef                	shr    %cl,%edi
  8026ab:	89 c1                	mov    %eax,%ecx
  8026ad:	89 f0                	mov    %esi,%eax
  8026af:	d3 e3                	shl    %cl,%ebx
  8026b1:	89 d1                	mov    %edx,%ecx
  8026b3:	89 fa                	mov    %edi,%edx
  8026b5:	d3 e8                	shr    %cl,%eax
  8026b7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026bc:	09 d8                	or     %ebx,%eax
  8026be:	f7 f5                	div    %ebp
  8026c0:	d3 e6                	shl    %cl,%esi
  8026c2:	89 d1                	mov    %edx,%ecx
  8026c4:	f7 64 24 08          	mull   0x8(%esp)
  8026c8:	39 d1                	cmp    %edx,%ecx
  8026ca:	89 c3                	mov    %eax,%ebx
  8026cc:	89 d7                	mov    %edx,%edi
  8026ce:	72 06                	jb     8026d6 <__umoddi3+0xa6>
  8026d0:	75 0e                	jne    8026e0 <__umoddi3+0xb0>
  8026d2:	39 c6                	cmp    %eax,%esi
  8026d4:	73 0a                	jae    8026e0 <__umoddi3+0xb0>
  8026d6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026da:	19 ea                	sbb    %ebp,%edx
  8026dc:	89 d7                	mov    %edx,%edi
  8026de:	89 c3                	mov    %eax,%ebx
  8026e0:	89 ca                	mov    %ecx,%edx
  8026e2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8026e7:	29 de                	sub    %ebx,%esi
  8026e9:	19 fa                	sbb    %edi,%edx
  8026eb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8026ef:	89 d0                	mov    %edx,%eax
  8026f1:	d3 e0                	shl    %cl,%eax
  8026f3:	89 d9                	mov    %ebx,%ecx
  8026f5:	d3 ee                	shr    %cl,%esi
  8026f7:	d3 ea                	shr    %cl,%edx
  8026f9:	09 f0                	or     %esi,%eax
  8026fb:	83 c4 1c             	add    $0x1c,%esp
  8026fe:	5b                   	pop    %ebx
  8026ff:	5e                   	pop    %esi
  802700:	5f                   	pop    %edi
  802701:	5d                   	pop    %ebp
  802702:	c3                   	ret    
  802703:	90                   	nop
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	85 ff                	test   %edi,%edi
  80270a:	89 f9                	mov    %edi,%ecx
  80270c:	75 0b                	jne    802719 <__umoddi3+0xe9>
  80270e:	b8 01 00 00 00       	mov    $0x1,%eax
  802713:	31 d2                	xor    %edx,%edx
  802715:	f7 f7                	div    %edi
  802717:	89 c1                	mov    %eax,%ecx
  802719:	89 d8                	mov    %ebx,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	f7 f1                	div    %ecx
  80271f:	89 f0                	mov    %esi,%eax
  802721:	f7 f1                	div    %ecx
  802723:	e9 31 ff ff ff       	jmp    802659 <__umoddi3+0x29>
  802728:	90                   	nop
  802729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802730:	39 dd                	cmp    %ebx,%ebp
  802732:	72 08                	jb     80273c <__umoddi3+0x10c>
  802734:	39 f7                	cmp    %esi,%edi
  802736:	0f 87 21 ff ff ff    	ja     80265d <__umoddi3+0x2d>
  80273c:	89 da                	mov    %ebx,%edx
  80273e:	89 f0                	mov    %esi,%eax
  802740:	29 f8                	sub    %edi,%eax
  802742:	19 ea                	sbb    %ebp,%edx
  802744:	e9 14 ff ff ff       	jmp    80265d <__umoddi3+0x2d>

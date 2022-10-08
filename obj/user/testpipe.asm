
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 40 	movl   $0x802840,0x803004
  800042:	28 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 b0 20 00 00       	call   8020fe <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1f 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 b2 10 00 00       	call   801112 <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 22 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	85 c0                	test   %eax,%eax
  80006c:	0f 85 58 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800072:	a1 08 40 80 00       	mov    0x804008,%eax
  800077:	8b 40 48             	mov    0x48(%eax),%eax
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	ff 75 90             	pushl  -0x70(%ebp)
  800080:	50                   	push   %eax
  800081:	68 6e 28 80 00       	push   $0x80286e
  800086:	e8 86 03 00 00       	call   800411 <cprintf>
		close(p[1]);
  80008b:	83 c4 04             	add    $0x4,%esp
  80008e:	ff 75 90             	pushl  -0x70(%ebp)
  800091:	e8 ec 13 00 00       	call   801482 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800096:	a1 08 40 80 00       	mov    0x804008,%eax
  80009b:	8b 40 48             	mov    0x48(%eax),%eax
  80009e:	83 c4 0c             	add    $0xc,%esp
  8000a1:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a4:	50                   	push   %eax
  8000a5:	68 8b 28 80 00       	push   $0x80288b
  8000aa:	e8 62 03 00 00       	call   800411 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000af:	83 c4 0c             	add    $0xc,%esp
  8000b2:	6a 63                	push   $0x63
  8000b4:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b7:	50                   	push   %eax
  8000b8:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bb:	e8 85 15 00 00       	call   801645 <readn>
  8000c0:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	0f 88 d1 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cd:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	ff 35 00 30 80 00    	pushl  0x803000
  8000db:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000de:	50                   	push   %eax
  8000df:	e8 f2 09 00 00       	call   800ad6 <strcmp>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	0f 85 c1 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 b1 28 80 00       	push   $0x8028b1
  8000f7:	e8 15 03 00 00       	call   800411 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000ff:	e8 18 02 00 00       	call   80031c <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	53                   	push   %ebx
  800108:	e8 6d 21 00 00       	call   80227a <wait>

	binaryname = "pipewriteeof";
  80010d:	c7 05 04 30 80 00 07 	movl   $0x802907,0x803004
  800114:	29 80 00 
	if ((i = pipe(p)) < 0)
  800117:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 dc 1f 00 00       	call   8020fe <pipe>
  800122:	89 c6                	mov    %eax,%esi
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	85 c0                	test   %eax,%eax
  800129:	0f 88 34 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012f:	e8 de 0f 00 00       	call   801112 <fork>
  800134:	89 c3                	mov    %eax,%ebx
  800136:	85 c0                	test   %eax,%eax
  800138:	0f 88 37 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  80013e:	85 c0                	test   %eax,%eax
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 31 13 00 00       	call   801482 <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 26 13 00 00       	call   801482 <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 16 21 00 00       	call   80227a <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  80016b:	e8 a1 02 00 00       	call   800411 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 4c 28 80 00       	push   $0x80284c
  800180:	6a 0e                	push   $0xe
  800182:	68 55 28 80 00       	push   $0x802855
  800187:	e8 aa 01 00 00       	call   800336 <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 65 28 80 00       	push   $0x802865
  800192:	6a 11                	push   $0x11
  800194:	68 55 28 80 00       	push   $0x802855
  800199:	e8 98 01 00 00       	call   800336 <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 a8 28 80 00       	push   $0x8028a8
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 55 28 80 00       	push   $0x802855
  8001ab:	e8 86 01 00 00       	call   800336 <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 cd 28 80 00       	push   $0x8028cd
  8001bd:	e8 4f 02 00 00       	call   800411 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 35 ff ff ff       	jmp    8000ff <umain+0xcc>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 6e 28 80 00       	push   $0x80286e
  8001de:	e8 2e 02 00 00       	call   800411 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 94 12 00 00       	call   801482 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 08 40 80 00       	mov    0x804008,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 e0 28 80 00       	push   $0x8028e0
  800202:	e8 0a 02 00 00       	call   800411 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 30 80 00    	pushl  0x803000
  800210:	e8 e4 07 00 00       	call   8009f9 <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 30 80 00    	pushl  0x803000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 65 14 00 00       	call   80168c <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 30 80 00    	pushl  0x803000
  800232:	e8 c2 07 00 00       	call   8009f9 <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 39 12 00 00       	call   801482 <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b3 fe ff ff       	jmp    800104 <umain+0xd1>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 fd 28 80 00       	push   $0x8028fd
  800257:	6a 25                	push   $0x25
  800259:	68 55 28 80 00       	push   $0x802855
  80025e:	e8 d3 00 00 00       	call   800336 <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 4c 28 80 00       	push   $0x80284c
  800269:	6a 2c                	push   $0x2c
  80026b:	68 55 28 80 00       	push   $0x802855
  800270:	e8 c1 00 00 00       	call   800336 <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 65 28 80 00       	push   $0x802865
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 55 28 80 00       	push   $0x802855
  800282:	e8 af 00 00 00       	call   800336 <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 f0 11 00 00       	call   801482 <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 14 29 80 00       	push   $0x802914
  80029d:	e8 6f 01 00 00       	call   800411 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 16 29 80 00       	push   $0x802916
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 d8 13 00 00       	call   80168c <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 18 29 80 00       	push   $0x802918
  8002c4:	e8 48 01 00 00       	call   800411 <cprintf>
		exit();
  8002c9:	e8 4e 00 00 00       	call   80031c <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e1:	e8 05 0b 00 00       	call   800deb <sys_getenvid>
  8002e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f3:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	85 db                	test   %ebx,%ebx
  8002fa:	7e 07                	jle    800303 <libmain+0x2d>
		binaryname = argv[0];
  8002fc:	8b 06                	mov    (%esi),%eax
  8002fe:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	e8 26 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030d:	e8 0a 00 00 00       	call   80031c <exit>
}
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <exit>:

#include <inc/lib.h>

void exit(void)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800322:	e8 86 11 00 00       	call   8014ad <close_all>
	sys_env_destroy(0);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	e8 79 0a 00 00       	call   800daa <sys_env_destroy>
}
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	c9                   	leave  
  800335:	c3                   	ret    

00800336 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80033b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80033e:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800344:	e8 a2 0a 00 00       	call   800deb <sys_getenvid>
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	56                   	push   %esi
  800353:	50                   	push   %eax
  800354:	68 98 29 80 00       	push   $0x802998
  800359:	e8 b3 00 00 00       	call   800411 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035e:	83 c4 18             	add    $0x18,%esp
  800361:	53                   	push   %ebx
  800362:	ff 75 10             	pushl  0x10(%ebp)
  800365:	e8 56 00 00 00       	call   8003c0 <vcprintf>
	cprintf("\n");
  80036a:	c7 04 24 89 28 80 00 	movl   $0x802889,(%esp)
  800371:	e8 9b 00 00 00       	call   800411 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800379:	cc                   	int3   
  80037a:	eb fd                	jmp    800379 <_panic+0x43>

0080037c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	53                   	push   %ebx
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800386:	8b 13                	mov    (%ebx),%edx
  800388:	8d 42 01             	lea    0x1(%edx),%eax
  80038b:	89 03                	mov    %eax,(%ebx)
  80038d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800390:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800394:	3d ff 00 00 00       	cmp    $0xff,%eax
  800399:	74 09                	je     8003a4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80039b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80039f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	68 ff 00 00 00       	push   $0xff
  8003ac:	8d 43 08             	lea    0x8(%ebx),%eax
  8003af:	50                   	push   %eax
  8003b0:	e8 b8 09 00 00       	call   800d6d <sys_cputs>
		b->idx = 0;
  8003b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	eb db                	jmp    80039b <putch+0x1f>

008003c0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d0:	00 00 00 
	b.cnt = 0;
  8003d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003dd:	ff 75 0c             	pushl  0xc(%ebp)
  8003e0:	ff 75 08             	pushl  0x8(%ebp)
  8003e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e9:	50                   	push   %eax
  8003ea:	68 7c 03 80 00       	push   $0x80037c
  8003ef:	e8 1a 01 00 00       	call   80050e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f4:	83 c4 08             	add    $0x8,%esp
  8003f7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003fd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800403:	50                   	push   %eax
  800404:	e8 64 09 00 00       	call   800d6d <sys_cputs>

	return b.cnt;
}
  800409:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80040f:	c9                   	leave  
  800410:	c3                   	ret    

00800411 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800417:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80041a:	50                   	push   %eax
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 9d ff ff ff       	call   8003c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	57                   	push   %edi
  800429:	56                   	push   %esi
  80042a:	53                   	push   %ebx
  80042b:	83 ec 1c             	sub    $0x1c,%esp
  80042e:	89 c7                	mov    %eax,%edi
  800430:	89 d6                	mov    %edx,%esi
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 55 0c             	mov    0xc(%ebp),%edx
  800438:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800441:	bb 00 00 00 00       	mov    $0x0,%ebx
  800446:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80044c:	39 d3                	cmp    %edx,%ebx
  80044e:	72 05                	jb     800455 <printnum+0x30>
  800450:	39 45 10             	cmp    %eax,0x10(%ebp)
  800453:	77 7a                	ja     8004cf <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	ff 75 18             	pushl  0x18(%ebp)
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800461:	53                   	push   %ebx
  800462:	ff 75 10             	pushl  0x10(%ebp)
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046b:	ff 75 e0             	pushl  -0x20(%ebp)
  80046e:	ff 75 dc             	pushl  -0x24(%ebp)
  800471:	ff 75 d8             	pushl  -0x28(%ebp)
  800474:	e8 87 21 00 00       	call   802600 <__udivdi3>
  800479:	83 c4 18             	add    $0x18,%esp
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	89 f2                	mov    %esi,%edx
  800480:	89 f8                	mov    %edi,%eax
  800482:	e8 9e ff ff ff       	call   800425 <printnum>
  800487:	83 c4 20             	add    $0x20,%esp
  80048a:	eb 13                	jmp    80049f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	56                   	push   %esi
  800490:	ff 75 18             	pushl  0x18(%ebp)
  800493:	ff d7                	call   *%edi
  800495:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800498:	83 eb 01             	sub    $0x1,%ebx
  80049b:	85 db                	test   %ebx,%ebx
  80049d:	7f ed                	jg     80048c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	56                   	push   %esi
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8004af:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b2:	e8 69 22 00 00       	call   802720 <__umoddi3>
  8004b7:	83 c4 14             	add    $0x14,%esp
  8004ba:	0f be 80 bb 29 80 00 	movsbl 0x8029bb(%eax),%eax
  8004c1:	50                   	push   %eax
  8004c2:	ff d7                	call   *%edi
}
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ca:	5b                   	pop    %ebx
  8004cb:	5e                   	pop    %esi
  8004cc:	5f                   	pop    %edi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    
  8004cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004d2:	eb c4                	jmp    800498 <printnum+0x73>

008004d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004da:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004de:	8b 10                	mov    (%eax),%edx
  8004e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e3:	73 0a                	jae    8004ef <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e8:	89 08                	mov    %ecx,(%eax)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	88 02                	mov    %al,(%edx)
}
  8004ef:	5d                   	pop    %ebp
  8004f0:	c3                   	ret    

008004f1 <printfmt>:
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004fa:	50                   	push   %eax
  8004fb:	ff 75 10             	pushl  0x10(%ebp)
  8004fe:	ff 75 0c             	pushl  0xc(%ebp)
  800501:	ff 75 08             	pushl  0x8(%ebp)
  800504:	e8 05 00 00 00       	call   80050e <vprintfmt>
}
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vprintfmt>:
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	57                   	push   %edi
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 2c             	sub    $0x2c,%esp
  800517:	8b 75 08             	mov    0x8(%ebp),%esi
  80051a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800520:	e9 c1 03 00 00       	jmp    8008e6 <vprintfmt+0x3d8>
		padc = ' ';
  800525:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800529:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800530:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800537:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80053e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8d 47 01             	lea    0x1(%edi),%eax
  800546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800549:	0f b6 17             	movzbl (%edi),%edx
  80054c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80054f:	3c 55                	cmp    $0x55,%al
  800551:	0f 87 12 04 00 00    	ja     800969 <vprintfmt+0x45b>
  800557:	0f b6 c0             	movzbl %al,%eax
  80055a:	ff 24 85 00 2b 80 00 	jmp    *0x802b00(,%eax,4)
  800561:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800564:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800568:	eb d9                	jmp    800543 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80056d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800571:	eb d0                	jmp    800543 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800573:	0f b6 d2             	movzbl %dl,%edx
  800576:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800581:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800584:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800588:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80058e:	83 f9 09             	cmp    $0x9,%ecx
  800591:	77 55                	ja     8005e8 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800593:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800596:	eb e9                	jmp    800581 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 40 04             	lea    0x4(%eax),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b0:	79 91                	jns    800543 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005bf:	eb 82                	jmp    800543 <vprintfmt+0x35>
  8005c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	0f 49 d0             	cmovns %eax,%edx
  8005ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d4:	e9 6a ff ff ff       	jmp    800543 <vprintfmt+0x35>
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005dc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005e3:	e9 5b ff ff ff       	jmp    800543 <vprintfmt+0x35>
  8005e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ee:	eb bc                	jmp    8005ac <vprintfmt+0x9e>
			lflag++;
  8005f0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f6:	e9 48 ff ff ff       	jmp    800543 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 78 04             	lea    0x4(%eax),%edi
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	53                   	push   %ebx
  800605:	ff 30                	pushl  (%eax)
  800607:	ff d6                	call   *%esi
			break;
  800609:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80060c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80060f:	e9 cf 02 00 00       	jmp    8008e3 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 78 04             	lea    0x4(%eax),%edi
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	99                   	cltd   
  80061d:	31 d0                	xor    %edx,%eax
  80061f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800621:	83 f8 0f             	cmp    $0xf,%eax
  800624:	7f 23                	jg     800649 <vprintfmt+0x13b>
  800626:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  80062d:	85 d2                	test   %edx,%edx
  80062f:	74 18                	je     800649 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800631:	52                   	push   %edx
  800632:	68 85 2e 80 00       	push   $0x802e85
  800637:	53                   	push   %ebx
  800638:	56                   	push   %esi
  800639:	e8 b3 fe ff ff       	call   8004f1 <printfmt>
  80063e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800641:	89 7d 14             	mov    %edi,0x14(%ebp)
  800644:	e9 9a 02 00 00       	jmp    8008e3 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800649:	50                   	push   %eax
  80064a:	68 d3 29 80 00       	push   $0x8029d3
  80064f:	53                   	push   %ebx
  800650:	56                   	push   %esi
  800651:	e8 9b fe ff ff       	call   8004f1 <printfmt>
  800656:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800659:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80065c:	e9 82 02 00 00       	jmp    8008e3 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 c0 04             	add    $0x4,%eax
  800667:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80066f:	85 ff                	test   %edi,%edi
  800671:	b8 cc 29 80 00       	mov    $0x8029cc,%eax
  800676:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800679:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067d:	0f 8e bd 00 00 00    	jle    800740 <vprintfmt+0x232>
  800683:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800687:	75 0e                	jne    800697 <vprintfmt+0x189>
  800689:	89 75 08             	mov    %esi,0x8(%ebp)
  80068c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80068f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800692:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800695:	eb 6d                	jmp    800704 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 d0             	pushl  -0x30(%ebp)
  80069d:	57                   	push   %edi
  80069e:	e8 6e 03 00 00       	call   800a11 <strnlen>
  8006a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006a6:	29 c1                	sub    %eax,%ecx
  8006a8:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006ab:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006ae:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006b8:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c5:	83 ef 01             	sub    $0x1,%edi
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	85 ff                	test   %edi,%edi
  8006cd:	7f ed                	jg     8006bc <vprintfmt+0x1ae>
  8006cf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006d2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d5:	85 c9                	test   %ecx,%ecx
  8006d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006dc:	0f 49 c1             	cmovns %ecx,%eax
  8006df:	29 c1                	sub    %eax,%ecx
  8006e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8006e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006e7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006ea:	89 cb                	mov    %ecx,%ebx
  8006ec:	eb 16                	jmp    800704 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f2:	75 31                	jne    800725 <vprintfmt+0x217>
					putch(ch, putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	ff 55 08             	call   *0x8(%ebp)
  8006fe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800701:	83 eb 01             	sub    $0x1,%ebx
  800704:	83 c7 01             	add    $0x1,%edi
  800707:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80070b:	0f be c2             	movsbl %dl,%eax
  80070e:	85 c0                	test   %eax,%eax
  800710:	74 59                	je     80076b <vprintfmt+0x25d>
  800712:	85 f6                	test   %esi,%esi
  800714:	78 d8                	js     8006ee <vprintfmt+0x1e0>
  800716:	83 ee 01             	sub    $0x1,%esi
  800719:	79 d3                	jns    8006ee <vprintfmt+0x1e0>
  80071b:	89 df                	mov    %ebx,%edi
  80071d:	8b 75 08             	mov    0x8(%ebp),%esi
  800720:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800723:	eb 37                	jmp    80075c <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800725:	0f be d2             	movsbl %dl,%edx
  800728:	83 ea 20             	sub    $0x20,%edx
  80072b:	83 fa 5e             	cmp    $0x5e,%edx
  80072e:	76 c4                	jbe    8006f4 <vprintfmt+0x1e6>
					putch('?', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	6a 3f                	push   $0x3f
  800738:	ff 55 08             	call   *0x8(%ebp)
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	eb c1                	jmp    800701 <vprintfmt+0x1f3>
  800740:	89 75 08             	mov    %esi,0x8(%ebp)
  800743:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800746:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800749:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80074c:	eb b6                	jmp    800704 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 20                	push   $0x20
  800754:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800756:	83 ef 01             	sub    $0x1,%edi
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 ff                	test   %edi,%edi
  80075e:	7f ee                	jg     80074e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800760:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
  800766:	e9 78 01 00 00       	jmp    8008e3 <vprintfmt+0x3d5>
  80076b:	89 df                	mov    %ebx,%edi
  80076d:	8b 75 08             	mov    0x8(%ebp),%esi
  800770:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800773:	eb e7                	jmp    80075c <vprintfmt+0x24e>
	if (lflag >= 2)
  800775:	83 f9 01             	cmp    $0x1,%ecx
  800778:	7e 3f                	jle    8007b9 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 50 04             	mov    0x4(%eax),%edx
  800780:	8b 00                	mov    (%eax),%eax
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800785:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 08             	lea    0x8(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800791:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800795:	79 5c                	jns    8007f3 <vprintfmt+0x2e5>
				putch('-', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	6a 2d                	push   $0x2d
  80079d:	ff d6                	call   *%esi
				num = -(long long) num;
  80079f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007a5:	f7 da                	neg    %edx
  8007a7:	83 d1 00             	adc    $0x0,%ecx
  8007aa:	f7 d9                	neg    %ecx
  8007ac:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b4:	e9 10 01 00 00       	jmp    8008c9 <vprintfmt+0x3bb>
	else if (lflag)
  8007b9:	85 c9                	test   %ecx,%ecx
  8007bb:	75 1b                	jne    8007d8 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c5:	89 c1                	mov    %eax,%ecx
  8007c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d6:	eb b9                	jmp    800791 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 c1                	mov    %eax,%ecx
  8007e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	eb 9e                	jmp    800791 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007f6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fe:	e9 c6 00 00 00       	jmp    8008c9 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800803:	83 f9 01             	cmp    $0x1,%ecx
  800806:	7e 18                	jle    800820 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	8b 48 04             	mov    0x4(%eax),%ecx
  800810:	8d 40 08             	lea    0x8(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800816:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081b:	e9 a9 00 00 00       	jmp    8008c9 <vprintfmt+0x3bb>
	else if (lflag)
  800820:	85 c9                	test   %ecx,%ecx
  800822:	75 1a                	jne    80083e <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 10                	mov    (%eax),%edx
  800829:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082e:	8d 40 04             	lea    0x4(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800834:	b8 0a 00 00 00       	mov    $0xa,%eax
  800839:	e9 8b 00 00 00       	jmp    8008c9 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8b 10                	mov    (%eax),%edx
  800843:	b9 00 00 00 00       	mov    $0x0,%ecx
  800848:	8d 40 04             	lea    0x4(%eax),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800853:	eb 74                	jmp    8008c9 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800855:	83 f9 01             	cmp    $0x1,%ecx
  800858:	7e 15                	jle    80086f <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 10                	mov    (%eax),%edx
  80085f:	8b 48 04             	mov    0x4(%eax),%ecx
  800862:	8d 40 08             	lea    0x8(%eax),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800868:	b8 08 00 00 00       	mov    $0x8,%eax
  80086d:	eb 5a                	jmp    8008c9 <vprintfmt+0x3bb>
	else if (lflag)
  80086f:	85 c9                	test   %ecx,%ecx
  800871:	75 17                	jne    80088a <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 10                	mov    (%eax),%edx
  800878:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800883:	b8 08 00 00 00       	mov    $0x8,%eax
  800888:	eb 3f                	jmp    8008c9 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	8b 10                	mov    (%eax),%edx
  80088f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800894:	8d 40 04             	lea    0x4(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80089a:	b8 08 00 00 00       	mov    $0x8,%eax
  80089f:	eb 28                	jmp    8008c9 <vprintfmt+0x3bb>
			putch('0', putdat);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	53                   	push   %ebx
  8008a5:	6a 30                	push   $0x30
  8008a7:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a9:	83 c4 08             	add    $0x8,%esp
  8008ac:	53                   	push   %ebx
  8008ad:	6a 78                	push   $0x78
  8008af:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 10                	mov    (%eax),%edx
  8008b6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008bb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008be:	8d 40 04             	lea    0x4(%eax),%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008d0:	57                   	push   %edi
  8008d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	51                   	push   %ecx
  8008d6:	52                   	push   %edx
  8008d7:	89 da                	mov    %ebx,%edx
  8008d9:	89 f0                	mov    %esi,%eax
  8008db:	e8 45 fb ff ff       	call   800425 <printnum>
			break;
  8008e0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e6:	83 c7 01             	add    $0x1,%edi
  8008e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ed:	83 f8 25             	cmp    $0x25,%eax
  8008f0:	0f 84 2f fc ff ff    	je     800525 <vprintfmt+0x17>
			if (ch == '\0')
  8008f6:	85 c0                	test   %eax,%eax
  8008f8:	0f 84 8b 00 00 00    	je     800989 <vprintfmt+0x47b>
			putch(ch, putdat);
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	53                   	push   %ebx
  800902:	50                   	push   %eax
  800903:	ff d6                	call   *%esi
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	eb dc                	jmp    8008e6 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80090a:	83 f9 01             	cmp    $0x1,%ecx
  80090d:	7e 15                	jle    800924 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	8b 10                	mov    (%eax),%edx
  800914:	8b 48 04             	mov    0x4(%eax),%ecx
  800917:	8d 40 08             	lea    0x8(%eax),%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091d:	b8 10 00 00 00       	mov    $0x10,%eax
  800922:	eb a5                	jmp    8008c9 <vprintfmt+0x3bb>
	else if (lflag)
  800924:	85 c9                	test   %ecx,%ecx
  800926:	75 17                	jne    80093f <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8b 10                	mov    (%eax),%edx
  80092d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800932:	8d 40 04             	lea    0x4(%eax),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800938:	b8 10 00 00 00       	mov    $0x10,%eax
  80093d:	eb 8a                	jmp    8008c9 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8b 10                	mov    (%eax),%edx
  800944:	b9 00 00 00 00       	mov    $0x0,%ecx
  800949:	8d 40 04             	lea    0x4(%eax),%eax
  80094c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094f:	b8 10 00 00 00       	mov    $0x10,%eax
  800954:	e9 70 ff ff ff       	jmp    8008c9 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	53                   	push   %ebx
  80095d:	6a 25                	push   $0x25
  80095f:	ff d6                	call   *%esi
			break;
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	e9 7a ff ff ff       	jmp    8008e3 <vprintfmt+0x3d5>
			putch('%', putdat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	53                   	push   %ebx
  80096d:	6a 25                	push   $0x25
  80096f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800971:	83 c4 10             	add    $0x10,%esp
  800974:	89 f8                	mov    %edi,%eax
  800976:	eb 03                	jmp    80097b <vprintfmt+0x46d>
  800978:	83 e8 01             	sub    $0x1,%eax
  80097b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80097f:	75 f7                	jne    800978 <vprintfmt+0x46a>
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	e9 5a ff ff ff       	jmp    8008e3 <vprintfmt+0x3d5>
}
  800989:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5f                   	pop    %edi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 18             	sub    $0x18,%esp
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80099d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ae:	85 c0                	test   %eax,%eax
  8009b0:	74 26                	je     8009d8 <vsnprintf+0x47>
  8009b2:	85 d2                	test   %edx,%edx
  8009b4:	7e 22                	jle    8009d8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b6:	ff 75 14             	pushl  0x14(%ebp)
  8009b9:	ff 75 10             	pushl  0x10(%ebp)
  8009bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009bf:	50                   	push   %eax
  8009c0:	68 d4 04 80 00       	push   $0x8004d4
  8009c5:	e8 44 fb ff ff       	call   80050e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
}
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    
		return -E_INVAL;
  8009d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009dd:	eb f7                	jmp    8009d6 <vsnprintf+0x45>

008009df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e8:	50                   	push   %eax
  8009e9:	ff 75 10             	pushl  0x10(%ebp)
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	ff 75 08             	pushl  0x8(%ebp)
  8009f2:	e8 9a ff ff ff       	call   800991 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800a04:	eb 03                	jmp    800a09 <strlen+0x10>
		n++;
  800a06:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a09:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a0d:	75 f7                	jne    800a06 <strlen+0xd>
	return n;
}
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a17:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1f:	eb 03                	jmp    800a24 <strnlen+0x13>
		n++;
  800a21:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a24:	39 d0                	cmp    %edx,%eax
  800a26:	74 06                	je     800a2e <strnlen+0x1d>
  800a28:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a2c:	75 f3                	jne    800a21 <strnlen+0x10>
	return n;
}
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	53                   	push   %ebx
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a3a:	89 c2                	mov    %eax,%edx
  800a3c:	83 c1 01             	add    $0x1,%ecx
  800a3f:	83 c2 01             	add    $0x1,%edx
  800a42:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a46:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a49:	84 db                	test   %bl,%bl
  800a4b:	75 ef                	jne    800a3c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	53                   	push   %ebx
  800a54:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a57:	53                   	push   %ebx
  800a58:	e8 9c ff ff ff       	call   8009f9 <strlen>
  800a5d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a60:	ff 75 0c             	pushl  0xc(%ebp)
  800a63:	01 d8                	add    %ebx,%eax
  800a65:	50                   	push   %eax
  800a66:	e8 c5 ff ff ff       	call   800a30 <strcpy>
	return dst;
}
  800a6b:	89 d8                	mov    %ebx,%eax
  800a6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
  800a77:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7d:	89 f3                	mov    %esi,%ebx
  800a7f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a82:	89 f2                	mov    %esi,%edx
  800a84:	eb 0f                	jmp    800a95 <strncpy+0x23>
		*dst++ = *src;
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	0f b6 01             	movzbl (%ecx),%eax
  800a8c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a8f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a92:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a95:	39 da                	cmp    %ebx,%edx
  800a97:	75 ed                	jne    800a86 <strncpy+0x14>
	}
	return ret;
}
  800a99:	89 f0                	mov    %esi,%eax
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	56                   	push   %esi
  800aa3:	53                   	push   %ebx
  800aa4:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aad:	89 f0                	mov    %esi,%eax
  800aaf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab3:	85 c9                	test   %ecx,%ecx
  800ab5:	75 0b                	jne    800ac2 <strlcpy+0x23>
  800ab7:	eb 17                	jmp    800ad0 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ab9:	83 c2 01             	add    $0x1,%edx
  800abc:	83 c0 01             	add    $0x1,%eax
  800abf:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ac2:	39 d8                	cmp    %ebx,%eax
  800ac4:	74 07                	je     800acd <strlcpy+0x2e>
  800ac6:	0f b6 0a             	movzbl (%edx),%ecx
  800ac9:	84 c9                	test   %cl,%cl
  800acb:	75 ec                	jne    800ab9 <strlcpy+0x1a>
		*dst = '\0';
  800acd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad0:	29 f0                	sub    %esi,%eax
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800adc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800adf:	eb 06                	jmp    800ae7 <strcmp+0x11>
		p++, q++;
  800ae1:	83 c1 01             	add    $0x1,%ecx
  800ae4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ae7:	0f b6 01             	movzbl (%ecx),%eax
  800aea:	84 c0                	test   %al,%al
  800aec:	74 04                	je     800af2 <strcmp+0x1c>
  800aee:	3a 02                	cmp    (%edx),%al
  800af0:	74 ef                	je     800ae1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af2:	0f b6 c0             	movzbl %al,%eax
  800af5:	0f b6 12             	movzbl (%edx),%edx
  800af8:	29 d0                	sub    %edx,%eax
}
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	53                   	push   %ebx
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b06:	89 c3                	mov    %eax,%ebx
  800b08:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b0b:	eb 06                	jmp    800b13 <strncmp+0x17>
		n--, p++, q++;
  800b0d:	83 c0 01             	add    $0x1,%eax
  800b10:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b13:	39 d8                	cmp    %ebx,%eax
  800b15:	74 16                	je     800b2d <strncmp+0x31>
  800b17:	0f b6 08             	movzbl (%eax),%ecx
  800b1a:	84 c9                	test   %cl,%cl
  800b1c:	74 04                	je     800b22 <strncmp+0x26>
  800b1e:	3a 0a                	cmp    (%edx),%cl
  800b20:	74 eb                	je     800b0d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b22:	0f b6 00             	movzbl (%eax),%eax
  800b25:	0f b6 12             	movzbl (%edx),%edx
  800b28:	29 d0                	sub    %edx,%eax
}
  800b2a:	5b                   	pop    %ebx
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    
		return 0;
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b32:	eb f6                	jmp    800b2a <strncmp+0x2e>

00800b34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b3e:	0f b6 10             	movzbl (%eax),%edx
  800b41:	84 d2                	test   %dl,%dl
  800b43:	74 09                	je     800b4e <strchr+0x1a>
		if (*s == c)
  800b45:	38 ca                	cmp    %cl,%dl
  800b47:	74 0a                	je     800b53 <strchr+0x1f>
	for (; *s; s++)
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	eb f0                	jmp    800b3e <strchr+0xa>
			return (char *) s;
	return 0;
  800b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5f:	eb 03                	jmp    800b64 <strfind+0xf>
  800b61:	83 c0 01             	add    $0x1,%eax
  800b64:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b67:	38 ca                	cmp    %cl,%dl
  800b69:	74 04                	je     800b6f <strfind+0x1a>
  800b6b:	84 d2                	test   %dl,%dl
  800b6d:	75 f2                	jne    800b61 <strfind+0xc>
			break;
	return (char *) s;
}
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	57                   	push   %edi
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
  800b77:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b7d:	85 c9                	test   %ecx,%ecx
  800b7f:	74 13                	je     800b94 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b81:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b87:	75 05                	jne    800b8e <memset+0x1d>
  800b89:	f6 c1 03             	test   $0x3,%cl
  800b8c:	74 0d                	je     800b9b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	fc                   	cld    
  800b92:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b94:	89 f8                	mov    %edi,%eax
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5f                   	pop    %edi
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    
		c &= 0xFF;
  800b9b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b9f:	89 d3                	mov    %edx,%ebx
  800ba1:	c1 e3 08             	shl    $0x8,%ebx
  800ba4:	89 d0                	mov    %edx,%eax
  800ba6:	c1 e0 18             	shl    $0x18,%eax
  800ba9:	89 d6                	mov    %edx,%esi
  800bab:	c1 e6 10             	shl    $0x10,%esi
  800bae:	09 f0                	or     %esi,%eax
  800bb0:	09 c2                	or     %eax,%edx
  800bb2:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bb4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bb7:	89 d0                	mov    %edx,%eax
  800bb9:	fc                   	cld    
  800bba:	f3 ab                	rep stos %eax,%es:(%edi)
  800bbc:	eb d6                	jmp    800b94 <memset+0x23>

00800bbe <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bcc:	39 c6                	cmp    %eax,%esi
  800bce:	73 35                	jae    800c05 <memmove+0x47>
  800bd0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd3:	39 c2                	cmp    %eax,%edx
  800bd5:	76 2e                	jbe    800c05 <memmove+0x47>
		s += n;
		d += n;
  800bd7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bda:	89 d6                	mov    %edx,%esi
  800bdc:	09 fe                	or     %edi,%esi
  800bde:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be4:	74 0c                	je     800bf2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800be6:	83 ef 01             	sub    $0x1,%edi
  800be9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bec:	fd                   	std    
  800bed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bef:	fc                   	cld    
  800bf0:	eb 21                	jmp    800c13 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf2:	f6 c1 03             	test   $0x3,%cl
  800bf5:	75 ef                	jne    800be6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf7:	83 ef 04             	sub    $0x4,%edi
  800bfa:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bfd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c00:	fd                   	std    
  800c01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c03:	eb ea                	jmp    800bef <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c05:	89 f2                	mov    %esi,%edx
  800c07:	09 c2                	or     %eax,%edx
  800c09:	f6 c2 03             	test   $0x3,%dl
  800c0c:	74 09                	je     800c17 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c0e:	89 c7                	mov    %eax,%edi
  800c10:	fc                   	cld    
  800c11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c17:	f6 c1 03             	test   $0x3,%cl
  800c1a:	75 f2                	jne    800c0e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c1c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c1f:	89 c7                	mov    %eax,%edi
  800c21:	fc                   	cld    
  800c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c24:	eb ed                	jmp    800c13 <memmove+0x55>

00800c26 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c29:	ff 75 10             	pushl  0x10(%ebp)
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	ff 75 08             	pushl  0x8(%ebp)
  800c32:	e8 87 ff ff ff       	call   800bbe <memmove>
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	56                   	push   %esi
  800c3d:	53                   	push   %ebx
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	89 c6                	mov    %eax,%esi
  800c46:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c49:	39 f0                	cmp    %esi,%eax
  800c4b:	74 1c                	je     800c69 <memcmp+0x30>
		if (*s1 != *s2)
  800c4d:	0f b6 08             	movzbl (%eax),%ecx
  800c50:	0f b6 1a             	movzbl (%edx),%ebx
  800c53:	38 d9                	cmp    %bl,%cl
  800c55:	75 08                	jne    800c5f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c57:	83 c0 01             	add    $0x1,%eax
  800c5a:	83 c2 01             	add    $0x1,%edx
  800c5d:	eb ea                	jmp    800c49 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c5f:	0f b6 c1             	movzbl %cl,%eax
  800c62:	0f b6 db             	movzbl %bl,%ebx
  800c65:	29 d8                	sub    %ebx,%eax
  800c67:	eb 05                	jmp    800c6e <memcmp+0x35>
	}

	return 0;
  800c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c7b:	89 c2                	mov    %eax,%edx
  800c7d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c80:	39 d0                	cmp    %edx,%eax
  800c82:	73 09                	jae    800c8d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c84:	38 08                	cmp    %cl,(%eax)
  800c86:	74 05                	je     800c8d <memfind+0x1b>
	for (; s < ends; s++)
  800c88:	83 c0 01             	add    $0x1,%eax
  800c8b:	eb f3                	jmp    800c80 <memfind+0xe>
			break;
	return (void *) s;
}
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c9b:	eb 03                	jmp    800ca0 <strtol+0x11>
		s++;
  800c9d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ca0:	0f b6 01             	movzbl (%ecx),%eax
  800ca3:	3c 20                	cmp    $0x20,%al
  800ca5:	74 f6                	je     800c9d <strtol+0xe>
  800ca7:	3c 09                	cmp    $0x9,%al
  800ca9:	74 f2                	je     800c9d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cab:	3c 2b                	cmp    $0x2b,%al
  800cad:	74 2e                	je     800cdd <strtol+0x4e>
	int neg = 0;
  800caf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cb4:	3c 2d                	cmp    $0x2d,%al
  800cb6:	74 2f                	je     800ce7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cbe:	75 05                	jne    800cc5 <strtol+0x36>
  800cc0:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc3:	74 2c                	je     800cf1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc5:	85 db                	test   %ebx,%ebx
  800cc7:	75 0a                	jne    800cd3 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc9:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cce:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd1:	74 28                	je     800cfb <strtol+0x6c>
		base = 10;
  800cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cdb:	eb 50                	jmp    800d2d <strtol+0x9e>
		s++;
  800cdd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce5:	eb d1                	jmp    800cb8 <strtol+0x29>
		s++, neg = 1;
  800ce7:	83 c1 01             	add    $0x1,%ecx
  800cea:	bf 01 00 00 00       	mov    $0x1,%edi
  800cef:	eb c7                	jmp    800cb8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cf5:	74 0e                	je     800d05 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cf7:	85 db                	test   %ebx,%ebx
  800cf9:	75 d8                	jne    800cd3 <strtol+0x44>
		s++, base = 8;
  800cfb:	83 c1 01             	add    $0x1,%ecx
  800cfe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d03:	eb ce                	jmp    800cd3 <strtol+0x44>
		s += 2, base = 16;
  800d05:	83 c1 02             	add    $0x2,%ecx
  800d08:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d0d:	eb c4                	jmp    800cd3 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d0f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d12:	89 f3                	mov    %esi,%ebx
  800d14:	80 fb 19             	cmp    $0x19,%bl
  800d17:	77 29                	ja     800d42 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d19:	0f be d2             	movsbl %dl,%edx
  800d1c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d1f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d22:	7d 30                	jge    800d54 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d24:	83 c1 01             	add    $0x1,%ecx
  800d27:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d2b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d2d:	0f b6 11             	movzbl (%ecx),%edx
  800d30:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d33:	89 f3                	mov    %esi,%ebx
  800d35:	80 fb 09             	cmp    $0x9,%bl
  800d38:	77 d5                	ja     800d0f <strtol+0x80>
			dig = *s - '0';
  800d3a:	0f be d2             	movsbl %dl,%edx
  800d3d:	83 ea 30             	sub    $0x30,%edx
  800d40:	eb dd                	jmp    800d1f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d42:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d45:	89 f3                	mov    %esi,%ebx
  800d47:	80 fb 19             	cmp    $0x19,%bl
  800d4a:	77 08                	ja     800d54 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d4c:	0f be d2             	movsbl %dl,%edx
  800d4f:	83 ea 37             	sub    $0x37,%edx
  800d52:	eb cb                	jmp    800d1f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d58:	74 05                	je     800d5f <strtol+0xd0>
		*endptr = (char *) s;
  800d5a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d5d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d5f:	89 c2                	mov    %eax,%edx
  800d61:	f7 da                	neg    %edx
  800d63:	85 ff                	test   %edi,%edi
  800d65:	0f 45 c2             	cmovne %edx,%eax
}
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	89 c3                	mov    %eax,%ebx
  800d80:	89 c7                	mov    %eax,%edi
  800d82:	89 c6                	mov    %eax,%esi
  800d84:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <sys_cgetc>:

int
sys_cgetc(void)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d91:	ba 00 00 00 00       	mov    $0x0,%edx
  800d96:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9b:	89 d1                	mov    %edx,%ecx
  800d9d:	89 d3                	mov    %edx,%ebx
  800d9f:	89 d7                	mov    %edx,%edi
  800da1:	89 d6                	mov    %edx,%esi
  800da3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc0:	89 cb                	mov    %ecx,%ebx
  800dc2:	89 cf                	mov    %ecx,%edi
  800dc4:	89 ce                	mov    %ecx,%esi
  800dc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7f 08                	jg     800dd4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	50                   	push   %eax
  800dd8:	6a 03                	push   $0x3
  800dda:	68 bf 2c 80 00       	push   $0x802cbf
  800ddf:	6a 23                	push   $0x23
  800de1:	68 dc 2c 80 00       	push   $0x802cdc
  800de6:	e8 4b f5 ff ff       	call   800336 <_panic>

00800deb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df1:	ba 00 00 00 00       	mov    $0x0,%edx
  800df6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dfb:	89 d1                	mov    %edx,%ecx
  800dfd:	89 d3                	mov    %edx,%ebx
  800dff:	89 d7                	mov    %edx,%edi
  800e01:	89 d6                	mov    %edx,%esi
  800e03:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_yield>:

void
sys_yield(void)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e10:	ba 00 00 00 00       	mov    $0x0,%edx
  800e15:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e1a:	89 d1                	mov    %edx,%ecx
  800e1c:	89 d3                	mov    %edx,%ebx
  800e1e:	89 d7                	mov    %edx,%edi
  800e20:	89 d6                	mov    %edx,%esi
  800e22:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e32:	be 00 00 00 00       	mov    $0x0,%esi
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e45:	89 f7                	mov    %esi,%edi
  800e47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	7f 08                	jg     800e55 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	50                   	push   %eax
  800e59:	6a 04                	push   $0x4
  800e5b:	68 bf 2c 80 00       	push   $0x802cbf
  800e60:	6a 23                	push   $0x23
  800e62:	68 dc 2c 80 00       	push   $0x802cdc
  800e67:	e8 ca f4 ff ff       	call   800336 <_panic>

00800e6c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	b8 05 00 00 00       	mov    $0x5,%eax
  800e80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e83:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e86:	8b 75 18             	mov    0x18(%ebp),%esi
  800e89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	7f 08                	jg     800e97 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	50                   	push   %eax
  800e9b:	6a 05                	push   $0x5
  800e9d:	68 bf 2c 80 00       	push   $0x802cbf
  800ea2:	6a 23                	push   $0x23
  800ea4:	68 dc 2c 80 00       	push   $0x802cdc
  800ea9:	e8 88 f4 ff ff       	call   800336 <_panic>

00800eae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec7:	89 df                	mov    %ebx,%edi
  800ec9:	89 de                	mov    %ebx,%esi
  800ecb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	7f 08                	jg     800ed9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed9:	83 ec 0c             	sub    $0xc,%esp
  800edc:	50                   	push   %eax
  800edd:	6a 06                	push   $0x6
  800edf:	68 bf 2c 80 00       	push   $0x802cbf
  800ee4:	6a 23                	push   $0x23
  800ee6:	68 dc 2c 80 00       	push   $0x802cdc
  800eeb:	e8 46 f4 ff ff       	call   800336 <_panic>

00800ef0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f04:	b8 08 00 00 00       	mov    $0x8,%eax
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	89 de                	mov    %ebx,%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 08                	push   $0x8
  800f21:	68 bf 2c 80 00       	push   $0x802cbf
  800f26:	6a 23                	push   $0x23
  800f28:	68 dc 2c 80 00       	push   $0x802cdc
  800f2d:	e8 04 f4 ff ff       	call   800336 <_panic>

00800f32 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f46:	b8 09 00 00 00       	mov    $0x9,%eax
  800f4b:	89 df                	mov    %ebx,%edi
  800f4d:	89 de                	mov    %ebx,%esi
  800f4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f51:	85 c0                	test   %eax,%eax
  800f53:	7f 08                	jg     800f5d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5d:	83 ec 0c             	sub    $0xc,%esp
  800f60:	50                   	push   %eax
  800f61:	6a 09                	push   $0x9
  800f63:	68 bf 2c 80 00       	push   $0x802cbf
  800f68:	6a 23                	push   $0x23
  800f6a:	68 dc 2c 80 00       	push   $0x802cdc
  800f6f:	e8 c2 f3 ff ff       	call   800336 <_panic>

00800f74 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	57                   	push   %edi
  800f78:	56                   	push   %esi
  800f79:	53                   	push   %ebx
  800f7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f88:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f8d:	89 df                	mov    %ebx,%edi
  800f8f:	89 de                	mov    %ebx,%esi
  800f91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	7f 08                	jg     800f9f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	50                   	push   %eax
  800fa3:	6a 0a                	push   $0xa
  800fa5:	68 bf 2c 80 00       	push   $0x802cbf
  800faa:	6a 23                	push   $0x23
  800fac:	68 dc 2c 80 00       	push   $0x802cdc
  800fb1:	e8 80 f3 ff ff       	call   800336 <_panic>

00800fb6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fc7:	be 00 00 00 00       	mov    $0x0,%esi
  800fcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fea:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fef:	89 cb                	mov    %ecx,%ebx
  800ff1:	89 cf                	mov    %ecx,%edi
  800ff3:	89 ce                	mov    %ecx,%esi
  800ff5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7f 08                	jg     801003 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	50                   	push   %eax
  801007:	6a 0d                	push   $0xd
  801009:	68 bf 2c 80 00       	push   $0x802cbf
  80100e:	6a 23                	push   $0x23
  801010:	68 dc 2c 80 00       	push   $0x802cdc
  801015:	e8 1c f3 ff ff       	call   800336 <_panic>

0080101a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801020:	ba 00 00 00 00       	mov    $0x0,%edx
  801025:	b8 0e 00 00 00       	mov    $0xe,%eax
  80102a:	89 d1                	mov    %edx,%ecx
  80102c:	89 d3                	mov    %edx,%ebx
  80102e:	89 d7                	mov    %edx,%edi
  801030:	89 d6                	mov    %edx,%esi
  801032:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801034:	5b                   	pop    %ebx
  801035:	5e                   	pop    %esi
  801036:	5f                   	pop    %edi
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  801041:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801043:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801047:	74 7f                	je     8010c8 <pgfault+0x8f>
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	c1 e8 0c             	shr    $0xc,%eax
  80104e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801055:	f6 c4 08             	test   $0x8,%ah
  801058:	74 6e                	je     8010c8 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  80105a:	e8 8c fd ff ff       	call   800deb <sys_getenvid>
  80105f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  801061:	83 ec 04             	sub    $0x4,%esp
  801064:	6a 07                	push   $0x7
  801066:	68 00 f0 7f 00       	push   $0x7ff000
  80106b:	50                   	push   %eax
  80106c:	e8 b8 fd ff ff       	call   800e29 <sys_page_alloc>
  801071:	83 c4 10             	add    $0x10,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	78 64                	js     8010dc <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  801078:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  80107e:	83 ec 04             	sub    $0x4,%esp
  801081:	68 00 10 00 00       	push   $0x1000
  801086:	53                   	push   %ebx
  801087:	68 00 f0 7f 00       	push   $0x7ff000
  80108c:	e8 2d fb ff ff       	call   800bbe <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  801091:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801098:	53                   	push   %ebx
  801099:	56                   	push   %esi
  80109a:	68 00 f0 7f 00       	push   $0x7ff000
  80109f:	56                   	push   %esi
  8010a0:	e8 c7 fd ff ff       	call   800e6c <sys_page_map>
  8010a5:	83 c4 20             	add    $0x20,%esp
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	78 42                	js     8010ee <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  8010ac:	83 ec 08             	sub    $0x8,%esp
  8010af:	68 00 f0 7f 00       	push   $0x7ff000
  8010b4:	56                   	push   %esi
  8010b5:	e8 f4 fd ff ff       	call   800eae <sys_page_unmap>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 3f                	js     801100 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  8010c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  8010c8:	83 ec 04             	sub    $0x4,%esp
  8010cb:	68 ec 2c 80 00       	push   $0x802cec
  8010d0:	6a 1d                	push   $0x1d
  8010d2:	68 7b 2d 80 00       	push   $0x802d7b
  8010d7:	e8 5a f2 ff ff       	call   800336 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  8010dc:	50                   	push   %eax
  8010dd:	68 14 2d 80 00       	push   $0x802d14
  8010e2:	6a 28                	push   $0x28
  8010e4:	68 7b 2d 80 00       	push   $0x802d7b
  8010e9:	e8 48 f2 ff ff       	call   800336 <_panic>
		panic("pgfault:page map failed: %e", r);
  8010ee:	50                   	push   %eax
  8010ef:	68 86 2d 80 00       	push   $0x802d86
  8010f4:	6a 2c                	push   $0x2c
  8010f6:	68 7b 2d 80 00       	push   $0x802d7b
  8010fb:	e8 36 f2 ff ff       	call   800336 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  801100:	50                   	push   %eax
  801101:	68 38 2d 80 00       	push   $0x802d38
  801106:	6a 2e                	push   $0x2e
  801108:	68 7b 2d 80 00       	push   $0x802d7b
  80110d:	e8 24 f2 ff ff       	call   800336 <_panic>

00801112 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	57                   	push   %edi
  801116:	56                   	push   %esi
  801117:	53                   	push   %ebx
  801118:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  80111b:	68 39 10 80 00       	push   $0x801039
  801120:	e8 21 13 00 00       	call   802446 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801125:	b8 07 00 00 00       	mov    $0x7,%eax
  80112a:	cd 30                	int    $0x30
  80112c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  80112f:	83 c4 10             	add    $0x10,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	78 2f                	js     801165 <fork+0x53>
  801136:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801138:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  80113d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801141:	75 6e                	jne    8011b1 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801143:	e8 a3 fc ff ff       	call   800deb <sys_getenvid>
  801148:	25 ff 03 00 00       	and    $0x3ff,%eax
  80114d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801150:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801155:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80115a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  80115d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801160:	5b                   	pop    %ebx
  801161:	5e                   	pop    %esi
  801162:	5f                   	pop    %edi
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  801165:	50                   	push   %eax
  801166:	68 58 2d 80 00       	push   $0x802d58
  80116b:	6a 6e                	push   $0x6e
  80116d:	68 7b 2d 80 00       	push   $0x802d7b
  801172:	e8 bf f1 ff ff       	call   800336 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801177:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80117e:	83 ec 0c             	sub    $0xc,%esp
  801181:	25 07 0e 00 00       	and    $0xe07,%eax
  801186:	50                   	push   %eax
  801187:	56                   	push   %esi
  801188:	57                   	push   %edi
  801189:	56                   	push   %esi
  80118a:	6a 00                	push   $0x0
  80118c:	e8 db fc ff ff       	call   800e6c <sys_page_map>
  801191:	83 c4 20             	add    $0x20,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	ba 00 00 00 00       	mov    $0x0,%edx
  80119b:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	78 bb                	js     80115d <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8011a2:	83 c3 01             	add    $0x1,%ebx
  8011a5:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8011ab:	0f 84 a6 00 00 00    	je     801257 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8011b1:	89 d8                	mov    %ebx,%eax
  8011b3:	c1 e8 0a             	shr    $0xa,%eax
  8011b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011bd:	a8 01                	test   $0x1,%al
  8011bf:	74 e1                	je     8011a2 <fork+0x90>
  8011c1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011c8:	a8 01                	test   $0x1,%al
  8011ca:	74 d6                	je     8011a2 <fork+0x90>
  8011cc:	89 de                	mov    %ebx,%esi
  8011ce:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  8011d1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011d8:	f6 c4 04             	test   $0x4,%ah
  8011db:	75 9a                	jne    801177 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  8011dd:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011e4:	a8 02                	test   $0x2,%al
  8011e6:	75 0c                	jne    8011f4 <fork+0xe2>
  8011e8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011ef:	f6 c4 08             	test   $0x8,%ah
  8011f2:	74 42                	je     801236 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	68 05 08 00 00       	push   $0x805
  8011fc:	56                   	push   %esi
  8011fd:	57                   	push   %edi
  8011fe:	56                   	push   %esi
  8011ff:	6a 00                	push   $0x0
  801201:	e8 66 fc ff ff       	call   800e6c <sys_page_map>
  801206:	83 c4 20             	add    $0x20,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	0f 88 4c ff ff ff    	js     80115d <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	68 05 08 00 00       	push   $0x805
  801219:	56                   	push   %esi
  80121a:	6a 00                	push   $0x0
  80121c:	56                   	push   %esi
  80121d:	6a 00                	push   $0x0
  80121f:	e8 48 fc ff ff       	call   800e6c <sys_page_map>
  801224:	83 c4 20             	add    $0x20,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	b9 00 00 00 00       	mov    $0x0,%ecx
  80122e:	0f 4f c1             	cmovg  %ecx,%eax
  801231:	e9 68 ff ff ff       	jmp    80119e <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	6a 05                	push   $0x5
  80123b:	56                   	push   %esi
  80123c:	57                   	push   %edi
  80123d:	56                   	push   %esi
  80123e:	6a 00                	push   $0x0
  801240:	e8 27 fc ff ff       	call   800e6c <sys_page_map>
  801245:	83 c4 20             	add    $0x20,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80124f:	0f 4f c1             	cmovg  %ecx,%eax
  801252:	e9 47 ff ff ff       	jmp    80119e <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	6a 07                	push   $0x7
  80125c:	68 00 f0 bf ee       	push   $0xeebff000
  801261:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801264:	57                   	push   %edi
  801265:	e8 bf fb ff ff       	call   800e29 <sys_page_alloc>
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	0f 88 e8 fe ff ff    	js     80115d <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	68 ab 24 80 00       	push   $0x8024ab
  80127d:	57                   	push   %edi
  80127e:	e8 f1 fc ff ff       	call   800f74 <sys_env_set_pgfault_upcall>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	0f 88 cf fe ff ff    	js     80115d <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  80128e:	83 ec 08             	sub    $0x8,%esp
  801291:	6a 02                	push   $0x2
  801293:	57                   	push   %edi
  801294:	e8 57 fc ff ff       	call   800ef0 <sys_env_set_status>
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	78 08                	js     8012a8 <fork+0x196>
	return eid;
  8012a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a3:	e9 b5 fe ff ff       	jmp    80115d <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  8012a8:	50                   	push   %eax
  8012a9:	68 a2 2d 80 00       	push   $0x802da2
  8012ae:	68 87 00 00 00       	push   $0x87
  8012b3:	68 7b 2d 80 00       	push   $0x802d7b
  8012b8:	e8 79 f0 ff ff       	call   800336 <_panic>

008012bd <sfork>:

// Challenge!
int sfork(void)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012c3:	68 c0 2d 80 00       	push   $0x802dc0
  8012c8:	68 8f 00 00 00       	push   $0x8f
  8012cd:	68 7b 2d 80 00       	push   $0x802d7b
  8012d2:	e8 5f f0 ff ff       	call   800336 <_panic>

008012d7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	05 00 00 00 30       	add    $0x30000000,%eax
  8012e2:	c1 e8 0c             	shr    $0xc,%eax
}
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012f7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801304:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801309:	89 c2                	mov    %eax,%edx
  80130b:	c1 ea 16             	shr    $0x16,%edx
  80130e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801315:	f6 c2 01             	test   $0x1,%dl
  801318:	74 2a                	je     801344 <fd_alloc+0x46>
  80131a:	89 c2                	mov    %eax,%edx
  80131c:	c1 ea 0c             	shr    $0xc,%edx
  80131f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801326:	f6 c2 01             	test   $0x1,%dl
  801329:	74 19                	je     801344 <fd_alloc+0x46>
  80132b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801330:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801335:	75 d2                	jne    801309 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801337:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80133d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801342:	eb 07                	jmp    80134b <fd_alloc+0x4d>
			*fd_store = fd;
  801344:	89 01                	mov    %eax,(%ecx)
			return 0;
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134b:	5d                   	pop    %ebp
  80134c:	c3                   	ret    

0080134d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801353:	83 f8 1f             	cmp    $0x1f,%eax
  801356:	77 36                	ja     80138e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801358:	c1 e0 0c             	shl    $0xc,%eax
  80135b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801360:	89 c2                	mov    %eax,%edx
  801362:	c1 ea 16             	shr    $0x16,%edx
  801365:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136c:	f6 c2 01             	test   $0x1,%dl
  80136f:	74 24                	je     801395 <fd_lookup+0x48>
  801371:	89 c2                	mov    %eax,%edx
  801373:	c1 ea 0c             	shr    $0xc,%edx
  801376:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80137d:	f6 c2 01             	test   $0x1,%dl
  801380:	74 1a                	je     80139c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801382:	8b 55 0c             	mov    0xc(%ebp),%edx
  801385:	89 02                	mov    %eax,(%edx)
	return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    
		return -E_INVAL;
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801393:	eb f7                	jmp    80138c <fd_lookup+0x3f>
		return -E_INVAL;
  801395:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139a:	eb f0                	jmp    80138c <fd_lookup+0x3f>
  80139c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a1:	eb e9                	jmp    80138c <fd_lookup+0x3f>

008013a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 08             	sub    $0x8,%esp
  8013a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ac:	ba 58 2e 80 00       	mov    $0x802e58,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013b1:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013b6:	39 08                	cmp    %ecx,(%eax)
  8013b8:	74 33                	je     8013ed <dev_lookup+0x4a>
  8013ba:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013bd:	8b 02                	mov    (%edx),%eax
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 f3                	jne    8013b6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c8:	8b 40 48             	mov    0x48(%eax),%eax
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	51                   	push   %ecx
  8013cf:	50                   	push   %eax
  8013d0:	68 d8 2d 80 00       	push   $0x802dd8
  8013d5:	e8 37 f0 ff ff       	call   800411 <cprintf>
	*dev = 0;
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    
			*dev = devtab[i];
  8013ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f7:	eb f2                	jmp    8013eb <dev_lookup+0x48>

008013f9 <fd_close>:
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	57                   	push   %edi
  8013fd:	56                   	push   %esi
  8013fe:	53                   	push   %ebx
  8013ff:	83 ec 1c             	sub    $0x1c,%esp
  801402:	8b 75 08             	mov    0x8(%ebp),%esi
  801405:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801408:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80140b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801412:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801415:	50                   	push   %eax
  801416:	e8 32 ff ff ff       	call   80134d <fd_lookup>
  80141b:	89 c3                	mov    %eax,%ebx
  80141d:	83 c4 08             	add    $0x8,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	78 05                	js     801429 <fd_close+0x30>
	    || fd != fd2)
  801424:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801427:	74 16                	je     80143f <fd_close+0x46>
		return (must_exist ? r : 0);
  801429:	89 f8                	mov    %edi,%eax
  80142b:	84 c0                	test   %al,%al
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax
  801432:	0f 44 d8             	cmove  %eax,%ebx
}
  801435:	89 d8                	mov    %ebx,%eax
  801437:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	5f                   	pop    %edi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80143f:	83 ec 08             	sub    $0x8,%esp
  801442:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801445:	50                   	push   %eax
  801446:	ff 36                	pushl  (%esi)
  801448:	e8 56 ff ff ff       	call   8013a3 <dev_lookup>
  80144d:	89 c3                	mov    %eax,%ebx
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 15                	js     80146b <fd_close+0x72>
		if (dev->dev_close)
  801456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801459:	8b 40 10             	mov    0x10(%eax),%eax
  80145c:	85 c0                	test   %eax,%eax
  80145e:	74 1b                	je     80147b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801460:	83 ec 0c             	sub    $0xc,%esp
  801463:	56                   	push   %esi
  801464:	ff d0                	call   *%eax
  801466:	89 c3                	mov    %eax,%ebx
  801468:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	56                   	push   %esi
  80146f:	6a 00                	push   $0x0
  801471:	e8 38 fa ff ff       	call   800eae <sys_page_unmap>
	return r;
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	eb ba                	jmp    801435 <fd_close+0x3c>
			r = 0;
  80147b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801480:	eb e9                	jmp    80146b <fd_close+0x72>

00801482 <close>:

int
close(int fdnum)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	ff 75 08             	pushl  0x8(%ebp)
  80148f:	e8 b9 fe ff ff       	call   80134d <fd_lookup>
  801494:	83 c4 08             	add    $0x8,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 10                	js     8014ab <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	6a 01                	push   $0x1
  8014a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a3:	e8 51 ff ff ff       	call   8013f9 <fd_close>
  8014a8:	83 c4 10             	add    $0x10,%esp
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <close_all>:

void
close_all(void)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014b4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014b9:	83 ec 0c             	sub    $0xc,%esp
  8014bc:	53                   	push   %ebx
  8014bd:	e8 c0 ff ff ff       	call   801482 <close>
	for (i = 0; i < MAXFD; i++)
  8014c2:	83 c3 01             	add    $0x1,%ebx
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	83 fb 20             	cmp    $0x20,%ebx
  8014cb:	75 ec                	jne    8014b9 <close_all+0xc>
}
  8014cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	57                   	push   %edi
  8014d6:	56                   	push   %esi
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	e8 66 fe ff ff       	call   80134d <fd_lookup>
  8014e7:	89 c3                	mov    %eax,%ebx
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	0f 88 81 00 00 00    	js     801575 <dup+0xa3>
		return r;
	close(newfdnum);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 83 ff ff ff       	call   801482 <close>

	newfd = INDEX2FD(newfdnum);
  8014ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801502:	c1 e6 0c             	shl    $0xc,%esi
  801505:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80150b:	83 c4 04             	add    $0x4,%esp
  80150e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801511:	e8 d1 fd ff ff       	call   8012e7 <fd2data>
  801516:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801518:	89 34 24             	mov    %esi,(%esp)
  80151b:	e8 c7 fd ff ff       	call   8012e7 <fd2data>
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801525:	89 d8                	mov    %ebx,%eax
  801527:	c1 e8 16             	shr    $0x16,%eax
  80152a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801531:	a8 01                	test   $0x1,%al
  801533:	74 11                	je     801546 <dup+0x74>
  801535:	89 d8                	mov    %ebx,%eax
  801537:	c1 e8 0c             	shr    $0xc,%eax
  80153a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801541:	f6 c2 01             	test   $0x1,%dl
  801544:	75 39                	jne    80157f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801546:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801549:	89 d0                	mov    %edx,%eax
  80154b:	c1 e8 0c             	shr    $0xc,%eax
  80154e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801555:	83 ec 0c             	sub    $0xc,%esp
  801558:	25 07 0e 00 00       	and    $0xe07,%eax
  80155d:	50                   	push   %eax
  80155e:	56                   	push   %esi
  80155f:	6a 00                	push   $0x0
  801561:	52                   	push   %edx
  801562:	6a 00                	push   $0x0
  801564:	e8 03 f9 ff ff       	call   800e6c <sys_page_map>
  801569:	89 c3                	mov    %eax,%ebx
  80156b:	83 c4 20             	add    $0x20,%esp
  80156e:	85 c0                	test   %eax,%eax
  801570:	78 31                	js     8015a3 <dup+0xd1>
		goto err;

	return newfdnum;
  801572:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801575:	89 d8                	mov    %ebx,%eax
  801577:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157a:	5b                   	pop    %ebx
  80157b:	5e                   	pop    %esi
  80157c:	5f                   	pop    %edi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80157f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801586:	83 ec 0c             	sub    $0xc,%esp
  801589:	25 07 0e 00 00       	and    $0xe07,%eax
  80158e:	50                   	push   %eax
  80158f:	57                   	push   %edi
  801590:	6a 00                	push   $0x0
  801592:	53                   	push   %ebx
  801593:	6a 00                	push   $0x0
  801595:	e8 d2 f8 ff ff       	call   800e6c <sys_page_map>
  80159a:	89 c3                	mov    %eax,%ebx
  80159c:	83 c4 20             	add    $0x20,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	79 a3                	jns    801546 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	56                   	push   %esi
  8015a7:	6a 00                	push   $0x0
  8015a9:	e8 00 f9 ff ff       	call   800eae <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015ae:	83 c4 08             	add    $0x8,%esp
  8015b1:	57                   	push   %edi
  8015b2:	6a 00                	push   $0x0
  8015b4:	e8 f5 f8 ff ff       	call   800eae <sys_page_unmap>
	return r;
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	eb b7                	jmp    801575 <dup+0xa3>

008015be <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 14             	sub    $0x14,%esp
  8015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015cb:	50                   	push   %eax
  8015cc:	53                   	push   %ebx
  8015cd:	e8 7b fd ff ff       	call   80134d <fd_lookup>
  8015d2:	83 c4 08             	add    $0x8,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 3f                	js     801618 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015df:	50                   	push   %eax
  8015e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e3:	ff 30                	pushl  (%eax)
  8015e5:	e8 b9 fd ff ff       	call   8013a3 <dev_lookup>
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 27                	js     801618 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f4:	8b 42 08             	mov    0x8(%edx),%eax
  8015f7:	83 e0 03             	and    $0x3,%eax
  8015fa:	83 f8 01             	cmp    $0x1,%eax
  8015fd:	74 1e                	je     80161d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801602:	8b 40 08             	mov    0x8(%eax),%eax
  801605:	85 c0                	test   %eax,%eax
  801607:	74 35                	je     80163e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	ff 75 10             	pushl  0x10(%ebp)
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	52                   	push   %edx
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
}
  801618:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80161d:	a1 08 40 80 00       	mov    0x804008,%eax
  801622:	8b 40 48             	mov    0x48(%eax),%eax
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	53                   	push   %ebx
  801629:	50                   	push   %eax
  80162a:	68 1c 2e 80 00       	push   $0x802e1c
  80162f:	e8 dd ed ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163c:	eb da                	jmp    801618 <read+0x5a>
		return -E_NOT_SUPP;
  80163e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801643:	eb d3                	jmp    801618 <read+0x5a>

00801645 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	57                   	push   %edi
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801651:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801654:	bb 00 00 00 00       	mov    $0x0,%ebx
  801659:	39 f3                	cmp    %esi,%ebx
  80165b:	73 25                	jae    801682 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	89 f0                	mov    %esi,%eax
  801662:	29 d8                	sub    %ebx,%eax
  801664:	50                   	push   %eax
  801665:	89 d8                	mov    %ebx,%eax
  801667:	03 45 0c             	add    0xc(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	57                   	push   %edi
  80166c:	e8 4d ff ff ff       	call   8015be <read>
		if (m < 0)
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 08                	js     801680 <readn+0x3b>
			return m;
		if (m == 0)
  801678:	85 c0                	test   %eax,%eax
  80167a:	74 06                	je     801682 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80167c:	01 c3                	add    %eax,%ebx
  80167e:	eb d9                	jmp    801659 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801680:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801682:	89 d8                	mov    %ebx,%eax
  801684:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801687:	5b                   	pop    %ebx
  801688:	5e                   	pop    %esi
  801689:	5f                   	pop    %edi
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	53                   	push   %ebx
  801690:	83 ec 14             	sub    $0x14,%esp
  801693:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801696:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801699:	50                   	push   %eax
  80169a:	53                   	push   %ebx
  80169b:	e8 ad fc ff ff       	call   80134d <fd_lookup>
  8016a0:	83 c4 08             	add    $0x8,%esp
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 3a                	js     8016e1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a7:	83 ec 08             	sub    $0x8,%esp
  8016aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ad:	50                   	push   %eax
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b1:	ff 30                	pushl  (%eax)
  8016b3:	e8 eb fc ff ff       	call   8013a3 <dev_lookup>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	78 22                	js     8016e1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c6:	74 1e                	je     8016e6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8016ce:	85 d2                	test   %edx,%edx
  8016d0:	74 35                	je     801707 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	ff 75 10             	pushl  0x10(%ebp)
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	50                   	push   %eax
  8016dc:	ff d2                	call   *%edx
  8016de:	83 c4 10             	add    $0x10,%esp
}
  8016e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016e6:	a1 08 40 80 00       	mov    0x804008,%eax
  8016eb:	8b 40 48             	mov    0x48(%eax),%eax
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	53                   	push   %ebx
  8016f2:	50                   	push   %eax
  8016f3:	68 38 2e 80 00       	push   $0x802e38
  8016f8:	e8 14 ed ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801705:	eb da                	jmp    8016e1 <write+0x55>
		return -E_NOT_SUPP;
  801707:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170c:	eb d3                	jmp    8016e1 <write+0x55>

0080170e <seek>:

int
seek(int fdnum, off_t offset)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801714:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801717:	50                   	push   %eax
  801718:	ff 75 08             	pushl  0x8(%ebp)
  80171b:	e8 2d fc ff ff       	call   80134d <fd_lookup>
  801720:	83 c4 08             	add    $0x8,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	78 0e                	js     801735 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	53                   	push   %ebx
  80173b:	83 ec 14             	sub    $0x14,%esp
  80173e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801741:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801744:	50                   	push   %eax
  801745:	53                   	push   %ebx
  801746:	e8 02 fc ff ff       	call   80134d <fd_lookup>
  80174b:	83 c4 08             	add    $0x8,%esp
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 37                	js     801789 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175c:	ff 30                	pushl  (%eax)
  80175e:	e8 40 fc ff ff       	call   8013a3 <dev_lookup>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	78 1f                	js     801789 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801771:	74 1b                	je     80178e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801776:	8b 52 18             	mov    0x18(%edx),%edx
  801779:	85 d2                	test   %edx,%edx
  80177b:	74 32                	je     8017af <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80177d:	83 ec 08             	sub    $0x8,%esp
  801780:	ff 75 0c             	pushl  0xc(%ebp)
  801783:	50                   	push   %eax
  801784:	ff d2                	call   *%edx
  801786:	83 c4 10             	add    $0x10,%esp
}
  801789:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80178e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801793:	8b 40 48             	mov    0x48(%eax),%eax
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	53                   	push   %ebx
  80179a:	50                   	push   %eax
  80179b:	68 f8 2d 80 00       	push   $0x802df8
  8017a0:	e8 6c ec ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ad:	eb da                	jmp    801789 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017b4:	eb d3                	jmp    801789 <ftruncate+0x52>

008017b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	53                   	push   %ebx
  8017ba:	83 ec 14             	sub    $0x14,%esp
  8017bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c3:	50                   	push   %eax
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	e8 81 fb ff ff       	call   80134d <fd_lookup>
  8017cc:	83 c4 08             	add    $0x8,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 4b                	js     80181e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d9:	50                   	push   %eax
  8017da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dd:	ff 30                	pushl  (%eax)
  8017df:	e8 bf fb ff ff       	call   8013a3 <dev_lookup>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	78 33                	js     80181e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ee:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017f2:	74 2f                	je     801823 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017f4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017f7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017fe:	00 00 00 
	stat->st_isdir = 0;
  801801:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801808:	00 00 00 
	stat->st_dev = dev;
  80180b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	53                   	push   %ebx
  801815:	ff 75 f0             	pushl  -0x10(%ebp)
  801818:	ff 50 14             	call   *0x14(%eax)
  80181b:	83 c4 10             	add    $0x10,%esp
}
  80181e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801821:	c9                   	leave  
  801822:	c3                   	ret    
		return -E_NOT_SUPP;
  801823:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801828:	eb f4                	jmp    80181e <fstat+0x68>

0080182a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	6a 00                	push   $0x0
  801834:	ff 75 08             	pushl  0x8(%ebp)
  801837:	e8 e7 01 00 00       	call   801a23 <open>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	78 1b                	js     801860 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801845:	83 ec 08             	sub    $0x8,%esp
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	50                   	push   %eax
  80184c:	e8 65 ff ff ff       	call   8017b6 <fstat>
  801851:	89 c6                	mov    %eax,%esi
	close(fd);
  801853:	89 1c 24             	mov    %ebx,(%esp)
  801856:	e8 27 fc ff ff       	call   801482 <close>
	return r;
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	89 f3                	mov    %esi,%ebx
}
  801860:	89 d8                	mov    %ebx,%eax
  801862:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
  80186e:	89 c6                	mov    %eax,%esi
  801870:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801872:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801879:	74 27                	je     8018a2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80187b:	6a 07                	push   $0x7
  80187d:	68 00 50 80 00       	push   $0x805000
  801882:	56                   	push   %esi
  801883:	ff 35 00 40 80 00    	pushl  0x804000
  801889:	e8 aa 0c 00 00       	call   802538 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80188e:	83 c4 0c             	add    $0xc,%esp
  801891:	6a 00                	push   $0x0
  801893:	53                   	push   %ebx
  801894:	6a 00                	push   $0x0
  801896:	e8 36 0c 00 00       	call   8024d1 <ipc_recv>
}
  80189b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189e:	5b                   	pop    %ebx
  80189f:	5e                   	pop    %esi
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	6a 01                	push   $0x1
  8018a7:	e8 e0 0c 00 00       	call   80258c <ipc_find_env>
  8018ac:	a3 00 40 80 00       	mov    %eax,0x804000
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	eb c5                	jmp    80187b <fsipc+0x12>

008018b6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ca:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8018d9:	e8 8b ff ff ff       	call   801869 <fsipc>
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <devfile_flush>:
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ec:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8018fb:	e8 69 ff ff ff       	call   801869 <fsipc>
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <devfile_stat>:
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	53                   	push   %ebx
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8b 40 0c             	mov    0xc(%eax),%eax
  801912:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	b8 05 00 00 00       	mov    $0x5,%eax
  801921:	e8 43 ff ff ff       	call   801869 <fsipc>
  801926:	85 c0                	test   %eax,%eax
  801928:	78 2c                	js     801956 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80192a:	83 ec 08             	sub    $0x8,%esp
  80192d:	68 00 50 80 00       	push   $0x805000
  801932:	53                   	push   %ebx
  801933:	e8 f8 f0 ff ff       	call   800a30 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801938:	a1 80 50 80 00       	mov    0x805080,%eax
  80193d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801943:	a1 84 50 80 00       	mov    0x805084,%eax
  801948:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <devfile_write>:
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	8b 45 10             	mov    0x10(%ebp),%eax
  801964:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801969:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80196e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801971:	8b 55 08             	mov    0x8(%ebp),%edx
  801974:	8b 52 0c             	mov    0xc(%edx),%edx
  801977:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80197d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801982:	50                   	push   %eax
  801983:	ff 75 0c             	pushl  0xc(%ebp)
  801986:	68 08 50 80 00       	push   $0x805008
  80198b:	e8 2e f2 ff ff       	call   800bbe <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801990:	ba 00 00 00 00       	mov    $0x0,%edx
  801995:	b8 04 00 00 00       	mov    $0x4,%eax
  80199a:	e8 ca fe ff ff       	call   801869 <fsipc>
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <devfile_read>:
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
  8019a6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8019af:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019b4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bf:	b8 03 00 00 00       	mov    $0x3,%eax
  8019c4:	e8 a0 fe ff ff       	call   801869 <fsipc>
  8019c9:	89 c3                	mov    %eax,%ebx
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 1f                	js     8019ee <devfile_read+0x4d>
	assert(r <= n);
  8019cf:	39 f0                	cmp    %esi,%eax
  8019d1:	77 24                	ja     8019f7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019d3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d8:	7f 33                	jg     801a0d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	50                   	push   %eax
  8019de:	68 00 50 80 00       	push   $0x805000
  8019e3:	ff 75 0c             	pushl  0xc(%ebp)
  8019e6:	e8 d3 f1 ff ff       	call   800bbe <memmove>
	return r;
  8019eb:	83 c4 10             	add    $0x10,%esp
}
  8019ee:	89 d8                	mov    %ebx,%eax
  8019f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    
	assert(r <= n);
  8019f7:	68 6c 2e 80 00       	push   $0x802e6c
  8019fc:	68 73 2e 80 00       	push   $0x802e73
  801a01:	6a 7b                	push   $0x7b
  801a03:	68 88 2e 80 00       	push   $0x802e88
  801a08:	e8 29 e9 ff ff       	call   800336 <_panic>
	assert(r <= PGSIZE);
  801a0d:	68 93 2e 80 00       	push   $0x802e93
  801a12:	68 73 2e 80 00       	push   $0x802e73
  801a17:	6a 7c                	push   $0x7c
  801a19:	68 88 2e 80 00       	push   $0x802e88
  801a1e:	e8 13 e9 ff ff       	call   800336 <_panic>

00801a23 <open>:
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	83 ec 1c             	sub    $0x1c,%esp
  801a2b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a2e:	56                   	push   %esi
  801a2f:	e8 c5 ef ff ff       	call   8009f9 <strlen>
  801a34:	83 c4 10             	add    $0x10,%esp
  801a37:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a3c:	7f 6c                	jg     801aaa <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a44:	50                   	push   %eax
  801a45:	e8 b4 f8 ff ff       	call   8012fe <fd_alloc>
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	78 3c                	js     801a8f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a53:	83 ec 08             	sub    $0x8,%esp
  801a56:	56                   	push   %esi
  801a57:	68 00 50 80 00       	push   $0x805000
  801a5c:	e8 cf ef ff ff       	call   800a30 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a71:	e8 f3 fd ff ff       	call   801869 <fsipc>
  801a76:	89 c3                	mov    %eax,%ebx
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 19                	js     801a98 <open+0x75>
	return fd2num(fd);
  801a7f:	83 ec 0c             	sub    $0xc,%esp
  801a82:	ff 75 f4             	pushl  -0xc(%ebp)
  801a85:	e8 4d f8 ff ff       	call   8012d7 <fd2num>
  801a8a:	89 c3                	mov    %eax,%ebx
  801a8c:	83 c4 10             	add    $0x10,%esp
}
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
		fd_close(fd, 0);
  801a98:	83 ec 08             	sub    $0x8,%esp
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa0:	e8 54 f9 ff ff       	call   8013f9 <fd_close>
		return r;
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	eb e5                	jmp    801a8f <open+0x6c>
		return -E_BAD_PATH;
  801aaa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aaf:	eb de                	jmp    801a8f <open+0x6c>

00801ab1 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  801abc:	b8 08 00 00 00       	mov    $0x8,%eax
  801ac1:	e8 a3 fd ff ff       	call   801869 <fsipc>
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ace:	68 9f 2e 80 00       	push   $0x802e9f
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	e8 55 ef ff ff       	call   800a30 <strcpy>
	return 0;
}
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <devsock_close>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 10             	sub    $0x10,%esp
  801ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801aec:	53                   	push   %ebx
  801aed:	e8 d3 0a 00 00       	call   8025c5 <pageref>
  801af2:	83 c4 10             	add    $0x10,%esp
		return 0;
  801af5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801afa:	83 f8 01             	cmp    $0x1,%eax
  801afd:	74 07                	je     801b06 <devsock_close+0x24>
}
  801aff:	89 d0                	mov    %edx,%eax
  801b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	ff 73 0c             	pushl  0xc(%ebx)
  801b0c:	e8 b7 02 00 00       	call   801dc8 <nsipc_close>
  801b11:	89 c2                	mov    %eax,%edx
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	eb e7                	jmp    801aff <devsock_close+0x1d>

00801b18 <devsock_write>:
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	ff 75 10             	pushl  0x10(%ebp)
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	ff 70 0c             	pushl  0xc(%eax)
  801b2c:	e8 74 03 00 00       	call   801ea5 <nsipc_send>
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <devsock_read>:
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 10             	pushl  0x10(%ebp)
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	ff 70 0c             	pushl  0xc(%eax)
  801b47:	e8 ed 02 00 00       	call   801e39 <nsipc_recv>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <fd2sockid>:
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b54:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	e8 ef f7 ff ff       	call   80134d <fd_lookup>
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 10                	js     801b75 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b68:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801b6e:	39 08                	cmp    %ecx,(%eax)
  801b70:	75 05                	jne    801b77 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b72:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    
		return -E_NOT_SUPP;
  801b77:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b7c:	eb f7                	jmp    801b75 <fd2sockid+0x27>

00801b7e <alloc_sockfd>:
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
  801b83:	83 ec 1c             	sub    $0x1c,%esp
  801b86:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8b:	50                   	push   %eax
  801b8c:	e8 6d f7 ff ff       	call   8012fe <fd_alloc>
  801b91:	89 c3                	mov    %eax,%ebx
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	85 c0                	test   %eax,%eax
  801b98:	78 43                	js     801bdd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	68 07 04 00 00       	push   $0x407
  801ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba5:	6a 00                	push   $0x0
  801ba7:	e8 7d f2 ff ff       	call   800e29 <sys_page_alloc>
  801bac:	89 c3                	mov    %eax,%ebx
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 28                	js     801bdd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb8:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801bbe:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bca:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bcd:	83 ec 0c             	sub    $0xc,%esp
  801bd0:	50                   	push   %eax
  801bd1:	e8 01 f7 ff ff       	call   8012d7 <fd2num>
  801bd6:	89 c3                	mov    %eax,%ebx
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	eb 0c                	jmp    801be9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	56                   	push   %esi
  801be1:	e8 e2 01 00 00       	call   801dc8 <nsipc_close>
		return r;
  801be6:	83 c4 10             	add    $0x10,%esp
}
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5e                   	pop    %esi
  801bf0:	5d                   	pop    %ebp
  801bf1:	c3                   	ret    

00801bf2 <accept>:
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	e8 4e ff ff ff       	call   801b4e <fd2sockid>
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 1b                	js     801c1f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	ff 75 10             	pushl  0x10(%ebp)
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	50                   	push   %eax
  801c0e:	e8 0e 01 00 00       	call   801d21 <nsipc_accept>
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	85 c0                	test   %eax,%eax
  801c18:	78 05                	js     801c1f <accept+0x2d>
	return alloc_sockfd(r);
  801c1a:	e8 5f ff ff ff       	call   801b7e <alloc_sockfd>
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <bind>:
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	e8 1f ff ff ff       	call   801b4e <fd2sockid>
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 12                	js     801c45 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	ff 75 10             	pushl  0x10(%ebp)
  801c39:	ff 75 0c             	pushl  0xc(%ebp)
  801c3c:	50                   	push   %eax
  801c3d:	e8 2f 01 00 00       	call   801d71 <nsipc_bind>
  801c42:	83 c4 10             	add    $0x10,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <shutdown>:
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	e8 f9 fe ff ff       	call   801b4e <fd2sockid>
  801c55:	85 c0                	test   %eax,%eax
  801c57:	78 0f                	js     801c68 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c59:	83 ec 08             	sub    $0x8,%esp
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	50                   	push   %eax
  801c60:	e8 41 01 00 00       	call   801da6 <nsipc_shutdown>
  801c65:	83 c4 10             	add    $0x10,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <connect>:
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	e8 d6 fe ff ff       	call   801b4e <fd2sockid>
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 12                	js     801c8e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	ff 75 10             	pushl  0x10(%ebp)
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	50                   	push   %eax
  801c86:	e8 57 01 00 00       	call   801de2 <nsipc_connect>
  801c8b:	83 c4 10             	add    $0x10,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <listen>:
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	e8 b0 fe ff ff       	call   801b4e <fd2sockid>
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 0f                	js     801cb1 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ca2:	83 ec 08             	sub    $0x8,%esp
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	50                   	push   %eax
  801ca9:	e8 69 01 00 00       	call   801e17 <nsipc_listen>
  801cae:	83 c4 10             	add    $0x10,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <socket>:

int
socket(int domain, int type, int protocol)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cb9:	ff 75 10             	pushl  0x10(%ebp)
  801cbc:	ff 75 0c             	pushl  0xc(%ebp)
  801cbf:	ff 75 08             	pushl  0x8(%ebp)
  801cc2:	e8 3c 02 00 00       	call   801f03 <nsipc_socket>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	78 05                	js     801cd3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cce:	e8 ab fe ff ff       	call   801b7e <alloc_sockfd>
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	53                   	push   %ebx
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cde:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ce5:	74 26                	je     801d0d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ce7:	6a 07                	push   $0x7
  801ce9:	68 00 60 80 00       	push   $0x806000
  801cee:	53                   	push   %ebx
  801cef:	ff 35 04 40 80 00    	pushl  0x804004
  801cf5:	e8 3e 08 00 00       	call   802538 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cfa:	83 c4 0c             	add    $0xc,%esp
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	e8 c9 07 00 00       	call   8024d1 <ipc_recv>
}
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	6a 02                	push   $0x2
  801d12:	e8 75 08 00 00       	call   80258c <ipc_find_env>
  801d17:	a3 04 40 80 00       	mov    %eax,0x804004
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	eb c6                	jmp    801ce7 <nsipc+0x12>

00801d21 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	56                   	push   %esi
  801d25:	53                   	push   %ebx
  801d26:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d31:	8b 06                	mov    (%esi),%eax
  801d33:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d38:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3d:	e8 93 ff ff ff       	call   801cd5 <nsipc>
  801d42:	89 c3                	mov    %eax,%ebx
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 20                	js     801d68 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d48:	83 ec 04             	sub    $0x4,%esp
  801d4b:	ff 35 10 60 80 00    	pushl  0x806010
  801d51:	68 00 60 80 00       	push   $0x806000
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	e8 60 ee ff ff       	call   800bbe <memmove>
		*addrlen = ret->ret_addrlen;
  801d5e:	a1 10 60 80 00       	mov    0x806010,%eax
  801d63:	89 06                	mov    %eax,(%esi)
  801d65:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801d68:	89 d8                	mov    %ebx,%eax
  801d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6d:	5b                   	pop    %ebx
  801d6e:	5e                   	pop    %esi
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	53                   	push   %ebx
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d83:	53                   	push   %ebx
  801d84:	ff 75 0c             	pushl  0xc(%ebp)
  801d87:	68 04 60 80 00       	push   $0x806004
  801d8c:	e8 2d ee ff ff       	call   800bbe <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d91:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d97:	b8 02 00 00 00       	mov    $0x2,%eax
  801d9c:	e8 34 ff ff ff       	call   801cd5 <nsipc>
}
  801da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801dbc:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc1:	e8 0f ff ff ff       	call   801cd5 <nsipc>
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <nsipc_close>:

int
nsipc_close(int s)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dd6:	b8 04 00 00 00       	mov    $0x4,%eax
  801ddb:	e8 f5 fe ff ff       	call   801cd5 <nsipc>
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	53                   	push   %ebx
  801de6:	83 ec 08             	sub    $0x8,%esp
  801de9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801df4:	53                   	push   %ebx
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	68 04 60 80 00       	push   $0x806004
  801dfd:	e8 bc ed ff ff       	call   800bbe <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e02:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e08:	b8 05 00 00 00       	mov    $0x5,%eax
  801e0d:	e8 c3 fe ff ff       	call   801cd5 <nsipc>
}
  801e12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e28:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e2d:	b8 06 00 00 00       	mov    $0x6,%eax
  801e32:	e8 9e fe ff ff       	call   801cd5 <nsipc>
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	56                   	push   %esi
  801e3d:	53                   	push   %ebx
  801e3e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e49:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e52:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e57:	b8 07 00 00 00       	mov    $0x7,%eax
  801e5c:	e8 74 fe ff ff       	call   801cd5 <nsipc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 1f                	js     801e86 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e67:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e6c:	7f 21                	jg     801e8f <nsipc_recv+0x56>
  801e6e:	39 c6                	cmp    %eax,%esi
  801e70:	7c 1d                	jl     801e8f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e72:	83 ec 04             	sub    $0x4,%esp
  801e75:	50                   	push   %eax
  801e76:	68 00 60 80 00       	push   $0x806000
  801e7b:	ff 75 0c             	pushl  0xc(%ebp)
  801e7e:	e8 3b ed ff ff       	call   800bbe <memmove>
  801e83:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e86:	89 d8                	mov    %ebx,%eax
  801e88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8b:	5b                   	pop    %ebx
  801e8c:	5e                   	pop    %esi
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e8f:	68 ab 2e 80 00       	push   $0x802eab
  801e94:	68 73 2e 80 00       	push   $0x802e73
  801e99:	6a 62                	push   $0x62
  801e9b:	68 c0 2e 80 00       	push   $0x802ec0
  801ea0:	e8 91 e4 ff ff       	call   800336 <_panic>

00801ea5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	53                   	push   %ebx
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801eb7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ebd:	7f 2e                	jg     801eed <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	53                   	push   %ebx
  801ec3:	ff 75 0c             	pushl  0xc(%ebp)
  801ec6:	68 0c 60 80 00       	push   $0x80600c
  801ecb:	e8 ee ec ff ff       	call   800bbe <memmove>
	nsipcbuf.send.req_size = size;
  801ed0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ede:	b8 08 00 00 00       	mov    $0x8,%eax
  801ee3:	e8 ed fd ff ff       	call   801cd5 <nsipc>
}
  801ee8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    
	assert(size < 1600);
  801eed:	68 cc 2e 80 00       	push   $0x802ecc
  801ef2:	68 73 2e 80 00       	push   $0x802e73
  801ef7:	6a 6d                	push   $0x6d
  801ef9:	68 c0 2e 80 00       	push   $0x802ec0
  801efe:	e8 33 e4 ff ff       	call   800336 <_panic>

00801f03 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f14:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f19:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f21:	b8 09 00 00 00       	mov    $0x9,%eax
  801f26:	e8 aa fd ff ff       	call   801cd5 <nsipc>
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	56                   	push   %esi
  801f31:	53                   	push   %ebx
  801f32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	ff 75 08             	pushl  0x8(%ebp)
  801f3b:	e8 a7 f3 ff ff       	call   8012e7 <fd2data>
  801f40:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f42:	83 c4 08             	add    $0x8,%esp
  801f45:	68 d8 2e 80 00       	push   $0x802ed8
  801f4a:	53                   	push   %ebx
  801f4b:	e8 e0 ea ff ff       	call   800a30 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f50:	8b 46 04             	mov    0x4(%esi),%eax
  801f53:	2b 06                	sub    (%esi),%eax
  801f55:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f5b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f62:	00 00 00 
	stat->st_dev = &devpipe;
  801f65:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801f6c:	30 80 00 
	return 0;
}
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5d                   	pop    %ebp
  801f7a:	c3                   	ret    

00801f7b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	53                   	push   %ebx
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f85:	53                   	push   %ebx
  801f86:	6a 00                	push   $0x0
  801f88:	e8 21 ef ff ff       	call   800eae <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f8d:	89 1c 24             	mov    %ebx,(%esp)
  801f90:	e8 52 f3 ff ff       	call   8012e7 <fd2data>
  801f95:	83 c4 08             	add    $0x8,%esp
  801f98:	50                   	push   %eax
  801f99:	6a 00                	push   $0x0
  801f9b:	e8 0e ef ff ff       	call   800eae <sys_page_unmap>
}
  801fa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <_pipeisclosed>:
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	57                   	push   %edi
  801fa9:	56                   	push   %esi
  801faa:	53                   	push   %ebx
  801fab:	83 ec 1c             	sub    $0x1c,%esp
  801fae:	89 c7                	mov    %eax,%edi
  801fb0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fb2:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	57                   	push   %edi
  801fbe:	e8 02 06 00 00       	call   8025c5 <pageref>
  801fc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fc6:	89 34 24             	mov    %esi,(%esp)
  801fc9:	e8 f7 05 00 00       	call   8025c5 <pageref>
		nn = thisenv->env_runs;
  801fce:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fd4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	39 cb                	cmp    %ecx,%ebx
  801fdc:	74 1b                	je     801ff9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fde:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fe1:	75 cf                	jne    801fb2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fe3:	8b 42 58             	mov    0x58(%edx),%eax
  801fe6:	6a 01                	push   $0x1
  801fe8:	50                   	push   %eax
  801fe9:	53                   	push   %ebx
  801fea:	68 df 2e 80 00       	push   $0x802edf
  801fef:	e8 1d e4 ff ff       	call   800411 <cprintf>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	eb b9                	jmp    801fb2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ff9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ffc:	0f 94 c0             	sete   %al
  801fff:	0f b6 c0             	movzbl %al,%eax
}
  802002:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802005:	5b                   	pop    %ebx
  802006:	5e                   	pop    %esi
  802007:	5f                   	pop    %edi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    

0080200a <devpipe_write>:
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	57                   	push   %edi
  80200e:	56                   	push   %esi
  80200f:	53                   	push   %ebx
  802010:	83 ec 28             	sub    $0x28,%esp
  802013:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802016:	56                   	push   %esi
  802017:	e8 cb f2 ff ff       	call   8012e7 <fd2data>
  80201c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
  802026:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802029:	74 4f                	je     80207a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80202b:	8b 43 04             	mov    0x4(%ebx),%eax
  80202e:	8b 0b                	mov    (%ebx),%ecx
  802030:	8d 51 20             	lea    0x20(%ecx),%edx
  802033:	39 d0                	cmp    %edx,%eax
  802035:	72 14                	jb     80204b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802037:	89 da                	mov    %ebx,%edx
  802039:	89 f0                	mov    %esi,%eax
  80203b:	e8 65 ff ff ff       	call   801fa5 <_pipeisclosed>
  802040:	85 c0                	test   %eax,%eax
  802042:	75 3a                	jne    80207e <devpipe_write+0x74>
			sys_yield();
  802044:	e8 c1 ed ff ff       	call   800e0a <sys_yield>
  802049:	eb e0                	jmp    80202b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80204b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80204e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802052:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802055:	89 c2                	mov    %eax,%edx
  802057:	c1 fa 1f             	sar    $0x1f,%edx
  80205a:	89 d1                	mov    %edx,%ecx
  80205c:	c1 e9 1b             	shr    $0x1b,%ecx
  80205f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802062:	83 e2 1f             	and    $0x1f,%edx
  802065:	29 ca                	sub    %ecx,%edx
  802067:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80206b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80206f:	83 c0 01             	add    $0x1,%eax
  802072:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802075:	83 c7 01             	add    $0x1,%edi
  802078:	eb ac                	jmp    802026 <devpipe_write+0x1c>
	return i;
  80207a:	89 f8                	mov    %edi,%eax
  80207c:	eb 05                	jmp    802083 <devpipe_write+0x79>
				return 0;
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802083:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802086:	5b                   	pop    %ebx
  802087:	5e                   	pop    %esi
  802088:	5f                   	pop    %edi
  802089:	5d                   	pop    %ebp
  80208a:	c3                   	ret    

0080208b <devpipe_read>:
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	57                   	push   %edi
  80208f:	56                   	push   %esi
  802090:	53                   	push   %ebx
  802091:	83 ec 18             	sub    $0x18,%esp
  802094:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802097:	57                   	push   %edi
  802098:	e8 4a f2 ff ff       	call   8012e7 <fd2data>
  80209d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	be 00 00 00 00       	mov    $0x0,%esi
  8020a7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020aa:	74 47                	je     8020f3 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8020ac:	8b 03                	mov    (%ebx),%eax
  8020ae:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020b1:	75 22                	jne    8020d5 <devpipe_read+0x4a>
			if (i > 0)
  8020b3:	85 f6                	test   %esi,%esi
  8020b5:	75 14                	jne    8020cb <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8020b7:	89 da                	mov    %ebx,%edx
  8020b9:	89 f8                	mov    %edi,%eax
  8020bb:	e8 e5 fe ff ff       	call   801fa5 <_pipeisclosed>
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	75 33                	jne    8020f7 <devpipe_read+0x6c>
			sys_yield();
  8020c4:	e8 41 ed ff ff       	call   800e0a <sys_yield>
  8020c9:	eb e1                	jmp    8020ac <devpipe_read+0x21>
				return i;
  8020cb:	89 f0                	mov    %esi,%eax
}
  8020cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020d5:	99                   	cltd   
  8020d6:	c1 ea 1b             	shr    $0x1b,%edx
  8020d9:	01 d0                	add    %edx,%eax
  8020db:	83 e0 1f             	and    $0x1f,%eax
  8020de:	29 d0                	sub    %edx,%eax
  8020e0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020e8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020eb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020ee:	83 c6 01             	add    $0x1,%esi
  8020f1:	eb b4                	jmp    8020a7 <devpipe_read+0x1c>
	return i;
  8020f3:	89 f0                	mov    %esi,%eax
  8020f5:	eb d6                	jmp    8020cd <devpipe_read+0x42>
				return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fc:	eb cf                	jmp    8020cd <devpipe_read+0x42>

008020fe <pipe>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	56                   	push   %esi
  802102:	53                   	push   %ebx
  802103:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802106:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802109:	50                   	push   %eax
  80210a:	e8 ef f1 ff ff       	call   8012fe <fd_alloc>
  80210f:	89 c3                	mov    %eax,%ebx
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 5b                	js     802173 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802118:	83 ec 04             	sub    $0x4,%esp
  80211b:	68 07 04 00 00       	push   $0x407
  802120:	ff 75 f4             	pushl  -0xc(%ebp)
  802123:	6a 00                	push   $0x0
  802125:	e8 ff ec ff ff       	call   800e29 <sys_page_alloc>
  80212a:	89 c3                	mov    %eax,%ebx
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 40                	js     802173 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802139:	50                   	push   %eax
  80213a:	e8 bf f1 ff ff       	call   8012fe <fd_alloc>
  80213f:	89 c3                	mov    %eax,%ebx
  802141:	83 c4 10             	add    $0x10,%esp
  802144:	85 c0                	test   %eax,%eax
  802146:	78 1b                	js     802163 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	68 07 04 00 00       	push   $0x407
  802150:	ff 75 f0             	pushl  -0x10(%ebp)
  802153:	6a 00                	push   $0x0
  802155:	e8 cf ec ff ff       	call   800e29 <sys_page_alloc>
  80215a:	89 c3                	mov    %eax,%ebx
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	85 c0                	test   %eax,%eax
  802161:	79 19                	jns    80217c <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802163:	83 ec 08             	sub    $0x8,%esp
  802166:	ff 75 f4             	pushl  -0xc(%ebp)
  802169:	6a 00                	push   $0x0
  80216b:	e8 3e ed ff ff       	call   800eae <sys_page_unmap>
  802170:	83 c4 10             	add    $0x10,%esp
}
  802173:	89 d8                	mov    %ebx,%eax
  802175:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802178:	5b                   	pop    %ebx
  802179:	5e                   	pop    %esi
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    
	va = fd2data(fd0);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	ff 75 f4             	pushl  -0xc(%ebp)
  802182:	e8 60 f1 ff ff       	call   8012e7 <fd2data>
  802187:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802189:	83 c4 0c             	add    $0xc,%esp
  80218c:	68 07 04 00 00       	push   $0x407
  802191:	50                   	push   %eax
  802192:	6a 00                	push   $0x0
  802194:	e8 90 ec ff ff       	call   800e29 <sys_page_alloc>
  802199:	89 c3                	mov    %eax,%ebx
  80219b:	83 c4 10             	add    $0x10,%esp
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	0f 88 8c 00 00 00    	js     802232 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ac:	e8 36 f1 ff ff       	call   8012e7 <fd2data>
  8021b1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021b8:	50                   	push   %eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	56                   	push   %esi
  8021bc:	6a 00                	push   $0x0
  8021be:	e8 a9 ec ff ff       	call   800e6c <sys_page_map>
  8021c3:	89 c3                	mov    %eax,%ebx
  8021c5:	83 c4 20             	add    $0x20,%esp
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	78 58                	js     802224 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8021d5:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8021e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e4:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8021ea:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021f6:	83 ec 0c             	sub    $0xc,%esp
  8021f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021fc:	e8 d6 f0 ff ff       	call   8012d7 <fd2num>
  802201:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802204:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802206:	83 c4 04             	add    $0x4,%esp
  802209:	ff 75 f0             	pushl  -0x10(%ebp)
  80220c:	e8 c6 f0 ff ff       	call   8012d7 <fd2num>
  802211:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802214:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80221f:	e9 4f ff ff ff       	jmp    802173 <pipe+0x75>
	sys_page_unmap(0, va);
  802224:	83 ec 08             	sub    $0x8,%esp
  802227:	56                   	push   %esi
  802228:	6a 00                	push   $0x0
  80222a:	e8 7f ec ff ff       	call   800eae <sys_page_unmap>
  80222f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802232:	83 ec 08             	sub    $0x8,%esp
  802235:	ff 75 f0             	pushl  -0x10(%ebp)
  802238:	6a 00                	push   $0x0
  80223a:	e8 6f ec ff ff       	call   800eae <sys_page_unmap>
  80223f:	83 c4 10             	add    $0x10,%esp
  802242:	e9 1c ff ff ff       	jmp    802163 <pipe+0x65>

00802247 <pipeisclosed>:
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80224d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802250:	50                   	push   %eax
  802251:	ff 75 08             	pushl  0x8(%ebp)
  802254:	e8 f4 f0 ff ff       	call   80134d <fd_lookup>
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	85 c0                	test   %eax,%eax
  80225e:	78 18                	js     802278 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	ff 75 f4             	pushl  -0xc(%ebp)
  802266:	e8 7c f0 ff ff       	call   8012e7 <fd2data>
	return _pipeisclosed(fd, p);
  80226b:	89 c2                	mov    %eax,%edx
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	e8 30 fd ff ff       	call   801fa5 <_pipeisclosed>
  802275:	83 c4 10             	add    $0x10,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	56                   	push   %esi
  80227e:	53                   	push   %ebx
  80227f:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802282:	85 f6                	test   %esi,%esi
  802284:	74 13                	je     802299 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802286:	89 f3                	mov    %esi,%ebx
  802288:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80228e:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802291:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802297:	eb 1b                	jmp    8022b4 <wait+0x3a>
	assert(envid != 0);
  802299:	68 f7 2e 80 00       	push   $0x802ef7
  80229e:	68 73 2e 80 00       	push   $0x802e73
  8022a3:	6a 09                	push   $0x9
  8022a5:	68 02 2f 80 00       	push   $0x802f02
  8022aa:	e8 87 e0 ff ff       	call   800336 <_panic>
		sys_yield();
  8022af:	e8 56 eb ff ff       	call   800e0a <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8022b4:	8b 43 48             	mov    0x48(%ebx),%eax
  8022b7:	39 f0                	cmp    %esi,%eax
  8022b9:	75 07                	jne    8022c2 <wait+0x48>
  8022bb:	8b 43 54             	mov    0x54(%ebx),%eax
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	75 ed                	jne    8022af <wait+0x35>
}
  8022c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    

008022c9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    

008022d3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022d9:	68 0d 2f 80 00       	push   $0x802f0d
  8022de:	ff 75 0c             	pushl  0xc(%ebp)
  8022e1:	e8 4a e7 ff ff       	call   800a30 <strcpy>
	return 0;
}
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <devcons_write>:
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	57                   	push   %edi
  8022f1:	56                   	push   %esi
  8022f2:	53                   	push   %ebx
  8022f3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022f9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022fe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802304:	eb 2f                	jmp    802335 <devcons_write+0x48>
		m = n - tot;
  802306:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802309:	29 f3                	sub    %esi,%ebx
  80230b:	83 fb 7f             	cmp    $0x7f,%ebx
  80230e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802313:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802316:	83 ec 04             	sub    $0x4,%esp
  802319:	53                   	push   %ebx
  80231a:	89 f0                	mov    %esi,%eax
  80231c:	03 45 0c             	add    0xc(%ebp),%eax
  80231f:	50                   	push   %eax
  802320:	57                   	push   %edi
  802321:	e8 98 e8 ff ff       	call   800bbe <memmove>
		sys_cputs(buf, m);
  802326:	83 c4 08             	add    $0x8,%esp
  802329:	53                   	push   %ebx
  80232a:	57                   	push   %edi
  80232b:	e8 3d ea ff ff       	call   800d6d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802330:	01 de                	add    %ebx,%esi
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	3b 75 10             	cmp    0x10(%ebp),%esi
  802338:	72 cc                	jb     802306 <devcons_write+0x19>
}
  80233a:	89 f0                	mov    %esi,%eax
  80233c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <devcons_read>:
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 08             	sub    $0x8,%esp
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80234f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802353:	75 07                	jne    80235c <devcons_read+0x18>
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    
		sys_yield();
  802357:	e8 ae ea ff ff       	call   800e0a <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80235c:	e8 2a ea ff ff       	call   800d8b <sys_cgetc>
  802361:	85 c0                	test   %eax,%eax
  802363:	74 f2                	je     802357 <devcons_read+0x13>
	if (c < 0)
  802365:	85 c0                	test   %eax,%eax
  802367:	78 ec                	js     802355 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802369:	83 f8 04             	cmp    $0x4,%eax
  80236c:	74 0c                	je     80237a <devcons_read+0x36>
	*(char*)vbuf = c;
  80236e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802371:	88 02                	mov    %al,(%edx)
	return 1;
  802373:	b8 01 00 00 00       	mov    $0x1,%eax
  802378:	eb db                	jmp    802355 <devcons_read+0x11>
		return 0;
  80237a:	b8 00 00 00 00       	mov    $0x0,%eax
  80237f:	eb d4                	jmp    802355 <devcons_read+0x11>

00802381 <cputchar>:
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80238d:	6a 01                	push   $0x1
  80238f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802392:	50                   	push   %eax
  802393:	e8 d5 e9 ff ff       	call   800d6d <sys_cputs>
}
  802398:	83 c4 10             	add    $0x10,%esp
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <getchar>:
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023a3:	6a 01                	push   $0x1
  8023a5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023a8:	50                   	push   %eax
  8023a9:	6a 00                	push   $0x0
  8023ab:	e8 0e f2 ff ff       	call   8015be <read>
	if (r < 0)
  8023b0:	83 c4 10             	add    $0x10,%esp
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	78 08                	js     8023bf <getchar+0x22>
	if (r < 1)
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	7e 06                	jle    8023c1 <getchar+0x24>
	return c;
  8023bb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    
		return -E_EOF;
  8023c1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023c6:	eb f7                	jmp    8023bf <getchar+0x22>

008023c8 <iscons>:
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d1:	50                   	push   %eax
  8023d2:	ff 75 08             	pushl  0x8(%ebp)
  8023d5:	e8 73 ef ff ff       	call   80134d <fd_lookup>
  8023da:	83 c4 10             	add    $0x10,%esp
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	78 11                	js     8023f2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8023ea:	39 10                	cmp    %edx,(%eax)
  8023ec:	0f 94 c0             	sete   %al
  8023ef:	0f b6 c0             	movzbl %al,%eax
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <opencons>:
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023fd:	50                   	push   %eax
  8023fe:	e8 fb ee ff ff       	call   8012fe <fd_alloc>
  802403:	83 c4 10             	add    $0x10,%esp
  802406:	85 c0                	test   %eax,%eax
  802408:	78 3a                	js     802444 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	68 07 04 00 00       	push   $0x407
  802412:	ff 75 f4             	pushl  -0xc(%ebp)
  802415:	6a 00                	push   $0x0
  802417:	e8 0d ea ff ff       	call   800e29 <sys_page_alloc>
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	85 c0                	test   %eax,%eax
  802421:	78 21                	js     802444 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80242c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802438:	83 ec 0c             	sub    $0xc,%esp
  80243b:	50                   	push   %eax
  80243c:	e8 96 ee ff ff       	call   8012d7 <fd2num>
  802441:	83 c4 10             	add    $0x10,%esp
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  80244c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802453:	74 0a                	je     80245f <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  80245f:	a1 08 40 80 00       	mov    0x804008,%eax
  802464:	8b 40 48             	mov    0x48(%eax),%eax
  802467:	83 ec 04             	sub    $0x4,%esp
  80246a:	6a 07                	push   $0x7
  80246c:	68 00 f0 bf ee       	push   $0xeebff000
  802471:	50                   	push   %eax
  802472:	e8 b2 e9 ff ff       	call   800e29 <sys_page_alloc>
  802477:	83 c4 10             	add    $0x10,%esp
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 1b                	js     802499 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80247e:	a1 08 40 80 00       	mov    0x804008,%eax
  802483:	8b 40 48             	mov    0x48(%eax),%eax
  802486:	83 ec 08             	sub    $0x8,%esp
  802489:	68 ab 24 80 00       	push   $0x8024ab
  80248e:	50                   	push   %eax
  80248f:	e8 e0 ea ff ff       	call   800f74 <sys_env_set_pgfault_upcall>
  802494:	83 c4 10             	add    $0x10,%esp
  802497:	eb bc                	jmp    802455 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802499:	50                   	push   %eax
  80249a:	68 19 2f 80 00       	push   $0x802f19
  80249f:	6a 22                	push   $0x22
  8024a1:	68 31 2f 80 00       	push   $0x802f31
  8024a6:	e8 8b de ff ff       	call   800336 <_panic>

008024ab <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024ab:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024ac:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024b1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024b3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8024b6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8024ba:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8024bd:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8024c1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8024c5:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8024c7:	83 c4 08             	add    $0x8,%esp
	popal
  8024ca:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8024cb:	83 c4 04             	add    $0x4,%esp
	popfl
  8024ce:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8024cf:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8024d0:	c3                   	ret    

008024d1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	56                   	push   %esi
  8024d5:	53                   	push   %ebx
  8024d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8024d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8024df:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8024e1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8024e6:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8024e9:	83 ec 0c             	sub    $0xc,%esp
  8024ec:	50                   	push   %eax
  8024ed:	e8 e7 ea ff ff       	call   800fd9 <sys_ipc_recv>
	if (from_env_store)
  8024f2:	83 c4 10             	add    $0x10,%esp
  8024f5:	85 f6                	test   %esi,%esi
  8024f7:	74 14                	je     80250d <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8024f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 09                	js     80250b <ipc_recv+0x3a>
  802502:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802508:	8b 52 74             	mov    0x74(%edx),%edx
  80250b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80250d:	85 db                	test   %ebx,%ebx
  80250f:	74 14                	je     802525 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802511:	ba 00 00 00 00       	mov    $0x0,%edx
  802516:	85 c0                	test   %eax,%eax
  802518:	78 09                	js     802523 <ipc_recv+0x52>
  80251a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802520:	8b 52 78             	mov    0x78(%edx),%edx
  802523:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802525:	85 c0                	test   %eax,%eax
  802527:	78 08                	js     802531 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802529:	a1 08 40 80 00       	mov    0x804008,%eax
  80252e:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802531:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802534:	5b                   	pop    %ebx
  802535:	5e                   	pop    %esi
  802536:	5d                   	pop    %ebp
  802537:	c3                   	ret    

00802538 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	57                   	push   %edi
  80253c:	56                   	push   %esi
  80253d:	53                   	push   %ebx
  80253e:	83 ec 0c             	sub    $0xc,%esp
  802541:	8b 7d 08             	mov    0x8(%ebp),%edi
  802544:	8b 75 0c             	mov    0xc(%ebp),%esi
  802547:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80254a:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  80254c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802551:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802554:	ff 75 14             	pushl  0x14(%ebp)
  802557:	53                   	push   %ebx
  802558:	56                   	push   %esi
  802559:	57                   	push   %edi
  80255a:	e8 57 ea ff ff       	call   800fb6 <sys_ipc_try_send>
		if (ret == 0)
  80255f:	83 c4 10             	add    $0x10,%esp
  802562:	85 c0                	test   %eax,%eax
  802564:	74 1e                	je     802584 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802566:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802569:	75 07                	jne    802572 <ipc_send+0x3a>
			sys_yield();
  80256b:	e8 9a e8 ff ff       	call   800e0a <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802570:	eb e2                	jmp    802554 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802572:	50                   	push   %eax
  802573:	68 3f 2f 80 00       	push   $0x802f3f
  802578:	6a 3d                	push   $0x3d
  80257a:	68 53 2f 80 00       	push   $0x802f53
  80257f:	e8 b2 dd ff ff       	call   800336 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802584:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    

0080258c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802597:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80259a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025a0:	8b 52 50             	mov    0x50(%edx),%edx
  8025a3:	39 ca                	cmp    %ecx,%edx
  8025a5:	74 11                	je     8025b8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025a7:	83 c0 01             	add    $0x1,%eax
  8025aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025af:	75 e6                	jne    802597 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b6:	eb 0b                	jmp    8025c3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8025b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025c0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    

008025c5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	c1 e8 16             	shr    $0x16,%eax
  8025d0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025dc:	f6 c1 01             	test   $0x1,%cl
  8025df:	74 1d                	je     8025fe <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025e1:	c1 ea 0c             	shr    $0xc,%edx
  8025e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025eb:	f6 c2 01             	test   $0x1,%dl
  8025ee:	74 0e                	je     8025fe <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025f0:	c1 ea 0c             	shr    $0xc,%edx
  8025f3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025fa:	ef 
  8025fb:	0f b7 c0             	movzwl %ax,%eax
}
  8025fe:	5d                   	pop    %ebp
  8025ff:	c3                   	ret    

00802600 <__udivdi3>:
  802600:	55                   	push   %ebp
  802601:	57                   	push   %edi
  802602:	56                   	push   %esi
  802603:	53                   	push   %ebx
  802604:	83 ec 1c             	sub    $0x1c,%esp
  802607:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80260b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80260f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802613:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802617:	85 d2                	test   %edx,%edx
  802619:	75 35                	jne    802650 <__udivdi3+0x50>
  80261b:	39 f3                	cmp    %esi,%ebx
  80261d:	0f 87 bd 00 00 00    	ja     8026e0 <__udivdi3+0xe0>
  802623:	85 db                	test   %ebx,%ebx
  802625:	89 d9                	mov    %ebx,%ecx
  802627:	75 0b                	jne    802634 <__udivdi3+0x34>
  802629:	b8 01 00 00 00       	mov    $0x1,%eax
  80262e:	31 d2                	xor    %edx,%edx
  802630:	f7 f3                	div    %ebx
  802632:	89 c1                	mov    %eax,%ecx
  802634:	31 d2                	xor    %edx,%edx
  802636:	89 f0                	mov    %esi,%eax
  802638:	f7 f1                	div    %ecx
  80263a:	89 c6                	mov    %eax,%esi
  80263c:	89 e8                	mov    %ebp,%eax
  80263e:	89 f7                	mov    %esi,%edi
  802640:	f7 f1                	div    %ecx
  802642:	89 fa                	mov    %edi,%edx
  802644:	83 c4 1c             	add    $0x1c,%esp
  802647:	5b                   	pop    %ebx
  802648:	5e                   	pop    %esi
  802649:	5f                   	pop    %edi
  80264a:	5d                   	pop    %ebp
  80264b:	c3                   	ret    
  80264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802650:	39 f2                	cmp    %esi,%edx
  802652:	77 7c                	ja     8026d0 <__udivdi3+0xd0>
  802654:	0f bd fa             	bsr    %edx,%edi
  802657:	83 f7 1f             	xor    $0x1f,%edi
  80265a:	0f 84 98 00 00 00    	je     8026f8 <__udivdi3+0xf8>
  802660:	89 f9                	mov    %edi,%ecx
  802662:	b8 20 00 00 00       	mov    $0x20,%eax
  802667:	29 f8                	sub    %edi,%eax
  802669:	d3 e2                	shl    %cl,%edx
  80266b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 da                	mov    %ebx,%edx
  802673:	d3 ea                	shr    %cl,%edx
  802675:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802679:	09 d1                	or     %edx,%ecx
  80267b:	89 f2                	mov    %esi,%edx
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 f9                	mov    %edi,%ecx
  802683:	d3 e3                	shl    %cl,%ebx
  802685:	89 c1                	mov    %eax,%ecx
  802687:	d3 ea                	shr    %cl,%edx
  802689:	89 f9                	mov    %edi,%ecx
  80268b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80268f:	d3 e6                	shl    %cl,%esi
  802691:	89 eb                	mov    %ebp,%ebx
  802693:	89 c1                	mov    %eax,%ecx
  802695:	d3 eb                	shr    %cl,%ebx
  802697:	09 de                	or     %ebx,%esi
  802699:	89 f0                	mov    %esi,%eax
  80269b:	f7 74 24 08          	divl   0x8(%esp)
  80269f:	89 d6                	mov    %edx,%esi
  8026a1:	89 c3                	mov    %eax,%ebx
  8026a3:	f7 64 24 0c          	mull   0xc(%esp)
  8026a7:	39 d6                	cmp    %edx,%esi
  8026a9:	72 0c                	jb     8026b7 <__udivdi3+0xb7>
  8026ab:	89 f9                	mov    %edi,%ecx
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	39 c5                	cmp    %eax,%ebp
  8026b1:	73 5d                	jae    802710 <__udivdi3+0x110>
  8026b3:	39 d6                	cmp    %edx,%esi
  8026b5:	75 59                	jne    802710 <__udivdi3+0x110>
  8026b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026ba:	31 ff                	xor    %edi,%edi
  8026bc:	89 fa                	mov    %edi,%edx
  8026be:	83 c4 1c             	add    $0x1c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
  8026c6:	8d 76 00             	lea    0x0(%esi),%esi
  8026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8026d0:	31 ff                	xor    %edi,%edi
  8026d2:	31 c0                	xor    %eax,%eax
  8026d4:	89 fa                	mov    %edi,%edx
  8026d6:	83 c4 1c             	add    $0x1c,%esp
  8026d9:	5b                   	pop    %ebx
  8026da:	5e                   	pop    %esi
  8026db:	5f                   	pop    %edi
  8026dc:	5d                   	pop    %ebp
  8026dd:	c3                   	ret    
  8026de:	66 90                	xchg   %ax,%ax
  8026e0:	31 ff                	xor    %edi,%edi
  8026e2:	89 e8                	mov    %ebp,%eax
  8026e4:	89 f2                	mov    %esi,%edx
  8026e6:	f7 f3                	div    %ebx
  8026e8:	89 fa                	mov    %edi,%edx
  8026ea:	83 c4 1c             	add    $0x1c,%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5e                   	pop    %esi
  8026ef:	5f                   	pop    %edi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    
  8026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026f8:	39 f2                	cmp    %esi,%edx
  8026fa:	72 06                	jb     802702 <__udivdi3+0x102>
  8026fc:	31 c0                	xor    %eax,%eax
  8026fe:	39 eb                	cmp    %ebp,%ebx
  802700:	77 d2                	ja     8026d4 <__udivdi3+0xd4>
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
  802707:	eb cb                	jmp    8026d4 <__udivdi3+0xd4>
  802709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802710:	89 d8                	mov    %ebx,%eax
  802712:	31 ff                	xor    %edi,%edi
  802714:	eb be                	jmp    8026d4 <__udivdi3+0xd4>
  802716:	66 90                	xchg   %ax,%ax
  802718:	66 90                	xchg   %ax,%ax
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__umoddi3>:
  802720:	55                   	push   %ebp
  802721:	57                   	push   %edi
  802722:	56                   	push   %esi
  802723:	53                   	push   %ebx
  802724:	83 ec 1c             	sub    $0x1c,%esp
  802727:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80272b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80272f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802733:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802737:	85 ed                	test   %ebp,%ebp
  802739:	89 f0                	mov    %esi,%eax
  80273b:	89 da                	mov    %ebx,%edx
  80273d:	75 19                	jne    802758 <__umoddi3+0x38>
  80273f:	39 df                	cmp    %ebx,%edi
  802741:	0f 86 b1 00 00 00    	jbe    8027f8 <__umoddi3+0xd8>
  802747:	f7 f7                	div    %edi
  802749:	89 d0                	mov    %edx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	39 dd                	cmp    %ebx,%ebp
  80275a:	77 f1                	ja     80274d <__umoddi3+0x2d>
  80275c:	0f bd cd             	bsr    %ebp,%ecx
  80275f:	83 f1 1f             	xor    $0x1f,%ecx
  802762:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802766:	0f 84 b4 00 00 00    	je     802820 <__umoddi3+0x100>
  80276c:	b8 20 00 00 00       	mov    $0x20,%eax
  802771:	89 c2                	mov    %eax,%edx
  802773:	8b 44 24 04          	mov    0x4(%esp),%eax
  802777:	29 c2                	sub    %eax,%edx
  802779:	89 c1                	mov    %eax,%ecx
  80277b:	89 f8                	mov    %edi,%eax
  80277d:	d3 e5                	shl    %cl,%ebp
  80277f:	89 d1                	mov    %edx,%ecx
  802781:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802785:	d3 e8                	shr    %cl,%eax
  802787:	09 c5                	or     %eax,%ebp
  802789:	8b 44 24 04          	mov    0x4(%esp),%eax
  80278d:	89 c1                	mov    %eax,%ecx
  80278f:	d3 e7                	shl    %cl,%edi
  802791:	89 d1                	mov    %edx,%ecx
  802793:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802797:	89 df                	mov    %ebx,%edi
  802799:	d3 ef                	shr    %cl,%edi
  80279b:	89 c1                	mov    %eax,%ecx
  80279d:	89 f0                	mov    %esi,%eax
  80279f:	d3 e3                	shl    %cl,%ebx
  8027a1:	89 d1                	mov    %edx,%ecx
  8027a3:	89 fa                	mov    %edi,%edx
  8027a5:	d3 e8                	shr    %cl,%eax
  8027a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027ac:	09 d8                	or     %ebx,%eax
  8027ae:	f7 f5                	div    %ebp
  8027b0:	d3 e6                	shl    %cl,%esi
  8027b2:	89 d1                	mov    %edx,%ecx
  8027b4:	f7 64 24 08          	mull   0x8(%esp)
  8027b8:	39 d1                	cmp    %edx,%ecx
  8027ba:	89 c3                	mov    %eax,%ebx
  8027bc:	89 d7                	mov    %edx,%edi
  8027be:	72 06                	jb     8027c6 <__umoddi3+0xa6>
  8027c0:	75 0e                	jne    8027d0 <__umoddi3+0xb0>
  8027c2:	39 c6                	cmp    %eax,%esi
  8027c4:	73 0a                	jae    8027d0 <__umoddi3+0xb0>
  8027c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8027ca:	19 ea                	sbb    %ebp,%edx
  8027cc:	89 d7                	mov    %edx,%edi
  8027ce:	89 c3                	mov    %eax,%ebx
  8027d0:	89 ca                	mov    %ecx,%edx
  8027d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8027d7:	29 de                	sub    %ebx,%esi
  8027d9:	19 fa                	sbb    %edi,%edx
  8027db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8027df:	89 d0                	mov    %edx,%eax
  8027e1:	d3 e0                	shl    %cl,%eax
  8027e3:	89 d9                	mov    %ebx,%ecx
  8027e5:	d3 ee                	shr    %cl,%esi
  8027e7:	d3 ea                	shr    %cl,%edx
  8027e9:	09 f0                	or     %esi,%eax
  8027eb:	83 c4 1c             	add    $0x1c,%esp
  8027ee:	5b                   	pop    %ebx
  8027ef:	5e                   	pop    %esi
  8027f0:	5f                   	pop    %edi
  8027f1:	5d                   	pop    %ebp
  8027f2:	c3                   	ret    
  8027f3:	90                   	nop
  8027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	85 ff                	test   %edi,%edi
  8027fa:	89 f9                	mov    %edi,%ecx
  8027fc:	75 0b                	jne    802809 <__umoddi3+0xe9>
  8027fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802803:	31 d2                	xor    %edx,%edx
  802805:	f7 f7                	div    %edi
  802807:	89 c1                	mov    %eax,%ecx
  802809:	89 d8                	mov    %ebx,%eax
  80280b:	31 d2                	xor    %edx,%edx
  80280d:	f7 f1                	div    %ecx
  80280f:	89 f0                	mov    %esi,%eax
  802811:	f7 f1                	div    %ecx
  802813:	e9 31 ff ff ff       	jmp    802749 <__umoddi3+0x29>
  802818:	90                   	nop
  802819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802820:	39 dd                	cmp    %ebx,%ebp
  802822:	72 08                	jb     80282c <__umoddi3+0x10c>
  802824:	39 f7                	cmp    %esi,%edi
  802826:	0f 87 21 ff ff ff    	ja     80274d <__umoddi3+0x2d>
  80282c:	89 da                	mov    %ebx,%edx
  80282e:	89 f0                	mov    %esi,%eax
  802830:	29 f8                	sub    %edi,%eax
  802832:	19 ea                	sbb    %ebp,%edx
  802834:	e9 14 ff ff ff       	jmp    80274d <__umoddi3+0x2d>

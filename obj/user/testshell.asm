
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 5f 04 00 00       	call   800490 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 79 18 00 00       	call   8018c8 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 6f 18 00 00       	call   8018c8 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 80 2e 80 00 	movl   $0x802e80,(%esp)
  800060:	e8 66 05 00 00       	call   8005cb <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 eb 2e 80 00 	movl   $0x802eeb,(%esp)
  80006c:	e8 5a 05 00 00       	call   8005cb <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	eb 0d                	jmp    800086 <wrong+0x53>
		sys_cputs(buf, n);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	e8 a4 0e 00 00       	call   800f27 <sys_cputs>
  800083:	83 c4 10             	add    $0x10,%esp
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 63                	push   $0x63
  80008b:	53                   	push   %ebx
  80008c:	57                   	push   %edi
  80008d:	e8 e6 16 00 00       	call   801778 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7f e0                	jg     800079 <wrong+0x46>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 fa 2e 80 00       	push   $0x802efa
  8000a1:	e8 25 05 00 00       	call   8005cb <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 6f 0e 00 00       	call   800f27 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 b1 16 00 00       	call   801778 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 f5 2e 80 00       	push   $0x802ef5
  8000d6:	e8 f0 04 00 00       	call   8005cb <cprintf>
	exit();
  8000db:	e8 f6 03 00 00       	call   8004d6 <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 41 15 00 00       	call   80163c <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 35 15 00 00       	call   80163c <close>
	opencons();
  800107:	e8 32 03 00 00       	call   80043e <opencons>
	opencons();
  80010c:	e8 2d 03 00 00       	call   80043e <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 08 2f 80 00       	push   $0x802f08
  80011b:	e8 bd 1a 00 00       	call   801bdd <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e9 00 00 00    	js     800216 <umain+0x12b>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 76 27 00 00       	call   8028af <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e4 00 00 00    	js     800228 <umain+0x13d>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 a4 2e 80 00       	push   $0x802ea4
  80014f:	e8 77 04 00 00       	call   8005cb <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 73 11 00 00       	call   8012cc <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d6 00 00 00    	js     80023a <umain+0x14f>
	if (r == 0) {
  800164:	85 c0                	test   %eax,%eax
  800166:	75 6f                	jne    8001d7 <umain+0xec>
		dup(rfd, 0);
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	53                   	push   %ebx
  80016e:	e8 19 15 00 00       	call   80168c <dup>
		dup(wfd, 1);
  800173:	83 c4 08             	add    $0x8,%esp
  800176:	6a 01                	push   $0x1
  800178:	56                   	push   %esi
  800179:	e8 0e 15 00 00       	call   80168c <dup>
		close(rfd);
  80017e:	89 1c 24             	mov    %ebx,(%esp)
  800181:	e8 b6 14 00 00       	call   80163c <close>
		close(wfd);
  800186:	89 34 24             	mov    %esi,(%esp)
  800189:	e8 ae 14 00 00       	call   80163c <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018e:	6a 00                	push   $0x0
  800190:	68 4e 2f 80 00       	push   $0x802f4e
  800195:	68 12 2f 80 00       	push   $0x802f12
  80019a:	68 51 2f 80 00       	push   $0x802f51
  80019f:	e8 58 20 00 00       	call   8021fc <spawnl>
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	83 c4 20             	add    $0x20,%esp
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	0f 88 9b 00 00 00    	js     80024c <umain+0x161>
		close(0);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	e8 81 14 00 00       	call   80163c <close>
		close(1);
  8001bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c2:	e8 75 14 00 00       	call   80163c <close>
		wait(r);
  8001c7:	89 3c 24             	mov    %edi,(%esp)
  8001ca:	e8 5c 28 00 00       	call   802a2b <wait>
		exit();
  8001cf:	e8 02 03 00 00       	call   8004d6 <exit>
  8001d4:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	53                   	push   %ebx
  8001db:	e8 5c 14 00 00       	call   80163c <close>
	close(wfd);
  8001e0:	89 34 24             	mov    %esi,(%esp)
  8001e3:	e8 54 14 00 00       	call   80163c <close>
	rfd = pfds[0];
  8001e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ee:	83 c4 08             	add    $0x8,%esp
  8001f1:	6a 00                	push   $0x0
  8001f3:	68 5f 2f 80 00       	push   $0x802f5f
  8001f8:	e8 e0 19 00 00       	call   801bdd <open>
  8001fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	85 c0                	test   %eax,%eax
  800205:	78 57                	js     80025e <umain+0x173>
  800207:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020c:	bf 00 00 00 00       	mov    $0x0,%edi
  800211:	e9 9a 00 00 00       	jmp    8002b0 <umain+0x1c5>
		panic("open testshell.sh: %e", rfd);
  800216:	50                   	push   %eax
  800217:	68 15 2f 80 00       	push   $0x802f15
  80021c:	6a 13                	push   $0x13
  80021e:	68 2b 2f 80 00       	push   $0x802f2b
  800223:	e8 c8 02 00 00       	call   8004f0 <_panic>
		panic("pipe: %e", wfd);
  800228:	50                   	push   %eax
  800229:	68 3c 2f 80 00       	push   $0x802f3c
  80022e:	6a 15                	push   $0x15
  800230:	68 2b 2f 80 00       	push   $0x802f2b
  800235:	e8 b6 02 00 00       	call   8004f0 <_panic>
		panic("fork: %e", r);
  80023a:	50                   	push   %eax
  80023b:	68 45 2f 80 00       	push   $0x802f45
  800240:	6a 1a                	push   $0x1a
  800242:	68 2b 2f 80 00       	push   $0x802f2b
  800247:	e8 a4 02 00 00       	call   8004f0 <_panic>
			panic("spawn: %e", r);
  80024c:	50                   	push   %eax
  80024d:	68 55 2f 80 00       	push   $0x802f55
  800252:	6a 21                	push   $0x21
  800254:	68 2b 2f 80 00       	push   $0x802f2b
  800259:	e8 92 02 00 00       	call   8004f0 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025e:	50                   	push   %eax
  80025f:	68 c8 2e 80 00       	push   $0x802ec8
  800264:	6a 2c                	push   $0x2c
  800266:	68 2b 2f 80 00       	push   $0x802f2b
  80026b:	e8 80 02 00 00       	call   8004f0 <_panic>
			panic("reading testshell.out: %e", n1);
  800270:	53                   	push   %ebx
  800271:	68 6d 2f 80 00       	push   $0x802f6d
  800276:	6a 33                	push   $0x33
  800278:	68 2b 2f 80 00       	push   $0x802f2b
  80027d:	e8 6e 02 00 00       	call   8004f0 <_panic>
			panic("reading testshell.key: %e", n2);
  800282:	50                   	push   %eax
  800283:	68 87 2f 80 00       	push   $0x802f87
  800288:	6a 35                	push   $0x35
  80028a:	68 2b 2f 80 00       	push   $0x802f2b
  80028f:	e8 5c 02 00 00       	call   8004f0 <_panic>
			wrong(rfd, kfd, nloff);
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 d4             	pushl  -0x2c(%ebp)
  80029b:	ff 75 d0             	pushl  -0x30(%ebp)
  80029e:	e8 90 fd ff ff       	call   800033 <wrong>
  8002a3:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a6:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002aa:	0f 44 fe             	cmove  %esi,%edi
  8002ad:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	6a 01                	push   $0x1
  8002b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002bc:	e8 b7 14 00 00       	call   801778 <read>
  8002c1:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c3:	83 c4 0c             	add    $0xc,%esp
  8002c6:	6a 01                	push   $0x1
  8002c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002cb:	50                   	push   %eax
  8002cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cf:	e8 a4 14 00 00       	call   801778 <read>
		if (n1 < 0)
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	85 db                	test   %ebx,%ebx
  8002d9:	78 95                	js     800270 <umain+0x185>
		if (n2 < 0)
  8002db:	85 c0                	test   %eax,%eax
  8002dd:	78 a3                	js     800282 <umain+0x197>
		if (n1 == 0 && n2 == 0)
  8002df:	89 da                	mov    %ebx,%edx
  8002e1:	09 c2                	or     %eax,%edx
  8002e3:	74 15                	je     8002fa <umain+0x20f>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e5:	83 fb 01             	cmp    $0x1,%ebx
  8002e8:	75 aa                	jne    800294 <umain+0x1a9>
  8002ea:	83 f8 01             	cmp    $0x1,%eax
  8002ed:	75 a5                	jne    800294 <umain+0x1a9>
  8002ef:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f3:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f6:	75 9c                	jne    800294 <umain+0x1a9>
  8002f8:	eb ac                	jmp    8002a6 <umain+0x1bb>
	cprintf("shell ran correctly\n");
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 a1 2f 80 00       	push   $0x802fa1
  800302:	e8 c4 02 00 00       	call   8005cb <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800307:	cc                   	int3   
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800323:	68 b6 2f 80 00       	push   $0x802fb6
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	e8 ba 08 00 00       	call   800bea <strcpy>
	return 0;
}
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <devcons_write>:
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	57                   	push   %edi
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
  80033d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800343:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800348:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80034e:	eb 2f                	jmp    80037f <devcons_write+0x48>
		m = n - tot;
  800350:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800353:	29 f3                	sub    %esi,%ebx
  800355:	83 fb 7f             	cmp    $0x7f,%ebx
  800358:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	53                   	push   %ebx
  800364:	89 f0                	mov    %esi,%eax
  800366:	03 45 0c             	add    0xc(%ebp),%eax
  800369:	50                   	push   %eax
  80036a:	57                   	push   %edi
  80036b:	e8 08 0a 00 00       	call   800d78 <memmove>
		sys_cputs(buf, m);
  800370:	83 c4 08             	add    $0x8,%esp
  800373:	53                   	push   %ebx
  800374:	57                   	push   %edi
  800375:	e8 ad 0b 00 00       	call   800f27 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80037a:	01 de                	add    %ebx,%esi
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800382:	72 cc                	jb     800350 <devcons_write+0x19>
}
  800384:	89 f0                	mov    %esi,%eax
  800386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800389:	5b                   	pop    %ebx
  80038a:	5e                   	pop    %esi
  80038b:	5f                   	pop    %edi
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <devcons_read>:
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80039d:	75 07                	jne    8003a6 <devcons_read+0x18>
}
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    
		sys_yield();
  8003a1:	e8 1e 0c 00 00       	call   800fc4 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8003a6:	e8 9a 0b 00 00       	call   800f45 <sys_cgetc>
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	74 f2                	je     8003a1 <devcons_read+0x13>
	if (c < 0)
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	78 ec                	js     80039f <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8003b3:	83 f8 04             	cmp    $0x4,%eax
  8003b6:	74 0c                	je     8003c4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8003b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bb:	88 02                	mov    %al,(%edx)
	return 1;
  8003bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8003c2:	eb db                	jmp    80039f <devcons_read+0x11>
		return 0;
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	eb d4                	jmp    80039f <devcons_read+0x11>

008003cb <cputchar>:
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003d7:	6a 01                	push   $0x1
  8003d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003dc:	50                   	push   %eax
  8003dd:	e8 45 0b 00 00       	call   800f27 <sys_cputs>
}
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <getchar>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003ed:	6a 01                	push   $0x1
  8003ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f2:	50                   	push   %eax
  8003f3:	6a 00                	push   $0x0
  8003f5:	e8 7e 13 00 00       	call   801778 <read>
	if (r < 0)
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	85 c0                	test   %eax,%eax
  8003ff:	78 08                	js     800409 <getchar+0x22>
	if (r < 1)
  800401:	85 c0                	test   %eax,%eax
  800403:	7e 06                	jle    80040b <getchar+0x24>
	return c;
  800405:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800409:	c9                   	leave  
  80040a:	c3                   	ret    
		return -E_EOF;
  80040b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800410:	eb f7                	jmp    800409 <getchar+0x22>

00800412 <iscons>:
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800418:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 e3 10 00 00       	call   801507 <fd_lookup>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	85 c0                	test   %eax,%eax
  800429:	78 11                	js     80043c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80042b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800434:	39 10                	cmp    %edx,(%eax)
  800436:	0f 94 c0             	sete   %al
  800439:	0f b6 c0             	movzbl %al,%eax
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <opencons>:
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800447:	50                   	push   %eax
  800448:	e8 6b 10 00 00       	call   8014b8 <fd_alloc>
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 c0                	test   %eax,%eax
  800452:	78 3a                	js     80048e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 07 04 00 00       	push   $0x407
  80045c:	ff 75 f4             	pushl  -0xc(%ebp)
  80045f:	6a 00                	push   $0x0
  800461:	e8 7d 0b 00 00       	call   800fe3 <sys_page_alloc>
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	85 c0                	test   %eax,%eax
  80046b:	78 21                	js     80048e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80046d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800470:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800476:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	50                   	push   %eax
  800486:	e8 06 10 00 00       	call   801491 <fd2num>
  80048b:	83 c4 10             	add    $0x10,%esp
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	56                   	push   %esi
  800494:	53                   	push   %ebx
  800495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800498:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80049b:	e8 05 0b 00 00       	call   800fa5 <sys_getenvid>
  8004a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ad:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7e 07                	jle    8004bd <libmain+0x2d>
		binaryname = argv[0];
  8004b6:	8b 06                	mov    (%esi),%eax
  8004b8:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	56                   	push   %esi
  8004c1:	53                   	push   %ebx
  8004c2:	e8 24 fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c7:	e8 0a 00 00 00       	call   8004d6 <exit>
}
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004d2:	5b                   	pop    %ebx
  8004d3:	5e                   	pop    %esi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004dc:	e8 86 11 00 00       	call   801667 <close_all>
	sys_env_destroy(0);
  8004e1:	83 ec 0c             	sub    $0xc,%esp
  8004e4:	6a 00                	push   $0x0
  8004e6:	e8 79 0a 00 00       	call   800f64 <sys_env_destroy>
}
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	56                   	push   %esi
  8004f4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004f5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004f8:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004fe:	e8 a2 0a 00 00       	call   800fa5 <sys_getenvid>
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	56                   	push   %esi
  80050d:	50                   	push   %eax
  80050e:	68 cc 2f 80 00       	push   $0x802fcc
  800513:	e8 b3 00 00 00       	call   8005cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800518:	83 c4 18             	add    $0x18,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 75 10             	pushl  0x10(%ebp)
  80051f:	e8 56 00 00 00       	call   80057a <vcprintf>
	cprintf("\n");
  800524:	c7 04 24 f8 2e 80 00 	movl   $0x802ef8,(%esp)
  80052b:	e8 9b 00 00 00       	call   8005cb <cprintf>
  800530:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800533:	cc                   	int3   
  800534:	eb fd                	jmp    800533 <_panic+0x43>

00800536 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	53                   	push   %ebx
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800540:	8b 13                	mov    (%ebx),%edx
  800542:	8d 42 01             	lea    0x1(%edx),%eax
  800545:	89 03                	mov    %eax,(%ebx)
  800547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80054a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80054e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800553:	74 09                	je     80055e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800555:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	68 ff 00 00 00       	push   $0xff
  800566:	8d 43 08             	lea    0x8(%ebx),%eax
  800569:	50                   	push   %eax
  80056a:	e8 b8 09 00 00       	call   800f27 <sys_cputs>
		b->idx = 0;
  80056f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	eb db                	jmp    800555 <putch+0x1f>

0080057a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800583:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058a:	00 00 00 
	b.cnt = 0;
  80058d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800594:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800597:	ff 75 0c             	pushl  0xc(%ebp)
  80059a:	ff 75 08             	pushl  0x8(%ebp)
  80059d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a3:	50                   	push   %eax
  8005a4:	68 36 05 80 00       	push   $0x800536
  8005a9:	e8 1a 01 00 00       	call   8006c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ae:	83 c4 08             	add    $0x8,%esp
  8005b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	e8 64 09 00 00       	call   800f27 <sys_cputs>

	return b.cnt;
}
  8005c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	e8 9d ff ff ff       	call   80057a <vcprintf>
	va_end(ap);

	return cnt;
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	57                   	push   %edi
  8005e3:	56                   	push   %esi
  8005e4:	53                   	push   %ebx
  8005e5:	83 ec 1c             	sub    $0x1c,%esp
  8005e8:	89 c7                	mov    %eax,%edi
  8005ea:	89 d6                	mov    %edx,%esi
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800603:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800606:	39 d3                	cmp    %edx,%ebx
  800608:	72 05                	jb     80060f <printnum+0x30>
  80060a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80060d:	77 7a                	ja     800689 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80061b:	53                   	push   %ebx
  80061c:	ff 75 10             	pushl  0x10(%ebp)
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 e4             	pushl  -0x1c(%ebp)
  800625:	ff 75 e0             	pushl  -0x20(%ebp)
  800628:	ff 75 dc             	pushl  -0x24(%ebp)
  80062b:	ff 75 d8             	pushl  -0x28(%ebp)
  80062e:	e8 0d 26 00 00       	call   802c40 <__udivdi3>
  800633:	83 c4 18             	add    $0x18,%esp
  800636:	52                   	push   %edx
  800637:	50                   	push   %eax
  800638:	89 f2                	mov    %esi,%edx
  80063a:	89 f8                	mov    %edi,%eax
  80063c:	e8 9e ff ff ff       	call   8005df <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 13                	jmp    800659 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	56                   	push   %esi
  80064a:	ff 75 18             	pushl  0x18(%ebp)
  80064d:	ff d7                	call   *%edi
  80064f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800652:	83 eb 01             	sub    $0x1,%ebx
  800655:	85 db                	test   %ebx,%ebx
  800657:	7f ed                	jg     800646 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	56                   	push   %esi
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	ff 75 e4             	pushl  -0x1c(%ebp)
  800663:	ff 75 e0             	pushl  -0x20(%ebp)
  800666:	ff 75 dc             	pushl  -0x24(%ebp)
  800669:	ff 75 d8             	pushl  -0x28(%ebp)
  80066c:	e8 ef 26 00 00       	call   802d60 <__umoddi3>
  800671:	83 c4 14             	add    $0x14,%esp
  800674:	0f be 80 ef 2f 80 00 	movsbl 0x802fef(%eax),%eax
  80067b:	50                   	push   %eax
  80067c:	ff d7                	call   *%edi
}
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800684:	5b                   	pop    %ebx
  800685:	5e                   	pop    %esi
  800686:	5f                   	pop    %edi
  800687:	5d                   	pop    %ebp
  800688:	c3                   	ret    
  800689:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80068c:	eb c4                	jmp    800652 <printnum+0x73>

0080068e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800694:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	3b 50 04             	cmp    0x4(%eax),%edx
  80069d:	73 0a                	jae    8006a9 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006a2:	89 08                	mov    %ecx,(%eax)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	88 02                	mov    %al,(%edx)
}
  8006a9:	5d                   	pop    %ebp
  8006aa:	c3                   	ret    

008006ab <printfmt>:
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 10             	pushl  0x10(%ebp)
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 05 00 00 00       	call   8006c8 <vprintfmt>
}
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <vprintfmt>:
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	57                   	push   %edi
  8006cc:	56                   	push   %esi
  8006cd:	53                   	push   %ebx
  8006ce:	83 ec 2c             	sub    $0x2c,%esp
  8006d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006da:	e9 c1 03 00 00       	jmp    800aa0 <vprintfmt+0x3d8>
		padc = ' ';
  8006df:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006e3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006fd:	8d 47 01             	lea    0x1(%edi),%eax
  800700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800703:	0f b6 17             	movzbl (%edi),%edx
  800706:	8d 42 dd             	lea    -0x23(%edx),%eax
  800709:	3c 55                	cmp    $0x55,%al
  80070b:	0f 87 12 04 00 00    	ja     800b23 <vprintfmt+0x45b>
  800711:	0f b6 c0             	movzbl %al,%eax
  800714:	ff 24 85 40 31 80 00 	jmp    *0x803140(,%eax,4)
  80071b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80071e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800722:	eb d9                	jmp    8006fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800724:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800727:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80072b:	eb d0                	jmp    8006fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80072d:	0f b6 d2             	movzbl %dl,%edx
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80073b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80073e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800742:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800745:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800748:	83 f9 09             	cmp    $0x9,%ecx
  80074b:	77 55                	ja     8007a2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80074d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800750:	eb e9                	jmp    80073b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 40 04             	lea    0x4(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800763:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800766:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076a:	79 91                	jns    8006fd <vprintfmt+0x35>
				width = precision, precision = -1;
  80076c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80076f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800772:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800779:	eb 82                	jmp    8006fd <vprintfmt+0x35>
  80077b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80077e:	85 c0                	test   %eax,%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	0f 49 d0             	cmovns %eax,%edx
  800788:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80078e:	e9 6a ff ff ff       	jmp    8006fd <vprintfmt+0x35>
  800793:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800796:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80079d:	e9 5b ff ff ff       	jmp    8006fd <vprintfmt+0x35>
  8007a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a8:	eb bc                	jmp    800766 <vprintfmt+0x9e>
			lflag++;
  8007aa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007b0:	e9 48 ff ff ff       	jmp    8006fd <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 78 04             	lea    0x4(%eax),%edi
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	ff 30                	pushl  (%eax)
  8007c1:	ff d6                	call   *%esi
			break;
  8007c3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007c6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007c9:	e9 cf 02 00 00       	jmp    800a9d <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 78 04             	lea    0x4(%eax),%edi
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	99                   	cltd   
  8007d7:	31 d0                	xor    %edx,%eax
  8007d9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007db:	83 f8 0f             	cmp    $0xf,%eax
  8007de:	7f 23                	jg     800803 <vprintfmt+0x13b>
  8007e0:	8b 14 85 a0 32 80 00 	mov    0x8032a0(,%eax,4),%edx
  8007e7:	85 d2                	test   %edx,%edx
  8007e9:	74 18                	je     800803 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007eb:	52                   	push   %edx
  8007ec:	68 c1 34 80 00       	push   $0x8034c1
  8007f1:	53                   	push   %ebx
  8007f2:	56                   	push   %esi
  8007f3:	e8 b3 fe ff ff       	call   8006ab <printfmt>
  8007f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007fb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007fe:	e9 9a 02 00 00       	jmp    800a9d <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800803:	50                   	push   %eax
  800804:	68 07 30 80 00       	push   $0x803007
  800809:	53                   	push   %ebx
  80080a:	56                   	push   %esi
  80080b:	e8 9b fe ff ff       	call   8006ab <printfmt>
  800810:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800813:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800816:	e9 82 02 00 00       	jmp    800a9d <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800829:	85 ff                	test   %edi,%edi
  80082b:	b8 00 30 80 00       	mov    $0x803000,%eax
  800830:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800833:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800837:	0f 8e bd 00 00 00    	jle    8008fa <vprintfmt+0x232>
  80083d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800841:	75 0e                	jne    800851 <vprintfmt+0x189>
  800843:	89 75 08             	mov    %esi,0x8(%ebp)
  800846:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800849:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80084c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80084f:	eb 6d                	jmp    8008be <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 d0             	pushl  -0x30(%ebp)
  800857:	57                   	push   %edi
  800858:	e8 6e 03 00 00       	call   800bcb <strnlen>
  80085d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800860:	29 c1                	sub    %eax,%ecx
  800862:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800865:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800868:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80086c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800872:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800874:	eb 0f                	jmp    800885 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	ff 75 e0             	pushl  -0x20(%ebp)
  80087d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80087f:	83 ef 01             	sub    $0x1,%edi
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	85 ff                	test   %edi,%edi
  800887:	7f ed                	jg     800876 <vprintfmt+0x1ae>
  800889:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80088c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80088f:	85 c9                	test   %ecx,%ecx
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	0f 49 c1             	cmovns %ecx,%eax
  800899:	29 c1                	sub    %eax,%ecx
  80089b:	89 75 08             	mov    %esi,0x8(%ebp)
  80089e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008a4:	89 cb                	mov    %ecx,%ebx
  8008a6:	eb 16                	jmp    8008be <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8008a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008ac:	75 31                	jne    8008df <vprintfmt+0x217>
					putch(ch, putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	ff 55 08             	call   *0x8(%ebp)
  8008b8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bb:	83 eb 01             	sub    $0x1,%ebx
  8008be:	83 c7 01             	add    $0x1,%edi
  8008c1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008c5:	0f be c2             	movsbl %dl,%eax
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	74 59                	je     800925 <vprintfmt+0x25d>
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	78 d8                	js     8008a8 <vprintfmt+0x1e0>
  8008d0:	83 ee 01             	sub    $0x1,%esi
  8008d3:	79 d3                	jns    8008a8 <vprintfmt+0x1e0>
  8008d5:	89 df                	mov    %ebx,%edi
  8008d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008dd:	eb 37                	jmp    800916 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008df:	0f be d2             	movsbl %dl,%edx
  8008e2:	83 ea 20             	sub    $0x20,%edx
  8008e5:	83 fa 5e             	cmp    $0x5e,%edx
  8008e8:	76 c4                	jbe    8008ae <vprintfmt+0x1e6>
					putch('?', putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	6a 3f                	push   $0x3f
  8008f2:	ff 55 08             	call   *0x8(%ebp)
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	eb c1                	jmp    8008bb <vprintfmt+0x1f3>
  8008fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8008fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800900:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800903:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800906:	eb b6                	jmp    8008be <vprintfmt+0x1f6>
				putch(' ', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	6a 20                	push   $0x20
  80090e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800910:	83 ef 01             	sub    $0x1,%edi
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	85 ff                	test   %edi,%edi
  800918:	7f ee                	jg     800908 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80091a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
  800920:	e9 78 01 00 00       	jmp    800a9d <vprintfmt+0x3d5>
  800925:	89 df                	mov    %ebx,%edi
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80092d:	eb e7                	jmp    800916 <vprintfmt+0x24e>
	if (lflag >= 2)
  80092f:	83 f9 01             	cmp    $0x1,%ecx
  800932:	7e 3f                	jle    800973 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 50 04             	mov    0x4(%eax),%edx
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8d 40 08             	lea    0x8(%eax),%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80094b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094f:	79 5c                	jns    8009ad <vprintfmt+0x2e5>
				putch('-', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	53                   	push   %ebx
  800955:	6a 2d                	push   $0x2d
  800957:	ff d6                	call   *%esi
				num = -(long long) num;
  800959:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80095c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80095f:	f7 da                	neg    %edx
  800961:	83 d1 00             	adc    $0x0,%ecx
  800964:	f7 d9                	neg    %ecx
  800966:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800969:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096e:	e9 10 01 00 00       	jmp    800a83 <vprintfmt+0x3bb>
	else if (lflag)
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 1b                	jne    800992 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097f:	89 c1                	mov    %eax,%ecx
  800981:	c1 f9 1f             	sar    $0x1f,%ecx
  800984:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	8d 40 04             	lea    0x4(%eax),%eax
  80098d:	89 45 14             	mov    %eax,0x14(%ebp)
  800990:	eb b9                	jmp    80094b <vprintfmt+0x283>
		return va_arg(*ap, long);
  800992:	8b 45 14             	mov    0x14(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099a:	89 c1                	mov    %eax,%ecx
  80099c:	c1 f9 1f             	sar    $0x1f,%ecx
  80099f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	8d 40 04             	lea    0x4(%eax),%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ab:	eb 9e                	jmp    80094b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8009ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009b0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8009b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b8:	e9 c6 00 00 00       	jmp    800a83 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8009bd:	83 f9 01             	cmp    $0x1,%ecx
  8009c0:	7e 18                	jle    8009da <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	8b 10                	mov    (%eax),%edx
  8009c7:	8b 48 04             	mov    0x4(%eax),%ecx
  8009ca:	8d 40 08             	lea    0x8(%eax),%eax
  8009cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d5:	e9 a9 00 00 00       	jmp    800a83 <vprintfmt+0x3bb>
	else if (lflag)
  8009da:	85 c9                	test   %ecx,%ecx
  8009dc:	75 1a                	jne    8009f8 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	8b 10                	mov    (%eax),%edx
  8009e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e8:	8d 40 04             	lea    0x4(%eax),%eax
  8009eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009ee:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f3:	e9 8b 00 00 00       	jmp    800a83 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	8b 10                	mov    (%eax),%edx
  8009fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a02:	8d 40 04             	lea    0x4(%eax),%eax
  800a05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a08:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a0d:	eb 74                	jmp    800a83 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800a0f:	83 f9 01             	cmp    $0x1,%ecx
  800a12:	7e 15                	jle    800a29 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8b 10                	mov    (%eax),%edx
  800a19:	8b 48 04             	mov    0x4(%eax),%ecx
  800a1c:	8d 40 08             	lea    0x8(%eax),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a22:	b8 08 00 00 00       	mov    $0x8,%eax
  800a27:	eb 5a                	jmp    800a83 <vprintfmt+0x3bb>
	else if (lflag)
  800a29:	85 c9                	test   %ecx,%ecx
  800a2b:	75 17                	jne    800a44 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	8b 10                	mov    (%eax),%edx
  800a32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a37:	8d 40 04             	lea    0x4(%eax),%eax
  800a3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a3d:	b8 08 00 00 00       	mov    $0x8,%eax
  800a42:	eb 3f                	jmp    800a83 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	8b 10                	mov    (%eax),%edx
  800a49:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a4e:	8d 40 04             	lea    0x4(%eax),%eax
  800a51:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a54:	b8 08 00 00 00       	mov    $0x8,%eax
  800a59:	eb 28                	jmp    800a83 <vprintfmt+0x3bb>
			putch('0', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	53                   	push   %ebx
  800a5f:	6a 30                	push   $0x30
  800a61:	ff d6                	call   *%esi
			putch('x', putdat);
  800a63:	83 c4 08             	add    $0x8,%esp
  800a66:	53                   	push   %ebx
  800a67:	6a 78                	push   $0x78
  800a69:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8b 10                	mov    (%eax),%edx
  800a70:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a75:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a78:	8d 40 04             	lea    0x4(%eax),%eax
  800a7b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a7e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800a8a:	57                   	push   %edi
  800a8b:	ff 75 e0             	pushl  -0x20(%ebp)
  800a8e:	50                   	push   %eax
  800a8f:	51                   	push   %ecx
  800a90:	52                   	push   %edx
  800a91:	89 da                	mov    %ebx,%edx
  800a93:	89 f0                	mov    %esi,%eax
  800a95:	e8 45 fb ff ff       	call   8005df <printnum>
			break;
  800a9a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800a9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa0:	83 c7 01             	add    $0x1,%edi
  800aa3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800aa7:	83 f8 25             	cmp    $0x25,%eax
  800aaa:	0f 84 2f fc ff ff    	je     8006df <vprintfmt+0x17>
			if (ch == '\0')
  800ab0:	85 c0                	test   %eax,%eax
  800ab2:	0f 84 8b 00 00 00    	je     800b43 <vprintfmt+0x47b>
			putch(ch, putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	53                   	push   %ebx
  800abc:	50                   	push   %eax
  800abd:	ff d6                	call   *%esi
  800abf:	83 c4 10             	add    $0x10,%esp
  800ac2:	eb dc                	jmp    800aa0 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800ac4:	83 f9 01             	cmp    $0x1,%ecx
  800ac7:	7e 15                	jle    800ade <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  800acc:	8b 10                	mov    (%eax),%edx
  800ace:	8b 48 04             	mov    0x4(%eax),%ecx
  800ad1:	8d 40 08             	lea    0x8(%eax),%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad7:	b8 10 00 00 00       	mov    $0x10,%eax
  800adc:	eb a5                	jmp    800a83 <vprintfmt+0x3bb>
	else if (lflag)
  800ade:	85 c9                	test   %ecx,%ecx
  800ae0:	75 17                	jne    800af9 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae5:	8b 10                	mov    (%eax),%edx
  800ae7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aec:	8d 40 04             	lea    0x4(%eax),%eax
  800aef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800af2:	b8 10 00 00 00       	mov    $0x10,%eax
  800af7:	eb 8a                	jmp    800a83 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8b 10                	mov    (%eax),%edx
  800afe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b03:	8d 40 04             	lea    0x4(%eax),%eax
  800b06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b09:	b8 10 00 00 00       	mov    $0x10,%eax
  800b0e:	e9 70 ff ff ff       	jmp    800a83 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	53                   	push   %ebx
  800b17:	6a 25                	push   $0x25
  800b19:	ff d6                	call   *%esi
			break;
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	e9 7a ff ff ff       	jmp    800a9d <vprintfmt+0x3d5>
			putch('%', putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	53                   	push   %ebx
  800b27:	6a 25                	push   $0x25
  800b29:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b2b:	83 c4 10             	add    $0x10,%esp
  800b2e:	89 f8                	mov    %edi,%eax
  800b30:	eb 03                	jmp    800b35 <vprintfmt+0x46d>
  800b32:	83 e8 01             	sub    $0x1,%eax
  800b35:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b39:	75 f7                	jne    800b32 <vprintfmt+0x46a>
  800b3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b3e:	e9 5a ff ff ff       	jmp    800a9d <vprintfmt+0x3d5>
}
  800b43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5f                   	pop    %edi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b5a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b5e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b68:	85 c0                	test   %eax,%eax
  800b6a:	74 26                	je     800b92 <vsnprintf+0x47>
  800b6c:	85 d2                	test   %edx,%edx
  800b6e:	7e 22                	jle    800b92 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b70:	ff 75 14             	pushl  0x14(%ebp)
  800b73:	ff 75 10             	pushl  0x10(%ebp)
  800b76:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b79:	50                   	push   %eax
  800b7a:	68 8e 06 80 00       	push   $0x80068e
  800b7f:	e8 44 fb ff ff       	call   8006c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b87:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    
		return -E_INVAL;
  800b92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b97:	eb f7                	jmp    800b90 <vsnprintf+0x45>

00800b99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ba2:	50                   	push   %eax
  800ba3:	ff 75 10             	pushl  0x10(%ebp)
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	e8 9a ff ff ff       	call   800b4b <vsnprintf>
	va_end(ap);

	return rc;
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbe:	eb 03                	jmp    800bc3 <strlen+0x10>
		n++;
  800bc0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800bc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bc7:	75 f7                	jne    800bc0 <strlen+0xd>
	return n;
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	eb 03                	jmp    800bde <strnlen+0x13>
		n++;
  800bdb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	39 d0                	cmp    %edx,%eax
  800be0:	74 06                	je     800be8 <strnlen+0x1d>
  800be2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800be6:	75 f3                	jne    800bdb <strnlen+0x10>
	return n;
}
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	53                   	push   %ebx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bf4:	89 c2                	mov    %eax,%edx
  800bf6:	83 c1 01             	add    $0x1,%ecx
  800bf9:	83 c2 01             	add    $0x1,%edx
  800bfc:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c00:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c03:	84 db                	test   %bl,%bl
  800c05:	75 ef                	jne    800bf6 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c07:	5b                   	pop    %ebx
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	53                   	push   %ebx
  800c0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c11:	53                   	push   %ebx
  800c12:	e8 9c ff ff ff       	call   800bb3 <strlen>
  800c17:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	01 d8                	add    %ebx,%eax
  800c1f:	50                   	push   %eax
  800c20:	e8 c5 ff ff ff       	call   800bea <strcpy>
	return dst;
}
  800c25:	89 d8                	mov    %ebx,%eax
  800c27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	8b 75 08             	mov    0x8(%ebp),%esi
  800c34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c37:	89 f3                	mov    %esi,%ebx
  800c39:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3c:	89 f2                	mov    %esi,%edx
  800c3e:	eb 0f                	jmp    800c4f <strncpy+0x23>
		*dst++ = *src;
  800c40:	83 c2 01             	add    $0x1,%edx
  800c43:	0f b6 01             	movzbl (%ecx),%eax
  800c46:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c49:	80 39 01             	cmpb   $0x1,(%ecx)
  800c4c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800c4f:	39 da                	cmp    %ebx,%edx
  800c51:	75 ed                	jne    800c40 <strncpy+0x14>
	}
	return ret;
}
  800c53:	89 f0                	mov    %esi,%eax
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	8b 75 08             	mov    0x8(%ebp),%esi
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c67:	89 f0                	mov    %esi,%eax
  800c69:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c6d:	85 c9                	test   %ecx,%ecx
  800c6f:	75 0b                	jne    800c7c <strlcpy+0x23>
  800c71:	eb 17                	jmp    800c8a <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c73:	83 c2 01             	add    $0x1,%edx
  800c76:	83 c0 01             	add    $0x1,%eax
  800c79:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800c7c:	39 d8                	cmp    %ebx,%eax
  800c7e:	74 07                	je     800c87 <strlcpy+0x2e>
  800c80:	0f b6 0a             	movzbl (%edx),%ecx
  800c83:	84 c9                	test   %cl,%cl
  800c85:	75 ec                	jne    800c73 <strlcpy+0x1a>
		*dst = '\0';
  800c87:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c8a:	29 f0                	sub    %esi,%eax
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c96:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c99:	eb 06                	jmp    800ca1 <strcmp+0x11>
		p++, q++;
  800c9b:	83 c1 01             	add    $0x1,%ecx
  800c9e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ca1:	0f b6 01             	movzbl (%ecx),%eax
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 04                	je     800cac <strcmp+0x1c>
  800ca8:	3a 02                	cmp    (%edx),%al
  800caa:	74 ef                	je     800c9b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	0f b6 12             	movzbl (%edx),%edx
  800cb2:	29 d0                	sub    %edx,%eax
}
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	53                   	push   %ebx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc0:	89 c3                	mov    %eax,%ebx
  800cc2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cc5:	eb 06                	jmp    800ccd <strncmp+0x17>
		n--, p++, q++;
  800cc7:	83 c0 01             	add    $0x1,%eax
  800cca:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ccd:	39 d8                	cmp    %ebx,%eax
  800ccf:	74 16                	je     800ce7 <strncmp+0x31>
  800cd1:	0f b6 08             	movzbl (%eax),%ecx
  800cd4:	84 c9                	test   %cl,%cl
  800cd6:	74 04                	je     800cdc <strncmp+0x26>
  800cd8:	3a 0a                	cmp    (%edx),%cl
  800cda:	74 eb                	je     800cc7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdc:	0f b6 00             	movzbl (%eax),%eax
  800cdf:	0f b6 12             	movzbl (%edx),%edx
  800ce2:	29 d0                	sub    %edx,%eax
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    
		return 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cec:	eb f6                	jmp    800ce4 <strncmp+0x2e>

00800cee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf8:	0f b6 10             	movzbl (%eax),%edx
  800cfb:	84 d2                	test   %dl,%dl
  800cfd:	74 09                	je     800d08 <strchr+0x1a>
		if (*s == c)
  800cff:	38 ca                	cmp    %cl,%dl
  800d01:	74 0a                	je     800d0d <strchr+0x1f>
	for (; *s; s++)
  800d03:	83 c0 01             	add    $0x1,%eax
  800d06:	eb f0                	jmp    800cf8 <strchr+0xa>
			return (char *) s;
	return 0;
  800d08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d19:	eb 03                	jmp    800d1e <strfind+0xf>
  800d1b:	83 c0 01             	add    $0x1,%eax
  800d1e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d21:	38 ca                	cmp    %cl,%dl
  800d23:	74 04                	je     800d29 <strfind+0x1a>
  800d25:	84 d2                	test   %dl,%dl
  800d27:	75 f2                	jne    800d1b <strfind+0xc>
			break;
	return (char *) s;
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	57                   	push   %edi
  800d2f:	56                   	push   %esi
  800d30:	53                   	push   %ebx
  800d31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d37:	85 c9                	test   %ecx,%ecx
  800d39:	74 13                	je     800d4e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d3b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d41:	75 05                	jne    800d48 <memset+0x1d>
  800d43:	f6 c1 03             	test   $0x3,%cl
  800d46:	74 0d                	je     800d55 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	fc                   	cld    
  800d4c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d4e:	89 f8                	mov    %edi,%eax
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		c &= 0xFF;
  800d55:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d59:	89 d3                	mov    %edx,%ebx
  800d5b:	c1 e3 08             	shl    $0x8,%ebx
  800d5e:	89 d0                	mov    %edx,%eax
  800d60:	c1 e0 18             	shl    $0x18,%eax
  800d63:	89 d6                	mov    %edx,%esi
  800d65:	c1 e6 10             	shl    $0x10,%esi
  800d68:	09 f0                	or     %esi,%eax
  800d6a:	09 c2                	or     %eax,%edx
  800d6c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800d6e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d71:	89 d0                	mov    %edx,%eax
  800d73:	fc                   	cld    
  800d74:	f3 ab                	rep stos %eax,%es:(%edi)
  800d76:	eb d6                	jmp    800d4e <memset+0x23>

00800d78 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d86:	39 c6                	cmp    %eax,%esi
  800d88:	73 35                	jae    800dbf <memmove+0x47>
  800d8a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	76 2e                	jbe    800dbf <memmove+0x47>
		s += n;
		d += n;
  800d91:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d94:	89 d6                	mov    %edx,%esi
  800d96:	09 fe                	or     %edi,%esi
  800d98:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d9e:	74 0c                	je     800dac <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800da0:	83 ef 01             	sub    $0x1,%edi
  800da3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800da6:	fd                   	std    
  800da7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800da9:	fc                   	cld    
  800daa:	eb 21                	jmp    800dcd <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dac:	f6 c1 03             	test   $0x3,%cl
  800daf:	75 ef                	jne    800da0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800db1:	83 ef 04             	sub    $0x4,%edi
  800db4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800db7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dba:	fd                   	std    
  800dbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dbd:	eb ea                	jmp    800da9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dbf:	89 f2                	mov    %esi,%edx
  800dc1:	09 c2                	or     %eax,%edx
  800dc3:	f6 c2 03             	test   $0x3,%dl
  800dc6:	74 09                	je     800dd1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dc8:	89 c7                	mov    %eax,%edi
  800dca:	fc                   	cld    
  800dcb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd1:	f6 c1 03             	test   $0x3,%cl
  800dd4:	75 f2                	jne    800dc8 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dd6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dd9:	89 c7                	mov    %eax,%edi
  800ddb:	fc                   	cld    
  800ddc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dde:	eb ed                	jmp    800dcd <memmove+0x55>

00800de0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800de3:	ff 75 10             	pushl  0x10(%ebp)
  800de6:	ff 75 0c             	pushl  0xc(%ebp)
  800de9:	ff 75 08             	pushl  0x8(%ebp)
  800dec:	e8 87 ff ff ff       	call   800d78 <memmove>
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfe:	89 c6                	mov    %eax,%esi
  800e00:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e03:	39 f0                	cmp    %esi,%eax
  800e05:	74 1c                	je     800e23 <memcmp+0x30>
		if (*s1 != *s2)
  800e07:	0f b6 08             	movzbl (%eax),%ecx
  800e0a:	0f b6 1a             	movzbl (%edx),%ebx
  800e0d:	38 d9                	cmp    %bl,%cl
  800e0f:	75 08                	jne    800e19 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e11:	83 c0 01             	add    $0x1,%eax
  800e14:	83 c2 01             	add    $0x1,%edx
  800e17:	eb ea                	jmp    800e03 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e19:	0f b6 c1             	movzbl %cl,%eax
  800e1c:	0f b6 db             	movzbl %bl,%ebx
  800e1f:	29 d8                	sub    %ebx,%eax
  800e21:	eb 05                	jmp    800e28 <memcmp+0x35>
	}

	return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e35:	89 c2                	mov    %eax,%edx
  800e37:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e3a:	39 d0                	cmp    %edx,%eax
  800e3c:	73 09                	jae    800e47 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e3e:	38 08                	cmp    %cl,(%eax)
  800e40:	74 05                	je     800e47 <memfind+0x1b>
	for (; s < ends; s++)
  800e42:	83 c0 01             	add    $0x1,%eax
  800e45:	eb f3                	jmp    800e3a <memfind+0xe>
			break;
	return (void *) s;
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	eb 03                	jmp    800e5a <strtol+0x11>
		s++;
  800e57:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e5a:	0f b6 01             	movzbl (%ecx),%eax
  800e5d:	3c 20                	cmp    $0x20,%al
  800e5f:	74 f6                	je     800e57 <strtol+0xe>
  800e61:	3c 09                	cmp    $0x9,%al
  800e63:	74 f2                	je     800e57 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e65:	3c 2b                	cmp    $0x2b,%al
  800e67:	74 2e                	je     800e97 <strtol+0x4e>
	int neg = 0;
  800e69:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e6e:	3c 2d                	cmp    $0x2d,%al
  800e70:	74 2f                	je     800ea1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e72:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e78:	75 05                	jne    800e7f <strtol+0x36>
  800e7a:	80 39 30             	cmpb   $0x30,(%ecx)
  800e7d:	74 2c                	je     800eab <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e7f:	85 db                	test   %ebx,%ebx
  800e81:	75 0a                	jne    800e8d <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e83:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800e88:	80 39 30             	cmpb   $0x30,(%ecx)
  800e8b:	74 28                	je     800eb5 <strtol+0x6c>
		base = 10;
  800e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e92:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e95:	eb 50                	jmp    800ee7 <strtol+0x9e>
		s++;
  800e97:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e9a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e9f:	eb d1                	jmp    800e72 <strtol+0x29>
		s++, neg = 1;
  800ea1:	83 c1 01             	add    $0x1,%ecx
  800ea4:	bf 01 00 00 00       	mov    $0x1,%edi
  800ea9:	eb c7                	jmp    800e72 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eab:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eaf:	74 0e                	je     800ebf <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800eb1:	85 db                	test   %ebx,%ebx
  800eb3:	75 d8                	jne    800e8d <strtol+0x44>
		s++, base = 8;
  800eb5:	83 c1 01             	add    $0x1,%ecx
  800eb8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ebd:	eb ce                	jmp    800e8d <strtol+0x44>
		s += 2, base = 16;
  800ebf:	83 c1 02             	add    $0x2,%ecx
  800ec2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ec7:	eb c4                	jmp    800e8d <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ec9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ecc:	89 f3                	mov    %esi,%ebx
  800ece:	80 fb 19             	cmp    $0x19,%bl
  800ed1:	77 29                	ja     800efc <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ed3:	0f be d2             	movsbl %dl,%edx
  800ed6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ed9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800edc:	7d 30                	jge    800f0e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ede:	83 c1 01             	add    $0x1,%ecx
  800ee1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ee7:	0f b6 11             	movzbl (%ecx),%edx
  800eea:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eed:	89 f3                	mov    %esi,%ebx
  800eef:	80 fb 09             	cmp    $0x9,%bl
  800ef2:	77 d5                	ja     800ec9 <strtol+0x80>
			dig = *s - '0';
  800ef4:	0f be d2             	movsbl %dl,%edx
  800ef7:	83 ea 30             	sub    $0x30,%edx
  800efa:	eb dd                	jmp    800ed9 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800efc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eff:	89 f3                	mov    %esi,%ebx
  800f01:	80 fb 19             	cmp    $0x19,%bl
  800f04:	77 08                	ja     800f0e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f06:	0f be d2             	movsbl %dl,%edx
  800f09:	83 ea 37             	sub    $0x37,%edx
  800f0c:	eb cb                	jmp    800ed9 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f12:	74 05                	je     800f19 <strtol+0xd0>
		*endptr = (char *) s;
  800f14:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f17:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f19:	89 c2                	mov    %eax,%edx
  800f1b:	f7 da                	neg    %edx
  800f1d:	85 ff                	test   %edi,%edi
  800f1f:	0f 45 c2             	cmovne %edx,%eax
}
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5f                   	pop    %edi
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	89 c3                	mov    %eax,%ebx
  800f3a:	89 c7                	mov    %eax,%edi
  800f3c:	89 c6                	mov    %eax,%esi
  800f3e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f50:	b8 01 00 00 00       	mov    $0x1,%eax
  800f55:	89 d1                	mov    %edx,%ecx
  800f57:	89 d3                	mov    %edx,%ebx
  800f59:	89 d7                	mov    %edx,%edi
  800f5b:	89 d6                	mov    %edx,%esi
  800f5d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5f                   	pop    %edi
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	57                   	push   %edi
  800f68:	56                   	push   %esi
  800f69:	53                   	push   %ebx
  800f6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	b8 03 00 00 00       	mov    $0x3,%eax
  800f7a:	89 cb                	mov    %ecx,%ebx
  800f7c:	89 cf                	mov    %ecx,%edi
  800f7e:	89 ce                	mov    %ecx,%esi
  800f80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7f 08                	jg     800f8e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8e:	83 ec 0c             	sub    $0xc,%esp
  800f91:	50                   	push   %eax
  800f92:	6a 03                	push   $0x3
  800f94:	68 ff 32 80 00       	push   $0x8032ff
  800f99:	6a 23                	push   $0x23
  800f9b:	68 1c 33 80 00       	push   $0x80331c
  800fa0:	e8 4b f5 ff ff       	call   8004f0 <_panic>

00800fa5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fab:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800fb5:	89 d1                	mov    %edx,%ecx
  800fb7:	89 d3                	mov    %edx,%ebx
  800fb9:	89 d7                	mov    %edx,%edi
  800fbb:	89 d6                	mov    %edx,%esi
  800fbd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <sys_yield>:

void
sys_yield(void)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	57                   	push   %edi
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fca:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fd4:	89 d1                	mov    %edx,%ecx
  800fd6:	89 d3                	mov    %edx,%ebx
  800fd8:	89 d7                	mov    %edx,%edi
  800fda:	89 d6                	mov    %edx,%esi
  800fdc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	57                   	push   %edi
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fec:	be 00 00 00 00       	mov    $0x0,%esi
  800ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff7:	b8 04 00 00 00       	mov    $0x4,%eax
  800ffc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fff:	89 f7                	mov    %esi,%edi
  801001:	cd 30                	int    $0x30
	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7f 08                	jg     80100f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	50                   	push   %eax
  801013:	6a 04                	push   $0x4
  801015:	68 ff 32 80 00       	push   $0x8032ff
  80101a:	6a 23                	push   $0x23
  80101c:	68 1c 33 80 00       	push   $0x80331c
  801021:	e8 ca f4 ff ff       	call   8004f0 <_panic>

00801026 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
  80102c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102f:	8b 55 08             	mov    0x8(%ebp),%edx
  801032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801035:	b8 05 00 00 00       	mov    $0x5,%eax
  80103a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801040:	8b 75 18             	mov    0x18(%ebp),%esi
  801043:	cd 30                	int    $0x30
	if(check && ret > 0)
  801045:	85 c0                	test   %eax,%eax
  801047:	7f 08                	jg     801051 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801049:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	50                   	push   %eax
  801055:	6a 05                	push   $0x5
  801057:	68 ff 32 80 00       	push   $0x8032ff
  80105c:	6a 23                	push   $0x23
  80105e:	68 1c 33 80 00       	push   $0x80331c
  801063:	e8 88 f4 ff ff       	call   8004f0 <_panic>

00801068 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	57                   	push   %edi
  80106c:	56                   	push   %esi
  80106d:	53                   	push   %ebx
  80106e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801071:	bb 00 00 00 00       	mov    $0x0,%ebx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107c:	b8 06 00 00 00       	mov    $0x6,%eax
  801081:	89 df                	mov    %ebx,%edi
  801083:	89 de                	mov    %ebx,%esi
  801085:	cd 30                	int    $0x30
	if(check && ret > 0)
  801087:	85 c0                	test   %eax,%eax
  801089:	7f 08                	jg     801093 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80108b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108e:	5b                   	pop    %ebx
  80108f:	5e                   	pop    %esi
  801090:	5f                   	pop    %edi
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801093:	83 ec 0c             	sub    $0xc,%esp
  801096:	50                   	push   %eax
  801097:	6a 06                	push   $0x6
  801099:	68 ff 32 80 00       	push   $0x8032ff
  80109e:	6a 23                	push   $0x23
  8010a0:	68 1c 33 80 00       	push   $0x80331c
  8010a5:	e8 46 f4 ff ff       	call   8004f0 <_panic>

008010aa <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	57                   	push   %edi
  8010ae:	56                   	push   %esi
  8010af:	53                   	push   %ebx
  8010b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010be:	b8 08 00 00 00       	mov    $0x8,%eax
  8010c3:	89 df                	mov    %ebx,%edi
  8010c5:	89 de                	mov    %ebx,%esi
  8010c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	7f 08                	jg     8010d5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d0:	5b                   	pop    %ebx
  8010d1:	5e                   	pop    %esi
  8010d2:	5f                   	pop    %edi
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d5:	83 ec 0c             	sub    $0xc,%esp
  8010d8:	50                   	push   %eax
  8010d9:	6a 08                	push   $0x8
  8010db:	68 ff 32 80 00       	push   $0x8032ff
  8010e0:	6a 23                	push   $0x23
  8010e2:	68 1c 33 80 00       	push   $0x80331c
  8010e7:	e8 04 f4 ff ff       	call   8004f0 <_panic>

008010ec <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	b8 09 00 00 00       	mov    $0x9,%eax
  801105:	89 df                	mov    %ebx,%edi
  801107:	89 de                	mov    %ebx,%esi
  801109:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110b:	85 c0                	test   %eax,%eax
  80110d:	7f 08                	jg     801117 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80110f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	50                   	push   %eax
  80111b:	6a 09                	push   $0x9
  80111d:	68 ff 32 80 00       	push   $0x8032ff
  801122:	6a 23                	push   $0x23
  801124:	68 1c 33 80 00       	push   $0x80331c
  801129:	e8 c2 f3 ff ff       	call   8004f0 <_panic>

0080112e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	57                   	push   %edi
  801132:	56                   	push   %esi
  801133:	53                   	push   %ebx
  801134:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801137:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
  80113f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801142:	b8 0a 00 00 00       	mov    $0xa,%eax
  801147:	89 df                	mov    %ebx,%edi
  801149:	89 de                	mov    %ebx,%esi
  80114b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	7f 08                	jg     801159 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801151:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5f                   	pop    %edi
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	50                   	push   %eax
  80115d:	6a 0a                	push   $0xa
  80115f:	68 ff 32 80 00       	push   $0x8032ff
  801164:	6a 23                	push   $0x23
  801166:	68 1c 33 80 00       	push   $0x80331c
  80116b:	e8 80 f3 ff ff       	call   8004f0 <_panic>

00801170 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
	asm volatile("int %1\n"
  801176:	8b 55 08             	mov    0x8(%ebp),%edx
  801179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801181:	be 00 00 00 00       	mov    $0x0,%esi
  801186:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801189:	8b 7d 14             	mov    0x14(%ebp),%edi
  80118c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80118e:	5b                   	pop    %ebx
  80118f:	5e                   	pop    %esi
  801190:	5f                   	pop    %edi
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    

00801193 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	57                   	push   %edi
  801197:	56                   	push   %esi
  801198:	53                   	push   %ebx
  801199:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80119c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011a9:	89 cb                	mov    %ecx,%ebx
  8011ab:	89 cf                	mov    %ecx,%edi
  8011ad:	89 ce                	mov    %ecx,%esi
  8011af:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	7f 08                	jg     8011bd <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5f                   	pop    %edi
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	50                   	push   %eax
  8011c1:	6a 0d                	push   $0xd
  8011c3:	68 ff 32 80 00       	push   $0x8032ff
  8011c8:	6a 23                	push   $0x23
  8011ca:	68 1c 33 80 00       	push   $0x80331c
  8011cf:	e8 1c f3 ff ff       	call   8004f0 <_panic>

008011d4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	57                   	push   %edi
  8011d8:	56                   	push   %esi
  8011d9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011da:	ba 00 00 00 00       	mov    $0x0,%edx
  8011df:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011e4:	89 d1                	mov    %edx,%ecx
  8011e6:	89 d3                	mov    %edx,%ebx
  8011e8:	89 d7                	mov    %edx,%edi
  8011ea:	89 d6                	mov    %edx,%esi
  8011ec:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	56                   	push   %esi
  8011f7:	53                   	push   %ebx
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  8011fb:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  8011fd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801201:	74 7f                	je     801282 <pgfault+0x8f>
  801203:	89 d8                	mov    %ebx,%eax
  801205:	c1 e8 0c             	shr    $0xc,%eax
  801208:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80120f:	f6 c4 08             	test   $0x8,%ah
  801212:	74 6e                	je     801282 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  801214:	e8 8c fd ff ff       	call   800fa5 <sys_getenvid>
  801219:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	6a 07                	push   $0x7
  801220:	68 00 f0 7f 00       	push   $0x7ff000
  801225:	50                   	push   %eax
  801226:	e8 b8 fd ff ff       	call   800fe3 <sys_page_alloc>
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 64                	js     801296 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  801232:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	68 00 10 00 00       	push   $0x1000
  801240:	53                   	push   %ebx
  801241:	68 00 f0 7f 00       	push   $0x7ff000
  801246:	e8 2d fb ff ff       	call   800d78 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  80124b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801252:	53                   	push   %ebx
  801253:	56                   	push   %esi
  801254:	68 00 f0 7f 00       	push   $0x7ff000
  801259:	56                   	push   %esi
  80125a:	e8 c7 fd ff ff       	call   801026 <sys_page_map>
  80125f:	83 c4 20             	add    $0x20,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	78 42                	js     8012a8 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801266:	83 ec 08             	sub    $0x8,%esp
  801269:	68 00 f0 7f 00       	push   $0x7ff000
  80126e:	56                   	push   %esi
  80126f:	e8 f4 fd ff ff       	call   801068 <sys_page_unmap>
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	78 3f                	js     8012ba <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  80127b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127e:	5b                   	pop    %ebx
  80127f:	5e                   	pop    %esi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	68 2c 33 80 00       	push   $0x80332c
  80128a:	6a 1d                	push   $0x1d
  80128c:	68 bb 33 80 00       	push   $0x8033bb
  801291:	e8 5a f2 ff ff       	call   8004f0 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  801296:	50                   	push   %eax
  801297:	68 54 33 80 00       	push   $0x803354
  80129c:	6a 28                	push   $0x28
  80129e:	68 bb 33 80 00       	push   $0x8033bb
  8012a3:	e8 48 f2 ff ff       	call   8004f0 <_panic>
		panic("pgfault:page map failed: %e", r);
  8012a8:	50                   	push   %eax
  8012a9:	68 c6 33 80 00       	push   $0x8033c6
  8012ae:	6a 2c                	push   $0x2c
  8012b0:	68 bb 33 80 00       	push   $0x8033bb
  8012b5:	e8 36 f2 ff ff       	call   8004f0 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  8012ba:	50                   	push   %eax
  8012bb:	68 78 33 80 00       	push   $0x803378
  8012c0:	6a 2e                	push   $0x2e
  8012c2:	68 bb 33 80 00       	push   $0x8033bb
  8012c7:	e8 24 f2 ff ff       	call   8004f0 <_panic>

008012cc <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  8012d5:	68 f3 11 80 00       	push   $0x8011f3
  8012da:	e8 9b 17 00 00       	call   802a7a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012df:	b8 07 00 00 00       	mov    $0x7,%eax
  8012e4:	cd 30                	int    $0x30
  8012e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 2f                	js     80131f <fork+0x53>
  8012f0:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8012f2:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  8012f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012fb:	75 6e                	jne    80136b <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012fd:	e8 a3 fc ff ff       	call   800fa5 <sys_getenvid>
  801302:	25 ff 03 00 00       	and    $0x3ff,%eax
  801307:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80130a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80130f:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  801317:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131a:	5b                   	pop    %ebx
  80131b:	5e                   	pop    %esi
  80131c:	5f                   	pop    %edi
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  80131f:	50                   	push   %eax
  801320:	68 98 33 80 00       	push   $0x803398
  801325:	6a 6e                	push   $0x6e
  801327:	68 bb 33 80 00       	push   $0x8033bb
  80132c:	e8 bf f1 ff ff       	call   8004f0 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801331:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801338:	83 ec 0c             	sub    $0xc,%esp
  80133b:	25 07 0e 00 00       	and    $0xe07,%eax
  801340:	50                   	push   %eax
  801341:	56                   	push   %esi
  801342:	57                   	push   %edi
  801343:	56                   	push   %esi
  801344:	6a 00                	push   $0x0
  801346:	e8 db fc ff ff       	call   801026 <sys_page_map>
  80134b:	83 c4 20             	add    $0x20,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	ba 00 00 00 00       	mov    $0x0,%edx
  801355:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  801358:	85 c0                	test   %eax,%eax
  80135a:	78 bb                	js     801317 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  80135c:	83 c3 01             	add    $0x1,%ebx
  80135f:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801365:	0f 84 a6 00 00 00    	je     801411 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  80136b:	89 d8                	mov    %ebx,%eax
  80136d:	c1 e8 0a             	shr    $0xa,%eax
  801370:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801377:	a8 01                	test   $0x1,%al
  801379:	74 e1                	je     80135c <fork+0x90>
  80137b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801382:	a8 01                	test   $0x1,%al
  801384:	74 d6                	je     80135c <fork+0x90>
  801386:	89 de                	mov    %ebx,%esi
  801388:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  80138b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801392:	f6 c4 04             	test   $0x4,%ah
  801395:	75 9a                	jne    801331 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801397:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80139e:	a8 02                	test   $0x2,%al
  8013a0:	75 0c                	jne    8013ae <fork+0xe2>
  8013a2:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013a9:	f6 c4 08             	test   $0x8,%ah
  8013ac:	74 42                	je     8013f0 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8013ae:	83 ec 0c             	sub    $0xc,%esp
  8013b1:	68 05 08 00 00       	push   $0x805
  8013b6:	56                   	push   %esi
  8013b7:	57                   	push   %edi
  8013b8:	56                   	push   %esi
  8013b9:	6a 00                	push   $0x0
  8013bb:	e8 66 fc ff ff       	call   801026 <sys_page_map>
  8013c0:	83 c4 20             	add    $0x20,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	0f 88 4c ff ff ff    	js     801317 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8013cb:	83 ec 0c             	sub    $0xc,%esp
  8013ce:	68 05 08 00 00       	push   $0x805
  8013d3:	56                   	push   %esi
  8013d4:	6a 00                	push   $0x0
  8013d6:	56                   	push   %esi
  8013d7:	6a 00                	push   $0x0
  8013d9:	e8 48 fc ff ff       	call   801026 <sys_page_map>
  8013de:	83 c4 20             	add    $0x20,%esp
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013e8:	0f 4f c1             	cmovg  %ecx,%eax
  8013eb:	e9 68 ff ff ff       	jmp    801358 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  8013f0:	83 ec 0c             	sub    $0xc,%esp
  8013f3:	6a 05                	push   $0x5
  8013f5:	56                   	push   %esi
  8013f6:	57                   	push   %edi
  8013f7:	56                   	push   %esi
  8013f8:	6a 00                	push   $0x0
  8013fa:	e8 27 fc ff ff       	call   801026 <sys_page_map>
  8013ff:	83 c4 20             	add    $0x20,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	b9 00 00 00 00       	mov    $0x0,%ecx
  801409:	0f 4f c1             	cmovg  %ecx,%eax
  80140c:	e9 47 ff ff ff       	jmp    801358 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	6a 07                	push   $0x7
  801416:	68 00 f0 bf ee       	push   $0xeebff000
  80141b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80141e:	57                   	push   %edi
  80141f:	e8 bf fb ff ff       	call   800fe3 <sys_page_alloc>
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	0f 88 e8 fe ff ff    	js     801317 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  80142f:	83 ec 08             	sub    $0x8,%esp
  801432:	68 df 2a 80 00       	push   $0x802adf
  801437:	57                   	push   %edi
  801438:	e8 f1 fc ff ff       	call   80112e <sys_env_set_pgfault_upcall>
  80143d:	83 c4 10             	add    $0x10,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	0f 88 cf fe ff ff    	js     801317 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	6a 02                	push   $0x2
  80144d:	57                   	push   %edi
  80144e:	e8 57 fc ff ff       	call   8010aa <sys_env_set_status>
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 08                	js     801462 <fork+0x196>
	return eid;
  80145a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80145d:	e9 b5 fe ff ff       	jmp    801317 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  801462:	50                   	push   %eax
  801463:	68 e2 33 80 00       	push   $0x8033e2
  801468:	68 87 00 00 00       	push   $0x87
  80146d:	68 bb 33 80 00       	push   $0x8033bb
  801472:	e8 79 f0 ff ff       	call   8004f0 <_panic>

00801477 <sfork>:

// Challenge!
int sfork(void)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80147d:	68 00 34 80 00       	push   $0x803400
  801482:	68 8f 00 00 00       	push   $0x8f
  801487:	68 bb 33 80 00       	push   $0x8033bb
  80148c:	e8 5f f0 ff ff       	call   8004f0 <_panic>

00801491 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	05 00 00 00 30       	add    $0x30000000,%eax
  80149c:	c1 e8 0c             	shr    $0xc,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014b6:	5d                   	pop    %ebp
  8014b7:	c3                   	ret    

008014b8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014be:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014c3:	89 c2                	mov    %eax,%edx
  8014c5:	c1 ea 16             	shr    $0x16,%edx
  8014c8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014cf:	f6 c2 01             	test   $0x1,%dl
  8014d2:	74 2a                	je     8014fe <fd_alloc+0x46>
  8014d4:	89 c2                	mov    %eax,%edx
  8014d6:	c1 ea 0c             	shr    $0xc,%edx
  8014d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014e0:	f6 c2 01             	test   $0x1,%dl
  8014e3:	74 19                	je     8014fe <fd_alloc+0x46>
  8014e5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014ea:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014ef:	75 d2                	jne    8014c3 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014f1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8014f7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014fc:	eb 07                	jmp    801505 <fd_alloc+0x4d>
			*fd_store = fd;
  8014fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80150d:	83 f8 1f             	cmp    $0x1f,%eax
  801510:	77 36                	ja     801548 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801512:	c1 e0 0c             	shl    $0xc,%eax
  801515:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80151a:	89 c2                	mov    %eax,%edx
  80151c:	c1 ea 16             	shr    $0x16,%edx
  80151f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801526:	f6 c2 01             	test   $0x1,%dl
  801529:	74 24                	je     80154f <fd_lookup+0x48>
  80152b:	89 c2                	mov    %eax,%edx
  80152d:	c1 ea 0c             	shr    $0xc,%edx
  801530:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801537:	f6 c2 01             	test   $0x1,%dl
  80153a:	74 1a                	je     801556 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80153c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153f:	89 02                	mov    %eax,(%edx)
	return 0;
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    
		return -E_INVAL;
  801548:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154d:	eb f7                	jmp    801546 <fd_lookup+0x3f>
		return -E_INVAL;
  80154f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801554:	eb f0                	jmp    801546 <fd_lookup+0x3f>
  801556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155b:	eb e9                	jmp    801546 <fd_lookup+0x3f>

0080155d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801566:	ba 94 34 80 00       	mov    $0x803494,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80156b:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801570:	39 08                	cmp    %ecx,(%eax)
  801572:	74 33                	je     8015a7 <dev_lookup+0x4a>
  801574:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801577:	8b 02                	mov    (%edx),%eax
  801579:	85 c0                	test   %eax,%eax
  80157b:	75 f3                	jne    801570 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80157d:	a1 08 50 80 00       	mov    0x805008,%eax
  801582:	8b 40 48             	mov    0x48(%eax),%eax
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	51                   	push   %ecx
  801589:	50                   	push   %eax
  80158a:	68 18 34 80 00       	push   $0x803418
  80158f:	e8 37 f0 ff ff       	call   8005cb <cprintf>
	*dev = 0;
  801594:	8b 45 0c             	mov    0xc(%ebp),%eax
  801597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    
			*dev = devtab[i];
  8015a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b1:	eb f2                	jmp    8015a5 <dev_lookup+0x48>

008015b3 <fd_close>:
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	57                   	push   %edi
  8015b7:	56                   	push   %esi
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 1c             	sub    $0x1c,%esp
  8015bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8015bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015c5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015c6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015cc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015cf:	50                   	push   %eax
  8015d0:	e8 32 ff ff ff       	call   801507 <fd_lookup>
  8015d5:	89 c3                	mov    %eax,%ebx
  8015d7:	83 c4 08             	add    $0x8,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	78 05                	js     8015e3 <fd_close+0x30>
	    || fd != fd2)
  8015de:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015e1:	74 16                	je     8015f9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015e3:	89 f8                	mov    %edi,%eax
  8015e5:	84 c0                	test   %al,%al
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ec:	0f 44 d8             	cmove  %eax,%ebx
}
  8015ef:	89 d8                	mov    %ebx,%eax
  8015f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f4:	5b                   	pop    %ebx
  8015f5:	5e                   	pop    %esi
  8015f6:	5f                   	pop    %edi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	ff 36                	pushl  (%esi)
  801602:	e8 56 ff ff ff       	call   80155d <dev_lookup>
  801607:	89 c3                	mov    %eax,%ebx
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 15                	js     801625 <fd_close+0x72>
		if (dev->dev_close)
  801610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801613:	8b 40 10             	mov    0x10(%eax),%eax
  801616:	85 c0                	test   %eax,%eax
  801618:	74 1b                	je     801635 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	56                   	push   %esi
  80161e:	ff d0                	call   *%eax
  801620:	89 c3                	mov    %eax,%ebx
  801622:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	56                   	push   %esi
  801629:	6a 00                	push   $0x0
  80162b:	e8 38 fa ff ff       	call   801068 <sys_page_unmap>
	return r;
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	eb ba                	jmp    8015ef <fd_close+0x3c>
			r = 0;
  801635:	bb 00 00 00 00       	mov    $0x0,%ebx
  80163a:	eb e9                	jmp    801625 <fd_close+0x72>

0080163c <close>:

int
close(int fdnum)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801642:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801645:	50                   	push   %eax
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 b9 fe ff ff       	call   801507 <fd_lookup>
  80164e:	83 c4 08             	add    $0x8,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 10                	js     801665 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	6a 01                	push   $0x1
  80165a:	ff 75 f4             	pushl  -0xc(%ebp)
  80165d:	e8 51 ff ff ff       	call   8015b3 <fd_close>
  801662:	83 c4 10             	add    $0x10,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <close_all>:

void
close_all(void)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	53                   	push   %ebx
  80166b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80166e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801673:	83 ec 0c             	sub    $0xc,%esp
  801676:	53                   	push   %ebx
  801677:	e8 c0 ff ff ff       	call   80163c <close>
	for (i = 0; i < MAXFD; i++)
  80167c:	83 c3 01             	add    $0x1,%ebx
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	83 fb 20             	cmp    $0x20,%ebx
  801685:	75 ec                	jne    801673 <close_all+0xc>
}
  801687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	57                   	push   %edi
  801690:	56                   	push   %esi
  801691:	53                   	push   %ebx
  801692:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801695:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801698:	50                   	push   %eax
  801699:	ff 75 08             	pushl  0x8(%ebp)
  80169c:	e8 66 fe ff ff       	call   801507 <fd_lookup>
  8016a1:	89 c3                	mov    %eax,%ebx
  8016a3:	83 c4 08             	add    $0x8,%esp
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	0f 88 81 00 00 00    	js     80172f <dup+0xa3>
		return r;
	close(newfdnum);
  8016ae:	83 ec 0c             	sub    $0xc,%esp
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	e8 83 ff ff ff       	call   80163c <close>

	newfd = INDEX2FD(newfdnum);
  8016b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016bc:	c1 e6 0c             	shl    $0xc,%esi
  8016bf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016c5:	83 c4 04             	add    $0x4,%esp
  8016c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016cb:	e8 d1 fd ff ff       	call   8014a1 <fd2data>
  8016d0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016d2:	89 34 24             	mov    %esi,(%esp)
  8016d5:	e8 c7 fd ff ff       	call   8014a1 <fd2data>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016df:	89 d8                	mov    %ebx,%eax
  8016e1:	c1 e8 16             	shr    $0x16,%eax
  8016e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016eb:	a8 01                	test   $0x1,%al
  8016ed:	74 11                	je     801700 <dup+0x74>
  8016ef:	89 d8                	mov    %ebx,%eax
  8016f1:	c1 e8 0c             	shr    $0xc,%eax
  8016f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016fb:	f6 c2 01             	test   $0x1,%dl
  8016fe:	75 39                	jne    801739 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801700:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801703:	89 d0                	mov    %edx,%eax
  801705:	c1 e8 0c             	shr    $0xc,%eax
  801708:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80170f:	83 ec 0c             	sub    $0xc,%esp
  801712:	25 07 0e 00 00       	and    $0xe07,%eax
  801717:	50                   	push   %eax
  801718:	56                   	push   %esi
  801719:	6a 00                	push   $0x0
  80171b:	52                   	push   %edx
  80171c:	6a 00                	push   $0x0
  80171e:	e8 03 f9 ff ff       	call   801026 <sys_page_map>
  801723:	89 c3                	mov    %eax,%ebx
  801725:	83 c4 20             	add    $0x20,%esp
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 31                	js     80175d <dup+0xd1>
		goto err;

	return newfdnum;
  80172c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80172f:	89 d8                	mov    %ebx,%eax
  801731:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801734:	5b                   	pop    %ebx
  801735:	5e                   	pop    %esi
  801736:	5f                   	pop    %edi
  801737:	5d                   	pop    %ebp
  801738:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801739:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801740:	83 ec 0c             	sub    $0xc,%esp
  801743:	25 07 0e 00 00       	and    $0xe07,%eax
  801748:	50                   	push   %eax
  801749:	57                   	push   %edi
  80174a:	6a 00                	push   $0x0
  80174c:	53                   	push   %ebx
  80174d:	6a 00                	push   $0x0
  80174f:	e8 d2 f8 ff ff       	call   801026 <sys_page_map>
  801754:	89 c3                	mov    %eax,%ebx
  801756:	83 c4 20             	add    $0x20,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	79 a3                	jns    801700 <dup+0x74>
	sys_page_unmap(0, newfd);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	56                   	push   %esi
  801761:	6a 00                	push   $0x0
  801763:	e8 00 f9 ff ff       	call   801068 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801768:	83 c4 08             	add    $0x8,%esp
  80176b:	57                   	push   %edi
  80176c:	6a 00                	push   $0x0
  80176e:	e8 f5 f8 ff ff       	call   801068 <sys_page_unmap>
	return r;
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	eb b7                	jmp    80172f <dup+0xa3>

00801778 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	53                   	push   %ebx
  80177c:	83 ec 14             	sub    $0x14,%esp
  80177f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801782:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801785:	50                   	push   %eax
  801786:	53                   	push   %ebx
  801787:	e8 7b fd ff ff       	call   801507 <fd_lookup>
  80178c:	83 c4 08             	add    $0x8,%esp
  80178f:	85 c0                	test   %eax,%eax
  801791:	78 3f                	js     8017d2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801793:	83 ec 08             	sub    $0x8,%esp
  801796:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801799:	50                   	push   %eax
  80179a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179d:	ff 30                	pushl  (%eax)
  80179f:	e8 b9 fd ff ff       	call   80155d <dev_lookup>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 27                	js     8017d2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ae:	8b 42 08             	mov    0x8(%edx),%eax
  8017b1:	83 e0 03             	and    $0x3,%eax
  8017b4:	83 f8 01             	cmp    $0x1,%eax
  8017b7:	74 1e                	je     8017d7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bc:	8b 40 08             	mov    0x8(%eax),%eax
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	74 35                	je     8017f8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	ff 75 10             	pushl  0x10(%ebp)
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	52                   	push   %edx
  8017cd:	ff d0                	call   *%eax
  8017cf:	83 c4 10             	add    $0x10,%esp
}
  8017d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017d7:	a1 08 50 80 00       	mov    0x805008,%eax
  8017dc:	8b 40 48             	mov    0x48(%eax),%eax
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	53                   	push   %ebx
  8017e3:	50                   	push   %eax
  8017e4:	68 59 34 80 00       	push   $0x803459
  8017e9:	e8 dd ed ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f6:	eb da                	jmp    8017d2 <read+0x5a>
		return -E_NOT_SUPP;
  8017f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017fd:	eb d3                	jmp    8017d2 <read+0x5a>

008017ff <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	57                   	push   %edi
  801803:	56                   	push   %esi
  801804:	53                   	push   %ebx
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	8b 7d 08             	mov    0x8(%ebp),%edi
  80180b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80180e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801813:	39 f3                	cmp    %esi,%ebx
  801815:	73 25                	jae    80183c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	89 f0                	mov    %esi,%eax
  80181c:	29 d8                	sub    %ebx,%eax
  80181e:	50                   	push   %eax
  80181f:	89 d8                	mov    %ebx,%eax
  801821:	03 45 0c             	add    0xc(%ebp),%eax
  801824:	50                   	push   %eax
  801825:	57                   	push   %edi
  801826:	e8 4d ff ff ff       	call   801778 <read>
		if (m < 0)
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 08                	js     80183a <readn+0x3b>
			return m;
		if (m == 0)
  801832:	85 c0                	test   %eax,%eax
  801834:	74 06                	je     80183c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801836:	01 c3                	add    %eax,%ebx
  801838:	eb d9                	jmp    801813 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80183a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80183c:	89 d8                	mov    %ebx,%eax
  80183e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801841:	5b                   	pop    %ebx
  801842:	5e                   	pop    %esi
  801843:	5f                   	pop    %edi
  801844:	5d                   	pop    %ebp
  801845:	c3                   	ret    

00801846 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	53                   	push   %ebx
  80184a:	83 ec 14             	sub    $0x14,%esp
  80184d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801850:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801853:	50                   	push   %eax
  801854:	53                   	push   %ebx
  801855:	e8 ad fc ff ff       	call   801507 <fd_lookup>
  80185a:	83 c4 08             	add    $0x8,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 3a                	js     80189b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801861:	83 ec 08             	sub    $0x8,%esp
  801864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801867:	50                   	push   %eax
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186b:	ff 30                	pushl  (%eax)
  80186d:	e8 eb fc ff ff       	call   80155d <dev_lookup>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	85 c0                	test   %eax,%eax
  801877:	78 22                	js     80189b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801880:	74 1e                	je     8018a0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801885:	8b 52 0c             	mov    0xc(%edx),%edx
  801888:	85 d2                	test   %edx,%edx
  80188a:	74 35                	je     8018c1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	ff 75 10             	pushl  0x10(%ebp)
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	50                   	push   %eax
  801896:	ff d2                	call   *%edx
  801898:	83 c4 10             	add    $0x10,%esp
}
  80189b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018a0:	a1 08 50 80 00       	mov    0x805008,%eax
  8018a5:	8b 40 48             	mov    0x48(%eax),%eax
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	53                   	push   %ebx
  8018ac:	50                   	push   %eax
  8018ad:	68 75 34 80 00       	push   $0x803475
  8018b2:	e8 14 ed ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bf:	eb da                	jmp    80189b <write+0x55>
		return -E_NOT_SUPP;
  8018c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c6:	eb d3                	jmp    80189b <write+0x55>

008018c8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ce:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	e8 2d fc ff ff       	call   801507 <fd_lookup>
  8018da:	83 c4 08             	add    $0x8,%esp
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 0e                	js     8018ef <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	53                   	push   %ebx
  8018f5:	83 ec 14             	sub    $0x14,%esp
  8018f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fe:	50                   	push   %eax
  8018ff:	53                   	push   %ebx
  801900:	e8 02 fc ff ff       	call   801507 <fd_lookup>
  801905:	83 c4 08             	add    $0x8,%esp
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 37                	js     801943 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80190c:	83 ec 08             	sub    $0x8,%esp
  80190f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801912:	50                   	push   %eax
  801913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801916:	ff 30                	pushl  (%eax)
  801918:	e8 40 fc ff ff       	call   80155d <dev_lookup>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	78 1f                	js     801943 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801927:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80192b:	74 1b                	je     801948 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 52 18             	mov    0x18(%edx),%edx
  801933:	85 d2                	test   %edx,%edx
  801935:	74 32                	je     801969 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	50                   	push   %eax
  80193e:	ff d2                	call   *%edx
  801940:	83 c4 10             	add    $0x10,%esp
}
  801943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801946:	c9                   	leave  
  801947:	c3                   	ret    
			thisenv->env_id, fdnum);
  801948:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80194d:	8b 40 48             	mov    0x48(%eax),%eax
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	53                   	push   %ebx
  801954:	50                   	push   %eax
  801955:	68 38 34 80 00       	push   $0x803438
  80195a:	e8 6c ec ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801967:	eb da                	jmp    801943 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801969:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80196e:	eb d3                	jmp    801943 <ftruncate+0x52>

00801970 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
  801974:	83 ec 14             	sub    $0x14,%esp
  801977:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197d:	50                   	push   %eax
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	e8 81 fb ff ff       	call   801507 <fd_lookup>
  801986:	83 c4 08             	add    $0x8,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 4b                	js     8019d8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198d:	83 ec 08             	sub    $0x8,%esp
  801990:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801993:	50                   	push   %eax
  801994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801997:	ff 30                	pushl  (%eax)
  801999:	e8 bf fb ff ff       	call   80155d <dev_lookup>
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 33                	js     8019d8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019ac:	74 2f                	je     8019dd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019ae:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019b1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019b8:	00 00 00 
	stat->st_isdir = 0;
  8019bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019c2:	00 00 00 
	stat->st_dev = dev;
  8019c5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	53                   	push   %ebx
  8019cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d2:	ff 50 14             	call   *0x14(%eax)
  8019d5:	83 c4 10             	add    $0x10,%esp
}
  8019d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    
		return -E_NOT_SUPP;
  8019dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019e2:	eb f4                	jmp    8019d8 <fstat+0x68>

008019e4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	56                   	push   %esi
  8019e8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019e9:	83 ec 08             	sub    $0x8,%esp
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	e8 e7 01 00 00       	call   801bdd <open>
  8019f6:	89 c3                	mov    %eax,%ebx
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 1b                	js     801a1a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	e8 65 ff ff ff       	call   801970 <fstat>
  801a0b:	89 c6                	mov    %eax,%esi
	close(fd);
  801a0d:	89 1c 24             	mov    %ebx,(%esp)
  801a10:	e8 27 fc ff ff       	call   80163c <close>
	return r;
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	89 f3                	mov    %esi,%ebx
}
  801a1a:	89 d8                	mov    %ebx,%eax
  801a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	89 c6                	mov    %eax,%esi
  801a2a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a2c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a33:	74 27                	je     801a5c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a35:	6a 07                	push   $0x7
  801a37:	68 00 60 80 00       	push   $0x806000
  801a3c:	56                   	push   %esi
  801a3d:	ff 35 00 50 80 00    	pushl  0x805000
  801a43:	e8 24 11 00 00       	call   802b6c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a48:	83 c4 0c             	add    $0xc,%esp
  801a4b:	6a 00                	push   $0x0
  801a4d:	53                   	push   %ebx
  801a4e:	6a 00                	push   $0x0
  801a50:	e8 b0 10 00 00       	call   802b05 <ipc_recv>
}
  801a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a58:	5b                   	pop    %ebx
  801a59:	5e                   	pop    %esi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	6a 01                	push   $0x1
  801a61:	e8 5a 11 00 00       	call   802bc0 <ipc_find_env>
  801a66:	a3 00 50 80 00       	mov    %eax,0x805000
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	eb c5                	jmp    801a35 <fsipc+0x12>

00801a70 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a84:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a89:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8e:	b8 02 00 00 00       	mov    $0x2,%eax
  801a93:	e8 8b ff ff ff       	call   801a23 <fsipc>
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <devfile_flush>:
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	b8 06 00 00 00       	mov    $0x6,%eax
  801ab5:	e8 69 ff ff ff       	call   801a23 <fsipc>
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <devfile_stat>:
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  801acc:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad6:	b8 05 00 00 00       	mov    $0x5,%eax
  801adb:	e8 43 ff ff ff       	call   801a23 <fsipc>
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 2c                	js     801b10 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	68 00 60 80 00       	push   $0x806000
  801aec:	53                   	push   %ebx
  801aed:	e8 f8 f0 ff ff       	call   800bea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801af2:	a1 80 60 80 00       	mov    0x806080,%eax
  801af7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801afd:	a1 84 60 80 00       	mov    0x806084,%eax
  801b02:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <devfile_write>:
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b23:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b28:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2e:	8b 52 0c             	mov    0xc(%edx),%edx
  801b31:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801b37:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b3c:	50                   	push   %eax
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	68 08 60 80 00       	push   $0x806008
  801b45:	e8 2e f2 ff ff       	call   800d78 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4f:	b8 04 00 00 00       	mov    $0x4,%eax
  801b54:	e8 ca fe ff ff       	call   801a23 <fsipc>
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <devfile_read>:
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	8b 40 0c             	mov    0xc(%eax),%eax
  801b69:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b6e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b74:	ba 00 00 00 00       	mov    $0x0,%edx
  801b79:	b8 03 00 00 00       	mov    $0x3,%eax
  801b7e:	e8 a0 fe ff ff       	call   801a23 <fsipc>
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	85 c0                	test   %eax,%eax
  801b87:	78 1f                	js     801ba8 <devfile_read+0x4d>
	assert(r <= n);
  801b89:	39 f0                	cmp    %esi,%eax
  801b8b:	77 24                	ja     801bb1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b8d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b92:	7f 33                	jg     801bc7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	50                   	push   %eax
  801b98:	68 00 60 80 00       	push   $0x806000
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	e8 d3 f1 ff ff       	call   800d78 <memmove>
	return r;
  801ba5:	83 c4 10             	add    $0x10,%esp
}
  801ba8:	89 d8                	mov    %ebx,%eax
  801baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5e                   	pop    %esi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    
	assert(r <= n);
  801bb1:	68 a8 34 80 00       	push   $0x8034a8
  801bb6:	68 af 34 80 00       	push   $0x8034af
  801bbb:	6a 7b                	push   $0x7b
  801bbd:	68 c4 34 80 00       	push   $0x8034c4
  801bc2:	e8 29 e9 ff ff       	call   8004f0 <_panic>
	assert(r <= PGSIZE);
  801bc7:	68 cf 34 80 00       	push   $0x8034cf
  801bcc:	68 af 34 80 00       	push   $0x8034af
  801bd1:	6a 7c                	push   $0x7c
  801bd3:	68 c4 34 80 00       	push   $0x8034c4
  801bd8:	e8 13 e9 ff ff       	call   8004f0 <_panic>

00801bdd <open>:
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	56                   	push   %esi
  801be1:	53                   	push   %ebx
  801be2:	83 ec 1c             	sub    $0x1c,%esp
  801be5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801be8:	56                   	push   %esi
  801be9:	e8 c5 ef ff ff       	call   800bb3 <strlen>
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bf6:	7f 6c                	jg     801c64 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfe:	50                   	push   %eax
  801bff:	e8 b4 f8 ff ff       	call   8014b8 <fd_alloc>
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 3c                	js     801c49 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	56                   	push   %esi
  801c11:	68 00 60 80 00       	push   $0x806000
  801c16:	e8 cf ef ff ff       	call   800bea <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	e8 f3 fd ff ff       	call   801a23 <fsipc>
  801c30:	89 c3                	mov    %eax,%ebx
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	85 c0                	test   %eax,%eax
  801c37:	78 19                	js     801c52 <open+0x75>
	return fd2num(fd);
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3f:	e8 4d f8 ff ff       	call   801491 <fd2num>
  801c44:	89 c3                	mov    %eax,%ebx
  801c46:	83 c4 10             	add    $0x10,%esp
}
  801c49:	89 d8                	mov    %ebx,%eax
  801c4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4e:	5b                   	pop    %ebx
  801c4f:	5e                   	pop    %esi
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    
		fd_close(fd, 0);
  801c52:	83 ec 08             	sub    $0x8,%esp
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5a:	e8 54 f9 ff ff       	call   8015b3 <fd_close>
		return r;
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	eb e5                	jmp    801c49 <open+0x6c>
		return -E_BAD_PATH;
  801c64:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c69:	eb de                	jmp    801c49 <open+0x6c>

00801c6b <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c71:	ba 00 00 00 00       	mov    $0x0,%edx
  801c76:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7b:	e8 a3 fd ff ff       	call   801a23 <fsipc>
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <spawn>:
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int spawn(const char *prog, const char **argv)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	57                   	push   %edi
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801c8e:	6a 00                	push   $0x0
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	e8 45 ff ff ff       	call   801bdd <open>
  801c98:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	0f 88 40 03 00 00    	js     801fe9 <spawn+0x367>
  801ca9:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *)elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) || elf->e_magic != ELF_MAGIC)
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	68 00 02 00 00       	push   $0x200
  801cb3:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801cb9:	50                   	push   %eax
  801cba:	51                   	push   %ecx
  801cbb:	e8 3f fb ff ff       	call   8017ff <readn>
  801cc0:	83 c4 10             	add    $0x10,%esp
  801cc3:	3d 00 02 00 00       	cmp    $0x200,%eax
  801cc8:	75 5d                	jne    801d27 <spawn+0xa5>
  801cca:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801cd1:	45 4c 46 
  801cd4:	75 51                	jne    801d27 <spawn+0xa5>
  801cd6:	b8 07 00 00 00       	mov    $0x7,%eax
  801cdb:	cd 30                	int    $0x30
  801cdd:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801ce3:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	0f 88 62 04 00 00    	js     802153 <spawn+0x4d1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801cf1:	25 ff 03 00 00       	and    $0x3ff,%eax
  801cf6:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801cf9:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801cff:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d05:	b9 11 00 00 00       	mov    $0x11,%ecx
  801d0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801d0c:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801d12:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d18:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801d1d:	be 00 00 00 00       	mov    $0x0,%esi
  801d22:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d25:	eb 4b                	jmp    801d72 <spawn+0xf0>
		close(fd);
  801d27:	83 ec 0c             	sub    $0xc,%esp
  801d2a:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801d30:	e8 07 f9 ff ff       	call   80163c <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801d35:	83 c4 0c             	add    $0xc,%esp
  801d38:	68 7f 45 4c 46       	push   $0x464c457f
  801d3d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801d43:	68 db 34 80 00       	push   $0x8034db
  801d48:	e8 7e e8 ff ff       	call   8005cb <cprintf>
		return -E_NOT_EXEC;
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801d57:	ff ff ff 
  801d5a:	e9 8a 02 00 00       	jmp    801fe9 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	50                   	push   %eax
  801d63:	e8 4b ee ff ff       	call   800bb3 <strlen>
  801d68:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801d6c:	83 c3 01             	add    $0x1,%ebx
  801d6f:	83 c4 10             	add    $0x10,%esp
  801d72:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801d79:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	75 df                	jne    801d5f <spawn+0xdd>
  801d80:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801d86:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *)UTEMP + PGSIZE - string_size;
  801d8c:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d91:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *)(ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d93:	89 fa                	mov    %edi,%edx
  801d95:	83 e2 fc             	and    $0xfffffffc,%edx
  801d98:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d9f:	29 c2                	sub    %eax,%edx
  801da1:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *)(argv_store - 2) < (void *)UTEMP)
  801da7:	8d 42 f8             	lea    -0x8(%edx),%eax
  801daa:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801daf:	0f 86 af 03 00 00    	jbe    802164 <spawn+0x4e2>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	6a 07                	push   $0x7
  801dba:	68 00 00 40 00       	push   $0x400000
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 1d f2 ff ff       	call   800fe3 <sys_page_alloc>
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	0f 88 98 03 00 00    	js     802169 <spawn+0x4e7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++)
  801dd1:	be 00 00 00 00       	mov    $0x0,%esi
  801dd6:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801ddc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ddf:	eb 30                	jmp    801e11 <spawn+0x18f>
	{
		argv_store[i] = UTEMP2USTACK(string_store);
  801de1:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801de7:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801ded:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801df0:	83 ec 08             	sub    $0x8,%esp
  801df3:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801df6:	57                   	push   %edi
  801df7:	e8 ee ed ff ff       	call   800bea <strcpy>
		string_store += strlen(argv[i]) + 1;
  801dfc:	83 c4 04             	add    $0x4,%esp
  801dff:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801e02:	e8 ac ed ff ff       	call   800bb3 <strlen>
  801e07:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++)
  801e0b:	83 c6 01             	add    $0x1,%esi
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801e17:	7f c8                	jg     801de1 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801e19:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e1f:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801e25:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *)UTEMP + PGSIZE);
  801e2c:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801e32:	0f 85 8c 00 00 00    	jne    801ec4 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801e38:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801e3e:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801e44:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801e47:	89 f8                	mov    %edi,%eax
  801e49:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801e4f:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e52:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801e57:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void *)(USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	6a 07                	push   $0x7
  801e62:	68 00 d0 bf ee       	push   $0xeebfd000
  801e67:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e6d:	68 00 00 40 00       	push   $0x400000
  801e72:	6a 00                	push   $0x0
  801e74:	e8 ad f1 ff ff       	call   801026 <sys_page_map>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 20             	add    $0x20,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	0f 88 59 03 00 00    	js     8021df <spawn+0x55d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801e86:	83 ec 08             	sub    $0x8,%esp
  801e89:	68 00 00 40 00       	push   $0x400000
  801e8e:	6a 00                	push   $0x0
  801e90:	e8 d3 f1 ff ff       	call   801068 <sys_page_unmap>
  801e95:	89 c3                	mov    %eax,%ebx
  801e97:	83 c4 10             	add    $0x10,%esp
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	0f 88 3d 03 00 00    	js     8021df <spawn+0x55d>
	ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  801ea2:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ea8:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801eaf:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801eb5:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801ebc:	00 00 00 
  801ebf:	e9 56 01 00 00       	jmp    80201a <spawn+0x398>
	assert(string_store == (char *)UTEMP + PGSIZE);
  801ec4:	68 68 35 80 00       	push   $0x803568
  801ec9:	68 af 34 80 00       	push   $0x8034af
  801ece:	68 f0 00 00 00       	push   $0xf0
  801ed3:	68 f5 34 80 00       	push   $0x8034f5
  801ed8:	e8 13 e6 ff ff       	call   8004f0 <_panic>
				return r;
		}
		else
		{
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	6a 07                	push   $0x7
  801ee2:	68 00 00 40 00       	push   $0x400000
  801ee7:	6a 00                	push   $0x0
  801ee9:	e8 f5 f0 ff ff       	call   800fe3 <sys_page_alloc>
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	0f 88 7b 02 00 00    	js     802174 <spawn+0x4f2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801ef9:	83 ec 08             	sub    $0x8,%esp
  801efc:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801f02:	01 f0                	add    %esi,%eax
  801f04:	50                   	push   %eax
  801f05:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801f0b:	e8 b8 f9 ff ff       	call   8018c8 <seek>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	85 c0                	test   %eax,%eax
  801f15:	0f 88 60 02 00 00    	js     80217b <spawn+0x4f9>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f24:	29 f0                	sub    %esi,%eax
  801f26:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f2b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f30:	0f 47 c1             	cmova  %ecx,%eax
  801f33:	50                   	push   %eax
  801f34:	68 00 00 40 00       	push   $0x400000
  801f39:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801f3f:	e8 bb f8 ff ff       	call   8017ff <readn>
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	85 c0                	test   %eax,%eax
  801f49:	0f 88 33 02 00 00    	js     802182 <spawn+0x500>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void *)(va + i), perm)) < 0)
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	57                   	push   %edi
  801f53:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801f59:	56                   	push   %esi
  801f5a:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801f60:	68 00 00 40 00       	push   $0x400000
  801f65:	6a 00                	push   $0x0
  801f67:	e8 ba f0 ff ff       	call   801026 <sys_page_map>
  801f6c:	83 c4 20             	add    $0x20,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	0f 88 80 00 00 00    	js     801ff7 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	68 00 00 40 00       	push   $0x400000
  801f7f:	6a 00                	push   $0x0
  801f81:	e8 e2 f0 ff ff       	call   801068 <sys_page_unmap>
  801f86:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE)
  801f89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f8f:	89 de                	mov    %ebx,%esi
  801f91:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801f97:	76 73                	jbe    80200c <spawn+0x38a>
		if (i >= filesz)
  801f99:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801f9f:	0f 87 38 ff ff ff    	ja     801edd <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void *)(va + i), perm)) < 0)
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	57                   	push   %edi
  801fa9:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801faf:	56                   	push   %esi
  801fb0:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801fb6:	e8 28 f0 ff ff       	call   800fe3 <sys_page_alloc>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	79 c7                	jns    801f89 <spawn+0x307>
  801fc2:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801fcd:	e8 92 ef ff ff       	call   800f64 <sys_env_destroy>
	close(fd);
  801fd2:	83 c4 04             	add    $0x4,%esp
  801fd5:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801fdb:	e8 5c f6 ff ff       	call   80163c <close>
	return r;
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801fe9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801fef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff2:	5b                   	pop    %ebx
  801ff3:	5e                   	pop    %esi
  801ff4:	5f                   	pop    %edi
  801ff5:	5d                   	pop    %ebp
  801ff6:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801ff7:	50                   	push   %eax
  801ff8:	68 01 35 80 00       	push   $0x803501
  801ffd:	68 28 01 00 00       	push   $0x128
  802002:	68 f5 34 80 00       	push   $0x8034f5
  802007:	e8 e4 e4 ff ff       	call   8004f0 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++)
  80200c:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802013:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  80201a:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802021:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802027:	7e 71                	jle    80209a <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  802029:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  80202f:	83 3a 01             	cmpl   $0x1,(%edx)
  802032:	75 d8                	jne    80200c <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802034:	8b 42 18             	mov    0x18(%edx),%eax
  802037:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80203a:	83 f8 01             	cmp    $0x1,%eax
  80203d:	19 ff                	sbb    %edi,%edi
  80203f:	83 e7 fe             	and    $0xfffffffe,%edi
  802042:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802045:	8b 72 04             	mov    0x4(%edx),%esi
  802048:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  80204e:	8b 5a 10             	mov    0x10(%edx),%ebx
  802051:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802057:	8b 42 14             	mov    0x14(%edx),%eax
  80205a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802060:	8b 4a 08             	mov    0x8(%edx),%ecx
  802063:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
	if ((i = PGOFF(va)))
  802069:	89 c8                	mov    %ecx,%eax
  80206b:	25 ff 0f 00 00       	and    $0xfff,%eax
  802070:	74 1e                	je     802090 <spawn+0x40e>
		va -= i;
  802072:	29 c1                	sub    %eax,%ecx
  802074:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
		memsz += i;
  80207a:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802080:	01 c3                	add    %eax,%ebx
  802082:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  802088:	29 c6                	sub    %eax,%esi
  80208a:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE)
  802090:	bb 00 00 00 00       	mov    $0x0,%ebx
  802095:	e9 f5 fe ff ff       	jmp    801f8f <spawn+0x30d>
	close(fd);
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8020a3:	e8 94 f5 ff ff       	call   80163c <close>
  8020a8:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int r, pn;
	struct Env *e;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8020ab:	bb 00 08 00 00       	mov    $0x800,%ebx
  8020b0:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  8020b6:	eb 0f                	jmp    8020c7 <spawn+0x445>
  8020b8:	83 c3 01             	add    $0x1,%ebx
  8020bb:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8020c1:	0f 84 c2 00 00 00    	je     802189 <spawn+0x507>
	{
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8020c7:	89 d8                	mov    %ebx,%eax
  8020c9:	c1 f8 0a             	sar    $0xa,%eax
  8020cc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020d3:	a8 01                	test   $0x1,%al
  8020d5:	74 e1                	je     8020b8 <spawn+0x436>
  8020d7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8020de:	a8 01                	test   $0x1,%al
  8020e0:	74 d6                	je     8020b8 <spawn+0x436>
		{
			if (uvpt[pn] & PTE_SHARE)
  8020e2:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8020e9:	f6 c4 04             	test   $0x4,%ah
  8020ec:	74 ca                	je     8020b8 <spawn+0x436>
			{
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
									  child, (void *)(pn * PGSIZE),
									  uvpt[pn] & PTE_SYSCALL)) < 0)
  8020ee:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8020f5:	89 da                	mov    %ebx,%edx
  8020f7:	c1 e2 0c             	shl    $0xc,%edx
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
  8020fa:	83 ec 0c             	sub    $0xc,%esp
  8020fd:	25 07 0e 00 00       	and    $0xe07,%eax
  802102:	50                   	push   %eax
  802103:	52                   	push   %edx
  802104:	56                   	push   %esi
  802105:	52                   	push   %edx
  802106:	6a 00                	push   $0x0
  802108:	e8 19 ef ff ff       	call   801026 <sys_page_map>
  80210d:	83 c4 20             	add    $0x20,%esp
  802110:	85 c0                	test   %eax,%eax
  802112:	79 a4                	jns    8020b8 <spawn+0x436>
		panic("copy_shared_pages: %e", r);
  802114:	50                   	push   %eax
  802115:	68 4f 35 80 00       	push   $0x80354f
  80211a:	68 82 00 00 00       	push   $0x82
  80211f:	68 f5 34 80 00       	push   $0x8034f5
  802124:	e8 c7 e3 ff ff       	call   8004f0 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  802129:	50                   	push   %eax
  80212a:	68 1e 35 80 00       	push   $0x80351e
  80212f:	68 86 00 00 00       	push   $0x86
  802134:	68 f5 34 80 00       	push   $0x8034f5
  802139:	e8 b2 e3 ff ff       	call   8004f0 <_panic>
		panic("sys_env_set_status: %e", r);
  80213e:	50                   	push   %eax
  80213f:	68 38 35 80 00       	push   $0x803538
  802144:	68 89 00 00 00       	push   $0x89
  802149:	68 f5 34 80 00       	push   $0x8034f5
  80214e:	e8 9d e3 ff ff       	call   8004f0 <_panic>
		return r;
  802153:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802159:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  80215f:	e9 85 fe ff ff       	jmp    801fe9 <spawn+0x367>
		return -E_NO_MEM;
  802164:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  802169:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  80216f:	e9 75 fe ff ff       	jmp    801fe9 <spawn+0x367>
  802174:	89 c7                	mov    %eax,%edi
  802176:	e9 49 fe ff ff       	jmp    801fc4 <spawn+0x342>
  80217b:	89 c7                	mov    %eax,%edi
  80217d:	e9 42 fe ff ff       	jmp    801fc4 <spawn+0x342>
  802182:	89 c7                	mov    %eax,%edi
  802184:	e9 3b fe ff ff       	jmp    801fc4 <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3; // devious: see user/faultio.c
  802189:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802190:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802193:	83 ec 08             	sub    $0x8,%esp
  802196:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80219c:	50                   	push   %eax
  80219d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8021a3:	e8 44 ef ff ff       	call   8010ec <sys_env_set_trapframe>
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	0f 88 76 ff ff ff    	js     802129 <spawn+0x4a7>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8021b3:	83 ec 08             	sub    $0x8,%esp
  8021b6:	6a 02                	push   $0x2
  8021b8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8021be:	e8 e7 ee ff ff       	call   8010aa <sys_env_set_status>
  8021c3:	83 c4 10             	add    $0x10,%esp
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	0f 88 70 ff ff ff    	js     80213e <spawn+0x4bc>
	return child;
  8021ce:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021d4:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8021da:	e9 0a fe ff ff       	jmp    801fe9 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  8021df:	83 ec 08             	sub    $0x8,%esp
  8021e2:	68 00 00 40 00       	push   $0x400000
  8021e7:	6a 00                	push   $0x0
  8021e9:	e8 7a ee ff ff       	call   801068 <sys_page_unmap>
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8021f7:	e9 ed fd ff ff       	jmp    801fe9 <spawn+0x367>

008021fc <spawnl>:
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	57                   	push   %edi
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802205:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  802208:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  80220d:	eb 05                	jmp    802214 <spawnl+0x18>
		argc++;
  80220f:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  802212:	89 ca                	mov    %ecx,%edx
  802214:	8d 4a 04             	lea    0x4(%edx),%ecx
  802217:	83 3a 00             	cmpl   $0x0,(%edx)
  80221a:	75 f3                	jne    80220f <spawnl+0x13>
	const char *argv[argc + 2];
  80221c:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802223:	83 e2 f0             	and    $0xfffffff0,%edx
  802226:	29 d4                	sub    %edx,%esp
  802228:	8d 54 24 03          	lea    0x3(%esp),%edx
  80222c:	c1 ea 02             	shr    $0x2,%edx
  80222f:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802236:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802238:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80223b:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  802242:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802249:	00 
	va_start(vl, arg0);
  80224a:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80224d:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	eb 0b                	jmp    802261 <spawnl+0x65>
		argv[i + 1] = va_arg(vl, const char *);
  802256:	83 c0 01             	add    $0x1,%eax
  802259:	8b 39                	mov    (%ecx),%edi
  80225b:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80225e:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  802261:	39 d0                	cmp    %edx,%eax
  802263:	75 f1                	jne    802256 <spawnl+0x5a>
	return spawn(prog, argv);
  802265:	83 ec 08             	sub    $0x8,%esp
  802268:	56                   	push   %esi
  802269:	ff 75 08             	pushl  0x8(%ebp)
  80226c:	e8 11 fa ff ff       	call   801c82 <spawn>
}
  802271:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802274:	5b                   	pop    %ebx
  802275:	5e                   	pop    %esi
  802276:	5f                   	pop    %edi
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    

00802279 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80227f:	68 90 35 80 00       	push   $0x803590
  802284:	ff 75 0c             	pushl  0xc(%ebp)
  802287:	e8 5e e9 ff ff       	call   800bea <strcpy>
	return 0;
}
  80228c:	b8 00 00 00 00       	mov    $0x0,%eax
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <devsock_close>:
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	53                   	push   %ebx
  802297:	83 ec 10             	sub    $0x10,%esp
  80229a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80229d:	53                   	push   %ebx
  80229e:	e8 56 09 00 00       	call   802bf9 <pageref>
  8022a3:	83 c4 10             	add    $0x10,%esp
		return 0;
  8022a6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8022ab:	83 f8 01             	cmp    $0x1,%eax
  8022ae:	74 07                	je     8022b7 <devsock_close+0x24>
}
  8022b0:	89 d0                	mov    %edx,%eax
  8022b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8022b7:	83 ec 0c             	sub    $0xc,%esp
  8022ba:	ff 73 0c             	pushl  0xc(%ebx)
  8022bd:	e8 b7 02 00 00       	call   802579 <nsipc_close>
  8022c2:	89 c2                	mov    %eax,%edx
  8022c4:	83 c4 10             	add    $0x10,%esp
  8022c7:	eb e7                	jmp    8022b0 <devsock_close+0x1d>

008022c9 <devsock_write>:
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8022cf:	6a 00                	push   $0x0
  8022d1:	ff 75 10             	pushl  0x10(%ebp)
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	ff 70 0c             	pushl  0xc(%eax)
  8022dd:	e8 74 03 00 00       	call   802656 <nsipc_send>
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <devsock_read>:
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	ff 75 10             	pushl  0x10(%ebp)
  8022ef:	ff 75 0c             	pushl  0xc(%ebp)
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	ff 70 0c             	pushl  0xc(%eax)
  8022f8:	e8 ed 02 00 00       	call   8025ea <nsipc_recv>
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <fd2sockid>:
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802305:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	e8 f8 f1 ff ff       	call   801507 <fd_lookup>
  80230f:	83 c4 10             	add    $0x10,%esp
  802312:	85 c0                	test   %eax,%eax
  802314:	78 10                	js     802326 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  80231f:	39 08                	cmp    %ecx,(%eax)
  802321:	75 05                	jne    802328 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802323:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    
		return -E_NOT_SUPP;
  802328:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80232d:	eb f7                	jmp    802326 <fd2sockid+0x27>

0080232f <alloc_sockfd>:
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802339:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233c:	50                   	push   %eax
  80233d:	e8 76 f1 ff ff       	call   8014b8 <fd_alloc>
  802342:	89 c3                	mov    %eax,%ebx
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	85 c0                	test   %eax,%eax
  802349:	78 43                	js     80238e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	68 07 04 00 00       	push   $0x407
  802353:	ff 75 f4             	pushl  -0xc(%ebp)
  802356:	6a 00                	push   $0x0
  802358:	e8 86 ec ff ff       	call   800fe3 <sys_page_alloc>
  80235d:	89 c3                	mov    %eax,%ebx
  80235f:	83 c4 10             	add    $0x10,%esp
  802362:	85 c0                	test   %eax,%eax
  802364:	78 28                	js     80238e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80236f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80237b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80237e:	83 ec 0c             	sub    $0xc,%esp
  802381:	50                   	push   %eax
  802382:	e8 0a f1 ff ff       	call   801491 <fd2num>
  802387:	89 c3                	mov    %eax,%ebx
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	eb 0c                	jmp    80239a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80238e:	83 ec 0c             	sub    $0xc,%esp
  802391:	56                   	push   %esi
  802392:	e8 e2 01 00 00       	call   802579 <nsipc_close>
		return r;
  802397:	83 c4 10             	add    $0x10,%esp
}
  80239a:	89 d8                	mov    %ebx,%eax
  80239c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5d                   	pop    %ebp
  8023a2:	c3                   	ret    

008023a3 <accept>:
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	e8 4e ff ff ff       	call   8022ff <fd2sockid>
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	78 1b                	js     8023d0 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023b5:	83 ec 04             	sub    $0x4,%esp
  8023b8:	ff 75 10             	pushl  0x10(%ebp)
  8023bb:	ff 75 0c             	pushl  0xc(%ebp)
  8023be:	50                   	push   %eax
  8023bf:	e8 0e 01 00 00       	call   8024d2 <nsipc_accept>
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	78 05                	js     8023d0 <accept+0x2d>
	return alloc_sockfd(r);
  8023cb:	e8 5f ff ff ff       	call   80232f <alloc_sockfd>
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <bind>:
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	e8 1f ff ff ff       	call   8022ff <fd2sockid>
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	78 12                	js     8023f6 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8023e4:	83 ec 04             	sub    $0x4,%esp
  8023e7:	ff 75 10             	pushl  0x10(%ebp)
  8023ea:	ff 75 0c             	pushl  0xc(%ebp)
  8023ed:	50                   	push   %eax
  8023ee:	e8 2f 01 00 00       	call   802522 <nsipc_bind>
  8023f3:	83 c4 10             	add    $0x10,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <shutdown>:
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	e8 f9 fe ff ff       	call   8022ff <fd2sockid>
  802406:	85 c0                	test   %eax,%eax
  802408:	78 0f                	js     802419 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80240a:	83 ec 08             	sub    $0x8,%esp
  80240d:	ff 75 0c             	pushl  0xc(%ebp)
  802410:	50                   	push   %eax
  802411:	e8 41 01 00 00       	call   802557 <nsipc_shutdown>
  802416:	83 c4 10             	add    $0x10,%esp
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <connect>:
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	e8 d6 fe ff ff       	call   8022ff <fd2sockid>
  802429:	85 c0                	test   %eax,%eax
  80242b:	78 12                	js     80243f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80242d:	83 ec 04             	sub    $0x4,%esp
  802430:	ff 75 10             	pushl  0x10(%ebp)
  802433:	ff 75 0c             	pushl  0xc(%ebp)
  802436:	50                   	push   %eax
  802437:	e8 57 01 00 00       	call   802593 <nsipc_connect>
  80243c:	83 c4 10             	add    $0x10,%esp
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <listen>:
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	e8 b0 fe ff ff       	call   8022ff <fd2sockid>
  80244f:	85 c0                	test   %eax,%eax
  802451:	78 0f                	js     802462 <listen+0x21>
	return nsipc_listen(r, backlog);
  802453:	83 ec 08             	sub    $0x8,%esp
  802456:	ff 75 0c             	pushl  0xc(%ebp)
  802459:	50                   	push   %eax
  80245a:	e8 69 01 00 00       	call   8025c8 <nsipc_listen>
  80245f:	83 c4 10             	add    $0x10,%esp
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <socket>:

int
socket(int domain, int type, int protocol)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80246a:	ff 75 10             	pushl  0x10(%ebp)
  80246d:	ff 75 0c             	pushl  0xc(%ebp)
  802470:	ff 75 08             	pushl  0x8(%ebp)
  802473:	e8 3c 02 00 00       	call   8026b4 <nsipc_socket>
  802478:	83 c4 10             	add    $0x10,%esp
  80247b:	85 c0                	test   %eax,%eax
  80247d:	78 05                	js     802484 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80247f:	e8 ab fe ff ff       	call   80232f <alloc_sockfd>
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	53                   	push   %ebx
  80248a:	83 ec 04             	sub    $0x4,%esp
  80248d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80248f:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802496:	74 26                	je     8024be <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802498:	6a 07                	push   $0x7
  80249a:	68 00 70 80 00       	push   $0x807000
  80249f:	53                   	push   %ebx
  8024a0:	ff 35 04 50 80 00    	pushl  0x805004
  8024a6:	e8 c1 06 00 00       	call   802b6c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8024ab:	83 c4 0c             	add    $0xc,%esp
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	e8 4c 06 00 00       	call   802b05 <ipc_recv>
}
  8024b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	6a 02                	push   $0x2
  8024c3:	e8 f8 06 00 00       	call   802bc0 <ipc_find_env>
  8024c8:	a3 04 50 80 00       	mov    %eax,0x805004
  8024cd:	83 c4 10             	add    $0x10,%esp
  8024d0:	eb c6                	jmp    802498 <nsipc+0x12>

008024d2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	56                   	push   %esi
  8024d6:	53                   	push   %ebx
  8024d7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8024e2:	8b 06                	mov    (%esi),%eax
  8024e4:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8024e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ee:	e8 93 ff ff ff       	call   802486 <nsipc>
  8024f3:	89 c3                	mov    %eax,%ebx
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	78 20                	js     802519 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	ff 35 10 70 80 00    	pushl  0x807010
  802502:	68 00 70 80 00       	push   $0x807000
  802507:	ff 75 0c             	pushl  0xc(%ebp)
  80250a:	e8 69 e8 ff ff       	call   800d78 <memmove>
		*addrlen = ret->ret_addrlen;
  80250f:	a1 10 70 80 00       	mov    0x807010,%eax
  802514:	89 06                	mov    %eax,(%esi)
  802516:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802519:	89 d8                	mov    %ebx,%eax
  80251b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80251e:	5b                   	pop    %ebx
  80251f:	5e                   	pop    %esi
  802520:	5d                   	pop    %ebp
  802521:	c3                   	ret    

00802522 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	53                   	push   %ebx
  802526:	83 ec 08             	sub    $0x8,%esp
  802529:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80252c:	8b 45 08             	mov    0x8(%ebp),%eax
  80252f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802534:	53                   	push   %ebx
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	68 04 70 80 00       	push   $0x807004
  80253d:	e8 36 e8 ff ff       	call   800d78 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802542:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802548:	b8 02 00 00 00       	mov    $0x2,%eax
  80254d:	e8 34 ff ff ff       	call   802486 <nsipc>
}
  802552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802565:	8b 45 0c             	mov    0xc(%ebp),%eax
  802568:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80256d:	b8 03 00 00 00       	mov    $0x3,%eax
  802572:	e8 0f ff ff ff       	call   802486 <nsipc>
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <nsipc_close>:

int
nsipc_close(int s)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802587:	b8 04 00 00 00       	mov    $0x4,%eax
  80258c:	e8 f5 fe ff ff       	call   802486 <nsipc>
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	53                   	push   %ebx
  802597:	83 ec 08             	sub    $0x8,%esp
  80259a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8025a5:	53                   	push   %ebx
  8025a6:	ff 75 0c             	pushl  0xc(%ebp)
  8025a9:	68 04 70 80 00       	push   $0x807004
  8025ae:	e8 c5 e7 ff ff       	call   800d78 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8025b3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8025b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8025be:	e8 c3 fe ff ff       	call   802486 <nsipc>
}
  8025c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8025d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d9:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8025de:	b8 06 00 00 00       	mov    $0x6,%eax
  8025e3:	e8 9e fe ff ff       	call   802486 <nsipc>
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	56                   	push   %esi
  8025ee:	53                   	push   %ebx
  8025ef:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8025fa:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802600:	8b 45 14             	mov    0x14(%ebp),%eax
  802603:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802608:	b8 07 00 00 00       	mov    $0x7,%eax
  80260d:	e8 74 fe ff ff       	call   802486 <nsipc>
  802612:	89 c3                	mov    %eax,%ebx
  802614:	85 c0                	test   %eax,%eax
  802616:	78 1f                	js     802637 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802618:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80261d:	7f 21                	jg     802640 <nsipc_recv+0x56>
  80261f:	39 c6                	cmp    %eax,%esi
  802621:	7c 1d                	jl     802640 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	50                   	push   %eax
  802627:	68 00 70 80 00       	push   $0x807000
  80262c:	ff 75 0c             	pushl  0xc(%ebp)
  80262f:	e8 44 e7 ff ff       	call   800d78 <memmove>
  802634:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802637:	89 d8                	mov    %ebx,%eax
  802639:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80263c:	5b                   	pop    %ebx
  80263d:	5e                   	pop    %esi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802640:	68 9c 35 80 00       	push   $0x80359c
  802645:	68 af 34 80 00       	push   $0x8034af
  80264a:	6a 62                	push   $0x62
  80264c:	68 b1 35 80 00       	push   $0x8035b1
  802651:	e8 9a de ff ff       	call   8004f0 <_panic>

00802656 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	53                   	push   %ebx
  80265a:	83 ec 04             	sub    $0x4,%esp
  80265d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802668:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80266e:	7f 2e                	jg     80269e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	53                   	push   %ebx
  802674:	ff 75 0c             	pushl  0xc(%ebp)
  802677:	68 0c 70 80 00       	push   $0x80700c
  80267c:	e8 f7 e6 ff ff       	call   800d78 <memmove>
	nsipcbuf.send.req_size = size;
  802681:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802687:	8b 45 14             	mov    0x14(%ebp),%eax
  80268a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80268f:	b8 08 00 00 00       	mov    $0x8,%eax
  802694:	e8 ed fd ff ff       	call   802486 <nsipc>
}
  802699:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    
	assert(size < 1600);
  80269e:	68 bd 35 80 00       	push   $0x8035bd
  8026a3:	68 af 34 80 00       	push   $0x8034af
  8026a8:	6a 6d                	push   $0x6d
  8026aa:	68 b1 35 80 00       	push   $0x8035b1
  8026af:	e8 3c de ff ff       	call   8004f0 <_panic>

008026b4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8026c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c5:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8026ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8026cd:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8026d2:	b8 09 00 00 00       	mov    $0x9,%eax
  8026d7:	e8 aa fd ff ff       	call   802486 <nsipc>
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	56                   	push   %esi
  8026e2:	53                   	push   %ebx
  8026e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	ff 75 08             	pushl  0x8(%ebp)
  8026ec:	e8 b0 ed ff ff       	call   8014a1 <fd2data>
  8026f1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8026f3:	83 c4 08             	add    $0x8,%esp
  8026f6:	68 c9 35 80 00       	push   $0x8035c9
  8026fb:	53                   	push   %ebx
  8026fc:	e8 e9 e4 ff ff       	call   800bea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802701:	8b 46 04             	mov    0x4(%esi),%eax
  802704:	2b 06                	sub    (%esi),%eax
  802706:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80270c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802713:	00 00 00 
	stat->st_dev = &devpipe;
  802716:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  80271d:	40 80 00 
	return 0;
}
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
  802725:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802728:	5b                   	pop    %ebx
  802729:	5e                   	pop    %esi
  80272a:	5d                   	pop    %ebp
  80272b:	c3                   	ret    

0080272c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	53                   	push   %ebx
  802730:	83 ec 0c             	sub    $0xc,%esp
  802733:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802736:	53                   	push   %ebx
  802737:	6a 00                	push   $0x0
  802739:	e8 2a e9 ff ff       	call   801068 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80273e:	89 1c 24             	mov    %ebx,(%esp)
  802741:	e8 5b ed ff ff       	call   8014a1 <fd2data>
  802746:	83 c4 08             	add    $0x8,%esp
  802749:	50                   	push   %eax
  80274a:	6a 00                	push   $0x0
  80274c:	e8 17 e9 ff ff       	call   801068 <sys_page_unmap>
}
  802751:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <_pipeisclosed>:
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	57                   	push   %edi
  80275a:	56                   	push   %esi
  80275b:	53                   	push   %ebx
  80275c:	83 ec 1c             	sub    $0x1c,%esp
  80275f:	89 c7                	mov    %eax,%edi
  802761:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802763:	a1 08 50 80 00       	mov    0x805008,%eax
  802768:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80276b:	83 ec 0c             	sub    $0xc,%esp
  80276e:	57                   	push   %edi
  80276f:	e8 85 04 00 00       	call   802bf9 <pageref>
  802774:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802777:	89 34 24             	mov    %esi,(%esp)
  80277a:	e8 7a 04 00 00       	call   802bf9 <pageref>
		nn = thisenv->env_runs;
  80277f:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802785:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802788:	83 c4 10             	add    $0x10,%esp
  80278b:	39 cb                	cmp    %ecx,%ebx
  80278d:	74 1b                	je     8027aa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80278f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802792:	75 cf                	jne    802763 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802794:	8b 42 58             	mov    0x58(%edx),%eax
  802797:	6a 01                	push   $0x1
  802799:	50                   	push   %eax
  80279a:	53                   	push   %ebx
  80279b:	68 d0 35 80 00       	push   $0x8035d0
  8027a0:	e8 26 de ff ff       	call   8005cb <cprintf>
  8027a5:	83 c4 10             	add    $0x10,%esp
  8027a8:	eb b9                	jmp    802763 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8027aa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8027ad:	0f 94 c0             	sete   %al
  8027b0:	0f b6 c0             	movzbl %al,%eax
}
  8027b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027b6:	5b                   	pop    %ebx
  8027b7:	5e                   	pop    %esi
  8027b8:	5f                   	pop    %edi
  8027b9:	5d                   	pop    %ebp
  8027ba:	c3                   	ret    

008027bb <devpipe_write>:
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	57                   	push   %edi
  8027bf:	56                   	push   %esi
  8027c0:	53                   	push   %ebx
  8027c1:	83 ec 28             	sub    $0x28,%esp
  8027c4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8027c7:	56                   	push   %esi
  8027c8:	e8 d4 ec ff ff       	call   8014a1 <fd2data>
  8027cd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8027cf:	83 c4 10             	add    $0x10,%esp
  8027d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8027da:	74 4f                	je     80282b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027dc:	8b 43 04             	mov    0x4(%ebx),%eax
  8027df:	8b 0b                	mov    (%ebx),%ecx
  8027e1:	8d 51 20             	lea    0x20(%ecx),%edx
  8027e4:	39 d0                	cmp    %edx,%eax
  8027e6:	72 14                	jb     8027fc <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8027e8:	89 da                	mov    %ebx,%edx
  8027ea:	89 f0                	mov    %esi,%eax
  8027ec:	e8 65 ff ff ff       	call   802756 <_pipeisclosed>
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	75 3a                	jne    80282f <devpipe_write+0x74>
			sys_yield();
  8027f5:	e8 ca e7 ff ff       	call   800fc4 <sys_yield>
  8027fa:	eb e0                	jmp    8027dc <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027ff:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802803:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802806:	89 c2                	mov    %eax,%edx
  802808:	c1 fa 1f             	sar    $0x1f,%edx
  80280b:	89 d1                	mov    %edx,%ecx
  80280d:	c1 e9 1b             	shr    $0x1b,%ecx
  802810:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802813:	83 e2 1f             	and    $0x1f,%edx
  802816:	29 ca                	sub    %ecx,%edx
  802818:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80281c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802820:	83 c0 01             	add    $0x1,%eax
  802823:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802826:	83 c7 01             	add    $0x1,%edi
  802829:	eb ac                	jmp    8027d7 <devpipe_write+0x1c>
	return i;
  80282b:	89 f8                	mov    %edi,%eax
  80282d:	eb 05                	jmp    802834 <devpipe_write+0x79>
				return 0;
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802834:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802837:	5b                   	pop    %ebx
  802838:	5e                   	pop    %esi
  802839:	5f                   	pop    %edi
  80283a:	5d                   	pop    %ebp
  80283b:	c3                   	ret    

0080283c <devpipe_read>:
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	57                   	push   %edi
  802840:	56                   	push   %esi
  802841:	53                   	push   %ebx
  802842:	83 ec 18             	sub    $0x18,%esp
  802845:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802848:	57                   	push   %edi
  802849:	e8 53 ec ff ff       	call   8014a1 <fd2data>
  80284e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802850:	83 c4 10             	add    $0x10,%esp
  802853:	be 00 00 00 00       	mov    $0x0,%esi
  802858:	3b 75 10             	cmp    0x10(%ebp),%esi
  80285b:	74 47                	je     8028a4 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80285d:	8b 03                	mov    (%ebx),%eax
  80285f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802862:	75 22                	jne    802886 <devpipe_read+0x4a>
			if (i > 0)
  802864:	85 f6                	test   %esi,%esi
  802866:	75 14                	jne    80287c <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802868:	89 da                	mov    %ebx,%edx
  80286a:	89 f8                	mov    %edi,%eax
  80286c:	e8 e5 fe ff ff       	call   802756 <_pipeisclosed>
  802871:	85 c0                	test   %eax,%eax
  802873:	75 33                	jne    8028a8 <devpipe_read+0x6c>
			sys_yield();
  802875:	e8 4a e7 ff ff       	call   800fc4 <sys_yield>
  80287a:	eb e1                	jmp    80285d <devpipe_read+0x21>
				return i;
  80287c:	89 f0                	mov    %esi,%eax
}
  80287e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802886:	99                   	cltd   
  802887:	c1 ea 1b             	shr    $0x1b,%edx
  80288a:	01 d0                	add    %edx,%eax
  80288c:	83 e0 1f             	and    $0x1f,%eax
  80288f:	29 d0                	sub    %edx,%eax
  802891:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802896:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802899:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80289c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80289f:	83 c6 01             	add    $0x1,%esi
  8028a2:	eb b4                	jmp    802858 <devpipe_read+0x1c>
	return i;
  8028a4:	89 f0                	mov    %esi,%eax
  8028a6:	eb d6                	jmp    80287e <devpipe_read+0x42>
				return 0;
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ad:	eb cf                	jmp    80287e <devpipe_read+0x42>

008028af <pipe>:
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
  8028b2:	56                   	push   %esi
  8028b3:	53                   	push   %ebx
  8028b4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8028b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ba:	50                   	push   %eax
  8028bb:	e8 f8 eb ff ff       	call   8014b8 <fd_alloc>
  8028c0:	89 c3                	mov    %eax,%ebx
  8028c2:	83 c4 10             	add    $0x10,%esp
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	78 5b                	js     802924 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	68 07 04 00 00       	push   $0x407
  8028d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8028d4:	6a 00                	push   $0x0
  8028d6:	e8 08 e7 ff ff       	call   800fe3 <sys_page_alloc>
  8028db:	89 c3                	mov    %eax,%ebx
  8028dd:	83 c4 10             	add    $0x10,%esp
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	78 40                	js     802924 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8028e4:	83 ec 0c             	sub    $0xc,%esp
  8028e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028ea:	50                   	push   %eax
  8028eb:	e8 c8 eb ff ff       	call   8014b8 <fd_alloc>
  8028f0:	89 c3                	mov    %eax,%ebx
  8028f2:	83 c4 10             	add    $0x10,%esp
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	78 1b                	js     802914 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	68 07 04 00 00       	push   $0x407
  802901:	ff 75 f0             	pushl  -0x10(%ebp)
  802904:	6a 00                	push   $0x0
  802906:	e8 d8 e6 ff ff       	call   800fe3 <sys_page_alloc>
  80290b:	89 c3                	mov    %eax,%ebx
  80290d:	83 c4 10             	add    $0x10,%esp
  802910:	85 c0                	test   %eax,%eax
  802912:	79 19                	jns    80292d <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802914:	83 ec 08             	sub    $0x8,%esp
  802917:	ff 75 f4             	pushl  -0xc(%ebp)
  80291a:	6a 00                	push   $0x0
  80291c:	e8 47 e7 ff ff       	call   801068 <sys_page_unmap>
  802921:	83 c4 10             	add    $0x10,%esp
}
  802924:	89 d8                	mov    %ebx,%eax
  802926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802929:	5b                   	pop    %ebx
  80292a:	5e                   	pop    %esi
  80292b:	5d                   	pop    %ebp
  80292c:	c3                   	ret    
	va = fd2data(fd0);
  80292d:	83 ec 0c             	sub    $0xc,%esp
  802930:	ff 75 f4             	pushl  -0xc(%ebp)
  802933:	e8 69 eb ff ff       	call   8014a1 <fd2data>
  802938:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80293a:	83 c4 0c             	add    $0xc,%esp
  80293d:	68 07 04 00 00       	push   $0x407
  802942:	50                   	push   %eax
  802943:	6a 00                	push   $0x0
  802945:	e8 99 e6 ff ff       	call   800fe3 <sys_page_alloc>
  80294a:	89 c3                	mov    %eax,%ebx
  80294c:	83 c4 10             	add    $0x10,%esp
  80294f:	85 c0                	test   %eax,%eax
  802951:	0f 88 8c 00 00 00    	js     8029e3 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802957:	83 ec 0c             	sub    $0xc,%esp
  80295a:	ff 75 f0             	pushl  -0x10(%ebp)
  80295d:	e8 3f eb ff ff       	call   8014a1 <fd2data>
  802962:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802969:	50                   	push   %eax
  80296a:	6a 00                	push   $0x0
  80296c:	56                   	push   %esi
  80296d:	6a 00                	push   $0x0
  80296f:	e8 b2 e6 ff ff       	call   801026 <sys_page_map>
  802974:	89 c3                	mov    %eax,%ebx
  802976:	83 c4 20             	add    $0x20,%esp
  802979:	85 c0                	test   %eax,%eax
  80297b:	78 58                	js     8029d5 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802986:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80299b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8029a7:	83 ec 0c             	sub    $0xc,%esp
  8029aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8029ad:	e8 df ea ff ff       	call   801491 <fd2num>
  8029b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029b5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8029b7:	83 c4 04             	add    $0x4,%esp
  8029ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8029bd:	e8 cf ea ff ff       	call   801491 <fd2num>
  8029c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029c5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8029c8:	83 c4 10             	add    $0x10,%esp
  8029cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029d0:	e9 4f ff ff ff       	jmp    802924 <pipe+0x75>
	sys_page_unmap(0, va);
  8029d5:	83 ec 08             	sub    $0x8,%esp
  8029d8:	56                   	push   %esi
  8029d9:	6a 00                	push   $0x0
  8029db:	e8 88 e6 ff ff       	call   801068 <sys_page_unmap>
  8029e0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8029e3:	83 ec 08             	sub    $0x8,%esp
  8029e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8029e9:	6a 00                	push   $0x0
  8029eb:	e8 78 e6 ff ff       	call   801068 <sys_page_unmap>
  8029f0:	83 c4 10             	add    $0x10,%esp
  8029f3:	e9 1c ff ff ff       	jmp    802914 <pipe+0x65>

008029f8 <pipeisclosed>:
{
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
  8029fb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a01:	50                   	push   %eax
  802a02:	ff 75 08             	pushl  0x8(%ebp)
  802a05:	e8 fd ea ff ff       	call   801507 <fd_lookup>
  802a0a:	83 c4 10             	add    $0x10,%esp
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	78 18                	js     802a29 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802a11:	83 ec 0c             	sub    $0xc,%esp
  802a14:	ff 75 f4             	pushl  -0xc(%ebp)
  802a17:	e8 85 ea ff ff       	call   8014a1 <fd2data>
	return _pipeisclosed(fd, p);
  802a1c:	89 c2                	mov    %eax,%edx
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	e8 30 fd ff ff       	call   802756 <_pipeisclosed>
  802a26:	83 c4 10             	add    $0x10,%esp
}
  802a29:	c9                   	leave  
  802a2a:	c3                   	ret    

00802a2b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802a2b:	55                   	push   %ebp
  802a2c:	89 e5                	mov    %esp,%ebp
  802a2e:	56                   	push   %esi
  802a2f:	53                   	push   %ebx
  802a30:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802a33:	85 f6                	test   %esi,%esi
  802a35:	74 13                	je     802a4a <wait+0x1f>
	e = &envs[ENVX(envid)];
  802a37:	89 f3                	mov    %esi,%ebx
  802a39:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a3f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802a42:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802a48:	eb 1b                	jmp    802a65 <wait+0x3a>
	assert(envid != 0);
  802a4a:	68 e8 35 80 00       	push   $0x8035e8
  802a4f:	68 af 34 80 00       	push   $0x8034af
  802a54:	6a 09                	push   $0x9
  802a56:	68 f3 35 80 00       	push   $0x8035f3
  802a5b:	e8 90 da ff ff       	call   8004f0 <_panic>
		sys_yield();
  802a60:	e8 5f e5 ff ff       	call   800fc4 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a65:	8b 43 48             	mov    0x48(%ebx),%eax
  802a68:	39 f0                	cmp    %esi,%eax
  802a6a:	75 07                	jne    802a73 <wait+0x48>
  802a6c:	8b 43 54             	mov    0x54(%ebx),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	75 ed                	jne    802a60 <wait+0x35>
}
  802a73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a76:	5b                   	pop    %ebx
  802a77:	5e                   	pop    %esi
  802a78:	5d                   	pop    %ebp
  802a79:	c3                   	ret    

00802a7a <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
  802a7d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  802a80:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a87:	74 0a                	je     802a93 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a91:	c9                   	leave  
  802a92:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802a93:	a1 08 50 80 00       	mov    0x805008,%eax
  802a98:	8b 40 48             	mov    0x48(%eax),%eax
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	6a 07                	push   $0x7
  802aa0:	68 00 f0 bf ee       	push   $0xeebff000
  802aa5:	50                   	push   %eax
  802aa6:	e8 38 e5 ff ff       	call   800fe3 <sys_page_alloc>
  802aab:	83 c4 10             	add    $0x10,%esp
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	78 1b                	js     802acd <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802ab2:	a1 08 50 80 00       	mov    0x805008,%eax
  802ab7:	8b 40 48             	mov    0x48(%eax),%eax
  802aba:	83 ec 08             	sub    $0x8,%esp
  802abd:	68 df 2a 80 00       	push   $0x802adf
  802ac2:	50                   	push   %eax
  802ac3:	e8 66 e6 ff ff       	call   80112e <sys_env_set_pgfault_upcall>
  802ac8:	83 c4 10             	add    $0x10,%esp
  802acb:	eb bc                	jmp    802a89 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802acd:	50                   	push   %eax
  802ace:	68 fe 35 80 00       	push   $0x8035fe
  802ad3:	6a 22                	push   $0x22
  802ad5:	68 16 36 80 00       	push   $0x803616
  802ada:	e8 11 da ff ff       	call   8004f0 <_panic>

00802adf <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802adf:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ae0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802ae5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802ae7:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802aea:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  802aee:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  802af1:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802af5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802af9:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  802afb:	83 c4 08             	add    $0x8,%esp
	popal
  802afe:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802aff:	83 c4 04             	add    $0x4,%esp
	popfl
  802b02:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b03:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802b04:	c3                   	ret    

00802b05 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
  802b08:	56                   	push   %esi
  802b09:	53                   	push   %ebx
  802b0a:	8b 75 08             	mov    0x8(%ebp),%esi
  802b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802b13:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802b15:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802b1a:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802b1d:	83 ec 0c             	sub    $0xc,%esp
  802b20:	50                   	push   %eax
  802b21:	e8 6d e6 ff ff       	call   801193 <sys_ipc_recv>
	if (from_env_store)
  802b26:	83 c4 10             	add    $0x10,%esp
  802b29:	85 f6                	test   %esi,%esi
  802b2b:	74 14                	je     802b41 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b32:	85 c0                	test   %eax,%eax
  802b34:	78 09                	js     802b3f <ipc_recv+0x3a>
  802b36:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802b3c:	8b 52 74             	mov    0x74(%edx),%edx
  802b3f:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802b41:	85 db                	test   %ebx,%ebx
  802b43:	74 14                	je     802b59 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802b45:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	78 09                	js     802b57 <ipc_recv+0x52>
  802b4e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802b54:	8b 52 78             	mov    0x78(%edx),%edx
  802b57:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	78 08                	js     802b65 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802b5d:	a1 08 50 80 00       	mov    0x805008,%eax
  802b62:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b68:	5b                   	pop    %ebx
  802b69:	5e                   	pop    %esi
  802b6a:	5d                   	pop    %ebp
  802b6b:	c3                   	ret    

00802b6c <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
  802b6f:	57                   	push   %edi
  802b70:	56                   	push   %esi
  802b71:	53                   	push   %ebx
  802b72:	83 ec 0c             	sub    $0xc,%esp
  802b75:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b78:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802b7e:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802b80:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802b85:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802b88:	ff 75 14             	pushl  0x14(%ebp)
  802b8b:	53                   	push   %ebx
  802b8c:	56                   	push   %esi
  802b8d:	57                   	push   %edi
  802b8e:	e8 dd e5 ff ff       	call   801170 <sys_ipc_try_send>
		if (ret == 0)
  802b93:	83 c4 10             	add    $0x10,%esp
  802b96:	85 c0                	test   %eax,%eax
  802b98:	74 1e                	je     802bb8 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802b9a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b9d:	75 07                	jne    802ba6 <ipc_send+0x3a>
			sys_yield();
  802b9f:	e8 20 e4 ff ff       	call   800fc4 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802ba4:	eb e2                	jmp    802b88 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802ba6:	50                   	push   %eax
  802ba7:	68 24 36 80 00       	push   $0x803624
  802bac:	6a 3d                	push   $0x3d
  802bae:	68 38 36 80 00       	push   $0x803638
  802bb3:	e8 38 d9 ff ff       	call   8004f0 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bbb:	5b                   	pop    %ebx
  802bbc:	5e                   	pop    %esi
  802bbd:	5f                   	pop    %edi
  802bbe:	5d                   	pop    %ebp
  802bbf:	c3                   	ret    

00802bc0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802bc0:	55                   	push   %ebp
  802bc1:	89 e5                	mov    %esp,%ebp
  802bc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802bc6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802bcb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802bce:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802bd4:	8b 52 50             	mov    0x50(%edx),%edx
  802bd7:	39 ca                	cmp    %ecx,%edx
  802bd9:	74 11                	je     802bec <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802bdb:	83 c0 01             	add    $0x1,%eax
  802bde:	3d 00 04 00 00       	cmp    $0x400,%eax
  802be3:	75 e6                	jne    802bcb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802be5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bea:	eb 0b                	jmp    802bf7 <ipc_find_env+0x37>
			return envs[i].env_id;
  802bec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802bef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802bf4:	8b 40 48             	mov    0x48(%eax),%eax
}
  802bf7:	5d                   	pop    %ebp
  802bf8:	c3                   	ret    

00802bf9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bf9:	55                   	push   %ebp
  802bfa:	89 e5                	mov    %esp,%ebp
  802bfc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bff:	89 d0                	mov    %edx,%eax
  802c01:	c1 e8 16             	shr    $0x16,%eax
  802c04:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802c0b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802c10:	f6 c1 01             	test   $0x1,%cl
  802c13:	74 1d                	je     802c32 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802c15:	c1 ea 0c             	shr    $0xc,%edx
  802c18:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802c1f:	f6 c2 01             	test   $0x1,%dl
  802c22:	74 0e                	je     802c32 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c24:	c1 ea 0c             	shr    $0xc,%edx
  802c27:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802c2e:	ef 
  802c2f:	0f b7 c0             	movzwl %ax,%eax
}
  802c32:	5d                   	pop    %ebp
  802c33:	c3                   	ret    
  802c34:	66 90                	xchg   %ax,%ax
  802c36:	66 90                	xchg   %ax,%ax
  802c38:	66 90                	xchg   %ax,%ax
  802c3a:	66 90                	xchg   %ax,%ax
  802c3c:	66 90                	xchg   %ax,%ax
  802c3e:	66 90                	xchg   %ax,%ax

00802c40 <__udivdi3>:
  802c40:	55                   	push   %ebp
  802c41:	57                   	push   %edi
  802c42:	56                   	push   %esi
  802c43:	53                   	push   %ebx
  802c44:	83 ec 1c             	sub    $0x1c,%esp
  802c47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802c4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802c4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802c57:	85 d2                	test   %edx,%edx
  802c59:	75 35                	jne    802c90 <__udivdi3+0x50>
  802c5b:	39 f3                	cmp    %esi,%ebx
  802c5d:	0f 87 bd 00 00 00    	ja     802d20 <__udivdi3+0xe0>
  802c63:	85 db                	test   %ebx,%ebx
  802c65:	89 d9                	mov    %ebx,%ecx
  802c67:	75 0b                	jne    802c74 <__udivdi3+0x34>
  802c69:	b8 01 00 00 00       	mov    $0x1,%eax
  802c6e:	31 d2                	xor    %edx,%edx
  802c70:	f7 f3                	div    %ebx
  802c72:	89 c1                	mov    %eax,%ecx
  802c74:	31 d2                	xor    %edx,%edx
  802c76:	89 f0                	mov    %esi,%eax
  802c78:	f7 f1                	div    %ecx
  802c7a:	89 c6                	mov    %eax,%esi
  802c7c:	89 e8                	mov    %ebp,%eax
  802c7e:	89 f7                	mov    %esi,%edi
  802c80:	f7 f1                	div    %ecx
  802c82:	89 fa                	mov    %edi,%edx
  802c84:	83 c4 1c             	add    $0x1c,%esp
  802c87:	5b                   	pop    %ebx
  802c88:	5e                   	pop    %esi
  802c89:	5f                   	pop    %edi
  802c8a:	5d                   	pop    %ebp
  802c8b:	c3                   	ret    
  802c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c90:	39 f2                	cmp    %esi,%edx
  802c92:	77 7c                	ja     802d10 <__udivdi3+0xd0>
  802c94:	0f bd fa             	bsr    %edx,%edi
  802c97:	83 f7 1f             	xor    $0x1f,%edi
  802c9a:	0f 84 98 00 00 00    	je     802d38 <__udivdi3+0xf8>
  802ca0:	89 f9                	mov    %edi,%ecx
  802ca2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ca7:	29 f8                	sub    %edi,%eax
  802ca9:	d3 e2                	shl    %cl,%edx
  802cab:	89 54 24 08          	mov    %edx,0x8(%esp)
  802caf:	89 c1                	mov    %eax,%ecx
  802cb1:	89 da                	mov    %ebx,%edx
  802cb3:	d3 ea                	shr    %cl,%edx
  802cb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cb9:	09 d1                	or     %edx,%ecx
  802cbb:	89 f2                	mov    %esi,%edx
  802cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cc1:	89 f9                	mov    %edi,%ecx
  802cc3:	d3 e3                	shl    %cl,%ebx
  802cc5:	89 c1                	mov    %eax,%ecx
  802cc7:	d3 ea                	shr    %cl,%edx
  802cc9:	89 f9                	mov    %edi,%ecx
  802ccb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802ccf:	d3 e6                	shl    %cl,%esi
  802cd1:	89 eb                	mov    %ebp,%ebx
  802cd3:	89 c1                	mov    %eax,%ecx
  802cd5:	d3 eb                	shr    %cl,%ebx
  802cd7:	09 de                	or     %ebx,%esi
  802cd9:	89 f0                	mov    %esi,%eax
  802cdb:	f7 74 24 08          	divl   0x8(%esp)
  802cdf:	89 d6                	mov    %edx,%esi
  802ce1:	89 c3                	mov    %eax,%ebx
  802ce3:	f7 64 24 0c          	mull   0xc(%esp)
  802ce7:	39 d6                	cmp    %edx,%esi
  802ce9:	72 0c                	jb     802cf7 <__udivdi3+0xb7>
  802ceb:	89 f9                	mov    %edi,%ecx
  802ced:	d3 e5                	shl    %cl,%ebp
  802cef:	39 c5                	cmp    %eax,%ebp
  802cf1:	73 5d                	jae    802d50 <__udivdi3+0x110>
  802cf3:	39 d6                	cmp    %edx,%esi
  802cf5:	75 59                	jne    802d50 <__udivdi3+0x110>
  802cf7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802cfa:	31 ff                	xor    %edi,%edi
  802cfc:	89 fa                	mov    %edi,%edx
  802cfe:	83 c4 1c             	add    $0x1c,%esp
  802d01:	5b                   	pop    %ebx
  802d02:	5e                   	pop    %esi
  802d03:	5f                   	pop    %edi
  802d04:	5d                   	pop    %ebp
  802d05:	c3                   	ret    
  802d06:	8d 76 00             	lea    0x0(%esi),%esi
  802d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802d10:	31 ff                	xor    %edi,%edi
  802d12:	31 c0                	xor    %eax,%eax
  802d14:	89 fa                	mov    %edi,%edx
  802d16:	83 c4 1c             	add    $0x1c,%esp
  802d19:	5b                   	pop    %ebx
  802d1a:	5e                   	pop    %esi
  802d1b:	5f                   	pop    %edi
  802d1c:	5d                   	pop    %ebp
  802d1d:	c3                   	ret    
  802d1e:	66 90                	xchg   %ax,%ax
  802d20:	31 ff                	xor    %edi,%edi
  802d22:	89 e8                	mov    %ebp,%eax
  802d24:	89 f2                	mov    %esi,%edx
  802d26:	f7 f3                	div    %ebx
  802d28:	89 fa                	mov    %edi,%edx
  802d2a:	83 c4 1c             	add    $0x1c,%esp
  802d2d:	5b                   	pop    %ebx
  802d2e:	5e                   	pop    %esi
  802d2f:	5f                   	pop    %edi
  802d30:	5d                   	pop    %ebp
  802d31:	c3                   	ret    
  802d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d38:	39 f2                	cmp    %esi,%edx
  802d3a:	72 06                	jb     802d42 <__udivdi3+0x102>
  802d3c:	31 c0                	xor    %eax,%eax
  802d3e:	39 eb                	cmp    %ebp,%ebx
  802d40:	77 d2                	ja     802d14 <__udivdi3+0xd4>
  802d42:	b8 01 00 00 00       	mov    $0x1,%eax
  802d47:	eb cb                	jmp    802d14 <__udivdi3+0xd4>
  802d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d50:	89 d8                	mov    %ebx,%eax
  802d52:	31 ff                	xor    %edi,%edi
  802d54:	eb be                	jmp    802d14 <__udivdi3+0xd4>
  802d56:	66 90                	xchg   %ax,%ax
  802d58:	66 90                	xchg   %ax,%ax
  802d5a:	66 90                	xchg   %ax,%ax
  802d5c:	66 90                	xchg   %ax,%ax
  802d5e:	66 90                	xchg   %ax,%ax

00802d60 <__umoddi3>:
  802d60:	55                   	push   %ebp
  802d61:	57                   	push   %edi
  802d62:	56                   	push   %esi
  802d63:	53                   	push   %ebx
  802d64:	83 ec 1c             	sub    $0x1c,%esp
  802d67:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  802d6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  802d6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d77:	85 ed                	test   %ebp,%ebp
  802d79:	89 f0                	mov    %esi,%eax
  802d7b:	89 da                	mov    %ebx,%edx
  802d7d:	75 19                	jne    802d98 <__umoddi3+0x38>
  802d7f:	39 df                	cmp    %ebx,%edi
  802d81:	0f 86 b1 00 00 00    	jbe    802e38 <__umoddi3+0xd8>
  802d87:	f7 f7                	div    %edi
  802d89:	89 d0                	mov    %edx,%eax
  802d8b:	31 d2                	xor    %edx,%edx
  802d8d:	83 c4 1c             	add    $0x1c,%esp
  802d90:	5b                   	pop    %ebx
  802d91:	5e                   	pop    %esi
  802d92:	5f                   	pop    %edi
  802d93:	5d                   	pop    %ebp
  802d94:	c3                   	ret    
  802d95:	8d 76 00             	lea    0x0(%esi),%esi
  802d98:	39 dd                	cmp    %ebx,%ebp
  802d9a:	77 f1                	ja     802d8d <__umoddi3+0x2d>
  802d9c:	0f bd cd             	bsr    %ebp,%ecx
  802d9f:	83 f1 1f             	xor    $0x1f,%ecx
  802da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802da6:	0f 84 b4 00 00 00    	je     802e60 <__umoddi3+0x100>
  802dac:	b8 20 00 00 00       	mov    $0x20,%eax
  802db1:	89 c2                	mov    %eax,%edx
  802db3:	8b 44 24 04          	mov    0x4(%esp),%eax
  802db7:	29 c2                	sub    %eax,%edx
  802db9:	89 c1                	mov    %eax,%ecx
  802dbb:	89 f8                	mov    %edi,%eax
  802dbd:	d3 e5                	shl    %cl,%ebp
  802dbf:	89 d1                	mov    %edx,%ecx
  802dc1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802dc5:	d3 e8                	shr    %cl,%eax
  802dc7:	09 c5                	or     %eax,%ebp
  802dc9:	8b 44 24 04          	mov    0x4(%esp),%eax
  802dcd:	89 c1                	mov    %eax,%ecx
  802dcf:	d3 e7                	shl    %cl,%edi
  802dd1:	89 d1                	mov    %edx,%ecx
  802dd3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802dd7:	89 df                	mov    %ebx,%edi
  802dd9:	d3 ef                	shr    %cl,%edi
  802ddb:	89 c1                	mov    %eax,%ecx
  802ddd:	89 f0                	mov    %esi,%eax
  802ddf:	d3 e3                	shl    %cl,%ebx
  802de1:	89 d1                	mov    %edx,%ecx
  802de3:	89 fa                	mov    %edi,%edx
  802de5:	d3 e8                	shr    %cl,%eax
  802de7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802dec:	09 d8                	or     %ebx,%eax
  802dee:	f7 f5                	div    %ebp
  802df0:	d3 e6                	shl    %cl,%esi
  802df2:	89 d1                	mov    %edx,%ecx
  802df4:	f7 64 24 08          	mull   0x8(%esp)
  802df8:	39 d1                	cmp    %edx,%ecx
  802dfa:	89 c3                	mov    %eax,%ebx
  802dfc:	89 d7                	mov    %edx,%edi
  802dfe:	72 06                	jb     802e06 <__umoddi3+0xa6>
  802e00:	75 0e                	jne    802e10 <__umoddi3+0xb0>
  802e02:	39 c6                	cmp    %eax,%esi
  802e04:	73 0a                	jae    802e10 <__umoddi3+0xb0>
  802e06:	2b 44 24 08          	sub    0x8(%esp),%eax
  802e0a:	19 ea                	sbb    %ebp,%edx
  802e0c:	89 d7                	mov    %edx,%edi
  802e0e:	89 c3                	mov    %eax,%ebx
  802e10:	89 ca                	mov    %ecx,%edx
  802e12:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802e17:	29 de                	sub    %ebx,%esi
  802e19:	19 fa                	sbb    %edi,%edx
  802e1b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802e1f:	89 d0                	mov    %edx,%eax
  802e21:	d3 e0                	shl    %cl,%eax
  802e23:	89 d9                	mov    %ebx,%ecx
  802e25:	d3 ee                	shr    %cl,%esi
  802e27:	d3 ea                	shr    %cl,%edx
  802e29:	09 f0                	or     %esi,%eax
  802e2b:	83 c4 1c             	add    $0x1c,%esp
  802e2e:	5b                   	pop    %ebx
  802e2f:	5e                   	pop    %esi
  802e30:	5f                   	pop    %edi
  802e31:	5d                   	pop    %ebp
  802e32:	c3                   	ret    
  802e33:	90                   	nop
  802e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e38:	85 ff                	test   %edi,%edi
  802e3a:	89 f9                	mov    %edi,%ecx
  802e3c:	75 0b                	jne    802e49 <__umoddi3+0xe9>
  802e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e43:	31 d2                	xor    %edx,%edx
  802e45:	f7 f7                	div    %edi
  802e47:	89 c1                	mov    %eax,%ecx
  802e49:	89 d8                	mov    %ebx,%eax
  802e4b:	31 d2                	xor    %edx,%edx
  802e4d:	f7 f1                	div    %ecx
  802e4f:	89 f0                	mov    %esi,%eax
  802e51:	f7 f1                	div    %ecx
  802e53:	e9 31 ff ff ff       	jmp    802d89 <__umoddi3+0x29>
  802e58:	90                   	nop
  802e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e60:	39 dd                	cmp    %ebx,%ebp
  802e62:	72 08                	jb     802e6c <__umoddi3+0x10c>
  802e64:	39 f7                	cmp    %esi,%edi
  802e66:	0f 87 21 ff ff ff    	ja     802d8d <__umoddi3+0x2d>
  802e6c:	89 da                	mov    %ebx,%edx
  802e6e:	89 f0                	mov    %esi,%eax
  802e70:	29 f8                	sub    %edi,%eax
  802e72:	19 ea                	sbb    %ebp,%edx
  802e74:	e9 14 ff ff ff       	jmp    802d8d <__umoddi3+0x2d>

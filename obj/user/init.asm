
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 6f 03 00 00       	call   8003a0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	eb 0c                	jmp    800056 <sum+0x23>
		tot ^= i * s[i];
  80004a:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80004e:	0f af ca             	imul   %edx,%ecx
  800051:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800053:	83 c2 01             	add    $0x1,%edx
  800056:	39 da                	cmp    %ebx,%edx
  800058:	7c f0                	jl     80004a <sum+0x17>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 60 2a 80 00       	push   $0x802a60
  800072:	e8 64 04 00 00       	call   8004db <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 40 80 00       	push   $0x804000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 28 2b 80 00       	push   $0x802b28
  8000a5:	e8 31 04 00 00       	call   8004db <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 60 80 00       	push   $0x806020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 64 2b 80 00       	push   $0x802b64
  8000cf:	e8 07 04 00 00       	call   8004db <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 9c 2a 80 00       	push   $0x802a9c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 2f 0a 00 00       	call   800b1a <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 a8 2a 80 00       	push   $0x802aa8
  800105:	56                   	push   %esi
  800106:	e8 0f 0a 00 00       	call   800b1a <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 00 0a 00 00       	call   800b1a <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 a9 2a 80 00       	push   $0x802aa9
  800122:	56                   	push   %esi
  800123:	e8 f2 09 00 00       	call   800b1a <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 6f 2a 80 00       	push   $0x802a6f
  800138:	e8 9e 03 00 00       	call   8004db <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 86 2a 80 00       	push   $0x802a86
  80014d:	e8 89 03 00 00       	call   8004db <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 ab 2a 80 00       	push   $0x802aab
  800166:	e8 70 03 00 00       	call   8004db <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 af 2a 80 00 	movl   $0x802aaf,(%esp)
  800172:	e8 64 03 00 00       	call   8004db <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 2b 11 00 00       	call   8012ae <close>
	if ((r = opencons()) < 0)
  800183:	e8 c6 01 00 00       	call   80034e <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 16                	js     8001a5 <umain+0x147>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	85 c0                	test   %eax,%eax
  800191:	74 24                	je     8001b7 <umain+0x159>
		panic("first opencons used fd %d", r);
  800193:	50                   	push   %eax
  800194:	68 da 2a 80 00       	push   $0x802ada
  800199:	6a 39                	push   $0x39
  80019b:	68 ce 2a 80 00       	push   $0x802ace
  8001a0:	e8 5b 02 00 00       	call   800400 <_panic>
		panic("opencons: %e", r);
  8001a5:	50                   	push   %eax
  8001a6:	68 c1 2a 80 00       	push   $0x802ac1
  8001ab:	6a 37                	push   $0x37
  8001ad:	68 ce 2a 80 00       	push   $0x802ace
  8001b2:	e8 49 02 00 00       	call   800400 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	6a 01                	push   $0x1
  8001bc:	6a 00                	push   $0x0
  8001be:	e8 3b 11 00 00       	call   8012fe <dup>
  8001c3:	83 c4 10             	add    $0x10,%esp
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	79 23                	jns    8001ed <umain+0x18f>
		panic("dup: %e", r);
  8001ca:	50                   	push   %eax
  8001cb:	68 f4 2a 80 00       	push   $0x802af4
  8001d0:	6a 3b                	push   $0x3b
  8001d2:	68 ce 2a 80 00       	push   $0x802ace
  8001d7:	e8 24 02 00 00       	call   800400 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	68 13 2b 80 00       	push   $0x802b13
  8001e5:	e8 f1 02 00 00       	call   8004db <cprintf>
			continue;
  8001ea:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	68 fc 2a 80 00       	push   $0x802afc
  8001f5:	e8 e1 02 00 00       	call   8004db <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001fa:	83 c4 0c             	add    $0xc,%esp
  8001fd:	6a 00                	push   $0x0
  8001ff:	68 10 2b 80 00       	push   $0x802b10
  800204:	68 0f 2b 80 00       	push   $0x802b0f
  800209:	e8 60 1c 00 00       	call   801e6e <spawnl>
		if (r < 0) {
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	85 c0                	test   %eax,%eax
  800213:	78 c7                	js     8001dc <umain+0x17e>
		}
		wait(r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	e8 7f 24 00 00       	call   80269d <wait>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	eb ca                	jmp    8001ed <umain+0x18f>

00800223 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    

0080022d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800233:	68 93 2b 80 00       	push   $0x802b93
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	e8 ba 08 00 00       	call   800afa <strcpy>
	return 0;
}
  800240:	b8 00 00 00 00       	mov    $0x0,%eax
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <devcons_write>:
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800253:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800258:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80025e:	eb 2f                	jmp    80028f <devcons_write+0x48>
		m = n - tot;
  800260:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800263:	29 f3                	sub    %esi,%ebx
  800265:	83 fb 7f             	cmp    $0x7f,%ebx
  800268:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	53                   	push   %ebx
  800274:	89 f0                	mov    %esi,%eax
  800276:	03 45 0c             	add    0xc(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	57                   	push   %edi
  80027b:	e8 08 0a 00 00       	call   800c88 <memmove>
		sys_cputs(buf, m);
  800280:	83 c4 08             	add    $0x8,%esp
  800283:	53                   	push   %ebx
  800284:	57                   	push   %edi
  800285:	e8 ad 0b 00 00       	call   800e37 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80028a:	01 de                	add    %ebx,%esi
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800292:	72 cc                	jb     800260 <devcons_write+0x19>
}
  800294:	89 f0                	mov    %esi,%eax
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <devcons_read>:
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002ad:	75 07                	jne    8002b6 <devcons_read+0x18>
}
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    
		sys_yield();
  8002b1:	e8 1e 0c 00 00       	call   800ed4 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8002b6:	e8 9a 0b 00 00       	call   800e55 <sys_cgetc>
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	74 f2                	je     8002b1 <devcons_read+0x13>
	if (c < 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	78 ec                	js     8002af <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8002c3:	83 f8 04             	cmp    $0x4,%eax
  8002c6:	74 0c                	je     8002d4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8002c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cb:	88 02                	mov    %al,(%edx)
	return 1;
  8002cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8002d2:	eb db                	jmp    8002af <devcons_read+0x11>
		return 0;
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	eb d4                	jmp    8002af <devcons_read+0x11>

008002db <cputchar>:
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002e7:	6a 01                	push   $0x1
  8002e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002ec:	50                   	push   %eax
  8002ed:	e8 45 0b 00 00       	call   800e37 <sys_cputs>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <getchar>:
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002fd:	6a 01                	push   $0x1
  8002ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	6a 00                	push   $0x0
  800305:	e8 e0 10 00 00       	call   8013ea <read>
	if (r < 0)
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	85 c0                	test   %eax,%eax
  80030f:	78 08                	js     800319 <getchar+0x22>
	if (r < 1)
  800311:	85 c0                	test   %eax,%eax
  800313:	7e 06                	jle    80031b <getchar+0x24>
	return c;
  800315:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    
		return -E_EOF;
  80031b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800320:	eb f7                	jmp    800319 <getchar+0x22>

00800322 <iscons>:
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800328:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80032b:	50                   	push   %eax
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 45 0e 00 00       	call   801179 <fd_lookup>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	85 c0                	test   %eax,%eax
  800339:	78 11                	js     80034c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80033b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80033e:	8b 15 70 57 80 00    	mov    0x805770,%edx
  800344:	39 10                	cmp    %edx,(%eax)
  800346:	0f 94 c0             	sete   %al
  800349:	0f b6 c0             	movzbl %al,%eax
}
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <opencons>:
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800354:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	e8 cd 0d 00 00       	call   80112a <fd_alloc>
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	85 c0                	test   %eax,%eax
  800362:	78 3a                	js     80039e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	68 07 04 00 00       	push   $0x407
  80036c:	ff 75 f4             	pushl  -0xc(%ebp)
  80036f:	6a 00                	push   $0x0
  800371:	e8 7d 0b 00 00       	call   800ef3 <sys_page_alloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	85 c0                	test   %eax,%eax
  80037b:	78 21                	js     80039e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80037d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800380:	8b 15 70 57 80 00    	mov    0x805770,%edx
  800386:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	50                   	push   %eax
  800396:	e8 68 0d 00 00       	call   801103 <fd2num>
  80039b:	83 c4 10             	add    $0x10,%esp
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003ab:	e8 05 0b 00 00       	call   800eb5 <sys_getenvid>
  8003b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003bd:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c2:	85 db                	test   %ebx,%ebx
  8003c4:	7e 07                	jle    8003cd <libmain+0x2d>
		binaryname = argv[0];
  8003c6:	8b 06                	mov    (%esi),%eax
  8003c8:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
  8003d2:	e8 87 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003d7:	e8 0a 00 00 00       	call   8003e6 <exit>
}
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003e2:	5b                   	pop    %ebx
  8003e3:	5e                   	pop    %esi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8003ec:	e8 e8 0e 00 00       	call   8012d9 <close_all>
	sys_env_destroy(0);
  8003f1:	83 ec 0c             	sub    $0xc,%esp
  8003f4:	6a 00                	push   $0x0
  8003f6:	e8 79 0a 00 00       	call   800e74 <sys_env_destroy>
}
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	56                   	push   %esi
  800404:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800405:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800408:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  80040e:	e8 a2 0a 00 00       	call   800eb5 <sys_getenvid>
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	56                   	push   %esi
  80041d:	50                   	push   %eax
  80041e:	68 ac 2b 80 00       	push   $0x802bac
  800423:	e8 b3 00 00 00       	call   8004db <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800428:	83 c4 18             	add    $0x18,%esp
  80042b:	53                   	push   %ebx
  80042c:	ff 75 10             	pushl  0x10(%ebp)
  80042f:	e8 56 00 00 00       	call   80048a <vcprintf>
	cprintf("\n");
  800434:	c7 04 24 d5 30 80 00 	movl   $0x8030d5,(%esp)
  80043b:	e8 9b 00 00 00       	call   8004db <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800443:	cc                   	int3   
  800444:	eb fd                	jmp    800443 <_panic+0x43>

00800446 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	53                   	push   %ebx
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800450:	8b 13                	mov    (%ebx),%edx
  800452:	8d 42 01             	lea    0x1(%edx),%eax
  800455:	89 03                	mov    %eax,(%ebx)
  800457:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80045e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800463:	74 09                	je     80046e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800465:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	68 ff 00 00 00       	push   $0xff
  800476:	8d 43 08             	lea    0x8(%ebx),%eax
  800479:	50                   	push   %eax
  80047a:	e8 b8 09 00 00       	call   800e37 <sys_cputs>
		b->idx = 0;
  80047f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	eb db                	jmp    800465 <putch+0x1f>

0080048a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800493:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80049a:	00 00 00 
	b.cnt = 0;
  80049d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a7:	ff 75 0c             	pushl  0xc(%ebp)
  8004aa:	ff 75 08             	pushl  0x8(%ebp)
  8004ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	68 46 04 80 00       	push   $0x800446
  8004b9:	e8 1a 01 00 00       	call   8005d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004be:	83 c4 08             	add    $0x8,%esp
  8004c1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 64 09 00 00       	call   800e37 <sys_cputs>

	return b.cnt;
}
  8004d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004e1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004e4:	50                   	push   %eax
  8004e5:	ff 75 08             	pushl  0x8(%ebp)
  8004e8:	e8 9d ff ff ff       	call   80048a <vcprintf>
	va_end(ap);

	return cnt;
}
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	57                   	push   %edi
  8004f3:	56                   	push   %esi
  8004f4:	53                   	push   %ebx
  8004f5:	83 ec 1c             	sub    $0x1c,%esp
  8004f8:	89 c7                	mov    %eax,%edi
  8004fa:	89 d6                	mov    %edx,%esi
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80050b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800510:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800513:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800516:	39 d3                	cmp    %edx,%ebx
  800518:	72 05                	jb     80051f <printnum+0x30>
  80051a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80051d:	77 7a                	ja     800599 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	ff 75 18             	pushl  0x18(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80052b:	53                   	push   %ebx
  80052c:	ff 75 10             	pushl  0x10(%ebp)
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 e4             	pushl  -0x1c(%ebp)
  800535:	ff 75 e0             	pushl  -0x20(%ebp)
  800538:	ff 75 dc             	pushl  -0x24(%ebp)
  80053b:	ff 75 d8             	pushl  -0x28(%ebp)
  80053e:	e8 dd 22 00 00       	call   802820 <__udivdi3>
  800543:	83 c4 18             	add    $0x18,%esp
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	89 f2                	mov    %esi,%edx
  80054a:	89 f8                	mov    %edi,%eax
  80054c:	e8 9e ff ff ff       	call   8004ef <printnum>
  800551:	83 c4 20             	add    $0x20,%esp
  800554:	eb 13                	jmp    800569 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	56                   	push   %esi
  80055a:	ff 75 18             	pushl  0x18(%ebp)
  80055d:	ff d7                	call   *%edi
  80055f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800562:	83 eb 01             	sub    $0x1,%ebx
  800565:	85 db                	test   %ebx,%ebx
  800567:	7f ed                	jg     800556 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	56                   	push   %esi
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	ff 75 e4             	pushl  -0x1c(%ebp)
  800573:	ff 75 e0             	pushl  -0x20(%ebp)
  800576:	ff 75 dc             	pushl  -0x24(%ebp)
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	e8 bf 23 00 00       	call   802940 <__umoddi3>
  800581:	83 c4 14             	add    $0x14,%esp
  800584:	0f be 80 cf 2b 80 00 	movsbl 0x802bcf(%eax),%eax
  80058b:	50                   	push   %eax
  80058c:	ff d7                	call   *%edi
}
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800594:	5b                   	pop    %ebx
  800595:	5e                   	pop    %esi
  800596:	5f                   	pop    %edi
  800597:	5d                   	pop    %ebp
  800598:	c3                   	ret    
  800599:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80059c:	eb c4                	jmp    800562 <printnum+0x73>

0080059e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005a4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005a8:	8b 10                	mov    (%eax),%edx
  8005aa:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ad:	73 0a                	jae    8005b9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005b2:	89 08                	mov    %ecx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	88 02                	mov    %al,(%edx)
}
  8005b9:	5d                   	pop    %ebp
  8005ba:	c3                   	ret    

008005bb <printfmt>:
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005c1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005c4:	50                   	push   %eax
  8005c5:	ff 75 10             	pushl  0x10(%ebp)
  8005c8:	ff 75 0c             	pushl  0xc(%ebp)
  8005cb:	ff 75 08             	pushl  0x8(%ebp)
  8005ce:	e8 05 00 00 00       	call   8005d8 <vprintfmt>
}
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	c9                   	leave  
  8005d7:	c3                   	ret    

008005d8 <vprintfmt>:
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
  8005db:	57                   	push   %edi
  8005dc:	56                   	push   %esi
  8005dd:	53                   	push   %ebx
  8005de:	83 ec 2c             	sub    $0x2c,%esp
  8005e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ea:	e9 c1 03 00 00       	jmp    8009b0 <vprintfmt+0x3d8>
		padc = ' ';
  8005ef:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8005f3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8005fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800601:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800608:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8d 47 01             	lea    0x1(%edi),%eax
  800610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800613:	0f b6 17             	movzbl (%edi),%edx
  800616:	8d 42 dd             	lea    -0x23(%edx),%eax
  800619:	3c 55                	cmp    $0x55,%al
  80061b:	0f 87 12 04 00 00    	ja     800a33 <vprintfmt+0x45b>
  800621:	0f b6 c0             	movzbl %al,%eax
  800624:	ff 24 85 20 2d 80 00 	jmp    *0x802d20(,%eax,4)
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80062e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800632:	eb d9                	jmp    80060d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800634:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800637:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80063b:	eb d0                	jmp    80060d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80063d:	0f b6 d2             	movzbl %dl,%edx
  800640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800643:	b8 00 00 00 00       	mov    $0x0,%eax
  800648:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80064b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80064e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800652:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800655:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800658:	83 f9 09             	cmp    $0x9,%ecx
  80065b:	77 55                	ja     8006b2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80065d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800660:	eb e9                	jmp    80064b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 04             	lea    0x4(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	79 91                	jns    80060d <vprintfmt+0x35>
				width = precision, precision = -1;
  80067c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800682:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800689:	eb 82                	jmp    80060d <vprintfmt+0x35>
  80068b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068e:	85 c0                	test   %eax,%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	0f 49 d0             	cmovns %eax,%edx
  800698:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80069e:	e9 6a ff ff ff       	jmp    80060d <vprintfmt+0x35>
  8006a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006a6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006ad:	e9 5b ff ff ff       	jmp    80060d <vprintfmt+0x35>
  8006b2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b8:	eb bc                	jmp    800676 <vprintfmt+0x9e>
			lflag++;
  8006ba:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006c0:	e9 48 ff ff ff       	jmp    80060d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 78 04             	lea    0x4(%eax),%edi
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	ff 30                	pushl  (%eax)
  8006d1:	ff d6                	call   *%esi
			break;
  8006d3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006d6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006d9:	e9 cf 02 00 00       	jmp    8009ad <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 78 04             	lea    0x4(%eax),%edi
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
  8006e7:	31 d0                	xor    %edx,%eax
  8006e9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006eb:	83 f8 0f             	cmp    $0xf,%eax
  8006ee:	7f 23                	jg     800713 <vprintfmt+0x13b>
  8006f0:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	74 18                	je     800713 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8006fb:	52                   	push   %edx
  8006fc:	68 b5 2f 80 00       	push   $0x802fb5
  800701:	53                   	push   %ebx
  800702:	56                   	push   %esi
  800703:	e8 b3 fe ff ff       	call   8005bb <printfmt>
  800708:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80070b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80070e:	e9 9a 02 00 00       	jmp    8009ad <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800713:	50                   	push   %eax
  800714:	68 e7 2b 80 00       	push   $0x802be7
  800719:	53                   	push   %ebx
  80071a:	56                   	push   %esi
  80071b:	e8 9b fe ff ff       	call   8005bb <printfmt>
  800720:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800723:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800726:	e9 82 02 00 00       	jmp    8009ad <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	83 c0 04             	add    $0x4,%eax
  800731:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800739:	85 ff                	test   %edi,%edi
  80073b:	b8 e0 2b 80 00       	mov    $0x802be0,%eax
  800740:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800743:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800747:	0f 8e bd 00 00 00    	jle    80080a <vprintfmt+0x232>
  80074d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800751:	75 0e                	jne    800761 <vprintfmt+0x189>
  800753:	89 75 08             	mov    %esi,0x8(%ebp)
  800756:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800759:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80075c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80075f:	eb 6d                	jmp    8007ce <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 d0             	pushl  -0x30(%ebp)
  800767:	57                   	push   %edi
  800768:	e8 6e 03 00 00       	call   800adb <strnlen>
  80076d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800770:	29 c1                	sub    %eax,%ecx
  800772:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800775:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800778:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80077c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800782:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800784:	eb 0f                	jmp    800795 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	ff 75 e0             	pushl  -0x20(%ebp)
  80078d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80078f:	83 ef 01             	sub    $0x1,%edi
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	85 ff                	test   %edi,%edi
  800797:	7f ed                	jg     800786 <vprintfmt+0x1ae>
  800799:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80079c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80079f:	85 c9                	test   %ecx,%ecx
  8007a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a6:	0f 49 c1             	cmovns %ecx,%eax
  8007a9:	29 c1                	sub    %eax,%ecx
  8007ab:	89 75 08             	mov    %esi,0x8(%ebp)
  8007ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8007b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8007b4:	89 cb                	mov    %ecx,%ebx
  8007b6:	eb 16                	jmp    8007ce <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007bc:	75 31                	jne    8007ef <vprintfmt+0x217>
					putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	ff 55 08             	call   *0x8(%ebp)
  8007c8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007cb:	83 eb 01             	sub    $0x1,%ebx
  8007ce:	83 c7 01             	add    $0x1,%edi
  8007d1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8007d5:	0f be c2             	movsbl %dl,%eax
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	74 59                	je     800835 <vprintfmt+0x25d>
  8007dc:	85 f6                	test   %esi,%esi
  8007de:	78 d8                	js     8007b8 <vprintfmt+0x1e0>
  8007e0:	83 ee 01             	sub    $0x1,%esi
  8007e3:	79 d3                	jns    8007b8 <vprintfmt+0x1e0>
  8007e5:	89 df                	mov    %ebx,%edi
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007ed:	eb 37                	jmp    800826 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ef:	0f be d2             	movsbl %dl,%edx
  8007f2:	83 ea 20             	sub    $0x20,%edx
  8007f5:	83 fa 5e             	cmp    $0x5e,%edx
  8007f8:	76 c4                	jbe    8007be <vprintfmt+0x1e6>
					putch('?', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	6a 3f                	push   $0x3f
  800802:	ff 55 08             	call   *0x8(%ebp)
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	eb c1                	jmp    8007cb <vprintfmt+0x1f3>
  80080a:	89 75 08             	mov    %esi,0x8(%ebp)
  80080d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800810:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800813:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800816:	eb b6                	jmp    8007ce <vprintfmt+0x1f6>
				putch(' ', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 20                	push   $0x20
  80081e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800820:	83 ef 01             	sub    $0x1,%edi
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	85 ff                	test   %edi,%edi
  800828:	7f ee                	jg     800818 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80082a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	e9 78 01 00 00       	jmp    8009ad <vprintfmt+0x3d5>
  800835:	89 df                	mov    %ebx,%edi
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80083d:	eb e7                	jmp    800826 <vprintfmt+0x24e>
	if (lflag >= 2)
  80083f:	83 f9 01             	cmp    $0x1,%ecx
  800842:	7e 3f                	jle    800883 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8d 40 08             	lea    0x8(%eax),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80085b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80085f:	79 5c                	jns    8008bd <vprintfmt+0x2e5>
				putch('-', putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	53                   	push   %ebx
  800865:	6a 2d                	push   $0x2d
  800867:	ff d6                	call   *%esi
				num = -(long long) num;
  800869:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80086c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80086f:	f7 da                	neg    %edx
  800871:	83 d1 00             	adc    $0x0,%ecx
  800874:	f7 d9                	neg    %ecx
  800876:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800879:	b8 0a 00 00 00       	mov    $0xa,%eax
  80087e:	e9 10 01 00 00       	jmp    800993 <vprintfmt+0x3bb>
	else if (lflag)
  800883:	85 c9                	test   %ecx,%ecx
  800885:	75 1b                	jne    8008a2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088f:	89 c1                	mov    %eax,%ecx
  800891:	c1 f9 1f             	sar    $0x1f,%ecx
  800894:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 40 04             	lea    0x4(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	eb b9                	jmp    80085b <vprintfmt+0x283>
		return va_arg(*ap, long);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 c1                	mov    %eax,%ecx
  8008ac:	c1 f9 1f             	sar    $0x1f,%ecx
  8008af:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 04             	lea    0x4(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bb:	eb 9e                	jmp    80085b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8008bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8008c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c8:	e9 c6 00 00 00       	jmp    800993 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8008cd:	83 f9 01             	cmp    $0x1,%ecx
  8008d0:	7e 18                	jle    8008ea <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	8b 48 04             	mov    0x4(%eax),%ecx
  8008da:	8d 40 08             	lea    0x8(%eax),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e5:	e9 a9 00 00 00       	jmp    800993 <vprintfmt+0x3bb>
	else if (lflag)
  8008ea:	85 c9                	test   %ecx,%ecx
  8008ec:	75 1a                	jne    800908 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	8b 10                	mov    (%eax),%edx
  8008f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008f8:	8d 40 04             	lea    0x4(%eax),%eax
  8008fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800903:	e9 8b 00 00 00       	jmp    800993 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	8b 10                	mov    (%eax),%edx
  80090d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800912:	8d 40 04             	lea    0x4(%eax),%eax
  800915:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800918:	b8 0a 00 00 00       	mov    $0xa,%eax
  80091d:	eb 74                	jmp    800993 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80091f:	83 f9 01             	cmp    $0x1,%ecx
  800922:	7e 15                	jle    800939 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 48 04             	mov    0x4(%eax),%ecx
  80092c:	8d 40 08             	lea    0x8(%eax),%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800932:	b8 08 00 00 00       	mov    $0x8,%eax
  800937:	eb 5a                	jmp    800993 <vprintfmt+0x3bb>
	else if (lflag)
  800939:	85 c9                	test   %ecx,%ecx
  80093b:	75 17                	jne    800954 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 10                	mov    (%eax),%edx
  800942:	b9 00 00 00 00       	mov    $0x0,%ecx
  800947:	8d 40 04             	lea    0x4(%eax),%eax
  80094a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80094d:	b8 08 00 00 00       	mov    $0x8,%eax
  800952:	eb 3f                	jmp    800993 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	8b 10                	mov    (%eax),%edx
  800959:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095e:	8d 40 04             	lea    0x4(%eax),%eax
  800961:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800964:	b8 08 00 00 00       	mov    $0x8,%eax
  800969:	eb 28                	jmp    800993 <vprintfmt+0x3bb>
			putch('0', putdat);
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	53                   	push   %ebx
  80096f:	6a 30                	push   $0x30
  800971:	ff d6                	call   *%esi
			putch('x', putdat);
  800973:	83 c4 08             	add    $0x8,%esp
  800976:	53                   	push   %ebx
  800977:	6a 78                	push   $0x78
  800979:	ff d6                	call   *%esi
			num = (unsigned long long)
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8b 10                	mov    (%eax),%edx
  800980:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800985:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800988:	8d 40 04             	lea    0x4(%eax),%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80098e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800993:	83 ec 0c             	sub    $0xc,%esp
  800996:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80099a:	57                   	push   %edi
  80099b:	ff 75 e0             	pushl  -0x20(%ebp)
  80099e:	50                   	push   %eax
  80099f:	51                   	push   %ecx
  8009a0:	52                   	push   %edx
  8009a1:	89 da                	mov    %ebx,%edx
  8009a3:	89 f0                	mov    %esi,%eax
  8009a5:	e8 45 fb ff ff       	call   8004ef <printnum>
			break;
  8009aa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8009ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b0:	83 c7 01             	add    $0x1,%edi
  8009b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009b7:	83 f8 25             	cmp    $0x25,%eax
  8009ba:	0f 84 2f fc ff ff    	je     8005ef <vprintfmt+0x17>
			if (ch == '\0')
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	0f 84 8b 00 00 00    	je     800a53 <vprintfmt+0x47b>
			putch(ch, putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	53                   	push   %ebx
  8009cc:	50                   	push   %eax
  8009cd:	ff d6                	call   *%esi
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	eb dc                	jmp    8009b0 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8009d4:	83 f9 01             	cmp    $0x1,%ecx
  8009d7:	7e 15                	jle    8009ee <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	8b 10                	mov    (%eax),%edx
  8009de:	8b 48 04             	mov    0x4(%eax),%ecx
  8009e1:	8d 40 08             	lea    0x8(%eax),%eax
  8009e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e7:	b8 10 00 00 00       	mov    $0x10,%eax
  8009ec:	eb a5                	jmp    800993 <vprintfmt+0x3bb>
	else if (lflag)
  8009ee:	85 c9                	test   %ecx,%ecx
  8009f0:	75 17                	jne    800a09 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8b 10                	mov    (%eax),%edx
  8009f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009fc:	8d 40 04             	lea    0x4(%eax),%eax
  8009ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a02:	b8 10 00 00 00       	mov    $0x10,%eax
  800a07:	eb 8a                	jmp    800993 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8b 10                	mov    (%eax),%edx
  800a0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a13:	8d 40 04             	lea    0x4(%eax),%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a19:	b8 10 00 00 00       	mov    $0x10,%eax
  800a1e:	e9 70 ff ff ff       	jmp    800993 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	53                   	push   %ebx
  800a27:	6a 25                	push   $0x25
  800a29:	ff d6                	call   *%esi
			break;
  800a2b:	83 c4 10             	add    $0x10,%esp
  800a2e:	e9 7a ff ff ff       	jmp    8009ad <vprintfmt+0x3d5>
			putch('%', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	53                   	push   %ebx
  800a37:	6a 25                	push   $0x25
  800a39:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a3b:	83 c4 10             	add    $0x10,%esp
  800a3e:	89 f8                	mov    %edi,%eax
  800a40:	eb 03                	jmp    800a45 <vprintfmt+0x46d>
  800a42:	83 e8 01             	sub    $0x1,%eax
  800a45:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a49:	75 f7                	jne    800a42 <vprintfmt+0x46a>
  800a4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a4e:	e9 5a ff ff ff       	jmp    8009ad <vprintfmt+0x3d5>
}
  800a53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a56:	5b                   	pop    %ebx
  800a57:	5e                   	pop    %esi
  800a58:	5f                   	pop    %edi
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 18             	sub    $0x18,%esp
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a6e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a78:	85 c0                	test   %eax,%eax
  800a7a:	74 26                	je     800aa2 <vsnprintf+0x47>
  800a7c:	85 d2                	test   %edx,%edx
  800a7e:	7e 22                	jle    800aa2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a80:	ff 75 14             	pushl  0x14(%ebp)
  800a83:	ff 75 10             	pushl  0x10(%ebp)
  800a86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a89:	50                   	push   %eax
  800a8a:	68 9e 05 80 00       	push   $0x80059e
  800a8f:	e8 44 fb ff ff       	call   8005d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a97:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    
		return -E_INVAL;
  800aa2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa7:	eb f7                	jmp    800aa0 <vsnprintf+0x45>

00800aa9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aaf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ab2:	50                   	push   %eax
  800ab3:	ff 75 10             	pushl  0x10(%ebp)
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	ff 75 08             	pushl  0x8(%ebp)
  800abc:	e8 9a ff ff ff       	call   800a5b <vsnprintf>
	va_end(ap);

	return rc;
}
  800ac1:	c9                   	leave  
  800ac2:	c3                   	ret    

00800ac3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ace:	eb 03                	jmp    800ad3 <strlen+0x10>
		n++;
  800ad0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ad3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad7:	75 f7                	jne    800ad0 <strlen+0xd>
	return n;
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae9:	eb 03                	jmp    800aee <strnlen+0x13>
		n++;
  800aeb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aee:	39 d0                	cmp    %edx,%eax
  800af0:	74 06                	je     800af8 <strnlen+0x1d>
  800af2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800af6:	75 f3                	jne    800aeb <strnlen+0x10>
	return n;
}
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	53                   	push   %ebx
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b04:	89 c2                	mov    %eax,%edx
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	83 c2 01             	add    $0x1,%edx
  800b0c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b10:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b13:	84 db                	test   %bl,%bl
  800b15:	75 ef                	jne    800b06 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b17:	5b                   	pop    %ebx
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	53                   	push   %ebx
  800b1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b21:	53                   	push   %ebx
  800b22:	e8 9c ff ff ff       	call   800ac3 <strlen>
  800b27:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	01 d8                	add    %ebx,%eax
  800b2f:	50                   	push   %eax
  800b30:	e8 c5 ff ff ff       	call   800afa <strcpy>
	return dst;
}
  800b35:	89 d8                	mov    %ebx,%eax
  800b37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
  800b41:	8b 75 08             	mov    0x8(%ebp),%esi
  800b44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b47:	89 f3                	mov    %esi,%ebx
  800b49:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4c:	89 f2                	mov    %esi,%edx
  800b4e:	eb 0f                	jmp    800b5f <strncpy+0x23>
		*dst++ = *src;
  800b50:	83 c2 01             	add    $0x1,%edx
  800b53:	0f b6 01             	movzbl (%ecx),%eax
  800b56:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b59:	80 39 01             	cmpb   $0x1,(%ecx)
  800b5c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b5f:	39 da                	cmp    %ebx,%edx
  800b61:	75 ed                	jne    800b50 <strncpy+0x14>
	}
	return ret;
}
  800b63:	89 f0                	mov    %esi,%eax
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	8b 75 08             	mov    0x8(%ebp),%esi
  800b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b77:	89 f0                	mov    %esi,%eax
  800b79:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b7d:	85 c9                	test   %ecx,%ecx
  800b7f:	75 0b                	jne    800b8c <strlcpy+0x23>
  800b81:	eb 17                	jmp    800b9a <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b83:	83 c2 01             	add    $0x1,%edx
  800b86:	83 c0 01             	add    $0x1,%eax
  800b89:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b8c:	39 d8                	cmp    %ebx,%eax
  800b8e:	74 07                	je     800b97 <strlcpy+0x2e>
  800b90:	0f b6 0a             	movzbl (%edx),%ecx
  800b93:	84 c9                	test   %cl,%cl
  800b95:	75 ec                	jne    800b83 <strlcpy+0x1a>
		*dst = '\0';
  800b97:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b9a:	29 f0                	sub    %esi,%eax
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba9:	eb 06                	jmp    800bb1 <strcmp+0x11>
		p++, q++;
  800bab:	83 c1 01             	add    $0x1,%ecx
  800bae:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800bb1:	0f b6 01             	movzbl (%ecx),%eax
  800bb4:	84 c0                	test   %al,%al
  800bb6:	74 04                	je     800bbc <strcmp+0x1c>
  800bb8:	3a 02                	cmp    (%edx),%al
  800bba:	74 ef                	je     800bab <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbc:	0f b6 c0             	movzbl %al,%eax
  800bbf:	0f b6 12             	movzbl (%edx),%edx
  800bc2:	29 d0                	sub    %edx,%eax
}
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	53                   	push   %ebx
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 c3                	mov    %eax,%ebx
  800bd2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd5:	eb 06                	jmp    800bdd <strncmp+0x17>
		n--, p++, q++;
  800bd7:	83 c0 01             	add    $0x1,%eax
  800bda:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bdd:	39 d8                	cmp    %ebx,%eax
  800bdf:	74 16                	je     800bf7 <strncmp+0x31>
  800be1:	0f b6 08             	movzbl (%eax),%ecx
  800be4:	84 c9                	test   %cl,%cl
  800be6:	74 04                	je     800bec <strncmp+0x26>
  800be8:	3a 0a                	cmp    (%edx),%cl
  800bea:	74 eb                	je     800bd7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bec:	0f b6 00             	movzbl (%eax),%eax
  800bef:	0f b6 12             	movzbl (%edx),%edx
  800bf2:	29 d0                	sub    %edx,%eax
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    
		return 0;
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	eb f6                	jmp    800bf4 <strncmp+0x2e>

00800bfe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c08:	0f b6 10             	movzbl (%eax),%edx
  800c0b:	84 d2                	test   %dl,%dl
  800c0d:	74 09                	je     800c18 <strchr+0x1a>
		if (*s == c)
  800c0f:	38 ca                	cmp    %cl,%dl
  800c11:	74 0a                	je     800c1d <strchr+0x1f>
	for (; *s; s++)
  800c13:	83 c0 01             	add    $0x1,%eax
  800c16:	eb f0                	jmp    800c08 <strchr+0xa>
			return (char *) s;
	return 0;
  800c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c29:	eb 03                	jmp    800c2e <strfind+0xf>
  800c2b:	83 c0 01             	add    $0x1,%eax
  800c2e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c31:	38 ca                	cmp    %cl,%dl
  800c33:	74 04                	je     800c39 <strfind+0x1a>
  800c35:	84 d2                	test   %dl,%dl
  800c37:	75 f2                	jne    800c2b <strfind+0xc>
			break;
	return (char *) s;
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c44:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c47:	85 c9                	test   %ecx,%ecx
  800c49:	74 13                	je     800c5e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c4b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c51:	75 05                	jne    800c58 <memset+0x1d>
  800c53:	f6 c1 03             	test   $0x3,%cl
  800c56:	74 0d                	je     800c65 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	fc                   	cld    
  800c5c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c5e:	89 f8                	mov    %edi,%eax
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    
		c &= 0xFF;
  800c65:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c69:	89 d3                	mov    %edx,%ebx
  800c6b:	c1 e3 08             	shl    $0x8,%ebx
  800c6e:	89 d0                	mov    %edx,%eax
  800c70:	c1 e0 18             	shl    $0x18,%eax
  800c73:	89 d6                	mov    %edx,%esi
  800c75:	c1 e6 10             	shl    $0x10,%esi
  800c78:	09 f0                	or     %esi,%eax
  800c7a:	09 c2                	or     %eax,%edx
  800c7c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800c7e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c81:	89 d0                	mov    %edx,%eax
  800c83:	fc                   	cld    
  800c84:	f3 ab                	rep stos %eax,%es:(%edi)
  800c86:	eb d6                	jmp    800c5e <memset+0x23>

00800c88 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	57                   	push   %edi
  800c8c:	56                   	push   %esi
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c93:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c96:	39 c6                	cmp    %eax,%esi
  800c98:	73 35                	jae    800ccf <memmove+0x47>
  800c9a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c9d:	39 c2                	cmp    %eax,%edx
  800c9f:	76 2e                	jbe    800ccf <memmove+0x47>
		s += n;
		d += n;
  800ca1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	09 fe                	or     %edi,%esi
  800ca8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cae:	74 0c                	je     800cbc <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cb0:	83 ef 01             	sub    $0x1,%edi
  800cb3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cb6:	fd                   	std    
  800cb7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb9:	fc                   	cld    
  800cba:	eb 21                	jmp    800cdd <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cbc:	f6 c1 03             	test   $0x3,%cl
  800cbf:	75 ef                	jne    800cb0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc1:	83 ef 04             	sub    $0x4,%edi
  800cc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cca:	fd                   	std    
  800ccb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ccd:	eb ea                	jmp    800cb9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ccf:	89 f2                	mov    %esi,%edx
  800cd1:	09 c2                	or     %eax,%edx
  800cd3:	f6 c2 03             	test   $0x3,%dl
  800cd6:	74 09                	je     800ce1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cd8:	89 c7                	mov    %eax,%edi
  800cda:	fc                   	cld    
  800cdb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ce1:	f6 c1 03             	test   $0x3,%cl
  800ce4:	75 f2                	jne    800cd8 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ce6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ce9:	89 c7                	mov    %eax,%edi
  800ceb:	fc                   	cld    
  800cec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cee:	eb ed                	jmp    800cdd <memmove+0x55>

00800cf0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800cf3:	ff 75 10             	pushl  0x10(%ebp)
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 87 ff ff ff       	call   800c88 <memmove>
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0e:	89 c6                	mov    %eax,%esi
  800d10:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d13:	39 f0                	cmp    %esi,%eax
  800d15:	74 1c                	je     800d33 <memcmp+0x30>
		if (*s1 != *s2)
  800d17:	0f b6 08             	movzbl (%eax),%ecx
  800d1a:	0f b6 1a             	movzbl (%edx),%ebx
  800d1d:	38 d9                	cmp    %bl,%cl
  800d1f:	75 08                	jne    800d29 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d21:	83 c0 01             	add    $0x1,%eax
  800d24:	83 c2 01             	add    $0x1,%edx
  800d27:	eb ea                	jmp    800d13 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d29:	0f b6 c1             	movzbl %cl,%eax
  800d2c:	0f b6 db             	movzbl %bl,%ebx
  800d2f:	29 d8                	sub    %ebx,%eax
  800d31:	eb 05                	jmp    800d38 <memcmp+0x35>
	}

	return 0;
  800d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d45:	89 c2                	mov    %eax,%edx
  800d47:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d4a:	39 d0                	cmp    %edx,%eax
  800d4c:	73 09                	jae    800d57 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d4e:	38 08                	cmp    %cl,(%eax)
  800d50:	74 05                	je     800d57 <memfind+0x1b>
	for (; s < ends; s++)
  800d52:	83 c0 01             	add    $0x1,%eax
  800d55:	eb f3                	jmp    800d4a <memfind+0xe>
			break;
	return (void *) s;
}
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d65:	eb 03                	jmp    800d6a <strtol+0x11>
		s++;
  800d67:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d6a:	0f b6 01             	movzbl (%ecx),%eax
  800d6d:	3c 20                	cmp    $0x20,%al
  800d6f:	74 f6                	je     800d67 <strtol+0xe>
  800d71:	3c 09                	cmp    $0x9,%al
  800d73:	74 f2                	je     800d67 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d75:	3c 2b                	cmp    $0x2b,%al
  800d77:	74 2e                	je     800da7 <strtol+0x4e>
	int neg = 0;
  800d79:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d7e:	3c 2d                	cmp    $0x2d,%al
  800d80:	74 2f                	je     800db1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d82:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d88:	75 05                	jne    800d8f <strtol+0x36>
  800d8a:	80 39 30             	cmpb   $0x30,(%ecx)
  800d8d:	74 2c                	je     800dbb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d8f:	85 db                	test   %ebx,%ebx
  800d91:	75 0a                	jne    800d9d <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d93:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d98:	80 39 30             	cmpb   $0x30,(%ecx)
  800d9b:	74 28                	je     800dc5 <strtol+0x6c>
		base = 10;
  800d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800da2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800da5:	eb 50                	jmp    800df7 <strtol+0x9e>
		s++;
  800da7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800daa:	bf 00 00 00 00       	mov    $0x0,%edi
  800daf:	eb d1                	jmp    800d82 <strtol+0x29>
		s++, neg = 1;
  800db1:	83 c1 01             	add    $0x1,%ecx
  800db4:	bf 01 00 00 00       	mov    $0x1,%edi
  800db9:	eb c7                	jmp    800d82 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dbb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dbf:	74 0e                	je     800dcf <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800dc1:	85 db                	test   %ebx,%ebx
  800dc3:	75 d8                	jne    800d9d <strtol+0x44>
		s++, base = 8;
  800dc5:	83 c1 01             	add    $0x1,%ecx
  800dc8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dcd:	eb ce                	jmp    800d9d <strtol+0x44>
		s += 2, base = 16;
  800dcf:	83 c1 02             	add    $0x2,%ecx
  800dd2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dd7:	eb c4                	jmp    800d9d <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dd9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ddc:	89 f3                	mov    %esi,%ebx
  800dde:	80 fb 19             	cmp    $0x19,%bl
  800de1:	77 29                	ja     800e0c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800de3:	0f be d2             	movsbl %dl,%edx
  800de6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800de9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dec:	7d 30                	jge    800e1e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800dee:	83 c1 01             	add    $0x1,%ecx
  800df1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800df5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800df7:	0f b6 11             	movzbl (%ecx),%edx
  800dfa:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dfd:	89 f3                	mov    %esi,%ebx
  800dff:	80 fb 09             	cmp    $0x9,%bl
  800e02:	77 d5                	ja     800dd9 <strtol+0x80>
			dig = *s - '0';
  800e04:	0f be d2             	movsbl %dl,%edx
  800e07:	83 ea 30             	sub    $0x30,%edx
  800e0a:	eb dd                	jmp    800de9 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800e0c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e0f:	89 f3                	mov    %esi,%ebx
  800e11:	80 fb 19             	cmp    $0x19,%bl
  800e14:	77 08                	ja     800e1e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e16:	0f be d2             	movsbl %dl,%edx
  800e19:	83 ea 37             	sub    $0x37,%edx
  800e1c:	eb cb                	jmp    800de9 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e22:	74 05                	je     800e29 <strtol+0xd0>
		*endptr = (char *) s;
  800e24:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e27:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e29:	89 c2                	mov    %eax,%edx
  800e2b:	f7 da                	neg    %edx
  800e2d:	85 ff                	test   %edi,%edi
  800e2f:	0f 45 c2             	cmovne %edx,%eax
}
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e48:	89 c3                	mov    %eax,%ebx
  800e4a:	89 c7                	mov    %eax,%edi
  800e4c:	89 c6                	mov    %eax,%esi
  800e4e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    

00800e55 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e60:	b8 01 00 00 00       	mov    $0x1,%eax
  800e65:	89 d1                	mov    %edx,%ecx
  800e67:	89 d3                	mov    %edx,%ebx
  800e69:	89 d7                	mov    %edx,%edi
  800e6b:	89 d6                	mov    %edx,%esi
  800e6d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	57                   	push   %edi
  800e78:	56                   	push   %esi
  800e79:	53                   	push   %ebx
  800e7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	b8 03 00 00 00       	mov    $0x3,%eax
  800e8a:	89 cb                	mov    %ecx,%ebx
  800e8c:	89 cf                	mov    %ecx,%edi
  800e8e:	89 ce                	mov    %ecx,%esi
  800e90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7f 08                	jg     800e9e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	50                   	push   %eax
  800ea2:	6a 03                	push   $0x3
  800ea4:	68 df 2e 80 00       	push   $0x802edf
  800ea9:	6a 23                	push   $0x23
  800eab:	68 fc 2e 80 00       	push   $0x802efc
  800eb0:	e8 4b f5 ff ff       	call   800400 <_panic>

00800eb5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ec5:	89 d1                	mov    %edx,%ecx
  800ec7:	89 d3                	mov    %edx,%ebx
  800ec9:	89 d7                	mov    %edx,%edi
  800ecb:	89 d6                	mov    %edx,%esi
  800ecd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ecf:	5b                   	pop    %ebx
  800ed0:	5e                   	pop    %esi
  800ed1:	5f                   	pop    %edi
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    

00800ed4 <sys_yield>:

void
sys_yield(void)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	57                   	push   %edi
  800ed8:	56                   	push   %esi
  800ed9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eda:	ba 00 00 00 00       	mov    $0x0,%edx
  800edf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ee4:	89 d1                	mov    %edx,%ecx
  800ee6:	89 d3                	mov    %edx,%ebx
  800ee8:	89 d7                	mov    %edx,%edi
  800eea:	89 d6                	mov    %edx,%esi
  800eec:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efc:	be 00 00 00 00       	mov    $0x0,%esi
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f07:	b8 04 00 00 00       	mov    $0x4,%eax
  800f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f0f:	89 f7                	mov    %esi,%edi
  800f11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	7f 08                	jg     800f1f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1f:	83 ec 0c             	sub    $0xc,%esp
  800f22:	50                   	push   %eax
  800f23:	6a 04                	push   $0x4
  800f25:	68 df 2e 80 00       	push   $0x802edf
  800f2a:	6a 23                	push   $0x23
  800f2c:	68 fc 2e 80 00       	push   $0x802efc
  800f31:	e8 ca f4 ff ff       	call   800400 <_panic>

00800f36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
  800f3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 05 00 00 00       	mov    $0x5,%eax
  800f4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f50:	8b 75 18             	mov    0x18(%ebp),%esi
  800f53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	7f 08                	jg     800f61 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f61:	83 ec 0c             	sub    $0xc,%esp
  800f64:	50                   	push   %eax
  800f65:	6a 05                	push   $0x5
  800f67:	68 df 2e 80 00       	push   $0x802edf
  800f6c:	6a 23                	push   $0x23
  800f6e:	68 fc 2e 80 00       	push   $0x802efc
  800f73:	e8 88 f4 ff ff       	call   800400 <_panic>

00800f78 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	57                   	push   %edi
  800f7c:	56                   	push   %esi
  800f7d:	53                   	push   %ebx
  800f7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8c:	b8 06 00 00 00       	mov    $0x6,%eax
  800f91:	89 df                	mov    %ebx,%edi
  800f93:	89 de                	mov    %ebx,%esi
  800f95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7f 08                	jg     800fa3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	50                   	push   %eax
  800fa7:	6a 06                	push   $0x6
  800fa9:	68 df 2e 80 00       	push   $0x802edf
  800fae:	6a 23                	push   $0x23
  800fb0:	68 fc 2e 80 00       	push   $0x802efc
  800fb5:	e8 46 f4 ff ff       	call   800400 <_panic>

00800fba <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fce:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd3:	89 df                	mov    %ebx,%edi
  800fd5:	89 de                	mov    %ebx,%esi
  800fd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	7f 08                	jg     800fe5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	50                   	push   %eax
  800fe9:	6a 08                	push   $0x8
  800feb:	68 df 2e 80 00       	push   $0x802edf
  800ff0:	6a 23                	push   $0x23
  800ff2:	68 fc 2e 80 00       	push   $0x802efc
  800ff7:	e8 04 f4 ff ff       	call   800400 <_panic>

00800ffc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801005:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	b8 09 00 00 00       	mov    $0x9,%eax
  801015:	89 df                	mov    %ebx,%edi
  801017:	89 de                	mov    %ebx,%esi
  801019:	cd 30                	int    $0x30
	if(check && ret > 0)
  80101b:	85 c0                	test   %eax,%eax
  80101d:	7f 08                	jg     801027 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80101f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801022:	5b                   	pop    %ebx
  801023:	5e                   	pop    %esi
  801024:	5f                   	pop    %edi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801027:	83 ec 0c             	sub    $0xc,%esp
  80102a:	50                   	push   %eax
  80102b:	6a 09                	push   $0x9
  80102d:	68 df 2e 80 00       	push   $0x802edf
  801032:	6a 23                	push   $0x23
  801034:	68 fc 2e 80 00       	push   $0x802efc
  801039:	e8 c2 f3 ff ff       	call   800400 <_panic>

0080103e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801047:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104c:	8b 55 08             	mov    0x8(%ebp),%edx
  80104f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801052:	b8 0a 00 00 00       	mov    $0xa,%eax
  801057:	89 df                	mov    %ebx,%edi
  801059:	89 de                	mov    %ebx,%esi
  80105b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	7f 08                	jg     801069 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801061:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801064:	5b                   	pop    %ebx
  801065:	5e                   	pop    %esi
  801066:	5f                   	pop    %edi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	6a 0a                	push   $0xa
  80106f:	68 df 2e 80 00       	push   $0x802edf
  801074:	6a 23                	push   $0x23
  801076:	68 fc 2e 80 00       	push   $0x802efc
  80107b:	e8 80 f3 ff ff       	call   800400 <_panic>

00801080 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	57                   	push   %edi
  801084:	56                   	push   %esi
  801085:	53                   	push   %ebx
	asm volatile("int %1\n"
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801091:	be 00 00 00 00       	mov    $0x0,%esi
  801096:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801099:	8b 7d 14             	mov    0x14(%ebp),%edi
  80109c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010b9:	89 cb                	mov    %ecx,%ebx
  8010bb:	89 cf                	mov    %ecx,%edi
  8010bd:	89 ce                	mov    %ecx,%esi
  8010bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	7f 08                	jg     8010cd <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	50                   	push   %eax
  8010d1:	6a 0d                	push   $0xd
  8010d3:	68 df 2e 80 00       	push   $0x802edf
  8010d8:	6a 23                	push   $0x23
  8010da:	68 fc 2e 80 00       	push   $0x802efc
  8010df:	e8 1c f3 ff ff       	call   800400 <_panic>

008010e4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	57                   	push   %edi
  8010e8:	56                   	push   %esi
  8010e9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ef:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010f4:	89 d1                	mov    %edx,%ecx
  8010f6:	89 d3                	mov    %edx,%ebx
  8010f8:	89 d7                	mov    %edx,%edi
  8010fa:	89 d6                	mov    %edx,%esi
  8010fc:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010fe:	5b                   	pop    %ebx
  8010ff:	5e                   	pop    %esi
  801100:	5f                   	pop    %edi
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	05 00 00 00 30       	add    $0x30000000,%eax
  80110e:	c1 e8 0c             	shr    $0xc,%eax
}
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80111e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801123:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801130:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801135:	89 c2                	mov    %eax,%edx
  801137:	c1 ea 16             	shr    $0x16,%edx
  80113a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801141:	f6 c2 01             	test   $0x1,%dl
  801144:	74 2a                	je     801170 <fd_alloc+0x46>
  801146:	89 c2                	mov    %eax,%edx
  801148:	c1 ea 0c             	shr    $0xc,%edx
  80114b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801152:	f6 c2 01             	test   $0x1,%dl
  801155:	74 19                	je     801170 <fd_alloc+0x46>
  801157:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80115c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801161:	75 d2                	jne    801135 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801163:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801169:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80116e:	eb 07                	jmp    801177 <fd_alloc+0x4d>
			*fd_store = fd;
  801170:	89 01                	mov    %eax,(%ecx)
			return 0;
  801172:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80117f:	83 f8 1f             	cmp    $0x1f,%eax
  801182:	77 36                	ja     8011ba <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801184:	c1 e0 0c             	shl    $0xc,%eax
  801187:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80118c:	89 c2                	mov    %eax,%edx
  80118e:	c1 ea 16             	shr    $0x16,%edx
  801191:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801198:	f6 c2 01             	test   $0x1,%dl
  80119b:	74 24                	je     8011c1 <fd_lookup+0x48>
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	c1 ea 0c             	shr    $0xc,%edx
  8011a2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a9:	f6 c2 01             	test   $0x1,%dl
  8011ac:	74 1a                	je     8011c8 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b1:	89 02                	mov    %eax,(%edx)
	return 0;
  8011b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    
		return -E_INVAL;
  8011ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011bf:	eb f7                	jmp    8011b8 <fd_lookup+0x3f>
		return -E_INVAL;
  8011c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c6:	eb f0                	jmp    8011b8 <fd_lookup+0x3f>
  8011c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cd:	eb e9                	jmp    8011b8 <fd_lookup+0x3f>

008011cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 08             	sub    $0x8,%esp
  8011d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d8:	ba 88 2f 80 00       	mov    $0x802f88,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011dd:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e2:	39 08                	cmp    %ecx,(%eax)
  8011e4:	74 33                	je     801219 <dev_lookup+0x4a>
  8011e6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011e9:	8b 02                	mov    (%edx),%eax
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	75 f3                	jne    8011e2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ef:	a1 90 77 80 00       	mov    0x807790,%eax
  8011f4:	8b 40 48             	mov    0x48(%eax),%eax
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	51                   	push   %ecx
  8011fb:	50                   	push   %eax
  8011fc:	68 0c 2f 80 00       	push   $0x802f0c
  801201:	e8 d5 f2 ff ff       	call   8004db <cprintf>
	*dev = 0;
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    
			*dev = devtab[i];
  801219:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
  801223:	eb f2                	jmp    801217 <dev_lookup+0x48>

00801225 <fd_close>:
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	57                   	push   %edi
  801229:	56                   	push   %esi
  80122a:	53                   	push   %ebx
  80122b:	83 ec 1c             	sub    $0x1c,%esp
  80122e:	8b 75 08             	mov    0x8(%ebp),%esi
  801231:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801234:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801237:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801238:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80123e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801241:	50                   	push   %eax
  801242:	e8 32 ff ff ff       	call   801179 <fd_lookup>
  801247:	89 c3                	mov    %eax,%ebx
  801249:	83 c4 08             	add    $0x8,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	78 05                	js     801255 <fd_close+0x30>
	    || fd != fd2)
  801250:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801253:	74 16                	je     80126b <fd_close+0x46>
		return (must_exist ? r : 0);
  801255:	89 f8                	mov    %edi,%eax
  801257:	84 c0                	test   %al,%al
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
  80125e:	0f 44 d8             	cmove  %eax,%ebx
}
  801261:	89 d8                	mov    %ebx,%eax
  801263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801266:	5b                   	pop    %ebx
  801267:	5e                   	pop    %esi
  801268:	5f                   	pop    %edi
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801271:	50                   	push   %eax
  801272:	ff 36                	pushl  (%esi)
  801274:	e8 56 ff ff ff       	call   8011cf <dev_lookup>
  801279:	89 c3                	mov    %eax,%ebx
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 15                	js     801297 <fd_close+0x72>
		if (dev->dev_close)
  801282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801285:	8b 40 10             	mov    0x10(%eax),%eax
  801288:	85 c0                	test   %eax,%eax
  80128a:	74 1b                	je     8012a7 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	56                   	push   %esi
  801290:	ff d0                	call   *%eax
  801292:	89 c3                	mov    %eax,%ebx
  801294:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801297:	83 ec 08             	sub    $0x8,%esp
  80129a:	56                   	push   %esi
  80129b:	6a 00                	push   $0x0
  80129d:	e8 d6 fc ff ff       	call   800f78 <sys_page_unmap>
	return r;
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	eb ba                	jmp    801261 <fd_close+0x3c>
			r = 0;
  8012a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ac:	eb e9                	jmp    801297 <fd_close+0x72>

008012ae <close>:

int
close(int fdnum)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b7:	50                   	push   %eax
  8012b8:	ff 75 08             	pushl  0x8(%ebp)
  8012bb:	e8 b9 fe ff ff       	call   801179 <fd_lookup>
  8012c0:	83 c4 08             	add    $0x8,%esp
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	78 10                	js     8012d7 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	6a 01                	push   $0x1
  8012cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8012cf:	e8 51 ff ff ff       	call   801225 <fd_close>
  8012d4:	83 c4 10             	add    $0x10,%esp
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <close_all>:

void
close_all(void)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	53                   	push   %ebx
  8012e9:	e8 c0 ff ff ff       	call   8012ae <close>
	for (i = 0; i < MAXFD; i++)
  8012ee:	83 c3 01             	add    $0x1,%ebx
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	83 fb 20             	cmp    $0x20,%ebx
  8012f7:	75 ec                	jne    8012e5 <close_all+0xc>
}
  8012f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	57                   	push   %edi
  801302:	56                   	push   %esi
  801303:	53                   	push   %ebx
  801304:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801307:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80130a:	50                   	push   %eax
  80130b:	ff 75 08             	pushl  0x8(%ebp)
  80130e:	e8 66 fe ff ff       	call   801179 <fd_lookup>
  801313:	89 c3                	mov    %eax,%ebx
  801315:	83 c4 08             	add    $0x8,%esp
  801318:	85 c0                	test   %eax,%eax
  80131a:	0f 88 81 00 00 00    	js     8013a1 <dup+0xa3>
		return r;
	close(newfdnum);
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	ff 75 0c             	pushl  0xc(%ebp)
  801326:	e8 83 ff ff ff       	call   8012ae <close>

	newfd = INDEX2FD(newfdnum);
  80132b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80132e:	c1 e6 0c             	shl    $0xc,%esi
  801331:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801337:	83 c4 04             	add    $0x4,%esp
  80133a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80133d:	e8 d1 fd ff ff       	call   801113 <fd2data>
  801342:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801344:	89 34 24             	mov    %esi,(%esp)
  801347:	e8 c7 fd ff ff       	call   801113 <fd2data>
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801351:	89 d8                	mov    %ebx,%eax
  801353:	c1 e8 16             	shr    $0x16,%eax
  801356:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80135d:	a8 01                	test   $0x1,%al
  80135f:	74 11                	je     801372 <dup+0x74>
  801361:	89 d8                	mov    %ebx,%eax
  801363:	c1 e8 0c             	shr    $0xc,%eax
  801366:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80136d:	f6 c2 01             	test   $0x1,%dl
  801370:	75 39                	jne    8013ab <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801375:	89 d0                	mov    %edx,%eax
  801377:	c1 e8 0c             	shr    $0xc,%eax
  80137a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801381:	83 ec 0c             	sub    $0xc,%esp
  801384:	25 07 0e 00 00       	and    $0xe07,%eax
  801389:	50                   	push   %eax
  80138a:	56                   	push   %esi
  80138b:	6a 00                	push   $0x0
  80138d:	52                   	push   %edx
  80138e:	6a 00                	push   $0x0
  801390:	e8 a1 fb ff ff       	call   800f36 <sys_page_map>
  801395:	89 c3                	mov    %eax,%ebx
  801397:	83 c4 20             	add    $0x20,%esp
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 31                	js     8013cf <dup+0xd1>
		goto err;

	return newfdnum;
  80139e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013a1:	89 d8                	mov    %ebx,%eax
  8013a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a6:	5b                   	pop    %ebx
  8013a7:	5e                   	pop    %esi
  8013a8:	5f                   	pop    %edi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013ab:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ba:	50                   	push   %eax
  8013bb:	57                   	push   %edi
  8013bc:	6a 00                	push   $0x0
  8013be:	53                   	push   %ebx
  8013bf:	6a 00                	push   $0x0
  8013c1:	e8 70 fb ff ff       	call   800f36 <sys_page_map>
  8013c6:	89 c3                	mov    %eax,%ebx
  8013c8:	83 c4 20             	add    $0x20,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	79 a3                	jns    801372 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	56                   	push   %esi
  8013d3:	6a 00                	push   $0x0
  8013d5:	e8 9e fb ff ff       	call   800f78 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013da:	83 c4 08             	add    $0x8,%esp
  8013dd:	57                   	push   %edi
  8013de:	6a 00                	push   $0x0
  8013e0:	e8 93 fb ff ff       	call   800f78 <sys_page_unmap>
	return r;
  8013e5:	83 c4 10             	add    $0x10,%esp
  8013e8:	eb b7                	jmp    8013a1 <dup+0xa3>

008013ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	53                   	push   %ebx
  8013ee:	83 ec 14             	sub    $0x14,%esp
  8013f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	53                   	push   %ebx
  8013f9:	e8 7b fd ff ff       	call   801179 <fd_lookup>
  8013fe:	83 c4 08             	add    $0x8,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 3f                	js     801444 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140b:	50                   	push   %eax
  80140c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140f:	ff 30                	pushl  (%eax)
  801411:	e8 b9 fd ff ff       	call   8011cf <dev_lookup>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 27                	js     801444 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80141d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801420:	8b 42 08             	mov    0x8(%edx),%eax
  801423:	83 e0 03             	and    $0x3,%eax
  801426:	83 f8 01             	cmp    $0x1,%eax
  801429:	74 1e                	je     801449 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142e:	8b 40 08             	mov    0x8(%eax),%eax
  801431:	85 c0                	test   %eax,%eax
  801433:	74 35                	je     80146a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801435:	83 ec 04             	sub    $0x4,%esp
  801438:	ff 75 10             	pushl  0x10(%ebp)
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	52                   	push   %edx
  80143f:	ff d0                	call   *%eax
  801441:	83 c4 10             	add    $0x10,%esp
}
  801444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801447:	c9                   	leave  
  801448:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801449:	a1 90 77 80 00       	mov    0x807790,%eax
  80144e:	8b 40 48             	mov    0x48(%eax),%eax
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	53                   	push   %ebx
  801455:	50                   	push   %eax
  801456:	68 4d 2f 80 00       	push   $0x802f4d
  80145b:	e8 7b f0 ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801468:	eb da                	jmp    801444 <read+0x5a>
		return -E_NOT_SUPP;
  80146a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146f:	eb d3                	jmp    801444 <read+0x5a>

00801471 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	57                   	push   %edi
  801475:	56                   	push   %esi
  801476:	53                   	push   %ebx
  801477:	83 ec 0c             	sub    $0xc,%esp
  80147a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80147d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801480:	bb 00 00 00 00       	mov    $0x0,%ebx
  801485:	39 f3                	cmp    %esi,%ebx
  801487:	73 25                	jae    8014ae <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	89 f0                	mov    %esi,%eax
  80148e:	29 d8                	sub    %ebx,%eax
  801490:	50                   	push   %eax
  801491:	89 d8                	mov    %ebx,%eax
  801493:	03 45 0c             	add    0xc(%ebp),%eax
  801496:	50                   	push   %eax
  801497:	57                   	push   %edi
  801498:	e8 4d ff ff ff       	call   8013ea <read>
		if (m < 0)
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 08                	js     8014ac <readn+0x3b>
			return m;
		if (m == 0)
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	74 06                	je     8014ae <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014a8:	01 c3                	add    %eax,%ebx
  8014aa:	eb d9                	jmp    801485 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ac:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014ae:	89 d8                	mov    %ebx,%eax
  8014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b3:	5b                   	pop    %ebx
  8014b4:	5e                   	pop    %esi
  8014b5:	5f                   	pop    %edi
  8014b6:	5d                   	pop    %ebp
  8014b7:	c3                   	ret    

008014b8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 14             	sub    $0x14,%esp
  8014bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c5:	50                   	push   %eax
  8014c6:	53                   	push   %ebx
  8014c7:	e8 ad fc ff ff       	call   801179 <fd_lookup>
  8014cc:	83 c4 08             	add    $0x8,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 3a                	js     80150d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d9:	50                   	push   %eax
  8014da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dd:	ff 30                	pushl  (%eax)
  8014df:	e8 eb fc ff ff       	call   8011cf <dev_lookup>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 22                	js     80150d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ee:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f2:	74 1e                	je     801512 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f7:	8b 52 0c             	mov    0xc(%edx),%edx
  8014fa:	85 d2                	test   %edx,%edx
  8014fc:	74 35                	je     801533 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	ff 75 10             	pushl  0x10(%ebp)
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	50                   	push   %eax
  801508:	ff d2                	call   *%edx
  80150a:	83 c4 10             	add    $0x10,%esp
}
  80150d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801510:	c9                   	leave  
  801511:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801512:	a1 90 77 80 00       	mov    0x807790,%eax
  801517:	8b 40 48             	mov    0x48(%eax),%eax
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	53                   	push   %ebx
  80151e:	50                   	push   %eax
  80151f:	68 69 2f 80 00       	push   $0x802f69
  801524:	e8 b2 ef ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801531:	eb da                	jmp    80150d <write+0x55>
		return -E_NOT_SUPP;
  801533:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801538:	eb d3                	jmp    80150d <write+0x55>

0080153a <seek>:

int
seek(int fdnum, off_t offset)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801540:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801543:	50                   	push   %eax
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	e8 2d fc ff ff       	call   801179 <fd_lookup>
  80154c:	83 c4 08             	add    $0x8,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 0e                	js     801561 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801559:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	53                   	push   %ebx
  801567:	83 ec 14             	sub    $0x14,%esp
  80156a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801570:	50                   	push   %eax
  801571:	53                   	push   %ebx
  801572:	e8 02 fc ff ff       	call   801179 <fd_lookup>
  801577:	83 c4 08             	add    $0x8,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	78 37                	js     8015b5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157e:	83 ec 08             	sub    $0x8,%esp
  801581:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801584:	50                   	push   %eax
  801585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801588:	ff 30                	pushl  (%eax)
  80158a:	e8 40 fc ff ff       	call   8011cf <dev_lookup>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 1f                	js     8015b5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80159d:	74 1b                	je     8015ba <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80159f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a2:	8b 52 18             	mov    0x18(%edx),%edx
  8015a5:	85 d2                	test   %edx,%edx
  8015a7:	74 32                	je     8015db <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015a9:	83 ec 08             	sub    $0x8,%esp
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	50                   	push   %eax
  8015b0:	ff d2                	call   *%edx
  8015b2:	83 c4 10             	add    $0x10,%esp
}
  8015b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015ba:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015bf:	8b 40 48             	mov    0x48(%eax),%eax
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	53                   	push   %ebx
  8015c6:	50                   	push   %eax
  8015c7:	68 2c 2f 80 00       	push   $0x802f2c
  8015cc:	e8 0a ef ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d9:	eb da                	jmp    8015b5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e0:	eb d3                	jmp    8015b5 <ftruncate+0x52>

008015e2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	53                   	push   %ebx
  8015e6:	83 ec 14             	sub    $0x14,%esp
  8015e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ef:	50                   	push   %eax
  8015f0:	ff 75 08             	pushl  0x8(%ebp)
  8015f3:	e8 81 fb ff ff       	call   801179 <fd_lookup>
  8015f8:	83 c4 08             	add    $0x8,%esp
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 4b                	js     80164a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801605:	50                   	push   %eax
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	ff 30                	pushl  (%eax)
  80160b:	e8 bf fb ff ff       	call   8011cf <dev_lookup>
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	85 c0                	test   %eax,%eax
  801615:	78 33                	js     80164a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80161e:	74 2f                	je     80164f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801620:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801623:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80162a:	00 00 00 
	stat->st_isdir = 0;
  80162d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801634:	00 00 00 
	stat->st_dev = dev;
  801637:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	53                   	push   %ebx
  801641:	ff 75 f0             	pushl  -0x10(%ebp)
  801644:	ff 50 14             	call   *0x14(%eax)
  801647:	83 c4 10             	add    $0x10,%esp
}
  80164a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    
		return -E_NOT_SUPP;
  80164f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801654:	eb f4                	jmp    80164a <fstat+0x68>

00801656 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	6a 00                	push   $0x0
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	e8 e7 01 00 00       	call   80184f <open>
  801668:	89 c3                	mov    %eax,%ebx
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 1b                	js     80168c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	50                   	push   %eax
  801678:	e8 65 ff ff ff       	call   8015e2 <fstat>
  80167d:	89 c6                	mov    %eax,%esi
	close(fd);
  80167f:	89 1c 24             	mov    %ebx,(%esp)
  801682:	e8 27 fc ff ff       	call   8012ae <close>
	return r;
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	89 f3                	mov    %esi,%ebx
}
  80168c:	89 d8                	mov    %ebx,%eax
  80168e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    

00801695 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
  80169a:	89 c6                	mov    %eax,%esi
  80169c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80169e:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8016a5:	74 27                	je     8016ce <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016a7:	6a 07                	push   $0x7
  8016a9:	68 00 80 80 00       	push   $0x808000
  8016ae:	56                   	push   %esi
  8016af:	ff 35 00 60 80 00    	pushl  0x806000
  8016b5:	e8 99 10 00 00       	call   802753 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ba:	83 c4 0c             	add    $0xc,%esp
  8016bd:	6a 00                	push   $0x0
  8016bf:	53                   	push   %ebx
  8016c0:	6a 00                	push   $0x0
  8016c2:	e8 25 10 00 00       	call   8026ec <ipc_recv>
}
  8016c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ca:	5b                   	pop    %ebx
  8016cb:	5e                   	pop    %esi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016ce:	83 ec 0c             	sub    $0xc,%esp
  8016d1:	6a 01                	push   $0x1
  8016d3:	e8 cf 10 00 00       	call   8027a7 <ipc_find_env>
  8016d8:	a3 00 60 80 00       	mov    %eax,0x806000
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	eb c5                	jmp    8016a7 <fsipc+0x12>

008016e2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ee:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801700:	b8 02 00 00 00       	mov    $0x2,%eax
  801705:	e8 8b ff ff ff       	call   801695 <fsipc>
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <devfile_flush>:
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8b 40 0c             	mov    0xc(%eax),%eax
  801718:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  80171d:	ba 00 00 00 00       	mov    $0x0,%edx
  801722:	b8 06 00 00 00       	mov    $0x6,%eax
  801727:	e8 69 ff ff ff       	call   801695 <fsipc>
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <devfile_stat>:
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	53                   	push   %ebx
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8b 40 0c             	mov    0xc(%eax),%eax
  80173e:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801743:	ba 00 00 00 00       	mov    $0x0,%edx
  801748:	b8 05 00 00 00       	mov    $0x5,%eax
  80174d:	e8 43 ff ff ff       	call   801695 <fsipc>
  801752:	85 c0                	test   %eax,%eax
  801754:	78 2c                	js     801782 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801756:	83 ec 08             	sub    $0x8,%esp
  801759:	68 00 80 80 00       	push   $0x808000
  80175e:	53                   	push   %ebx
  80175f:	e8 96 f3 ff ff       	call   800afa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801764:	a1 80 80 80 00       	mov    0x808080,%eax
  801769:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80176f:	a1 84 80 80 00       	mov    0x808084,%eax
  801774:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <devfile_write>:
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 0c             	sub    $0xc,%esp
  80178d:	8b 45 10             	mov    0x10(%ebp),%eax
  801790:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801795:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80179a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80179d:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8017a3:	89 15 00 80 80 00    	mov    %edx,0x808000
	fsipcbuf.write.req_n = n;
  8017a9:	a3 04 80 80 00       	mov    %eax,0x808004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8017ae:	50                   	push   %eax
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	68 08 80 80 00       	push   $0x808008
  8017b7:	e8 cc f4 ff ff       	call   800c88 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8017bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c1:	b8 04 00 00 00       	mov    $0x4,%eax
  8017c6:	e8 ca fe ff ff       	call   801695 <fsipc>
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <devfile_read>:
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017db:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  8017e0:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8017f0:	e8 a0 fe ff ff       	call   801695 <fsipc>
  8017f5:	89 c3                	mov    %eax,%ebx
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 1f                	js     80181a <devfile_read+0x4d>
	assert(r <= n);
  8017fb:	39 f0                	cmp    %esi,%eax
  8017fd:	77 24                	ja     801823 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017ff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801804:	7f 33                	jg     801839 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	50                   	push   %eax
  80180a:	68 00 80 80 00       	push   $0x808000
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	e8 71 f4 ff ff       	call   800c88 <memmove>
	return r;
  801817:	83 c4 10             	add    $0x10,%esp
}
  80181a:	89 d8                	mov    %ebx,%eax
  80181c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181f:	5b                   	pop    %ebx
  801820:	5e                   	pop    %esi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    
	assert(r <= n);
  801823:	68 9c 2f 80 00       	push   $0x802f9c
  801828:	68 a3 2f 80 00       	push   $0x802fa3
  80182d:	6a 7b                	push   $0x7b
  80182f:	68 b8 2f 80 00       	push   $0x802fb8
  801834:	e8 c7 eb ff ff       	call   800400 <_panic>
	assert(r <= PGSIZE);
  801839:	68 c3 2f 80 00       	push   $0x802fc3
  80183e:	68 a3 2f 80 00       	push   $0x802fa3
  801843:	6a 7c                	push   $0x7c
  801845:	68 b8 2f 80 00       	push   $0x802fb8
  80184a:	e8 b1 eb ff ff       	call   800400 <_panic>

0080184f <open>:
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	56                   	push   %esi
  801853:	53                   	push   %ebx
  801854:	83 ec 1c             	sub    $0x1c,%esp
  801857:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80185a:	56                   	push   %esi
  80185b:	e8 63 f2 ff ff       	call   800ac3 <strlen>
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801868:	7f 6c                	jg     8018d6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80186a:	83 ec 0c             	sub    $0xc,%esp
  80186d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801870:	50                   	push   %eax
  801871:	e8 b4 f8 ff ff       	call   80112a <fd_alloc>
  801876:	89 c3                	mov    %eax,%ebx
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	85 c0                	test   %eax,%eax
  80187d:	78 3c                	js     8018bb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80187f:	83 ec 08             	sub    $0x8,%esp
  801882:	56                   	push   %esi
  801883:	68 00 80 80 00       	push   $0x808000
  801888:	e8 6d f2 ff ff       	call   800afa <strcpy>
	fsipcbuf.open.req_omode = mode;
  80188d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801890:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801898:	b8 01 00 00 00       	mov    $0x1,%eax
  80189d:	e8 f3 fd ff ff       	call   801695 <fsipc>
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 19                	js     8018c4 <open+0x75>
	return fd2num(fd);
  8018ab:	83 ec 0c             	sub    $0xc,%esp
  8018ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b1:	e8 4d f8 ff ff       	call   801103 <fd2num>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 10             	add    $0x10,%esp
}
  8018bb:	89 d8                	mov    %ebx,%eax
  8018bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    
		fd_close(fd, 0);
  8018c4:	83 ec 08             	sub    $0x8,%esp
  8018c7:	6a 00                	push   $0x0
  8018c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8018cc:	e8 54 f9 ff ff       	call   801225 <fd_close>
		return r;
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	eb e5                	jmp    8018bb <open+0x6c>
		return -E_BAD_PATH;
  8018d6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018db:	eb de                	jmp    8018bb <open+0x6c>

008018dd <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8018ed:	e8 a3 fd ff ff       	call   801695 <fsipc>
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <spawn>:
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int spawn(const char *prog, const char **argv)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	57                   	push   %edi
  8018f8:	56                   	push   %esi
  8018f9:	53                   	push   %ebx
  8018fa:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801900:	6a 00                	push   $0x0
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	e8 45 ff ff ff       	call   80184f <open>
  80190a:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	85 c0                	test   %eax,%eax
  801915:	0f 88 40 03 00 00    	js     801c5b <spawn+0x367>
  80191b:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *)elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) || elf->e_magic != ELF_MAGIC)
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	68 00 02 00 00       	push   $0x200
  801925:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80192b:	50                   	push   %eax
  80192c:	51                   	push   %ecx
  80192d:	e8 3f fb ff ff       	call   801471 <readn>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	3d 00 02 00 00       	cmp    $0x200,%eax
  80193a:	75 5d                	jne    801999 <spawn+0xa5>
  80193c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801943:	45 4c 46 
  801946:	75 51                	jne    801999 <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801948:	b8 07 00 00 00       	mov    $0x7,%eax
  80194d:	cd 30                	int    $0x30
  80194f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801955:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80195b:	85 c0                	test   %eax,%eax
  80195d:	0f 88 62 04 00 00    	js     801dc5 <spawn+0x4d1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801963:	25 ff 03 00 00       	and    $0x3ff,%eax
  801968:	6b f0 7c             	imul   $0x7c,%eax,%esi
  80196b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801971:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801977:	b9 11 00 00 00       	mov    $0x11,%ecx
  80197c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80197e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801984:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80198a:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80198f:	be 00 00 00 00       	mov    $0x0,%esi
  801994:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801997:	eb 4b                	jmp    8019e4 <spawn+0xf0>
		close(fd);
  801999:	83 ec 0c             	sub    $0xc,%esp
  80199c:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8019a2:	e8 07 f9 ff ff       	call   8012ae <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8019a7:	83 c4 0c             	add    $0xc,%esp
  8019aa:	68 7f 45 4c 46       	push   $0x464c457f
  8019af:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8019b5:	68 cf 2f 80 00       	push   $0x802fcf
  8019ba:	e8 1c eb ff ff       	call   8004db <cprintf>
		return -E_NOT_EXEC;
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  8019c9:	ff ff ff 
  8019cc:	e9 8a 02 00 00       	jmp    801c5b <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	50                   	push   %eax
  8019d5:	e8 e9 f0 ff ff       	call   800ac3 <strlen>
  8019da:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8019de:	83 c3 01             	add    $0x1,%ebx
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8019eb:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	75 df                	jne    8019d1 <spawn+0xdd>
  8019f2:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8019f8:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *)UTEMP + PGSIZE - string_size;
  8019fe:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a03:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *)(ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a05:	89 fa                	mov    %edi,%edx
  801a07:	83 e2 fc             	and    $0xfffffffc,%edx
  801a0a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a11:	29 c2                	sub    %eax,%edx
  801a13:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *)(argv_store - 2) < (void *)UTEMP)
  801a19:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a1c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a21:	0f 86 af 03 00 00    	jbe    801dd6 <spawn+0x4e2>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	6a 07                	push   $0x7
  801a2c:	68 00 00 40 00       	push   $0x400000
  801a31:	6a 00                	push   $0x0
  801a33:	e8 bb f4 ff ff       	call   800ef3 <sys_page_alloc>
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	0f 88 98 03 00 00    	js     801ddb <spawn+0x4e7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++)
  801a43:	be 00 00 00 00       	mov    $0x0,%esi
  801a48:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a51:	eb 30                	jmp    801a83 <spawn+0x18f>
	{
		argv_store[i] = UTEMP2USTACK(string_store);
  801a53:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a59:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a5f:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a68:	57                   	push   %edi
  801a69:	e8 8c f0 ff ff       	call   800afa <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a6e:	83 c4 04             	add    $0x4,%esp
  801a71:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a74:	e8 4a f0 ff ff       	call   800ac3 <strlen>
  801a79:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++)
  801a7d:	83 c6 01             	add    $0x1,%esi
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801a89:	7f c8                	jg     801a53 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801a8b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a91:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a97:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *)UTEMP + PGSIZE);
  801a9e:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801aa4:	0f 85 8c 00 00 00    	jne    801b36 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801aaa:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801ab0:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801ab6:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801ab9:	89 f8                	mov    %edi,%eax
  801abb:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801ac1:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ac4:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801ac9:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void *)(USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	6a 07                	push   $0x7
  801ad4:	68 00 d0 bf ee       	push   $0xeebfd000
  801ad9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801adf:	68 00 00 40 00       	push   $0x400000
  801ae4:	6a 00                	push   $0x0
  801ae6:	e8 4b f4 ff ff       	call   800f36 <sys_page_map>
  801aeb:	89 c3                	mov    %eax,%ebx
  801aed:	83 c4 20             	add    $0x20,%esp
  801af0:	85 c0                	test   %eax,%eax
  801af2:	0f 88 59 03 00 00    	js     801e51 <spawn+0x55d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	68 00 00 40 00       	push   $0x400000
  801b00:	6a 00                	push   $0x0
  801b02:	e8 71 f4 ff ff       	call   800f78 <sys_page_unmap>
  801b07:	89 c3                	mov    %eax,%ebx
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	0f 88 3d 03 00 00    	js     801e51 <spawn+0x55d>
	ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  801b14:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b1a:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801b21:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801b27:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801b2e:	00 00 00 
  801b31:	e9 56 01 00 00       	jmp    801c8c <spawn+0x398>
	assert(string_store == (char *)UTEMP + PGSIZE);
  801b36:	68 5c 30 80 00       	push   $0x80305c
  801b3b:	68 a3 2f 80 00       	push   $0x802fa3
  801b40:	68 f0 00 00 00       	push   $0xf0
  801b45:	68 e9 2f 80 00       	push   $0x802fe9
  801b4a:	e8 b1 e8 ff ff       	call   800400 <_panic>
				return r;
		}
		else
		{
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	6a 07                	push   $0x7
  801b54:	68 00 00 40 00       	push   $0x400000
  801b59:	6a 00                	push   $0x0
  801b5b:	e8 93 f3 ff ff       	call   800ef3 <sys_page_alloc>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	0f 88 7b 02 00 00    	js     801de6 <spawn+0x4f2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b74:	01 f0                	add    %esi,%eax
  801b76:	50                   	push   %eax
  801b77:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b7d:	e8 b8 f9 ff ff       	call   80153a <seek>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	0f 88 60 02 00 00    	js     801ded <spawn+0x4f9>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b96:	29 f0                	sub    %esi,%eax
  801b98:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b9d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ba2:	0f 47 c1             	cmova  %ecx,%eax
  801ba5:	50                   	push   %eax
  801ba6:	68 00 00 40 00       	push   $0x400000
  801bab:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801bb1:	e8 bb f8 ff ff       	call   801471 <readn>
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	0f 88 33 02 00 00    	js     801df4 <spawn+0x500>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void *)(va + i), perm)) < 0)
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	57                   	push   %edi
  801bc5:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801bcb:	56                   	push   %esi
  801bcc:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801bd2:	68 00 00 40 00       	push   $0x400000
  801bd7:	6a 00                	push   $0x0
  801bd9:	e8 58 f3 ff ff       	call   800f36 <sys_page_map>
  801bde:	83 c4 20             	add    $0x20,%esp
  801be1:	85 c0                	test   %eax,%eax
  801be3:	0f 88 80 00 00 00    	js     801c69 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801be9:	83 ec 08             	sub    $0x8,%esp
  801bec:	68 00 00 40 00       	push   $0x400000
  801bf1:	6a 00                	push   $0x0
  801bf3:	e8 80 f3 ff ff       	call   800f78 <sys_page_unmap>
  801bf8:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE)
  801bfb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c01:	89 de                	mov    %ebx,%esi
  801c03:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801c09:	76 73                	jbe    801c7e <spawn+0x38a>
		if (i >= filesz)
  801c0b:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801c11:	0f 87 38 ff ff ff    	ja     801b4f <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void *)(va + i), perm)) < 0)
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	57                   	push   %edi
  801c1b:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801c21:	56                   	push   %esi
  801c22:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801c28:	e8 c6 f2 ff ff       	call   800ef3 <sys_page_alloc>
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	85 c0                	test   %eax,%eax
  801c32:	79 c7                	jns    801bfb <spawn+0x307>
  801c34:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c36:	83 ec 0c             	sub    $0xc,%esp
  801c39:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c3f:	e8 30 f2 ff ff       	call   800e74 <sys_env_destroy>
	close(fd);
  801c44:	83 c4 04             	add    $0x4,%esp
  801c47:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c4d:	e8 5c f6 ff ff       	call   8012ae <close>
	return r;
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801c5b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5f                   	pop    %edi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801c69:	50                   	push   %eax
  801c6a:	68 f5 2f 80 00       	push   $0x802ff5
  801c6f:	68 28 01 00 00       	push   $0x128
  801c74:	68 e9 2f 80 00       	push   $0x802fe9
  801c79:	e8 82 e7 ff ff       	call   800400 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801c7e:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801c85:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801c8c:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c93:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801c99:	7e 71                	jle    801d0c <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801c9b:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801ca1:	83 3a 01             	cmpl   $0x1,(%edx)
  801ca4:	75 d8                	jne    801c7e <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ca6:	8b 42 18             	mov    0x18(%edx),%eax
  801ca9:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801cac:	83 f8 01             	cmp    $0x1,%eax
  801caf:	19 ff                	sbb    %edi,%edi
  801cb1:	83 e7 fe             	and    $0xfffffffe,%edi
  801cb4:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801cb7:	8b 72 04             	mov    0x4(%edx),%esi
  801cba:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801cc0:	8b 5a 10             	mov    0x10(%edx),%ebx
  801cc3:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801cc9:	8b 42 14             	mov    0x14(%edx),%eax
  801ccc:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801cd2:	8b 4a 08             	mov    0x8(%edx),%ecx
  801cd5:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
	if ((i = PGOFF(va)))
  801cdb:	89 c8                	mov    %ecx,%eax
  801cdd:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ce2:	74 1e                	je     801d02 <spawn+0x40e>
		va -= i;
  801ce4:	29 c1                	sub    %eax,%ecx
  801ce6:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
		memsz += i;
  801cec:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801cf2:	01 c3                	add    %eax,%ebx
  801cf4:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801cfa:	29 c6                	sub    %eax,%esi
  801cfc:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE)
  801d02:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d07:	e9 f5 fe ff ff       	jmp    801c01 <spawn+0x30d>
	close(fd);
  801d0c:	83 ec 0c             	sub    $0xc,%esp
  801d0f:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801d15:	e8 94 f5 ff ff       	call   8012ae <close>
  801d1a:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int r, pn;
	struct Env *e;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801d1d:	bb 00 08 00 00       	mov    $0x800,%ebx
  801d22:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801d28:	eb 0f                	jmp    801d39 <spawn+0x445>
  801d2a:	83 c3 01             	add    $0x1,%ebx
  801d2d:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801d33:	0f 84 c2 00 00 00    	je     801dfb <spawn+0x507>
	{
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  801d39:	89 d8                	mov    %ebx,%eax
  801d3b:	c1 f8 0a             	sar    $0xa,%eax
  801d3e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d45:	a8 01                	test   $0x1,%al
  801d47:	74 e1                	je     801d2a <spawn+0x436>
  801d49:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801d50:	a8 01                	test   $0x1,%al
  801d52:	74 d6                	je     801d2a <spawn+0x436>
		{
			if (uvpt[pn] & PTE_SHARE)
  801d54:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801d5b:	f6 c4 04             	test   $0x4,%ah
  801d5e:	74 ca                	je     801d2a <spawn+0x436>
			{
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
									  child, (void *)(pn * PGSIZE),
									  uvpt[pn] & PTE_SYSCALL)) < 0)
  801d60:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801d67:	89 da                	mov    %ebx,%edx
  801d69:	c1 e2 0c             	shl    $0xc,%edx
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
  801d6c:	83 ec 0c             	sub    $0xc,%esp
  801d6f:	25 07 0e 00 00       	and    $0xe07,%eax
  801d74:	50                   	push   %eax
  801d75:	52                   	push   %edx
  801d76:	56                   	push   %esi
  801d77:	52                   	push   %edx
  801d78:	6a 00                	push   $0x0
  801d7a:	e8 b7 f1 ff ff       	call   800f36 <sys_page_map>
  801d7f:	83 c4 20             	add    $0x20,%esp
  801d82:	85 c0                	test   %eax,%eax
  801d84:	79 a4                	jns    801d2a <spawn+0x436>
		panic("copy_shared_pages: %e", r);
  801d86:	50                   	push   %eax
  801d87:	68 43 30 80 00       	push   $0x803043
  801d8c:	68 82 00 00 00       	push   $0x82
  801d91:	68 e9 2f 80 00       	push   $0x802fe9
  801d96:	e8 65 e6 ff ff       	call   800400 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801d9b:	50                   	push   %eax
  801d9c:	68 12 30 80 00       	push   $0x803012
  801da1:	68 86 00 00 00       	push   $0x86
  801da6:	68 e9 2f 80 00       	push   $0x802fe9
  801dab:	e8 50 e6 ff ff       	call   800400 <_panic>
		panic("sys_env_set_status: %e", r);
  801db0:	50                   	push   %eax
  801db1:	68 2c 30 80 00       	push   $0x80302c
  801db6:	68 89 00 00 00       	push   $0x89
  801dbb:	68 e9 2f 80 00       	push   $0x802fe9
  801dc0:	e8 3b e6 ff ff       	call   800400 <_panic>
		return r;
  801dc5:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dcb:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801dd1:	e9 85 fe ff ff       	jmp    801c5b <spawn+0x367>
		return -E_NO_MEM;
  801dd6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801ddb:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801de1:	e9 75 fe ff ff       	jmp    801c5b <spawn+0x367>
  801de6:	89 c7                	mov    %eax,%edi
  801de8:	e9 49 fe ff ff       	jmp    801c36 <spawn+0x342>
  801ded:	89 c7                	mov    %eax,%edi
  801def:	e9 42 fe ff ff       	jmp    801c36 <spawn+0x342>
  801df4:	89 c7                	mov    %eax,%edi
  801df6:	e9 3b fe ff ff       	jmp    801c36 <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3; // devious: see user/faultio.c
  801dfb:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e02:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e05:	83 ec 08             	sub    $0x8,%esp
  801e08:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e0e:	50                   	push   %eax
  801e0f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e15:	e8 e2 f1 ff ff       	call   800ffc <sys_env_set_trapframe>
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	0f 88 76 ff ff ff    	js     801d9b <spawn+0x4a7>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e25:	83 ec 08             	sub    $0x8,%esp
  801e28:	6a 02                	push   $0x2
  801e2a:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e30:	e8 85 f1 ff ff       	call   800fba <sys_env_set_status>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	0f 88 70 ff ff ff    	js     801db0 <spawn+0x4bc>
	return child;
  801e40:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e46:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801e4c:	e9 0a fe ff ff       	jmp    801c5b <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801e51:	83 ec 08             	sub    $0x8,%esp
  801e54:	68 00 00 40 00       	push   $0x400000
  801e59:	6a 00                	push   $0x0
  801e5b:	e8 18 f1 ff ff       	call   800f78 <sys_page_unmap>
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801e69:	e9 ed fd ff ff       	jmp    801c5b <spawn+0x367>

00801e6e <spawnl>:
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	57                   	push   %edi
  801e72:	56                   	push   %esi
  801e73:	53                   	push   %ebx
  801e74:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801e77:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  801e7f:	eb 05                	jmp    801e86 <spawnl+0x18>
		argc++;
  801e81:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  801e84:	89 ca                	mov    %ecx,%edx
  801e86:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e89:	83 3a 00             	cmpl   $0x0,(%edx)
  801e8c:	75 f3                	jne    801e81 <spawnl+0x13>
	const char *argv[argc + 2];
  801e8e:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801e95:	83 e2 f0             	and    $0xfffffff0,%edx
  801e98:	29 d4                	sub    %edx,%esp
  801e9a:	8d 54 24 03          	lea    0x3(%esp),%edx
  801e9e:	c1 ea 02             	shr    $0x2,%edx
  801ea1:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ea8:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ead:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  801eb4:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801ebb:	00 
	va_start(vl, arg0);
  801ebc:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801ebf:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec6:	eb 0b                	jmp    801ed3 <spawnl+0x65>
		argv[i + 1] = va_arg(vl, const char *);
  801ec8:	83 c0 01             	add    $0x1,%eax
  801ecb:	8b 39                	mov    (%ecx),%edi
  801ecd:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ed0:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  801ed3:	39 d0                	cmp    %edx,%eax
  801ed5:	75 f1                	jne    801ec8 <spawnl+0x5a>
	return spawn(prog, argv);
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	56                   	push   %esi
  801edb:	ff 75 08             	pushl  0x8(%ebp)
  801ede:	e8 11 fa ff ff       	call   8018f4 <spawn>
}
  801ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee6:	5b                   	pop    %ebx
  801ee7:	5e                   	pop    %esi
  801ee8:	5f                   	pop    %edi
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    

00801eeb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ef1:	68 84 30 80 00       	push   $0x803084
  801ef6:	ff 75 0c             	pushl  0xc(%ebp)
  801ef9:	e8 fc eb ff ff       	call   800afa <strcpy>
	return 0;
}
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <devsock_close>:
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	53                   	push   %ebx
  801f09:	83 ec 10             	sub    $0x10,%esp
  801f0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f0f:	53                   	push   %ebx
  801f10:	e8 cb 08 00 00       	call   8027e0 <pageref>
  801f15:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f18:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f1d:	83 f8 01             	cmp    $0x1,%eax
  801f20:	74 07                	je     801f29 <devsock_close+0x24>
}
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	ff 73 0c             	pushl  0xc(%ebx)
  801f2f:	e8 b7 02 00 00       	call   8021eb <nsipc_close>
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	eb e7                	jmp    801f22 <devsock_close+0x1d>

00801f3b <devsock_write>:
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f41:	6a 00                	push   $0x0
  801f43:	ff 75 10             	pushl  0x10(%ebp)
  801f46:	ff 75 0c             	pushl  0xc(%ebp)
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	ff 70 0c             	pushl  0xc(%eax)
  801f4f:	e8 74 03 00 00       	call   8022c8 <nsipc_send>
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <devsock_read>:
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	ff 75 10             	pushl  0x10(%ebp)
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	ff 70 0c             	pushl  0xc(%eax)
  801f6a:	e8 ed 02 00 00       	call   80225c <nsipc_recv>
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <fd2sockid>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f77:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	e8 f8 f1 ff ff       	call   801179 <fd_lookup>
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 10                	js     801f98 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  801f91:	39 08                	cmp    %ecx,(%eax)
  801f93:	75 05                	jne    801f9a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f95:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    
		return -E_NOT_SUPP;
  801f9a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f9f:	eb f7                	jmp    801f98 <fd2sockid+0x27>

00801fa1 <alloc_sockfd>:
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	56                   	push   %esi
  801fa5:	53                   	push   %ebx
  801fa6:	83 ec 1c             	sub    $0x1c,%esp
  801fa9:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fae:	50                   	push   %eax
  801faf:	e8 76 f1 ff ff       	call   80112a <fd_alloc>
  801fb4:	89 c3                	mov    %eax,%ebx
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	78 43                	js     802000 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	68 07 04 00 00       	push   $0x407
  801fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 24 ef ff ff       	call   800ef3 <sys_page_alloc>
  801fcf:	89 c3                	mov    %eax,%ebx
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 28                	js     802000 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdb:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  801fe1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fed:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	50                   	push   %eax
  801ff4:	e8 0a f1 ff ff       	call   801103 <fd2num>
  801ff9:	89 c3                	mov    %eax,%ebx
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	eb 0c                	jmp    80200c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	56                   	push   %esi
  802004:	e8 e2 01 00 00       	call   8021eb <nsipc_close>
		return r;
  802009:	83 c4 10             	add    $0x10,%esp
}
  80200c:	89 d8                	mov    %ebx,%eax
  80200e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802011:	5b                   	pop    %ebx
  802012:	5e                   	pop    %esi
  802013:	5d                   	pop    %ebp
  802014:	c3                   	ret    

00802015 <accept>:
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	e8 4e ff ff ff       	call   801f71 <fd2sockid>
  802023:	85 c0                	test   %eax,%eax
  802025:	78 1b                	js     802042 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	ff 75 10             	pushl  0x10(%ebp)
  80202d:	ff 75 0c             	pushl  0xc(%ebp)
  802030:	50                   	push   %eax
  802031:	e8 0e 01 00 00       	call   802144 <nsipc_accept>
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	85 c0                	test   %eax,%eax
  80203b:	78 05                	js     802042 <accept+0x2d>
	return alloc_sockfd(r);
  80203d:	e8 5f ff ff ff       	call   801fa1 <alloc_sockfd>
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <bind>:
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	e8 1f ff ff ff       	call   801f71 <fd2sockid>
  802052:	85 c0                	test   %eax,%eax
  802054:	78 12                	js     802068 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	ff 75 10             	pushl  0x10(%ebp)
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	50                   	push   %eax
  802060:	e8 2f 01 00 00       	call   802194 <nsipc_bind>
  802065:	83 c4 10             	add    $0x10,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <shutdown>:
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	e8 f9 fe ff ff       	call   801f71 <fd2sockid>
  802078:	85 c0                	test   %eax,%eax
  80207a:	78 0f                	js     80208b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80207c:	83 ec 08             	sub    $0x8,%esp
  80207f:	ff 75 0c             	pushl  0xc(%ebp)
  802082:	50                   	push   %eax
  802083:	e8 41 01 00 00       	call   8021c9 <nsipc_shutdown>
  802088:	83 c4 10             	add    $0x10,%esp
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <connect>:
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	e8 d6 fe ff ff       	call   801f71 <fd2sockid>
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 12                	js     8020b1 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	ff 75 10             	pushl  0x10(%ebp)
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	50                   	push   %eax
  8020a9:	e8 57 01 00 00       	call   802205 <nsipc_connect>
  8020ae:	83 c4 10             	add    $0x10,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <listen>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	e8 b0 fe ff ff       	call   801f71 <fd2sockid>
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	78 0f                	js     8020d4 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020c5:	83 ec 08             	sub    $0x8,%esp
  8020c8:	ff 75 0c             	pushl  0xc(%ebp)
  8020cb:	50                   	push   %eax
  8020cc:	e8 69 01 00 00       	call   80223a <nsipc_listen>
  8020d1:	83 c4 10             	add    $0x10,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020dc:	ff 75 10             	pushl  0x10(%ebp)
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	e8 3c 02 00 00       	call   802326 <nsipc_socket>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 05                	js     8020f6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020f1:	e8 ab fe ff ff       	call   801fa1 <alloc_sockfd>
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 04             	sub    $0x4,%esp
  8020ff:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802101:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802108:	74 26                	je     802130 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80210a:	6a 07                	push   $0x7
  80210c:	68 00 90 80 00       	push   $0x809000
  802111:	53                   	push   %ebx
  802112:	ff 35 04 60 80 00    	pushl  0x806004
  802118:	e8 36 06 00 00       	call   802753 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80211d:	83 c4 0c             	add    $0xc,%esp
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	e8 c1 05 00 00       	call   8026ec <ipc_recv>
}
  80212b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	6a 02                	push   $0x2
  802135:	e8 6d 06 00 00       	call   8027a7 <ipc_find_env>
  80213a:	a3 04 60 80 00       	mov    %eax,0x806004
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	eb c6                	jmp    80210a <nsipc+0x12>

00802144 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802154:	8b 06                	mov    (%esi),%eax
  802156:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80215b:	b8 01 00 00 00       	mov    $0x1,%eax
  802160:	e8 93 ff ff ff       	call   8020f8 <nsipc>
  802165:	89 c3                	mov    %eax,%ebx
  802167:	85 c0                	test   %eax,%eax
  802169:	78 20                	js     80218b <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80216b:	83 ec 04             	sub    $0x4,%esp
  80216e:	ff 35 10 90 80 00    	pushl  0x809010
  802174:	68 00 90 80 00       	push   $0x809000
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	e8 07 eb ff ff       	call   800c88 <memmove>
		*addrlen = ret->ret_addrlen;
  802181:	a1 10 90 80 00       	mov    0x809010,%eax
  802186:	89 06                	mov    %eax,(%esi)
  802188:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80218b:	89 d8                	mov    %ebx,%eax
  80218d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802190:	5b                   	pop    %ebx
  802191:	5e                   	pop    %esi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    

00802194 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	53                   	push   %ebx
  802198:	83 ec 08             	sub    $0x8,%esp
  80219b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021a6:	53                   	push   %ebx
  8021a7:	ff 75 0c             	pushl  0xc(%ebp)
  8021aa:	68 04 90 80 00       	push   $0x809004
  8021af:	e8 d4 ea ff ff       	call   800c88 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021b4:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8021ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8021bf:	e8 34 ff ff ff       	call   8020f8 <nsipc>
}
  8021c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  8021d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021da:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  8021df:	b8 03 00 00 00       	mov    $0x3,%eax
  8021e4:	e8 0f ff ff ff       	call   8020f8 <nsipc>
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <nsipc_close>:

int
nsipc_close(int s)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  8021f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8021fe:	e8 f5 fe ff ff       	call   8020f8 <nsipc>
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	53                   	push   %ebx
  802209:	83 ec 08             	sub    $0x8,%esp
  80220c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802217:	53                   	push   %ebx
  802218:	ff 75 0c             	pushl  0xc(%ebp)
  80221b:	68 04 90 80 00       	push   $0x809004
  802220:	e8 63 ea ff ff       	call   800c88 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802225:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  80222b:	b8 05 00 00 00       	mov    $0x5,%eax
  802230:	e8 c3 fe ff ff       	call   8020f8 <nsipc>
}
  802235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224b:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  802250:	b8 06 00 00 00       	mov    $0x6,%eax
  802255:	e8 9e fe ff ff       	call   8020f8 <nsipc>
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	56                   	push   %esi
  802260:	53                   	push   %ebx
  802261:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  80226c:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  802272:	8b 45 14             	mov    0x14(%ebp),%eax
  802275:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80227a:	b8 07 00 00 00       	mov    $0x7,%eax
  80227f:	e8 74 fe ff ff       	call   8020f8 <nsipc>
  802284:	89 c3                	mov    %eax,%ebx
  802286:	85 c0                	test   %eax,%eax
  802288:	78 1f                	js     8022a9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80228a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80228f:	7f 21                	jg     8022b2 <nsipc_recv+0x56>
  802291:	39 c6                	cmp    %eax,%esi
  802293:	7c 1d                	jl     8022b2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	50                   	push   %eax
  802299:	68 00 90 80 00       	push   $0x809000
  80229e:	ff 75 0c             	pushl  0xc(%ebp)
  8022a1:	e8 e2 e9 ff ff       	call   800c88 <memmove>
  8022a6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022a9:	89 d8                	mov    %ebx,%eax
  8022ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ae:	5b                   	pop    %ebx
  8022af:	5e                   	pop    %esi
  8022b0:	5d                   	pop    %ebp
  8022b1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022b2:	68 90 30 80 00       	push   $0x803090
  8022b7:	68 a3 2f 80 00       	push   $0x802fa3
  8022bc:	6a 62                	push   $0x62
  8022be:	68 a5 30 80 00       	push   $0x8030a5
  8022c3:	e8 38 e1 ff ff       	call   800400 <_panic>

008022c8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	53                   	push   %ebx
  8022cc:	83 ec 04             	sub    $0x4,%esp
  8022cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  8022da:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022e0:	7f 2e                	jg     802310 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	53                   	push   %ebx
  8022e6:	ff 75 0c             	pushl  0xc(%ebp)
  8022e9:	68 0c 90 80 00       	push   $0x80900c
  8022ee:	e8 95 e9 ff ff       	call   800c88 <memmove>
	nsipcbuf.send.req_size = size;
  8022f3:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  8022f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022fc:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  802301:	b8 08 00 00 00       	mov    $0x8,%eax
  802306:	e8 ed fd ff ff       	call   8020f8 <nsipc>
}
  80230b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    
	assert(size < 1600);
  802310:	68 b1 30 80 00       	push   $0x8030b1
  802315:	68 a3 2f 80 00       	push   $0x802fa3
  80231a:	6a 6d                	push   $0x6d
  80231c:	68 a5 30 80 00       	push   $0x8030a5
  802321:	e8 da e0 ff ff       	call   800400 <_panic>

00802326 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  802334:	8b 45 0c             	mov    0xc(%ebp),%eax
  802337:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  80233c:	8b 45 10             	mov    0x10(%ebp),%eax
  80233f:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  802344:	b8 09 00 00 00       	mov    $0x9,%eax
  802349:	e8 aa fd ff ff       	call   8020f8 <nsipc>
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	56                   	push   %esi
  802354:	53                   	push   %ebx
  802355:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802358:	83 ec 0c             	sub    $0xc,%esp
  80235b:	ff 75 08             	pushl  0x8(%ebp)
  80235e:	e8 b0 ed ff ff       	call   801113 <fd2data>
  802363:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802365:	83 c4 08             	add    $0x8,%esp
  802368:	68 bd 30 80 00       	push   $0x8030bd
  80236d:	53                   	push   %ebx
  80236e:	e8 87 e7 ff ff       	call   800afa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802373:	8b 46 04             	mov    0x4(%esi),%eax
  802376:	2b 06                	sub    (%esi),%eax
  802378:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80237e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802385:	00 00 00 
	stat->st_dev = &devpipe;
  802388:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  80238f:	57 80 00 
	return 0;
}
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
  802397:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239a:	5b                   	pop    %ebx
  80239b:	5e                   	pop    %esi
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	53                   	push   %ebx
  8023a2:	83 ec 0c             	sub    $0xc,%esp
  8023a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023a8:	53                   	push   %ebx
  8023a9:	6a 00                	push   $0x0
  8023ab:	e8 c8 eb ff ff       	call   800f78 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023b0:	89 1c 24             	mov    %ebx,(%esp)
  8023b3:	e8 5b ed ff ff       	call   801113 <fd2data>
  8023b8:	83 c4 08             	add    $0x8,%esp
  8023bb:	50                   	push   %eax
  8023bc:	6a 00                	push   $0x0
  8023be:	e8 b5 eb ff ff       	call   800f78 <sys_page_unmap>
}
  8023c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <_pipeisclosed>:
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	57                   	push   %edi
  8023cc:	56                   	push   %esi
  8023cd:	53                   	push   %ebx
  8023ce:	83 ec 1c             	sub    $0x1c,%esp
  8023d1:	89 c7                	mov    %eax,%edi
  8023d3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023d5:	a1 90 77 80 00       	mov    0x807790,%eax
  8023da:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023dd:	83 ec 0c             	sub    $0xc,%esp
  8023e0:	57                   	push   %edi
  8023e1:	e8 fa 03 00 00       	call   8027e0 <pageref>
  8023e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023e9:	89 34 24             	mov    %esi,(%esp)
  8023ec:	e8 ef 03 00 00       	call   8027e0 <pageref>
		nn = thisenv->env_runs;
  8023f1:	8b 15 90 77 80 00    	mov    0x807790,%edx
  8023f7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	39 cb                	cmp    %ecx,%ebx
  8023ff:	74 1b                	je     80241c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802401:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802404:	75 cf                	jne    8023d5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802406:	8b 42 58             	mov    0x58(%edx),%eax
  802409:	6a 01                	push   $0x1
  80240b:	50                   	push   %eax
  80240c:	53                   	push   %ebx
  80240d:	68 c4 30 80 00       	push   $0x8030c4
  802412:	e8 c4 e0 ff ff       	call   8004db <cprintf>
  802417:	83 c4 10             	add    $0x10,%esp
  80241a:	eb b9                	jmp    8023d5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80241c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80241f:	0f 94 c0             	sete   %al
  802422:	0f b6 c0             	movzbl %al,%eax
}
  802425:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802428:	5b                   	pop    %ebx
  802429:	5e                   	pop    %esi
  80242a:	5f                   	pop    %edi
  80242b:	5d                   	pop    %ebp
  80242c:	c3                   	ret    

0080242d <devpipe_write>:
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	57                   	push   %edi
  802431:	56                   	push   %esi
  802432:	53                   	push   %ebx
  802433:	83 ec 28             	sub    $0x28,%esp
  802436:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802439:	56                   	push   %esi
  80243a:	e8 d4 ec ff ff       	call   801113 <fd2data>
  80243f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802441:	83 c4 10             	add    $0x10,%esp
  802444:	bf 00 00 00 00       	mov    $0x0,%edi
  802449:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80244c:	74 4f                	je     80249d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80244e:	8b 43 04             	mov    0x4(%ebx),%eax
  802451:	8b 0b                	mov    (%ebx),%ecx
  802453:	8d 51 20             	lea    0x20(%ecx),%edx
  802456:	39 d0                	cmp    %edx,%eax
  802458:	72 14                	jb     80246e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80245a:	89 da                	mov    %ebx,%edx
  80245c:	89 f0                	mov    %esi,%eax
  80245e:	e8 65 ff ff ff       	call   8023c8 <_pipeisclosed>
  802463:	85 c0                	test   %eax,%eax
  802465:	75 3a                	jne    8024a1 <devpipe_write+0x74>
			sys_yield();
  802467:	e8 68 ea ff ff       	call   800ed4 <sys_yield>
  80246c:	eb e0                	jmp    80244e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80246e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802471:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802475:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802478:	89 c2                	mov    %eax,%edx
  80247a:	c1 fa 1f             	sar    $0x1f,%edx
  80247d:	89 d1                	mov    %edx,%ecx
  80247f:	c1 e9 1b             	shr    $0x1b,%ecx
  802482:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802485:	83 e2 1f             	and    $0x1f,%edx
  802488:	29 ca                	sub    %ecx,%edx
  80248a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80248e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802492:	83 c0 01             	add    $0x1,%eax
  802495:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802498:	83 c7 01             	add    $0x1,%edi
  80249b:	eb ac                	jmp    802449 <devpipe_write+0x1c>
	return i;
  80249d:	89 f8                	mov    %edi,%eax
  80249f:	eb 05                	jmp    8024a6 <devpipe_write+0x79>
				return 0;
  8024a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a9:	5b                   	pop    %ebx
  8024aa:	5e                   	pop    %esi
  8024ab:	5f                   	pop    %edi
  8024ac:	5d                   	pop    %ebp
  8024ad:	c3                   	ret    

008024ae <devpipe_read>:
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 18             	sub    $0x18,%esp
  8024b7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024ba:	57                   	push   %edi
  8024bb:	e8 53 ec ff ff       	call   801113 <fd2data>
  8024c0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024c2:	83 c4 10             	add    $0x10,%esp
  8024c5:	be 00 00 00 00       	mov    $0x0,%esi
  8024ca:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024cd:	74 47                	je     802516 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8024cf:	8b 03                	mov    (%ebx),%eax
  8024d1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024d4:	75 22                	jne    8024f8 <devpipe_read+0x4a>
			if (i > 0)
  8024d6:	85 f6                	test   %esi,%esi
  8024d8:	75 14                	jne    8024ee <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8024da:	89 da                	mov    %ebx,%edx
  8024dc:	89 f8                	mov    %edi,%eax
  8024de:	e8 e5 fe ff ff       	call   8023c8 <_pipeisclosed>
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	75 33                	jne    80251a <devpipe_read+0x6c>
			sys_yield();
  8024e7:	e8 e8 e9 ff ff       	call   800ed4 <sys_yield>
  8024ec:	eb e1                	jmp    8024cf <devpipe_read+0x21>
				return i;
  8024ee:	89 f0                	mov    %esi,%eax
}
  8024f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f3:	5b                   	pop    %ebx
  8024f4:	5e                   	pop    %esi
  8024f5:	5f                   	pop    %edi
  8024f6:	5d                   	pop    %ebp
  8024f7:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024f8:	99                   	cltd   
  8024f9:	c1 ea 1b             	shr    $0x1b,%edx
  8024fc:	01 d0                	add    %edx,%eax
  8024fe:	83 e0 1f             	and    $0x1f,%eax
  802501:	29 d0                	sub    %edx,%eax
  802503:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802508:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80250b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80250e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802511:	83 c6 01             	add    $0x1,%esi
  802514:	eb b4                	jmp    8024ca <devpipe_read+0x1c>
	return i;
  802516:	89 f0                	mov    %esi,%eax
  802518:	eb d6                	jmp    8024f0 <devpipe_read+0x42>
				return 0;
  80251a:	b8 00 00 00 00       	mov    $0x0,%eax
  80251f:	eb cf                	jmp    8024f0 <devpipe_read+0x42>

00802521 <pipe>:
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	56                   	push   %esi
  802525:	53                   	push   %ebx
  802526:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802529:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252c:	50                   	push   %eax
  80252d:	e8 f8 eb ff ff       	call   80112a <fd_alloc>
  802532:	89 c3                	mov    %eax,%ebx
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	85 c0                	test   %eax,%eax
  802539:	78 5b                	js     802596 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	68 07 04 00 00       	push   $0x407
  802543:	ff 75 f4             	pushl  -0xc(%ebp)
  802546:	6a 00                	push   $0x0
  802548:	e8 a6 e9 ff ff       	call   800ef3 <sys_page_alloc>
  80254d:	89 c3                	mov    %eax,%ebx
  80254f:	83 c4 10             	add    $0x10,%esp
  802552:	85 c0                	test   %eax,%eax
  802554:	78 40                	js     802596 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802556:	83 ec 0c             	sub    $0xc,%esp
  802559:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80255c:	50                   	push   %eax
  80255d:	e8 c8 eb ff ff       	call   80112a <fd_alloc>
  802562:	89 c3                	mov    %eax,%ebx
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	85 c0                	test   %eax,%eax
  802569:	78 1b                	js     802586 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 07 04 00 00       	push   $0x407
  802573:	ff 75 f0             	pushl  -0x10(%ebp)
  802576:	6a 00                	push   $0x0
  802578:	e8 76 e9 ff ff       	call   800ef3 <sys_page_alloc>
  80257d:	89 c3                	mov    %eax,%ebx
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	85 c0                	test   %eax,%eax
  802584:	79 19                	jns    80259f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802586:	83 ec 08             	sub    $0x8,%esp
  802589:	ff 75 f4             	pushl  -0xc(%ebp)
  80258c:	6a 00                	push   $0x0
  80258e:	e8 e5 e9 ff ff       	call   800f78 <sys_page_unmap>
  802593:	83 c4 10             	add    $0x10,%esp
}
  802596:	89 d8                	mov    %ebx,%eax
  802598:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80259b:	5b                   	pop    %ebx
  80259c:	5e                   	pop    %esi
  80259d:	5d                   	pop    %ebp
  80259e:	c3                   	ret    
	va = fd2data(fd0);
  80259f:	83 ec 0c             	sub    $0xc,%esp
  8025a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a5:	e8 69 eb ff ff       	call   801113 <fd2data>
  8025aa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ac:	83 c4 0c             	add    $0xc,%esp
  8025af:	68 07 04 00 00       	push   $0x407
  8025b4:	50                   	push   %eax
  8025b5:	6a 00                	push   $0x0
  8025b7:	e8 37 e9 ff ff       	call   800ef3 <sys_page_alloc>
  8025bc:	89 c3                	mov    %eax,%ebx
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	0f 88 8c 00 00 00    	js     802655 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8025cf:	e8 3f eb ff ff       	call   801113 <fd2data>
  8025d4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025db:	50                   	push   %eax
  8025dc:	6a 00                	push   $0x0
  8025de:	56                   	push   %esi
  8025df:	6a 00                	push   $0x0
  8025e1:	e8 50 e9 ff ff       	call   800f36 <sys_page_map>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	83 c4 20             	add    $0x20,%esp
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	78 58                	js     802647 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  8025f8:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  80260d:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	ff 75 f4             	pushl  -0xc(%ebp)
  80261f:	e8 df ea ff ff       	call   801103 <fd2num>
  802624:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802627:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802629:	83 c4 04             	add    $0x4,%esp
  80262c:	ff 75 f0             	pushl  -0x10(%ebp)
  80262f:	e8 cf ea ff ff       	call   801103 <fd2num>
  802634:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802637:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80263a:	83 c4 10             	add    $0x10,%esp
  80263d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802642:	e9 4f ff ff ff       	jmp    802596 <pipe+0x75>
	sys_page_unmap(0, va);
  802647:	83 ec 08             	sub    $0x8,%esp
  80264a:	56                   	push   %esi
  80264b:	6a 00                	push   $0x0
  80264d:	e8 26 e9 ff ff       	call   800f78 <sys_page_unmap>
  802652:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802655:	83 ec 08             	sub    $0x8,%esp
  802658:	ff 75 f0             	pushl  -0x10(%ebp)
  80265b:	6a 00                	push   $0x0
  80265d:	e8 16 e9 ff ff       	call   800f78 <sys_page_unmap>
  802662:	83 c4 10             	add    $0x10,%esp
  802665:	e9 1c ff ff ff       	jmp    802586 <pipe+0x65>

0080266a <pipeisclosed>:
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802670:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802673:	50                   	push   %eax
  802674:	ff 75 08             	pushl  0x8(%ebp)
  802677:	e8 fd ea ff ff       	call   801179 <fd_lookup>
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 18                	js     80269b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	ff 75 f4             	pushl  -0xc(%ebp)
  802689:	e8 85 ea ff ff       	call   801113 <fd2data>
	return _pipeisclosed(fd, p);
  80268e:	89 c2                	mov    %eax,%edx
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	e8 30 fd ff ff       	call   8023c8 <_pipeisclosed>
  802698:	83 c4 10             	add    $0x10,%esp
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	56                   	push   %esi
  8026a1:	53                   	push   %ebx
  8026a2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8026a5:	85 f6                	test   %esi,%esi
  8026a7:	74 13                	je     8026bc <wait+0x1f>
	e = &envs[ENVX(envid)];
  8026a9:	89 f3                	mov    %esi,%ebx
  8026ab:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026b1:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8026b4:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8026ba:	eb 1b                	jmp    8026d7 <wait+0x3a>
	assert(envid != 0);
  8026bc:	68 dc 30 80 00       	push   $0x8030dc
  8026c1:	68 a3 2f 80 00       	push   $0x802fa3
  8026c6:	6a 09                	push   $0x9
  8026c8:	68 e7 30 80 00       	push   $0x8030e7
  8026cd:	e8 2e dd ff ff       	call   800400 <_panic>
		sys_yield();
  8026d2:	e8 fd e7 ff ff       	call   800ed4 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026d7:	8b 43 48             	mov    0x48(%ebx),%eax
  8026da:	39 f0                	cmp    %esi,%eax
  8026dc:	75 07                	jne    8026e5 <wait+0x48>
  8026de:	8b 43 54             	mov    0x54(%ebx),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	75 ed                	jne    8026d2 <wait+0x35>
}
  8026e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026e8:	5b                   	pop    %ebx
  8026e9:	5e                   	pop    %esi
  8026ea:	5d                   	pop    %ebp
  8026eb:	c3                   	ret    

008026ec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	56                   	push   %esi
  8026f0:	53                   	push   %ebx
  8026f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8026f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8026fa:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8026fc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802701:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802704:	83 ec 0c             	sub    $0xc,%esp
  802707:	50                   	push   %eax
  802708:	e8 96 e9 ff ff       	call   8010a3 <sys_ipc_recv>
	if (from_env_store)
  80270d:	83 c4 10             	add    $0x10,%esp
  802710:	85 f6                	test   %esi,%esi
  802712:	74 14                	je     802728 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802714:	ba 00 00 00 00       	mov    $0x0,%edx
  802719:	85 c0                	test   %eax,%eax
  80271b:	78 09                	js     802726 <ipc_recv+0x3a>
  80271d:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802723:	8b 52 74             	mov    0x74(%edx),%edx
  802726:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802728:	85 db                	test   %ebx,%ebx
  80272a:	74 14                	je     802740 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  80272c:	ba 00 00 00 00       	mov    $0x0,%edx
  802731:	85 c0                	test   %eax,%eax
  802733:	78 09                	js     80273e <ipc_recv+0x52>
  802735:	8b 15 90 77 80 00    	mov    0x807790,%edx
  80273b:	8b 52 78             	mov    0x78(%edx),%edx
  80273e:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802740:	85 c0                	test   %eax,%eax
  802742:	78 08                	js     80274c <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802744:	a1 90 77 80 00       	mov    0x807790,%eax
  802749:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  80274c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5d                   	pop    %ebp
  802752:	c3                   	ret    

00802753 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	57                   	push   %edi
  802757:	56                   	push   %esi
  802758:	53                   	push   %ebx
  802759:	83 ec 0c             	sub    $0xc,%esp
  80275c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80275f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802762:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802765:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802767:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80276c:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80276f:	ff 75 14             	pushl  0x14(%ebp)
  802772:	53                   	push   %ebx
  802773:	56                   	push   %esi
  802774:	57                   	push   %edi
  802775:	e8 06 e9 ff ff       	call   801080 <sys_ipc_try_send>
		if (ret == 0)
  80277a:	83 c4 10             	add    $0x10,%esp
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 1e                	je     80279f <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802781:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802784:	75 07                	jne    80278d <ipc_send+0x3a>
			sys_yield();
  802786:	e8 49 e7 ff ff       	call   800ed4 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80278b:	eb e2                	jmp    80276f <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80278d:	50                   	push   %eax
  80278e:	68 f2 30 80 00       	push   $0x8030f2
  802793:	6a 3d                	push   $0x3d
  802795:	68 06 31 80 00       	push   $0x803106
  80279a:	e8 61 dc ff ff       	call   800400 <_panic>
	}
	// panic("ipc_send not implemented");
}
  80279f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a2:	5b                   	pop    %ebx
  8027a3:	5e                   	pop    %esi
  8027a4:	5f                   	pop    %edi
  8027a5:	5d                   	pop    %ebp
  8027a6:	c3                   	ret    

008027a7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027b2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8027b5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027bb:	8b 52 50             	mov    0x50(%edx),%edx
  8027be:	39 ca                	cmp    %ecx,%edx
  8027c0:	74 11                	je     8027d3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8027c2:	83 c0 01             	add    $0x1,%eax
  8027c5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027ca:	75 e6                	jne    8027b2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d1:	eb 0b                	jmp    8027de <ipc_find_env+0x37>
			return envs[i].env_id;
  8027d3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027db:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027de:	5d                   	pop    %ebp
  8027df:	c3                   	ret    

008027e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027e6:	89 d0                	mov    %edx,%eax
  8027e8:	c1 e8 16             	shr    $0x16,%eax
  8027eb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027f2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8027f7:	f6 c1 01             	test   $0x1,%cl
  8027fa:	74 1d                	je     802819 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8027fc:	c1 ea 0c             	shr    $0xc,%edx
  8027ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802806:	f6 c2 01             	test   $0x1,%dl
  802809:	74 0e                	je     802819 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80280b:	c1 ea 0c             	shr    $0xc,%edx
  80280e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802815:	ef 
  802816:	0f b7 c0             	movzwl %ax,%eax
}
  802819:	5d                   	pop    %ebp
  80281a:	c3                   	ret    
  80281b:	66 90                	xchg   %ax,%ax
  80281d:	66 90                	xchg   %ax,%ax
  80281f:	90                   	nop

00802820 <__udivdi3>:
  802820:	55                   	push   %ebp
  802821:	57                   	push   %edi
  802822:	56                   	push   %esi
  802823:	53                   	push   %ebx
  802824:	83 ec 1c             	sub    $0x1c,%esp
  802827:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80282b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80282f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802833:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802837:	85 d2                	test   %edx,%edx
  802839:	75 35                	jne    802870 <__udivdi3+0x50>
  80283b:	39 f3                	cmp    %esi,%ebx
  80283d:	0f 87 bd 00 00 00    	ja     802900 <__udivdi3+0xe0>
  802843:	85 db                	test   %ebx,%ebx
  802845:	89 d9                	mov    %ebx,%ecx
  802847:	75 0b                	jne    802854 <__udivdi3+0x34>
  802849:	b8 01 00 00 00       	mov    $0x1,%eax
  80284e:	31 d2                	xor    %edx,%edx
  802850:	f7 f3                	div    %ebx
  802852:	89 c1                	mov    %eax,%ecx
  802854:	31 d2                	xor    %edx,%edx
  802856:	89 f0                	mov    %esi,%eax
  802858:	f7 f1                	div    %ecx
  80285a:	89 c6                	mov    %eax,%esi
  80285c:	89 e8                	mov    %ebp,%eax
  80285e:	89 f7                	mov    %esi,%edi
  802860:	f7 f1                	div    %ecx
  802862:	89 fa                	mov    %edi,%edx
  802864:	83 c4 1c             	add    $0x1c,%esp
  802867:	5b                   	pop    %ebx
  802868:	5e                   	pop    %esi
  802869:	5f                   	pop    %edi
  80286a:	5d                   	pop    %ebp
  80286b:	c3                   	ret    
  80286c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802870:	39 f2                	cmp    %esi,%edx
  802872:	77 7c                	ja     8028f0 <__udivdi3+0xd0>
  802874:	0f bd fa             	bsr    %edx,%edi
  802877:	83 f7 1f             	xor    $0x1f,%edi
  80287a:	0f 84 98 00 00 00    	je     802918 <__udivdi3+0xf8>
  802880:	89 f9                	mov    %edi,%ecx
  802882:	b8 20 00 00 00       	mov    $0x20,%eax
  802887:	29 f8                	sub    %edi,%eax
  802889:	d3 e2                	shl    %cl,%edx
  80288b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80288f:	89 c1                	mov    %eax,%ecx
  802891:	89 da                	mov    %ebx,%edx
  802893:	d3 ea                	shr    %cl,%edx
  802895:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802899:	09 d1                	or     %edx,%ecx
  80289b:	89 f2                	mov    %esi,%edx
  80289d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028a1:	89 f9                	mov    %edi,%ecx
  8028a3:	d3 e3                	shl    %cl,%ebx
  8028a5:	89 c1                	mov    %eax,%ecx
  8028a7:	d3 ea                	shr    %cl,%edx
  8028a9:	89 f9                	mov    %edi,%ecx
  8028ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028af:	d3 e6                	shl    %cl,%esi
  8028b1:	89 eb                	mov    %ebp,%ebx
  8028b3:	89 c1                	mov    %eax,%ecx
  8028b5:	d3 eb                	shr    %cl,%ebx
  8028b7:	09 de                	or     %ebx,%esi
  8028b9:	89 f0                	mov    %esi,%eax
  8028bb:	f7 74 24 08          	divl   0x8(%esp)
  8028bf:	89 d6                	mov    %edx,%esi
  8028c1:	89 c3                	mov    %eax,%ebx
  8028c3:	f7 64 24 0c          	mull   0xc(%esp)
  8028c7:	39 d6                	cmp    %edx,%esi
  8028c9:	72 0c                	jb     8028d7 <__udivdi3+0xb7>
  8028cb:	89 f9                	mov    %edi,%ecx
  8028cd:	d3 e5                	shl    %cl,%ebp
  8028cf:	39 c5                	cmp    %eax,%ebp
  8028d1:	73 5d                	jae    802930 <__udivdi3+0x110>
  8028d3:	39 d6                	cmp    %edx,%esi
  8028d5:	75 59                	jne    802930 <__udivdi3+0x110>
  8028d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028da:	31 ff                	xor    %edi,%edi
  8028dc:	89 fa                	mov    %edi,%edx
  8028de:	83 c4 1c             	add    $0x1c,%esp
  8028e1:	5b                   	pop    %ebx
  8028e2:	5e                   	pop    %esi
  8028e3:	5f                   	pop    %edi
  8028e4:	5d                   	pop    %ebp
  8028e5:	c3                   	ret    
  8028e6:	8d 76 00             	lea    0x0(%esi),%esi
  8028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8028f0:	31 ff                	xor    %edi,%edi
  8028f2:	31 c0                	xor    %eax,%eax
  8028f4:	89 fa                	mov    %edi,%edx
  8028f6:	83 c4 1c             	add    $0x1c,%esp
  8028f9:	5b                   	pop    %ebx
  8028fa:	5e                   	pop    %esi
  8028fb:	5f                   	pop    %edi
  8028fc:	5d                   	pop    %ebp
  8028fd:	c3                   	ret    
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	31 ff                	xor    %edi,%edi
  802902:	89 e8                	mov    %ebp,%eax
  802904:	89 f2                	mov    %esi,%edx
  802906:	f7 f3                	div    %ebx
  802908:	89 fa                	mov    %edi,%edx
  80290a:	83 c4 1c             	add    $0x1c,%esp
  80290d:	5b                   	pop    %ebx
  80290e:	5e                   	pop    %esi
  80290f:	5f                   	pop    %edi
  802910:	5d                   	pop    %ebp
  802911:	c3                   	ret    
  802912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802918:	39 f2                	cmp    %esi,%edx
  80291a:	72 06                	jb     802922 <__udivdi3+0x102>
  80291c:	31 c0                	xor    %eax,%eax
  80291e:	39 eb                	cmp    %ebp,%ebx
  802920:	77 d2                	ja     8028f4 <__udivdi3+0xd4>
  802922:	b8 01 00 00 00       	mov    $0x1,%eax
  802927:	eb cb                	jmp    8028f4 <__udivdi3+0xd4>
  802929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802930:	89 d8                	mov    %ebx,%eax
  802932:	31 ff                	xor    %edi,%edi
  802934:	eb be                	jmp    8028f4 <__udivdi3+0xd4>
  802936:	66 90                	xchg   %ax,%ax
  802938:	66 90                	xchg   %ax,%ax
  80293a:	66 90                	xchg   %ax,%ax
  80293c:	66 90                	xchg   %ax,%ax
  80293e:	66 90                	xchg   %ax,%ax

00802940 <__umoddi3>:
  802940:	55                   	push   %ebp
  802941:	57                   	push   %edi
  802942:	56                   	push   %esi
  802943:	53                   	push   %ebx
  802944:	83 ec 1c             	sub    $0x1c,%esp
  802947:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80294b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80294f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802953:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802957:	85 ed                	test   %ebp,%ebp
  802959:	89 f0                	mov    %esi,%eax
  80295b:	89 da                	mov    %ebx,%edx
  80295d:	75 19                	jne    802978 <__umoddi3+0x38>
  80295f:	39 df                	cmp    %ebx,%edi
  802961:	0f 86 b1 00 00 00    	jbe    802a18 <__umoddi3+0xd8>
  802967:	f7 f7                	div    %edi
  802969:	89 d0                	mov    %edx,%eax
  80296b:	31 d2                	xor    %edx,%edx
  80296d:	83 c4 1c             	add    $0x1c,%esp
  802970:	5b                   	pop    %ebx
  802971:	5e                   	pop    %esi
  802972:	5f                   	pop    %edi
  802973:	5d                   	pop    %ebp
  802974:	c3                   	ret    
  802975:	8d 76 00             	lea    0x0(%esi),%esi
  802978:	39 dd                	cmp    %ebx,%ebp
  80297a:	77 f1                	ja     80296d <__umoddi3+0x2d>
  80297c:	0f bd cd             	bsr    %ebp,%ecx
  80297f:	83 f1 1f             	xor    $0x1f,%ecx
  802982:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802986:	0f 84 b4 00 00 00    	je     802a40 <__umoddi3+0x100>
  80298c:	b8 20 00 00 00       	mov    $0x20,%eax
  802991:	89 c2                	mov    %eax,%edx
  802993:	8b 44 24 04          	mov    0x4(%esp),%eax
  802997:	29 c2                	sub    %eax,%edx
  802999:	89 c1                	mov    %eax,%ecx
  80299b:	89 f8                	mov    %edi,%eax
  80299d:	d3 e5                	shl    %cl,%ebp
  80299f:	89 d1                	mov    %edx,%ecx
  8029a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8029a5:	d3 e8                	shr    %cl,%eax
  8029a7:	09 c5                	or     %eax,%ebp
  8029a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029ad:	89 c1                	mov    %eax,%ecx
  8029af:	d3 e7                	shl    %cl,%edi
  8029b1:	89 d1                	mov    %edx,%ecx
  8029b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029b7:	89 df                	mov    %ebx,%edi
  8029b9:	d3 ef                	shr    %cl,%edi
  8029bb:	89 c1                	mov    %eax,%ecx
  8029bd:	89 f0                	mov    %esi,%eax
  8029bf:	d3 e3                	shl    %cl,%ebx
  8029c1:	89 d1                	mov    %edx,%ecx
  8029c3:	89 fa                	mov    %edi,%edx
  8029c5:	d3 e8                	shr    %cl,%eax
  8029c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029cc:	09 d8                	or     %ebx,%eax
  8029ce:	f7 f5                	div    %ebp
  8029d0:	d3 e6                	shl    %cl,%esi
  8029d2:	89 d1                	mov    %edx,%ecx
  8029d4:	f7 64 24 08          	mull   0x8(%esp)
  8029d8:	39 d1                	cmp    %edx,%ecx
  8029da:	89 c3                	mov    %eax,%ebx
  8029dc:	89 d7                	mov    %edx,%edi
  8029de:	72 06                	jb     8029e6 <__umoddi3+0xa6>
  8029e0:	75 0e                	jne    8029f0 <__umoddi3+0xb0>
  8029e2:	39 c6                	cmp    %eax,%esi
  8029e4:	73 0a                	jae    8029f0 <__umoddi3+0xb0>
  8029e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8029ea:	19 ea                	sbb    %ebp,%edx
  8029ec:	89 d7                	mov    %edx,%edi
  8029ee:	89 c3                	mov    %eax,%ebx
  8029f0:	89 ca                	mov    %ecx,%edx
  8029f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8029f7:	29 de                	sub    %ebx,%esi
  8029f9:	19 fa                	sbb    %edi,%edx
  8029fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8029ff:	89 d0                	mov    %edx,%eax
  802a01:	d3 e0                	shl    %cl,%eax
  802a03:	89 d9                	mov    %ebx,%ecx
  802a05:	d3 ee                	shr    %cl,%esi
  802a07:	d3 ea                	shr    %cl,%edx
  802a09:	09 f0                	or     %esi,%eax
  802a0b:	83 c4 1c             	add    $0x1c,%esp
  802a0e:	5b                   	pop    %ebx
  802a0f:	5e                   	pop    %esi
  802a10:	5f                   	pop    %edi
  802a11:	5d                   	pop    %ebp
  802a12:	c3                   	ret    
  802a13:	90                   	nop
  802a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a18:	85 ff                	test   %edi,%edi
  802a1a:	89 f9                	mov    %edi,%ecx
  802a1c:	75 0b                	jne    802a29 <__umoddi3+0xe9>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f7                	div    %edi
  802a27:	89 c1                	mov    %eax,%ecx
  802a29:	89 d8                	mov    %ebx,%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	f7 f1                	div    %ecx
  802a2f:	89 f0                	mov    %esi,%eax
  802a31:	f7 f1                	div    %ecx
  802a33:	e9 31 ff ff ff       	jmp    802969 <__umoddi3+0x29>
  802a38:	90                   	nop
  802a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a40:	39 dd                	cmp    %ebx,%ebp
  802a42:	72 08                	jb     802a4c <__umoddi3+0x10c>
  802a44:	39 f7                	cmp    %esi,%edi
  802a46:	0f 87 21 ff ff ff    	ja     80296d <__umoddi3+0x2d>
  802a4c:	89 da                	mov    %ebx,%edx
  802a4e:	89 f0                	mov    %esi,%eax
  802a50:	29 f8                	sub    %edi,%eax
  802a52:	19 ea                	sbb    %ebp,%edx
  802a54:	e9 14 ff ff ff       	jmp    80296d <__umoddi3+0x2d>

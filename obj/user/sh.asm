
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 ee 09 00 00       	call   800a1f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
// words get nul-terminated.
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int _gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0)
  80003b:	85 db                	test   %ebx,%ebx
  80003d:	74 1d                	je     80005c <_gettoken+0x29>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80003f:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800046:	7f 34                	jg     80007c <_gettoken+0x49>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80004b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  800051:	8b 45 10             	mov    0x10(%ebp),%eax
  800054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005a:	eb 3a                	jmp    800096 <_gettoken+0x63>
		return 0;
  80005c:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800061:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800068:	7e 59                	jle    8000c3 <_gettoken+0x90>
			cprintf("GETTOKEN NULL\n");
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	68 60 37 80 00       	push   $0x803760
  800072:	e8 e3 0a 00 00       	call   800b5a <cprintf>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	eb 47                	jmp    8000c3 <_gettoken+0x90>
		cprintf("GETTOKEN: %s\n", s);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	53                   	push   %ebx
  800080:	68 6f 37 80 00       	push   $0x80376f
  800085:	e8 d0 0a 00 00       	call   800b5a <cprintf>
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	eb b9                	jmp    800048 <_gettoken+0x15>
		*s++ = 0;
  80008f:	83 c3 01             	add    $0x1,%ebx
  800092:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	0f be 03             	movsbl (%ebx),%eax
  80009c:	50                   	push   %eax
  80009d:	68 7d 37 80 00       	push   $0x80377d
  8000a2:	e8 c6 12 00 00       	call   80136d <strchr>
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	75 e1                	jne    80008f <_gettoken+0x5c>
	if (*s == 0)
  8000ae:	0f b6 03             	movzbl (%ebx),%eax
  8000b1:	84 c0                	test   %al,%al
  8000b3:	75 29                	jne    8000de <_gettoken+0xab>
	{
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b5:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000ba:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c1:	7f 09                	jg     8000cc <_gettoken+0x99>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c3:	89 f0                	mov    %esi,%eax
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    
			cprintf("EOL\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 82 37 80 00       	push   $0x803782
  8000d4:	e8 81 0a 00 00       	call   800b5a <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	eb e5                	jmp    8000c3 <_gettoken+0x90>
	if (strchr(SYMBOLS, *s))
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	0f be c0             	movsbl %al,%eax
  8000e4:	50                   	push   %eax
  8000e5:	68 93 37 80 00       	push   $0x803793
  8000ea:	e8 7e 12 00 00       	call   80136d <strchr>
  8000ef:	83 c4 10             	add    $0x10,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 2f                	je     800125 <_gettoken+0xf2>
		t = *s;
  8000f6:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fc:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  8000fe:	c6 03 00             	movb   $0x0,(%ebx)
  800101:	83 c3 01             	add    $0x1,%ebx
  800104:	8b 45 10             	mov    0x10(%ebp),%eax
  800107:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  800109:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800110:	7e b1                	jle    8000c3 <_gettoken+0x90>
			cprintf("TOK %c\n", t);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	56                   	push   %esi
  800116:	68 87 37 80 00       	push   $0x803787
  80011b:	e8 3a 0a 00 00       	call   800b5a <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	eb 9e                	jmp    8000c3 <_gettoken+0x90>
	*p1 = s;
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012a:	eb 03                	jmp    80012f <_gettoken+0xfc>
		s++;
  80012c:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012f:	0f b6 03             	movzbl (%ebx),%eax
  800132:	84 c0                	test   %al,%al
  800134:	74 18                	je     80014e <_gettoken+0x11b>
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	0f be c0             	movsbl %al,%eax
  80013c:	50                   	push   %eax
  80013d:	68 8f 37 80 00       	push   $0x80378f
  800142:	e8 26 12 00 00       	call   80136d <strchr>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	85 c0                	test   %eax,%eax
  80014c:	74 de                	je     80012c <_gettoken+0xf9>
	*p2 = s;
  80014e:	8b 45 10             	mov    0x10(%ebp),%eax
  800151:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800153:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1)
  800158:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80015f:	0f 8e 5e ff ff ff    	jle    8000c3 <_gettoken+0x90>
		t = **p2;
  800165:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800168:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800171:	ff 30                	pushl  (%eax)
  800173:	68 9b 37 80 00       	push   $0x80379b
  800178:	e8 dd 09 00 00       	call   800b5a <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 30 ff ff ff       	jmp    8000c3 <_gettoken+0x90>

00800193 <gettoken>:

int gettoken(char *s, char **p1)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char *np1, *np2;

	if (s)
  80019c:	85 c0                	test   %eax,%eax
  80019e:	74 22                	je     8001c2 <gettoken+0x2f>
	{
		nc = _gettoken(s, &np1, &np2);
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 0c 50 80 00       	push   $0x80500c
  8001a8:	68 10 50 80 00       	push   $0x805010
  8001ad:	50                   	push   %eax
  8001ae:	e8 80 fe ff ff       	call   800033 <_gettoken>
  8001b3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
	c = nc;
  8001c2:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c7:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001cc:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d5:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	68 0c 50 80 00       	push   $0x80500c
  8001df:	68 10 50 80 00       	push   $0x805010
  8001e4:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001ea:	e8 44 fe ff ff       	call   800033 <_gettoken>
  8001ef:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f4:	a1 04 50 80 00       	mov    0x805004,%eax
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb c2                	jmp    8001c0 <gettoken+0x2d>

008001fe <runcmd>:
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  80020a:	6a 00                	push   $0x0
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	e8 7f ff ff ff       	call   800193 <gettoken>
  800214:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t)))
  800217:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  80021a:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t)))
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	56                   	push   %esi
  800223:	6a 00                	push   $0x0
  800225:	e8 69 ff ff ff       	call   800193 <gettoken>
  80022a:	89 c3                	mov    %eax,%ebx
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	83 f8 3e             	cmp    $0x3e,%eax
  800232:	0f 84 3a 01 00 00    	je     800372 <runcmd+0x174>
  800238:	83 f8 3e             	cmp    $0x3e,%eax
  80023b:	7f 4b                	jg     800288 <runcmd+0x8a>
  80023d:	85 c0                	test   %eax,%eax
  80023f:	0f 84 1d 02 00 00    	je     800462 <runcmd+0x264>
  800245:	83 f8 3c             	cmp    $0x3c,%eax
  800248:	0f 85 79 02 00 00    	jne    8004c7 <runcmd+0x2c9>
			if (gettoken(0, &t) != 'w')
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	56                   	push   %esi
  800252:	6a 00                	push   $0x0
  800254:	e8 3a ff ff ff       	call   800193 <gettoken>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	83 f8 77             	cmp    $0x77,%eax
  80025f:	0f 85 be 00 00 00    	jne    800323 <runcmd+0x125>
			if ((fd = open(t, O_RDONLY)) < 0)
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	6a 00                	push   $0x0
  80026a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80026d:	e8 3e 21 00 00       	call   8023b0 <open>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	85 c0                	test   %eax,%eax
  800279:	0f 88 be 00 00 00    	js     80033d <runcmd+0x13f>
			if (fd != 0)
  80027f:	85 c0                	test   %eax,%eax
  800281:	74 9c                	je     80021f <runcmd+0x21>
  800283:	e9 cf 00 00 00       	jmp    800357 <runcmd+0x159>
		switch ((c = gettoken(0, &t)))
  800288:	83 f8 77             	cmp    $0x77,%eax
  80028b:	74 6b                	je     8002f8 <runcmd+0xfa>
  80028d:	83 f8 7c             	cmp    $0x7c,%eax
  800290:	0f 85 31 02 00 00    	jne    8004c7 <runcmd+0x2c9>
			if ((r = pipe(p)) < 0)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 f2 2e 00 00       	call   803197 <pipe>
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	0f 88 44 01 00 00    	js     8003f4 <runcmd+0x1f6>
			if (debug)
  8002b0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002b7:	0f 85 52 01 00 00    	jne    80040f <runcmd+0x211>
			if ((r = fork()) < 0)
  8002bd:	e8 89 16 00 00       	call   80194b <fork>
  8002c2:	89 c3                	mov    %eax,%ebx
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	0f 88 64 01 00 00    	js     800430 <runcmd+0x232>
			if (r == 0)
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	0f 85 72 01 00 00    	jne    800446 <runcmd+0x248>
				if (p[0] != 0)
  8002d4:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	0f 85 a6 01 00 00    	jne    800488 <runcmd+0x28a>
				close(p[1]);
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002eb:	e8 1f 1b 00 00       	call   801e0f <close>
				goto again;
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	e9 22 ff ff ff       	jmp    80021a <runcmd+0x1c>
			if (argc == MAXARGS)
  8002f8:	83 ff 10             	cmp    $0x10,%edi
  8002fb:	74 0f                	je     80030c <runcmd+0x10e>
			argv[argc++] = t;
  8002fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800300:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  800304:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  800307:	e9 13 ff ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("too many arguments\n");
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	68 a5 37 80 00       	push   $0x8037a5
  800314:	e8 41 08 00 00       	call   800b5a <cprintf>
				exit();
  800319:	e8 47 07 00 00       	call   800a65 <exit>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	eb da                	jmp    8002fd <runcmd+0xff>
				cprintf("syntax error: < not followed by word\n");
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	68 f8 38 80 00       	push   $0x8038f8
  80032b:	e8 2a 08 00 00       	call   800b5a <cprintf>
				exit();
  800330:	e8 30 07 00 00       	call   800a65 <exit>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	e9 28 ff ff ff       	jmp    800265 <runcmd+0x67>
				fprintf(2, "file %s is no exist\n", t);
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	ff 75 a4             	pushl  -0x5c(%ebp)
  800343:	68 b9 37 80 00       	push   $0x8037b9
  800348:	6a 02                	push   $0x2
  80034a:	e8 ee 21 00 00       	call   80253d <fprintf>
				exit();
  80034f:	e8 11 07 00 00       	call   800a65 <exit>
  800354:	83 c4 10             	add    $0x10,%esp
				dup(fd, 0);
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	6a 00                	push   $0x0
  80035c:	53                   	push   %ebx
  80035d:	e8 fd 1a 00 00       	call   801e5f <dup>
				close(fd);
  800362:	89 1c 24             	mov    %ebx,(%esp)
  800365:	e8 a5 1a 00 00       	call   801e0f <close>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	e9 ad fe ff ff       	jmp    80021f <runcmd+0x21>
			if (gettoken(0, &t) != 'w')
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	56                   	push   %esi
  800376:	6a 00                	push   $0x0
  800378:	e8 16 fe ff ff       	call   800193 <gettoken>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	83 f8 77             	cmp    $0x77,%eax
  800383:	75 3d                	jne    8003c2 <runcmd+0x1c4>
			if ((fd = open(t, O_WRONLY | O_CREAT | O_TRUNC)) < 0)
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	68 01 03 00 00       	push   $0x301
  80038d:	ff 75 a4             	pushl  -0x5c(%ebp)
  800390:	e8 1b 20 00 00       	call   8023b0 <open>
  800395:	89 c3                	mov    %eax,%ebx
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	85 c0                	test   %eax,%eax
  80039c:	78 3b                	js     8003d9 <runcmd+0x1db>
			if (fd != 1)
  80039e:	83 fb 01             	cmp    $0x1,%ebx
  8003a1:	0f 84 78 fe ff ff    	je     80021f <runcmd+0x21>
				dup(fd, 1);
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	6a 01                	push   $0x1
  8003ac:	53                   	push   %ebx
  8003ad:	e8 ad 1a 00 00       	call   801e5f <dup>
				close(fd);
  8003b2:	89 1c 24             	mov    %ebx,(%esp)
  8003b5:	e8 55 1a 00 00       	call   801e0f <close>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	e9 5d fe ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("syntax error: > not followed by word\n");
  8003c2:	83 ec 0c             	sub    $0xc,%esp
  8003c5:	68 20 39 80 00       	push   $0x803920
  8003ca:	e8 8b 07 00 00       	call   800b5a <cprintf>
				exit();
  8003cf:	e8 91 06 00 00       	call   800a65 <exit>
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	eb ac                	jmp    800385 <runcmd+0x187>
				cprintf("open %s for write: %e", t, fd);
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	50                   	push   %eax
  8003dd:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003e0:	68 ce 37 80 00       	push   $0x8037ce
  8003e5:	e8 70 07 00 00       	call   800b5a <cprintf>
				exit();
  8003ea:	e8 76 06 00 00       	call   800a65 <exit>
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	eb aa                	jmp    80039e <runcmd+0x1a0>
				cprintf("pipe: %e", r);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	50                   	push   %eax
  8003f8:	68 e4 37 80 00       	push   $0x8037e4
  8003fd:	e8 58 07 00 00       	call   800b5a <cprintf>
				exit();
  800402:	e8 5e 06 00 00       	call   800a65 <exit>
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	e9 a1 fe ff ff       	jmp    8002b0 <runcmd+0xb2>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800418:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80041e:	68 ed 37 80 00       	push   $0x8037ed
  800423:	e8 32 07 00 00       	call   800b5a <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	e9 8d fe ff ff       	jmp    8002bd <runcmd+0xbf>
				cprintf("fork: %e", r);
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	50                   	push   %eax
  800434:	68 fa 37 80 00       	push   $0x8037fa
  800439:	e8 1c 07 00 00       	call   800b5a <cprintf>
				exit();
  80043e:	e8 22 06 00 00       	call   800a65 <exit>
  800443:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1)
  800446:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80044c:	83 f8 01             	cmp    $0x1,%eax
  80044f:	75 58                	jne    8004a9 <runcmd+0x2ab>
				close(p[0]);
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80045a:	e8 b0 19 00 00       	call   801e0f <close>
				goto runit;
  80045f:	83 c4 10             	add    $0x10,%esp
	if (argc == 0)
  800462:	85 ff                	test   %edi,%edi
  800464:	75 76                	jne    8004dc <runcmd+0x2de>
		if (debug)
  800466:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80046d:	0f 84 f3 00 00 00    	je     800566 <runcmd+0x368>
			cprintf("EMPTY COMMAND\n");
  800473:	83 ec 0c             	sub    $0xc,%esp
  800476:	68 29 38 80 00       	push   $0x803829
  80047b:	e8 da 06 00 00       	call   800b5a <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp
  800483:	e9 de 00 00 00       	jmp    800566 <runcmd+0x368>
					dup(p[0], 0);
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	6a 00                	push   $0x0
  80048d:	50                   	push   %eax
  80048e:	e8 cc 19 00 00       	call   801e5f <dup>
					close(p[0]);
  800493:	83 c4 04             	add    $0x4,%esp
  800496:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80049c:	e8 6e 19 00 00       	call   801e0f <close>
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	e9 39 fe ff ff       	jmp    8002e2 <runcmd+0xe4>
					dup(p[1], 1);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	6a 01                	push   $0x1
  8004ae:	50                   	push   %eax
  8004af:	e8 ab 19 00 00       	call   801e5f <dup>
					close(p[1]);
  8004b4:	83 c4 04             	add    $0x4,%esp
  8004b7:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8004bd:	e8 4d 19 00 00       	call   801e0f <close>
  8004c2:	83 c4 10             	add    $0x10,%esp
  8004c5:	eb 8a                	jmp    800451 <runcmd+0x253>
			panic("bad return %d from gettoken", c);
  8004c7:	53                   	push   %ebx
  8004c8:	68 03 38 80 00       	push   $0x803803
  8004cd:	68 85 00 00 00       	push   $0x85
  8004d2:	68 1f 38 80 00       	push   $0x80381f
  8004d7:	e8 a3 05 00 00       	call   800a7f <_panic>
	if (argv[0][0] != '/')
  8004dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004df:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004e2:	0f 85 86 00 00 00    	jne    80056e <runcmd+0x370>
	argv[argc] = 0;
  8004e8:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  8004ef:	00 
	if (debug)
  8004f0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004f7:	0f 85 99 00 00 00    	jne    800596 <runcmd+0x398>
	if ((r = spawn(argv[0], (const char **)argv)) < 0)
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800503:	50                   	push   %eax
  800504:	ff 75 a8             	pushl  -0x58(%ebp)
  800507:	e8 5e 20 00 00       	call   80256a <spawn>
  80050c:	89 c6                	mov    %eax,%esi
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	85 c0                	test   %eax,%eax
  800513:	0f 88 cb 00 00 00    	js     8005e4 <runcmd+0x3e6>
	close_all();
  800519:	e8 1c 19 00 00       	call   801e3a <close_all>
		if (debug)
  80051e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800525:	0f 85 06 01 00 00    	jne    800631 <runcmd+0x433>
		wait(r);
  80052b:	83 ec 0c             	sub    $0xc,%esp
  80052e:	56                   	push   %esi
  80052f:	e8 df 2d 00 00       	call   803313 <wait>
		if (debug)
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80053e:	0f 85 0c 01 00 00    	jne    800650 <runcmd+0x452>
	if (pipe_child)
  800544:	85 db                	test   %ebx,%ebx
  800546:	74 19                	je     800561 <runcmd+0x363>
		wait(pipe_child);
  800548:	83 ec 0c             	sub    $0xc,%esp
  80054b:	53                   	push   %ebx
  80054c:	e8 c2 2d 00 00       	call   803313 <wait>
		if (debug)
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80055b:	0f 85 0a 01 00 00    	jne    80066b <runcmd+0x46d>
	exit();
  800561:	e8 ff 04 00 00       	call   800a65 <exit>
}
  800566:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800569:	5b                   	pop    %ebx
  80056a:	5e                   	pop    %esi
  80056b:	5f                   	pop    %edi
  80056c:	5d                   	pop    %ebp
  80056d:	c3                   	ret    
		argv0buf[0] = '/';
  80056e:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	50                   	push   %eax
  800579:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  80057f:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800585:	50                   	push   %eax
  800586:	e8 de 0c 00 00       	call   801269 <strcpy>
		argv[0] = argv0buf;
  80058b:	89 75 a8             	mov    %esi,-0x58(%ebp)
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	e9 52 ff ff ff       	jmp    8004e8 <runcmd+0x2ea>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800596:	a1 28 54 80 00       	mov    0x805428,%eax
  80059b:	8b 40 48             	mov    0x48(%eax),%eax
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	50                   	push   %eax
  8005a2:	68 38 38 80 00       	push   $0x803838
  8005a7:	e8 ae 05 00 00       	call   800b5a <cprintf>
  8005ac:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	83 c6 04             	add    $0x4,%esi
  8005b5:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	74 13                	je     8005cf <runcmd+0x3d1>
			cprintf(" %s", argv[i]);
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	50                   	push   %eax
  8005c0:	68 c0 38 80 00       	push   $0x8038c0
  8005c5:	e8 90 05 00 00       	call   800b5a <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	eb e3                	jmp    8005b2 <runcmd+0x3b4>
		cprintf("\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 80 37 80 00       	push   $0x803780
  8005d7:	e8 7e 05 00 00       	call   800b5a <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	e9 19 ff ff ff       	jmp    8004fd <runcmd+0x2ff>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	50                   	push   %eax
  8005e8:	ff 75 a8             	pushl  -0x58(%ebp)
  8005eb:	68 46 38 80 00       	push   $0x803846
  8005f0:	e8 65 05 00 00       	call   800b5a <cprintf>
	close_all();
  8005f5:	e8 40 18 00 00       	call   801e3a <close_all>
  8005fa:	83 c4 10             	add    $0x10,%esp
	if (pipe_child)
  8005fd:	85 db                	test   %ebx,%ebx
  8005ff:	0f 84 5c ff ff ff    	je     800561 <runcmd+0x363>
		if (debug)
  800605:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80060c:	0f 84 36 ff ff ff    	je     800548 <runcmd+0x34a>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800612:	a1 28 54 80 00       	mov    0x805428,%eax
  800617:	8b 40 48             	mov    0x48(%eax),%eax
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	53                   	push   %ebx
  80061e:	50                   	push   %eax
  80061f:	68 7f 38 80 00       	push   $0x80387f
  800624:	e8 31 05 00 00       	call   800b5a <cprintf>
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	e9 17 ff ff ff       	jmp    800548 <runcmd+0x34a>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800631:	a1 28 54 80 00       	mov    0x805428,%eax
  800636:	8b 40 48             	mov    0x48(%eax),%eax
  800639:	56                   	push   %esi
  80063a:	ff 75 a8             	pushl  -0x58(%ebp)
  80063d:	50                   	push   %eax
  80063e:	68 54 38 80 00       	push   $0x803854
  800643:	e8 12 05 00 00       	call   800b5a <cprintf>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	e9 db fe ff ff       	jmp    80052b <runcmd+0x32d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800650:	a1 28 54 80 00       	mov    0x805428,%eax
  800655:	8b 40 48             	mov    0x48(%eax),%eax
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	50                   	push   %eax
  80065c:	68 69 38 80 00       	push   $0x803869
  800661:	e8 f4 04 00 00       	call   800b5a <cprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	eb 92                	jmp    8005fd <runcmd+0x3ff>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80066b:	a1 28 54 80 00       	mov    0x805428,%eax
  800670:	8b 40 48             	mov    0x48(%eax),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	50                   	push   %eax
  800677:	68 69 38 80 00       	push   $0x803869
  80067c:	e8 d9 04 00 00       	call   800b5a <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	e9 d8 fe ff ff       	jmp    800561 <runcmd+0x363>

00800689 <usage>:

void usage(void)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80068f:	68 48 39 80 00       	push   $0x803948
  800694:	e8 c1 04 00 00       	call   800b5a <cprintf>
	exit();
  800699:	e8 c7 03 00 00       	call   800a65 <exit>
}
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	c9                   	leave  
  8006a2:	c3                   	ret    

008006a3 <umain>:

void umain(int argc, char **argv)
{
  8006a3:	55                   	push   %ebp
  8006a4:	89 e5                	mov    %esp,%ebp
  8006a6:	57                   	push   %edi
  8006a7:	56                   	push   %esi
  8006a8:	53                   	push   %ebx
  8006a9:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006ac:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006af:	50                   	push   %eax
  8006b0:	ff 75 0c             	pushl  0xc(%ebp)
  8006b3:	8d 45 08             	lea    0x8(%ebp),%eax
  8006b6:	50                   	push   %eax
  8006b7:	e8 54 14 00 00       	call   801b10 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006bc:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006bf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006c6:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006cb:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		{
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006ce:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006d3:	eb 03                	jmp    8006d8 <umain+0x35>
			break;
		case 'x':
			echocmds = 1;
  8006d5:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006d8:	83 ec 0c             	sub    $0xc,%esp
  8006db:	53                   	push   %ebx
  8006dc:	e8 5f 14 00 00       	call   801b40 <argnext>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	85 c0                	test   %eax,%eax
  8006e6:	78 23                	js     80070b <umain+0x68>
		switch (r)
  8006e8:	83 f8 69             	cmp    $0x69,%eax
  8006eb:	74 1a                	je     800707 <umain+0x64>
  8006ed:	83 f8 78             	cmp    $0x78,%eax
  8006f0:	74 e3                	je     8006d5 <umain+0x32>
  8006f2:	83 f8 64             	cmp    $0x64,%eax
  8006f5:	74 07                	je     8006fe <umain+0x5b>
			break;
		default:
			usage();
  8006f7:	e8 8d ff ff ff       	call   800689 <usage>
  8006fc:	eb da                	jmp    8006d8 <umain+0x35>
			debug++;
  8006fe:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  800705:	eb d1                	jmp    8006d8 <umain+0x35>
			interactive = 1;
  800707:	89 f7                	mov    %esi,%edi
  800709:	eb cd                	jmp    8006d8 <umain+0x35>
		}

	if (argc > 2)
  80070b:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070f:	7f 1f                	jg     800730 <umain+0x8d>
		usage();
	if (argc == 2)
  800711:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800715:	74 20                	je     800737 <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  800717:	83 ff 3f             	cmp    $0x3f,%edi
  80071a:	74 77                	je     800793 <umain+0xf0>
  80071c:	85 ff                	test   %edi,%edi
  80071e:	bf c4 38 80 00       	mov    $0x8038c4,%edi
  800723:	b8 00 00 00 00       	mov    $0x0,%eax
  800728:	0f 44 f8             	cmove  %eax,%edi
  80072b:	e9 08 01 00 00       	jmp    800838 <umain+0x195>
		usage();
  800730:	e8 54 ff ff ff       	call   800689 <usage>
  800735:	eb da                	jmp    800711 <umain+0x6e>
		close(0);
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	6a 00                	push   $0x0
  80073c:	e8 ce 16 00 00       	call   801e0f <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800741:	83 c4 08             	add    $0x8,%esp
  800744:	6a 00                	push   $0x0
  800746:	8b 45 0c             	mov    0xc(%ebp),%eax
  800749:	ff 70 04             	pushl  0x4(%eax)
  80074c:	e8 5f 1c 00 00       	call   8023b0 <open>
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	85 c0                	test   %eax,%eax
  800756:	78 1d                	js     800775 <umain+0xd2>
		assert(r == 0);
  800758:	85 c0                	test   %eax,%eax
  80075a:	74 bb                	je     800717 <umain+0x74>
  80075c:	68 a8 38 80 00       	push   $0x8038a8
  800761:	68 af 38 80 00       	push   $0x8038af
  800766:	68 3b 01 00 00       	push   $0x13b
  80076b:	68 1f 38 80 00       	push   $0x80381f
  800770:	e8 0a 03 00 00       	call   800a7f <_panic>
			panic("open %s: %e", argv[1], r);
  800775:	83 ec 0c             	sub    $0xc,%esp
  800778:	50                   	push   %eax
  800779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077c:	ff 70 04             	pushl  0x4(%eax)
  80077f:	68 9c 38 80 00       	push   $0x80389c
  800784:	68 3a 01 00 00       	push   $0x13a
  800789:	68 1f 38 80 00       	push   $0x80381f
  80078e:	e8 ec 02 00 00       	call   800a7f <_panic>
		interactive = iscons(0);
  800793:	83 ec 0c             	sub    $0xc,%esp
  800796:	6a 00                	push   $0x0
  800798:	e8 04 02 00 00       	call   8009a1 <iscons>
  80079d:	89 c7                	mov    %eax,%edi
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	e9 75 ff ff ff       	jmp    80071c <umain+0x79>
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL)
		{
			if (debug)
  8007a7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007ae:	75 0a                	jne    8007ba <umain+0x117>
				cprintf("EXITING\n");
			exit(); // end of file
  8007b0:	e8 b0 02 00 00       	call   800a65 <exit>
  8007b5:	e9 94 00 00 00       	jmp    80084e <umain+0x1ab>
				cprintf("EXITING\n");
  8007ba:	83 ec 0c             	sub    $0xc,%esp
  8007bd:	68 c7 38 80 00       	push   $0x8038c7
  8007c2:	e8 93 03 00 00       	call   800b5a <cprintf>
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	eb e4                	jmp    8007b0 <umain+0x10d>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	68 d0 38 80 00       	push   $0x8038d0
  8007d5:	e8 80 03 00 00       	call   800b5a <cprintf>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	eb 7c                	jmp    80085b <umain+0x1b8>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	68 da 38 80 00       	push   $0x8038da
  8007e8:	e8 67 1d 00 00       	call   802554 <printf>
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	eb 78                	jmp    80086a <umain+0x1c7>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	68 e0 38 80 00       	push   $0x8038e0
  8007fa:	e8 5b 03 00 00       	call   800b5a <cprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	eb 73                	jmp    800877 <umain+0x1d4>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  800804:	50                   	push   %eax
  800805:	68 fa 37 80 00       	push   $0x8037fa
  80080a:	68 54 01 00 00       	push   $0x154
  80080f:	68 1f 38 80 00       	push   $0x80381f
  800814:	e8 66 02 00 00       	call   800a7f <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	50                   	push   %eax
  80081d:	68 ed 38 80 00       	push   $0x8038ed
  800822:	e8 33 03 00 00       	call   800b5a <cprintf>
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	eb 5f                	jmp    80088b <umain+0x1e8>
		{
			runcmd(buf);
			exit();
		}
		else
			wait(r);
  80082c:	83 ec 0c             	sub    $0xc,%esp
  80082f:	56                   	push   %esi
  800830:	e8 de 2a 00 00       	call   803313 <wait>
  800835:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  800838:	83 ec 0c             	sub    $0xc,%esp
  80083b:	57                   	push   %edi
  80083c:	e8 01 09 00 00       	call   801142 <readline>
  800841:	89 c3                	mov    %eax,%ebx
		if (buf == NULL)
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	85 c0                	test   %eax,%eax
  800848:	0f 84 59 ff ff ff    	je     8007a7 <umain+0x104>
		if (debug)
  80084e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800855:	0f 85 71 ff ff ff    	jne    8007cc <umain+0x129>
		if (buf[0] == '#')
  80085b:	80 3b 23             	cmpb   $0x23,(%ebx)
  80085e:	74 d8                	je     800838 <umain+0x195>
		if (echocmds)
  800860:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800864:	0f 85 75 ff ff ff    	jne    8007df <umain+0x13c>
		if (debug)
  80086a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800871:	0f 85 7b ff ff ff    	jne    8007f2 <umain+0x14f>
		if ((r = fork()) < 0)
  800877:	e8 cf 10 00 00       	call   80194b <fork>
  80087c:	89 c6                	mov    %eax,%esi
  80087e:	85 c0                	test   %eax,%eax
  800880:	78 82                	js     800804 <umain+0x161>
		if (debug)
  800882:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800889:	75 8e                	jne    800819 <umain+0x176>
		if (r == 0)
  80088b:	85 f6                	test   %esi,%esi
  80088d:	75 9d                	jne    80082c <umain+0x189>
			runcmd(buf);
  80088f:	83 ec 0c             	sub    $0xc,%esp
  800892:	53                   	push   %ebx
  800893:	e8 66 f9 ff ff       	call   8001fe <runcmd>
			exit();
  800898:	e8 c8 01 00 00       	call   800a65 <exit>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	eb 96                	jmp    800838 <umain+0x195>

008008a2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8008a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008b2:	68 69 39 80 00       	push   $0x803969
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	e8 aa 09 00 00       	call   801269 <strcpy>
	return 0;
}
  8008bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    

008008c6 <devcons_write>:
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	57                   	push   %edi
  8008ca:	56                   	push   %esi
  8008cb:	53                   	push   %ebx
  8008cc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008d2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008d7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008dd:	eb 2f                	jmp    80090e <devcons_write+0x48>
		m = n - tot;
  8008df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008e2:	29 f3                	sub    %esi,%ebx
  8008e4:	83 fb 7f             	cmp    $0x7f,%ebx
  8008e7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008ec:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	89 f0                	mov    %esi,%eax
  8008f5:	03 45 0c             	add    0xc(%ebp),%eax
  8008f8:	50                   	push   %eax
  8008f9:	57                   	push   %edi
  8008fa:	e8 f8 0a 00 00       	call   8013f7 <memmove>
		sys_cputs(buf, m);
  8008ff:	83 c4 08             	add    $0x8,%esp
  800902:	53                   	push   %ebx
  800903:	57                   	push   %edi
  800904:	e8 9d 0c 00 00       	call   8015a6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800909:	01 de                	add    %ebx,%esi
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800911:	72 cc                	jb     8008df <devcons_write+0x19>
}
  800913:	89 f0                	mov    %esi,%eax
  800915:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5f                   	pop    %edi
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <devcons_read>:
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800928:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80092c:	75 07                	jne    800935 <devcons_read+0x18>
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    
		sys_yield();
  800930:	e8 0e 0d 00 00       	call   801643 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800935:	e8 8a 0c 00 00       	call   8015c4 <sys_cgetc>
  80093a:	85 c0                	test   %eax,%eax
  80093c:	74 f2                	je     800930 <devcons_read+0x13>
	if (c < 0)
  80093e:	85 c0                	test   %eax,%eax
  800940:	78 ec                	js     80092e <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800942:	83 f8 04             	cmp    $0x4,%eax
  800945:	74 0c                	je     800953 <devcons_read+0x36>
	*(char*)vbuf = c;
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	88 02                	mov    %al,(%edx)
	return 1;
  80094c:	b8 01 00 00 00       	mov    $0x1,%eax
  800951:	eb db                	jmp    80092e <devcons_read+0x11>
		return 0;
  800953:	b8 00 00 00 00       	mov    $0x0,%eax
  800958:	eb d4                	jmp    80092e <devcons_read+0x11>

0080095a <cputchar>:
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800966:	6a 01                	push   $0x1
  800968:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80096b:	50                   	push   %eax
  80096c:	e8 35 0c 00 00       	call   8015a6 <sys_cputs>
}
  800971:	83 c4 10             	add    $0x10,%esp
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <getchar>:
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80097c:	6a 01                	push   $0x1
  80097e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	6a 00                	push   $0x0
  800984:	e8 c2 15 00 00       	call   801f4b <read>
	if (r < 0)
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	85 c0                	test   %eax,%eax
  80098e:	78 08                	js     800998 <getchar+0x22>
	if (r < 1)
  800990:	85 c0                	test   %eax,%eax
  800992:	7e 06                	jle    80099a <getchar+0x24>
	return c;
  800994:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    
		return -E_EOF;
  80099a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80099f:	eb f7                	jmp    800998 <getchar+0x22>

008009a1 <iscons>:
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	ff 75 08             	pushl  0x8(%ebp)
  8009ae:	e8 27 13 00 00       	call   801cda <fd_lookup>
  8009b3:	83 c4 10             	add    $0x10,%esp
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	78 11                	js     8009cb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009bd:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009c3:	39 10                	cmp    %edx,(%eax)
  8009c5:	0f 94 c0             	sete   %al
  8009c8:	0f b6 c0             	movzbl %al,%eax
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <opencons>:
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 af 12 00 00       	call   801c8b <fd_alloc>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	85 c0                	test   %eax,%eax
  8009e1:	78 3a                	js     800a1d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009e3:	83 ec 04             	sub    $0x4,%esp
  8009e6:	68 07 04 00 00       	push   $0x407
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	6a 00                	push   $0x0
  8009f0:	e8 6d 0c 00 00       	call   801662 <sys_page_alloc>
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	85 c0                	test   %eax,%eax
  8009fa:	78 21                	js     800a1d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ff:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800a05:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	50                   	push   %eax
  800a15:	e8 4a 12 00 00       	call   801c64 <fd2num>
  800a1a:	83 c4 10             	add    $0x10,%esp
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a27:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a2a:	e8 f5 0b 00 00       	call   801624 <sys_getenvid>
  800a2f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a34:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a37:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a3c:	a3 28 54 80 00       	mov    %eax,0x805428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	7e 07                	jle    800a4c <libmain+0x2d>
		binaryname = argv[0];
  800a45:	8b 06                	mov    (%esi),%eax
  800a47:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	56                   	push   %esi
  800a50:	53                   	push   %ebx
  800a51:	e8 4d fc ff ff       	call   8006a3 <umain>

	// exit gracefully
	exit();
  800a56:	e8 0a 00 00 00       	call   800a65 <exit>
}
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a6b:	e8 ca 13 00 00       	call   801e3a <close_all>
	sys_env_destroy(0);
  800a70:	83 ec 0c             	sub    $0xc,%esp
  800a73:	6a 00                	push   $0x0
  800a75:	e8 69 0b 00 00       	call   8015e3 <sys_env_destroy>
}
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    

00800a7f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a84:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a87:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a8d:	e8 92 0b 00 00       	call   801624 <sys_getenvid>
  800a92:	83 ec 0c             	sub    $0xc,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	56                   	push   %esi
  800a9c:	50                   	push   %eax
  800a9d:	68 80 39 80 00       	push   $0x803980
  800aa2:	e8 b3 00 00 00       	call   800b5a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800aa7:	83 c4 18             	add    $0x18,%esp
  800aaa:	53                   	push   %ebx
  800aab:	ff 75 10             	pushl  0x10(%ebp)
  800aae:	e8 56 00 00 00       	call   800b09 <vcprintf>
	cprintf("\n");
  800ab3:	c7 04 24 80 37 80 00 	movl   $0x803780,(%esp)
  800aba:	e8 9b 00 00 00       	call   800b5a <cprintf>
  800abf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ac2:	cc                   	int3   
  800ac3:	eb fd                	jmp    800ac2 <_panic+0x43>

00800ac5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	53                   	push   %ebx
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800acf:	8b 13                	mov    (%ebx),%edx
  800ad1:	8d 42 01             	lea    0x1(%edx),%eax
  800ad4:	89 03                	mov    %eax,(%ebx)
  800ad6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800add:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae2:	74 09                	je     800aed <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800ae4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	68 ff 00 00 00       	push   $0xff
  800af5:	8d 43 08             	lea    0x8(%ebx),%eax
  800af8:	50                   	push   %eax
  800af9:	e8 a8 0a 00 00       	call   8015a6 <sys_cputs>
		b->idx = 0;
  800afe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b04:	83 c4 10             	add    $0x10,%esp
  800b07:	eb db                	jmp    800ae4 <putch+0x1f>

00800b09 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b12:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b19:	00 00 00 
	b.cnt = 0;
  800b1c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b23:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b26:	ff 75 0c             	pushl  0xc(%ebp)
  800b29:	ff 75 08             	pushl  0x8(%ebp)
  800b2c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	68 c5 0a 80 00       	push   $0x800ac5
  800b38:	e8 1a 01 00 00       	call   800c57 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b3d:	83 c4 08             	add    $0x8,%esp
  800b40:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b46:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	e8 54 0a 00 00       	call   8015a6 <sys_cputs>

	return b.cnt;
}
  800b52:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b60:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b63:	50                   	push   %eax
  800b64:	ff 75 08             	pushl  0x8(%ebp)
  800b67:	e8 9d ff ff ff       	call   800b09 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	57                   	push   %edi
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 1c             	sub    $0x1c,%esp
  800b77:	89 c7                	mov    %eax,%edi
  800b79:	89 d6                	mov    %edx,%esi
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b81:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b84:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b8f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b92:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800b95:	39 d3                	cmp    %edx,%ebx
  800b97:	72 05                	jb     800b9e <printnum+0x30>
  800b99:	39 45 10             	cmp    %eax,0x10(%ebp)
  800b9c:	77 7a                	ja     800c18 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b9e:	83 ec 0c             	sub    $0xc,%esp
  800ba1:	ff 75 18             	pushl  0x18(%ebp)
  800ba4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800baa:	53                   	push   %ebx
  800bab:	ff 75 10             	pushl  0x10(%ebp)
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb4:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb7:	ff 75 dc             	pushl  -0x24(%ebp)
  800bba:	ff 75 d8             	pushl  -0x28(%ebp)
  800bbd:	e8 5e 29 00 00       	call   803520 <__udivdi3>
  800bc2:	83 c4 18             	add    $0x18,%esp
  800bc5:	52                   	push   %edx
  800bc6:	50                   	push   %eax
  800bc7:	89 f2                	mov    %esi,%edx
  800bc9:	89 f8                	mov    %edi,%eax
  800bcb:	e8 9e ff ff ff       	call   800b6e <printnum>
  800bd0:	83 c4 20             	add    $0x20,%esp
  800bd3:	eb 13                	jmp    800be8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	56                   	push   %esi
  800bd9:	ff 75 18             	pushl  0x18(%ebp)
  800bdc:	ff d7                	call   *%edi
  800bde:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800be1:	83 eb 01             	sub    $0x1,%ebx
  800be4:	85 db                	test   %ebx,%ebx
  800be6:	7f ed                	jg     800bd5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	56                   	push   %esi
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf2:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf5:	ff 75 dc             	pushl  -0x24(%ebp)
  800bf8:	ff 75 d8             	pushl  -0x28(%ebp)
  800bfb:	e8 40 2a 00 00       	call   803640 <__umoddi3>
  800c00:	83 c4 14             	add    $0x14,%esp
  800c03:	0f be 80 a3 39 80 00 	movsbl 0x8039a3(%eax),%eax
  800c0a:	50                   	push   %eax
  800c0b:	ff d7                	call   *%edi
}
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5f                   	pop    %edi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    
  800c18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800c1b:	eb c4                	jmp    800be1 <printnum+0x73>

00800c1d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c23:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c27:	8b 10                	mov    (%eax),%edx
  800c29:	3b 50 04             	cmp    0x4(%eax),%edx
  800c2c:	73 0a                	jae    800c38 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 08                	mov    %ecx,(%eax)
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	88 02                	mov    %al,(%edx)
}
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <printfmt>:
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c40:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c43:	50                   	push   %eax
  800c44:	ff 75 10             	pushl  0x10(%ebp)
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	ff 75 08             	pushl  0x8(%ebp)
  800c4d:	e8 05 00 00 00       	call   800c57 <vprintfmt>
}
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <vprintfmt>:
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	57                   	push   %edi
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
  800c5d:	83 ec 2c             	sub    $0x2c,%esp
  800c60:	8b 75 08             	mov    0x8(%ebp),%esi
  800c63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c66:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c69:	e9 c1 03 00 00       	jmp    80102f <vprintfmt+0x3d8>
		padc = ' ';
  800c6e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800c72:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800c79:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800c80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c87:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c8c:	8d 47 01             	lea    0x1(%edi),%eax
  800c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c92:	0f b6 17             	movzbl (%edi),%edx
  800c95:	8d 42 dd             	lea    -0x23(%edx),%eax
  800c98:	3c 55                	cmp    $0x55,%al
  800c9a:	0f 87 12 04 00 00    	ja     8010b2 <vprintfmt+0x45b>
  800ca0:	0f b6 c0             	movzbl %al,%eax
  800ca3:	ff 24 85 e0 3a 80 00 	jmp    *0x803ae0(,%eax,4)
  800caa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800cad:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800cb1:	eb d9                	jmp    800c8c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800cb3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cb6:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800cba:	eb d0                	jmp    800c8c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800cbc:	0f b6 d2             	movzbl %dl,%edx
  800cbf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800cca:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800ccd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800cd1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800cd4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800cd7:	83 f9 09             	cmp    $0x9,%ecx
  800cda:	77 55                	ja     800d31 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800cdc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800cdf:	eb e9                	jmp    800cca <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800ce1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce4:	8b 00                	mov    (%eax),%eax
  800ce6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	8d 40 04             	lea    0x4(%eax),%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cf2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800cf5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cf9:	79 91                	jns    800c8c <vprintfmt+0x35>
				width = precision, precision = -1;
  800cfb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d01:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800d08:	eb 82                	jmp    800c8c <vprintfmt+0x35>
  800d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d14:	0f 49 d0             	cmovns %eax,%edx
  800d17:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d1a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d1d:	e9 6a ff ff ff       	jmp    800c8c <vprintfmt+0x35>
  800d22:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d25:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800d2c:	e9 5b ff ff ff       	jmp    800c8c <vprintfmt+0x35>
  800d31:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d34:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d37:	eb bc                	jmp    800cf5 <vprintfmt+0x9e>
			lflag++;
  800d39:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d3c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d3f:	e9 48 ff ff ff       	jmp    800c8c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800d44:	8b 45 14             	mov    0x14(%ebp),%eax
  800d47:	8d 78 04             	lea    0x4(%eax),%edi
  800d4a:	83 ec 08             	sub    $0x8,%esp
  800d4d:	53                   	push   %ebx
  800d4e:	ff 30                	pushl  (%eax)
  800d50:	ff d6                	call   *%esi
			break;
  800d52:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d55:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d58:	e9 cf 02 00 00       	jmp    80102c <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	8d 78 04             	lea    0x4(%eax),%edi
  800d63:	8b 00                	mov    (%eax),%eax
  800d65:	99                   	cltd   
  800d66:	31 d0                	xor    %edx,%eax
  800d68:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d6a:	83 f8 0f             	cmp    $0xf,%eax
  800d6d:	7f 23                	jg     800d92 <vprintfmt+0x13b>
  800d6f:	8b 14 85 40 3c 80 00 	mov    0x803c40(,%eax,4),%edx
  800d76:	85 d2                	test   %edx,%edx
  800d78:	74 18                	je     800d92 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800d7a:	52                   	push   %edx
  800d7b:	68 c1 38 80 00       	push   $0x8038c1
  800d80:	53                   	push   %ebx
  800d81:	56                   	push   %esi
  800d82:	e8 b3 fe ff ff       	call   800c3a <printfmt>
  800d87:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d8a:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d8d:	e9 9a 02 00 00       	jmp    80102c <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800d92:	50                   	push   %eax
  800d93:	68 bb 39 80 00       	push   $0x8039bb
  800d98:	53                   	push   %ebx
  800d99:	56                   	push   %esi
  800d9a:	e8 9b fe ff ff       	call   800c3a <printfmt>
  800d9f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800da2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800da5:	e9 82 02 00 00       	jmp    80102c <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800daa:	8b 45 14             	mov    0x14(%ebp),%eax
  800dad:	83 c0 04             	add    $0x4,%eax
  800db0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800db3:	8b 45 14             	mov    0x14(%ebp),%eax
  800db6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800db8:	85 ff                	test   %edi,%edi
  800dba:	b8 b4 39 80 00       	mov    $0x8039b4,%eax
  800dbf:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800dc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc6:	0f 8e bd 00 00 00    	jle    800e89 <vprintfmt+0x232>
  800dcc:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800dd0:	75 0e                	jne    800de0 <vprintfmt+0x189>
  800dd2:	89 75 08             	mov    %esi,0x8(%ebp)
  800dd5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800dd8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800ddb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800dde:	eb 6d                	jmp    800e4d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800de0:	83 ec 08             	sub    $0x8,%esp
  800de3:	ff 75 d0             	pushl  -0x30(%ebp)
  800de6:	57                   	push   %edi
  800de7:	e8 5e 04 00 00       	call   80124a <strnlen>
  800dec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800def:	29 c1                	sub    %eax,%ecx
  800df1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800df4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800df7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800dfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dfe:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800e01:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	eb 0f                	jmp    800e14 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	53                   	push   %ebx
  800e09:	ff 75 e0             	pushl  -0x20(%ebp)
  800e0c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0e:	83 ef 01             	sub    $0x1,%edi
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	85 ff                	test   %edi,%edi
  800e16:	7f ed                	jg     800e05 <vprintfmt+0x1ae>
  800e18:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800e1b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800e1e:	85 c9                	test   %ecx,%ecx
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
  800e25:	0f 49 c1             	cmovns %ecx,%eax
  800e28:	29 c1                	sub    %eax,%ecx
  800e2a:	89 75 08             	mov    %esi,0x8(%ebp)
  800e2d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e30:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e33:	89 cb                	mov    %ecx,%ebx
  800e35:	eb 16                	jmp    800e4d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800e37:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e3b:	75 31                	jne    800e6e <vprintfmt+0x217>
					putch(ch, putdat);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 0c             	pushl  0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	ff 55 08             	call   *0x8(%ebp)
  800e47:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e4a:	83 eb 01             	sub    $0x1,%ebx
  800e4d:	83 c7 01             	add    $0x1,%edi
  800e50:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800e54:	0f be c2             	movsbl %dl,%eax
  800e57:	85 c0                	test   %eax,%eax
  800e59:	74 59                	je     800eb4 <vprintfmt+0x25d>
  800e5b:	85 f6                	test   %esi,%esi
  800e5d:	78 d8                	js     800e37 <vprintfmt+0x1e0>
  800e5f:	83 ee 01             	sub    $0x1,%esi
  800e62:	79 d3                	jns    800e37 <vprintfmt+0x1e0>
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	8b 75 08             	mov    0x8(%ebp),%esi
  800e69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e6c:	eb 37                	jmp    800ea5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800e6e:	0f be d2             	movsbl %dl,%edx
  800e71:	83 ea 20             	sub    $0x20,%edx
  800e74:	83 fa 5e             	cmp    $0x5e,%edx
  800e77:	76 c4                	jbe    800e3d <vprintfmt+0x1e6>
					putch('?', putdat);
  800e79:	83 ec 08             	sub    $0x8,%esp
  800e7c:	ff 75 0c             	pushl  0xc(%ebp)
  800e7f:	6a 3f                	push   $0x3f
  800e81:	ff 55 08             	call   *0x8(%ebp)
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	eb c1                	jmp    800e4a <vprintfmt+0x1f3>
  800e89:	89 75 08             	mov    %esi,0x8(%ebp)
  800e8c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e8f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e92:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e95:	eb b6                	jmp    800e4d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	53                   	push   %ebx
  800e9b:	6a 20                	push   $0x20
  800e9d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e9f:	83 ef 01             	sub    $0x1,%edi
  800ea2:	83 c4 10             	add    $0x10,%esp
  800ea5:	85 ff                	test   %edi,%edi
  800ea7:	7f ee                	jg     800e97 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800ea9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eac:	89 45 14             	mov    %eax,0x14(%ebp)
  800eaf:	e9 78 01 00 00       	jmp    80102c <vprintfmt+0x3d5>
  800eb4:	89 df                	mov    %ebx,%edi
  800eb6:	8b 75 08             	mov    0x8(%ebp),%esi
  800eb9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ebc:	eb e7                	jmp    800ea5 <vprintfmt+0x24e>
	if (lflag >= 2)
  800ebe:	83 f9 01             	cmp    $0x1,%ecx
  800ec1:	7e 3f                	jle    800f02 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec6:	8b 50 04             	mov    0x4(%eax),%edx
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ece:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ed1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed4:	8d 40 08             	lea    0x8(%eax),%eax
  800ed7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800eda:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ede:	79 5c                	jns    800f3c <vprintfmt+0x2e5>
				putch('-', putdat);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	53                   	push   %ebx
  800ee4:	6a 2d                	push   $0x2d
  800ee6:	ff d6                	call   *%esi
				num = -(long long) num;
  800ee8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800eeb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800eee:	f7 da                	neg    %edx
  800ef0:	83 d1 00             	adc    $0x0,%ecx
  800ef3:	f7 d9                	neg    %ecx
  800ef5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ef8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800efd:	e9 10 01 00 00       	jmp    801012 <vprintfmt+0x3bb>
	else if (lflag)
  800f02:	85 c9                	test   %ecx,%ecx
  800f04:	75 1b                	jne    800f21 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800f06:	8b 45 14             	mov    0x14(%ebp),%eax
  800f09:	8b 00                	mov    (%eax),%eax
  800f0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f0e:	89 c1                	mov    %eax,%ecx
  800f10:	c1 f9 1f             	sar    $0x1f,%ecx
  800f13:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	8d 40 04             	lea    0x4(%eax),%eax
  800f1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f1f:	eb b9                	jmp    800eda <vprintfmt+0x283>
		return va_arg(*ap, long);
  800f21:	8b 45 14             	mov    0x14(%ebp),%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f29:	89 c1                	mov    %eax,%ecx
  800f2b:	c1 f9 1f             	sar    $0x1f,%ecx
  800f2e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f31:	8b 45 14             	mov    0x14(%ebp),%eax
  800f34:	8d 40 04             	lea    0x4(%eax),%eax
  800f37:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3a:	eb 9e                	jmp    800eda <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800f3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f3f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800f42:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f47:	e9 c6 00 00 00       	jmp    801012 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800f4c:	83 f9 01             	cmp    $0x1,%ecx
  800f4f:	7e 18                	jle    800f69 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800f51:	8b 45 14             	mov    0x14(%ebp),%eax
  800f54:	8b 10                	mov    (%eax),%edx
  800f56:	8b 48 04             	mov    0x4(%eax),%ecx
  800f59:	8d 40 08             	lea    0x8(%eax),%eax
  800f5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f5f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f64:	e9 a9 00 00 00       	jmp    801012 <vprintfmt+0x3bb>
	else if (lflag)
  800f69:	85 c9                	test   %ecx,%ecx
  800f6b:	75 1a                	jne    800f87 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800f6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f70:	8b 10                	mov    (%eax),%edx
  800f72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f77:	8d 40 04             	lea    0x4(%eax),%eax
  800f7a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f82:	e9 8b 00 00 00       	jmp    801012 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	8b 10                	mov    (%eax),%edx
  800f8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f91:	8d 40 04             	lea    0x4(%eax),%eax
  800f94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f97:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f9c:	eb 74                	jmp    801012 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800f9e:	83 f9 01             	cmp    $0x1,%ecx
  800fa1:	7e 15                	jle    800fb8 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800fa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa6:	8b 10                	mov    (%eax),%edx
  800fa8:	8b 48 04             	mov    0x4(%eax),%ecx
  800fab:	8d 40 08             	lea    0x8(%eax),%eax
  800fae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fb1:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb6:	eb 5a                	jmp    801012 <vprintfmt+0x3bb>
	else if (lflag)
  800fb8:	85 c9                	test   %ecx,%ecx
  800fba:	75 17                	jne    800fd3 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	8b 10                	mov    (%eax),%edx
  800fc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc6:	8d 40 04             	lea    0x4(%eax),%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fcc:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd1:	eb 3f                	jmp    801012 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800fd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd6:	8b 10                	mov    (%eax),%edx
  800fd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdd:	8d 40 04             	lea    0x4(%eax),%eax
  800fe0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fe3:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe8:	eb 28                	jmp    801012 <vprintfmt+0x3bb>
			putch('0', putdat);
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	53                   	push   %ebx
  800fee:	6a 30                	push   $0x30
  800ff0:	ff d6                	call   *%esi
			putch('x', putdat);
  800ff2:	83 c4 08             	add    $0x8,%esp
  800ff5:	53                   	push   %ebx
  800ff6:	6a 78                	push   $0x78
  800ff8:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ffa:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffd:	8b 10                	mov    (%eax),%edx
  800fff:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801004:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801007:	8d 40 04             	lea    0x4(%eax),%eax
  80100a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80100d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801019:	57                   	push   %edi
  80101a:	ff 75 e0             	pushl  -0x20(%ebp)
  80101d:	50                   	push   %eax
  80101e:	51                   	push   %ecx
  80101f:	52                   	push   %edx
  801020:	89 da                	mov    %ebx,%edx
  801022:	89 f0                	mov    %esi,%eax
  801024:	e8 45 fb ff ff       	call   800b6e <printnum>
			break;
  801029:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80102c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80102f:	83 c7 01             	add    $0x1,%edi
  801032:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801036:	83 f8 25             	cmp    $0x25,%eax
  801039:	0f 84 2f fc ff ff    	je     800c6e <vprintfmt+0x17>
			if (ch == '\0')
  80103f:	85 c0                	test   %eax,%eax
  801041:	0f 84 8b 00 00 00    	je     8010d2 <vprintfmt+0x47b>
			putch(ch, putdat);
  801047:	83 ec 08             	sub    $0x8,%esp
  80104a:	53                   	push   %ebx
  80104b:	50                   	push   %eax
  80104c:	ff d6                	call   *%esi
  80104e:	83 c4 10             	add    $0x10,%esp
  801051:	eb dc                	jmp    80102f <vprintfmt+0x3d8>
	if (lflag >= 2)
  801053:	83 f9 01             	cmp    $0x1,%ecx
  801056:	7e 15                	jle    80106d <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	8b 10                	mov    (%eax),%edx
  80105d:	8b 48 04             	mov    0x4(%eax),%ecx
  801060:	8d 40 08             	lea    0x8(%eax),%eax
  801063:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801066:	b8 10 00 00 00       	mov    $0x10,%eax
  80106b:	eb a5                	jmp    801012 <vprintfmt+0x3bb>
	else if (lflag)
  80106d:	85 c9                	test   %ecx,%ecx
  80106f:	75 17                	jne    801088 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801071:	8b 45 14             	mov    0x14(%ebp),%eax
  801074:	8b 10                	mov    (%eax),%edx
  801076:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107b:	8d 40 04             	lea    0x4(%eax),%eax
  80107e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801081:	b8 10 00 00 00       	mov    $0x10,%eax
  801086:	eb 8a                	jmp    801012 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801088:	8b 45 14             	mov    0x14(%ebp),%eax
  80108b:	8b 10                	mov    (%eax),%edx
  80108d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801092:	8d 40 04             	lea    0x4(%eax),%eax
  801095:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801098:	b8 10 00 00 00       	mov    $0x10,%eax
  80109d:	e9 70 ff ff ff       	jmp    801012 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8010a2:	83 ec 08             	sub    $0x8,%esp
  8010a5:	53                   	push   %ebx
  8010a6:	6a 25                	push   $0x25
  8010a8:	ff d6                	call   *%esi
			break;
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	e9 7a ff ff ff       	jmp    80102c <vprintfmt+0x3d5>
			putch('%', putdat);
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	53                   	push   %ebx
  8010b6:	6a 25                	push   $0x25
  8010b8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	89 f8                	mov    %edi,%eax
  8010bf:	eb 03                	jmp    8010c4 <vprintfmt+0x46d>
  8010c1:	83 e8 01             	sub    $0x1,%eax
  8010c4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010c8:	75 f7                	jne    8010c1 <vprintfmt+0x46a>
  8010ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010cd:	e9 5a ff ff ff       	jmp    80102c <vprintfmt+0x3d5>
}
  8010d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d5:	5b                   	pop    %ebx
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 18             	sub    $0x18,%esp
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010ed:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	74 26                	je     801121 <vsnprintf+0x47>
  8010fb:	85 d2                	test   %edx,%edx
  8010fd:	7e 22                	jle    801121 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010ff:	ff 75 14             	pushl  0x14(%ebp)
  801102:	ff 75 10             	pushl  0x10(%ebp)
  801105:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801108:	50                   	push   %eax
  801109:	68 1d 0c 80 00       	push   $0x800c1d
  80110e:	e8 44 fb ff ff       	call   800c57 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801116:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	83 c4 10             	add    $0x10,%esp
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    
		return -E_INVAL;
  801121:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801126:	eb f7                	jmp    80111f <vsnprintf+0x45>

00801128 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80112e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801131:	50                   	push   %eax
  801132:	ff 75 10             	pushl  0x10(%ebp)
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	ff 75 08             	pushl  0x8(%ebp)
  80113b:	e8 9a ff ff ff       	call   8010da <vsnprintf>
	va_end(ap);

	return rc;
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	57                   	push   %edi
  801146:	56                   	push   %esi
  801147:	53                   	push   %ebx
  801148:	83 ec 0c             	sub    $0xc,%esp
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80114e:	85 c0                	test   %eax,%eax
  801150:	74 13                	je     801165 <readline+0x23>
		fprintf(1, "%s", prompt);
  801152:	83 ec 04             	sub    $0x4,%esp
  801155:	50                   	push   %eax
  801156:	68 c1 38 80 00       	push   $0x8038c1
  80115b:	6a 01                	push   $0x1
  80115d:	e8 db 13 00 00       	call   80253d <fprintf>
  801162:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801165:	83 ec 0c             	sub    $0xc,%esp
  801168:	6a 00                	push   $0x0
  80116a:	e8 32 f8 ff ff       	call   8009a1 <iscons>
  80116f:	89 c7                	mov    %eax,%edi
  801171:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801174:	be 00 00 00 00       	mov    $0x0,%esi
  801179:	eb 4b                	jmp    8011c6 <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801180:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801183:	75 08                	jne    80118d <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    
				cprintf("read error: %e\n", c);
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	53                   	push   %ebx
  801191:	68 9f 3c 80 00       	push   $0x803c9f
  801196:	e8 bf f9 ff ff       	call   800b5a <cprintf>
  80119b:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80119e:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a3:	eb e0                	jmp    801185 <readline+0x43>
			if (echoing)
  8011a5:	85 ff                	test   %edi,%edi
  8011a7:	75 05                	jne    8011ae <readline+0x6c>
			i--;
  8011a9:	83 ee 01             	sub    $0x1,%esi
  8011ac:	eb 18                	jmp    8011c6 <readline+0x84>
				cputchar('\b');
  8011ae:	83 ec 0c             	sub    $0xc,%esp
  8011b1:	6a 08                	push   $0x8
  8011b3:	e8 a2 f7 ff ff       	call   80095a <cputchar>
  8011b8:	83 c4 10             	add    $0x10,%esp
  8011bb:	eb ec                	jmp    8011a9 <readline+0x67>
			buf[i++] = c;
  8011bd:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  8011c3:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8011c6:	e8 ab f7 ff ff       	call   800976 <getchar>
  8011cb:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 aa                	js     80117b <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011d1:	83 f8 08             	cmp    $0x8,%eax
  8011d4:	0f 94 c2             	sete   %dl
  8011d7:	83 f8 7f             	cmp    $0x7f,%eax
  8011da:	0f 94 c0             	sete   %al
  8011dd:	08 c2                	or     %al,%dl
  8011df:	74 04                	je     8011e5 <readline+0xa3>
  8011e1:	85 f6                	test   %esi,%esi
  8011e3:	7f c0                	jg     8011a5 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011e5:	83 fb 1f             	cmp    $0x1f,%ebx
  8011e8:	7e 1a                	jle    801204 <readline+0xc2>
  8011ea:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011f0:	7f 12                	jg     801204 <readline+0xc2>
			if (echoing)
  8011f2:	85 ff                	test   %edi,%edi
  8011f4:	74 c7                	je     8011bd <readline+0x7b>
				cputchar(c);
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	53                   	push   %ebx
  8011fa:	e8 5b f7 ff ff       	call   80095a <cputchar>
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	eb b9                	jmp    8011bd <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  801204:	83 fb 0a             	cmp    $0xa,%ebx
  801207:	74 05                	je     80120e <readline+0xcc>
  801209:	83 fb 0d             	cmp    $0xd,%ebx
  80120c:	75 b8                	jne    8011c6 <readline+0x84>
			if (echoing)
  80120e:	85 ff                	test   %edi,%edi
  801210:	75 11                	jne    801223 <readline+0xe1>
			buf[i] = 0;
  801212:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  801219:	b8 20 50 80 00       	mov    $0x805020,%eax
  80121e:	e9 62 ff ff ff       	jmp    801185 <readline+0x43>
				cputchar('\n');
  801223:	83 ec 0c             	sub    $0xc,%esp
  801226:	6a 0a                	push   $0xa
  801228:	e8 2d f7 ff ff       	call   80095a <cputchar>
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	eb e0                	jmp    801212 <readline+0xd0>

00801232 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801238:	b8 00 00 00 00       	mov    $0x0,%eax
  80123d:	eb 03                	jmp    801242 <strlen+0x10>
		n++;
  80123f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801242:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801246:	75 f7                	jne    80123f <strlen+0xd>
	return n;
}
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801250:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801253:	b8 00 00 00 00       	mov    $0x0,%eax
  801258:	eb 03                	jmp    80125d <strnlen+0x13>
		n++;
  80125a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125d:	39 d0                	cmp    %edx,%eax
  80125f:	74 06                	je     801267 <strnlen+0x1d>
  801261:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801265:	75 f3                	jne    80125a <strnlen+0x10>
	return n;
}
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    

00801269 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	53                   	push   %ebx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801273:	89 c2                	mov    %eax,%edx
  801275:	83 c1 01             	add    $0x1,%ecx
  801278:	83 c2 01             	add    $0x1,%edx
  80127b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80127f:	88 5a ff             	mov    %bl,-0x1(%edx)
  801282:	84 db                	test   %bl,%bl
  801284:	75 ef                	jne    801275 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801286:	5b                   	pop    %ebx
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    

00801289 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	53                   	push   %ebx
  80128d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801290:	53                   	push   %ebx
  801291:	e8 9c ff ff ff       	call   801232 <strlen>
  801296:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801299:	ff 75 0c             	pushl  0xc(%ebp)
  80129c:	01 d8                	add    %ebx,%eax
  80129e:	50                   	push   %eax
  80129f:	e8 c5 ff ff ff       	call   801269 <strcpy>
	return dst;
}
  8012a4:	89 d8                	mov    %ebx,%eax
  8012a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b6:	89 f3                	mov    %esi,%ebx
  8012b8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012bb:	89 f2                	mov    %esi,%edx
  8012bd:	eb 0f                	jmp    8012ce <strncpy+0x23>
		*dst++ = *src;
  8012bf:	83 c2 01             	add    $0x1,%edx
  8012c2:	0f b6 01             	movzbl (%ecx),%eax
  8012c5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012c8:	80 39 01             	cmpb   $0x1,(%ecx)
  8012cb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8012ce:	39 da                	cmp    %ebx,%edx
  8012d0:	75 ed                	jne    8012bf <strncpy+0x14>
	}
	return ret;
}
  8012d2:	89 f0                	mov    %esi,%eax
  8012d4:	5b                   	pop    %ebx
  8012d5:	5e                   	pop    %esi
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
  8012dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e6:	89 f0                	mov    %esi,%eax
  8012e8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8012ec:	85 c9                	test   %ecx,%ecx
  8012ee:	75 0b                	jne    8012fb <strlcpy+0x23>
  8012f0:	eb 17                	jmp    801309 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8012f2:	83 c2 01             	add    $0x1,%edx
  8012f5:	83 c0 01             	add    $0x1,%eax
  8012f8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8012fb:	39 d8                	cmp    %ebx,%eax
  8012fd:	74 07                	je     801306 <strlcpy+0x2e>
  8012ff:	0f b6 0a             	movzbl (%edx),%ecx
  801302:	84 c9                	test   %cl,%cl
  801304:	75 ec                	jne    8012f2 <strlcpy+0x1a>
		*dst = '\0';
  801306:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801309:	29 f0                	sub    %esi,%eax
}
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801315:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801318:	eb 06                	jmp    801320 <strcmp+0x11>
		p++, q++;
  80131a:	83 c1 01             	add    $0x1,%ecx
  80131d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801320:	0f b6 01             	movzbl (%ecx),%eax
  801323:	84 c0                	test   %al,%al
  801325:	74 04                	je     80132b <strcmp+0x1c>
  801327:	3a 02                	cmp    (%edx),%al
  801329:	74 ef                	je     80131a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80132b:	0f b6 c0             	movzbl %al,%eax
  80132e:	0f b6 12             	movzbl (%edx),%edx
  801331:	29 d0                	sub    %edx,%eax
}
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	53                   	push   %ebx
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133f:	89 c3                	mov    %eax,%ebx
  801341:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801344:	eb 06                	jmp    80134c <strncmp+0x17>
		n--, p++, q++;
  801346:	83 c0 01             	add    $0x1,%eax
  801349:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80134c:	39 d8                	cmp    %ebx,%eax
  80134e:	74 16                	je     801366 <strncmp+0x31>
  801350:	0f b6 08             	movzbl (%eax),%ecx
  801353:	84 c9                	test   %cl,%cl
  801355:	74 04                	je     80135b <strncmp+0x26>
  801357:	3a 0a                	cmp    (%edx),%cl
  801359:	74 eb                	je     801346 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80135b:	0f b6 00             	movzbl (%eax),%eax
  80135e:	0f b6 12             	movzbl (%edx),%edx
  801361:	29 d0                	sub    %edx,%eax
}
  801363:	5b                   	pop    %ebx
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    
		return 0;
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
  80136b:	eb f6                	jmp    801363 <strncmp+0x2e>

0080136d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801377:	0f b6 10             	movzbl (%eax),%edx
  80137a:	84 d2                	test   %dl,%dl
  80137c:	74 09                	je     801387 <strchr+0x1a>
		if (*s == c)
  80137e:	38 ca                	cmp    %cl,%dl
  801380:	74 0a                	je     80138c <strchr+0x1f>
	for (; *s; s++)
  801382:	83 c0 01             	add    $0x1,%eax
  801385:	eb f0                	jmp    801377 <strchr+0xa>
			return (char *) s;
	return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801398:	eb 03                	jmp    80139d <strfind+0xf>
  80139a:	83 c0 01             	add    $0x1,%eax
  80139d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8013a0:	38 ca                	cmp    %cl,%dl
  8013a2:	74 04                	je     8013a8 <strfind+0x1a>
  8013a4:	84 d2                	test   %dl,%dl
  8013a6:	75 f2                	jne    80139a <strfind+0xc>
			break;
	return (char *) s;
}
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	57                   	push   %edi
  8013ae:	56                   	push   %esi
  8013af:	53                   	push   %ebx
  8013b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8013b6:	85 c9                	test   %ecx,%ecx
  8013b8:	74 13                	je     8013cd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8013ba:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013c0:	75 05                	jne    8013c7 <memset+0x1d>
  8013c2:	f6 c1 03             	test   $0x3,%cl
  8013c5:	74 0d                	je     8013d4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	fc                   	cld    
  8013cb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8013cd:	89 f8                	mov    %edi,%eax
  8013cf:	5b                   	pop    %ebx
  8013d0:	5e                   	pop    %esi
  8013d1:	5f                   	pop    %edi
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    
		c &= 0xFF;
  8013d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013d8:	89 d3                	mov    %edx,%ebx
  8013da:	c1 e3 08             	shl    $0x8,%ebx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e0 18             	shl    $0x18,%eax
  8013e2:	89 d6                	mov    %edx,%esi
  8013e4:	c1 e6 10             	shl    $0x10,%esi
  8013e7:	09 f0                	or     %esi,%eax
  8013e9:	09 c2                	or     %eax,%edx
  8013eb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8013ed:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8013f0:	89 d0                	mov    %edx,%eax
  8013f2:	fc                   	cld    
  8013f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8013f5:	eb d6                	jmp    8013cd <memset+0x23>

008013f7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	57                   	push   %edi
  8013fb:	56                   	push   %esi
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801402:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801405:	39 c6                	cmp    %eax,%esi
  801407:	73 35                	jae    80143e <memmove+0x47>
  801409:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80140c:	39 c2                	cmp    %eax,%edx
  80140e:	76 2e                	jbe    80143e <memmove+0x47>
		s += n;
		d += n;
  801410:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801413:	89 d6                	mov    %edx,%esi
  801415:	09 fe                	or     %edi,%esi
  801417:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80141d:	74 0c                	je     80142b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80141f:	83 ef 01             	sub    $0x1,%edi
  801422:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801425:	fd                   	std    
  801426:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801428:	fc                   	cld    
  801429:	eb 21                	jmp    80144c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80142b:	f6 c1 03             	test   $0x3,%cl
  80142e:	75 ef                	jne    80141f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801430:	83 ef 04             	sub    $0x4,%edi
  801433:	8d 72 fc             	lea    -0x4(%edx),%esi
  801436:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801439:	fd                   	std    
  80143a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80143c:	eb ea                	jmp    801428 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80143e:	89 f2                	mov    %esi,%edx
  801440:	09 c2                	or     %eax,%edx
  801442:	f6 c2 03             	test   $0x3,%dl
  801445:	74 09                	je     801450 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801447:	89 c7                	mov    %eax,%edi
  801449:	fc                   	cld    
  80144a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80144c:	5e                   	pop    %esi
  80144d:	5f                   	pop    %edi
  80144e:	5d                   	pop    %ebp
  80144f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801450:	f6 c1 03             	test   $0x3,%cl
  801453:	75 f2                	jne    801447 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801455:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801458:	89 c7                	mov    %eax,%edi
  80145a:	fc                   	cld    
  80145b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80145d:	eb ed                	jmp    80144c <memmove+0x55>

0080145f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801462:	ff 75 10             	pushl  0x10(%ebp)
  801465:	ff 75 0c             	pushl  0xc(%ebp)
  801468:	ff 75 08             	pushl  0x8(%ebp)
  80146b:	e8 87 ff ff ff       	call   8013f7 <memmove>
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	56                   	push   %esi
  801476:	53                   	push   %ebx
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147d:	89 c6                	mov    %eax,%esi
  80147f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801482:	39 f0                	cmp    %esi,%eax
  801484:	74 1c                	je     8014a2 <memcmp+0x30>
		if (*s1 != *s2)
  801486:	0f b6 08             	movzbl (%eax),%ecx
  801489:	0f b6 1a             	movzbl (%edx),%ebx
  80148c:	38 d9                	cmp    %bl,%cl
  80148e:	75 08                	jne    801498 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801490:	83 c0 01             	add    $0x1,%eax
  801493:	83 c2 01             	add    $0x1,%edx
  801496:	eb ea                	jmp    801482 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801498:	0f b6 c1             	movzbl %cl,%eax
  80149b:	0f b6 db             	movzbl %bl,%ebx
  80149e:	29 d8                	sub    %ebx,%eax
  8014a0:	eb 05                	jmp    8014a7 <memcmp+0x35>
	}

	return 0;
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a7:	5b                   	pop    %ebx
  8014a8:	5e                   	pop    %esi
  8014a9:	5d                   	pop    %ebp
  8014aa:	c3                   	ret    

008014ab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8014b4:	89 c2                	mov    %eax,%edx
  8014b6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8014b9:	39 d0                	cmp    %edx,%eax
  8014bb:	73 09                	jae    8014c6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014bd:	38 08                	cmp    %cl,(%eax)
  8014bf:	74 05                	je     8014c6 <memfind+0x1b>
	for (; s < ends; s++)
  8014c1:	83 c0 01             	add    $0x1,%eax
  8014c4:	eb f3                	jmp    8014b9 <memfind+0xe>
			break;
	return (void *) s;
}
  8014c6:	5d                   	pop    %ebp
  8014c7:	c3                   	ret    

008014c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	57                   	push   %edi
  8014cc:	56                   	push   %esi
  8014cd:	53                   	push   %ebx
  8014ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d4:	eb 03                	jmp    8014d9 <strtol+0x11>
		s++;
  8014d6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8014d9:	0f b6 01             	movzbl (%ecx),%eax
  8014dc:	3c 20                	cmp    $0x20,%al
  8014de:	74 f6                	je     8014d6 <strtol+0xe>
  8014e0:	3c 09                	cmp    $0x9,%al
  8014e2:	74 f2                	je     8014d6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8014e4:	3c 2b                	cmp    $0x2b,%al
  8014e6:	74 2e                	je     801516 <strtol+0x4e>
	int neg = 0;
  8014e8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8014ed:	3c 2d                	cmp    $0x2d,%al
  8014ef:	74 2f                	je     801520 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014f1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8014f7:	75 05                	jne    8014fe <strtol+0x36>
  8014f9:	80 39 30             	cmpb   $0x30,(%ecx)
  8014fc:	74 2c                	je     80152a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8014fe:	85 db                	test   %ebx,%ebx
  801500:	75 0a                	jne    80150c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801502:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801507:	80 39 30             	cmpb   $0x30,(%ecx)
  80150a:	74 28                	je     801534 <strtol+0x6c>
		base = 10;
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801514:	eb 50                	jmp    801566 <strtol+0x9e>
		s++;
  801516:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801519:	bf 00 00 00 00       	mov    $0x0,%edi
  80151e:	eb d1                	jmp    8014f1 <strtol+0x29>
		s++, neg = 1;
  801520:	83 c1 01             	add    $0x1,%ecx
  801523:	bf 01 00 00 00       	mov    $0x1,%edi
  801528:	eb c7                	jmp    8014f1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80152a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80152e:	74 0e                	je     80153e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801530:	85 db                	test   %ebx,%ebx
  801532:	75 d8                	jne    80150c <strtol+0x44>
		s++, base = 8;
  801534:	83 c1 01             	add    $0x1,%ecx
  801537:	bb 08 00 00 00       	mov    $0x8,%ebx
  80153c:	eb ce                	jmp    80150c <strtol+0x44>
		s += 2, base = 16;
  80153e:	83 c1 02             	add    $0x2,%ecx
  801541:	bb 10 00 00 00       	mov    $0x10,%ebx
  801546:	eb c4                	jmp    80150c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801548:	8d 72 9f             	lea    -0x61(%edx),%esi
  80154b:	89 f3                	mov    %esi,%ebx
  80154d:	80 fb 19             	cmp    $0x19,%bl
  801550:	77 29                	ja     80157b <strtol+0xb3>
			dig = *s - 'a' + 10;
  801552:	0f be d2             	movsbl %dl,%edx
  801555:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801558:	3b 55 10             	cmp    0x10(%ebp),%edx
  80155b:	7d 30                	jge    80158d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80155d:	83 c1 01             	add    $0x1,%ecx
  801560:	0f af 45 10          	imul   0x10(%ebp),%eax
  801564:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801566:	0f b6 11             	movzbl (%ecx),%edx
  801569:	8d 72 d0             	lea    -0x30(%edx),%esi
  80156c:	89 f3                	mov    %esi,%ebx
  80156e:	80 fb 09             	cmp    $0x9,%bl
  801571:	77 d5                	ja     801548 <strtol+0x80>
			dig = *s - '0';
  801573:	0f be d2             	movsbl %dl,%edx
  801576:	83 ea 30             	sub    $0x30,%edx
  801579:	eb dd                	jmp    801558 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  80157b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80157e:	89 f3                	mov    %esi,%ebx
  801580:	80 fb 19             	cmp    $0x19,%bl
  801583:	77 08                	ja     80158d <strtol+0xc5>
			dig = *s - 'A' + 10;
  801585:	0f be d2             	movsbl %dl,%edx
  801588:	83 ea 37             	sub    $0x37,%edx
  80158b:	eb cb                	jmp    801558 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  80158d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801591:	74 05                	je     801598 <strtol+0xd0>
		*endptr = (char *) s;
  801593:	8b 75 0c             	mov    0xc(%ebp),%esi
  801596:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801598:	89 c2                	mov    %eax,%edx
  80159a:	f7 da                	neg    %edx
  80159c:	85 ff                	test   %edi,%edi
  80159e:	0f 45 c2             	cmovne %edx,%eax
}
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5f                   	pop    %edi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    

008015a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	57                   	push   %edi
  8015aa:	56                   	push   %esi
  8015ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b7:	89 c3                	mov    %eax,%ebx
  8015b9:	89 c7                	mov    %eax,%edi
  8015bb:	89 c6                	mov    %eax,%esi
  8015bd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5f                   	pop    %edi
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    

008015c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	57                   	push   %edi
  8015c8:	56                   	push   %esi
  8015c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d4:	89 d1                	mov    %edx,%ecx
  8015d6:	89 d3                	mov    %edx,%ebx
  8015d8:	89 d7                	mov    %edx,%edi
  8015da:	89 d6                	mov    %edx,%esi
  8015dc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8015de:	5b                   	pop    %ebx
  8015df:	5e                   	pop    %esi
  8015e0:	5f                   	pop    %edi
  8015e1:	5d                   	pop    %ebp
  8015e2:	c3                   	ret    

008015e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	57                   	push   %edi
  8015e7:	56                   	push   %esi
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8015f9:	89 cb                	mov    %ecx,%ebx
  8015fb:	89 cf                	mov    %ecx,%edi
  8015fd:	89 ce                	mov    %ecx,%esi
  8015ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  801601:	85 c0                	test   %eax,%eax
  801603:	7f 08                	jg     80160d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801605:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801608:	5b                   	pop    %ebx
  801609:	5e                   	pop    %esi
  80160a:	5f                   	pop    %edi
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80160d:	83 ec 0c             	sub    $0xc,%esp
  801610:	50                   	push   %eax
  801611:	6a 03                	push   $0x3
  801613:	68 af 3c 80 00       	push   $0x803caf
  801618:	6a 23                	push   $0x23
  80161a:	68 cc 3c 80 00       	push   $0x803ccc
  80161f:	e8 5b f4 ff ff       	call   800a7f <_panic>

00801624 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	57                   	push   %edi
  801628:	56                   	push   %esi
  801629:	53                   	push   %ebx
	asm volatile("int %1\n"
  80162a:	ba 00 00 00 00       	mov    $0x0,%edx
  80162f:	b8 02 00 00 00       	mov    $0x2,%eax
  801634:	89 d1                	mov    %edx,%ecx
  801636:	89 d3                	mov    %edx,%ebx
  801638:	89 d7                	mov    %edx,%edi
  80163a:	89 d6                	mov    %edx,%esi
  80163c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80163e:	5b                   	pop    %ebx
  80163f:	5e                   	pop    %esi
  801640:	5f                   	pop    %edi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <sys_yield>:

void
sys_yield(void)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	57                   	push   %edi
  801647:	56                   	push   %esi
  801648:	53                   	push   %ebx
	asm volatile("int %1\n"
  801649:	ba 00 00 00 00       	mov    $0x0,%edx
  80164e:	b8 0b 00 00 00       	mov    $0xb,%eax
  801653:	89 d1                	mov    %edx,%ecx
  801655:	89 d3                	mov    %edx,%ebx
  801657:	89 d7                	mov    %edx,%edi
  801659:	89 d6                	mov    %edx,%esi
  80165b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80165d:	5b                   	pop    %ebx
  80165e:	5e                   	pop    %esi
  80165f:	5f                   	pop    %edi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    

00801662 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	57                   	push   %edi
  801666:	56                   	push   %esi
  801667:	53                   	push   %ebx
  801668:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80166b:	be 00 00 00 00       	mov    $0x0,%esi
  801670:	8b 55 08             	mov    0x8(%ebp),%edx
  801673:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801676:	b8 04 00 00 00       	mov    $0x4,%eax
  80167b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80167e:	89 f7                	mov    %esi,%edi
  801680:	cd 30                	int    $0x30
	if(check && ret > 0)
  801682:	85 c0                	test   %eax,%eax
  801684:	7f 08                	jg     80168e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801686:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801689:	5b                   	pop    %ebx
  80168a:	5e                   	pop    %esi
  80168b:	5f                   	pop    %edi
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80168e:	83 ec 0c             	sub    $0xc,%esp
  801691:	50                   	push   %eax
  801692:	6a 04                	push   $0x4
  801694:	68 af 3c 80 00       	push   $0x803caf
  801699:	6a 23                	push   $0x23
  80169b:	68 cc 3c 80 00       	push   $0x803ccc
  8016a0:	e8 da f3 ff ff       	call   800a7f <_panic>

008016a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	57                   	push   %edi
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8016b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016bc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	7f 08                	jg     8016d0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8016c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016d0:	83 ec 0c             	sub    $0xc,%esp
  8016d3:	50                   	push   %eax
  8016d4:	6a 05                	push   $0x5
  8016d6:	68 af 3c 80 00       	push   $0x803caf
  8016db:	6a 23                	push   $0x23
  8016dd:	68 cc 3c 80 00       	push   $0x803ccc
  8016e2:	e8 98 f3 ff ff       	call   800a7f <_panic>

008016e7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	57                   	push   %edi
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fb:	b8 06 00 00 00       	mov    $0x6,%eax
  801700:	89 df                	mov    %ebx,%edi
  801702:	89 de                	mov    %ebx,%esi
  801704:	cd 30                	int    $0x30
	if(check && ret > 0)
  801706:	85 c0                	test   %eax,%eax
  801708:	7f 08                	jg     801712 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80170a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5e                   	pop    %esi
  80170f:	5f                   	pop    %edi
  801710:	5d                   	pop    %ebp
  801711:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	50                   	push   %eax
  801716:	6a 06                	push   $0x6
  801718:	68 af 3c 80 00       	push   $0x803caf
  80171d:	6a 23                	push   $0x23
  80171f:	68 cc 3c 80 00       	push   $0x803ccc
  801724:	e8 56 f3 ff ff       	call   800a7f <_panic>

00801729 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	57                   	push   %edi
  80172d:	56                   	push   %esi
  80172e:	53                   	push   %ebx
  80172f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801732:	bb 00 00 00 00       	mov    $0x0,%ebx
  801737:	8b 55 08             	mov    0x8(%ebp),%edx
  80173a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173d:	b8 08 00 00 00       	mov    $0x8,%eax
  801742:	89 df                	mov    %ebx,%edi
  801744:	89 de                	mov    %ebx,%esi
  801746:	cd 30                	int    $0x30
	if(check && ret > 0)
  801748:	85 c0                	test   %eax,%eax
  80174a:	7f 08                	jg     801754 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80174c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801754:	83 ec 0c             	sub    $0xc,%esp
  801757:	50                   	push   %eax
  801758:	6a 08                	push   $0x8
  80175a:	68 af 3c 80 00       	push   $0x803caf
  80175f:	6a 23                	push   $0x23
  801761:	68 cc 3c 80 00       	push   $0x803ccc
  801766:	e8 14 f3 ff ff       	call   800a7f <_panic>

0080176b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	57                   	push   %edi
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801774:	bb 00 00 00 00       	mov    $0x0,%ebx
  801779:	8b 55 08             	mov    0x8(%ebp),%edx
  80177c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80177f:	b8 09 00 00 00       	mov    $0x9,%eax
  801784:	89 df                	mov    %ebx,%edi
  801786:	89 de                	mov    %ebx,%esi
  801788:	cd 30                	int    $0x30
	if(check && ret > 0)
  80178a:	85 c0                	test   %eax,%eax
  80178c:	7f 08                	jg     801796 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80178e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5f                   	pop    %edi
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	50                   	push   %eax
  80179a:	6a 09                	push   $0x9
  80179c:	68 af 3c 80 00       	push   $0x803caf
  8017a1:	6a 23                	push   $0x23
  8017a3:	68 cc 3c 80 00       	push   $0x803ccc
  8017a8:	e8 d2 f2 ff ff       	call   800a7f <_panic>

008017ad <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	57                   	push   %edi
  8017b1:	56                   	push   %esi
  8017b2:	53                   	push   %ebx
  8017b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8017be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8017c6:	89 df                	mov    %ebx,%edi
  8017c8:	89 de                	mov    %ebx,%esi
  8017ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	7f 08                	jg     8017d8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8017d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d3:	5b                   	pop    %ebx
  8017d4:	5e                   	pop    %esi
  8017d5:	5f                   	pop    %edi
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017d8:	83 ec 0c             	sub    $0xc,%esp
  8017db:	50                   	push   %eax
  8017dc:	6a 0a                	push   $0xa
  8017de:	68 af 3c 80 00       	push   $0x803caf
  8017e3:	6a 23                	push   $0x23
  8017e5:	68 cc 3c 80 00       	push   $0x803ccc
  8017ea:	e8 90 f2 ff ff       	call   800a7f <_panic>

008017ef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	57                   	push   %edi
  8017f3:	56                   	push   %esi
  8017f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fb:	b8 0c 00 00 00       	mov    $0xc,%eax
  801800:	be 00 00 00 00       	mov    $0x0,%esi
  801805:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801808:	8b 7d 14             	mov    0x14(%ebp),%edi
  80180b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80180d:	5b                   	pop    %ebx
  80180e:	5e                   	pop    %esi
  80180f:	5f                   	pop    %edi
  801810:	5d                   	pop    %ebp
  801811:	c3                   	ret    

00801812 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	57                   	push   %edi
  801816:	56                   	push   %esi
  801817:	53                   	push   %ebx
  801818:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80181b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801820:	8b 55 08             	mov    0x8(%ebp),%edx
  801823:	b8 0d 00 00 00       	mov    $0xd,%eax
  801828:	89 cb                	mov    %ecx,%ebx
  80182a:	89 cf                	mov    %ecx,%edi
  80182c:	89 ce                	mov    %ecx,%esi
  80182e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801830:	85 c0                	test   %eax,%eax
  801832:	7f 08                	jg     80183c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801834:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801837:	5b                   	pop    %ebx
  801838:	5e                   	pop    %esi
  801839:	5f                   	pop    %edi
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	50                   	push   %eax
  801840:	6a 0d                	push   $0xd
  801842:	68 af 3c 80 00       	push   $0x803caf
  801847:	6a 23                	push   $0x23
  801849:	68 cc 3c 80 00       	push   $0x803ccc
  80184e:	e8 2c f2 ff ff       	call   800a7f <_panic>

00801853 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	57                   	push   %edi
  801857:	56                   	push   %esi
  801858:	53                   	push   %ebx
	asm volatile("int %1\n"
  801859:	ba 00 00 00 00       	mov    $0x0,%edx
  80185e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801863:	89 d1                	mov    %edx,%ecx
  801865:	89 d3                	mov    %edx,%ebx
  801867:	89 d7                	mov    %edx,%edi
  801869:	89 d6                	mov    %edx,%esi
  80186b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80186d:	5b                   	pop    %ebx
  80186e:	5e                   	pop    %esi
  80186f:	5f                   	pop    %edi
  801870:	5d                   	pop    %ebp
  801871:	c3                   	ret    

00801872 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  80187a:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  80187c:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801880:	74 7f                	je     801901 <pgfault+0x8f>
  801882:	89 d8                	mov    %ebx,%eax
  801884:	c1 e8 0c             	shr    $0xc,%eax
  801887:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80188e:	f6 c4 08             	test   $0x8,%ah
  801891:	74 6e                	je     801901 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  801893:	e8 8c fd ff ff       	call   801624 <sys_getenvid>
  801898:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	6a 07                	push   $0x7
  80189f:	68 00 f0 7f 00       	push   $0x7ff000
  8018a4:	50                   	push   %eax
  8018a5:	e8 b8 fd ff ff       	call   801662 <sys_page_alloc>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 64                	js     801915 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  8018b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	68 00 10 00 00       	push   $0x1000
  8018bf:	53                   	push   %ebx
  8018c0:	68 00 f0 7f 00       	push   $0x7ff000
  8018c5:	e8 2d fb ff ff       	call   8013f7 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  8018ca:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8018d1:	53                   	push   %ebx
  8018d2:	56                   	push   %esi
  8018d3:	68 00 f0 7f 00       	push   $0x7ff000
  8018d8:	56                   	push   %esi
  8018d9:	e8 c7 fd ff ff       	call   8016a5 <sys_page_map>
  8018de:	83 c4 20             	add    $0x20,%esp
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	78 42                	js     801927 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	68 00 f0 7f 00       	push   $0x7ff000
  8018ed:	56                   	push   %esi
  8018ee:	e8 f4 fd ff ff       	call   8016e7 <sys_page_unmap>
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 3f                	js     801939 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  8018fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 dc 3c 80 00       	push   $0x803cdc
  801909:	6a 1d                	push   $0x1d
  80190b:	68 6b 3d 80 00       	push   $0x803d6b
  801910:	e8 6a f1 ff ff       	call   800a7f <_panic>
		panic("pgfault:page allocation failed: %e", r);
  801915:	50                   	push   %eax
  801916:	68 04 3d 80 00       	push   $0x803d04
  80191b:	6a 28                	push   $0x28
  80191d:	68 6b 3d 80 00       	push   $0x803d6b
  801922:	e8 58 f1 ff ff       	call   800a7f <_panic>
		panic("pgfault:page map failed: %e", r);
  801927:	50                   	push   %eax
  801928:	68 76 3d 80 00       	push   $0x803d76
  80192d:	6a 2c                	push   $0x2c
  80192f:	68 6b 3d 80 00       	push   $0x803d6b
  801934:	e8 46 f1 ff ff       	call   800a7f <_panic>
		panic("pgfault: page unmap failed: %e", r);
  801939:	50                   	push   %eax
  80193a:	68 28 3d 80 00       	push   $0x803d28
  80193f:	6a 2e                	push   $0x2e
  801941:	68 6b 3d 80 00       	push   $0x803d6b
  801946:	e8 34 f1 ff ff       	call   800a7f <_panic>

0080194b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	57                   	push   %edi
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  801954:	68 72 18 80 00       	push   $0x801872
  801959:	e8 04 1a 00 00       	call   803362 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80195e:	b8 07 00 00 00       	mov    $0x7,%eax
  801963:	cd 30                	int    $0x30
  801965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 2f                	js     80199e <fork+0x53>
  80196f:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801971:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  801976:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80197a:	75 6e                	jne    8019ea <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80197c:	e8 a3 fc ff ff       	call   801624 <sys_getenvid>
  801981:	25 ff 03 00 00       	and    $0x3ff,%eax
  801986:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801989:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80198e:	a3 28 54 80 00       	mov    %eax,0x805428
		return 0;
  801993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  801996:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801999:	5b                   	pop    %ebx
  80199a:	5e                   	pop    %esi
  80199b:	5f                   	pop    %edi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  80199e:	50                   	push   %eax
  80199f:	68 48 3d 80 00       	push   $0x803d48
  8019a4:	6a 6e                	push   $0x6e
  8019a6:	68 6b 3d 80 00       	push   $0x803d6b
  8019ab:	e8 cf f0 ff ff       	call   800a7f <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8019b0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8019b7:	83 ec 0c             	sub    $0xc,%esp
  8019ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8019bf:	50                   	push   %eax
  8019c0:	56                   	push   %esi
  8019c1:	57                   	push   %edi
  8019c2:	56                   	push   %esi
  8019c3:	6a 00                	push   $0x0
  8019c5:	e8 db fc ff ff       	call   8016a5 <sys_page_map>
  8019ca:	83 c4 20             	add    $0x20,%esp
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d4:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	78 bb                	js     801996 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8019db:	83 c3 01             	add    $0x1,%ebx
  8019de:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8019e4:	0f 84 a6 00 00 00    	je     801a90 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8019ea:	89 d8                	mov    %ebx,%eax
  8019ec:	c1 e8 0a             	shr    $0xa,%eax
  8019ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019f6:	a8 01                	test   $0x1,%al
  8019f8:	74 e1                	je     8019db <fork+0x90>
  8019fa:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a01:	a8 01                	test   $0x1,%al
  801a03:	74 d6                	je     8019db <fork+0x90>
  801a05:	89 de                	mov    %ebx,%esi
  801a07:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  801a0a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a11:	f6 c4 04             	test   $0x4,%ah
  801a14:	75 9a                	jne    8019b0 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801a16:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a1d:	a8 02                	test   $0x2,%al
  801a1f:	75 0c                	jne    801a2d <fork+0xe2>
  801a21:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a28:	f6 c4 08             	test   $0x8,%ah
  801a2b:	74 42                	je     801a6f <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	68 05 08 00 00       	push   $0x805
  801a35:	56                   	push   %esi
  801a36:	57                   	push   %edi
  801a37:	56                   	push   %esi
  801a38:	6a 00                	push   $0x0
  801a3a:	e8 66 fc ff ff       	call   8016a5 <sys_page_map>
  801a3f:	83 c4 20             	add    $0x20,%esp
  801a42:	85 c0                	test   %eax,%eax
  801a44:	0f 88 4c ff ff ff    	js     801996 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801a4a:	83 ec 0c             	sub    $0xc,%esp
  801a4d:	68 05 08 00 00       	push   $0x805
  801a52:	56                   	push   %esi
  801a53:	6a 00                	push   $0x0
  801a55:	56                   	push   %esi
  801a56:	6a 00                	push   $0x0
  801a58:	e8 48 fc ff ff       	call   8016a5 <sys_page_map>
  801a5d:	83 c4 20             	add    $0x20,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a67:	0f 4f c1             	cmovg  %ecx,%eax
  801a6a:	e9 68 ff ff ff       	jmp    8019d7 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	6a 05                	push   $0x5
  801a74:	56                   	push   %esi
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	6a 00                	push   $0x0
  801a79:	e8 27 fc ff ff       	call   8016a5 <sys_page_map>
  801a7e:	83 c4 20             	add    $0x20,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a88:	0f 4f c1             	cmovg  %ecx,%eax
  801a8b:	e9 47 ff ff ff       	jmp    8019d7 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	6a 07                	push   $0x7
  801a95:	68 00 f0 bf ee       	push   $0xeebff000
  801a9a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801a9d:	57                   	push   %edi
  801a9e:	e8 bf fb ff ff       	call   801662 <sys_page_alloc>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	0f 88 e8 fe ff ff    	js     801996 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801aae:	83 ec 08             	sub    $0x8,%esp
  801ab1:	68 c7 33 80 00       	push   $0x8033c7
  801ab6:	57                   	push   %edi
  801ab7:	e8 f1 fc ff ff       	call   8017ad <sys_env_set_pgfault_upcall>
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	0f 88 cf fe ff ff    	js     801996 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	6a 02                	push   $0x2
  801acc:	57                   	push   %edi
  801acd:	e8 57 fc ff ff       	call   801729 <sys_env_set_status>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 08                	js     801ae1 <fork+0x196>
	return eid;
  801ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801adc:	e9 b5 fe ff ff       	jmp    801996 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  801ae1:	50                   	push   %eax
  801ae2:	68 92 3d 80 00       	push   $0x803d92
  801ae7:	68 87 00 00 00       	push   $0x87
  801aec:	68 6b 3d 80 00       	push   $0x803d6b
  801af1:	e8 89 ef ff ff       	call   800a7f <_panic>

00801af6 <sfork>:

// Challenge!
int sfork(void)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801afc:	68 b0 3d 80 00       	push   $0x803db0
  801b01:	68 8f 00 00 00       	push   $0x8f
  801b06:	68 6b 3d 80 00       	push   $0x803d6b
  801b0b:	e8 6f ef ff ff       	call   800a7f <_panic>

00801b10 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	8b 55 08             	mov    0x8(%ebp),%edx
  801b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801b1c:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801b1e:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801b21:	83 3a 01             	cmpl   $0x1,(%edx)
  801b24:	7e 09                	jle    801b2f <argstart+0x1f>
  801b26:	ba 81 37 80 00       	mov    $0x803781,%edx
  801b2b:	85 c9                	test   %ecx,%ecx
  801b2d:	75 05                	jne    801b34 <argstart+0x24>
  801b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b34:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801b37:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <argnext>:

int
argnext(struct Argstate *args)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	53                   	push   %ebx
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801b4a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801b51:	8b 43 08             	mov    0x8(%ebx),%eax
  801b54:	85 c0                	test   %eax,%eax
  801b56:	74 72                	je     801bca <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801b58:	80 38 00             	cmpb   $0x0,(%eax)
  801b5b:	75 48                	jne    801ba5 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801b5d:	8b 0b                	mov    (%ebx),%ecx
  801b5f:	83 39 01             	cmpl   $0x1,(%ecx)
  801b62:	74 58                	je     801bbc <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801b64:	8b 53 04             	mov    0x4(%ebx),%edx
  801b67:	8b 42 04             	mov    0x4(%edx),%eax
  801b6a:	80 38 2d             	cmpb   $0x2d,(%eax)
  801b6d:	75 4d                	jne    801bbc <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801b6f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801b73:	74 47                	je     801bbc <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801b75:	83 c0 01             	add    $0x1,%eax
  801b78:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801b7b:	83 ec 04             	sub    $0x4,%esp
  801b7e:	8b 01                	mov    (%ecx),%eax
  801b80:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801b87:	50                   	push   %eax
  801b88:	8d 42 08             	lea    0x8(%edx),%eax
  801b8b:	50                   	push   %eax
  801b8c:	83 c2 04             	add    $0x4,%edx
  801b8f:	52                   	push   %edx
  801b90:	e8 62 f8 ff ff       	call   8013f7 <memmove>
		(*args->argc)--;
  801b95:	8b 03                	mov    (%ebx),%eax
  801b97:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801b9a:	8b 43 08             	mov    0x8(%ebx),%eax
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ba3:	74 11                	je     801bb6 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801ba5:	8b 53 08             	mov    0x8(%ebx),%edx
  801ba8:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801bab:	83 c2 01             	add    $0x1,%edx
  801bae:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801bb6:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801bba:	75 e9                	jne    801ba5 <argnext+0x65>
	args->curarg = 0;
  801bbc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bc8:	eb e7                	jmp    801bb1 <argnext+0x71>
		return -1;
  801bca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bcf:	eb e0                	jmp    801bb1 <argnext+0x71>

00801bd1 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	53                   	push   %ebx
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801bdb:	8b 43 08             	mov    0x8(%ebx),%eax
  801bde:	85 c0                	test   %eax,%eax
  801be0:	74 5b                	je     801c3d <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  801be2:	80 38 00             	cmpb   $0x0,(%eax)
  801be5:	74 12                	je     801bf9 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801be7:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801bea:	c7 43 08 81 37 80 00 	movl   $0x803781,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801bf1:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    
	} else if (*args->argc > 1) {
  801bf9:	8b 13                	mov    (%ebx),%edx
  801bfb:	83 3a 01             	cmpl   $0x1,(%edx)
  801bfe:	7f 10                	jg     801c10 <argnextvalue+0x3f>
		args->argvalue = 0;
  801c00:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801c07:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801c0e:	eb e1                	jmp    801bf1 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801c10:	8b 43 04             	mov    0x4(%ebx),%eax
  801c13:	8b 48 04             	mov    0x4(%eax),%ecx
  801c16:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c19:	83 ec 04             	sub    $0x4,%esp
  801c1c:	8b 12                	mov    (%edx),%edx
  801c1e:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801c25:	52                   	push   %edx
  801c26:	8d 50 08             	lea    0x8(%eax),%edx
  801c29:	52                   	push   %edx
  801c2a:	83 c0 04             	add    $0x4,%eax
  801c2d:	50                   	push   %eax
  801c2e:	e8 c4 f7 ff ff       	call   8013f7 <memmove>
		(*args->argc)--;
  801c33:	8b 03                	mov    (%ebx),%eax
  801c35:	83 28 01             	subl   $0x1,(%eax)
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	eb b4                	jmp    801bf1 <argnextvalue+0x20>
		return 0;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c42:	eb b0                	jmp    801bf4 <argnextvalue+0x23>

00801c44 <argvalue>:
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
  801c4a:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801c4d:	8b 42 0c             	mov    0xc(%edx),%eax
  801c50:	85 c0                	test   %eax,%eax
  801c52:	74 02                	je     801c56 <argvalue+0x12>
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	52                   	push   %edx
  801c5a:	e8 72 ff ff ff       	call   801bd1 <argnextvalue>
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	eb f0                	jmp    801c54 <argvalue+0x10>

00801c64 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	05 00 00 00 30       	add    $0x30000000,%eax
  801c6f:	c1 e8 0c             	shr    $0xc,%eax
}
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801c7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c84:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    

00801c8b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c91:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c96:	89 c2                	mov    %eax,%edx
  801c98:	c1 ea 16             	shr    $0x16,%edx
  801c9b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801ca2:	f6 c2 01             	test   $0x1,%dl
  801ca5:	74 2a                	je     801cd1 <fd_alloc+0x46>
  801ca7:	89 c2                	mov    %eax,%edx
  801ca9:	c1 ea 0c             	shr    $0xc,%edx
  801cac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cb3:	f6 c2 01             	test   $0x1,%dl
  801cb6:	74 19                	je     801cd1 <fd_alloc+0x46>
  801cb8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801cbd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801cc2:	75 d2                	jne    801c96 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cc4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801cca:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801ccf:	eb 07                	jmp    801cd8 <fd_alloc+0x4d>
			*fd_store = fd;
  801cd1:	89 01                	mov    %eax,(%ecx)
			return 0;
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    

00801cda <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ce0:	83 f8 1f             	cmp    $0x1f,%eax
  801ce3:	77 36                	ja     801d1b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801ce5:	c1 e0 0c             	shl    $0xc,%eax
  801ce8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ced:	89 c2                	mov    %eax,%edx
  801cef:	c1 ea 16             	shr    $0x16,%edx
  801cf2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cf9:	f6 c2 01             	test   $0x1,%dl
  801cfc:	74 24                	je     801d22 <fd_lookup+0x48>
  801cfe:	89 c2                	mov    %eax,%edx
  801d00:	c1 ea 0c             	shr    $0xc,%edx
  801d03:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d0a:	f6 c2 01             	test   $0x1,%dl
  801d0d:	74 1a                	je     801d29 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d12:	89 02                	mov    %eax,(%edx)
	return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    
		return -E_INVAL;
  801d1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d20:	eb f7                	jmp    801d19 <fd_lookup+0x3f>
		return -E_INVAL;
  801d22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d27:	eb f0                	jmp    801d19 <fd_lookup+0x3f>
  801d29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d2e:	eb e9                	jmp    801d19 <fd_lookup+0x3f>

00801d30 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d39:	ba 44 3e 80 00       	mov    $0x803e44,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801d3e:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801d43:	39 08                	cmp    %ecx,(%eax)
  801d45:	74 33                	je     801d7a <dev_lookup+0x4a>
  801d47:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801d4a:	8b 02                	mov    (%edx),%eax
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	75 f3                	jne    801d43 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d50:	a1 28 54 80 00       	mov    0x805428,%eax
  801d55:	8b 40 48             	mov    0x48(%eax),%eax
  801d58:	83 ec 04             	sub    $0x4,%esp
  801d5b:	51                   	push   %ecx
  801d5c:	50                   	push   %eax
  801d5d:	68 c8 3d 80 00       	push   $0x803dc8
  801d62:	e8 f3 ed ff ff       	call   800b5a <cprintf>
	*dev = 0;
  801d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    
			*dev = devtab[i];
  801d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d7d:	89 01                	mov    %eax,(%ecx)
			return 0;
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d84:	eb f2                	jmp    801d78 <dev_lookup+0x48>

00801d86 <fd_close>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	57                   	push   %edi
  801d8a:	56                   	push   %esi
  801d8b:	53                   	push   %ebx
  801d8c:	83 ec 1c             	sub    $0x1c,%esp
  801d8f:	8b 75 08             	mov    0x8(%ebp),%esi
  801d92:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d95:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d98:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d99:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801d9f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801da2:	50                   	push   %eax
  801da3:	e8 32 ff ff ff       	call   801cda <fd_lookup>
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	83 c4 08             	add    $0x8,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	78 05                	js     801db6 <fd_close+0x30>
	    || fd != fd2)
  801db1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801db4:	74 16                	je     801dcc <fd_close+0x46>
		return (must_exist ? r : 0);
  801db6:	89 f8                	mov    %edi,%eax
  801db8:	84 c0                	test   %al,%al
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	0f 44 d8             	cmove  %eax,%ebx
}
  801dc2:	89 d8                	mov    %ebx,%eax
  801dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801dd2:	50                   	push   %eax
  801dd3:	ff 36                	pushl  (%esi)
  801dd5:	e8 56 ff ff ff       	call   801d30 <dev_lookup>
  801dda:	89 c3                	mov    %eax,%ebx
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	78 15                	js     801df8 <fd_close+0x72>
		if (dev->dev_close)
  801de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de6:	8b 40 10             	mov    0x10(%eax),%eax
  801de9:	85 c0                	test   %eax,%eax
  801deb:	74 1b                	je     801e08 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801ded:	83 ec 0c             	sub    $0xc,%esp
  801df0:	56                   	push   %esi
  801df1:	ff d0                	call   *%eax
  801df3:	89 c3                	mov    %eax,%ebx
  801df5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801df8:	83 ec 08             	sub    $0x8,%esp
  801dfb:	56                   	push   %esi
  801dfc:	6a 00                	push   $0x0
  801dfe:	e8 e4 f8 ff ff       	call   8016e7 <sys_page_unmap>
	return r;
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	eb ba                	jmp    801dc2 <fd_close+0x3c>
			r = 0;
  801e08:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e0d:	eb e9                	jmp    801df8 <fd_close+0x72>

00801e0f <close>:

int
close(int fdnum)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e18:	50                   	push   %eax
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	e8 b9 fe ff ff       	call   801cda <fd_lookup>
  801e21:	83 c4 08             	add    $0x8,%esp
  801e24:	85 c0                	test   %eax,%eax
  801e26:	78 10                	js     801e38 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801e28:	83 ec 08             	sub    $0x8,%esp
  801e2b:	6a 01                	push   $0x1
  801e2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e30:	e8 51 ff ff ff       	call   801d86 <fd_close>
  801e35:	83 c4 10             	add    $0x10,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <close_all>:

void
close_all(void)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	53                   	push   %ebx
  801e3e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e41:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	53                   	push   %ebx
  801e4a:	e8 c0 ff ff ff       	call   801e0f <close>
	for (i = 0; i < MAXFD; i++)
  801e4f:	83 c3 01             	add    $0x1,%ebx
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	83 fb 20             	cmp    $0x20,%ebx
  801e58:	75 ec                	jne    801e46 <close_all+0xc>
}
  801e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	57                   	push   %edi
  801e63:	56                   	push   %esi
  801e64:	53                   	push   %ebx
  801e65:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e68:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e6b:	50                   	push   %eax
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	e8 66 fe ff ff       	call   801cda <fd_lookup>
  801e74:	89 c3                	mov    %eax,%ebx
  801e76:	83 c4 08             	add    $0x8,%esp
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	0f 88 81 00 00 00    	js     801f02 <dup+0xa3>
		return r;
	close(newfdnum);
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	e8 83 ff ff ff       	call   801e0f <close>

	newfd = INDEX2FD(newfdnum);
  801e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e8f:	c1 e6 0c             	shl    $0xc,%esi
  801e92:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801e98:	83 c4 04             	add    $0x4,%esp
  801e9b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e9e:	e8 d1 fd ff ff       	call   801c74 <fd2data>
  801ea3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801ea5:	89 34 24             	mov    %esi,(%esp)
  801ea8:	e8 c7 fd ff ff       	call   801c74 <fd2data>
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801eb2:	89 d8                	mov    %ebx,%eax
  801eb4:	c1 e8 16             	shr    $0x16,%eax
  801eb7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ebe:	a8 01                	test   $0x1,%al
  801ec0:	74 11                	je     801ed3 <dup+0x74>
  801ec2:	89 d8                	mov    %ebx,%eax
  801ec4:	c1 e8 0c             	shr    $0xc,%eax
  801ec7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ece:	f6 c2 01             	test   $0x1,%dl
  801ed1:	75 39                	jne    801f0c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ed3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ed6:	89 d0                	mov    %edx,%eax
  801ed8:	c1 e8 0c             	shr    $0xc,%eax
  801edb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	25 07 0e 00 00       	and    $0xe07,%eax
  801eea:	50                   	push   %eax
  801eeb:	56                   	push   %esi
  801eec:	6a 00                	push   $0x0
  801eee:	52                   	push   %edx
  801eef:	6a 00                	push   $0x0
  801ef1:	e8 af f7 ff ff       	call   8016a5 <sys_page_map>
  801ef6:	89 c3                	mov    %eax,%ebx
  801ef8:	83 c4 20             	add    $0x20,%esp
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 31                	js     801f30 <dup+0xd1>
		goto err;

	return newfdnum;
  801eff:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801f02:	89 d8                	mov    %ebx,%eax
  801f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5f                   	pop    %edi
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f0c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	25 07 0e 00 00       	and    $0xe07,%eax
  801f1b:	50                   	push   %eax
  801f1c:	57                   	push   %edi
  801f1d:	6a 00                	push   $0x0
  801f1f:	53                   	push   %ebx
  801f20:	6a 00                	push   $0x0
  801f22:	e8 7e f7 ff ff       	call   8016a5 <sys_page_map>
  801f27:	89 c3                	mov    %eax,%ebx
  801f29:	83 c4 20             	add    $0x20,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	79 a3                	jns    801ed3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801f30:	83 ec 08             	sub    $0x8,%esp
  801f33:	56                   	push   %esi
  801f34:	6a 00                	push   $0x0
  801f36:	e8 ac f7 ff ff       	call   8016e7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801f3b:	83 c4 08             	add    $0x8,%esp
  801f3e:	57                   	push   %edi
  801f3f:	6a 00                	push   $0x0
  801f41:	e8 a1 f7 ff ff       	call   8016e7 <sys_page_unmap>
	return r;
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	eb b7                	jmp    801f02 <dup+0xa3>

00801f4b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	53                   	push   %ebx
  801f4f:	83 ec 14             	sub    $0x14,%esp
  801f52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f55:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f58:	50                   	push   %eax
  801f59:	53                   	push   %ebx
  801f5a:	e8 7b fd ff ff       	call   801cda <fd_lookup>
  801f5f:	83 c4 08             	add    $0x8,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	78 3f                	js     801fa5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f66:	83 ec 08             	sub    $0x8,%esp
  801f69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6c:	50                   	push   %eax
  801f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f70:	ff 30                	pushl  (%eax)
  801f72:	e8 b9 fd ff ff       	call   801d30 <dev_lookup>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 27                	js     801fa5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f81:	8b 42 08             	mov    0x8(%edx),%eax
  801f84:	83 e0 03             	and    $0x3,%eax
  801f87:	83 f8 01             	cmp    $0x1,%eax
  801f8a:	74 1e                	je     801faa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	8b 40 08             	mov    0x8(%eax),%eax
  801f92:	85 c0                	test   %eax,%eax
  801f94:	74 35                	je     801fcb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	ff 75 10             	pushl  0x10(%ebp)
  801f9c:	ff 75 0c             	pushl  0xc(%ebp)
  801f9f:	52                   	push   %edx
  801fa0:	ff d0                	call   *%eax
  801fa2:	83 c4 10             	add    $0x10,%esp
}
  801fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801faa:	a1 28 54 80 00       	mov    0x805428,%eax
  801faf:	8b 40 48             	mov    0x48(%eax),%eax
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	53                   	push   %ebx
  801fb6:	50                   	push   %eax
  801fb7:	68 09 3e 80 00       	push   $0x803e09
  801fbc:	e8 99 eb ff ff       	call   800b5a <cprintf>
		return -E_INVAL;
  801fc1:	83 c4 10             	add    $0x10,%esp
  801fc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fc9:	eb da                	jmp    801fa5 <read+0x5a>
		return -E_NOT_SUPP;
  801fcb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fd0:	eb d3                	jmp    801fa5 <read+0x5a>

00801fd2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	57                   	push   %edi
  801fd6:	56                   	push   %esi
  801fd7:	53                   	push   %ebx
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fde:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe6:	39 f3                	cmp    %esi,%ebx
  801fe8:	73 25                	jae    80200f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	89 f0                	mov    %esi,%eax
  801fef:	29 d8                	sub    %ebx,%eax
  801ff1:	50                   	push   %eax
  801ff2:	89 d8                	mov    %ebx,%eax
  801ff4:	03 45 0c             	add    0xc(%ebp),%eax
  801ff7:	50                   	push   %eax
  801ff8:	57                   	push   %edi
  801ff9:	e8 4d ff ff ff       	call   801f4b <read>
		if (m < 0)
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	85 c0                	test   %eax,%eax
  802003:	78 08                	js     80200d <readn+0x3b>
			return m;
		if (m == 0)
  802005:	85 c0                	test   %eax,%eax
  802007:	74 06                	je     80200f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  802009:	01 c3                	add    %eax,%ebx
  80200b:	eb d9                	jmp    801fe6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80200d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80200f:	89 d8                	mov    %ebx,%eax
  802011:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802014:	5b                   	pop    %ebx
  802015:	5e                   	pop    %esi
  802016:	5f                   	pop    %edi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	53                   	push   %ebx
  80201d:	83 ec 14             	sub    $0x14,%esp
  802020:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802023:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802026:	50                   	push   %eax
  802027:	53                   	push   %ebx
  802028:	e8 ad fc ff ff       	call   801cda <fd_lookup>
  80202d:	83 c4 08             	add    $0x8,%esp
  802030:	85 c0                	test   %eax,%eax
  802032:	78 3a                	js     80206e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802034:	83 ec 08             	sub    $0x8,%esp
  802037:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203a:	50                   	push   %eax
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	ff 30                	pushl  (%eax)
  802040:	e8 eb fc ff ff       	call   801d30 <dev_lookup>
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 22                	js     80206e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802053:	74 1e                	je     802073 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802055:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802058:	8b 52 0c             	mov    0xc(%edx),%edx
  80205b:	85 d2                	test   %edx,%edx
  80205d:	74 35                	je     802094 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	ff 75 10             	pushl  0x10(%ebp)
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	50                   	push   %eax
  802069:	ff d2                	call   *%edx
  80206b:	83 c4 10             	add    $0x10,%esp
}
  80206e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802071:	c9                   	leave  
  802072:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802073:	a1 28 54 80 00       	mov    0x805428,%eax
  802078:	8b 40 48             	mov    0x48(%eax),%eax
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	53                   	push   %ebx
  80207f:	50                   	push   %eax
  802080:	68 25 3e 80 00       	push   $0x803e25
  802085:	e8 d0 ea ff ff       	call   800b5a <cprintf>
		return -E_INVAL;
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802092:	eb da                	jmp    80206e <write+0x55>
		return -E_NOT_SUPP;
  802094:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802099:	eb d3                	jmp    80206e <write+0x55>

0080209b <seek>:

int
seek(int fdnum, off_t offset)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020a1:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8020a4:	50                   	push   %eax
  8020a5:	ff 75 08             	pushl  0x8(%ebp)
  8020a8:	e8 2d fc ff ff       	call   801cda <fd_lookup>
  8020ad:	83 c4 08             	add    $0x8,%esp
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	78 0e                	js     8020c2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ba:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	53                   	push   %ebx
  8020c8:	83 ec 14             	sub    $0x14,%esp
  8020cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020d1:	50                   	push   %eax
  8020d2:	53                   	push   %ebx
  8020d3:	e8 02 fc ff ff       	call   801cda <fd_lookup>
  8020d8:	83 c4 08             	add    $0x8,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 37                	js     802116 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020df:	83 ec 08             	sub    $0x8,%esp
  8020e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e5:	50                   	push   %eax
  8020e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e9:	ff 30                	pushl  (%eax)
  8020eb:	e8 40 fc ff ff       	call   801d30 <dev_lookup>
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 1f                	js     802116 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8020fe:	74 1b                	je     80211b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802103:	8b 52 18             	mov    0x18(%edx),%edx
  802106:	85 d2                	test   %edx,%edx
  802108:	74 32                	je     80213c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80210a:	83 ec 08             	sub    $0x8,%esp
  80210d:	ff 75 0c             	pushl  0xc(%ebp)
  802110:	50                   	push   %eax
  802111:	ff d2                	call   *%edx
  802113:	83 c4 10             	add    $0x10,%esp
}
  802116:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802119:	c9                   	leave  
  80211a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80211b:	a1 28 54 80 00       	mov    0x805428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802120:	8b 40 48             	mov    0x48(%eax),%eax
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	53                   	push   %ebx
  802127:	50                   	push   %eax
  802128:	68 e8 3d 80 00       	push   $0x803de8
  80212d:	e8 28 ea ff ff       	call   800b5a <cprintf>
		return -E_INVAL;
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80213a:	eb da                	jmp    802116 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80213c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802141:	eb d3                	jmp    802116 <ftruncate+0x52>

00802143 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	53                   	push   %ebx
  802147:	83 ec 14             	sub    $0x14,%esp
  80214a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802150:	50                   	push   %eax
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	e8 81 fb ff ff       	call   801cda <fd_lookup>
  802159:	83 c4 08             	add    $0x8,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 4b                	js     8021ab <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802160:	83 ec 08             	sub    $0x8,%esp
  802163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802166:	50                   	push   %eax
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	ff 30                	pushl  (%eax)
  80216c:	e8 bf fb ff ff       	call   801d30 <dev_lookup>
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	85 c0                	test   %eax,%eax
  802176:	78 33                	js     8021ab <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80217f:	74 2f                	je     8021b0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802181:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802184:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80218b:	00 00 00 
	stat->st_isdir = 0;
  80218e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802195:	00 00 00 
	stat->st_dev = dev;
  802198:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80219e:	83 ec 08             	sub    $0x8,%esp
  8021a1:	53                   	push   %ebx
  8021a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a5:	ff 50 14             	call   *0x14(%eax)
  8021a8:	83 c4 10             	add    $0x10,%esp
}
  8021ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    
		return -E_NOT_SUPP;
  8021b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021b5:	eb f4                	jmp    8021ab <fstat+0x68>

008021b7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8021bc:	83 ec 08             	sub    $0x8,%esp
  8021bf:	6a 00                	push   $0x0
  8021c1:	ff 75 08             	pushl  0x8(%ebp)
  8021c4:	e8 e7 01 00 00       	call   8023b0 <open>
  8021c9:	89 c3                	mov    %eax,%ebx
  8021cb:	83 c4 10             	add    $0x10,%esp
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	78 1b                	js     8021ed <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8021d2:	83 ec 08             	sub    $0x8,%esp
  8021d5:	ff 75 0c             	pushl  0xc(%ebp)
  8021d8:	50                   	push   %eax
  8021d9:	e8 65 ff ff ff       	call   802143 <fstat>
  8021de:	89 c6                	mov    %eax,%esi
	close(fd);
  8021e0:	89 1c 24             	mov    %ebx,(%esp)
  8021e3:	e8 27 fc ff ff       	call   801e0f <close>
	return r;
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	89 f3                	mov    %esi,%ebx
}
  8021ed:	89 d8                	mov    %ebx,%eax
  8021ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    

008021f6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	56                   	push   %esi
  8021fa:	53                   	push   %ebx
  8021fb:	89 c6                	mov    %eax,%esi
  8021fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8021ff:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  802206:	74 27                	je     80222f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802208:	6a 07                	push   $0x7
  80220a:	68 00 60 80 00       	push   $0x806000
  80220f:	56                   	push   %esi
  802210:	ff 35 20 54 80 00    	pushl  0x805420
  802216:	e8 39 12 00 00       	call   803454 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80221b:	83 c4 0c             	add    $0xc,%esp
  80221e:	6a 00                	push   $0x0
  802220:	53                   	push   %ebx
  802221:	6a 00                	push   $0x0
  802223:	e8 c5 11 00 00       	call   8033ed <ipc_recv>
}
  802228:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5d                   	pop    %ebp
  80222e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80222f:	83 ec 0c             	sub    $0xc,%esp
  802232:	6a 01                	push   $0x1
  802234:	e8 6f 12 00 00       	call   8034a8 <ipc_find_env>
  802239:	a3 20 54 80 00       	mov    %eax,0x805420
  80223e:	83 c4 10             	add    $0x10,%esp
  802241:	eb c5                	jmp    802208 <fsipc+0x12>

00802243 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	8b 40 0c             	mov    0xc(%eax),%eax
  80224f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802254:	8b 45 0c             	mov    0xc(%ebp),%eax
  802257:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80225c:	ba 00 00 00 00       	mov    $0x0,%edx
  802261:	b8 02 00 00 00       	mov    $0x2,%eax
  802266:	e8 8b ff ff ff       	call   8021f6 <fsipc>
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <devfile_flush>:
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8b 40 0c             	mov    0xc(%eax),%eax
  802279:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80227e:	ba 00 00 00 00       	mov    $0x0,%edx
  802283:	b8 06 00 00 00       	mov    $0x6,%eax
  802288:	e8 69 ff ff ff       	call   8021f6 <fsipc>
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <devfile_stat>:
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	53                   	push   %ebx
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 40 0c             	mov    0xc(%eax),%eax
  80229f:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8022a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8022ae:	e8 43 ff ff ff       	call   8021f6 <fsipc>
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	78 2c                	js     8022e3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8022b7:	83 ec 08             	sub    $0x8,%esp
  8022ba:	68 00 60 80 00       	push   $0x806000
  8022bf:	53                   	push   %ebx
  8022c0:	e8 a4 ef ff ff       	call   801269 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8022c5:	a1 80 60 80 00       	mov    0x806080,%eax
  8022ca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8022d0:	a1 84 60 80 00       	mov    0x806084,%eax
  8022d5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8022db:	83 c4 10             	add    $0x10,%esp
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <devfile_write>:
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 0c             	sub    $0xc,%esp
  8022ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8022f6:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8022fb:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802301:	8b 52 0c             	mov    0xc(%edx),%edx
  802304:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  80230a:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80230f:	50                   	push   %eax
  802310:	ff 75 0c             	pushl  0xc(%ebp)
  802313:	68 08 60 80 00       	push   $0x806008
  802318:	e8 da f0 ff ff       	call   8013f7 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80231d:	ba 00 00 00 00       	mov    $0x0,%edx
  802322:	b8 04 00 00 00       	mov    $0x4,%eax
  802327:	e8 ca fe ff ff       	call   8021f6 <fsipc>
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <devfile_read>:
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	56                   	push   %esi
  802332:	53                   	push   %ebx
  802333:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	8b 40 0c             	mov    0xc(%eax),%eax
  80233c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802341:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802347:	ba 00 00 00 00       	mov    $0x0,%edx
  80234c:	b8 03 00 00 00       	mov    $0x3,%eax
  802351:	e8 a0 fe ff ff       	call   8021f6 <fsipc>
  802356:	89 c3                	mov    %eax,%ebx
  802358:	85 c0                	test   %eax,%eax
  80235a:	78 1f                	js     80237b <devfile_read+0x4d>
	assert(r <= n);
  80235c:	39 f0                	cmp    %esi,%eax
  80235e:	77 24                	ja     802384 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802360:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802365:	7f 33                	jg     80239a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802367:	83 ec 04             	sub    $0x4,%esp
  80236a:	50                   	push   %eax
  80236b:	68 00 60 80 00       	push   $0x806000
  802370:	ff 75 0c             	pushl  0xc(%ebp)
  802373:	e8 7f f0 ff ff       	call   8013f7 <memmove>
	return r;
  802378:	83 c4 10             	add    $0x10,%esp
}
  80237b:	89 d8                	mov    %ebx,%eax
  80237d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    
	assert(r <= n);
  802384:	68 58 3e 80 00       	push   $0x803e58
  802389:	68 af 38 80 00       	push   $0x8038af
  80238e:	6a 7b                	push   $0x7b
  802390:	68 5f 3e 80 00       	push   $0x803e5f
  802395:	e8 e5 e6 ff ff       	call   800a7f <_panic>
	assert(r <= PGSIZE);
  80239a:	68 6a 3e 80 00       	push   $0x803e6a
  80239f:	68 af 38 80 00       	push   $0x8038af
  8023a4:	6a 7c                	push   $0x7c
  8023a6:	68 5f 3e 80 00       	push   $0x803e5f
  8023ab:	e8 cf e6 ff ff       	call   800a7f <_panic>

008023b0 <open>:
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
  8023b5:	83 ec 1c             	sub    $0x1c,%esp
  8023b8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8023bb:	56                   	push   %esi
  8023bc:	e8 71 ee ff ff       	call   801232 <strlen>
  8023c1:	83 c4 10             	add    $0x10,%esp
  8023c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023c9:	7f 6c                	jg     802437 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8023cb:	83 ec 0c             	sub    $0xc,%esp
  8023ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d1:	50                   	push   %eax
  8023d2:	e8 b4 f8 ff ff       	call   801c8b <fd_alloc>
  8023d7:	89 c3                	mov    %eax,%ebx
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	78 3c                	js     80241c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8023e0:	83 ec 08             	sub    $0x8,%esp
  8023e3:	56                   	push   %esi
  8023e4:	68 00 60 80 00       	push   $0x806000
  8023e9:	e8 7b ee ff ff       	call   801269 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8023ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8023f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fe:	e8 f3 fd ff ff       	call   8021f6 <fsipc>
  802403:	89 c3                	mov    %eax,%ebx
  802405:	83 c4 10             	add    $0x10,%esp
  802408:	85 c0                	test   %eax,%eax
  80240a:	78 19                	js     802425 <open+0x75>
	return fd2num(fd);
  80240c:	83 ec 0c             	sub    $0xc,%esp
  80240f:	ff 75 f4             	pushl  -0xc(%ebp)
  802412:	e8 4d f8 ff ff       	call   801c64 <fd2num>
  802417:	89 c3                	mov    %eax,%ebx
  802419:	83 c4 10             	add    $0x10,%esp
}
  80241c:	89 d8                	mov    %ebx,%eax
  80241e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5d                   	pop    %ebp
  802424:	c3                   	ret    
		fd_close(fd, 0);
  802425:	83 ec 08             	sub    $0x8,%esp
  802428:	6a 00                	push   $0x0
  80242a:	ff 75 f4             	pushl  -0xc(%ebp)
  80242d:	e8 54 f9 ff ff       	call   801d86 <fd_close>
		return r;
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	eb e5                	jmp    80241c <open+0x6c>
		return -E_BAD_PATH;
  802437:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80243c:	eb de                	jmp    80241c <open+0x6c>

0080243e <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802444:	ba 00 00 00 00       	mov    $0x0,%edx
  802449:	b8 08 00 00 00       	mov    $0x8,%eax
  80244e:	e8 a3 fd ff ff       	call   8021f6 <fsipc>
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  802455:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802459:	7e 38                	jle    802493 <writebuf+0x3e>
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	53                   	push   %ebx
  80245f:	83 ec 08             	sub    $0x8,%esp
  802462:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  802464:	ff 70 04             	pushl  0x4(%eax)
  802467:	8d 40 10             	lea    0x10(%eax),%eax
  80246a:	50                   	push   %eax
  80246b:	ff 33                	pushl  (%ebx)
  80246d:	e8 a7 fb ff ff       	call   802019 <write>
		if (result > 0)
  802472:	83 c4 10             	add    $0x10,%esp
  802475:	85 c0                	test   %eax,%eax
  802477:	7e 03                	jle    80247c <writebuf+0x27>
			b->result += result;
  802479:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80247c:	39 43 04             	cmp    %eax,0x4(%ebx)
  80247f:	74 0d                	je     80248e <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  802481:	85 c0                	test   %eax,%eax
  802483:	ba 00 00 00 00       	mov    $0x0,%edx
  802488:	0f 4f c2             	cmovg  %edx,%eax
  80248b:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80248e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802491:	c9                   	leave  
  802492:	c3                   	ret    
  802493:	f3 c3                	repz ret 

00802495 <putch>:

static void
putch(int ch, void *thunk)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	53                   	push   %ebx
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80249f:	8b 53 04             	mov    0x4(%ebx),%edx
  8024a2:	8d 42 01             	lea    0x1(%edx),%eax
  8024a5:	89 43 04             	mov    %eax,0x4(%ebx)
  8024a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ab:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8024af:	3d 00 01 00 00       	cmp    $0x100,%eax
  8024b4:	74 06                	je     8024bc <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8024b6:	83 c4 04             	add    $0x4,%esp
  8024b9:	5b                   	pop    %ebx
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    
		writebuf(b);
  8024bc:	89 d8                	mov    %ebx,%eax
  8024be:	e8 92 ff ff ff       	call   802455 <writebuf>
		b->idx = 0;
  8024c3:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8024ca:	eb ea                	jmp    8024b6 <putch+0x21>

008024cc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8024de:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8024e5:	00 00 00 
	b.result = 0;
  8024e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8024ef:	00 00 00 
	b.error = 1;
  8024f2:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8024f9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8024fc:	ff 75 10             	pushl  0x10(%ebp)
  8024ff:	ff 75 0c             	pushl  0xc(%ebp)
  802502:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802508:	50                   	push   %eax
  802509:	68 95 24 80 00       	push   $0x802495
  80250e:	e8 44 e7 ff ff       	call   800c57 <vprintfmt>
	if (b.idx > 0)
  802513:	83 c4 10             	add    $0x10,%esp
  802516:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80251d:	7f 11                	jg     802530 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80251f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    
		writebuf(&b);
  802530:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802536:	e8 1a ff ff ff       	call   802455 <writebuf>
  80253b:	eb e2                	jmp    80251f <vfprintf+0x53>

0080253d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802543:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802546:	50                   	push   %eax
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	e8 7a ff ff ff       	call   8024cc <vfprintf>
	va_end(ap);

	return cnt;
}
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <printf>:

int
printf(const char *fmt, ...)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80255a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80255d:	50                   	push   %eax
  80255e:	ff 75 08             	pushl  0x8(%ebp)
  802561:	6a 01                	push   $0x1
  802563:	e8 64 ff ff ff       	call   8024cc <vfprintf>
	va_end(ap);

	return cnt;
}
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <spawn>:
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int spawn(const char *prog, const char **argv)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	57                   	push   %edi
  80256e:	56                   	push   %esi
  80256f:	53                   	push   %ebx
  802570:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802576:	6a 00                	push   $0x0
  802578:	ff 75 08             	pushl  0x8(%ebp)
  80257b:	e8 30 fe ff ff       	call   8023b0 <open>
  802580:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802586:	83 c4 10             	add    $0x10,%esp
  802589:	85 c0                	test   %eax,%eax
  80258b:	0f 88 40 03 00 00    	js     8028d1 <spawn+0x367>
  802591:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *)elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) || elf->e_magic != ELF_MAGIC)
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 00 02 00 00       	push   $0x200
  80259b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8025a1:	50                   	push   %eax
  8025a2:	51                   	push   %ecx
  8025a3:	e8 2a fa ff ff       	call   801fd2 <readn>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	3d 00 02 00 00       	cmp    $0x200,%eax
  8025b0:	75 5d                	jne    80260f <spawn+0xa5>
  8025b2:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8025b9:	45 4c 46 
  8025bc:	75 51                	jne    80260f <spawn+0xa5>
  8025be:	b8 07 00 00 00       	mov    $0x7,%eax
  8025c3:	cd 30                	int    $0x30
  8025c5:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8025cb:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	0f 88 62 04 00 00    	js     802a3b <spawn+0x4d1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8025d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8025de:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8025e1:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8025e7:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8025ed:	b9 11 00 00 00       	mov    $0x11,%ecx
  8025f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8025f4:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8025fa:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802600:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802605:	be 00 00 00 00       	mov    $0x0,%esi
  80260a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80260d:	eb 4b                	jmp    80265a <spawn+0xf0>
		close(fd);
  80260f:	83 ec 0c             	sub    $0xc,%esp
  802612:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802618:	e8 f2 f7 ff ff       	call   801e0f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80261d:	83 c4 0c             	add    $0xc,%esp
  802620:	68 7f 45 4c 46       	push   $0x464c457f
  802625:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80262b:	68 76 3e 80 00       	push   $0x803e76
  802630:	e8 25 e5 ff ff       	call   800b5a <cprintf>
		return -E_NOT_EXEC;
  802635:	83 c4 10             	add    $0x10,%esp
  802638:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  80263f:	ff ff ff 
  802642:	e9 8a 02 00 00       	jmp    8028d1 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  802647:	83 ec 0c             	sub    $0xc,%esp
  80264a:	50                   	push   %eax
  80264b:	e8 e2 eb ff ff       	call   801232 <strlen>
  802650:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802654:	83 c3 01             	add    $0x1,%ebx
  802657:	83 c4 10             	add    $0x10,%esp
  80265a:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802661:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	75 df                	jne    802647 <spawn+0xdd>
  802668:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  80266e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *)UTEMP + PGSIZE - string_size;
  802674:	bf 00 10 40 00       	mov    $0x401000,%edi
  802679:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *)(ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	83 e2 fc             	and    $0xfffffffc,%edx
  802680:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802687:	29 c2                	sub    %eax,%edx
  802689:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *)(argv_store - 2) < (void *)UTEMP)
  80268f:	8d 42 f8             	lea    -0x8(%edx),%eax
  802692:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802697:	0f 86 af 03 00 00    	jbe    802a4c <spawn+0x4e2>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80269d:	83 ec 04             	sub    $0x4,%esp
  8026a0:	6a 07                	push   $0x7
  8026a2:	68 00 00 40 00       	push   $0x400000
  8026a7:	6a 00                	push   $0x0
  8026a9:	e8 b4 ef ff ff       	call   801662 <sys_page_alloc>
  8026ae:	83 c4 10             	add    $0x10,%esp
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	0f 88 98 03 00 00    	js     802a51 <spawn+0x4e7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++)
  8026b9:	be 00 00 00 00       	mov    $0x0,%esi
  8026be:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8026c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8026c7:	eb 30                	jmp    8026f9 <spawn+0x18f>
	{
		argv_store[i] = UTEMP2USTACK(string_store);
  8026c9:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8026cf:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8026d5:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8026d8:	83 ec 08             	sub    $0x8,%esp
  8026db:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8026de:	57                   	push   %edi
  8026df:	e8 85 eb ff ff       	call   801269 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8026e4:	83 c4 04             	add    $0x4,%esp
  8026e7:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8026ea:	e8 43 eb ff ff       	call   801232 <strlen>
  8026ef:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++)
  8026f3:	83 c6 01             	add    $0x1,%esi
  8026f6:	83 c4 10             	add    $0x10,%esp
  8026f9:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8026ff:	7f c8                	jg     8026c9 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  802701:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802707:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80270d:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *)UTEMP + PGSIZE);
  802714:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80271a:	0f 85 8c 00 00 00    	jne    8027ac <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802720:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  802726:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80272c:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  80272f:	89 f8                	mov    %edi,%eax
  802731:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  802737:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80273a:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80273f:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void *)(USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802745:	83 ec 0c             	sub    $0xc,%esp
  802748:	6a 07                	push   $0x7
  80274a:	68 00 d0 bf ee       	push   $0xeebfd000
  80274f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802755:	68 00 00 40 00       	push   $0x400000
  80275a:	6a 00                	push   $0x0
  80275c:	e8 44 ef ff ff       	call   8016a5 <sys_page_map>
  802761:	89 c3                	mov    %eax,%ebx
  802763:	83 c4 20             	add    $0x20,%esp
  802766:	85 c0                	test   %eax,%eax
  802768:	0f 88 59 03 00 00    	js     802ac7 <spawn+0x55d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80276e:	83 ec 08             	sub    $0x8,%esp
  802771:	68 00 00 40 00       	push   $0x400000
  802776:	6a 00                	push   $0x0
  802778:	e8 6a ef ff ff       	call   8016e7 <sys_page_unmap>
  80277d:	89 c3                	mov    %eax,%ebx
  80277f:	83 c4 10             	add    $0x10,%esp
  802782:	85 c0                	test   %eax,%eax
  802784:	0f 88 3d 03 00 00    	js     802ac7 <spawn+0x55d>
	ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  80278a:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802790:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802797:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++)
  80279d:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8027a4:	00 00 00 
  8027a7:	e9 56 01 00 00       	jmp    802902 <spawn+0x398>
	assert(string_store == (char *)UTEMP + PGSIZE);
  8027ac:	68 00 3f 80 00       	push   $0x803f00
  8027b1:	68 af 38 80 00       	push   $0x8038af
  8027b6:	68 f0 00 00 00       	push   $0xf0
  8027bb:	68 90 3e 80 00       	push   $0x803e90
  8027c0:	e8 ba e2 ff ff       	call   800a7f <_panic>
				return r;
		}
		else
		{
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	6a 07                	push   $0x7
  8027ca:	68 00 00 40 00       	push   $0x400000
  8027cf:	6a 00                	push   $0x0
  8027d1:	e8 8c ee ff ff       	call   801662 <sys_page_alloc>
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	0f 88 7b 02 00 00    	js     802a5c <spawn+0x4f2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8027e1:	83 ec 08             	sub    $0x8,%esp
  8027e4:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8027ea:	01 f0                	add    %esi,%eax
  8027ec:	50                   	push   %eax
  8027ed:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8027f3:	e8 a3 f8 ff ff       	call   80209b <seek>
  8027f8:	83 c4 10             	add    $0x10,%esp
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	0f 88 60 02 00 00    	js     802a63 <spawn+0x4f9>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80280c:	29 f0                	sub    %esi,%eax
  80280e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802813:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802818:	0f 47 c1             	cmova  %ecx,%eax
  80281b:	50                   	push   %eax
  80281c:	68 00 00 40 00       	push   $0x400000
  802821:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802827:	e8 a6 f7 ff ff       	call   801fd2 <readn>
  80282c:	83 c4 10             	add    $0x10,%esp
  80282f:	85 c0                	test   %eax,%eax
  802831:	0f 88 33 02 00 00    	js     802a6a <spawn+0x500>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void *)(va + i), perm)) < 0)
  802837:	83 ec 0c             	sub    $0xc,%esp
  80283a:	57                   	push   %edi
  80283b:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802841:	56                   	push   %esi
  802842:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  802848:	68 00 00 40 00       	push   $0x400000
  80284d:	6a 00                	push   $0x0
  80284f:	e8 51 ee ff ff       	call   8016a5 <sys_page_map>
  802854:	83 c4 20             	add    $0x20,%esp
  802857:	85 c0                	test   %eax,%eax
  802859:	0f 88 80 00 00 00    	js     8028df <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80285f:	83 ec 08             	sub    $0x8,%esp
  802862:	68 00 00 40 00       	push   $0x400000
  802867:	6a 00                	push   $0x0
  802869:	e8 79 ee ff ff       	call   8016e7 <sys_page_unmap>
  80286e:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE)
  802871:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802877:	89 de                	mov    %ebx,%esi
  802879:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  80287f:	76 73                	jbe    8028f4 <spawn+0x38a>
		if (i >= filesz)
  802881:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  802887:	0f 87 38 ff ff ff    	ja     8027c5 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void *)(va + i), perm)) < 0)
  80288d:	83 ec 04             	sub    $0x4,%esp
  802890:	57                   	push   %edi
  802891:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802897:	56                   	push   %esi
  802898:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  80289e:	e8 bf ed ff ff       	call   801662 <sys_page_alloc>
  8028a3:	83 c4 10             	add    $0x10,%esp
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	79 c7                	jns    802871 <spawn+0x307>
  8028aa:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8028ac:	83 ec 0c             	sub    $0xc,%esp
  8028af:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8028b5:	e8 29 ed ff ff       	call   8015e3 <sys_env_destroy>
	close(fd);
  8028ba:	83 c4 04             	add    $0x4,%esp
  8028bd:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8028c3:	e8 47 f5 ff ff       	call   801e0f <close>
	return r;
  8028c8:	83 c4 10             	add    $0x10,%esp
  8028cb:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  8028d1:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028da:	5b                   	pop    %ebx
  8028db:	5e                   	pop    %esi
  8028dc:	5f                   	pop    %edi
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  8028df:	50                   	push   %eax
  8028e0:	68 9c 3e 80 00       	push   $0x803e9c
  8028e5:	68 28 01 00 00       	push   $0x128
  8028ea:	68 90 3e 80 00       	push   $0x803e90
  8028ef:	e8 8b e1 ff ff       	call   800a7f <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++)
  8028f4:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8028fb:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  802902:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802909:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  80290f:	7e 71                	jle    802982 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  802911:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802917:	83 3a 01             	cmpl   $0x1,(%edx)
  80291a:	75 d8                	jne    8028f4 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80291c:	8b 42 18             	mov    0x18(%edx),%eax
  80291f:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802922:	83 f8 01             	cmp    $0x1,%eax
  802925:	19 ff                	sbb    %edi,%edi
  802927:	83 e7 fe             	and    $0xfffffffe,%edi
  80292a:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80292d:	8b 72 04             	mov    0x4(%edx),%esi
  802930:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  802936:	8b 5a 10             	mov    0x10(%edx),%ebx
  802939:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80293f:	8b 42 14             	mov    0x14(%edx),%eax
  802942:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802948:	8b 4a 08             	mov    0x8(%edx),%ecx
  80294b:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
	if ((i = PGOFF(va)))
  802951:	89 c8                	mov    %ecx,%eax
  802953:	25 ff 0f 00 00       	and    $0xfff,%eax
  802958:	74 1e                	je     802978 <spawn+0x40e>
		va -= i;
  80295a:	29 c1                	sub    %eax,%ecx
  80295c:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
		memsz += i;
  802962:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802968:	01 c3                	add    %eax,%ebx
  80296a:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  802970:	29 c6                	sub    %eax,%esi
  802972:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE)
  802978:	bb 00 00 00 00       	mov    $0x0,%ebx
  80297d:	e9 f5 fe ff ff       	jmp    802877 <spawn+0x30d>
	close(fd);
  802982:	83 ec 0c             	sub    $0xc,%esp
  802985:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80298b:	e8 7f f4 ff ff       	call   801e0f <close>
  802990:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int r, pn;
	struct Env *e;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  802993:	bb 00 08 00 00       	mov    $0x800,%ebx
  802998:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  80299e:	eb 0f                	jmp    8029af <spawn+0x445>
  8029a0:	83 c3 01             	add    $0x1,%ebx
  8029a3:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8029a9:	0f 84 c2 00 00 00    	je     802a71 <spawn+0x507>
	{
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8029af:	89 d8                	mov    %ebx,%eax
  8029b1:	c1 f8 0a             	sar    $0xa,%eax
  8029b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8029bb:	a8 01                	test   $0x1,%al
  8029bd:	74 e1                	je     8029a0 <spawn+0x436>
  8029bf:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8029c6:	a8 01                	test   $0x1,%al
  8029c8:	74 d6                	je     8029a0 <spawn+0x436>
		{
			if (uvpt[pn] & PTE_SHARE)
  8029ca:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8029d1:	f6 c4 04             	test   $0x4,%ah
  8029d4:	74 ca                	je     8029a0 <spawn+0x436>
			{
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
									  child, (void *)(pn * PGSIZE),
									  uvpt[pn] & PTE_SYSCALL)) < 0)
  8029d6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8029dd:	89 da                	mov    %ebx,%edx
  8029df:	c1 e2 0c             	shl    $0xc,%edx
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
  8029e2:	83 ec 0c             	sub    $0xc,%esp
  8029e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8029ea:	50                   	push   %eax
  8029eb:	52                   	push   %edx
  8029ec:	56                   	push   %esi
  8029ed:	52                   	push   %edx
  8029ee:	6a 00                	push   $0x0
  8029f0:	e8 b0 ec ff ff       	call   8016a5 <sys_page_map>
  8029f5:	83 c4 20             	add    $0x20,%esp
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	79 a4                	jns    8029a0 <spawn+0x436>
		panic("copy_shared_pages: %e", r);
  8029fc:	50                   	push   %eax
  8029fd:	68 ea 3e 80 00       	push   $0x803eea
  802a02:	68 82 00 00 00       	push   $0x82
  802a07:	68 90 3e 80 00       	push   $0x803e90
  802a0c:	e8 6e e0 ff ff       	call   800a7f <_panic>
		panic("sys_env_set_trapframe: %e", r);
  802a11:	50                   	push   %eax
  802a12:	68 b9 3e 80 00       	push   $0x803eb9
  802a17:	68 86 00 00 00       	push   $0x86
  802a1c:	68 90 3e 80 00       	push   $0x803e90
  802a21:	e8 59 e0 ff ff       	call   800a7f <_panic>
		panic("sys_env_set_status: %e", r);
  802a26:	50                   	push   %eax
  802a27:	68 d3 3e 80 00       	push   $0x803ed3
  802a2c:	68 89 00 00 00       	push   $0x89
  802a31:	68 90 3e 80 00       	push   $0x803e90
  802a36:	e8 44 e0 ff ff       	call   800a7f <_panic>
		return r;
  802a3b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802a41:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802a47:	e9 85 fe ff ff       	jmp    8028d1 <spawn+0x367>
		return -E_NO_MEM;
  802a4c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  802a51:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802a57:	e9 75 fe ff ff       	jmp    8028d1 <spawn+0x367>
  802a5c:	89 c7                	mov    %eax,%edi
  802a5e:	e9 49 fe ff ff       	jmp    8028ac <spawn+0x342>
  802a63:	89 c7                	mov    %eax,%edi
  802a65:	e9 42 fe ff ff       	jmp    8028ac <spawn+0x342>
  802a6a:	89 c7                	mov    %eax,%edi
  802a6c:	e9 3b fe ff ff       	jmp    8028ac <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3; // devious: see user/faultio.c
  802a71:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802a78:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802a7b:	83 ec 08             	sub    $0x8,%esp
  802a7e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802a84:	50                   	push   %eax
  802a85:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802a8b:	e8 db ec ff ff       	call   80176b <sys_env_set_trapframe>
  802a90:	83 c4 10             	add    $0x10,%esp
  802a93:	85 c0                	test   %eax,%eax
  802a95:	0f 88 76 ff ff ff    	js     802a11 <spawn+0x4a7>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802a9b:	83 ec 08             	sub    $0x8,%esp
  802a9e:	6a 02                	push   $0x2
  802aa0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802aa6:	e8 7e ec ff ff       	call   801729 <sys_env_set_status>
  802aab:	83 c4 10             	add    $0x10,%esp
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	0f 88 70 ff ff ff    	js     802a26 <spawn+0x4bc>
	return child;
  802ab6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802abc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802ac2:	e9 0a fe ff ff       	jmp    8028d1 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  802ac7:	83 ec 08             	sub    $0x8,%esp
  802aca:	68 00 00 40 00       	push   $0x400000
  802acf:	6a 00                	push   $0x0
  802ad1:	e8 11 ec ff ff       	call   8016e7 <sys_page_unmap>
  802ad6:	83 c4 10             	add    $0x10,%esp
  802ad9:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802adf:	e9 ed fd ff ff       	jmp    8028d1 <spawn+0x367>

00802ae4 <spawnl>:
{
  802ae4:	55                   	push   %ebp
  802ae5:	89 e5                	mov    %esp,%ebp
  802ae7:	57                   	push   %edi
  802ae8:	56                   	push   %esi
  802ae9:	53                   	push   %ebx
  802aea:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802aed:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  802af0:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  802af5:	eb 05                	jmp    802afc <spawnl+0x18>
		argc++;
  802af7:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  802afa:	89 ca                	mov    %ecx,%edx
  802afc:	8d 4a 04             	lea    0x4(%edx),%ecx
  802aff:	83 3a 00             	cmpl   $0x0,(%edx)
  802b02:	75 f3                	jne    802af7 <spawnl+0x13>
	const char *argv[argc + 2];
  802b04:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802b0b:	83 e2 f0             	and    $0xfffffff0,%edx
  802b0e:	29 d4                	sub    %edx,%esp
  802b10:	8d 54 24 03          	lea    0x3(%esp),%edx
  802b14:	c1 ea 02             	shr    $0x2,%edx
  802b17:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802b1e:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b23:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  802b2a:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802b31:	00 
	va_start(vl, arg0);
  802b32:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802b35:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  802b37:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3c:	eb 0b                	jmp    802b49 <spawnl+0x65>
		argv[i + 1] = va_arg(vl, const char *);
  802b3e:	83 c0 01             	add    $0x1,%eax
  802b41:	8b 39                	mov    (%ecx),%edi
  802b43:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802b46:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  802b49:	39 d0                	cmp    %edx,%eax
  802b4b:	75 f1                	jne    802b3e <spawnl+0x5a>
	return spawn(prog, argv);
  802b4d:	83 ec 08             	sub    $0x8,%esp
  802b50:	56                   	push   %esi
  802b51:	ff 75 08             	pushl  0x8(%ebp)
  802b54:	e8 11 fa ff ff       	call   80256a <spawn>
}
  802b59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b5c:	5b                   	pop    %ebx
  802b5d:	5e                   	pop    %esi
  802b5e:	5f                   	pop    %edi
  802b5f:	5d                   	pop    %ebp
  802b60:	c3                   	ret    

00802b61 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802b61:	55                   	push   %ebp
  802b62:	89 e5                	mov    %esp,%ebp
  802b64:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802b67:	68 28 3f 80 00       	push   $0x803f28
  802b6c:	ff 75 0c             	pushl  0xc(%ebp)
  802b6f:	e8 f5 e6 ff ff       	call   801269 <strcpy>
	return 0;
}
  802b74:	b8 00 00 00 00       	mov    $0x0,%eax
  802b79:	c9                   	leave  
  802b7a:	c3                   	ret    

00802b7b <devsock_close>:
{
  802b7b:	55                   	push   %ebp
  802b7c:	89 e5                	mov    %esp,%ebp
  802b7e:	53                   	push   %ebx
  802b7f:	83 ec 10             	sub    $0x10,%esp
  802b82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802b85:	53                   	push   %ebx
  802b86:	e8 56 09 00 00       	call   8034e1 <pageref>
  802b8b:	83 c4 10             	add    $0x10,%esp
		return 0;
  802b8e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802b93:	83 f8 01             	cmp    $0x1,%eax
  802b96:	74 07                	je     802b9f <devsock_close+0x24>
}
  802b98:	89 d0                	mov    %edx,%eax
  802b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b9d:	c9                   	leave  
  802b9e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802b9f:	83 ec 0c             	sub    $0xc,%esp
  802ba2:	ff 73 0c             	pushl  0xc(%ebx)
  802ba5:	e8 b7 02 00 00       	call   802e61 <nsipc_close>
  802baa:	89 c2                	mov    %eax,%edx
  802bac:	83 c4 10             	add    $0x10,%esp
  802baf:	eb e7                	jmp    802b98 <devsock_close+0x1d>

00802bb1 <devsock_write>:
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802bb7:	6a 00                	push   $0x0
  802bb9:	ff 75 10             	pushl  0x10(%ebp)
  802bbc:	ff 75 0c             	pushl  0xc(%ebp)
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	ff 70 0c             	pushl  0xc(%eax)
  802bc5:	e8 74 03 00 00       	call   802f3e <nsipc_send>
}
  802bca:	c9                   	leave  
  802bcb:	c3                   	ret    

00802bcc <devsock_read>:
{
  802bcc:	55                   	push   %ebp
  802bcd:	89 e5                	mov    %esp,%ebp
  802bcf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802bd2:	6a 00                	push   $0x0
  802bd4:	ff 75 10             	pushl  0x10(%ebp)
  802bd7:	ff 75 0c             	pushl  0xc(%ebp)
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	ff 70 0c             	pushl  0xc(%eax)
  802be0:	e8 ed 02 00 00       	call   802ed2 <nsipc_recv>
}
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <fd2sockid>:
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
  802bea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802bed:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802bf0:	52                   	push   %edx
  802bf1:	50                   	push   %eax
  802bf2:	e8 e3 f0 ff ff       	call   801cda <fd_lookup>
  802bf7:	83 c4 10             	add    $0x10,%esp
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	78 10                	js     802c0e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  802c07:	39 08                	cmp    %ecx,(%eax)
  802c09:	75 05                	jne    802c10 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802c0b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802c0e:	c9                   	leave  
  802c0f:	c3                   	ret    
		return -E_NOT_SUPP;
  802c10:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802c15:	eb f7                	jmp    802c0e <fd2sockid+0x27>

00802c17 <alloc_sockfd>:
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
  802c1a:	56                   	push   %esi
  802c1b:	53                   	push   %ebx
  802c1c:	83 ec 1c             	sub    $0x1c,%esp
  802c1f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802c21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c24:	50                   	push   %eax
  802c25:	e8 61 f0 ff ff       	call   801c8b <fd_alloc>
  802c2a:	89 c3                	mov    %eax,%ebx
  802c2c:	83 c4 10             	add    $0x10,%esp
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	78 43                	js     802c76 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802c33:	83 ec 04             	sub    $0x4,%esp
  802c36:	68 07 04 00 00       	push   $0x407
  802c3b:	ff 75 f4             	pushl  -0xc(%ebp)
  802c3e:	6a 00                	push   $0x0
  802c40:	e8 1d ea ff ff       	call   801662 <sys_page_alloc>
  802c45:	89 c3                	mov    %eax,%ebx
  802c47:	83 c4 10             	add    $0x10,%esp
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	78 28                	js     802c76 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802c57:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802c63:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802c66:	83 ec 0c             	sub    $0xc,%esp
  802c69:	50                   	push   %eax
  802c6a:	e8 f5 ef ff ff       	call   801c64 <fd2num>
  802c6f:	89 c3                	mov    %eax,%ebx
  802c71:	83 c4 10             	add    $0x10,%esp
  802c74:	eb 0c                	jmp    802c82 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802c76:	83 ec 0c             	sub    $0xc,%esp
  802c79:	56                   	push   %esi
  802c7a:	e8 e2 01 00 00       	call   802e61 <nsipc_close>
		return r;
  802c7f:	83 c4 10             	add    $0x10,%esp
}
  802c82:	89 d8                	mov    %ebx,%eax
  802c84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c87:	5b                   	pop    %ebx
  802c88:	5e                   	pop    %esi
  802c89:	5d                   	pop    %ebp
  802c8a:	c3                   	ret    

00802c8b <accept>:
{
  802c8b:	55                   	push   %ebp
  802c8c:	89 e5                	mov    %esp,%ebp
  802c8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	e8 4e ff ff ff       	call   802be7 <fd2sockid>
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	78 1b                	js     802cb8 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	ff 75 10             	pushl  0x10(%ebp)
  802ca3:	ff 75 0c             	pushl  0xc(%ebp)
  802ca6:	50                   	push   %eax
  802ca7:	e8 0e 01 00 00       	call   802dba <nsipc_accept>
  802cac:	83 c4 10             	add    $0x10,%esp
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	78 05                	js     802cb8 <accept+0x2d>
	return alloc_sockfd(r);
  802cb3:	e8 5f ff ff ff       	call   802c17 <alloc_sockfd>
}
  802cb8:	c9                   	leave  
  802cb9:	c3                   	ret    

00802cba <bind>:
{
  802cba:	55                   	push   %ebp
  802cbb:	89 e5                	mov    %esp,%ebp
  802cbd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	e8 1f ff ff ff       	call   802be7 <fd2sockid>
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	78 12                	js     802cde <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802ccc:	83 ec 04             	sub    $0x4,%esp
  802ccf:	ff 75 10             	pushl  0x10(%ebp)
  802cd2:	ff 75 0c             	pushl  0xc(%ebp)
  802cd5:	50                   	push   %eax
  802cd6:	e8 2f 01 00 00       	call   802e0a <nsipc_bind>
  802cdb:	83 c4 10             	add    $0x10,%esp
}
  802cde:	c9                   	leave  
  802cdf:	c3                   	ret    

00802ce0 <shutdown>:
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	e8 f9 fe ff ff       	call   802be7 <fd2sockid>
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	78 0f                	js     802d01 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802cf2:	83 ec 08             	sub    $0x8,%esp
  802cf5:	ff 75 0c             	pushl  0xc(%ebp)
  802cf8:	50                   	push   %eax
  802cf9:	e8 41 01 00 00       	call   802e3f <nsipc_shutdown>
  802cfe:	83 c4 10             	add    $0x10,%esp
}
  802d01:	c9                   	leave  
  802d02:	c3                   	ret    

00802d03 <connect>:
{
  802d03:	55                   	push   %ebp
  802d04:	89 e5                	mov    %esp,%ebp
  802d06:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	e8 d6 fe ff ff       	call   802be7 <fd2sockid>
  802d11:	85 c0                	test   %eax,%eax
  802d13:	78 12                	js     802d27 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	ff 75 10             	pushl  0x10(%ebp)
  802d1b:	ff 75 0c             	pushl  0xc(%ebp)
  802d1e:	50                   	push   %eax
  802d1f:	e8 57 01 00 00       	call   802e7b <nsipc_connect>
  802d24:	83 c4 10             	add    $0x10,%esp
}
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <listen>:
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
  802d2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	e8 b0 fe ff ff       	call   802be7 <fd2sockid>
  802d37:	85 c0                	test   %eax,%eax
  802d39:	78 0f                	js     802d4a <listen+0x21>
	return nsipc_listen(r, backlog);
  802d3b:	83 ec 08             	sub    $0x8,%esp
  802d3e:	ff 75 0c             	pushl  0xc(%ebp)
  802d41:	50                   	push   %eax
  802d42:	e8 69 01 00 00       	call   802eb0 <nsipc_listen>
  802d47:	83 c4 10             	add    $0x10,%esp
}
  802d4a:	c9                   	leave  
  802d4b:	c3                   	ret    

00802d4c <socket>:

int
socket(int domain, int type, int protocol)
{
  802d4c:	55                   	push   %ebp
  802d4d:	89 e5                	mov    %esp,%ebp
  802d4f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802d52:	ff 75 10             	pushl  0x10(%ebp)
  802d55:	ff 75 0c             	pushl  0xc(%ebp)
  802d58:	ff 75 08             	pushl  0x8(%ebp)
  802d5b:	e8 3c 02 00 00       	call   802f9c <nsipc_socket>
  802d60:	83 c4 10             	add    $0x10,%esp
  802d63:	85 c0                	test   %eax,%eax
  802d65:	78 05                	js     802d6c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802d67:	e8 ab fe ff ff       	call   802c17 <alloc_sockfd>
}
  802d6c:	c9                   	leave  
  802d6d:	c3                   	ret    

00802d6e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802d6e:	55                   	push   %ebp
  802d6f:	89 e5                	mov    %esp,%ebp
  802d71:	53                   	push   %ebx
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802d77:	83 3d 24 54 80 00 00 	cmpl   $0x0,0x805424
  802d7e:	74 26                	je     802da6 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802d80:	6a 07                	push   $0x7
  802d82:	68 00 70 80 00       	push   $0x807000
  802d87:	53                   	push   %ebx
  802d88:	ff 35 24 54 80 00    	pushl  0x805424
  802d8e:	e8 c1 06 00 00       	call   803454 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802d93:	83 c4 0c             	add    $0xc,%esp
  802d96:	6a 00                	push   $0x0
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 00                	push   $0x0
  802d9c:	e8 4c 06 00 00       	call   8033ed <ipc_recv>
}
  802da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802da6:	83 ec 0c             	sub    $0xc,%esp
  802da9:	6a 02                	push   $0x2
  802dab:	e8 f8 06 00 00       	call   8034a8 <ipc_find_env>
  802db0:	a3 24 54 80 00       	mov    %eax,0x805424
  802db5:	83 c4 10             	add    $0x10,%esp
  802db8:	eb c6                	jmp    802d80 <nsipc+0x12>

00802dba <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	56                   	push   %esi
  802dbe:	53                   	push   %ebx
  802dbf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802dca:	8b 06                	mov    (%esi),%eax
  802dcc:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802dd1:	b8 01 00 00 00       	mov    $0x1,%eax
  802dd6:	e8 93 ff ff ff       	call   802d6e <nsipc>
  802ddb:	89 c3                	mov    %eax,%ebx
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	78 20                	js     802e01 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	ff 35 10 70 80 00    	pushl  0x807010
  802dea:	68 00 70 80 00       	push   $0x807000
  802def:	ff 75 0c             	pushl  0xc(%ebp)
  802df2:	e8 00 e6 ff ff       	call   8013f7 <memmove>
		*addrlen = ret->ret_addrlen;
  802df7:	a1 10 70 80 00       	mov    0x807010,%eax
  802dfc:	89 06                	mov    %eax,(%esi)
  802dfe:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802e01:	89 d8                	mov    %ebx,%eax
  802e03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e06:	5b                   	pop    %ebx
  802e07:	5e                   	pop    %esi
  802e08:	5d                   	pop    %ebp
  802e09:	c3                   	ret    

00802e0a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e0a:	55                   	push   %ebp
  802e0b:	89 e5                	mov    %esp,%ebp
  802e0d:	53                   	push   %ebx
  802e0e:	83 ec 08             	sub    $0x8,%esp
  802e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802e1c:	53                   	push   %ebx
  802e1d:	ff 75 0c             	pushl  0xc(%ebp)
  802e20:	68 04 70 80 00       	push   $0x807004
  802e25:	e8 cd e5 ff ff       	call   8013f7 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802e2a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802e30:	b8 02 00 00 00       	mov    $0x2,%eax
  802e35:	e8 34 ff ff ff       	call   802d6e <nsipc>
}
  802e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e3d:	c9                   	leave  
  802e3e:	c3                   	ret    

00802e3f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
  802e42:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e50:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802e55:	b8 03 00 00 00       	mov    $0x3,%eax
  802e5a:	e8 0f ff ff ff       	call   802d6e <nsipc>
}
  802e5f:	c9                   	leave  
  802e60:	c3                   	ret    

00802e61 <nsipc_close>:

int
nsipc_close(int s)
{
  802e61:	55                   	push   %ebp
  802e62:	89 e5                	mov    %esp,%ebp
  802e64:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802e6f:	b8 04 00 00 00       	mov    $0x4,%eax
  802e74:	e8 f5 fe ff ff       	call   802d6e <nsipc>
}
  802e79:	c9                   	leave  
  802e7a:	c3                   	ret    

00802e7b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802e7b:	55                   	push   %ebp
  802e7c:	89 e5                	mov    %esp,%ebp
  802e7e:	53                   	push   %ebx
  802e7f:	83 ec 08             	sub    $0x8,%esp
  802e82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802e8d:	53                   	push   %ebx
  802e8e:	ff 75 0c             	pushl  0xc(%ebp)
  802e91:	68 04 70 80 00       	push   $0x807004
  802e96:	e8 5c e5 ff ff       	call   8013f7 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802e9b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802ea1:	b8 05 00 00 00       	mov    $0x5,%eax
  802ea6:	e8 c3 fe ff ff       	call   802d6e <nsipc>
}
  802eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
  802eb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802ec6:	b8 06 00 00 00       	mov    $0x6,%eax
  802ecb:	e8 9e fe ff ff       	call   802d6e <nsipc>
}
  802ed0:	c9                   	leave  
  802ed1:	c3                   	ret    

00802ed2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802ed2:	55                   	push   %ebp
  802ed3:	89 e5                	mov    %esp,%ebp
  802ed5:	56                   	push   %esi
  802ed6:	53                   	push   %ebx
  802ed7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802ee2:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802ee8:	8b 45 14             	mov    0x14(%ebp),%eax
  802eeb:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802ef0:	b8 07 00 00 00       	mov    $0x7,%eax
  802ef5:	e8 74 fe ff ff       	call   802d6e <nsipc>
  802efa:	89 c3                	mov    %eax,%ebx
  802efc:	85 c0                	test   %eax,%eax
  802efe:	78 1f                	js     802f1f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802f00:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802f05:	7f 21                	jg     802f28 <nsipc_recv+0x56>
  802f07:	39 c6                	cmp    %eax,%esi
  802f09:	7c 1d                	jl     802f28 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	50                   	push   %eax
  802f0f:	68 00 70 80 00       	push   $0x807000
  802f14:	ff 75 0c             	pushl  0xc(%ebp)
  802f17:	e8 db e4 ff ff       	call   8013f7 <memmove>
  802f1c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802f1f:	89 d8                	mov    %ebx,%eax
  802f21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f24:	5b                   	pop    %ebx
  802f25:	5e                   	pop    %esi
  802f26:	5d                   	pop    %ebp
  802f27:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802f28:	68 34 3f 80 00       	push   $0x803f34
  802f2d:	68 af 38 80 00       	push   $0x8038af
  802f32:	6a 62                	push   $0x62
  802f34:	68 49 3f 80 00       	push   $0x803f49
  802f39:	e8 41 db ff ff       	call   800a7f <_panic>

00802f3e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802f3e:	55                   	push   %ebp
  802f3f:	89 e5                	mov    %esp,%ebp
  802f41:	53                   	push   %ebx
  802f42:	83 ec 04             	sub    $0x4,%esp
  802f45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802f50:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802f56:	7f 2e                	jg     802f86 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802f58:	83 ec 04             	sub    $0x4,%esp
  802f5b:	53                   	push   %ebx
  802f5c:	ff 75 0c             	pushl  0xc(%ebp)
  802f5f:	68 0c 70 80 00       	push   $0x80700c
  802f64:	e8 8e e4 ff ff       	call   8013f7 <memmove>
	nsipcbuf.send.req_size = size;
  802f69:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802f6f:	8b 45 14             	mov    0x14(%ebp),%eax
  802f72:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802f77:	b8 08 00 00 00       	mov    $0x8,%eax
  802f7c:	e8 ed fd ff ff       	call   802d6e <nsipc>
}
  802f81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f84:	c9                   	leave  
  802f85:	c3                   	ret    
	assert(size < 1600);
  802f86:	68 55 3f 80 00       	push   $0x803f55
  802f8b:	68 af 38 80 00       	push   $0x8038af
  802f90:	6a 6d                	push   $0x6d
  802f92:	68 49 3f 80 00       	push   $0x803f49
  802f97:	e8 e3 da ff ff       	call   800a7f <_panic>

00802f9c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802f9c:	55                   	push   %ebp
  802f9d:	89 e5                	mov    %esp,%ebp
  802f9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  802fb5:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802fba:	b8 09 00 00 00       	mov    $0x9,%eax
  802fbf:	e8 aa fd ff ff       	call   802d6e <nsipc>
}
  802fc4:	c9                   	leave  
  802fc5:	c3                   	ret    

00802fc6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802fc6:	55                   	push   %ebp
  802fc7:	89 e5                	mov    %esp,%ebp
  802fc9:	56                   	push   %esi
  802fca:	53                   	push   %ebx
  802fcb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802fce:	83 ec 0c             	sub    $0xc,%esp
  802fd1:	ff 75 08             	pushl  0x8(%ebp)
  802fd4:	e8 9b ec ff ff       	call   801c74 <fd2data>
  802fd9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802fdb:	83 c4 08             	add    $0x8,%esp
  802fde:	68 61 3f 80 00       	push   $0x803f61
  802fe3:	53                   	push   %ebx
  802fe4:	e8 80 e2 ff ff       	call   801269 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802fe9:	8b 46 04             	mov    0x4(%esi),%eax
  802fec:	2b 06                	sub    (%esi),%eax
  802fee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802ff4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802ffb:	00 00 00 
	stat->st_dev = &devpipe;
  802ffe:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  803005:	40 80 00 
	return 0;
}
  803008:	b8 00 00 00 00       	mov    $0x0,%eax
  80300d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803010:	5b                   	pop    %ebx
  803011:	5e                   	pop    %esi
  803012:	5d                   	pop    %ebp
  803013:	c3                   	ret    

00803014 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
  803017:	53                   	push   %ebx
  803018:	83 ec 0c             	sub    $0xc,%esp
  80301b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80301e:	53                   	push   %ebx
  80301f:	6a 00                	push   $0x0
  803021:	e8 c1 e6 ff ff       	call   8016e7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803026:	89 1c 24             	mov    %ebx,(%esp)
  803029:	e8 46 ec ff ff       	call   801c74 <fd2data>
  80302e:	83 c4 08             	add    $0x8,%esp
  803031:	50                   	push   %eax
  803032:	6a 00                	push   $0x0
  803034:	e8 ae e6 ff ff       	call   8016e7 <sys_page_unmap>
}
  803039:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80303c:	c9                   	leave  
  80303d:	c3                   	ret    

0080303e <_pipeisclosed>:
{
  80303e:	55                   	push   %ebp
  80303f:	89 e5                	mov    %esp,%ebp
  803041:	57                   	push   %edi
  803042:	56                   	push   %esi
  803043:	53                   	push   %ebx
  803044:	83 ec 1c             	sub    $0x1c,%esp
  803047:	89 c7                	mov    %eax,%edi
  803049:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80304b:	a1 28 54 80 00       	mov    0x805428,%eax
  803050:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803053:	83 ec 0c             	sub    $0xc,%esp
  803056:	57                   	push   %edi
  803057:	e8 85 04 00 00       	call   8034e1 <pageref>
  80305c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80305f:	89 34 24             	mov    %esi,(%esp)
  803062:	e8 7a 04 00 00       	call   8034e1 <pageref>
		nn = thisenv->env_runs;
  803067:	8b 15 28 54 80 00    	mov    0x805428,%edx
  80306d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803070:	83 c4 10             	add    $0x10,%esp
  803073:	39 cb                	cmp    %ecx,%ebx
  803075:	74 1b                	je     803092 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803077:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80307a:	75 cf                	jne    80304b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80307c:	8b 42 58             	mov    0x58(%edx),%eax
  80307f:	6a 01                	push   $0x1
  803081:	50                   	push   %eax
  803082:	53                   	push   %ebx
  803083:	68 68 3f 80 00       	push   $0x803f68
  803088:	e8 cd da ff ff       	call   800b5a <cprintf>
  80308d:	83 c4 10             	add    $0x10,%esp
  803090:	eb b9                	jmp    80304b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803092:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803095:	0f 94 c0             	sete   %al
  803098:	0f b6 c0             	movzbl %al,%eax
}
  80309b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80309e:	5b                   	pop    %ebx
  80309f:	5e                   	pop    %esi
  8030a0:	5f                   	pop    %edi
  8030a1:	5d                   	pop    %ebp
  8030a2:	c3                   	ret    

008030a3 <devpipe_write>:
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	57                   	push   %edi
  8030a7:	56                   	push   %esi
  8030a8:	53                   	push   %ebx
  8030a9:	83 ec 28             	sub    $0x28,%esp
  8030ac:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8030af:	56                   	push   %esi
  8030b0:	e8 bf eb ff ff       	call   801c74 <fd2data>
  8030b5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8030b7:	83 c4 10             	add    $0x10,%esp
  8030ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8030bf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8030c2:	74 4f                	je     803113 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030c4:	8b 43 04             	mov    0x4(%ebx),%eax
  8030c7:	8b 0b                	mov    (%ebx),%ecx
  8030c9:	8d 51 20             	lea    0x20(%ecx),%edx
  8030cc:	39 d0                	cmp    %edx,%eax
  8030ce:	72 14                	jb     8030e4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8030d0:	89 da                	mov    %ebx,%edx
  8030d2:	89 f0                	mov    %esi,%eax
  8030d4:	e8 65 ff ff ff       	call   80303e <_pipeisclosed>
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	75 3a                	jne    803117 <devpipe_write+0x74>
			sys_yield();
  8030dd:	e8 61 e5 ff ff       	call   801643 <sys_yield>
  8030e2:	eb e0                	jmp    8030c4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8030e7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8030eb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8030ee:	89 c2                	mov    %eax,%edx
  8030f0:	c1 fa 1f             	sar    $0x1f,%edx
  8030f3:	89 d1                	mov    %edx,%ecx
  8030f5:	c1 e9 1b             	shr    $0x1b,%ecx
  8030f8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8030fb:	83 e2 1f             	and    $0x1f,%edx
  8030fe:	29 ca                	sub    %ecx,%edx
  803100:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803104:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803108:	83 c0 01             	add    $0x1,%eax
  80310b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80310e:	83 c7 01             	add    $0x1,%edi
  803111:	eb ac                	jmp    8030bf <devpipe_write+0x1c>
	return i;
  803113:	89 f8                	mov    %edi,%eax
  803115:	eb 05                	jmp    80311c <devpipe_write+0x79>
				return 0;
  803117:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80311c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80311f:	5b                   	pop    %ebx
  803120:	5e                   	pop    %esi
  803121:	5f                   	pop    %edi
  803122:	5d                   	pop    %ebp
  803123:	c3                   	ret    

00803124 <devpipe_read>:
{
  803124:	55                   	push   %ebp
  803125:	89 e5                	mov    %esp,%ebp
  803127:	57                   	push   %edi
  803128:	56                   	push   %esi
  803129:	53                   	push   %ebx
  80312a:	83 ec 18             	sub    $0x18,%esp
  80312d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803130:	57                   	push   %edi
  803131:	e8 3e eb ff ff       	call   801c74 <fd2data>
  803136:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803138:	83 c4 10             	add    $0x10,%esp
  80313b:	be 00 00 00 00       	mov    $0x0,%esi
  803140:	3b 75 10             	cmp    0x10(%ebp),%esi
  803143:	74 47                	je     80318c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  803145:	8b 03                	mov    (%ebx),%eax
  803147:	3b 43 04             	cmp    0x4(%ebx),%eax
  80314a:	75 22                	jne    80316e <devpipe_read+0x4a>
			if (i > 0)
  80314c:	85 f6                	test   %esi,%esi
  80314e:	75 14                	jne    803164 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  803150:	89 da                	mov    %ebx,%edx
  803152:	89 f8                	mov    %edi,%eax
  803154:	e8 e5 fe ff ff       	call   80303e <_pipeisclosed>
  803159:	85 c0                	test   %eax,%eax
  80315b:	75 33                	jne    803190 <devpipe_read+0x6c>
			sys_yield();
  80315d:	e8 e1 e4 ff ff       	call   801643 <sys_yield>
  803162:	eb e1                	jmp    803145 <devpipe_read+0x21>
				return i;
  803164:	89 f0                	mov    %esi,%eax
}
  803166:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803169:	5b                   	pop    %ebx
  80316a:	5e                   	pop    %esi
  80316b:	5f                   	pop    %edi
  80316c:	5d                   	pop    %ebp
  80316d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80316e:	99                   	cltd   
  80316f:	c1 ea 1b             	shr    $0x1b,%edx
  803172:	01 d0                	add    %edx,%eax
  803174:	83 e0 1f             	and    $0x1f,%eax
  803177:	29 d0                	sub    %edx,%eax
  803179:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80317e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803181:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803184:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803187:	83 c6 01             	add    $0x1,%esi
  80318a:	eb b4                	jmp    803140 <devpipe_read+0x1c>
	return i;
  80318c:	89 f0                	mov    %esi,%eax
  80318e:	eb d6                	jmp    803166 <devpipe_read+0x42>
				return 0;
  803190:	b8 00 00 00 00       	mov    $0x0,%eax
  803195:	eb cf                	jmp    803166 <devpipe_read+0x42>

00803197 <pipe>:
{
  803197:	55                   	push   %ebp
  803198:	89 e5                	mov    %esp,%ebp
  80319a:	56                   	push   %esi
  80319b:	53                   	push   %ebx
  80319c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80319f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031a2:	50                   	push   %eax
  8031a3:	e8 e3 ea ff ff       	call   801c8b <fd_alloc>
  8031a8:	89 c3                	mov    %eax,%ebx
  8031aa:	83 c4 10             	add    $0x10,%esp
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	78 5b                	js     80320c <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	68 07 04 00 00       	push   $0x407
  8031b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8031bc:	6a 00                	push   $0x0
  8031be:	e8 9f e4 ff ff       	call   801662 <sys_page_alloc>
  8031c3:	89 c3                	mov    %eax,%ebx
  8031c5:	83 c4 10             	add    $0x10,%esp
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	78 40                	js     80320c <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8031cc:	83 ec 0c             	sub    $0xc,%esp
  8031cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031d2:	50                   	push   %eax
  8031d3:	e8 b3 ea ff ff       	call   801c8b <fd_alloc>
  8031d8:	89 c3                	mov    %eax,%ebx
  8031da:	83 c4 10             	add    $0x10,%esp
  8031dd:	85 c0                	test   %eax,%eax
  8031df:	78 1b                	js     8031fc <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	68 07 04 00 00       	push   $0x407
  8031e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ec:	6a 00                	push   $0x0
  8031ee:	e8 6f e4 ff ff       	call   801662 <sys_page_alloc>
  8031f3:	89 c3                	mov    %eax,%ebx
  8031f5:	83 c4 10             	add    $0x10,%esp
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	79 19                	jns    803215 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8031fc:	83 ec 08             	sub    $0x8,%esp
  8031ff:	ff 75 f4             	pushl  -0xc(%ebp)
  803202:	6a 00                	push   $0x0
  803204:	e8 de e4 ff ff       	call   8016e7 <sys_page_unmap>
  803209:	83 c4 10             	add    $0x10,%esp
}
  80320c:	89 d8                	mov    %ebx,%eax
  80320e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803211:	5b                   	pop    %ebx
  803212:	5e                   	pop    %esi
  803213:	5d                   	pop    %ebp
  803214:	c3                   	ret    
	va = fd2data(fd0);
  803215:	83 ec 0c             	sub    $0xc,%esp
  803218:	ff 75 f4             	pushl  -0xc(%ebp)
  80321b:	e8 54 ea ff ff       	call   801c74 <fd2data>
  803220:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803222:	83 c4 0c             	add    $0xc,%esp
  803225:	68 07 04 00 00       	push   $0x407
  80322a:	50                   	push   %eax
  80322b:	6a 00                	push   $0x0
  80322d:	e8 30 e4 ff ff       	call   801662 <sys_page_alloc>
  803232:	89 c3                	mov    %eax,%ebx
  803234:	83 c4 10             	add    $0x10,%esp
  803237:	85 c0                	test   %eax,%eax
  803239:	0f 88 8c 00 00 00    	js     8032cb <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80323f:	83 ec 0c             	sub    $0xc,%esp
  803242:	ff 75 f0             	pushl  -0x10(%ebp)
  803245:	e8 2a ea ff ff       	call   801c74 <fd2data>
  80324a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803251:	50                   	push   %eax
  803252:	6a 00                	push   $0x0
  803254:	56                   	push   %esi
  803255:	6a 00                	push   $0x0
  803257:	e8 49 e4 ff ff       	call   8016a5 <sys_page_map>
  80325c:	89 c3                	mov    %eax,%ebx
  80325e:	83 c4 20             	add    $0x20,%esp
  803261:	85 c0                	test   %eax,%eax
  803263:	78 58                	js     8032bd <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80326e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  803283:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803288:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80328f:	83 ec 0c             	sub    $0xc,%esp
  803292:	ff 75 f4             	pushl  -0xc(%ebp)
  803295:	e8 ca e9 ff ff       	call   801c64 <fd2num>
  80329a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80329d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80329f:	83 c4 04             	add    $0x4,%esp
  8032a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8032a5:	e8 ba e9 ff ff       	call   801c64 <fd2num>
  8032aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032ad:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8032b0:	83 c4 10             	add    $0x10,%esp
  8032b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8032b8:	e9 4f ff ff ff       	jmp    80320c <pipe+0x75>
	sys_page_unmap(0, va);
  8032bd:	83 ec 08             	sub    $0x8,%esp
  8032c0:	56                   	push   %esi
  8032c1:	6a 00                	push   $0x0
  8032c3:	e8 1f e4 ff ff       	call   8016e7 <sys_page_unmap>
  8032c8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8032cb:	83 ec 08             	sub    $0x8,%esp
  8032ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8032d1:	6a 00                	push   $0x0
  8032d3:	e8 0f e4 ff ff       	call   8016e7 <sys_page_unmap>
  8032d8:	83 c4 10             	add    $0x10,%esp
  8032db:	e9 1c ff ff ff       	jmp    8031fc <pipe+0x65>

008032e0 <pipeisclosed>:
{
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
  8032e3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032e9:	50                   	push   %eax
  8032ea:	ff 75 08             	pushl  0x8(%ebp)
  8032ed:	e8 e8 e9 ff ff       	call   801cda <fd_lookup>
  8032f2:	83 c4 10             	add    $0x10,%esp
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	78 18                	js     803311 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8032f9:	83 ec 0c             	sub    $0xc,%esp
  8032fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ff:	e8 70 e9 ff ff       	call   801c74 <fd2data>
	return _pipeisclosed(fd, p);
  803304:	89 c2                	mov    %eax,%edx
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	e8 30 fd ff ff       	call   80303e <_pipeisclosed>
  80330e:	83 c4 10             	add    $0x10,%esp
}
  803311:	c9                   	leave  
  803312:	c3                   	ret    

00803313 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803313:	55                   	push   %ebp
  803314:	89 e5                	mov    %esp,%ebp
  803316:	56                   	push   %esi
  803317:	53                   	push   %ebx
  803318:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80331b:	85 f6                	test   %esi,%esi
  80331d:	74 13                	je     803332 <wait+0x1f>
	e = &envs[ENVX(envid)];
  80331f:	89 f3                	mov    %esi,%ebx
  803321:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803327:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80332a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803330:	eb 1b                	jmp    80334d <wait+0x3a>
	assert(envid != 0);
  803332:	68 80 3f 80 00       	push   $0x803f80
  803337:	68 af 38 80 00       	push   $0x8038af
  80333c:	6a 09                	push   $0x9
  80333e:	68 8b 3f 80 00       	push   $0x803f8b
  803343:	e8 37 d7 ff ff       	call   800a7f <_panic>
		sys_yield();
  803348:	e8 f6 e2 ff ff       	call   801643 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80334d:	8b 43 48             	mov    0x48(%ebx),%eax
  803350:	39 f0                	cmp    %esi,%eax
  803352:	75 07                	jne    80335b <wait+0x48>
  803354:	8b 43 54             	mov    0x54(%ebx),%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	75 ed                	jne    803348 <wait+0x35>
}
  80335b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80335e:	5b                   	pop    %ebx
  80335f:	5e                   	pop    %esi
  803360:	5d                   	pop    %ebp
  803361:	c3                   	ret    

00803362 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803362:	55                   	push   %ebp
  803363:	89 e5                	mov    %esp,%ebp
  803365:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  803368:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80336f:	74 0a                	je     80337b <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803379:	c9                   	leave  
  80337a:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  80337b:	a1 28 54 80 00       	mov    0x805428,%eax
  803380:	8b 40 48             	mov    0x48(%eax),%eax
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	6a 07                	push   $0x7
  803388:	68 00 f0 bf ee       	push   $0xeebff000
  80338d:	50                   	push   %eax
  80338e:	e8 cf e2 ff ff       	call   801662 <sys_page_alloc>
  803393:	83 c4 10             	add    $0x10,%esp
  803396:	85 c0                	test   %eax,%eax
  803398:	78 1b                	js     8033b5 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80339a:	a1 28 54 80 00       	mov    0x805428,%eax
  80339f:	8b 40 48             	mov    0x48(%eax),%eax
  8033a2:	83 ec 08             	sub    $0x8,%esp
  8033a5:	68 c7 33 80 00       	push   $0x8033c7
  8033aa:	50                   	push   %eax
  8033ab:	e8 fd e3 ff ff       	call   8017ad <sys_env_set_pgfault_upcall>
  8033b0:	83 c4 10             	add    $0x10,%esp
  8033b3:	eb bc                	jmp    803371 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  8033b5:	50                   	push   %eax
  8033b6:	68 96 3f 80 00       	push   $0x803f96
  8033bb:	6a 22                	push   $0x22
  8033bd:	68 ae 3f 80 00       	push   $0x803fae
  8033c2:	e8 b8 d6 ff ff       	call   800a7f <_panic>

008033c7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8033c7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8033c8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8033cd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8033cf:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8033d2:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8033d6:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8033d9:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8033dd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8033e1:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8033e3:	83 c4 08             	add    $0x8,%esp
	popal
  8033e6:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8033e7:	83 c4 04             	add    $0x4,%esp
	popfl
  8033ea:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8033eb:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8033ec:	c3                   	ret    

008033ed <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033ed:	55                   	push   %ebp
  8033ee:	89 e5                	mov    %esp,%ebp
  8033f0:	56                   	push   %esi
  8033f1:	53                   	push   %ebx
  8033f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8033f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8033fb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8033fd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803402:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  803405:	83 ec 0c             	sub    $0xc,%esp
  803408:	50                   	push   %eax
  803409:	e8 04 e4 ff ff       	call   801812 <sys_ipc_recv>
	if (from_env_store)
  80340e:	83 c4 10             	add    $0x10,%esp
  803411:	85 f6                	test   %esi,%esi
  803413:	74 14                	je     803429 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  803415:	ba 00 00 00 00       	mov    $0x0,%edx
  80341a:	85 c0                	test   %eax,%eax
  80341c:	78 09                	js     803427 <ipc_recv+0x3a>
  80341e:	8b 15 28 54 80 00    	mov    0x805428,%edx
  803424:	8b 52 74             	mov    0x74(%edx),%edx
  803427:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  803429:	85 db                	test   %ebx,%ebx
  80342b:	74 14                	je     803441 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  80342d:	ba 00 00 00 00       	mov    $0x0,%edx
  803432:	85 c0                	test   %eax,%eax
  803434:	78 09                	js     80343f <ipc_recv+0x52>
  803436:	8b 15 28 54 80 00    	mov    0x805428,%edx
  80343c:	8b 52 78             	mov    0x78(%edx),%edx
  80343f:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  803441:	85 c0                	test   %eax,%eax
  803443:	78 08                	js     80344d <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  803445:	a1 28 54 80 00       	mov    0x805428,%eax
  80344a:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  80344d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803450:	5b                   	pop    %ebx
  803451:	5e                   	pop    %esi
  803452:	5d                   	pop    %ebp
  803453:	c3                   	ret    

00803454 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803454:	55                   	push   %ebp
  803455:	89 e5                	mov    %esp,%ebp
  803457:	57                   	push   %edi
  803458:	56                   	push   %esi
  803459:	53                   	push   %ebx
  80345a:	83 ec 0c             	sub    $0xc,%esp
  80345d:	8b 7d 08             	mov    0x8(%ebp),%edi
  803460:	8b 75 0c             	mov    0xc(%ebp),%esi
  803463:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  803466:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  803468:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80346d:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  803470:	ff 75 14             	pushl  0x14(%ebp)
  803473:	53                   	push   %ebx
  803474:	56                   	push   %esi
  803475:	57                   	push   %edi
  803476:	e8 74 e3 ff ff       	call   8017ef <sys_ipc_try_send>
		if (ret == 0)
  80347b:	83 c4 10             	add    $0x10,%esp
  80347e:	85 c0                	test   %eax,%eax
  803480:	74 1e                	je     8034a0 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  803482:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803485:	75 07                	jne    80348e <ipc_send+0x3a>
			sys_yield();
  803487:	e8 b7 e1 ff ff       	call   801643 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80348c:	eb e2                	jmp    803470 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80348e:	50                   	push   %eax
  80348f:	68 bc 3f 80 00       	push   $0x803fbc
  803494:	6a 3d                	push   $0x3d
  803496:	68 d0 3f 80 00       	push   $0x803fd0
  80349b:	e8 df d5 ff ff       	call   800a7f <_panic>
	}
	// panic("ipc_send not implemented");
}
  8034a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    

008034a8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034a8:	55                   	push   %ebp
  8034a9:	89 e5                	mov    %esp,%ebp
  8034ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8034ae:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8034b3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8034b6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8034bc:	8b 52 50             	mov    0x50(%edx),%edx
  8034bf:	39 ca                	cmp    %ecx,%edx
  8034c1:	74 11                	je     8034d4 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8034c3:	83 c0 01             	add    $0x1,%eax
  8034c6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8034cb:	75 e6                	jne    8034b3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8034cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d2:	eb 0b                	jmp    8034df <ipc_find_env+0x37>
			return envs[i].env_id;
  8034d4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8034d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8034dc:	8b 40 48             	mov    0x48(%eax),%eax
}
  8034df:	5d                   	pop    %ebp
  8034e0:	c3                   	ret    

008034e1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034e1:	55                   	push   %ebp
  8034e2:	89 e5                	mov    %esp,%ebp
  8034e4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8034e7:	89 d0                	mov    %edx,%eax
  8034e9:	c1 e8 16             	shr    $0x16,%eax
  8034ec:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8034f3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8034f8:	f6 c1 01             	test   $0x1,%cl
  8034fb:	74 1d                	je     80351a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8034fd:	c1 ea 0c             	shr    $0xc,%edx
  803500:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803507:	f6 c2 01             	test   $0x1,%dl
  80350a:	74 0e                	je     80351a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80350c:	c1 ea 0c             	shr    $0xc,%edx
  80350f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803516:	ef 
  803517:	0f b7 c0             	movzwl %ax,%eax
}
  80351a:	5d                   	pop    %ebp
  80351b:	c3                   	ret    
  80351c:	66 90                	xchg   %ax,%ax
  80351e:	66 90                	xchg   %ax,%ax

00803520 <__udivdi3>:
  803520:	55                   	push   %ebp
  803521:	57                   	push   %edi
  803522:	56                   	push   %esi
  803523:	53                   	push   %ebx
  803524:	83 ec 1c             	sub    $0x1c,%esp
  803527:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80352b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80352f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803533:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803537:	85 d2                	test   %edx,%edx
  803539:	75 35                	jne    803570 <__udivdi3+0x50>
  80353b:	39 f3                	cmp    %esi,%ebx
  80353d:	0f 87 bd 00 00 00    	ja     803600 <__udivdi3+0xe0>
  803543:	85 db                	test   %ebx,%ebx
  803545:	89 d9                	mov    %ebx,%ecx
  803547:	75 0b                	jne    803554 <__udivdi3+0x34>
  803549:	b8 01 00 00 00       	mov    $0x1,%eax
  80354e:	31 d2                	xor    %edx,%edx
  803550:	f7 f3                	div    %ebx
  803552:	89 c1                	mov    %eax,%ecx
  803554:	31 d2                	xor    %edx,%edx
  803556:	89 f0                	mov    %esi,%eax
  803558:	f7 f1                	div    %ecx
  80355a:	89 c6                	mov    %eax,%esi
  80355c:	89 e8                	mov    %ebp,%eax
  80355e:	89 f7                	mov    %esi,%edi
  803560:	f7 f1                	div    %ecx
  803562:	89 fa                	mov    %edi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803570:	39 f2                	cmp    %esi,%edx
  803572:	77 7c                	ja     8035f0 <__udivdi3+0xd0>
  803574:	0f bd fa             	bsr    %edx,%edi
  803577:	83 f7 1f             	xor    $0x1f,%edi
  80357a:	0f 84 98 00 00 00    	je     803618 <__udivdi3+0xf8>
  803580:	89 f9                	mov    %edi,%ecx
  803582:	b8 20 00 00 00       	mov    $0x20,%eax
  803587:	29 f8                	sub    %edi,%eax
  803589:	d3 e2                	shl    %cl,%edx
  80358b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80358f:	89 c1                	mov    %eax,%ecx
  803591:	89 da                	mov    %ebx,%edx
  803593:	d3 ea                	shr    %cl,%edx
  803595:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803599:	09 d1                	or     %edx,%ecx
  80359b:	89 f2                	mov    %esi,%edx
  80359d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035a1:	89 f9                	mov    %edi,%ecx
  8035a3:	d3 e3                	shl    %cl,%ebx
  8035a5:	89 c1                	mov    %eax,%ecx
  8035a7:	d3 ea                	shr    %cl,%edx
  8035a9:	89 f9                	mov    %edi,%ecx
  8035ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8035af:	d3 e6                	shl    %cl,%esi
  8035b1:	89 eb                	mov    %ebp,%ebx
  8035b3:	89 c1                	mov    %eax,%ecx
  8035b5:	d3 eb                	shr    %cl,%ebx
  8035b7:	09 de                	or     %ebx,%esi
  8035b9:	89 f0                	mov    %esi,%eax
  8035bb:	f7 74 24 08          	divl   0x8(%esp)
  8035bf:	89 d6                	mov    %edx,%esi
  8035c1:	89 c3                	mov    %eax,%ebx
  8035c3:	f7 64 24 0c          	mull   0xc(%esp)
  8035c7:	39 d6                	cmp    %edx,%esi
  8035c9:	72 0c                	jb     8035d7 <__udivdi3+0xb7>
  8035cb:	89 f9                	mov    %edi,%ecx
  8035cd:	d3 e5                	shl    %cl,%ebp
  8035cf:	39 c5                	cmp    %eax,%ebp
  8035d1:	73 5d                	jae    803630 <__udivdi3+0x110>
  8035d3:	39 d6                	cmp    %edx,%esi
  8035d5:	75 59                	jne    803630 <__udivdi3+0x110>
  8035d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035da:	31 ff                	xor    %edi,%edi
  8035dc:	89 fa                	mov    %edi,%edx
  8035de:	83 c4 1c             	add    $0x1c,%esp
  8035e1:	5b                   	pop    %ebx
  8035e2:	5e                   	pop    %esi
  8035e3:	5f                   	pop    %edi
  8035e4:	5d                   	pop    %ebp
  8035e5:	c3                   	ret    
  8035e6:	8d 76 00             	lea    0x0(%esi),%esi
  8035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8035f0:	31 ff                	xor    %edi,%edi
  8035f2:	31 c0                	xor    %eax,%eax
  8035f4:	89 fa                	mov    %edi,%edx
  8035f6:	83 c4 1c             	add    $0x1c,%esp
  8035f9:	5b                   	pop    %ebx
  8035fa:	5e                   	pop    %esi
  8035fb:	5f                   	pop    %edi
  8035fc:	5d                   	pop    %ebp
  8035fd:	c3                   	ret    
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	31 ff                	xor    %edi,%edi
  803602:	89 e8                	mov    %ebp,%eax
  803604:	89 f2                	mov    %esi,%edx
  803606:	f7 f3                	div    %ebx
  803608:	89 fa                	mov    %edi,%edx
  80360a:	83 c4 1c             	add    $0x1c,%esp
  80360d:	5b                   	pop    %ebx
  80360e:	5e                   	pop    %esi
  80360f:	5f                   	pop    %edi
  803610:	5d                   	pop    %ebp
  803611:	c3                   	ret    
  803612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803618:	39 f2                	cmp    %esi,%edx
  80361a:	72 06                	jb     803622 <__udivdi3+0x102>
  80361c:	31 c0                	xor    %eax,%eax
  80361e:	39 eb                	cmp    %ebp,%ebx
  803620:	77 d2                	ja     8035f4 <__udivdi3+0xd4>
  803622:	b8 01 00 00 00       	mov    $0x1,%eax
  803627:	eb cb                	jmp    8035f4 <__udivdi3+0xd4>
  803629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803630:	89 d8                	mov    %ebx,%eax
  803632:	31 ff                	xor    %edi,%edi
  803634:	eb be                	jmp    8035f4 <__udivdi3+0xd4>
  803636:	66 90                	xchg   %ax,%ax
  803638:	66 90                	xchg   %ax,%ax
  80363a:	66 90                	xchg   %ax,%ax
  80363c:	66 90                	xchg   %ax,%ax
  80363e:	66 90                	xchg   %ax,%ax

00803640 <__umoddi3>:
  803640:	55                   	push   %ebp
  803641:	57                   	push   %edi
  803642:	56                   	push   %esi
  803643:	53                   	push   %ebx
  803644:	83 ec 1c             	sub    $0x1c,%esp
  803647:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80364b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80364f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803653:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803657:	85 ed                	test   %ebp,%ebp
  803659:	89 f0                	mov    %esi,%eax
  80365b:	89 da                	mov    %ebx,%edx
  80365d:	75 19                	jne    803678 <__umoddi3+0x38>
  80365f:	39 df                	cmp    %ebx,%edi
  803661:	0f 86 b1 00 00 00    	jbe    803718 <__umoddi3+0xd8>
  803667:	f7 f7                	div    %edi
  803669:	89 d0                	mov    %edx,%eax
  80366b:	31 d2                	xor    %edx,%edx
  80366d:	83 c4 1c             	add    $0x1c,%esp
  803670:	5b                   	pop    %ebx
  803671:	5e                   	pop    %esi
  803672:	5f                   	pop    %edi
  803673:	5d                   	pop    %ebp
  803674:	c3                   	ret    
  803675:	8d 76 00             	lea    0x0(%esi),%esi
  803678:	39 dd                	cmp    %ebx,%ebp
  80367a:	77 f1                	ja     80366d <__umoddi3+0x2d>
  80367c:	0f bd cd             	bsr    %ebp,%ecx
  80367f:	83 f1 1f             	xor    $0x1f,%ecx
  803682:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803686:	0f 84 b4 00 00 00    	je     803740 <__umoddi3+0x100>
  80368c:	b8 20 00 00 00       	mov    $0x20,%eax
  803691:	89 c2                	mov    %eax,%edx
  803693:	8b 44 24 04          	mov    0x4(%esp),%eax
  803697:	29 c2                	sub    %eax,%edx
  803699:	89 c1                	mov    %eax,%ecx
  80369b:	89 f8                	mov    %edi,%eax
  80369d:	d3 e5                	shl    %cl,%ebp
  80369f:	89 d1                	mov    %edx,%ecx
  8036a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8036a5:	d3 e8                	shr    %cl,%eax
  8036a7:	09 c5                	or     %eax,%ebp
  8036a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036ad:	89 c1                	mov    %eax,%ecx
  8036af:	d3 e7                	shl    %cl,%edi
  8036b1:	89 d1                	mov    %edx,%ecx
  8036b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8036b7:	89 df                	mov    %ebx,%edi
  8036b9:	d3 ef                	shr    %cl,%edi
  8036bb:	89 c1                	mov    %eax,%ecx
  8036bd:	89 f0                	mov    %esi,%eax
  8036bf:	d3 e3                	shl    %cl,%ebx
  8036c1:	89 d1                	mov    %edx,%ecx
  8036c3:	89 fa                	mov    %edi,%edx
  8036c5:	d3 e8                	shr    %cl,%eax
  8036c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8036cc:	09 d8                	or     %ebx,%eax
  8036ce:	f7 f5                	div    %ebp
  8036d0:	d3 e6                	shl    %cl,%esi
  8036d2:	89 d1                	mov    %edx,%ecx
  8036d4:	f7 64 24 08          	mull   0x8(%esp)
  8036d8:	39 d1                	cmp    %edx,%ecx
  8036da:	89 c3                	mov    %eax,%ebx
  8036dc:	89 d7                	mov    %edx,%edi
  8036de:	72 06                	jb     8036e6 <__umoddi3+0xa6>
  8036e0:	75 0e                	jne    8036f0 <__umoddi3+0xb0>
  8036e2:	39 c6                	cmp    %eax,%esi
  8036e4:	73 0a                	jae    8036f0 <__umoddi3+0xb0>
  8036e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8036ea:	19 ea                	sbb    %ebp,%edx
  8036ec:	89 d7                	mov    %edx,%edi
  8036ee:	89 c3                	mov    %eax,%ebx
  8036f0:	89 ca                	mov    %ecx,%edx
  8036f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8036f7:	29 de                	sub    %ebx,%esi
  8036f9:	19 fa                	sbb    %edi,%edx
  8036fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8036ff:	89 d0                	mov    %edx,%eax
  803701:	d3 e0                	shl    %cl,%eax
  803703:	89 d9                	mov    %ebx,%ecx
  803705:	d3 ee                	shr    %cl,%esi
  803707:	d3 ea                	shr    %cl,%edx
  803709:	09 f0                	or     %esi,%eax
  80370b:	83 c4 1c             	add    $0x1c,%esp
  80370e:	5b                   	pop    %ebx
  80370f:	5e                   	pop    %esi
  803710:	5f                   	pop    %edi
  803711:	5d                   	pop    %ebp
  803712:	c3                   	ret    
  803713:	90                   	nop
  803714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803718:	85 ff                	test   %edi,%edi
  80371a:	89 f9                	mov    %edi,%ecx
  80371c:	75 0b                	jne    803729 <__umoddi3+0xe9>
  80371e:	b8 01 00 00 00       	mov    $0x1,%eax
  803723:	31 d2                	xor    %edx,%edx
  803725:	f7 f7                	div    %edi
  803727:	89 c1                	mov    %eax,%ecx
  803729:	89 d8                	mov    %ebx,%eax
  80372b:	31 d2                	xor    %edx,%edx
  80372d:	f7 f1                	div    %ecx
  80372f:	89 f0                	mov    %esi,%eax
  803731:	f7 f1                	div    %ecx
  803733:	e9 31 ff ff ff       	jmp    803669 <__umoddi3+0x29>
  803738:	90                   	nop
  803739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803740:	39 dd                	cmp    %ebx,%ebp
  803742:	72 08                	jb     80374c <__umoddi3+0x10c>
  803744:	39 f7                	cmp    %esi,%edi
  803746:	0f 87 21 ff ff ff    	ja     80366d <__umoddi3+0x2d>
  80374c:	89 da                	mov    %ebx,%edx
  80374e:	89 f0                	mov    %esi,%eax
  803750:	29 f8                	sub    %edi,%eax
  803752:	19 ea                	sbb    %ebp,%edx
  803754:	e9 14 ff ff ff       	jmp    80366d <__umoddi3+0x2d>

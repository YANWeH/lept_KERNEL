
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 97 02 00 00       	call   8002c8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 42 27 80 00       	push   $0x802742
  80005f:	e8 0b 1a 00 00       	call   801a6f <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 a8 27 80 00       	mov    $0x8027a8,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 4b 27 80 00       	push   $0x80274b
  80007f:	e8 eb 19 00 00       	call   801a6f <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 d9 2b 80 00       	push   $0x802bd9
  800092:	e8 d8 19 00 00       	call   801a6f <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 a7 27 80 00       	push   $0x8027a7
  8000b1:	e8 b9 19 00 00       	call   801a6f <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 22 09 00 00       	call   8009eb <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 40 27 80 00       	mov    $0x802740,%eax
  8000d6:	ba a8 27 80 00       	mov    $0x8027a8,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 40 27 80 00       	push   $0x802740
  8000e8:	e8 82 19 00 00       	call   801a6f <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 c2 17 00 00       	call   8018cb <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 c6 13 00 00       	call   8014ed <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 50 27 80 00       	push   $0x802750
  800166:	6a 1d                	push   $0x1d
  800168:	68 5c 27 80 00       	push   $0x80275c
  80016d:	e8 b6 01 00 00       	call   800328 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0c                	jg     800182 <lsdir+0x90>
	if (n < 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	78 1a                	js     800194 <lsdir+0xa2>
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("short read in directory %s", path);
  800182:	57                   	push   %edi
  800183:	68 66 27 80 00       	push   $0x802766
  800188:	6a 22                	push   $0x22
  80018a:	68 5c 27 80 00       	push   $0x80275c
  80018f:	e8 94 01 00 00       	call   800328 <_panic>
		panic("error reading directory %s: %e", path, n);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	57                   	push   %edi
  800199:	68 ac 27 80 00       	push   $0x8027ac
  80019e:	6a 24                	push   $0x24
  8001a0:	68 5c 27 80 00       	push   $0x80275c
  8001a5:	e8 7e 01 00 00       	call   800328 <_panic>

008001aa <ls>:
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	53                   	push   %ebx
  8001ae:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b7:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bd:	50                   	push   %eax
  8001be:	53                   	push   %ebx
  8001bf:	e8 0e 15 00 00       	call   8016d2 <stat>
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	78 2c                	js     8001f7 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	74 09                	je     8001db <ls+0x31>
  8001d2:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001d9:	74 32                	je     80020d <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001db:	53                   	push   %ebx
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	85 c0                	test   %eax,%eax
  8001e1:	0f 95 c0             	setne  %al
  8001e4:	0f b6 c0             	movzbl %al,%eax
  8001e7:	50                   	push   %eax
  8001e8:	6a 00                	push   $0x0
  8001ea:	e8 44 fe ff ff       	call   800033 <ls1>
  8001ef:	83 c4 10             	add    $0x10,%esp
}
  8001f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	50                   	push   %eax
  8001fb:	53                   	push   %ebx
  8001fc:	68 81 27 80 00       	push   $0x802781
  800201:	6a 0f                	push   $0xf
  800203:	68 5c 27 80 00       	push   $0x80275c
  800208:	e8 1b 01 00 00       	call   800328 <_panic>
		lsdir(path, prefix);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	53                   	push   %ebx
  800214:	e8 d9 fe ff ff       	call   8000f2 <lsdir>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb d4                	jmp    8001f2 <ls+0x48>

0080021e <usage>:

void
usage(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800224:	68 8d 27 80 00       	push   $0x80278d
  800229:	e8 41 18 00 00       	call   801a6f <printf>
	exit();
  80022e:	e8 db 00 00 00       	call   80030e <exit>
}
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	c9                   	leave  
  800237:	c3                   	ret    

00800238 <umain>:

void
umain(int argc, char **argv)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 14             	sub    $0x14,%esp
  800240:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800243:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800246:	50                   	push   %eax
  800247:	56                   	push   %esi
  800248:	8d 45 08             	lea    0x8(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 da 0d 00 00       	call   80102b <argstart>
	while ((i = argnext(&args)) >= 0)
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800257:	eb 08                	jmp    800261 <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800259:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  800260:	01 
	while ((i = argnext(&args)) >= 0)
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	53                   	push   %ebx
  800265:	e8 f1 0d 00 00       	call   80105b <argnext>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	85 c0                	test   %eax,%eax
  80026f:	78 16                	js     800287 <umain+0x4f>
		switch (i) {
  800271:	83 f8 64             	cmp    $0x64,%eax
  800274:	74 e3                	je     800259 <umain+0x21>
  800276:	83 f8 6c             	cmp    $0x6c,%eax
  800279:	74 de                	je     800259 <umain+0x21>
  80027b:	83 f8 46             	cmp    $0x46,%eax
  80027e:	74 d9                	je     800259 <umain+0x21>
			break;
		default:
			usage();
  800280:	e8 99 ff ff ff       	call   80021e <usage>
  800285:	eb da                	jmp    800261 <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800287:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800290:	75 2a                	jne    8002bc <umain+0x84>
		ls("/", "");
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 a8 27 80 00       	push   $0x8027a8
  80029a:	68 40 27 80 00       	push   $0x802740
  80029f:	e8 06 ff ff ff       	call   8001aa <ls>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	eb 18                	jmp    8002c1 <umain+0x89>
			ls(argv[i], argv[i]);
  8002a9:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	50                   	push   %eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 f4 fe ff ff       	call   8001aa <ls>
		for (i = 1; i < argc; i++)
  8002b6:	83 c3 01             	add    $0x1,%ebx
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bf:	7f e8                	jg     8002a9 <umain+0x71>
	}
}
  8002c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002d3:	e8 05 0b 00 00       	call   800ddd <sys_getenvid>
  8002d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ea:	85 db                	test   %ebx,%ebx
  8002ec:	7e 07                	jle    8002f5 <libmain+0x2d>
		binaryname = argv[0];
  8002ee:	8b 06                	mov    (%esi),%eax
  8002f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	e8 39 ff ff ff       	call   800238 <umain>

	// exit gracefully
	exit();
  8002ff:	e8 0a 00 00 00       	call   80030e <exit>
}
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <exit>:

#include <inc/lib.h>

void exit(void)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800314:	e8 3c 10 00 00       	call   801355 <close_all>
	sys_env_destroy(0);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	6a 00                	push   $0x0
  80031e:	e8 79 0a 00 00       	call   800d9c <sys_env_destroy>
}
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80032d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800330:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800336:	e8 a2 0a 00 00       	call   800ddd <sys_getenvid>
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	56                   	push   %esi
  800345:	50                   	push   %eax
  800346:	68 d8 27 80 00       	push   $0x8027d8
  80034b:	e8 b3 00 00 00       	call   800403 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	53                   	push   %ebx
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	e8 56 00 00 00       	call   8003b2 <vcprintf>
	cprintf("\n");
  80035c:	c7 04 24 a7 27 80 00 	movl   $0x8027a7,(%esp)
  800363:	e8 9b 00 00 00       	call   800403 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036b:	cc                   	int3   
  80036c:	eb fd                	jmp    80036b <_panic+0x43>

0080036e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	53                   	push   %ebx
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800378:	8b 13                	mov    (%ebx),%edx
  80037a:	8d 42 01             	lea    0x1(%edx),%eax
  80037d:	89 03                	mov    %eax,(%ebx)
  80037f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800382:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800386:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038b:	74 09                	je     800396 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80038d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800394:	c9                   	leave  
  800395:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	68 ff 00 00 00       	push   $0xff
  80039e:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a1:	50                   	push   %eax
  8003a2:	e8 b8 09 00 00       	call   800d5f <sys_cputs>
		b->idx = 0;
  8003a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb db                	jmp    80038d <putch+0x1f>

008003b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c2:	00 00 00 
	b.cnt = 0;
  8003c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003cc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	ff 75 08             	pushl  0x8(%ebp)
  8003d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003db:	50                   	push   %eax
  8003dc:	68 6e 03 80 00       	push   $0x80036e
  8003e1:	e8 1a 01 00 00       	call   800500 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e6:	83 c4 08             	add    $0x8,%esp
  8003e9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003ef:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f5:	50                   	push   %eax
  8003f6:	e8 64 09 00 00       	call   800d5f <sys_cputs>

	return b.cnt;
}
  8003fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800409:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 08             	pushl  0x8(%ebp)
  800410:	e8 9d ff ff ff       	call   8003b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	57                   	push   %edi
  80041b:	56                   	push   %esi
  80041c:	53                   	push   %ebx
  80041d:	83 ec 1c             	sub    $0x1c,%esp
  800420:	89 c7                	mov    %eax,%edi
  800422:	89 d6                	mov    %edx,%esi
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800433:	bb 00 00 00 00       	mov    $0x0,%ebx
  800438:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80043b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80043e:	39 d3                	cmp    %edx,%ebx
  800440:	72 05                	jb     800447 <printnum+0x30>
  800442:	39 45 10             	cmp    %eax,0x10(%ebp)
  800445:	77 7a                	ja     8004c1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	ff 75 18             	pushl  0x18(%ebp)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800453:	53                   	push   %ebx
  800454:	ff 75 10             	pushl  0x10(%ebp)
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80045d:	ff 75 e0             	pushl  -0x20(%ebp)
  800460:	ff 75 dc             	pushl  -0x24(%ebp)
  800463:	ff 75 d8             	pushl  -0x28(%ebp)
  800466:	e8 85 20 00 00       	call   8024f0 <__udivdi3>
  80046b:	83 c4 18             	add    $0x18,%esp
  80046e:	52                   	push   %edx
  80046f:	50                   	push   %eax
  800470:	89 f2                	mov    %esi,%edx
  800472:	89 f8                	mov    %edi,%eax
  800474:	e8 9e ff ff ff       	call   800417 <printnum>
  800479:	83 c4 20             	add    $0x20,%esp
  80047c:	eb 13                	jmp    800491 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	56                   	push   %esi
  800482:	ff 75 18             	pushl  0x18(%ebp)
  800485:	ff d7                	call   *%edi
  800487:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80048a:	83 eb 01             	sub    $0x1,%ebx
  80048d:	85 db                	test   %ebx,%ebx
  80048f:	7f ed                	jg     80047e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	56                   	push   %esi
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049b:	ff 75 e0             	pushl  -0x20(%ebp)
  80049e:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a4:	e8 67 21 00 00       	call   802610 <__umoddi3>
  8004a9:	83 c4 14             	add    $0x14,%esp
  8004ac:	0f be 80 fb 27 80 00 	movsbl 0x8027fb(%eax),%eax
  8004b3:	50                   	push   %eax
  8004b4:	ff d7                	call   *%edi
}
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bc:	5b                   	pop    %ebx
  8004bd:	5e                   	pop    %esi
  8004be:	5f                   	pop    %edi
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    
  8004c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004c4:	eb c4                	jmp    80048a <printnum+0x73>

008004c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d0:	8b 10                	mov    (%eax),%edx
  8004d2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d5:	73 0a                	jae    8004e1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004da:	89 08                	mov    %ecx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	88 02                	mov    %al,(%edx)
}
  8004e1:	5d                   	pop    %ebp
  8004e2:	c3                   	ret    

008004e3 <printfmt>:
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ec:	50                   	push   %eax
  8004ed:	ff 75 10             	pushl  0x10(%ebp)
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	ff 75 08             	pushl  0x8(%ebp)
  8004f6:	e8 05 00 00 00       	call   800500 <vprintfmt>
}
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <vprintfmt>:
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	57                   	push   %edi
  800504:	56                   	push   %esi
  800505:	53                   	push   %ebx
  800506:	83 ec 2c             	sub    $0x2c,%esp
  800509:	8b 75 08             	mov    0x8(%ebp),%esi
  80050c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800512:	e9 c1 03 00 00       	jmp    8008d8 <vprintfmt+0x3d8>
		padc = ' ';
  800517:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80051b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800522:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800529:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800530:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8d 47 01             	lea    0x1(%edi),%eax
  800538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053b:	0f b6 17             	movzbl (%edi),%edx
  80053e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800541:	3c 55                	cmp    $0x55,%al
  800543:	0f 87 12 04 00 00    	ja     80095b <vprintfmt+0x45b>
  800549:	0f b6 c0             	movzbl %al,%eax
  80054c:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800556:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80055a:	eb d9                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80055f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800563:	eb d0                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800565:	0f b6 d2             	movzbl %dl,%edx
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80056b:	b8 00 00 00 00       	mov    $0x0,%eax
  800570:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800573:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800576:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80057a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80057d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800580:	83 f9 09             	cmp    $0x9,%ecx
  800583:	77 55                	ja     8005da <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800585:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800588:	eb e9                	jmp    800573 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80059e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a2:	79 91                	jns    800535 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005b1:	eb 82                	jmp    800535 <vprintfmt+0x35>
  8005b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b6:	85 c0                	test   %eax,%eax
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bd:	0f 49 d0             	cmovns %eax,%edx
  8005c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c6:	e9 6a ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ce:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005d5:	e9 5b ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e0:	eb bc                	jmp    80059e <vprintfmt+0x9e>
			lflag++;
  8005e2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005e8:	e9 48 ff ff ff       	jmp    800535 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 78 04             	lea    0x4(%eax),%edi
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	ff 30                	pushl  (%eax)
  8005f9:	ff d6                	call   *%esi
			break;
  8005fb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005fe:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800601:	e9 cf 02 00 00       	jmp    8008d5 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 78 04             	lea    0x4(%eax),%edi
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	99                   	cltd   
  80060f:	31 d0                	xor    %edx,%eax
  800611:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800613:	83 f8 0f             	cmp    $0xf,%eax
  800616:	7f 23                	jg     80063b <vprintfmt+0x13b>
  800618:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  80061f:	85 d2                	test   %edx,%edx
  800621:	74 18                	je     80063b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800623:	52                   	push   %edx
  800624:	68 d9 2b 80 00       	push   $0x802bd9
  800629:	53                   	push   %ebx
  80062a:	56                   	push   %esi
  80062b:	e8 b3 fe ff ff       	call   8004e3 <printfmt>
  800630:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800633:	89 7d 14             	mov    %edi,0x14(%ebp)
  800636:	e9 9a 02 00 00       	jmp    8008d5 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80063b:	50                   	push   %eax
  80063c:	68 13 28 80 00       	push   $0x802813
  800641:	53                   	push   %ebx
  800642:	56                   	push   %esi
  800643:	e8 9b fe ff ff       	call   8004e3 <printfmt>
  800648:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80064b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80064e:	e9 82 02 00 00       	jmp    8008d5 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 c0 04             	add    $0x4,%eax
  800659:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800661:	85 ff                	test   %edi,%edi
  800663:	b8 0c 28 80 00       	mov    $0x80280c,%eax
  800668:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80066b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066f:	0f 8e bd 00 00 00    	jle    800732 <vprintfmt+0x232>
  800675:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800679:	75 0e                	jne    800689 <vprintfmt+0x189>
  80067b:	89 75 08             	mov    %esi,0x8(%ebp)
  80067e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800681:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800684:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800687:	eb 6d                	jmp    8006f6 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 d0             	pushl  -0x30(%ebp)
  80068f:	57                   	push   %edi
  800690:	e8 6e 03 00 00       	call   800a03 <strnlen>
  800695:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800698:	29 c1                	sub    %eax,%ecx
  80069a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80069d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006a0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006aa:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ac:	eb 0f                	jmp    8006bd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	53                   	push   %ebx
  8006b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b7:	83 ef 01             	sub    $0x1,%edi
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	85 ff                	test   %edi,%edi
  8006bf:	7f ed                	jg     8006ae <vprintfmt+0x1ae>
  8006c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006c4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006c7:	85 c9                	test   %ecx,%ecx
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	0f 49 c1             	cmovns %ecx,%eax
  8006d1:	29 c1                	sub    %eax,%ecx
  8006d3:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006dc:	89 cb                	mov    %ecx,%ebx
  8006de:	eb 16                	jmp    8006f6 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006e4:	75 31                	jne    800717 <vprintfmt+0x217>
					putch(ch, putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	ff 55 08             	call   *0x8(%ebp)
  8006f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f3:	83 eb 01             	sub    $0x1,%ebx
  8006f6:	83 c7 01             	add    $0x1,%edi
  8006f9:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006fd:	0f be c2             	movsbl %dl,%eax
  800700:	85 c0                	test   %eax,%eax
  800702:	74 59                	je     80075d <vprintfmt+0x25d>
  800704:	85 f6                	test   %esi,%esi
  800706:	78 d8                	js     8006e0 <vprintfmt+0x1e0>
  800708:	83 ee 01             	sub    $0x1,%esi
  80070b:	79 d3                	jns    8006e0 <vprintfmt+0x1e0>
  80070d:	89 df                	mov    %ebx,%edi
  80070f:	8b 75 08             	mov    0x8(%ebp),%esi
  800712:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800715:	eb 37                	jmp    80074e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800717:	0f be d2             	movsbl %dl,%edx
  80071a:	83 ea 20             	sub    $0x20,%edx
  80071d:	83 fa 5e             	cmp    $0x5e,%edx
  800720:	76 c4                	jbe    8006e6 <vprintfmt+0x1e6>
					putch('?', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 3f                	push   $0x3f
  80072a:	ff 55 08             	call   *0x8(%ebp)
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb c1                	jmp    8006f3 <vprintfmt+0x1f3>
  800732:	89 75 08             	mov    %esi,0x8(%ebp)
  800735:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800738:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80073b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80073e:	eb b6                	jmp    8006f6 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 20                	push   $0x20
  800746:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800748:	83 ef 01             	sub    $0x1,%edi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 ff                	test   %edi,%edi
  800750:	7f ee                	jg     800740 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800752:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
  800758:	e9 78 01 00 00       	jmp    8008d5 <vprintfmt+0x3d5>
  80075d:	89 df                	mov    %ebx,%edi
  80075f:	8b 75 08             	mov    0x8(%ebp),%esi
  800762:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800765:	eb e7                	jmp    80074e <vprintfmt+0x24e>
	if (lflag >= 2)
  800767:	83 f9 01             	cmp    $0x1,%ecx
  80076a:	7e 3f                	jle    8007ab <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 50 04             	mov    0x4(%eax),%edx
  800772:	8b 00                	mov    (%eax),%eax
  800774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800777:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 40 08             	lea    0x8(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800783:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800787:	79 5c                	jns    8007e5 <vprintfmt+0x2e5>
				putch('-', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 2d                	push   $0x2d
  80078f:	ff d6                	call   *%esi
				num = -(long long) num;
  800791:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800794:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800797:	f7 da                	neg    %edx
  800799:	83 d1 00             	adc    $0x0,%ecx
  80079c:	f7 d9                	neg    %ecx
  80079e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a6:	e9 10 01 00 00       	jmp    8008bb <vprintfmt+0x3bb>
	else if (lflag)
  8007ab:	85 c9                	test   %ecx,%ecx
  8007ad:	75 1b                	jne    8007ca <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 c1                	mov    %eax,%ecx
  8007b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c8:	eb b9                	jmp    800783 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 c1                	mov    %eax,%ecx
  8007d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	eb 9e                	jmp    800783 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f0:	e9 c6 00 00 00       	jmp    8008bb <vprintfmt+0x3bb>
	if (lflag >= 2)
  8007f5:	83 f9 01             	cmp    $0x1,%ecx
  8007f8:	7e 18                	jle    800812 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 10                	mov    (%eax),%edx
  8007ff:	8b 48 04             	mov    0x4(%eax),%ecx
  800802:	8d 40 08             	lea    0x8(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	e9 a9 00 00 00       	jmp    8008bb <vprintfmt+0x3bb>
	else if (lflag)
  800812:	85 c9                	test   %ecx,%ecx
  800814:	75 1a                	jne    800830 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 10                	mov    (%eax),%edx
  80081b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800820:	8d 40 04             	lea    0x4(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800826:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082b:	e9 8b 00 00 00       	jmp    8008bb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8b 10                	mov    (%eax),%edx
  800835:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083a:	8d 40 04             	lea    0x4(%eax),%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800840:	b8 0a 00 00 00       	mov    $0xa,%eax
  800845:	eb 74                	jmp    8008bb <vprintfmt+0x3bb>
	if (lflag >= 2)
  800847:	83 f9 01             	cmp    $0x1,%ecx
  80084a:	7e 15                	jle    800861 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 10                	mov    (%eax),%edx
  800851:	8b 48 04             	mov    0x4(%eax),%ecx
  800854:	8d 40 08             	lea    0x8(%eax),%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085a:	b8 08 00 00 00       	mov    $0x8,%eax
  80085f:	eb 5a                	jmp    8008bb <vprintfmt+0x3bb>
	else if (lflag)
  800861:	85 c9                	test   %ecx,%ecx
  800863:	75 17                	jne    80087c <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8b 10                	mov    (%eax),%edx
  80086a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800875:	b8 08 00 00 00       	mov    $0x8,%eax
  80087a:	eb 3f                	jmp    8008bb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 10                	mov    (%eax),%edx
  800881:	b9 00 00 00 00       	mov    $0x0,%ecx
  800886:	8d 40 04             	lea    0x4(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80088c:	b8 08 00 00 00       	mov    $0x8,%eax
  800891:	eb 28                	jmp    8008bb <vprintfmt+0x3bb>
			putch('0', putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	53                   	push   %ebx
  800897:	6a 30                	push   $0x30
  800899:	ff d6                	call   *%esi
			putch('x', putdat);
  80089b:	83 c4 08             	add    $0x8,%esp
  80089e:	53                   	push   %ebx
  80089f:	6a 78                	push   $0x78
  8008a1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8b 10                	mov    (%eax),%edx
  8008a8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008ad:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b0:	8d 40 04             	lea    0x4(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008c2:	57                   	push   %edi
  8008c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	51                   	push   %ecx
  8008c8:	52                   	push   %edx
  8008c9:	89 da                	mov    %ebx,%edx
  8008cb:	89 f0                	mov    %esi,%eax
  8008cd:	e8 45 fb ff ff       	call   800417 <printnum>
			break;
  8008d2:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d8:	83 c7 01             	add    $0x1,%edi
  8008db:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008df:	83 f8 25             	cmp    $0x25,%eax
  8008e2:	0f 84 2f fc ff ff    	je     800517 <vprintfmt+0x17>
			if (ch == '\0')
  8008e8:	85 c0                	test   %eax,%eax
  8008ea:	0f 84 8b 00 00 00    	je     80097b <vprintfmt+0x47b>
			putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	53                   	push   %ebx
  8008f4:	50                   	push   %eax
  8008f5:	ff d6                	call   *%esi
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	eb dc                	jmp    8008d8 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8008fc:	83 f9 01             	cmp    $0x1,%ecx
  8008ff:	7e 15                	jle    800916 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	8b 10                	mov    (%eax),%edx
  800906:	8b 48 04             	mov    0x4(%eax),%ecx
  800909:	8d 40 08             	lea    0x8(%eax),%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090f:	b8 10 00 00 00       	mov    $0x10,%eax
  800914:	eb a5                	jmp    8008bb <vprintfmt+0x3bb>
	else if (lflag)
  800916:	85 c9                	test   %ecx,%ecx
  800918:	75 17                	jne    800931 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 10                	mov    (%eax),%edx
  80091f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800924:	8d 40 04             	lea    0x4(%eax),%eax
  800927:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092a:	b8 10 00 00 00       	mov    $0x10,%eax
  80092f:	eb 8a                	jmp    8008bb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 10                	mov    (%eax),%edx
  800936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093b:	8d 40 04             	lea    0x4(%eax),%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800941:	b8 10 00 00 00       	mov    $0x10,%eax
  800946:	e9 70 ff ff ff       	jmp    8008bb <vprintfmt+0x3bb>
			putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	53                   	push   %ebx
  80094f:	6a 25                	push   $0x25
  800951:	ff d6                	call   *%esi
			break;
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	e9 7a ff ff ff       	jmp    8008d5 <vprintfmt+0x3d5>
			putch('%', putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	53                   	push   %ebx
  80095f:	6a 25                	push   $0x25
  800961:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	89 f8                	mov    %edi,%eax
  800968:	eb 03                	jmp    80096d <vprintfmt+0x46d>
  80096a:	83 e8 01             	sub    $0x1,%eax
  80096d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800971:	75 f7                	jne    80096a <vprintfmt+0x46a>
  800973:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800976:	e9 5a ff ff ff       	jmp    8008d5 <vprintfmt+0x3d5>
}
  80097b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80097e:	5b                   	pop    %ebx
  80097f:	5e                   	pop    %esi
  800980:	5f                   	pop    %edi
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800992:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800996:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800999:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a0:	85 c0                	test   %eax,%eax
  8009a2:	74 26                	je     8009ca <vsnprintf+0x47>
  8009a4:	85 d2                	test   %edx,%edx
  8009a6:	7e 22                	jle    8009ca <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a8:	ff 75 14             	pushl  0x14(%ebp)
  8009ab:	ff 75 10             	pushl  0x10(%ebp)
  8009ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b1:	50                   	push   %eax
  8009b2:	68 c6 04 80 00       	push   $0x8004c6
  8009b7:	e8 44 fb ff ff       	call   800500 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009bf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    
		return -E_INVAL;
  8009ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009cf:	eb f7                	jmp    8009c8 <vsnprintf+0x45>

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009da:	50                   	push   %eax
  8009db:	ff 75 10             	pushl  0x10(%ebp)
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	ff 75 08             	pushl  0x8(%ebp)
  8009e4:	e8 9a ff ff ff       	call   800983 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009e9:	c9                   	leave  
  8009ea:	c3                   	ret    

008009eb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f6:	eb 03                	jmp    8009fb <strlen+0x10>
		n++;
  8009f8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ff:	75 f7                	jne    8009f8 <strlen+0xd>
	return n;
}
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a09:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	eb 03                	jmp    800a16 <strnlen+0x13>
		n++;
  800a13:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a16:	39 d0                	cmp    %edx,%eax
  800a18:	74 06                	je     800a20 <strnlen+0x1d>
  800a1a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a1e:	75 f3                	jne    800a13 <strnlen+0x10>
	return n;
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	53                   	push   %ebx
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a2c:	89 c2                	mov    %eax,%edx
  800a2e:	83 c1 01             	add    $0x1,%ecx
  800a31:	83 c2 01             	add    $0x1,%edx
  800a34:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a38:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a3b:	84 db                	test   %bl,%bl
  800a3d:	75 ef                	jne    800a2e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a3f:	5b                   	pop    %ebx
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	53                   	push   %ebx
  800a46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a49:	53                   	push   %ebx
  800a4a:	e8 9c ff ff ff       	call   8009eb <strlen>
  800a4f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	01 d8                	add    %ebx,%eax
  800a57:	50                   	push   %eax
  800a58:	e8 c5 ff ff ff       	call   800a22 <strcpy>
	return dst;
}
  800a5d:	89 d8                	mov    %ebx,%eax
  800a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 75 08             	mov    0x8(%ebp),%esi
  800a6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6f:	89 f3                	mov    %esi,%ebx
  800a71:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a74:	89 f2                	mov    %esi,%edx
  800a76:	eb 0f                	jmp    800a87 <strncpy+0x23>
		*dst++ = *src;
  800a78:	83 c2 01             	add    $0x1,%edx
  800a7b:	0f b6 01             	movzbl (%ecx),%eax
  800a7e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a81:	80 39 01             	cmpb   $0x1,(%ecx)
  800a84:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a87:	39 da                	cmp    %ebx,%edx
  800a89:	75 ed                	jne    800a78 <strncpy+0x14>
	}
	return ret;
}
  800a8b:	89 f0                	mov    %esi,%eax
  800a8d:	5b                   	pop    %ebx
  800a8e:	5e                   	pop    %esi
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	8b 75 08             	mov    0x8(%ebp),%esi
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a9f:	89 f0                	mov    %esi,%eax
  800aa1:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aa5:	85 c9                	test   %ecx,%ecx
  800aa7:	75 0b                	jne    800ab4 <strlcpy+0x23>
  800aa9:	eb 17                	jmp    800ac2 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aab:	83 c2 01             	add    $0x1,%edx
  800aae:	83 c0 01             	add    $0x1,%eax
  800ab1:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ab4:	39 d8                	cmp    %ebx,%eax
  800ab6:	74 07                	je     800abf <strlcpy+0x2e>
  800ab8:	0f b6 0a             	movzbl (%edx),%ecx
  800abb:	84 c9                	test   %cl,%cl
  800abd:	75 ec                	jne    800aab <strlcpy+0x1a>
		*dst = '\0';
  800abf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac2:	29 f0                	sub    %esi,%eax
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ace:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ad1:	eb 06                	jmp    800ad9 <strcmp+0x11>
		p++, q++;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ad9:	0f b6 01             	movzbl (%ecx),%eax
  800adc:	84 c0                	test   %al,%al
  800ade:	74 04                	je     800ae4 <strcmp+0x1c>
  800ae0:	3a 02                	cmp    (%edx),%al
  800ae2:	74 ef                	je     800ad3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae4:	0f b6 c0             	movzbl %al,%eax
  800ae7:	0f b6 12             	movzbl (%edx),%edx
  800aea:	29 d0                	sub    %edx,%eax
}
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	53                   	push   %ebx
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af8:	89 c3                	mov    %eax,%ebx
  800afa:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800afd:	eb 06                	jmp    800b05 <strncmp+0x17>
		n--, p++, q++;
  800aff:	83 c0 01             	add    $0x1,%eax
  800b02:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b05:	39 d8                	cmp    %ebx,%eax
  800b07:	74 16                	je     800b1f <strncmp+0x31>
  800b09:	0f b6 08             	movzbl (%eax),%ecx
  800b0c:	84 c9                	test   %cl,%cl
  800b0e:	74 04                	je     800b14 <strncmp+0x26>
  800b10:	3a 0a                	cmp    (%edx),%cl
  800b12:	74 eb                	je     800aff <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b14:	0f b6 00             	movzbl (%eax),%eax
  800b17:	0f b6 12             	movzbl (%edx),%edx
  800b1a:	29 d0                	sub    %edx,%eax
}
  800b1c:	5b                   	pop    %ebx
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    
		return 0;
  800b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b24:	eb f6                	jmp    800b1c <strncmp+0x2e>

00800b26 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b30:	0f b6 10             	movzbl (%eax),%edx
  800b33:	84 d2                	test   %dl,%dl
  800b35:	74 09                	je     800b40 <strchr+0x1a>
		if (*s == c)
  800b37:	38 ca                	cmp    %cl,%dl
  800b39:	74 0a                	je     800b45 <strchr+0x1f>
	for (; *s; s++)
  800b3b:	83 c0 01             	add    $0x1,%eax
  800b3e:	eb f0                	jmp    800b30 <strchr+0xa>
			return (char *) s;
	return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b51:	eb 03                	jmp    800b56 <strfind+0xf>
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b59:	38 ca                	cmp    %cl,%dl
  800b5b:	74 04                	je     800b61 <strfind+0x1a>
  800b5d:	84 d2                	test   %dl,%dl
  800b5f:	75 f2                	jne    800b53 <strfind+0xc>
			break;
	return (char *) s;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b6f:	85 c9                	test   %ecx,%ecx
  800b71:	74 13                	je     800b86 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b73:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b79:	75 05                	jne    800b80 <memset+0x1d>
  800b7b:	f6 c1 03             	test   $0x3,%cl
  800b7e:	74 0d                	je     800b8d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	fc                   	cld    
  800b84:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b86:	89 f8                	mov    %edi,%eax
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    
		c &= 0xFF;
  800b8d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b91:	89 d3                	mov    %edx,%ebx
  800b93:	c1 e3 08             	shl    $0x8,%ebx
  800b96:	89 d0                	mov    %edx,%eax
  800b98:	c1 e0 18             	shl    $0x18,%eax
  800b9b:	89 d6                	mov    %edx,%esi
  800b9d:	c1 e6 10             	shl    $0x10,%esi
  800ba0:	09 f0                	or     %esi,%eax
  800ba2:	09 c2                	or     %eax,%edx
  800ba4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ba6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ba9:	89 d0                	mov    %edx,%eax
  800bab:	fc                   	cld    
  800bac:	f3 ab                	rep stos %eax,%es:(%edi)
  800bae:	eb d6                	jmp    800b86 <memset+0x23>

00800bb0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bbe:	39 c6                	cmp    %eax,%esi
  800bc0:	73 35                	jae    800bf7 <memmove+0x47>
  800bc2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bc5:	39 c2                	cmp    %eax,%edx
  800bc7:	76 2e                	jbe    800bf7 <memmove+0x47>
		s += n;
		d += n;
  800bc9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bcc:	89 d6                	mov    %edx,%esi
  800bce:	09 fe                	or     %edi,%esi
  800bd0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bd6:	74 0c                	je     800be4 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bd8:	83 ef 01             	sub    $0x1,%edi
  800bdb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bde:	fd                   	std    
  800bdf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be1:	fc                   	cld    
  800be2:	eb 21                	jmp    800c05 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be4:	f6 c1 03             	test   $0x3,%cl
  800be7:	75 ef                	jne    800bd8 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be9:	83 ef 04             	sub    $0x4,%edi
  800bec:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf2:	fd                   	std    
  800bf3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf5:	eb ea                	jmp    800be1 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf7:	89 f2                	mov    %esi,%edx
  800bf9:	09 c2                	or     %eax,%edx
  800bfb:	f6 c2 03             	test   $0x3,%dl
  800bfe:	74 09                	je     800c09 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c00:	89 c7                	mov    %eax,%edi
  800c02:	fc                   	cld    
  800c03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c09:	f6 c1 03             	test   $0x3,%cl
  800c0c:	75 f2                	jne    800c00 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c11:	89 c7                	mov    %eax,%edi
  800c13:	fc                   	cld    
  800c14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c16:	eb ed                	jmp    800c05 <memmove+0x55>

00800c18 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c1b:	ff 75 10             	pushl  0x10(%ebp)
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	ff 75 08             	pushl  0x8(%ebp)
  800c24:	e8 87 ff ff ff       	call   800bb0 <memmove>
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c36:	89 c6                	mov    %eax,%esi
  800c38:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3b:	39 f0                	cmp    %esi,%eax
  800c3d:	74 1c                	je     800c5b <memcmp+0x30>
		if (*s1 != *s2)
  800c3f:	0f b6 08             	movzbl (%eax),%ecx
  800c42:	0f b6 1a             	movzbl (%edx),%ebx
  800c45:	38 d9                	cmp    %bl,%cl
  800c47:	75 08                	jne    800c51 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c49:	83 c0 01             	add    $0x1,%eax
  800c4c:	83 c2 01             	add    $0x1,%edx
  800c4f:	eb ea                	jmp    800c3b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c51:	0f b6 c1             	movzbl %cl,%eax
  800c54:	0f b6 db             	movzbl %bl,%ebx
  800c57:	29 d8                	sub    %ebx,%eax
  800c59:	eb 05                	jmp    800c60 <memcmp+0x35>
	}

	return 0;
  800c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c6d:	89 c2                	mov    %eax,%edx
  800c6f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c72:	39 d0                	cmp    %edx,%eax
  800c74:	73 09                	jae    800c7f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c76:	38 08                	cmp    %cl,(%eax)
  800c78:	74 05                	je     800c7f <memfind+0x1b>
	for (; s < ends; s++)
  800c7a:	83 c0 01             	add    $0x1,%eax
  800c7d:	eb f3                	jmp    800c72 <memfind+0xe>
			break;
	return (void *) s;
}
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c8d:	eb 03                	jmp    800c92 <strtol+0x11>
		s++;
  800c8f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c92:	0f b6 01             	movzbl (%ecx),%eax
  800c95:	3c 20                	cmp    $0x20,%al
  800c97:	74 f6                	je     800c8f <strtol+0xe>
  800c99:	3c 09                	cmp    $0x9,%al
  800c9b:	74 f2                	je     800c8f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c9d:	3c 2b                	cmp    $0x2b,%al
  800c9f:	74 2e                	je     800ccf <strtol+0x4e>
	int neg = 0;
  800ca1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ca6:	3c 2d                	cmp    $0x2d,%al
  800ca8:	74 2f                	je     800cd9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800caa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb0:	75 05                	jne    800cb7 <strtol+0x36>
  800cb2:	80 39 30             	cmpb   $0x30,(%ecx)
  800cb5:	74 2c                	je     800ce3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cb7:	85 db                	test   %ebx,%ebx
  800cb9:	75 0a                	jne    800cc5 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cbb:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cc0:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc3:	74 28                	je     800ced <strtol+0x6c>
		base = 10;
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ccd:	eb 50                	jmp    800d1f <strtol+0x9e>
		s++;
  800ccf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd2:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd7:	eb d1                	jmp    800caa <strtol+0x29>
		s++, neg = 1;
  800cd9:	83 c1 01             	add    $0x1,%ecx
  800cdc:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce1:	eb c7                	jmp    800caa <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ce7:	74 0e                	je     800cf7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ce9:	85 db                	test   %ebx,%ebx
  800ceb:	75 d8                	jne    800cc5 <strtol+0x44>
		s++, base = 8;
  800ced:	83 c1 01             	add    $0x1,%ecx
  800cf0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cf5:	eb ce                	jmp    800cc5 <strtol+0x44>
		s += 2, base = 16;
  800cf7:	83 c1 02             	add    $0x2,%ecx
  800cfa:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cff:	eb c4                	jmp    800cc5 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d01:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d04:	89 f3                	mov    %esi,%ebx
  800d06:	80 fb 19             	cmp    $0x19,%bl
  800d09:	77 29                	ja     800d34 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d0b:	0f be d2             	movsbl %dl,%edx
  800d0e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d11:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d14:	7d 30                	jge    800d46 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d16:	83 c1 01             	add    $0x1,%ecx
  800d19:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d1d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d1f:	0f b6 11             	movzbl (%ecx),%edx
  800d22:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d25:	89 f3                	mov    %esi,%ebx
  800d27:	80 fb 09             	cmp    $0x9,%bl
  800d2a:	77 d5                	ja     800d01 <strtol+0x80>
			dig = *s - '0';
  800d2c:	0f be d2             	movsbl %dl,%edx
  800d2f:	83 ea 30             	sub    $0x30,%edx
  800d32:	eb dd                	jmp    800d11 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d34:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d37:	89 f3                	mov    %esi,%ebx
  800d39:	80 fb 19             	cmp    $0x19,%bl
  800d3c:	77 08                	ja     800d46 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d3e:	0f be d2             	movsbl %dl,%edx
  800d41:	83 ea 37             	sub    $0x37,%edx
  800d44:	eb cb                	jmp    800d11 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4a:	74 05                	je     800d51 <strtol+0xd0>
		*endptr = (char *) s;
  800d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d4f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d51:	89 c2                	mov    %eax,%edx
  800d53:	f7 da                	neg    %edx
  800d55:	85 ff                	test   %edi,%edi
  800d57:	0f 45 c2             	cmovne %edx,%eax
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	89 c3                	mov    %eax,%ebx
  800d72:	89 c7                	mov    %eax,%edi
  800d74:	89 c6                	mov    %eax,%esi
  800d76:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_cgetc>:

int
sys_cgetc(void)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d83:	ba 00 00 00 00       	mov    $0x0,%edx
  800d88:	b8 01 00 00 00       	mov    $0x1,%eax
  800d8d:	89 d1                	mov    %edx,%ecx
  800d8f:	89 d3                	mov    %edx,%ebx
  800d91:	89 d7                	mov    %edx,%edi
  800d93:	89 d6                	mov    %edx,%esi
  800d95:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	57                   	push   %edi
  800da0:	56                   	push   %esi
  800da1:	53                   	push   %ebx
  800da2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	b8 03 00 00 00       	mov    $0x3,%eax
  800db2:	89 cb                	mov    %ecx,%ebx
  800db4:	89 cf                	mov    %ecx,%edi
  800db6:	89 ce                	mov    %ecx,%esi
  800db8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	7f 08                	jg     800dc6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	50                   	push   %eax
  800dca:	6a 03                	push   $0x3
  800dcc:	68 ff 2a 80 00       	push   $0x802aff
  800dd1:	6a 23                	push   $0x23
  800dd3:	68 1c 2b 80 00       	push   $0x802b1c
  800dd8:	e8 4b f5 ff ff       	call   800328 <_panic>

00800ddd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de3:	ba 00 00 00 00       	mov    $0x0,%edx
  800de8:	b8 02 00 00 00       	mov    $0x2,%eax
  800ded:	89 d1                	mov    %edx,%ecx
  800def:	89 d3                	mov    %edx,%ebx
  800df1:	89 d7                	mov    %edx,%edi
  800df3:	89 d6                	mov    %edx,%esi
  800df5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <sys_yield>:

void
sys_yield(void)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e02:	ba 00 00 00 00       	mov    $0x0,%edx
  800e07:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e0c:	89 d1                	mov    %edx,%ecx
  800e0e:	89 d3                	mov    %edx,%ebx
  800e10:	89 d7                	mov    %edx,%edi
  800e12:	89 d6                	mov    %edx,%esi
  800e14:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e24:	be 00 00 00 00       	mov    $0x0,%esi
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2f:	b8 04 00 00 00       	mov    $0x4,%eax
  800e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e37:	89 f7                	mov    %esi,%edi
  800e39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	7f 08                	jg     800e47 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e47:	83 ec 0c             	sub    $0xc,%esp
  800e4a:	50                   	push   %eax
  800e4b:	6a 04                	push   $0x4
  800e4d:	68 ff 2a 80 00       	push   $0x802aff
  800e52:	6a 23                	push   $0x23
  800e54:	68 1c 2b 80 00       	push   $0x802b1c
  800e59:	e8 ca f4 ff ff       	call   800328 <_panic>

00800e5e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6d:	b8 05 00 00 00       	mov    $0x5,%eax
  800e72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e78:	8b 75 18             	mov    0x18(%ebp),%esi
  800e7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	7f 08                	jg     800e89 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e89:	83 ec 0c             	sub    $0xc,%esp
  800e8c:	50                   	push   %eax
  800e8d:	6a 05                	push   $0x5
  800e8f:	68 ff 2a 80 00       	push   $0x802aff
  800e94:	6a 23                	push   $0x23
  800e96:	68 1c 2b 80 00       	push   $0x802b1c
  800e9b:	e8 88 f4 ff ff       	call   800328 <_panic>

00800ea0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 06                	push   $0x6
  800ed1:	68 ff 2a 80 00       	push   $0x802aff
  800ed6:	6a 23                	push   $0x23
  800ed8:	68 1c 2b 80 00       	push   $0x802b1c
  800edd:	e8 46 f4 ff ff       	call   800328 <_panic>

00800ee2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	b8 08 00 00 00       	mov    $0x8,%eax
  800efb:	89 df                	mov    %ebx,%edi
  800efd:	89 de                	mov    %ebx,%esi
  800eff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	7f 08                	jg     800f0d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	50                   	push   %eax
  800f11:	6a 08                	push   $0x8
  800f13:	68 ff 2a 80 00       	push   $0x802aff
  800f18:	6a 23                	push   $0x23
  800f1a:	68 1c 2b 80 00       	push   $0x802b1c
  800f1f:	e8 04 f4 ff ff       	call   800328 <_panic>

00800f24 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 09 00 00 00       	mov    $0x9,%eax
  800f3d:	89 df                	mov    %ebx,%edi
  800f3f:	89 de                	mov    %ebx,%esi
  800f41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	7f 08                	jg     800f4f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	50                   	push   %eax
  800f53:	6a 09                	push   $0x9
  800f55:	68 ff 2a 80 00       	push   $0x802aff
  800f5a:	6a 23                	push   $0x23
  800f5c:	68 1c 2b 80 00       	push   $0x802b1c
  800f61:	e8 c2 f3 ff ff       	call   800328 <_panic>

00800f66 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
  800f6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	89 de                	mov    %ebx,%esi
  800f83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7f 08                	jg     800f91 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f91:	83 ec 0c             	sub    $0xc,%esp
  800f94:	50                   	push   %eax
  800f95:	6a 0a                	push   $0xa
  800f97:	68 ff 2a 80 00       	push   $0x802aff
  800f9c:	6a 23                	push   $0x23
  800f9e:	68 1c 2b 80 00       	push   $0x802b1c
  800fa3:	e8 80 f3 ff ff       	call   800328 <_panic>

00800fa8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fb9:	be 00 00 00 00       	mov    $0x0,%esi
  800fbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7f 08                	jg     800ff5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	6a 0d                	push   $0xd
  800ffb:	68 ff 2a 80 00       	push   $0x802aff
  801000:	6a 23                	push   $0x23
  801002:	68 1c 2b 80 00       	push   $0x802b1c
  801007:	e8 1c f3 ff ff       	call   800328 <_panic>

0080100c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
	asm volatile("int %1\n"
  801012:	ba 00 00 00 00       	mov    $0x0,%edx
  801017:	b8 0e 00 00 00       	mov    $0xe,%eax
  80101c:	89 d1                	mov    %edx,%ecx
  80101e:	89 d3                	mov    %edx,%ebx
  801020:	89 d7                	mov    %edx,%edi
  801022:	89 d6                	mov    %edx,%esi
  801024:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801037:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801039:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80103c:	83 3a 01             	cmpl   $0x1,(%edx)
  80103f:	7e 09                	jle    80104a <argstart+0x1f>
  801041:	ba a8 27 80 00       	mov    $0x8027a8,%edx
  801046:	85 c9                	test   %ecx,%ecx
  801048:	75 05                	jne    80104f <argstart+0x24>
  80104a:	ba 00 00 00 00       	mov    $0x0,%edx
  80104f:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801052:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <argnext>:

int
argnext(struct Argstate *args)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	53                   	push   %ebx
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801065:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80106c:	8b 43 08             	mov    0x8(%ebx),%eax
  80106f:	85 c0                	test   %eax,%eax
  801071:	74 72                	je     8010e5 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801073:	80 38 00             	cmpb   $0x0,(%eax)
  801076:	75 48                	jne    8010c0 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801078:	8b 0b                	mov    (%ebx),%ecx
  80107a:	83 39 01             	cmpl   $0x1,(%ecx)
  80107d:	74 58                	je     8010d7 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  80107f:	8b 53 04             	mov    0x4(%ebx),%edx
  801082:	8b 42 04             	mov    0x4(%edx),%eax
  801085:	80 38 2d             	cmpb   $0x2d,(%eax)
  801088:	75 4d                	jne    8010d7 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  80108a:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80108e:	74 47                	je     8010d7 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801090:	83 c0 01             	add    $0x1,%eax
  801093:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801096:	83 ec 04             	sub    $0x4,%esp
  801099:	8b 01                	mov    (%ecx),%eax
  80109b:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010a2:	50                   	push   %eax
  8010a3:	8d 42 08             	lea    0x8(%edx),%eax
  8010a6:	50                   	push   %eax
  8010a7:	83 c2 04             	add    $0x4,%edx
  8010aa:	52                   	push   %edx
  8010ab:	e8 00 fb ff ff       	call   800bb0 <memmove>
		(*args->argc)--;
  8010b0:	8b 03                	mov    (%ebx),%eax
  8010b2:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010b5:	8b 43 08             	mov    0x8(%ebx),%eax
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010be:	74 11                	je     8010d1 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8010c0:	8b 53 08             	mov    0x8(%ebx),%edx
  8010c3:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8010c6:	83 c2 01             	add    $0x1,%edx
  8010c9:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8010cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010d1:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010d5:	75 e9                	jne    8010c0 <argnext+0x65>
	args->curarg = 0;
  8010d7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8010de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010e3:	eb e7                	jmp    8010cc <argnext+0x71>
		return -1;
  8010e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010ea:	eb e0                	jmp    8010cc <argnext+0x71>

008010ec <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8010f6:	8b 43 08             	mov    0x8(%ebx),%eax
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	74 5b                	je     801158 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  8010fd:	80 38 00             	cmpb   $0x0,(%eax)
  801100:	74 12                	je     801114 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801102:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801105:	c7 43 08 a8 27 80 00 	movl   $0x8027a8,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80110c:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80110f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801112:	c9                   	leave  
  801113:	c3                   	ret    
	} else if (*args->argc > 1) {
  801114:	8b 13                	mov    (%ebx),%edx
  801116:	83 3a 01             	cmpl   $0x1,(%edx)
  801119:	7f 10                	jg     80112b <argnextvalue+0x3f>
		args->argvalue = 0;
  80111b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801122:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801129:	eb e1                	jmp    80110c <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  80112b:	8b 43 04             	mov    0x4(%ebx),%eax
  80112e:	8b 48 04             	mov    0x4(%eax),%ecx
  801131:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801134:	83 ec 04             	sub    $0x4,%esp
  801137:	8b 12                	mov    (%edx),%edx
  801139:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801140:	52                   	push   %edx
  801141:	8d 50 08             	lea    0x8(%eax),%edx
  801144:	52                   	push   %edx
  801145:	83 c0 04             	add    $0x4,%eax
  801148:	50                   	push   %eax
  801149:	e8 62 fa ff ff       	call   800bb0 <memmove>
		(*args->argc)--;
  80114e:	8b 03                	mov    (%ebx),%eax
  801150:	83 28 01             	subl   $0x1,(%eax)
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	eb b4                	jmp    80110c <argnextvalue+0x20>
		return 0;
  801158:	b8 00 00 00 00       	mov    $0x0,%eax
  80115d:	eb b0                	jmp    80110f <argnextvalue+0x23>

0080115f <argvalue>:
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801168:	8b 42 0c             	mov    0xc(%edx),%eax
  80116b:	85 c0                	test   %eax,%eax
  80116d:	74 02                	je     801171 <argvalue+0x12>
}
  80116f:	c9                   	leave  
  801170:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801171:	83 ec 0c             	sub    $0xc,%esp
  801174:	52                   	push   %edx
  801175:	e8 72 ff ff ff       	call   8010ec <argnextvalue>
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	eb f0                	jmp    80116f <argvalue+0x10>

0080117f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	05 00 00 00 30       	add    $0x30000000,%eax
  80118a:	c1 e8 0c             	shr    $0xc,%eax
}
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80119a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ac:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011b1:	89 c2                	mov    %eax,%edx
  8011b3:	c1 ea 16             	shr    $0x16,%edx
  8011b6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011bd:	f6 c2 01             	test   $0x1,%dl
  8011c0:	74 2a                	je     8011ec <fd_alloc+0x46>
  8011c2:	89 c2                	mov    %eax,%edx
  8011c4:	c1 ea 0c             	shr    $0xc,%edx
  8011c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ce:	f6 c2 01             	test   $0x1,%dl
  8011d1:	74 19                	je     8011ec <fd_alloc+0x46>
  8011d3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011d8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011dd:	75 d2                	jne    8011b1 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011df:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011e5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011ea:	eb 07                	jmp    8011f3 <fd_alloc+0x4d>
			*fd_store = fd;
  8011ec:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011fb:	83 f8 1f             	cmp    $0x1f,%eax
  8011fe:	77 36                	ja     801236 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801200:	c1 e0 0c             	shl    $0xc,%eax
  801203:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801208:	89 c2                	mov    %eax,%edx
  80120a:	c1 ea 16             	shr    $0x16,%edx
  80120d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801214:	f6 c2 01             	test   $0x1,%dl
  801217:	74 24                	je     80123d <fd_lookup+0x48>
  801219:	89 c2                	mov    %eax,%edx
  80121b:	c1 ea 0c             	shr    $0xc,%edx
  80121e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801225:	f6 c2 01             	test   $0x1,%dl
  801228:	74 1a                	je     801244 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80122a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122d:	89 02                	mov    %eax,(%edx)
	return 0;
  80122f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    
		return -E_INVAL;
  801236:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123b:	eb f7                	jmp    801234 <fd_lookup+0x3f>
		return -E_INVAL;
  80123d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801242:	eb f0                	jmp    801234 <fd_lookup+0x3f>
  801244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801249:	eb e9                	jmp    801234 <fd_lookup+0x3f>

0080124b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801254:	ba ac 2b 80 00       	mov    $0x802bac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801259:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80125e:	39 08                	cmp    %ecx,(%eax)
  801260:	74 33                	je     801295 <dev_lookup+0x4a>
  801262:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801265:	8b 02                	mov    (%edx),%eax
  801267:	85 c0                	test   %eax,%eax
  801269:	75 f3                	jne    80125e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80126b:	a1 20 44 80 00       	mov    0x804420,%eax
  801270:	8b 40 48             	mov    0x48(%eax),%eax
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	51                   	push   %ecx
  801277:	50                   	push   %eax
  801278:	68 2c 2b 80 00       	push   $0x802b2c
  80127d:	e8 81 f1 ff ff       	call   800403 <cprintf>
	*dev = 0;
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    
			*dev = devtab[i];
  801295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801298:	89 01                	mov    %eax,(%ecx)
			return 0;
  80129a:	b8 00 00 00 00       	mov    $0x0,%eax
  80129f:	eb f2                	jmp    801293 <dev_lookup+0x48>

008012a1 <fd_close>:
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 1c             	sub    $0x1c,%esp
  8012aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012ba:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bd:	50                   	push   %eax
  8012be:	e8 32 ff ff ff       	call   8011f5 <fd_lookup>
  8012c3:	89 c3                	mov    %eax,%ebx
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	78 05                	js     8012d1 <fd_close+0x30>
	    || fd != fd2)
  8012cc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012cf:	74 16                	je     8012e7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012d1:	89 f8                	mov    %edi,%eax
  8012d3:	84 c0                	test   %al,%al
  8012d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012da:	0f 44 d8             	cmove  %eax,%ebx
}
  8012dd:	89 d8                	mov    %ebx,%eax
  8012df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	ff 36                	pushl  (%esi)
  8012f0:	e8 56 ff ff ff       	call   80124b <dev_lookup>
  8012f5:	89 c3                	mov    %eax,%ebx
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 15                	js     801313 <fd_close+0x72>
		if (dev->dev_close)
  8012fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801301:	8b 40 10             	mov    0x10(%eax),%eax
  801304:	85 c0                	test   %eax,%eax
  801306:	74 1b                	je     801323 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	56                   	push   %esi
  80130c:	ff d0                	call   *%eax
  80130e:	89 c3                	mov    %eax,%ebx
  801310:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801313:	83 ec 08             	sub    $0x8,%esp
  801316:	56                   	push   %esi
  801317:	6a 00                	push   $0x0
  801319:	e8 82 fb ff ff       	call   800ea0 <sys_page_unmap>
	return r;
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	eb ba                	jmp    8012dd <fd_close+0x3c>
			r = 0;
  801323:	bb 00 00 00 00       	mov    $0x0,%ebx
  801328:	eb e9                	jmp    801313 <fd_close+0x72>

0080132a <close>:

int
close(int fdnum)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801333:	50                   	push   %eax
  801334:	ff 75 08             	pushl  0x8(%ebp)
  801337:	e8 b9 fe ff ff       	call   8011f5 <fd_lookup>
  80133c:	83 c4 08             	add    $0x8,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 10                	js     801353 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	6a 01                	push   $0x1
  801348:	ff 75 f4             	pushl  -0xc(%ebp)
  80134b:	e8 51 ff ff ff       	call   8012a1 <fd_close>
  801350:	83 c4 10             	add    $0x10,%esp
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <close_all>:

void
close_all(void)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	53                   	push   %ebx
  801359:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80135c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801361:	83 ec 0c             	sub    $0xc,%esp
  801364:	53                   	push   %ebx
  801365:	e8 c0 ff ff ff       	call   80132a <close>
	for (i = 0; i < MAXFD; i++)
  80136a:	83 c3 01             	add    $0x1,%ebx
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	83 fb 20             	cmp    $0x20,%ebx
  801373:	75 ec                	jne    801361 <close_all+0xc>
}
  801375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	57                   	push   %edi
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
  801380:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801383:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801386:	50                   	push   %eax
  801387:	ff 75 08             	pushl  0x8(%ebp)
  80138a:	e8 66 fe ff ff       	call   8011f5 <fd_lookup>
  80138f:	89 c3                	mov    %eax,%ebx
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	0f 88 81 00 00 00    	js     80141d <dup+0xa3>
		return r;
	close(newfdnum);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 0c             	pushl  0xc(%ebp)
  8013a2:	e8 83 ff ff ff       	call   80132a <close>

	newfd = INDEX2FD(newfdnum);
  8013a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013aa:	c1 e6 0c             	shl    $0xc,%esi
  8013ad:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013b3:	83 c4 04             	add    $0x4,%esp
  8013b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013b9:	e8 d1 fd ff ff       	call   80118f <fd2data>
  8013be:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013c0:	89 34 24             	mov    %esi,(%esp)
  8013c3:	e8 c7 fd ff ff       	call   80118f <fd2data>
  8013c8:	83 c4 10             	add    $0x10,%esp
  8013cb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013cd:	89 d8                	mov    %ebx,%eax
  8013cf:	c1 e8 16             	shr    $0x16,%eax
  8013d2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013d9:	a8 01                	test   $0x1,%al
  8013db:	74 11                	je     8013ee <dup+0x74>
  8013dd:	89 d8                	mov    %ebx,%eax
  8013df:	c1 e8 0c             	shr    $0xc,%eax
  8013e2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013e9:	f6 c2 01             	test   $0x1,%dl
  8013ec:	75 39                	jne    801427 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f1:	89 d0                	mov    %edx,%eax
  8013f3:	c1 e8 0c             	shr    $0xc,%eax
  8013f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013fd:	83 ec 0c             	sub    $0xc,%esp
  801400:	25 07 0e 00 00       	and    $0xe07,%eax
  801405:	50                   	push   %eax
  801406:	56                   	push   %esi
  801407:	6a 00                	push   $0x0
  801409:	52                   	push   %edx
  80140a:	6a 00                	push   $0x0
  80140c:	e8 4d fa ff ff       	call   800e5e <sys_page_map>
  801411:	89 c3                	mov    %eax,%ebx
  801413:	83 c4 20             	add    $0x20,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	78 31                	js     80144b <dup+0xd1>
		goto err;

	return newfdnum;
  80141a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80141d:	89 d8                	mov    %ebx,%eax
  80141f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801427:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80142e:	83 ec 0c             	sub    $0xc,%esp
  801431:	25 07 0e 00 00       	and    $0xe07,%eax
  801436:	50                   	push   %eax
  801437:	57                   	push   %edi
  801438:	6a 00                	push   $0x0
  80143a:	53                   	push   %ebx
  80143b:	6a 00                	push   $0x0
  80143d:	e8 1c fa ff ff       	call   800e5e <sys_page_map>
  801442:	89 c3                	mov    %eax,%ebx
  801444:	83 c4 20             	add    $0x20,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	79 a3                	jns    8013ee <dup+0x74>
	sys_page_unmap(0, newfd);
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	56                   	push   %esi
  80144f:	6a 00                	push   $0x0
  801451:	e8 4a fa ff ff       	call   800ea0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801456:	83 c4 08             	add    $0x8,%esp
  801459:	57                   	push   %edi
  80145a:	6a 00                	push   $0x0
  80145c:	e8 3f fa ff ff       	call   800ea0 <sys_page_unmap>
	return r;
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	eb b7                	jmp    80141d <dup+0xa3>

00801466 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	53                   	push   %ebx
  80146a:	83 ec 14             	sub    $0x14,%esp
  80146d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801470:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	53                   	push   %ebx
  801475:	e8 7b fd ff ff       	call   8011f5 <fd_lookup>
  80147a:	83 c4 08             	add    $0x8,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 3f                	js     8014c0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801487:	50                   	push   %eax
  801488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148b:	ff 30                	pushl  (%eax)
  80148d:	e8 b9 fd ff ff       	call   80124b <dev_lookup>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 27                	js     8014c0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80149c:	8b 42 08             	mov    0x8(%edx),%eax
  80149f:	83 e0 03             	and    $0x3,%eax
  8014a2:	83 f8 01             	cmp    $0x1,%eax
  8014a5:	74 1e                	je     8014c5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014aa:	8b 40 08             	mov    0x8(%eax),%eax
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	74 35                	je     8014e6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	ff 75 10             	pushl  0x10(%ebp)
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	52                   	push   %edx
  8014bb:	ff d0                	call   *%eax
  8014bd:	83 c4 10             	add    $0x10,%esp
}
  8014c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c5:	a1 20 44 80 00       	mov    0x804420,%eax
  8014ca:	8b 40 48             	mov    0x48(%eax),%eax
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	53                   	push   %ebx
  8014d1:	50                   	push   %eax
  8014d2:	68 70 2b 80 00       	push   $0x802b70
  8014d7:	e8 27 ef ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e4:	eb da                	jmp    8014c0 <read+0x5a>
		return -E_NOT_SUPP;
  8014e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014eb:	eb d3                	jmp    8014c0 <read+0x5a>

008014ed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	57                   	push   %edi
  8014f1:	56                   	push   %esi
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 0c             	sub    $0xc,%esp
  8014f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801501:	39 f3                	cmp    %esi,%ebx
  801503:	73 25                	jae    80152a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	89 f0                	mov    %esi,%eax
  80150a:	29 d8                	sub    %ebx,%eax
  80150c:	50                   	push   %eax
  80150d:	89 d8                	mov    %ebx,%eax
  80150f:	03 45 0c             	add    0xc(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	57                   	push   %edi
  801514:	e8 4d ff ff ff       	call   801466 <read>
		if (m < 0)
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 08                	js     801528 <readn+0x3b>
			return m;
		if (m == 0)
  801520:	85 c0                	test   %eax,%eax
  801522:	74 06                	je     80152a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801524:	01 c3                	add    %eax,%ebx
  801526:	eb d9                	jmp    801501 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801528:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80152a:	89 d8                	mov    %ebx,%eax
  80152c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152f:	5b                   	pop    %ebx
  801530:	5e                   	pop    %esi
  801531:	5f                   	pop    %edi
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	53                   	push   %ebx
  801538:	83 ec 14             	sub    $0x14,%esp
  80153b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801541:	50                   	push   %eax
  801542:	53                   	push   %ebx
  801543:	e8 ad fc ff ff       	call   8011f5 <fd_lookup>
  801548:	83 c4 08             	add    $0x8,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 3a                	js     801589 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801559:	ff 30                	pushl  (%eax)
  80155b:	e8 eb fc ff ff       	call   80124b <dev_lookup>
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	78 22                	js     801589 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80156e:	74 1e                	je     80158e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801573:	8b 52 0c             	mov    0xc(%edx),%edx
  801576:	85 d2                	test   %edx,%edx
  801578:	74 35                	je     8015af <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	ff 75 10             	pushl  0x10(%ebp)
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	50                   	push   %eax
  801584:	ff d2                	call   *%edx
  801586:	83 c4 10             	add    $0x10,%esp
}
  801589:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80158e:	a1 20 44 80 00       	mov    0x804420,%eax
  801593:	8b 40 48             	mov    0x48(%eax),%eax
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	53                   	push   %ebx
  80159a:	50                   	push   %eax
  80159b:	68 8c 2b 80 00       	push   $0x802b8c
  8015a0:	e8 5e ee ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ad:	eb da                	jmp    801589 <write+0x55>
		return -E_NOT_SUPP;
  8015af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b4:	eb d3                	jmp    801589 <write+0x55>

008015b6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015bc:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015bf:	50                   	push   %eax
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 2d fc ff ff       	call   8011f5 <fd_lookup>
  8015c8:	83 c4 08             	add    $0x8,%esp
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	78 0e                	js     8015dd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 14             	sub    $0x14,%esp
  8015e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ec:	50                   	push   %eax
  8015ed:	53                   	push   %ebx
  8015ee:	e8 02 fc ff ff       	call   8011f5 <fd_lookup>
  8015f3:	83 c4 08             	add    $0x8,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 37                	js     801631 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801604:	ff 30                	pushl  (%eax)
  801606:	e8 40 fc ff ff       	call   80124b <dev_lookup>
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 1f                	js     801631 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801619:	74 1b                	je     801636 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80161b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161e:	8b 52 18             	mov    0x18(%edx),%edx
  801621:	85 d2                	test   %edx,%edx
  801623:	74 32                	je     801657 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	ff 75 0c             	pushl  0xc(%ebp)
  80162b:	50                   	push   %eax
  80162c:	ff d2                	call   *%edx
  80162e:	83 c4 10             	add    $0x10,%esp
}
  801631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801634:	c9                   	leave  
  801635:	c3                   	ret    
			thisenv->env_id, fdnum);
  801636:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80163b:	8b 40 48             	mov    0x48(%eax),%eax
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	53                   	push   %ebx
  801642:	50                   	push   %eax
  801643:	68 4c 2b 80 00       	push   $0x802b4c
  801648:	e8 b6 ed ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801655:	eb da                	jmp    801631 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801657:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165c:	eb d3                	jmp    801631 <ftruncate+0x52>

0080165e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	53                   	push   %ebx
  801662:	83 ec 14             	sub    $0x14,%esp
  801665:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801668:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 81 fb ff ff       	call   8011f5 <fd_lookup>
  801674:	83 c4 08             	add    $0x8,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 4b                	js     8016c6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801681:	50                   	push   %eax
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801685:	ff 30                	pushl  (%eax)
  801687:	e8 bf fb ff ff       	call   80124b <dev_lookup>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 33                	js     8016c6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801696:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80169a:	74 2f                	je     8016cb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a6:	00 00 00 
	stat->st_isdir = 0;
  8016a9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b0:	00 00 00 
	stat->st_dev = dev;
  8016b3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	53                   	push   %ebx
  8016bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c0:	ff 50 14             	call   *0x14(%eax)
  8016c3:	83 c4 10             	add    $0x10,%esp
}
  8016c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    
		return -E_NOT_SUPP;
  8016cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d0:	eb f4                	jmp    8016c6 <fstat+0x68>

008016d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d7:	83 ec 08             	sub    $0x8,%esp
  8016da:	6a 00                	push   $0x0
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	e8 e7 01 00 00       	call   8018cb <open>
  8016e4:	89 c3                	mov    %eax,%ebx
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 1b                	js     801708 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016ed:	83 ec 08             	sub    $0x8,%esp
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	50                   	push   %eax
  8016f4:	e8 65 ff ff ff       	call   80165e <fstat>
  8016f9:	89 c6                	mov    %eax,%esi
	close(fd);
  8016fb:	89 1c 24             	mov    %ebx,(%esp)
  8016fe:	e8 27 fc ff ff       	call   80132a <close>
	return r;
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	89 f3                	mov    %esi,%ebx
}
  801708:	89 d8                	mov    %ebx,%eax
  80170a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5e                   	pop    %esi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    

00801711 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
  801716:	89 c6                	mov    %eax,%esi
  801718:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801721:	74 27                	je     80174a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801723:	6a 07                	push   $0x7
  801725:	68 00 50 80 00       	push   $0x805000
  80172a:	56                   	push   %esi
  80172b:	ff 35 00 40 80 00    	pushl  0x804000
  801731:	e8 e5 0c 00 00       	call   80241b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801736:	83 c4 0c             	add    $0xc,%esp
  801739:	6a 00                	push   $0x0
  80173b:	53                   	push   %ebx
  80173c:	6a 00                	push   $0x0
  80173e:	e8 71 0c 00 00       	call   8023b4 <ipc_recv>
}
  801743:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	6a 01                	push   $0x1
  80174f:	e8 1b 0d 00 00       	call   80246f <ipc_find_env>
  801754:	a3 00 40 80 00       	mov    %eax,0x804000
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	eb c5                	jmp    801723 <fsipc+0x12>

0080175e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8b 40 0c             	mov    0xc(%eax),%eax
  80176a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801772:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	b8 02 00 00 00       	mov    $0x2,%eax
  801781:	e8 8b ff ff ff       	call   801711 <fsipc>
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <devfile_flush>:
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8b 40 0c             	mov    0xc(%eax),%eax
  801794:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801799:	ba 00 00 00 00       	mov    $0x0,%edx
  80179e:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a3:	e8 69 ff ff ff       	call   801711 <fsipc>
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <devfile_stat>:
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ba:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c4:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c9:	e8 43 ff ff ff       	call   801711 <fsipc>
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	78 2c                	js     8017fe <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d2:	83 ec 08             	sub    $0x8,%esp
  8017d5:	68 00 50 80 00       	push   $0x805000
  8017da:	53                   	push   %ebx
  8017db:	e8 42 f2 ff ff       	call   800a22 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e0:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017eb:	a1 84 50 80 00       	mov    0x805084,%eax
  8017f0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <devfile_write>:
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	8b 45 10             	mov    0x10(%ebp),%eax
  80180c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801811:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801816:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801819:	8b 55 08             	mov    0x8(%ebp),%edx
  80181c:	8b 52 0c             	mov    0xc(%edx),%edx
  80181f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801825:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80182a:	50                   	push   %eax
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	68 08 50 80 00       	push   $0x805008
  801833:	e8 78 f3 ff ff       	call   800bb0 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801838:	ba 00 00 00 00       	mov    $0x0,%edx
  80183d:	b8 04 00 00 00       	mov    $0x4,%eax
  801842:	e8 ca fe ff ff       	call   801711 <fsipc>
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <devfile_read>:
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	56                   	push   %esi
  80184d:	53                   	push   %ebx
  80184e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	8b 40 0c             	mov    0xc(%eax),%eax
  801857:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80185c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801862:	ba 00 00 00 00       	mov    $0x0,%edx
  801867:	b8 03 00 00 00       	mov    $0x3,%eax
  80186c:	e8 a0 fe ff ff       	call   801711 <fsipc>
  801871:	89 c3                	mov    %eax,%ebx
  801873:	85 c0                	test   %eax,%eax
  801875:	78 1f                	js     801896 <devfile_read+0x4d>
	assert(r <= n);
  801877:	39 f0                	cmp    %esi,%eax
  801879:	77 24                	ja     80189f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80187b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801880:	7f 33                	jg     8018b5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	50                   	push   %eax
  801886:	68 00 50 80 00       	push   $0x805000
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	e8 1d f3 ff ff       	call   800bb0 <memmove>
	return r;
  801893:	83 c4 10             	add    $0x10,%esp
}
  801896:	89 d8                	mov    %ebx,%eax
  801898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5e                   	pop    %esi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
	assert(r <= n);
  80189f:	68 c0 2b 80 00       	push   $0x802bc0
  8018a4:	68 c7 2b 80 00       	push   $0x802bc7
  8018a9:	6a 7b                	push   $0x7b
  8018ab:	68 dc 2b 80 00       	push   $0x802bdc
  8018b0:	e8 73 ea ff ff       	call   800328 <_panic>
	assert(r <= PGSIZE);
  8018b5:	68 e7 2b 80 00       	push   $0x802be7
  8018ba:	68 c7 2b 80 00       	push   $0x802bc7
  8018bf:	6a 7c                	push   $0x7c
  8018c1:	68 dc 2b 80 00       	push   $0x802bdc
  8018c6:	e8 5d ea ff ff       	call   800328 <_panic>

008018cb <open>:
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	56                   	push   %esi
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 1c             	sub    $0x1c,%esp
  8018d3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018d6:	56                   	push   %esi
  8018d7:	e8 0f f1 ff ff       	call   8009eb <strlen>
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018e4:	7f 6c                	jg     801952 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ec:	50                   	push   %eax
  8018ed:	e8 b4 f8 ff ff       	call   8011a6 <fd_alloc>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 3c                	js     801937 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018fb:	83 ec 08             	sub    $0x8,%esp
  8018fe:	56                   	push   %esi
  8018ff:	68 00 50 80 00       	push   $0x805000
  801904:	e8 19 f1 ff ff       	call   800a22 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801911:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801914:	b8 01 00 00 00       	mov    $0x1,%eax
  801919:	e8 f3 fd ff ff       	call   801711 <fsipc>
  80191e:	89 c3                	mov    %eax,%ebx
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	85 c0                	test   %eax,%eax
  801925:	78 19                	js     801940 <open+0x75>
	return fd2num(fd);
  801927:	83 ec 0c             	sub    $0xc,%esp
  80192a:	ff 75 f4             	pushl  -0xc(%ebp)
  80192d:	e8 4d f8 ff ff       	call   80117f <fd2num>
  801932:	89 c3                	mov    %eax,%ebx
  801934:	83 c4 10             	add    $0x10,%esp
}
  801937:	89 d8                	mov    %ebx,%eax
  801939:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    
		fd_close(fd, 0);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	6a 00                	push   $0x0
  801945:	ff 75 f4             	pushl  -0xc(%ebp)
  801948:	e8 54 f9 ff ff       	call   8012a1 <fd_close>
		return r;
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	eb e5                	jmp    801937 <open+0x6c>
		return -E_BAD_PATH;
  801952:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801957:	eb de                	jmp    801937 <open+0x6c>

00801959 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80195f:	ba 00 00 00 00       	mov    $0x0,%edx
  801964:	b8 08 00 00 00       	mov    $0x8,%eax
  801969:	e8 a3 fd ff ff       	call   801711 <fsipc>
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801970:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801974:	7e 38                	jle    8019ae <writebuf+0x3e>
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	53                   	push   %ebx
  80197a:	83 ec 08             	sub    $0x8,%esp
  80197d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80197f:	ff 70 04             	pushl  0x4(%eax)
  801982:	8d 40 10             	lea    0x10(%eax),%eax
  801985:	50                   	push   %eax
  801986:	ff 33                	pushl  (%ebx)
  801988:	e8 a7 fb ff ff       	call   801534 <write>
		if (result > 0)
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	85 c0                	test   %eax,%eax
  801992:	7e 03                	jle    801997 <writebuf+0x27>
			b->result += result;
  801994:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801997:	39 43 04             	cmp    %eax,0x4(%ebx)
  80199a:	74 0d                	je     8019a9 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80199c:	85 c0                	test   %eax,%eax
  80199e:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a3:	0f 4f c2             	cmovg  %edx,%eax
  8019a6:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    
  8019ae:	f3 c3                	repz ret 

008019b0 <putch>:

static void
putch(int ch, void *thunk)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019ba:	8b 53 04             	mov    0x4(%ebx),%edx
  8019bd:	8d 42 01             	lea    0x1(%edx),%eax
  8019c0:	89 43 04             	mov    %eax,0x4(%ebx)
  8019c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c6:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019ca:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019cf:	74 06                	je     8019d7 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019d1:	83 c4 04             	add    $0x4,%esp
  8019d4:	5b                   	pop    %ebx
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    
		writebuf(b);
  8019d7:	89 d8                	mov    %ebx,%eax
  8019d9:	e8 92 ff ff ff       	call   801970 <writebuf>
		b->idx = 0;
  8019de:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019e5:	eb ea                	jmp    8019d1 <putch+0x21>

008019e7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019f9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a00:	00 00 00 
	b.result = 0;
  801a03:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a0a:	00 00 00 
	b.error = 1;
  801a0d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a14:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a17:	ff 75 10             	pushl  0x10(%ebp)
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a23:	50                   	push   %eax
  801a24:	68 b0 19 80 00       	push   $0x8019b0
  801a29:	e8 d2 ea ff ff       	call   800500 <vprintfmt>
	if (b.idx > 0)
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a38:	7f 11                	jg     801a4b <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a3a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a40:	85 c0                	test   %eax,%eax
  801a42:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    
		writebuf(&b);
  801a4b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a51:	e8 1a ff ff ff       	call   801970 <writebuf>
  801a56:	eb e2                	jmp    801a3a <vfprintf+0x53>

00801a58 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a5e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	ff 75 08             	pushl  0x8(%ebp)
  801a68:	e8 7a ff ff ff       	call   8019e7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <printf>:

int
printf(const char *fmt, ...)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a75:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a78:	50                   	push   %eax
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	6a 01                	push   $0x1
  801a7e:	e8 64 ff ff ff       	call   8019e7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a8b:	68 f3 2b 80 00       	push   $0x802bf3
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 8a ef ff ff       	call   800a22 <strcpy>
	return 0;
}
  801a98:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <devsock_close>:
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	53                   	push   %ebx
  801aa3:	83 ec 10             	sub    $0x10,%esp
  801aa6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801aa9:	53                   	push   %ebx
  801aaa:	e8 f9 09 00 00       	call   8024a8 <pageref>
  801aaf:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ab2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ab7:	83 f8 01             	cmp    $0x1,%eax
  801aba:	74 07                	je     801ac3 <devsock_close+0x24>
}
  801abc:	89 d0                	mov    %edx,%eax
  801abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	ff 73 0c             	pushl  0xc(%ebx)
  801ac9:	e8 b7 02 00 00       	call   801d85 <nsipc_close>
  801ace:	89 c2                	mov    %eax,%edx
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	eb e7                	jmp    801abc <devsock_close+0x1d>

00801ad5 <devsock_write>:
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801adb:	6a 00                	push   $0x0
  801add:	ff 75 10             	pushl  0x10(%ebp)
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	ff 70 0c             	pushl  0xc(%eax)
  801ae9:	e8 74 03 00 00       	call   801e62 <nsipc_send>
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <devsock_read>:
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	ff 75 10             	pushl  0x10(%ebp)
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	ff 70 0c             	pushl  0xc(%eax)
  801b04:	e8 ed 02 00 00       	call   801df6 <nsipc_recv>
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <fd2sockid>:
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b11:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	e8 da f6 ff ff       	call   8011f5 <fd_lookup>
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 10                	js     801b32 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b25:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b2b:	39 08                	cmp    %ecx,(%eax)
  801b2d:	75 05                	jne    801b34 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b2f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    
		return -E_NOT_SUPP;
  801b34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b39:	eb f7                	jmp    801b32 <fd2sockid+0x27>

00801b3b <alloc_sockfd>:
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	56                   	push   %esi
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 1c             	sub    $0x1c,%esp
  801b43:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b48:	50                   	push   %eax
  801b49:	e8 58 f6 ff ff       	call   8011a6 <fd_alloc>
  801b4e:	89 c3                	mov    %eax,%ebx
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 43                	js     801b9a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	68 07 04 00 00       	push   $0x407
  801b5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b62:	6a 00                	push   $0x0
  801b64:	e8 b2 f2 ff ff       	call   800e1b <sys_page_alloc>
  801b69:	89 c3                	mov    %eax,%ebx
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	78 28                	js     801b9a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b75:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b7b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b80:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b87:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b8a:	83 ec 0c             	sub    $0xc,%esp
  801b8d:	50                   	push   %eax
  801b8e:	e8 ec f5 ff ff       	call   80117f <fd2num>
  801b93:	89 c3                	mov    %eax,%ebx
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	eb 0c                	jmp    801ba6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b9a:	83 ec 0c             	sub    $0xc,%esp
  801b9d:	56                   	push   %esi
  801b9e:	e8 e2 01 00 00       	call   801d85 <nsipc_close>
		return r;
  801ba3:	83 c4 10             	add    $0x10,%esp
}
  801ba6:	89 d8                	mov    %ebx,%eax
  801ba8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5d                   	pop    %ebp
  801bae:	c3                   	ret    

00801baf <accept>:
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	e8 4e ff ff ff       	call   801b0b <fd2sockid>
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 1b                	js     801bdc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	ff 75 10             	pushl  0x10(%ebp)
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	50                   	push   %eax
  801bcb:	e8 0e 01 00 00       	call   801cde <nsipc_accept>
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 05                	js     801bdc <accept+0x2d>
	return alloc_sockfd(r);
  801bd7:	e8 5f ff ff ff       	call   801b3b <alloc_sockfd>
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <bind>:
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	e8 1f ff ff ff       	call   801b0b <fd2sockid>
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 12                	js     801c02 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	ff 75 10             	pushl  0x10(%ebp)
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	50                   	push   %eax
  801bfa:	e8 2f 01 00 00       	call   801d2e <nsipc_bind>
  801bff:	83 c4 10             	add    $0x10,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <shutdown>:
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	e8 f9 fe ff ff       	call   801b0b <fd2sockid>
  801c12:	85 c0                	test   %eax,%eax
  801c14:	78 0f                	js     801c25 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c16:	83 ec 08             	sub    $0x8,%esp
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	50                   	push   %eax
  801c1d:	e8 41 01 00 00       	call   801d63 <nsipc_shutdown>
  801c22:	83 c4 10             	add    $0x10,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <connect>:
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	e8 d6 fe ff ff       	call   801b0b <fd2sockid>
  801c35:	85 c0                	test   %eax,%eax
  801c37:	78 12                	js     801c4b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	ff 75 10             	pushl  0x10(%ebp)
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	50                   	push   %eax
  801c43:	e8 57 01 00 00       	call   801d9f <nsipc_connect>
  801c48:	83 c4 10             	add    $0x10,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <listen>:
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	e8 b0 fe ff ff       	call   801b0b <fd2sockid>
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 0f                	js     801c6e <listen+0x21>
	return nsipc_listen(r, backlog);
  801c5f:	83 ec 08             	sub    $0x8,%esp
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	50                   	push   %eax
  801c66:	e8 69 01 00 00       	call   801dd4 <nsipc_listen>
  801c6b:	83 c4 10             	add    $0x10,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c76:	ff 75 10             	pushl  0x10(%ebp)
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	ff 75 08             	pushl  0x8(%ebp)
  801c7f:	e8 3c 02 00 00       	call   801ec0 <nsipc_socket>
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	85 c0                	test   %eax,%eax
  801c89:	78 05                	js     801c90 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c8b:	e8 ab fe ff ff       	call   801b3b <alloc_sockfd>
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	53                   	push   %ebx
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c9b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ca2:	74 26                	je     801cca <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ca4:	6a 07                	push   $0x7
  801ca6:	68 00 60 80 00       	push   $0x806000
  801cab:	53                   	push   %ebx
  801cac:	ff 35 04 40 80 00    	pushl  0x804004
  801cb2:	e8 64 07 00 00       	call   80241b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cb7:	83 c4 0c             	add    $0xc,%esp
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	e8 ef 06 00 00       	call   8023b4 <ipc_recv>
}
  801cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	6a 02                	push   $0x2
  801ccf:	e8 9b 07 00 00       	call   80246f <ipc_find_env>
  801cd4:	a3 04 40 80 00       	mov    %eax,0x804004
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	eb c6                	jmp    801ca4 <nsipc+0x12>

00801cde <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	56                   	push   %esi
  801ce2:	53                   	push   %ebx
  801ce3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cee:	8b 06                	mov    (%esi),%eax
  801cf0:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfa:	e8 93 ff ff ff       	call   801c92 <nsipc>
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	85 c0                	test   %eax,%eax
  801d03:	78 20                	js     801d25 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	ff 35 10 60 80 00    	pushl  0x806010
  801d0e:	68 00 60 80 00       	push   $0x806000
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	e8 95 ee ff ff       	call   800bb0 <memmove>
		*addrlen = ret->ret_addrlen;
  801d1b:	a1 10 60 80 00       	mov    0x806010,%eax
  801d20:	89 06                	mov    %eax,(%esi)
  801d22:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801d25:	89 d8                	mov    %ebx,%eax
  801d27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2a:	5b                   	pop    %ebx
  801d2b:	5e                   	pop    %esi
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	53                   	push   %ebx
  801d32:	83 ec 08             	sub    $0x8,%esp
  801d35:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d40:	53                   	push   %ebx
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	68 04 60 80 00       	push   $0x806004
  801d49:	e8 62 ee ff ff       	call   800bb0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d4e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d54:	b8 02 00 00 00       	mov    $0x2,%eax
  801d59:	e8 34 ff ff ff       	call   801c92 <nsipc>
}
  801d5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d74:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d79:	b8 03 00 00 00       	mov    $0x3,%eax
  801d7e:	e8 0f ff ff ff       	call   801c92 <nsipc>
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <nsipc_close>:

int
nsipc_close(int s)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d93:	b8 04 00 00 00       	mov    $0x4,%eax
  801d98:	e8 f5 fe ff ff       	call   801c92 <nsipc>
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	53                   	push   %ebx
  801da3:	83 ec 08             	sub    $0x8,%esp
  801da6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801db1:	53                   	push   %ebx
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	68 04 60 80 00       	push   $0x806004
  801dba:	e8 f1 ed ff ff       	call   800bb0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dbf:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dc5:	b8 05 00 00 00       	mov    $0x5,%eax
  801dca:	e8 c3 fe ff ff       	call   801c92 <nsipc>
}
  801dcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dea:	b8 06 00 00 00       	mov    $0x6,%eax
  801def:	e8 9e fe ff ff       	call   801c92 <nsipc>
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	56                   	push   %esi
  801dfa:	53                   	push   %ebx
  801dfb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e06:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0f:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e14:	b8 07 00 00 00       	mov    $0x7,%eax
  801e19:	e8 74 fe ff ff       	call   801c92 <nsipc>
  801e1e:	89 c3                	mov    %eax,%ebx
  801e20:	85 c0                	test   %eax,%eax
  801e22:	78 1f                	js     801e43 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e24:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e29:	7f 21                	jg     801e4c <nsipc_recv+0x56>
  801e2b:	39 c6                	cmp    %eax,%esi
  801e2d:	7c 1d                	jl     801e4c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	50                   	push   %eax
  801e33:	68 00 60 80 00       	push   $0x806000
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	e8 70 ed ff ff       	call   800bb0 <memmove>
  801e40:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e43:	89 d8                	mov    %ebx,%eax
  801e45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5e                   	pop    %esi
  801e4a:	5d                   	pop    %ebp
  801e4b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e4c:	68 ff 2b 80 00       	push   $0x802bff
  801e51:	68 c7 2b 80 00       	push   $0x802bc7
  801e56:	6a 62                	push   $0x62
  801e58:	68 14 2c 80 00       	push   $0x802c14
  801e5d:	e8 c6 e4 ff ff       	call   800328 <_panic>

00801e62 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	53                   	push   %ebx
  801e66:	83 ec 04             	sub    $0x4,%esp
  801e69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e74:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e7a:	7f 2e                	jg     801eaa <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	53                   	push   %ebx
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	68 0c 60 80 00       	push   $0x80600c
  801e88:	e8 23 ed ff ff       	call   800bb0 <memmove>
	nsipcbuf.send.req_size = size;
  801e8d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e93:	8b 45 14             	mov    0x14(%ebp),%eax
  801e96:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e9b:	b8 08 00 00 00       	mov    $0x8,%eax
  801ea0:	e8 ed fd ff ff       	call   801c92 <nsipc>
}
  801ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    
	assert(size < 1600);
  801eaa:	68 20 2c 80 00       	push   $0x802c20
  801eaf:	68 c7 2b 80 00       	push   $0x802bc7
  801eb4:	6a 6d                	push   $0x6d
  801eb6:	68 14 2c 80 00       	push   $0x802c14
  801ebb:	e8 68 e4 ff ff       	call   800328 <_panic>

00801ec0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ede:	b8 09 00 00 00       	mov    $0x9,%eax
  801ee3:	e8 aa fd ff ff       	call   801c92 <nsipc>
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	56                   	push   %esi
  801eee:	53                   	push   %ebx
  801eef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ef2:	83 ec 0c             	sub    $0xc,%esp
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	e8 92 f2 ff ff       	call   80118f <fd2data>
  801efd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801eff:	83 c4 08             	add    $0x8,%esp
  801f02:	68 2c 2c 80 00       	push   $0x802c2c
  801f07:	53                   	push   %ebx
  801f08:	e8 15 eb ff ff       	call   800a22 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f0d:	8b 46 04             	mov    0x4(%esi),%eax
  801f10:	2b 06                	sub    (%esi),%eax
  801f12:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f18:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f1f:	00 00 00 
	stat->st_dev = &devpipe;
  801f22:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f29:	30 80 00 
	return 0;
}
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f34:	5b                   	pop    %ebx
  801f35:	5e                   	pop    %esi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    

00801f38 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	53                   	push   %ebx
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f42:	53                   	push   %ebx
  801f43:	6a 00                	push   $0x0
  801f45:	e8 56 ef ff ff       	call   800ea0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f4a:	89 1c 24             	mov    %ebx,(%esp)
  801f4d:	e8 3d f2 ff ff       	call   80118f <fd2data>
  801f52:	83 c4 08             	add    $0x8,%esp
  801f55:	50                   	push   %eax
  801f56:	6a 00                	push   $0x0
  801f58:	e8 43 ef ff ff       	call   800ea0 <sys_page_unmap>
}
  801f5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <_pipeisclosed>:
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	57                   	push   %edi
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	83 ec 1c             	sub    $0x1c,%esp
  801f6b:	89 c7                	mov    %eax,%edi
  801f6d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f6f:	a1 20 44 80 00       	mov    0x804420,%eax
  801f74:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	57                   	push   %edi
  801f7b:	e8 28 05 00 00       	call   8024a8 <pageref>
  801f80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f83:	89 34 24             	mov    %esi,(%esp)
  801f86:	e8 1d 05 00 00       	call   8024a8 <pageref>
		nn = thisenv->env_runs;
  801f8b:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801f91:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	39 cb                	cmp    %ecx,%ebx
  801f99:	74 1b                	je     801fb6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f9b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f9e:	75 cf                	jne    801f6f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fa0:	8b 42 58             	mov    0x58(%edx),%eax
  801fa3:	6a 01                	push   $0x1
  801fa5:	50                   	push   %eax
  801fa6:	53                   	push   %ebx
  801fa7:	68 33 2c 80 00       	push   $0x802c33
  801fac:	e8 52 e4 ff ff       	call   800403 <cprintf>
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	eb b9                	jmp    801f6f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fb6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb9:	0f 94 c0             	sete   %al
  801fbc:	0f b6 c0             	movzbl %al,%eax
}
  801fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5f                   	pop    %edi
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <devpipe_write>:
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	57                   	push   %edi
  801fcb:	56                   	push   %esi
  801fcc:	53                   	push   %ebx
  801fcd:	83 ec 28             	sub    $0x28,%esp
  801fd0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fd3:	56                   	push   %esi
  801fd4:	e8 b6 f1 ff ff       	call   80118f <fd2data>
  801fd9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fe6:	74 4f                	je     802037 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fe8:	8b 43 04             	mov    0x4(%ebx),%eax
  801feb:	8b 0b                	mov    (%ebx),%ecx
  801fed:	8d 51 20             	lea    0x20(%ecx),%edx
  801ff0:	39 d0                	cmp    %edx,%eax
  801ff2:	72 14                	jb     802008 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ff4:	89 da                	mov    %ebx,%edx
  801ff6:	89 f0                	mov    %esi,%eax
  801ff8:	e8 65 ff ff ff       	call   801f62 <_pipeisclosed>
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	75 3a                	jne    80203b <devpipe_write+0x74>
			sys_yield();
  802001:	e8 f6 ed ff ff       	call   800dfc <sys_yield>
  802006:	eb e0                	jmp    801fe8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802008:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80200b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80200f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802012:	89 c2                	mov    %eax,%edx
  802014:	c1 fa 1f             	sar    $0x1f,%edx
  802017:	89 d1                	mov    %edx,%ecx
  802019:	c1 e9 1b             	shr    $0x1b,%ecx
  80201c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80201f:	83 e2 1f             	and    $0x1f,%edx
  802022:	29 ca                	sub    %ecx,%edx
  802024:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802028:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80202c:	83 c0 01             	add    $0x1,%eax
  80202f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802032:	83 c7 01             	add    $0x1,%edi
  802035:	eb ac                	jmp    801fe3 <devpipe_write+0x1c>
	return i;
  802037:	89 f8                	mov    %edi,%eax
  802039:	eb 05                	jmp    802040 <devpipe_write+0x79>
				return 0;
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802040:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802043:	5b                   	pop    %ebx
  802044:	5e                   	pop    %esi
  802045:	5f                   	pop    %edi
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    

00802048 <devpipe_read>:
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	57                   	push   %edi
  80204c:	56                   	push   %esi
  80204d:	53                   	push   %ebx
  80204e:	83 ec 18             	sub    $0x18,%esp
  802051:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802054:	57                   	push   %edi
  802055:	e8 35 f1 ff ff       	call   80118f <fd2data>
  80205a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	be 00 00 00 00       	mov    $0x0,%esi
  802064:	3b 75 10             	cmp    0x10(%ebp),%esi
  802067:	74 47                	je     8020b0 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802069:	8b 03                	mov    (%ebx),%eax
  80206b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80206e:	75 22                	jne    802092 <devpipe_read+0x4a>
			if (i > 0)
  802070:	85 f6                	test   %esi,%esi
  802072:	75 14                	jne    802088 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802074:	89 da                	mov    %ebx,%edx
  802076:	89 f8                	mov    %edi,%eax
  802078:	e8 e5 fe ff ff       	call   801f62 <_pipeisclosed>
  80207d:	85 c0                	test   %eax,%eax
  80207f:	75 33                	jne    8020b4 <devpipe_read+0x6c>
			sys_yield();
  802081:	e8 76 ed ff ff       	call   800dfc <sys_yield>
  802086:	eb e1                	jmp    802069 <devpipe_read+0x21>
				return i;
  802088:	89 f0                	mov    %esi,%eax
}
  80208a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80208d:	5b                   	pop    %ebx
  80208e:	5e                   	pop    %esi
  80208f:	5f                   	pop    %edi
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802092:	99                   	cltd   
  802093:	c1 ea 1b             	shr    $0x1b,%edx
  802096:	01 d0                	add    %edx,%eax
  802098:	83 e0 1f             	and    $0x1f,%eax
  80209b:	29 d0                	sub    %edx,%eax
  80209d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020a8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020ab:	83 c6 01             	add    $0x1,%esi
  8020ae:	eb b4                	jmp    802064 <devpipe_read+0x1c>
	return i;
  8020b0:	89 f0                	mov    %esi,%eax
  8020b2:	eb d6                	jmp    80208a <devpipe_read+0x42>
				return 0;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	eb cf                	jmp    80208a <devpipe_read+0x42>

008020bb <pipe>:
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	56                   	push   %esi
  8020bf:	53                   	push   %ebx
  8020c0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c6:	50                   	push   %eax
  8020c7:	e8 da f0 ff ff       	call   8011a6 <fd_alloc>
  8020cc:	89 c3                	mov    %eax,%ebx
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 5b                	js     802130 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	68 07 04 00 00       	push   $0x407
  8020dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e0:	6a 00                	push   $0x0
  8020e2:	e8 34 ed ff ff       	call   800e1b <sys_page_alloc>
  8020e7:	89 c3                	mov    %eax,%ebx
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 40                	js     802130 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8020f0:	83 ec 0c             	sub    $0xc,%esp
  8020f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020f6:	50                   	push   %eax
  8020f7:	e8 aa f0 ff ff       	call   8011a6 <fd_alloc>
  8020fc:	89 c3                	mov    %eax,%ebx
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	85 c0                	test   %eax,%eax
  802103:	78 1b                	js     802120 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	68 07 04 00 00       	push   $0x407
  80210d:	ff 75 f0             	pushl  -0x10(%ebp)
  802110:	6a 00                	push   $0x0
  802112:	e8 04 ed ff ff       	call   800e1b <sys_page_alloc>
  802117:	89 c3                	mov    %eax,%ebx
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	79 19                	jns    802139 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802120:	83 ec 08             	sub    $0x8,%esp
  802123:	ff 75 f4             	pushl  -0xc(%ebp)
  802126:	6a 00                	push   $0x0
  802128:	e8 73 ed ff ff       	call   800ea0 <sys_page_unmap>
  80212d:	83 c4 10             	add    $0x10,%esp
}
  802130:	89 d8                	mov    %ebx,%eax
  802132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    
	va = fd2data(fd0);
  802139:	83 ec 0c             	sub    $0xc,%esp
  80213c:	ff 75 f4             	pushl  -0xc(%ebp)
  80213f:	e8 4b f0 ff ff       	call   80118f <fd2data>
  802144:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802146:	83 c4 0c             	add    $0xc,%esp
  802149:	68 07 04 00 00       	push   $0x407
  80214e:	50                   	push   %eax
  80214f:	6a 00                	push   $0x0
  802151:	e8 c5 ec ff ff       	call   800e1b <sys_page_alloc>
  802156:	89 c3                	mov    %eax,%ebx
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	85 c0                	test   %eax,%eax
  80215d:	0f 88 8c 00 00 00    	js     8021ef <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802163:	83 ec 0c             	sub    $0xc,%esp
  802166:	ff 75 f0             	pushl  -0x10(%ebp)
  802169:	e8 21 f0 ff ff       	call   80118f <fd2data>
  80216e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802175:	50                   	push   %eax
  802176:	6a 00                	push   $0x0
  802178:	56                   	push   %esi
  802179:	6a 00                	push   $0x0
  80217b:	e8 de ec ff ff       	call   800e5e <sys_page_map>
  802180:	89 c3                	mov    %eax,%ebx
  802182:	83 c4 20             	add    $0x20,%esp
  802185:	85 c0                	test   %eax,%eax
  802187:	78 58                	js     8021e1 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802192:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80219e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021a7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021b3:	83 ec 0c             	sub    $0xc,%esp
  8021b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021b9:	e8 c1 ef ff ff       	call   80117f <fd2num>
  8021be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021c1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021c3:	83 c4 04             	add    $0x4,%esp
  8021c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8021c9:	e8 b1 ef ff ff       	call   80117f <fd2num>
  8021ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021dc:	e9 4f ff ff ff       	jmp    802130 <pipe+0x75>
	sys_page_unmap(0, va);
  8021e1:	83 ec 08             	sub    $0x8,%esp
  8021e4:	56                   	push   %esi
  8021e5:	6a 00                	push   $0x0
  8021e7:	e8 b4 ec ff ff       	call   800ea0 <sys_page_unmap>
  8021ec:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021ef:	83 ec 08             	sub    $0x8,%esp
  8021f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f5:	6a 00                	push   $0x0
  8021f7:	e8 a4 ec ff ff       	call   800ea0 <sys_page_unmap>
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	e9 1c ff ff ff       	jmp    802120 <pipe+0x65>

00802204 <pipeisclosed>:
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80220a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220d:	50                   	push   %eax
  80220e:	ff 75 08             	pushl  0x8(%ebp)
  802211:	e8 df ef ff ff       	call   8011f5 <fd_lookup>
  802216:	83 c4 10             	add    $0x10,%esp
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 18                	js     802235 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80221d:	83 ec 0c             	sub    $0xc,%esp
  802220:	ff 75 f4             	pushl  -0xc(%ebp)
  802223:	e8 67 ef ff ff       	call   80118f <fd2data>
	return _pipeisclosed(fd, p);
  802228:	89 c2                	mov    %eax,%edx
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	e8 30 fd ff ff       	call   801f62 <_pipeisclosed>
  802232:	83 c4 10             	add    $0x10,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802247:	68 4b 2c 80 00       	push   $0x802c4b
  80224c:	ff 75 0c             	pushl  0xc(%ebp)
  80224f:	e8 ce e7 ff ff       	call   800a22 <strcpy>
	return 0;
}
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <devcons_write>:
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	57                   	push   %edi
  80225f:	56                   	push   %esi
  802260:	53                   	push   %ebx
  802261:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802267:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80226c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802272:	eb 2f                	jmp    8022a3 <devcons_write+0x48>
		m = n - tot;
  802274:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802277:	29 f3                	sub    %esi,%ebx
  802279:	83 fb 7f             	cmp    $0x7f,%ebx
  80227c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802281:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	53                   	push   %ebx
  802288:	89 f0                	mov    %esi,%eax
  80228a:	03 45 0c             	add    0xc(%ebp),%eax
  80228d:	50                   	push   %eax
  80228e:	57                   	push   %edi
  80228f:	e8 1c e9 ff ff       	call   800bb0 <memmove>
		sys_cputs(buf, m);
  802294:	83 c4 08             	add    $0x8,%esp
  802297:	53                   	push   %ebx
  802298:	57                   	push   %edi
  802299:	e8 c1 ea ff ff       	call   800d5f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80229e:	01 de                	add    %ebx,%esi
  8022a0:	83 c4 10             	add    $0x10,%esp
  8022a3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022a6:	72 cc                	jb     802274 <devcons_write+0x19>
}
  8022a8:	89 f0                	mov    %esi,%eax
  8022aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ad:	5b                   	pop    %ebx
  8022ae:	5e                   	pop    %esi
  8022af:	5f                   	pop    %edi
  8022b0:	5d                   	pop    %ebp
  8022b1:	c3                   	ret    

008022b2 <devcons_read>:
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	83 ec 08             	sub    $0x8,%esp
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022c1:	75 07                	jne    8022ca <devcons_read+0x18>
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    
		sys_yield();
  8022c5:	e8 32 eb ff ff       	call   800dfc <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8022ca:	e8 ae ea ff ff       	call   800d7d <sys_cgetc>
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	74 f2                	je     8022c5 <devcons_read+0x13>
	if (c < 0)
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	78 ec                	js     8022c3 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8022d7:	83 f8 04             	cmp    $0x4,%eax
  8022da:	74 0c                	je     8022e8 <devcons_read+0x36>
	*(char*)vbuf = c;
  8022dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022df:	88 02                	mov    %al,(%edx)
	return 1;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e6:	eb db                	jmp    8022c3 <devcons_read+0x11>
		return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ed:	eb d4                	jmp    8022c3 <devcons_read+0x11>

008022ef <cputchar>:
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022fb:	6a 01                	push   $0x1
  8022fd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802300:	50                   	push   %eax
  802301:	e8 59 ea ff ff       	call   800d5f <sys_cputs>
}
  802306:	83 c4 10             	add    $0x10,%esp
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <getchar>:
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802311:	6a 01                	push   $0x1
  802313:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802316:	50                   	push   %eax
  802317:	6a 00                	push   $0x0
  802319:	e8 48 f1 ff ff       	call   801466 <read>
	if (r < 0)
  80231e:	83 c4 10             	add    $0x10,%esp
  802321:	85 c0                	test   %eax,%eax
  802323:	78 08                	js     80232d <getchar+0x22>
	if (r < 1)
  802325:	85 c0                	test   %eax,%eax
  802327:	7e 06                	jle    80232f <getchar+0x24>
	return c;
  802329:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    
		return -E_EOF;
  80232f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802334:	eb f7                	jmp    80232d <getchar+0x22>

00802336 <iscons>:
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80233c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233f:	50                   	push   %eax
  802340:	ff 75 08             	pushl  0x8(%ebp)
  802343:	e8 ad ee ff ff       	call   8011f5 <fd_lookup>
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	85 c0                	test   %eax,%eax
  80234d:	78 11                	js     802360 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802358:	39 10                	cmp    %edx,(%eax)
  80235a:	0f 94 c0             	sete   %al
  80235d:	0f b6 c0             	movzbl %al,%eax
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <opencons>:
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802368:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236b:	50                   	push   %eax
  80236c:	e8 35 ee ff ff       	call   8011a6 <fd_alloc>
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	78 3a                	js     8023b2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	68 07 04 00 00       	push   $0x407
  802380:	ff 75 f4             	pushl  -0xc(%ebp)
  802383:	6a 00                	push   $0x0
  802385:	e8 91 ea ff ff       	call   800e1b <sys_page_alloc>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	85 c0                	test   %eax,%eax
  80238f:	78 21                	js     8023b2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80239a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	50                   	push   %eax
  8023aa:	e8 d0 ed ff ff       	call   80117f <fd2num>
  8023af:	83 c4 10             	add    $0x10,%esp
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	56                   	push   %esi
  8023b8:	53                   	push   %ebx
  8023b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8023bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023c2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023c4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023c9:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8023cc:	83 ec 0c             	sub    $0xc,%esp
  8023cf:	50                   	push   %eax
  8023d0:	e8 f6 eb ff ff       	call   800fcb <sys_ipc_recv>
	if (from_env_store)
  8023d5:	83 c4 10             	add    $0x10,%esp
  8023d8:	85 f6                	test   %esi,%esi
  8023da:	74 14                	je     8023f0 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8023dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	78 09                	js     8023ee <ipc_recv+0x3a>
  8023e5:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8023eb:	8b 52 74             	mov    0x74(%edx),%edx
  8023ee:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8023f0:	85 db                	test   %ebx,%ebx
  8023f2:	74 14                	je     802408 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8023f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	78 09                	js     802406 <ipc_recv+0x52>
  8023fd:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802403:	8b 52 78             	mov    0x78(%edx),%edx
  802406:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802408:	85 c0                	test   %eax,%eax
  80240a:	78 08                	js     802414 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  80240c:	a1 20 44 80 00       	mov    0x804420,%eax
  802411:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802414:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    

0080241b <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	57                   	push   %edi
  80241f:	56                   	push   %esi
  802420:	53                   	push   %ebx
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	8b 7d 08             	mov    0x8(%ebp),%edi
  802427:	8b 75 0c             	mov    0xc(%ebp),%esi
  80242a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80242d:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  80242f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802434:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802437:	ff 75 14             	pushl  0x14(%ebp)
  80243a:	53                   	push   %ebx
  80243b:	56                   	push   %esi
  80243c:	57                   	push   %edi
  80243d:	e8 66 eb ff ff       	call   800fa8 <sys_ipc_try_send>
		if (ret == 0)
  802442:	83 c4 10             	add    $0x10,%esp
  802445:	85 c0                	test   %eax,%eax
  802447:	74 1e                	je     802467 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802449:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80244c:	75 07                	jne    802455 <ipc_send+0x3a>
			sys_yield();
  80244e:	e8 a9 e9 ff ff       	call   800dfc <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802453:	eb e2                	jmp    802437 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802455:	50                   	push   %eax
  802456:	68 57 2c 80 00       	push   $0x802c57
  80245b:	6a 3d                	push   $0x3d
  80245d:	68 6b 2c 80 00       	push   $0x802c6b
  802462:	e8 c1 de ff ff       	call   800328 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80246a:	5b                   	pop    %ebx
  80246b:	5e                   	pop    %esi
  80246c:	5f                   	pop    %edi
  80246d:	5d                   	pop    %ebp
  80246e:	c3                   	ret    

0080246f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802475:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80247a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80247d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802483:	8b 52 50             	mov    0x50(%edx),%edx
  802486:	39 ca                	cmp    %ecx,%edx
  802488:	74 11                	je     80249b <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80248a:	83 c0 01             	add    $0x1,%eax
  80248d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802492:	75 e6                	jne    80247a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802494:	b8 00 00 00 00       	mov    $0x0,%eax
  802499:	eb 0b                	jmp    8024a6 <ipc_find_env+0x37>
			return envs[i].env_id;
  80249b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80249e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024a3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    

008024a8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024ae:	89 d0                	mov    %edx,%eax
  8024b0:	c1 e8 16             	shr    $0x16,%eax
  8024b3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024bf:	f6 c1 01             	test   $0x1,%cl
  8024c2:	74 1d                	je     8024e1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024c4:	c1 ea 0c             	shr    $0xc,%edx
  8024c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024ce:	f6 c2 01             	test   $0x1,%dl
  8024d1:	74 0e                	je     8024e1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024d3:	c1 ea 0c             	shr    $0xc,%edx
  8024d6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024dd:	ef 
  8024de:	0f b7 c0             	movzwl %ax,%eax
}
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    
  8024e3:	66 90                	xchg   %ax,%ax
  8024e5:	66 90                	xchg   %ax,%ax
  8024e7:	66 90                	xchg   %ax,%ax
  8024e9:	66 90                	xchg   %ax,%ax
  8024eb:	66 90                	xchg   %ax,%ax
  8024ed:	66 90                	xchg   %ax,%ax
  8024ef:	90                   	nop

008024f0 <__udivdi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	83 ec 1c             	sub    $0x1c,%esp
  8024f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802503:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802507:	85 d2                	test   %edx,%edx
  802509:	75 35                	jne    802540 <__udivdi3+0x50>
  80250b:	39 f3                	cmp    %esi,%ebx
  80250d:	0f 87 bd 00 00 00    	ja     8025d0 <__udivdi3+0xe0>
  802513:	85 db                	test   %ebx,%ebx
  802515:	89 d9                	mov    %ebx,%ecx
  802517:	75 0b                	jne    802524 <__udivdi3+0x34>
  802519:	b8 01 00 00 00       	mov    $0x1,%eax
  80251e:	31 d2                	xor    %edx,%edx
  802520:	f7 f3                	div    %ebx
  802522:	89 c1                	mov    %eax,%ecx
  802524:	31 d2                	xor    %edx,%edx
  802526:	89 f0                	mov    %esi,%eax
  802528:	f7 f1                	div    %ecx
  80252a:	89 c6                	mov    %eax,%esi
  80252c:	89 e8                	mov    %ebp,%eax
  80252e:	89 f7                	mov    %esi,%edi
  802530:	f7 f1                	div    %ecx
  802532:	89 fa                	mov    %edi,%edx
  802534:	83 c4 1c             	add    $0x1c,%esp
  802537:	5b                   	pop    %ebx
  802538:	5e                   	pop    %esi
  802539:	5f                   	pop    %edi
  80253a:	5d                   	pop    %ebp
  80253b:	c3                   	ret    
  80253c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802540:	39 f2                	cmp    %esi,%edx
  802542:	77 7c                	ja     8025c0 <__udivdi3+0xd0>
  802544:	0f bd fa             	bsr    %edx,%edi
  802547:	83 f7 1f             	xor    $0x1f,%edi
  80254a:	0f 84 98 00 00 00    	je     8025e8 <__udivdi3+0xf8>
  802550:	89 f9                	mov    %edi,%ecx
  802552:	b8 20 00 00 00       	mov    $0x20,%eax
  802557:	29 f8                	sub    %edi,%eax
  802559:	d3 e2                	shl    %cl,%edx
  80255b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80255f:	89 c1                	mov    %eax,%ecx
  802561:	89 da                	mov    %ebx,%edx
  802563:	d3 ea                	shr    %cl,%edx
  802565:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802569:	09 d1                	or     %edx,%ecx
  80256b:	89 f2                	mov    %esi,%edx
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 f9                	mov    %edi,%ecx
  802573:	d3 e3                	shl    %cl,%ebx
  802575:	89 c1                	mov    %eax,%ecx
  802577:	d3 ea                	shr    %cl,%edx
  802579:	89 f9                	mov    %edi,%ecx
  80257b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80257f:	d3 e6                	shl    %cl,%esi
  802581:	89 eb                	mov    %ebp,%ebx
  802583:	89 c1                	mov    %eax,%ecx
  802585:	d3 eb                	shr    %cl,%ebx
  802587:	09 de                	or     %ebx,%esi
  802589:	89 f0                	mov    %esi,%eax
  80258b:	f7 74 24 08          	divl   0x8(%esp)
  80258f:	89 d6                	mov    %edx,%esi
  802591:	89 c3                	mov    %eax,%ebx
  802593:	f7 64 24 0c          	mull   0xc(%esp)
  802597:	39 d6                	cmp    %edx,%esi
  802599:	72 0c                	jb     8025a7 <__udivdi3+0xb7>
  80259b:	89 f9                	mov    %edi,%ecx
  80259d:	d3 e5                	shl    %cl,%ebp
  80259f:	39 c5                	cmp    %eax,%ebp
  8025a1:	73 5d                	jae    802600 <__udivdi3+0x110>
  8025a3:	39 d6                	cmp    %edx,%esi
  8025a5:	75 59                	jne    802600 <__udivdi3+0x110>
  8025a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025aa:	31 ff                	xor    %edi,%edi
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	8d 76 00             	lea    0x0(%esi),%esi
  8025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8025c0:	31 ff                	xor    %edi,%edi
  8025c2:	31 c0                	xor    %eax,%eax
  8025c4:	89 fa                	mov    %edi,%edx
  8025c6:	83 c4 1c             	add    $0x1c,%esp
  8025c9:	5b                   	pop    %ebx
  8025ca:	5e                   	pop    %esi
  8025cb:	5f                   	pop    %edi
  8025cc:	5d                   	pop    %ebp
  8025cd:	c3                   	ret    
  8025ce:	66 90                	xchg   %ax,%ax
  8025d0:	31 ff                	xor    %edi,%edi
  8025d2:	89 e8                	mov    %ebp,%eax
  8025d4:	89 f2                	mov    %esi,%edx
  8025d6:	f7 f3                	div    %ebx
  8025d8:	89 fa                	mov    %edi,%edx
  8025da:	83 c4 1c             	add    $0x1c,%esp
  8025dd:	5b                   	pop    %ebx
  8025de:	5e                   	pop    %esi
  8025df:	5f                   	pop    %edi
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    
  8025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e8:	39 f2                	cmp    %esi,%edx
  8025ea:	72 06                	jb     8025f2 <__udivdi3+0x102>
  8025ec:	31 c0                	xor    %eax,%eax
  8025ee:	39 eb                	cmp    %ebp,%ebx
  8025f0:	77 d2                	ja     8025c4 <__udivdi3+0xd4>
  8025f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f7:	eb cb                	jmp    8025c4 <__udivdi3+0xd4>
  8025f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802600:	89 d8                	mov    %ebx,%eax
  802602:	31 ff                	xor    %edi,%edi
  802604:	eb be                	jmp    8025c4 <__udivdi3+0xd4>
  802606:	66 90                	xchg   %ax,%ax
  802608:	66 90                	xchg   %ax,%ax
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__umoddi3>:
  802610:	55                   	push   %ebp
  802611:	57                   	push   %edi
  802612:	56                   	push   %esi
  802613:	53                   	push   %ebx
  802614:	83 ec 1c             	sub    $0x1c,%esp
  802617:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80261b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80261f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802627:	85 ed                	test   %ebp,%ebp
  802629:	89 f0                	mov    %esi,%eax
  80262b:	89 da                	mov    %ebx,%edx
  80262d:	75 19                	jne    802648 <__umoddi3+0x38>
  80262f:	39 df                	cmp    %ebx,%edi
  802631:	0f 86 b1 00 00 00    	jbe    8026e8 <__umoddi3+0xd8>
  802637:	f7 f7                	div    %edi
  802639:	89 d0                	mov    %edx,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	39 dd                	cmp    %ebx,%ebp
  80264a:	77 f1                	ja     80263d <__umoddi3+0x2d>
  80264c:	0f bd cd             	bsr    %ebp,%ecx
  80264f:	83 f1 1f             	xor    $0x1f,%ecx
  802652:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802656:	0f 84 b4 00 00 00    	je     802710 <__umoddi3+0x100>
  80265c:	b8 20 00 00 00       	mov    $0x20,%eax
  802661:	89 c2                	mov    %eax,%edx
  802663:	8b 44 24 04          	mov    0x4(%esp),%eax
  802667:	29 c2                	sub    %eax,%edx
  802669:	89 c1                	mov    %eax,%ecx
  80266b:	89 f8                	mov    %edi,%eax
  80266d:	d3 e5                	shl    %cl,%ebp
  80266f:	89 d1                	mov    %edx,%ecx
  802671:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802675:	d3 e8                	shr    %cl,%eax
  802677:	09 c5                	or     %eax,%ebp
  802679:	8b 44 24 04          	mov    0x4(%esp),%eax
  80267d:	89 c1                	mov    %eax,%ecx
  80267f:	d3 e7                	shl    %cl,%edi
  802681:	89 d1                	mov    %edx,%ecx
  802683:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802687:	89 df                	mov    %ebx,%edi
  802689:	d3 ef                	shr    %cl,%edi
  80268b:	89 c1                	mov    %eax,%ecx
  80268d:	89 f0                	mov    %esi,%eax
  80268f:	d3 e3                	shl    %cl,%ebx
  802691:	89 d1                	mov    %edx,%ecx
  802693:	89 fa                	mov    %edi,%edx
  802695:	d3 e8                	shr    %cl,%eax
  802697:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80269c:	09 d8                	or     %ebx,%eax
  80269e:	f7 f5                	div    %ebp
  8026a0:	d3 e6                	shl    %cl,%esi
  8026a2:	89 d1                	mov    %edx,%ecx
  8026a4:	f7 64 24 08          	mull   0x8(%esp)
  8026a8:	39 d1                	cmp    %edx,%ecx
  8026aa:	89 c3                	mov    %eax,%ebx
  8026ac:	89 d7                	mov    %edx,%edi
  8026ae:	72 06                	jb     8026b6 <__umoddi3+0xa6>
  8026b0:	75 0e                	jne    8026c0 <__umoddi3+0xb0>
  8026b2:	39 c6                	cmp    %eax,%esi
  8026b4:	73 0a                	jae    8026c0 <__umoddi3+0xb0>
  8026b6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026ba:	19 ea                	sbb    %ebp,%edx
  8026bc:	89 d7                	mov    %edx,%edi
  8026be:	89 c3                	mov    %eax,%ebx
  8026c0:	89 ca                	mov    %ecx,%edx
  8026c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8026c7:	29 de                	sub    %ebx,%esi
  8026c9:	19 fa                	sbb    %edi,%edx
  8026cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8026cf:	89 d0                	mov    %edx,%eax
  8026d1:	d3 e0                	shl    %cl,%eax
  8026d3:	89 d9                	mov    %ebx,%ecx
  8026d5:	d3 ee                	shr    %cl,%esi
  8026d7:	d3 ea                	shr    %cl,%edx
  8026d9:	09 f0                	or     %esi,%eax
  8026db:	83 c4 1c             	add    $0x1c,%esp
  8026de:	5b                   	pop    %ebx
  8026df:	5e                   	pop    %esi
  8026e0:	5f                   	pop    %edi
  8026e1:	5d                   	pop    %ebp
  8026e2:	c3                   	ret    
  8026e3:	90                   	nop
  8026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	85 ff                	test   %edi,%edi
  8026ea:	89 f9                	mov    %edi,%ecx
  8026ec:	75 0b                	jne    8026f9 <__umoddi3+0xe9>
  8026ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f3:	31 d2                	xor    %edx,%edx
  8026f5:	f7 f7                	div    %edi
  8026f7:	89 c1                	mov    %eax,%ecx
  8026f9:	89 d8                	mov    %ebx,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	f7 f1                	div    %ecx
  8026ff:	89 f0                	mov    %esi,%eax
  802701:	f7 f1                	div    %ecx
  802703:	e9 31 ff ff ff       	jmp    802639 <__umoddi3+0x29>
  802708:	90                   	nop
  802709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802710:	39 dd                	cmp    %ebx,%ebp
  802712:	72 08                	jb     80271c <__umoddi3+0x10c>
  802714:	39 f7                	cmp    %esi,%edi
  802716:	0f 87 21 ff ff ff    	ja     80263d <__umoddi3+0x2d>
  80271c:	89 da                	mov    %ebx,%edx
  80271e:	89 f0                	mov    %esi,%eax
  802720:	29 f8                	sub    %edi,%eax
  802722:	19 ea                	sbb    %ebp,%edx
  802724:	e9 14 ff ff ff       	jmp    80263d <__umoddi3+0x2d>

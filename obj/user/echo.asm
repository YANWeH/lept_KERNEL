
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 4c                	jmp    8000a1 <umain+0x6e>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 e0 22 80 00       	push   $0x8022e0
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 bc 01 00 00       	call   800221 <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800088:	e8 b7 00 00 00       	call   800144 <strlen>
  80008d:	83 c4 0c             	add    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800094:	6a 01                	push   $0x1
  800096:	e8 9e 0a 00 00       	call   800b39 <write>
	for (i = 1; i < argc; i++) {
  80009b:	83 c3 01             	add    $0x1,%ebx
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	39 df                	cmp    %ebx,%edi
  8000a3:	7e 1b                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000a5:	83 fb 01             	cmp    $0x1,%ebx
  8000a8:	7e d8                	jle    800082 <umain+0x4f>
			write(1, " ", 1);
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 01                	push   $0x1
  8000af:	68 e3 22 80 00       	push   $0x8022e3
  8000b4:	6a 01                	push   $0x1
  8000b6:	e8 7e 0a 00 00       	call   800b39 <write>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	eb c2                	jmp    800082 <umain+0x4f>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 30 24 80 00       	push   $0x802430
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 5a 0a 00 00       	call   800b39 <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 42 04 00 00       	call   800536 <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x2d>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	e8 18 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011b:	e8 0a 00 00 00       	call   80012a <exit>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <exit>:

#include <inc/lib.h>

void exit(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800130:	e8 25 08 00 00       	call   80095a <close_all>
	sys_env_destroy(0);
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	6a 00                	push   $0x0
  80013a:	e8 b6 03 00 00       	call   8004f5 <sys_env_destroy>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	c9                   	leave  
  800143:	c3                   	ret    

00800144 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80014a:	b8 00 00 00 00       	mov    $0x0,%eax
  80014f:	eb 03                	jmp    800154 <strlen+0x10>
		n++;
  800151:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800154:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800158:	75 f7                	jne    800151 <strlen+0xd>
	return n;
}
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800162:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800165:	b8 00 00 00 00       	mov    $0x0,%eax
  80016a:	eb 03                	jmp    80016f <strnlen+0x13>
		n++;
  80016c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80016f:	39 d0                	cmp    %edx,%eax
  800171:	74 06                	je     800179 <strnlen+0x1d>
  800173:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800177:	75 f3                	jne    80016c <strnlen+0x10>
	return n;
}
  800179:	5d                   	pop    %ebp
  80017a:	c3                   	ret    

0080017b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	53                   	push   %ebx
  80017f:	8b 45 08             	mov    0x8(%ebp),%eax
  800182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800185:	89 c2                	mov    %eax,%edx
  800187:	83 c1 01             	add    $0x1,%ecx
  80018a:	83 c2 01             	add    $0x1,%edx
  80018d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800191:	88 5a ff             	mov    %bl,-0x1(%edx)
  800194:	84 db                	test   %bl,%bl
  800196:	75 ef                	jne    800187 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800198:	5b                   	pop    %ebx
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001a2:	53                   	push   %ebx
  8001a3:	e8 9c ff ff ff       	call   800144 <strlen>
  8001a8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	01 d8                	add    %ebx,%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 c5 ff ff ff       	call   80017b <strcpy>
	return dst;
}
  8001b6:	89 d8                	mov    %ebx,%eax
  8001b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c8:	89 f3                	mov    %esi,%ebx
  8001ca:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001cd:	89 f2                	mov    %esi,%edx
  8001cf:	eb 0f                	jmp    8001e0 <strncpy+0x23>
		*dst++ = *src;
  8001d1:	83 c2 01             	add    $0x1,%edx
  8001d4:	0f b6 01             	movzbl (%ecx),%eax
  8001d7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001da:	80 39 01             	cmpb   $0x1,(%ecx)
  8001dd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8001e0:	39 da                	cmp    %ebx,%edx
  8001e2:	75 ed                	jne    8001d1 <strncpy+0x14>
	}
	return ret;
}
  8001e4:	89 f0                	mov    %esi,%eax
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001f8:	89 f0                	mov    %esi,%eax
  8001fa:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001fe:	85 c9                	test   %ecx,%ecx
  800200:	75 0b                	jne    80020d <strlcpy+0x23>
  800202:	eb 17                	jmp    80021b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800204:	83 c2 01             	add    $0x1,%edx
  800207:	83 c0 01             	add    $0x1,%eax
  80020a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80020d:	39 d8                	cmp    %ebx,%eax
  80020f:	74 07                	je     800218 <strlcpy+0x2e>
  800211:	0f b6 0a             	movzbl (%edx),%ecx
  800214:	84 c9                	test   %cl,%cl
  800216:	75 ec                	jne    800204 <strlcpy+0x1a>
		*dst = '\0';
  800218:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80021b:	29 f0                	sub    %esi,%eax
}
  80021d:	5b                   	pop    %ebx
  80021e:	5e                   	pop    %esi
  80021f:	5d                   	pop    %ebp
  800220:	c3                   	ret    

00800221 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800227:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80022a:	eb 06                	jmp    800232 <strcmp+0x11>
		p++, q++;
  80022c:	83 c1 01             	add    $0x1,%ecx
  80022f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800232:	0f b6 01             	movzbl (%ecx),%eax
  800235:	84 c0                	test   %al,%al
  800237:	74 04                	je     80023d <strcmp+0x1c>
  800239:	3a 02                	cmp    (%edx),%al
  80023b:	74 ef                	je     80022c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80023d:	0f b6 c0             	movzbl %al,%eax
  800240:	0f b6 12             	movzbl (%edx),%edx
  800243:	29 d0                	sub    %edx,%eax
}
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    

00800247 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	53                   	push   %ebx
  80024b:	8b 45 08             	mov    0x8(%ebp),%eax
  80024e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800251:	89 c3                	mov    %eax,%ebx
  800253:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800256:	eb 06                	jmp    80025e <strncmp+0x17>
		n--, p++, q++;
  800258:	83 c0 01             	add    $0x1,%eax
  80025b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80025e:	39 d8                	cmp    %ebx,%eax
  800260:	74 16                	je     800278 <strncmp+0x31>
  800262:	0f b6 08             	movzbl (%eax),%ecx
  800265:	84 c9                	test   %cl,%cl
  800267:	74 04                	je     80026d <strncmp+0x26>
  800269:	3a 0a                	cmp    (%edx),%cl
  80026b:	74 eb                	je     800258 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80026d:	0f b6 00             	movzbl (%eax),%eax
  800270:	0f b6 12             	movzbl (%edx),%edx
  800273:	29 d0                	sub    %edx,%eax
}
  800275:	5b                   	pop    %ebx
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    
		return 0;
  800278:	b8 00 00 00 00       	mov    $0x0,%eax
  80027d:	eb f6                	jmp    800275 <strncmp+0x2e>

0080027f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800289:	0f b6 10             	movzbl (%eax),%edx
  80028c:	84 d2                	test   %dl,%dl
  80028e:	74 09                	je     800299 <strchr+0x1a>
		if (*s == c)
  800290:	38 ca                	cmp    %cl,%dl
  800292:	74 0a                	je     80029e <strchr+0x1f>
	for (; *s; s++)
  800294:	83 c0 01             	add    $0x1,%eax
  800297:	eb f0                	jmp    800289 <strchr+0xa>
			return (char *) s;
	return 0;
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002aa:	eb 03                	jmp    8002af <strfind+0xf>
  8002ac:	83 c0 01             	add    $0x1,%eax
  8002af:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002b2:	38 ca                	cmp    %cl,%dl
  8002b4:	74 04                	je     8002ba <strfind+0x1a>
  8002b6:	84 d2                	test   %dl,%dl
  8002b8:	75 f2                	jne    8002ac <strfind+0xc>
			break;
	return (char *) s;
}
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	57                   	push   %edi
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002c8:	85 c9                	test   %ecx,%ecx
  8002ca:	74 13                	je     8002df <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002cc:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8002d2:	75 05                	jne    8002d9 <memset+0x1d>
  8002d4:	f6 c1 03             	test   $0x3,%cl
  8002d7:	74 0d                	je     8002e6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dc:	fc                   	cld    
  8002dd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8002df:	89 f8                	mov    %edi,%eax
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    
		c &= 0xFF;
  8002e6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002ea:	89 d3                	mov    %edx,%ebx
  8002ec:	c1 e3 08             	shl    $0x8,%ebx
  8002ef:	89 d0                	mov    %edx,%eax
  8002f1:	c1 e0 18             	shl    $0x18,%eax
  8002f4:	89 d6                	mov    %edx,%esi
  8002f6:	c1 e6 10             	shl    $0x10,%esi
  8002f9:	09 f0                	or     %esi,%eax
  8002fb:	09 c2                	or     %eax,%edx
  8002fd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8002ff:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800302:	89 d0                	mov    %edx,%eax
  800304:	fc                   	cld    
  800305:	f3 ab                	rep stos %eax,%es:(%edi)
  800307:	eb d6                	jmp    8002df <memset+0x23>

00800309 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	57                   	push   %edi
  80030d:	56                   	push   %esi
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	8b 75 0c             	mov    0xc(%ebp),%esi
  800314:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800317:	39 c6                	cmp    %eax,%esi
  800319:	73 35                	jae    800350 <memmove+0x47>
  80031b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	76 2e                	jbe    800350 <memmove+0x47>
		s += n;
		d += n;
  800322:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800325:	89 d6                	mov    %edx,%esi
  800327:	09 fe                	or     %edi,%esi
  800329:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80032f:	74 0c                	je     80033d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800331:	83 ef 01             	sub    $0x1,%edi
  800334:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800337:	fd                   	std    
  800338:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80033a:	fc                   	cld    
  80033b:	eb 21                	jmp    80035e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80033d:	f6 c1 03             	test   $0x3,%cl
  800340:	75 ef                	jne    800331 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800342:	83 ef 04             	sub    $0x4,%edi
  800345:	8d 72 fc             	lea    -0x4(%edx),%esi
  800348:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80034b:	fd                   	std    
  80034c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80034e:	eb ea                	jmp    80033a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800350:	89 f2                	mov    %esi,%edx
  800352:	09 c2                	or     %eax,%edx
  800354:	f6 c2 03             	test   $0x3,%dl
  800357:	74 09                	je     800362 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800359:	89 c7                	mov    %eax,%edi
  80035b:	fc                   	cld    
  80035c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80035e:	5e                   	pop    %esi
  80035f:	5f                   	pop    %edi
  800360:	5d                   	pop    %ebp
  800361:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800362:	f6 c1 03             	test   $0x3,%cl
  800365:	75 f2                	jne    800359 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800367:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	fc                   	cld    
  80036d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80036f:	eb ed                	jmp    80035e <memmove+0x55>

00800371 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800374:	ff 75 10             	pushl  0x10(%ebp)
  800377:	ff 75 0c             	pushl  0xc(%ebp)
  80037a:	ff 75 08             	pushl  0x8(%ebp)
  80037d:	e8 87 ff ff ff       	call   800309 <memmove>
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	56                   	push   %esi
  800388:	53                   	push   %ebx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038f:	89 c6                	mov    %eax,%esi
  800391:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800394:	39 f0                	cmp    %esi,%eax
  800396:	74 1c                	je     8003b4 <memcmp+0x30>
		if (*s1 != *s2)
  800398:	0f b6 08             	movzbl (%eax),%ecx
  80039b:	0f b6 1a             	movzbl (%edx),%ebx
  80039e:	38 d9                	cmp    %bl,%cl
  8003a0:	75 08                	jne    8003aa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8003a2:	83 c0 01             	add    $0x1,%eax
  8003a5:	83 c2 01             	add    $0x1,%edx
  8003a8:	eb ea                	jmp    800394 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8003aa:	0f b6 c1             	movzbl %cl,%eax
  8003ad:	0f b6 db             	movzbl %bl,%ebx
  8003b0:	29 d8                	sub    %ebx,%eax
  8003b2:	eb 05                	jmp    8003b9 <memcmp+0x35>
	}

	return 0;
  8003b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003b9:	5b                   	pop    %ebx
  8003ba:	5e                   	pop    %esi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003c6:	89 c2                	mov    %eax,%edx
  8003c8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003cb:	39 d0                	cmp    %edx,%eax
  8003cd:	73 09                	jae    8003d8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003cf:	38 08                	cmp    %cl,(%eax)
  8003d1:	74 05                	je     8003d8 <memfind+0x1b>
	for (; s < ends; s++)
  8003d3:	83 c0 01             	add    $0x1,%eax
  8003d6:	eb f3                	jmp    8003cb <memfind+0xe>
			break;
	return (void *) s;
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	57                   	push   %edi
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
  8003e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003e6:	eb 03                	jmp    8003eb <strtol+0x11>
		s++;
  8003e8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8003eb:	0f b6 01             	movzbl (%ecx),%eax
  8003ee:	3c 20                	cmp    $0x20,%al
  8003f0:	74 f6                	je     8003e8 <strtol+0xe>
  8003f2:	3c 09                	cmp    $0x9,%al
  8003f4:	74 f2                	je     8003e8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8003f6:	3c 2b                	cmp    $0x2b,%al
  8003f8:	74 2e                	je     800428 <strtol+0x4e>
	int neg = 0;
  8003fa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8003ff:	3c 2d                	cmp    $0x2d,%al
  800401:	74 2f                	je     800432 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800403:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800409:	75 05                	jne    800410 <strtol+0x36>
  80040b:	80 39 30             	cmpb   $0x30,(%ecx)
  80040e:	74 2c                	je     80043c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800410:	85 db                	test   %ebx,%ebx
  800412:	75 0a                	jne    80041e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800414:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800419:	80 39 30             	cmpb   $0x30,(%ecx)
  80041c:	74 28                	je     800446 <strtol+0x6c>
		base = 10;
  80041e:	b8 00 00 00 00       	mov    $0x0,%eax
  800423:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800426:	eb 50                	jmp    800478 <strtol+0x9e>
		s++;
  800428:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80042b:	bf 00 00 00 00       	mov    $0x0,%edi
  800430:	eb d1                	jmp    800403 <strtol+0x29>
		s++, neg = 1;
  800432:	83 c1 01             	add    $0x1,%ecx
  800435:	bf 01 00 00 00       	mov    $0x1,%edi
  80043a:	eb c7                	jmp    800403 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80043c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800440:	74 0e                	je     800450 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800442:	85 db                	test   %ebx,%ebx
  800444:	75 d8                	jne    80041e <strtol+0x44>
		s++, base = 8;
  800446:	83 c1 01             	add    $0x1,%ecx
  800449:	bb 08 00 00 00       	mov    $0x8,%ebx
  80044e:	eb ce                	jmp    80041e <strtol+0x44>
		s += 2, base = 16;
  800450:	83 c1 02             	add    $0x2,%ecx
  800453:	bb 10 00 00 00       	mov    $0x10,%ebx
  800458:	eb c4                	jmp    80041e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80045a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80045d:	89 f3                	mov    %esi,%ebx
  80045f:	80 fb 19             	cmp    $0x19,%bl
  800462:	77 29                	ja     80048d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800464:	0f be d2             	movsbl %dl,%edx
  800467:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80046a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80046d:	7d 30                	jge    80049f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80046f:	83 c1 01             	add    $0x1,%ecx
  800472:	0f af 45 10          	imul   0x10(%ebp),%eax
  800476:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800478:	0f b6 11             	movzbl (%ecx),%edx
  80047b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80047e:	89 f3                	mov    %esi,%ebx
  800480:	80 fb 09             	cmp    $0x9,%bl
  800483:	77 d5                	ja     80045a <strtol+0x80>
			dig = *s - '0';
  800485:	0f be d2             	movsbl %dl,%edx
  800488:	83 ea 30             	sub    $0x30,%edx
  80048b:	eb dd                	jmp    80046a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  80048d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800490:	89 f3                	mov    %esi,%ebx
  800492:	80 fb 19             	cmp    $0x19,%bl
  800495:	77 08                	ja     80049f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800497:	0f be d2             	movsbl %dl,%edx
  80049a:	83 ea 37             	sub    $0x37,%edx
  80049d:	eb cb                	jmp    80046a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  80049f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a3:	74 05                	je     8004aa <strtol+0xd0>
		*endptr = (char *) s;
  8004a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004a8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004aa:	89 c2                	mov    %eax,%edx
  8004ac:	f7 da                	neg    %edx
  8004ae:	85 ff                	test   %edi,%edi
  8004b0:	0f 45 c2             	cmovne %edx,%eax
}
  8004b3:	5b                   	pop    %ebx
  8004b4:	5e                   	pop    %esi
  8004b5:	5f                   	pop    %edi
  8004b6:	5d                   	pop    %ebp
  8004b7:	c3                   	ret    

008004b8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	57                   	push   %edi
  8004bc:	56                   	push   %esi
  8004bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c9:	89 c3                	mov    %eax,%ebx
  8004cb:	89 c7                	mov    %eax,%edi
  8004cd:	89 c6                	mov    %eax,%esi
  8004cf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004d1:	5b                   	pop    %ebx
  8004d2:	5e                   	pop    %esi
  8004d3:	5f                   	pop    %edi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	57                   	push   %edi
  8004da:	56                   	push   %esi
  8004db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	89 d3                	mov    %edx,%ebx
  8004ea:	89 d7                	mov    %edx,%edi
  8004ec:	89 d6                	mov    %edx,%esi
  8004ee:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004f0:	5b                   	pop    %ebx
  8004f1:	5e                   	pop    %esi
  8004f2:	5f                   	pop    %edi
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	57                   	push   %edi
  8004f9:	56                   	push   %esi
  8004fa:	53                   	push   %ebx
  8004fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8004fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800503:	8b 55 08             	mov    0x8(%ebp),%edx
  800506:	b8 03 00 00 00       	mov    $0x3,%eax
  80050b:	89 cb                	mov    %ecx,%ebx
  80050d:	89 cf                	mov    %ecx,%edi
  80050f:	89 ce                	mov    %ecx,%esi
  800511:	cd 30                	int    $0x30
	if(check && ret > 0)
  800513:	85 c0                	test   %eax,%eax
  800515:	7f 08                	jg     80051f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800517:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80051a:	5b                   	pop    %ebx
  80051b:	5e                   	pop    %esi
  80051c:	5f                   	pop    %edi
  80051d:	5d                   	pop    %ebp
  80051e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	50                   	push   %eax
  800523:	6a 03                	push   $0x3
  800525:	68 ef 22 80 00       	push   $0x8022ef
  80052a:	6a 23                	push   $0x23
  80052c:	68 0c 23 80 00       	push   $0x80230c
  800531:	e8 6e 13 00 00       	call   8018a4 <_panic>

00800536 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	57                   	push   %edi
  80053a:	56                   	push   %esi
  80053b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80053c:	ba 00 00 00 00       	mov    $0x0,%edx
  800541:	b8 02 00 00 00       	mov    $0x2,%eax
  800546:	89 d1                	mov    %edx,%ecx
  800548:	89 d3                	mov    %edx,%ebx
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	89 d6                	mov    %edx,%esi
  80054e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800550:	5b                   	pop    %ebx
  800551:	5e                   	pop    %esi
  800552:	5f                   	pop    %edi
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <sys_yield>:

void
sys_yield(void)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	57                   	push   %edi
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80055b:	ba 00 00 00 00       	mov    $0x0,%edx
  800560:	b8 0b 00 00 00       	mov    $0xb,%eax
  800565:	89 d1                	mov    %edx,%ecx
  800567:	89 d3                	mov    %edx,%ebx
  800569:	89 d7                	mov    %edx,%edi
  80056b:	89 d6                	mov    %edx,%esi
  80056d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80056f:	5b                   	pop    %ebx
  800570:	5e                   	pop    %esi
  800571:	5f                   	pop    %edi
  800572:	5d                   	pop    %ebp
  800573:	c3                   	ret    

00800574 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	57                   	push   %edi
  800578:	56                   	push   %esi
  800579:	53                   	push   %ebx
  80057a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80057d:	be 00 00 00 00       	mov    $0x0,%esi
  800582:	8b 55 08             	mov    0x8(%ebp),%edx
  800585:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800588:	b8 04 00 00 00       	mov    $0x4,%eax
  80058d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800590:	89 f7                	mov    %esi,%edi
  800592:	cd 30                	int    $0x30
	if(check && ret > 0)
  800594:	85 c0                	test   %eax,%eax
  800596:	7f 08                	jg     8005a0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800598:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059b:	5b                   	pop    %ebx
  80059c:	5e                   	pop    %esi
  80059d:	5f                   	pop    %edi
  80059e:	5d                   	pop    %ebp
  80059f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005a0:	83 ec 0c             	sub    $0xc,%esp
  8005a3:	50                   	push   %eax
  8005a4:	6a 04                	push   $0x4
  8005a6:	68 ef 22 80 00       	push   $0x8022ef
  8005ab:	6a 23                	push   $0x23
  8005ad:	68 0c 23 80 00       	push   $0x80230c
  8005b2:	e8 ed 12 00 00       	call   8018a4 <_panic>

008005b7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	57                   	push   %edi
  8005bb:	56                   	push   %esi
  8005bc:	53                   	push   %ebx
  8005bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8005cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8005d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8005d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	7f 08                	jg     8005e2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8005da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005dd:	5b                   	pop    %ebx
  8005de:	5e                   	pop    %esi
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005e2:	83 ec 0c             	sub    $0xc,%esp
  8005e5:	50                   	push   %eax
  8005e6:	6a 05                	push   $0x5
  8005e8:	68 ef 22 80 00       	push   $0x8022ef
  8005ed:	6a 23                	push   $0x23
  8005ef:	68 0c 23 80 00       	push   $0x80230c
  8005f4:	e8 ab 12 00 00       	call   8018a4 <_panic>

008005f9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	57                   	push   %edi
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800602:	bb 00 00 00 00       	mov    $0x0,%ebx
  800607:	8b 55 08             	mov    0x8(%ebp),%edx
  80060a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80060d:	b8 06 00 00 00       	mov    $0x6,%eax
  800612:	89 df                	mov    %ebx,%edi
  800614:	89 de                	mov    %ebx,%esi
  800616:	cd 30                	int    $0x30
	if(check && ret > 0)
  800618:	85 c0                	test   %eax,%eax
  80061a:	7f 08                	jg     800624 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80061c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061f:	5b                   	pop    %ebx
  800620:	5e                   	pop    %esi
  800621:	5f                   	pop    %edi
  800622:	5d                   	pop    %ebp
  800623:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	50                   	push   %eax
  800628:	6a 06                	push   $0x6
  80062a:	68 ef 22 80 00       	push   $0x8022ef
  80062f:	6a 23                	push   $0x23
  800631:	68 0c 23 80 00       	push   $0x80230c
  800636:	e8 69 12 00 00       	call   8018a4 <_panic>

0080063b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	57                   	push   %edi
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
  800641:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 55 08             	mov    0x8(%ebp),%edx
  80064c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064f:	b8 08 00 00 00       	mov    $0x8,%eax
  800654:	89 df                	mov    %ebx,%edi
  800656:	89 de                	mov    %ebx,%esi
  800658:	cd 30                	int    $0x30
	if(check && ret > 0)
  80065a:	85 c0                	test   %eax,%eax
  80065c:	7f 08                	jg     800666 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80065e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	50                   	push   %eax
  80066a:	6a 08                	push   $0x8
  80066c:	68 ef 22 80 00       	push   $0x8022ef
  800671:	6a 23                	push   $0x23
  800673:	68 0c 23 80 00       	push   $0x80230c
  800678:	e8 27 12 00 00       	call   8018a4 <_panic>

0080067d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	57                   	push   %edi
  800681:	56                   	push   %esi
  800682:	53                   	push   %ebx
  800683:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800686:	bb 00 00 00 00       	mov    $0x0,%ebx
  80068b:	8b 55 08             	mov    0x8(%ebp),%edx
  80068e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800691:	b8 09 00 00 00       	mov    $0x9,%eax
  800696:	89 df                	mov    %ebx,%edi
  800698:	89 de                	mov    %ebx,%esi
  80069a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80069c:	85 c0                	test   %eax,%eax
  80069e:	7f 08                	jg     8006a8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8006a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a3:	5b                   	pop    %ebx
  8006a4:	5e                   	pop    %esi
  8006a5:	5f                   	pop    %edi
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	50                   	push   %eax
  8006ac:	6a 09                	push   $0x9
  8006ae:	68 ef 22 80 00       	push   $0x8022ef
  8006b3:	6a 23                	push   $0x23
  8006b5:	68 0c 23 80 00       	push   $0x80230c
  8006ba:	e8 e5 11 00 00       	call   8018a4 <_panic>

008006bf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	57                   	push   %edi
  8006c3:	56                   	push   %esi
  8006c4:	53                   	push   %ebx
  8006c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8006d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d8:	89 df                	mov    %ebx,%edi
  8006da:	89 de                	mov    %ebx,%esi
  8006dc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006de:	85 c0                	test   %eax,%eax
  8006e0:	7f 08                	jg     8006ea <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e5:	5b                   	pop    %ebx
  8006e6:	5e                   	pop    %esi
  8006e7:	5f                   	pop    %edi
  8006e8:	5d                   	pop    %ebp
  8006e9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	50                   	push   %eax
  8006ee:	6a 0a                	push   $0xa
  8006f0:	68 ef 22 80 00       	push   $0x8022ef
  8006f5:	6a 23                	push   $0x23
  8006f7:	68 0c 23 80 00       	push   $0x80230c
  8006fc:	e8 a3 11 00 00       	call   8018a4 <_panic>

00800701 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	57                   	push   %edi
  800705:	56                   	push   %esi
  800706:	53                   	push   %ebx
	asm volatile("int %1\n"
  800707:	8b 55 08             	mov    0x8(%ebp),%edx
  80070a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80070d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800712:	be 00 00 00 00       	mov    $0x0,%esi
  800717:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80071a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80071d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80071f:	5b                   	pop    %ebx
  800720:	5e                   	pop    %esi
  800721:	5f                   	pop    %edi
  800722:	5d                   	pop    %ebp
  800723:	c3                   	ret    

00800724 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	57                   	push   %edi
  800728:	56                   	push   %esi
  800729:	53                   	push   %ebx
  80072a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80072d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800732:	8b 55 08             	mov    0x8(%ebp),%edx
  800735:	b8 0d 00 00 00       	mov    $0xd,%eax
  80073a:	89 cb                	mov    %ecx,%ebx
  80073c:	89 cf                	mov    %ecx,%edi
  80073e:	89 ce                	mov    %ecx,%esi
  800740:	cd 30                	int    $0x30
	if(check && ret > 0)
  800742:	85 c0                	test   %eax,%eax
  800744:	7f 08                	jg     80074e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800746:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800749:	5b                   	pop    %ebx
  80074a:	5e                   	pop    %esi
  80074b:	5f                   	pop    %edi
  80074c:	5d                   	pop    %ebp
  80074d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80074e:	83 ec 0c             	sub    $0xc,%esp
  800751:	50                   	push   %eax
  800752:	6a 0d                	push   $0xd
  800754:	68 ef 22 80 00       	push   $0x8022ef
  800759:	6a 23                	push   $0x23
  80075b:	68 0c 23 80 00       	push   $0x80230c
  800760:	e8 3f 11 00 00       	call   8018a4 <_panic>

00800765 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	b8 0e 00 00 00       	mov    $0xe,%eax
  800775:	89 d1                	mov    %edx,%ecx
  800777:	89 d3                	mov    %edx,%ebx
  800779:	89 d7                	mov    %edx,%edi
  80077b:	89 d6                	mov    %edx,%esi
  80077d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80077f:	5b                   	pop    %ebx
  800780:	5e                   	pop    %esi
  800781:	5f                   	pop    %edi
  800782:	5d                   	pop    %ebp
  800783:	c3                   	ret    

00800784 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	05 00 00 00 30       	add    $0x30000000,%eax
  80078f:	c1 e8 0c             	shr    $0xc,%eax
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80079f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007a4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8007b6:	89 c2                	mov    %eax,%edx
  8007b8:	c1 ea 16             	shr    $0x16,%edx
  8007bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8007c2:	f6 c2 01             	test   $0x1,%dl
  8007c5:	74 2a                	je     8007f1 <fd_alloc+0x46>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	c1 ea 0c             	shr    $0xc,%edx
  8007cc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007d3:	f6 c2 01             	test   $0x1,%dl
  8007d6:	74 19                	je     8007f1 <fd_alloc+0x46>
  8007d8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8007dd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8007e2:	75 d2                	jne    8007b6 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007e4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8007ea:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8007ef:	eb 07                	jmp    8007f8 <fd_alloc+0x4d>
			*fd_store = fd;
  8007f1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8007f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800800:	83 f8 1f             	cmp    $0x1f,%eax
  800803:	77 36                	ja     80083b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800805:	c1 e0 0c             	shl    $0xc,%eax
  800808:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80080d:	89 c2                	mov    %eax,%edx
  80080f:	c1 ea 16             	shr    $0x16,%edx
  800812:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800819:	f6 c2 01             	test   $0x1,%dl
  80081c:	74 24                	je     800842 <fd_lookup+0x48>
  80081e:	89 c2                	mov    %eax,%edx
  800820:	c1 ea 0c             	shr    $0xc,%edx
  800823:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80082a:	f6 c2 01             	test   $0x1,%dl
  80082d:	74 1a                	je     800849 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800832:	89 02                	mov    %eax,(%edx)
	return 0;
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    
		return -E_INVAL;
  80083b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800840:	eb f7                	jmp    800839 <fd_lookup+0x3f>
		return -E_INVAL;
  800842:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800847:	eb f0                	jmp    800839 <fd_lookup+0x3f>
  800849:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084e:	eb e9                	jmp    800839 <fd_lookup+0x3f>

00800850 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800859:	ba 98 23 80 00       	mov    $0x802398,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80085e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800863:	39 08                	cmp    %ecx,(%eax)
  800865:	74 33                	je     80089a <dev_lookup+0x4a>
  800867:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80086a:	8b 02                	mov    (%edx),%eax
  80086c:	85 c0                	test   %eax,%eax
  80086e:	75 f3                	jne    800863 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800870:	a1 08 40 80 00       	mov    0x804008,%eax
  800875:	8b 40 48             	mov    0x48(%eax),%eax
  800878:	83 ec 04             	sub    $0x4,%esp
  80087b:	51                   	push   %ecx
  80087c:	50                   	push   %eax
  80087d:	68 1c 23 80 00       	push   $0x80231c
  800882:	e8 f8 10 00 00       	call   80197f <cprintf>
	*dev = 0;
  800887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800898:	c9                   	leave  
  800899:	c3                   	ret    
			*dev = devtab[i];
  80089a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	eb f2                	jmp    800898 <dev_lookup+0x48>

008008a6 <fd_close>:
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	57                   	push   %edi
  8008aa:	56                   	push   %esi
  8008ab:	53                   	push   %ebx
  8008ac:	83 ec 1c             	sub    $0x1c,%esp
  8008af:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8008b8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8008b9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8008bf:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008c2:	50                   	push   %eax
  8008c3:	e8 32 ff ff ff       	call   8007fa <fd_lookup>
  8008c8:	89 c3                	mov    %eax,%ebx
  8008ca:	83 c4 08             	add    $0x8,%esp
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	78 05                	js     8008d6 <fd_close+0x30>
	    || fd != fd2)
  8008d1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8008d4:	74 16                	je     8008ec <fd_close+0x46>
		return (must_exist ? r : 0);
  8008d6:	89 f8                	mov    %edi,%eax
  8008d8:	84 c0                	test   %al,%al
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	0f 44 d8             	cmove  %eax,%ebx
}
  8008e2:	89 d8                	mov    %ebx,%eax
  8008e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5f                   	pop    %edi
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008f2:	50                   	push   %eax
  8008f3:	ff 36                	pushl  (%esi)
  8008f5:	e8 56 ff ff ff       	call   800850 <dev_lookup>
  8008fa:	89 c3                	mov    %eax,%ebx
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	85 c0                	test   %eax,%eax
  800901:	78 15                	js     800918 <fd_close+0x72>
		if (dev->dev_close)
  800903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800906:	8b 40 10             	mov    0x10(%eax),%eax
  800909:	85 c0                	test   %eax,%eax
  80090b:	74 1b                	je     800928 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80090d:	83 ec 0c             	sub    $0xc,%esp
  800910:	56                   	push   %esi
  800911:	ff d0                	call   *%eax
  800913:	89 c3                	mov    %eax,%ebx
  800915:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	56                   	push   %esi
  80091c:	6a 00                	push   $0x0
  80091e:	e8 d6 fc ff ff       	call   8005f9 <sys_page_unmap>
	return r;
  800923:	83 c4 10             	add    $0x10,%esp
  800926:	eb ba                	jmp    8008e2 <fd_close+0x3c>
			r = 0;
  800928:	bb 00 00 00 00       	mov    $0x0,%ebx
  80092d:	eb e9                	jmp    800918 <fd_close+0x72>

0080092f <close>:

int
close(int fdnum)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800935:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800938:	50                   	push   %eax
  800939:	ff 75 08             	pushl  0x8(%ebp)
  80093c:	e8 b9 fe ff ff       	call   8007fa <fd_lookup>
  800941:	83 c4 08             	add    $0x8,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	78 10                	js     800958 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	6a 01                	push   $0x1
  80094d:	ff 75 f4             	pushl  -0xc(%ebp)
  800950:	e8 51 ff ff ff       	call   8008a6 <fd_close>
  800955:	83 c4 10             	add    $0x10,%esp
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <close_all>:

void
close_all(void)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800961:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800966:	83 ec 0c             	sub    $0xc,%esp
  800969:	53                   	push   %ebx
  80096a:	e8 c0 ff ff ff       	call   80092f <close>
	for (i = 0; i < MAXFD; i++)
  80096f:	83 c3 01             	add    $0x1,%ebx
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	83 fb 20             	cmp    $0x20,%ebx
  800978:	75 ec                	jne    800966 <close_all+0xc>
}
  80097a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	57                   	push   %edi
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800988:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80098b:	50                   	push   %eax
  80098c:	ff 75 08             	pushl  0x8(%ebp)
  80098f:	e8 66 fe ff ff       	call   8007fa <fd_lookup>
  800994:	89 c3                	mov    %eax,%ebx
  800996:	83 c4 08             	add    $0x8,%esp
  800999:	85 c0                	test   %eax,%eax
  80099b:	0f 88 81 00 00 00    	js     800a22 <dup+0xa3>
		return r;
	close(newfdnum);
  8009a1:	83 ec 0c             	sub    $0xc,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	e8 83 ff ff ff       	call   80092f <close>

	newfd = INDEX2FD(newfdnum);
  8009ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009af:	c1 e6 0c             	shl    $0xc,%esi
  8009b2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8009b8:	83 c4 04             	add    $0x4,%esp
  8009bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009be:	e8 d1 fd ff ff       	call   800794 <fd2data>
  8009c3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8009c5:	89 34 24             	mov    %esi,(%esp)
  8009c8:	e8 c7 fd ff ff       	call   800794 <fd2data>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009d2:	89 d8                	mov    %ebx,%eax
  8009d4:	c1 e8 16             	shr    $0x16,%eax
  8009d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8009de:	a8 01                	test   $0x1,%al
  8009e0:	74 11                	je     8009f3 <dup+0x74>
  8009e2:	89 d8                	mov    %ebx,%eax
  8009e4:	c1 e8 0c             	shr    $0xc,%eax
  8009e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8009ee:	f6 c2 01             	test   $0x1,%dl
  8009f1:	75 39                	jne    800a2c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f6:	89 d0                	mov    %edx,%eax
  8009f8:	c1 e8 0c             	shr    $0xc,%eax
  8009fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a02:	83 ec 0c             	sub    $0xc,%esp
  800a05:	25 07 0e 00 00       	and    $0xe07,%eax
  800a0a:	50                   	push   %eax
  800a0b:	56                   	push   %esi
  800a0c:	6a 00                	push   $0x0
  800a0e:	52                   	push   %edx
  800a0f:	6a 00                	push   $0x0
  800a11:	e8 a1 fb ff ff       	call   8005b7 <sys_page_map>
  800a16:	89 c3                	mov    %eax,%ebx
  800a18:	83 c4 20             	add    $0x20,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	78 31                	js     800a50 <dup+0xd1>
		goto err;

	return newfdnum;
  800a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a22:	89 d8                	mov    %ebx,%eax
  800a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a27:	5b                   	pop    %ebx
  800a28:	5e                   	pop    %esi
  800a29:	5f                   	pop    %edi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a2c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a33:	83 ec 0c             	sub    $0xc,%esp
  800a36:	25 07 0e 00 00       	and    $0xe07,%eax
  800a3b:	50                   	push   %eax
  800a3c:	57                   	push   %edi
  800a3d:	6a 00                	push   $0x0
  800a3f:	53                   	push   %ebx
  800a40:	6a 00                	push   $0x0
  800a42:	e8 70 fb ff ff       	call   8005b7 <sys_page_map>
  800a47:	89 c3                	mov    %eax,%ebx
  800a49:	83 c4 20             	add    $0x20,%esp
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	79 a3                	jns    8009f3 <dup+0x74>
	sys_page_unmap(0, newfd);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	56                   	push   %esi
  800a54:	6a 00                	push   $0x0
  800a56:	e8 9e fb ff ff       	call   8005f9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800a5b:	83 c4 08             	add    $0x8,%esp
  800a5e:	57                   	push   %edi
  800a5f:	6a 00                	push   $0x0
  800a61:	e8 93 fb ff ff       	call   8005f9 <sys_page_unmap>
	return r;
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	eb b7                	jmp    800a22 <dup+0xa3>

00800a6b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	53                   	push   %ebx
  800a6f:	83 ec 14             	sub    $0x14,%esp
  800a72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a78:	50                   	push   %eax
  800a79:	53                   	push   %ebx
  800a7a:	e8 7b fd ff ff       	call   8007fa <fd_lookup>
  800a7f:	83 c4 08             	add    $0x8,%esp
  800a82:	85 c0                	test   %eax,%eax
  800a84:	78 3f                	js     800ac5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a8c:	50                   	push   %eax
  800a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a90:	ff 30                	pushl  (%eax)
  800a92:	e8 b9 fd ff ff       	call   800850 <dev_lookup>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	85 c0                	test   %eax,%eax
  800a9c:	78 27                	js     800ac5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800aa1:	8b 42 08             	mov    0x8(%edx),%eax
  800aa4:	83 e0 03             	and    $0x3,%eax
  800aa7:	83 f8 01             	cmp    $0x1,%eax
  800aaa:	74 1e                	je     800aca <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aaf:	8b 40 08             	mov    0x8(%eax),%eax
  800ab2:	85 c0                	test   %eax,%eax
  800ab4:	74 35                	je     800aeb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800ab6:	83 ec 04             	sub    $0x4,%esp
  800ab9:	ff 75 10             	pushl  0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	52                   	push   %edx
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
}
  800ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aca:	a1 08 40 80 00       	mov    0x804008,%eax
  800acf:	8b 40 48             	mov    0x48(%eax),%eax
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	53                   	push   %ebx
  800ad6:	50                   	push   %eax
  800ad7:	68 5d 23 80 00       	push   $0x80235d
  800adc:	e8 9e 0e 00 00       	call   80197f <cprintf>
		return -E_INVAL;
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ae9:	eb da                	jmp    800ac5 <read+0x5a>
		return -E_NOT_SUPP;
  800aeb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800af0:	eb d3                	jmp    800ac5 <read+0x5a>

00800af2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	57                   	push   %edi
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	83 ec 0c             	sub    $0xc,%esp
  800afb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afe:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b06:	39 f3                	cmp    %esi,%ebx
  800b08:	73 25                	jae    800b2f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b0a:	83 ec 04             	sub    $0x4,%esp
  800b0d:	89 f0                	mov    %esi,%eax
  800b0f:	29 d8                	sub    %ebx,%eax
  800b11:	50                   	push   %eax
  800b12:	89 d8                	mov    %ebx,%eax
  800b14:	03 45 0c             	add    0xc(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	57                   	push   %edi
  800b19:	e8 4d ff ff ff       	call   800a6b <read>
		if (m < 0)
  800b1e:	83 c4 10             	add    $0x10,%esp
  800b21:	85 c0                	test   %eax,%eax
  800b23:	78 08                	js     800b2d <readn+0x3b>
			return m;
		if (m == 0)
  800b25:	85 c0                	test   %eax,%eax
  800b27:	74 06                	je     800b2f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800b29:	01 c3                	add    %eax,%ebx
  800b2b:	eb d9                	jmp    800b06 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b2d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b2f:	89 d8                	mov    %ebx,%eax
  800b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	53                   	push   %ebx
  800b3d:	83 ec 14             	sub    $0x14,%esp
  800b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b43:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b46:	50                   	push   %eax
  800b47:	53                   	push   %ebx
  800b48:	e8 ad fc ff ff       	call   8007fa <fd_lookup>
  800b4d:	83 c4 08             	add    $0x8,%esp
  800b50:	85 c0                	test   %eax,%eax
  800b52:	78 3a                	js     800b8e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b5a:	50                   	push   %eax
  800b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5e:	ff 30                	pushl  (%eax)
  800b60:	e8 eb fc ff ff       	call   800850 <dev_lookup>
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	85 c0                	test   %eax,%eax
  800b6a:	78 22                	js     800b8e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800b73:	74 1e                	je     800b93 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b78:	8b 52 0c             	mov    0xc(%edx),%edx
  800b7b:	85 d2                	test   %edx,%edx
  800b7d:	74 35                	je     800bb4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	ff 75 10             	pushl  0x10(%ebp)
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	50                   	push   %eax
  800b89:	ff d2                	call   *%edx
  800b8b:	83 c4 10             	add    $0x10,%esp
}
  800b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b93:	a1 08 40 80 00       	mov    0x804008,%eax
  800b98:	8b 40 48             	mov    0x48(%eax),%eax
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	53                   	push   %ebx
  800b9f:	50                   	push   %eax
  800ba0:	68 79 23 80 00       	push   $0x802379
  800ba5:	e8 d5 0d 00 00       	call   80197f <cprintf>
		return -E_INVAL;
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bb2:	eb da                	jmp    800b8e <write+0x55>
		return -E_NOT_SUPP;
  800bb4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800bb9:	eb d3                	jmp    800b8e <write+0x55>

00800bbb <seek>:

int
seek(int fdnum, off_t offset)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800bc1:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800bc4:	50                   	push   %eax
  800bc5:	ff 75 08             	pushl  0x8(%ebp)
  800bc8:	e8 2d fc ff ff       	call   8007fa <fd_lookup>
  800bcd:	83 c4 08             	add    $0x8,%esp
  800bd0:	85 c0                	test   %eax,%eax
  800bd2:	78 0e                	js     800be2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bda:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	53                   	push   %ebx
  800be8:	83 ec 14             	sub    $0x14,%esp
  800beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bf1:	50                   	push   %eax
  800bf2:	53                   	push   %ebx
  800bf3:	e8 02 fc ff ff       	call   8007fa <fd_lookup>
  800bf8:	83 c4 08             	add    $0x8,%esp
  800bfb:	85 c0                	test   %eax,%eax
  800bfd:	78 37                	js     800c36 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c05:	50                   	push   %eax
  800c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c09:	ff 30                	pushl  (%eax)
  800c0b:	e8 40 fc ff ff       	call   800850 <dev_lookup>
  800c10:	83 c4 10             	add    $0x10,%esp
  800c13:	85 c0                	test   %eax,%eax
  800c15:	78 1f                	js     800c36 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c1e:	74 1b                	je     800c3b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c23:	8b 52 18             	mov    0x18(%edx),%edx
  800c26:	85 d2                	test   %edx,%edx
  800c28:	74 32                	je     800c5c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	50                   	push   %eax
  800c31:	ff d2                	call   *%edx
  800c33:	83 c4 10             	add    $0x10,%esp
}
  800c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c3b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c40:	8b 40 48             	mov    0x48(%eax),%eax
  800c43:	83 ec 04             	sub    $0x4,%esp
  800c46:	53                   	push   %ebx
  800c47:	50                   	push   %eax
  800c48:	68 3c 23 80 00       	push   $0x80233c
  800c4d:	e8 2d 0d 00 00       	call   80197f <cprintf>
		return -E_INVAL;
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c5a:	eb da                	jmp    800c36 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800c5c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c61:	eb d3                	jmp    800c36 <ftruncate+0x52>

00800c63 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	53                   	push   %ebx
  800c67:	83 ec 14             	sub    $0x14,%esp
  800c6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c70:	50                   	push   %eax
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	e8 81 fb ff ff       	call   8007fa <fd_lookup>
  800c79:	83 c4 08             	add    $0x8,%esp
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	78 4b                	js     800ccb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c86:	50                   	push   %eax
  800c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8a:	ff 30                	pushl  (%eax)
  800c8c:	e8 bf fb ff ff       	call   800850 <dev_lookup>
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	85 c0                	test   %eax,%eax
  800c96:	78 33                	js     800ccb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c9b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800c9f:	74 2f                	je     800cd0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800ca1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800ca4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800cab:	00 00 00 
	stat->st_isdir = 0;
  800cae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cb5:	00 00 00 
	stat->st_dev = dev;
  800cb8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	53                   	push   %ebx
  800cc2:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc5:	ff 50 14             	call   *0x14(%eax)
  800cc8:	83 c4 10             	add    $0x10,%esp
}
  800ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    
		return -E_NOT_SUPP;
  800cd0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cd5:	eb f4                	jmp    800ccb <fstat+0x68>

00800cd7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800cdc:	83 ec 08             	sub    $0x8,%esp
  800cdf:	6a 00                	push   $0x0
  800ce1:	ff 75 08             	pushl  0x8(%ebp)
  800ce4:	e8 e7 01 00 00       	call   800ed0 <open>
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	83 c4 10             	add    $0x10,%esp
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	78 1b                	js     800d0d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800cf2:	83 ec 08             	sub    $0x8,%esp
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	50                   	push   %eax
  800cf9:	e8 65 ff ff ff       	call   800c63 <fstat>
  800cfe:	89 c6                	mov    %eax,%esi
	close(fd);
  800d00:	89 1c 24             	mov    %ebx,(%esp)
  800d03:	e8 27 fc ff ff       	call   80092f <close>
	return r;
  800d08:	83 c4 10             	add    $0x10,%esp
  800d0b:	89 f3                	mov    %esi,%ebx
}
  800d0d:	89 d8                	mov    %ebx,%eax
  800d0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	89 c6                	mov    %eax,%esi
  800d1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d1f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d26:	74 27                	je     800d4f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d28:	6a 07                	push   $0x7
  800d2a:	68 00 50 80 00       	push   $0x805000
  800d2f:	56                   	push   %esi
  800d30:	ff 35 00 40 80 00    	pushl  0x804000
  800d36:	e8 93 12 00 00       	call   801fce <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d3b:	83 c4 0c             	add    $0xc,%esp
  800d3e:	6a 00                	push   $0x0
  800d40:	53                   	push   %ebx
  800d41:	6a 00                	push   $0x0
  800d43:	e8 1f 12 00 00       	call   801f67 <ipc_recv>
}
  800d48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	6a 01                	push   $0x1
  800d54:	e8 c9 12 00 00       	call   802022 <ipc_find_env>
  800d59:	a3 00 40 80 00       	mov    %eax,0x804000
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	eb c5                	jmp    800d28 <fsipc+0x12>

00800d63 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  800d6f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d81:	b8 02 00 00 00       	mov    $0x2,%eax
  800d86:	e8 8b ff ff ff       	call   800d16 <fsipc>
}
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <devfile_flush>:
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 40 0c             	mov    0xc(%eax),%eax
  800d99:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	b8 06 00 00 00       	mov    $0x6,%eax
  800da8:	e8 69 ff ff ff       	call   800d16 <fsipc>
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <devfile_stat>:
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	53                   	push   %ebx
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  800dbf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800dc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dce:	e8 43 ff ff ff       	call   800d16 <fsipc>
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	78 2c                	js     800e03 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dd7:	83 ec 08             	sub    $0x8,%esp
  800dda:	68 00 50 80 00       	push   $0x805000
  800ddf:	53                   	push   %ebx
  800de0:	e8 96 f3 ff ff       	call   80017b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800de5:	a1 80 50 80 00       	mov    0x805080,%eax
  800dea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800df0:	a1 84 50 80 00       	mov    0x805084,%eax
  800df5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <devfile_write>:
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800e16:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800e1b:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	8b 52 0c             	mov    0xc(%edx),%edx
  800e24:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800e2a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800e2f:	50                   	push   %eax
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	68 08 50 80 00       	push   $0x805008
  800e38:	e8 cc f4 ff ff       	call   800309 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e42:	b8 04 00 00 00       	mov    $0x4,%eax
  800e47:	e8 ca fe ff ff       	call   800d16 <fsipc>
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <devfile_read>:
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8b 40 0c             	mov    0xc(%eax),%eax
  800e5c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800e61:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800e67:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e71:	e8 a0 fe ff ff       	call   800d16 <fsipc>
  800e76:	89 c3                	mov    %eax,%ebx
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	78 1f                	js     800e9b <devfile_read+0x4d>
	assert(r <= n);
  800e7c:	39 f0                	cmp    %esi,%eax
  800e7e:	77 24                	ja     800ea4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800e80:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800e85:	7f 33                	jg     800eba <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800e87:	83 ec 04             	sub    $0x4,%esp
  800e8a:	50                   	push   %eax
  800e8b:	68 00 50 80 00       	push   $0x805000
  800e90:	ff 75 0c             	pushl  0xc(%ebp)
  800e93:	e8 71 f4 ff ff       	call   800309 <memmove>
	return r;
  800e98:	83 c4 10             	add    $0x10,%esp
}
  800e9b:	89 d8                	mov    %ebx,%eax
  800e9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
	assert(r <= n);
  800ea4:	68 ac 23 80 00       	push   $0x8023ac
  800ea9:	68 b3 23 80 00       	push   $0x8023b3
  800eae:	6a 7b                	push   $0x7b
  800eb0:	68 c8 23 80 00       	push   $0x8023c8
  800eb5:	e8 ea 09 00 00       	call   8018a4 <_panic>
	assert(r <= PGSIZE);
  800eba:	68 d3 23 80 00       	push   $0x8023d3
  800ebf:	68 b3 23 80 00       	push   $0x8023b3
  800ec4:	6a 7c                	push   $0x7c
  800ec6:	68 c8 23 80 00       	push   $0x8023c8
  800ecb:	e8 d4 09 00 00       	call   8018a4 <_panic>

00800ed0 <open>:
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	83 ec 1c             	sub    $0x1c,%esp
  800ed8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800edb:	56                   	push   %esi
  800edc:	e8 63 f2 ff ff       	call   800144 <strlen>
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ee9:	7f 6c                	jg     800f57 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ef1:	50                   	push   %eax
  800ef2:	e8 b4 f8 ff ff       	call   8007ab <fd_alloc>
  800ef7:	89 c3                	mov    %eax,%ebx
  800ef9:	83 c4 10             	add    $0x10,%esp
  800efc:	85 c0                	test   %eax,%eax
  800efe:	78 3c                	js     800f3c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800f00:	83 ec 08             	sub    $0x8,%esp
  800f03:	56                   	push   %esi
  800f04:	68 00 50 80 00       	push   $0x805000
  800f09:	e8 6d f2 ff ff       	call   80017b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f19:	b8 01 00 00 00       	mov    $0x1,%eax
  800f1e:	e8 f3 fd ff ff       	call   800d16 <fsipc>
  800f23:	89 c3                	mov    %eax,%ebx
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	78 19                	js     800f45 <open+0x75>
	return fd2num(fd);
  800f2c:	83 ec 0c             	sub    $0xc,%esp
  800f2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f32:	e8 4d f8 ff ff       	call   800784 <fd2num>
  800f37:	89 c3                	mov    %eax,%ebx
  800f39:	83 c4 10             	add    $0x10,%esp
}
  800f3c:	89 d8                	mov    %ebx,%eax
  800f3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
		fd_close(fd, 0);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	6a 00                	push   $0x0
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	e8 54 f9 ff ff       	call   8008a6 <fd_close>
		return r;
  800f52:	83 c4 10             	add    $0x10,%esp
  800f55:	eb e5                	jmp    800f3c <open+0x6c>
		return -E_BAD_PATH;
  800f57:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f5c:	eb de                	jmp    800f3c <open+0x6c>

00800f5e <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800f64:	ba 00 00 00 00       	mov    $0x0,%edx
  800f69:	b8 08 00 00 00       	mov    $0x8,%eax
  800f6e:	e8 a3 fd ff ff       	call   800d16 <fsipc>
}
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    

00800f75 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f7b:	68 df 23 80 00       	push   $0x8023df
  800f80:	ff 75 0c             	pushl  0xc(%ebp)
  800f83:	e8 f3 f1 ff ff       	call   80017b <strcpy>
	return 0;
}
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8d:	c9                   	leave  
  800f8e:	c3                   	ret    

00800f8f <devsock_close>:
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	53                   	push   %ebx
  800f93:	83 ec 10             	sub    $0x10,%esp
  800f96:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f99:	53                   	push   %ebx
  800f9a:	e8 bc 10 00 00       	call   80205b <pageref>
  800f9f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800fa2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800fa7:	83 f8 01             	cmp    $0x1,%eax
  800faa:	74 07                	je     800fb3 <devsock_close+0x24>
}
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	ff 73 0c             	pushl  0xc(%ebx)
  800fb9:	e8 b7 02 00 00       	call   801275 <nsipc_close>
  800fbe:	89 c2                	mov    %eax,%edx
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	eb e7                	jmp    800fac <devsock_close+0x1d>

00800fc5 <devsock_write>:
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800fcb:	6a 00                	push   $0x0
  800fcd:	ff 75 10             	pushl  0x10(%ebp)
  800fd0:	ff 75 0c             	pushl  0xc(%ebp)
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	ff 70 0c             	pushl  0xc(%eax)
  800fd9:	e8 74 03 00 00       	call   801352 <nsipc_send>
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <devsock_read>:
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800fe6:	6a 00                	push   $0x0
  800fe8:	ff 75 10             	pushl  0x10(%ebp)
  800feb:	ff 75 0c             	pushl  0xc(%ebp)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	ff 70 0c             	pushl  0xc(%eax)
  800ff4:	e8 ed 02 00 00       	call   8012e6 <nsipc_recv>
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <fd2sockid>:
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801001:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801004:	52                   	push   %edx
  801005:	50                   	push   %eax
  801006:	e8 ef f7 ff ff       	call   8007fa <fd_lookup>
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	78 10                	js     801022 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801015:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80101b:	39 08                	cmp    %ecx,(%eax)
  80101d:	75 05                	jne    801024 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80101f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801022:	c9                   	leave  
  801023:	c3                   	ret    
		return -E_NOT_SUPP;
  801024:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801029:	eb f7                	jmp    801022 <fd2sockid+0x27>

0080102b <alloc_sockfd>:
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	83 ec 1c             	sub    $0x1c,%esp
  801033:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801035:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801038:	50                   	push   %eax
  801039:	e8 6d f7 ff ff       	call   8007ab <fd_alloc>
  80103e:	89 c3                	mov    %eax,%ebx
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	85 c0                	test   %eax,%eax
  801045:	78 43                	js     80108a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801047:	83 ec 04             	sub    $0x4,%esp
  80104a:	68 07 04 00 00       	push   $0x407
  80104f:	ff 75 f4             	pushl  -0xc(%ebp)
  801052:	6a 00                	push   $0x0
  801054:	e8 1b f5 ff ff       	call   800574 <sys_page_alloc>
  801059:	89 c3                	mov    %eax,%ebx
  80105b:	83 c4 10             	add    $0x10,%esp
  80105e:	85 c0                	test   %eax,%eax
  801060:	78 28                	js     80108a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801065:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80106b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801070:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801077:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80107a:	83 ec 0c             	sub    $0xc,%esp
  80107d:	50                   	push   %eax
  80107e:	e8 01 f7 ff ff       	call   800784 <fd2num>
  801083:	89 c3                	mov    %eax,%ebx
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	eb 0c                	jmp    801096 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	56                   	push   %esi
  80108e:	e8 e2 01 00 00       	call   801275 <nsipc_close>
		return r;
  801093:	83 c4 10             	add    $0x10,%esp
}
  801096:	89 d8                	mov    %ebx,%eax
  801098:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <accept>:
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	e8 4e ff ff ff       	call   800ffb <fd2sockid>
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 1b                	js     8010cc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8010b1:	83 ec 04             	sub    $0x4,%esp
  8010b4:	ff 75 10             	pushl  0x10(%ebp)
  8010b7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	e8 0e 01 00 00       	call   8011ce <nsipc_accept>
  8010c0:	83 c4 10             	add    $0x10,%esp
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	78 05                	js     8010cc <accept+0x2d>
	return alloc_sockfd(r);
  8010c7:	e8 5f ff ff ff       	call   80102b <alloc_sockfd>
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <bind>:
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	e8 1f ff ff ff       	call   800ffb <fd2sockid>
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	78 12                	js     8010f2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8010e0:	83 ec 04             	sub    $0x4,%esp
  8010e3:	ff 75 10             	pushl  0x10(%ebp)
  8010e6:	ff 75 0c             	pushl  0xc(%ebp)
  8010e9:	50                   	push   %eax
  8010ea:	e8 2f 01 00 00       	call   80121e <nsipc_bind>
  8010ef:	83 c4 10             	add    $0x10,%esp
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <shutdown>:
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	e8 f9 fe ff ff       	call   800ffb <fd2sockid>
  801102:	85 c0                	test   %eax,%eax
  801104:	78 0f                	js     801115 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801106:	83 ec 08             	sub    $0x8,%esp
  801109:	ff 75 0c             	pushl  0xc(%ebp)
  80110c:	50                   	push   %eax
  80110d:	e8 41 01 00 00       	call   801253 <nsipc_shutdown>
  801112:	83 c4 10             	add    $0x10,%esp
}
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <connect>:
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	e8 d6 fe ff ff       	call   800ffb <fd2sockid>
  801125:	85 c0                	test   %eax,%eax
  801127:	78 12                	js     80113b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	ff 75 10             	pushl  0x10(%ebp)
  80112f:	ff 75 0c             	pushl  0xc(%ebp)
  801132:	50                   	push   %eax
  801133:	e8 57 01 00 00       	call   80128f <nsipc_connect>
  801138:	83 c4 10             	add    $0x10,%esp
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <listen>:
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	e8 b0 fe ff ff       	call   800ffb <fd2sockid>
  80114b:	85 c0                	test   %eax,%eax
  80114d:	78 0f                	js     80115e <listen+0x21>
	return nsipc_listen(r, backlog);
  80114f:	83 ec 08             	sub    $0x8,%esp
  801152:	ff 75 0c             	pushl  0xc(%ebp)
  801155:	50                   	push   %eax
  801156:	e8 69 01 00 00       	call   8012c4 <nsipc_listen>
  80115b:	83 c4 10             	add    $0x10,%esp
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <socket>:

int
socket(int domain, int type, int protocol)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801166:	ff 75 10             	pushl  0x10(%ebp)
  801169:	ff 75 0c             	pushl  0xc(%ebp)
  80116c:	ff 75 08             	pushl  0x8(%ebp)
  80116f:	e8 3c 02 00 00       	call   8013b0 <nsipc_socket>
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	85 c0                	test   %eax,%eax
  801179:	78 05                	js     801180 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80117b:	e8 ab fe ff ff       	call   80102b <alloc_sockfd>
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	53                   	push   %ebx
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80118b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801192:	74 26                	je     8011ba <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801194:	6a 07                	push   $0x7
  801196:	68 00 60 80 00       	push   $0x806000
  80119b:	53                   	push   %ebx
  80119c:	ff 35 04 40 80 00    	pushl  0x804004
  8011a2:	e8 27 0e 00 00       	call   801fce <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8011a7:	83 c4 0c             	add    $0xc,%esp
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 00                	push   $0x0
  8011ae:	6a 00                	push   $0x0
  8011b0:	e8 b2 0d 00 00       	call   801f67 <ipc_recv>
}
  8011b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	6a 02                	push   $0x2
  8011bf:	e8 5e 0e 00 00       	call   802022 <ipc_find_env>
  8011c4:	a3 04 40 80 00       	mov    %eax,0x804004
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	eb c6                	jmp    801194 <nsipc+0x12>

008011ce <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
  8011d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8011de:	8b 06                	mov    (%esi),%eax
  8011e0:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8011e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8011ea:	e8 93 ff ff ff       	call   801182 <nsipc>
  8011ef:	89 c3                	mov    %eax,%ebx
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	78 20                	js     801215 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8011f5:	83 ec 04             	sub    $0x4,%esp
  8011f8:	ff 35 10 60 80 00    	pushl  0x806010
  8011fe:	68 00 60 80 00       	push   $0x806000
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	e8 fe f0 ff ff       	call   800309 <memmove>
		*addrlen = ret->ret_addrlen;
  80120b:	a1 10 60 80 00       	mov    0x806010,%eax
  801210:	89 06                	mov    %eax,(%esi)
  801212:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801215:	89 d8                	mov    %ebx,%eax
  801217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121a:	5b                   	pop    %ebx
  80121b:	5e                   	pop    %esi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	53                   	push   %ebx
  801222:	83 ec 08             	sub    $0x8,%esp
  801225:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801230:	53                   	push   %ebx
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	68 04 60 80 00       	push   $0x806004
  801239:	e8 cb f0 ff ff       	call   800309 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80123e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801244:	b8 02 00 00 00       	mov    $0x2,%eax
  801249:	e8 34 ff ff ff       	call   801182 <nsipc>
}
  80124e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801269:	b8 03 00 00 00       	mov    $0x3,%eax
  80126e:	e8 0f ff ff ff       	call   801182 <nsipc>
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <nsipc_close>:

int
nsipc_close(int s)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801283:	b8 04 00 00 00       	mov    $0x4,%eax
  801288:	e8 f5 fe ff ff       	call   801182 <nsipc>
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	53                   	push   %ebx
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8012a1:	53                   	push   %ebx
  8012a2:	ff 75 0c             	pushl  0xc(%ebp)
  8012a5:	68 04 60 80 00       	push   $0x806004
  8012aa:	e8 5a f0 ff ff       	call   800309 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8012af:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8012b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8012ba:	e8 c3 fe ff ff       	call   801182 <nsipc>
}
  8012bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8012da:	b8 06 00 00 00       	mov    $0x6,%eax
  8012df:	e8 9e fe ff ff       	call   801182 <nsipc>
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8012f6:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801304:	b8 07 00 00 00       	mov    $0x7,%eax
  801309:	e8 74 fe ff ff       	call   801182 <nsipc>
  80130e:	89 c3                	mov    %eax,%ebx
  801310:	85 c0                	test   %eax,%eax
  801312:	78 1f                	js     801333 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801314:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801319:	7f 21                	jg     80133c <nsipc_recv+0x56>
  80131b:	39 c6                	cmp    %eax,%esi
  80131d:	7c 1d                	jl     80133c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	50                   	push   %eax
  801323:	68 00 60 80 00       	push   $0x806000
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 d9 ef ff ff       	call   800309 <memmove>
  801330:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801333:	89 d8                	mov    %ebx,%eax
  801335:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80133c:	68 eb 23 80 00       	push   $0x8023eb
  801341:	68 b3 23 80 00       	push   $0x8023b3
  801346:	6a 62                	push   $0x62
  801348:	68 00 24 80 00       	push   $0x802400
  80134d:	e8 52 05 00 00       	call   8018a4 <_panic>

00801352 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	53                   	push   %ebx
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801364:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80136a:	7f 2e                	jg     80139a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	53                   	push   %ebx
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	68 0c 60 80 00       	push   $0x80600c
  801378:	e8 8c ef ff ff       	call   800309 <memmove>
	nsipcbuf.send.req_size = size;
  80137d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801383:	8b 45 14             	mov    0x14(%ebp),%eax
  801386:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80138b:	b8 08 00 00 00       	mov    $0x8,%eax
  801390:	e8 ed fd ff ff       	call   801182 <nsipc>
}
  801395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801398:	c9                   	leave  
  801399:	c3                   	ret    
	assert(size < 1600);
  80139a:	68 0c 24 80 00       	push   $0x80240c
  80139f:	68 b3 23 80 00       	push   $0x8023b3
  8013a4:	6a 6d                	push   $0x6d
  8013a6:	68 00 24 80 00       	push   $0x802400
  8013ab:	e8 f4 04 00 00       	call   8018a4 <_panic>

008013b0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8013c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8013ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8013d3:	e8 aa fd ff ff       	call   801182 <nsipc>
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	56                   	push   %esi
  8013de:	53                   	push   %ebx
  8013df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	ff 75 08             	pushl  0x8(%ebp)
  8013e8:	e8 a7 f3 ff ff       	call   800794 <fd2data>
  8013ed:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8013ef:	83 c4 08             	add    $0x8,%esp
  8013f2:	68 18 24 80 00       	push   $0x802418
  8013f7:	53                   	push   %ebx
  8013f8:	e8 7e ed ff ff       	call   80017b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8013fd:	8b 46 04             	mov    0x4(%esi),%eax
  801400:	2b 06                	sub    (%esi),%eax
  801402:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801408:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80140f:	00 00 00 
	stat->st_dev = &devpipe;
  801412:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801419:	30 80 00 
	return 0;
}
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
  801421:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5d                   	pop    %ebp
  801427:	c3                   	ret    

00801428 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	53                   	push   %ebx
  80142c:	83 ec 0c             	sub    $0xc,%esp
  80142f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801432:	53                   	push   %ebx
  801433:	6a 00                	push   $0x0
  801435:	e8 bf f1 ff ff       	call   8005f9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80143a:	89 1c 24             	mov    %ebx,(%esp)
  80143d:	e8 52 f3 ff ff       	call   800794 <fd2data>
  801442:	83 c4 08             	add    $0x8,%esp
  801445:	50                   	push   %eax
  801446:	6a 00                	push   $0x0
  801448:	e8 ac f1 ff ff       	call   8005f9 <sys_page_unmap>
}
  80144d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <_pipeisclosed>:
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	57                   	push   %edi
  801456:	56                   	push   %esi
  801457:	53                   	push   %ebx
  801458:	83 ec 1c             	sub    $0x1c,%esp
  80145b:	89 c7                	mov    %eax,%edi
  80145d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80145f:	a1 08 40 80 00       	mov    0x804008,%eax
  801464:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	57                   	push   %edi
  80146b:	e8 eb 0b 00 00       	call   80205b <pageref>
  801470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801473:	89 34 24             	mov    %esi,(%esp)
  801476:	e8 e0 0b 00 00       	call   80205b <pageref>
		nn = thisenv->env_runs;
  80147b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801481:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	39 cb                	cmp    %ecx,%ebx
  801489:	74 1b                	je     8014a6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80148b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80148e:	75 cf                	jne    80145f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801490:	8b 42 58             	mov    0x58(%edx),%eax
  801493:	6a 01                	push   $0x1
  801495:	50                   	push   %eax
  801496:	53                   	push   %ebx
  801497:	68 1f 24 80 00       	push   $0x80241f
  80149c:	e8 de 04 00 00       	call   80197f <cprintf>
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	eb b9                	jmp    80145f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8014a6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8014a9:	0f 94 c0             	sete   %al
  8014ac:	0f b6 c0             	movzbl %al,%eax
}
  8014af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5f                   	pop    %edi
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    

008014b7 <devpipe_write>:
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	57                   	push   %edi
  8014bb:	56                   	push   %esi
  8014bc:	53                   	push   %ebx
  8014bd:	83 ec 28             	sub    $0x28,%esp
  8014c0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8014c3:	56                   	push   %esi
  8014c4:	e8 cb f2 ff ff       	call   800794 <fd2data>
  8014c9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8014d3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8014d6:	74 4f                	je     801527 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8014d8:	8b 43 04             	mov    0x4(%ebx),%eax
  8014db:	8b 0b                	mov    (%ebx),%ecx
  8014dd:	8d 51 20             	lea    0x20(%ecx),%edx
  8014e0:	39 d0                	cmp    %edx,%eax
  8014e2:	72 14                	jb     8014f8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8014e4:	89 da                	mov    %ebx,%edx
  8014e6:	89 f0                	mov    %esi,%eax
  8014e8:	e8 65 ff ff ff       	call   801452 <_pipeisclosed>
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	75 3a                	jne    80152b <devpipe_write+0x74>
			sys_yield();
  8014f1:	e8 5f f0 ff ff       	call   800555 <sys_yield>
  8014f6:	eb e0                	jmp    8014d8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8014f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8014ff:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801502:	89 c2                	mov    %eax,%edx
  801504:	c1 fa 1f             	sar    $0x1f,%edx
  801507:	89 d1                	mov    %edx,%ecx
  801509:	c1 e9 1b             	shr    $0x1b,%ecx
  80150c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80150f:	83 e2 1f             	and    $0x1f,%edx
  801512:	29 ca                	sub    %ecx,%edx
  801514:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801518:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80151c:	83 c0 01             	add    $0x1,%eax
  80151f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801522:	83 c7 01             	add    $0x1,%edi
  801525:	eb ac                	jmp    8014d3 <devpipe_write+0x1c>
	return i;
  801527:	89 f8                	mov    %edi,%eax
  801529:	eb 05                	jmp    801530 <devpipe_write+0x79>
				return 0;
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5f                   	pop    %edi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <devpipe_read>:
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	57                   	push   %edi
  80153c:	56                   	push   %esi
  80153d:	53                   	push   %ebx
  80153e:	83 ec 18             	sub    $0x18,%esp
  801541:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801544:	57                   	push   %edi
  801545:	e8 4a f2 ff ff       	call   800794 <fd2data>
  80154a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	be 00 00 00 00       	mov    $0x0,%esi
  801554:	3b 75 10             	cmp    0x10(%ebp),%esi
  801557:	74 47                	je     8015a0 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801559:	8b 03                	mov    (%ebx),%eax
  80155b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80155e:	75 22                	jne    801582 <devpipe_read+0x4a>
			if (i > 0)
  801560:	85 f6                	test   %esi,%esi
  801562:	75 14                	jne    801578 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801564:	89 da                	mov    %ebx,%edx
  801566:	89 f8                	mov    %edi,%eax
  801568:	e8 e5 fe ff ff       	call   801452 <_pipeisclosed>
  80156d:	85 c0                	test   %eax,%eax
  80156f:	75 33                	jne    8015a4 <devpipe_read+0x6c>
			sys_yield();
  801571:	e8 df ef ff ff       	call   800555 <sys_yield>
  801576:	eb e1                	jmp    801559 <devpipe_read+0x21>
				return i;
  801578:	89 f0                	mov    %esi,%eax
}
  80157a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5e                   	pop    %esi
  80157f:	5f                   	pop    %edi
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801582:	99                   	cltd   
  801583:	c1 ea 1b             	shr    $0x1b,%edx
  801586:	01 d0                	add    %edx,%eax
  801588:	83 e0 1f             	and    $0x1f,%eax
  80158b:	29 d0                	sub    %edx,%eax
  80158d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801592:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801595:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801598:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80159b:	83 c6 01             	add    $0x1,%esi
  80159e:	eb b4                	jmp    801554 <devpipe_read+0x1c>
	return i;
  8015a0:	89 f0                	mov    %esi,%eax
  8015a2:	eb d6                	jmp    80157a <devpipe_read+0x42>
				return 0;
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a9:	eb cf                	jmp    80157a <devpipe_read+0x42>

008015ab <pipe>:
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	e8 ef f1 ff ff       	call   8007ab <fd_alloc>
  8015bc:	89 c3                	mov    %eax,%ebx
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 5b                	js     801620 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	68 07 04 00 00       	push   $0x407
  8015cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d0:	6a 00                	push   $0x0
  8015d2:	e8 9d ef ff ff       	call   800574 <sys_page_alloc>
  8015d7:	89 c3                	mov    %eax,%ebx
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	78 40                	js     801620 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e6:	50                   	push   %eax
  8015e7:	e8 bf f1 ff ff       	call   8007ab <fd_alloc>
  8015ec:	89 c3                	mov    %eax,%ebx
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 1b                	js     801610 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015f5:	83 ec 04             	sub    $0x4,%esp
  8015f8:	68 07 04 00 00       	push   $0x407
  8015fd:	ff 75 f0             	pushl  -0x10(%ebp)
  801600:	6a 00                	push   $0x0
  801602:	e8 6d ef ff ff       	call   800574 <sys_page_alloc>
  801607:	89 c3                	mov    %eax,%ebx
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	79 19                	jns    801629 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	ff 75 f4             	pushl  -0xc(%ebp)
  801616:	6a 00                	push   $0x0
  801618:	e8 dc ef ff ff       	call   8005f9 <sys_page_unmap>
  80161d:	83 c4 10             	add    $0x10,%esp
}
  801620:	89 d8                	mov    %ebx,%eax
  801622:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801625:	5b                   	pop    %ebx
  801626:	5e                   	pop    %esi
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    
	va = fd2data(fd0);
  801629:	83 ec 0c             	sub    $0xc,%esp
  80162c:	ff 75 f4             	pushl  -0xc(%ebp)
  80162f:	e8 60 f1 ff ff       	call   800794 <fd2data>
  801634:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801636:	83 c4 0c             	add    $0xc,%esp
  801639:	68 07 04 00 00       	push   $0x407
  80163e:	50                   	push   %eax
  80163f:	6a 00                	push   $0x0
  801641:	e8 2e ef ff ff       	call   800574 <sys_page_alloc>
  801646:	89 c3                	mov    %eax,%ebx
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	85 c0                	test   %eax,%eax
  80164d:	0f 88 8c 00 00 00    	js     8016df <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801653:	83 ec 0c             	sub    $0xc,%esp
  801656:	ff 75 f0             	pushl  -0x10(%ebp)
  801659:	e8 36 f1 ff ff       	call   800794 <fd2data>
  80165e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801665:	50                   	push   %eax
  801666:	6a 00                	push   $0x0
  801668:	56                   	push   %esi
  801669:	6a 00                	push   $0x0
  80166b:	e8 47 ef ff ff       	call   8005b7 <sys_page_map>
  801670:	89 c3                	mov    %eax,%ebx
  801672:	83 c4 20             	add    $0x20,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	78 58                	js     8016d1 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801682:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801697:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a9:	e8 d6 f0 ff ff       	call   800784 <fd2num>
  8016ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8016b3:	83 c4 04             	add    $0x4,%esp
  8016b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b9:	e8 c6 f0 ff ff       	call   800784 <fd2num>
  8016be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016cc:	e9 4f ff ff ff       	jmp    801620 <pipe+0x75>
	sys_page_unmap(0, va);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	56                   	push   %esi
  8016d5:	6a 00                	push   $0x0
  8016d7:	e8 1d ef ff ff       	call   8005f9 <sys_page_unmap>
  8016dc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e5:	6a 00                	push   $0x0
  8016e7:	e8 0d ef ff ff       	call   8005f9 <sys_page_unmap>
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	e9 1c ff ff ff       	jmp    801610 <pipe+0x65>

008016f4 <pipeisclosed>:
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fd:	50                   	push   %eax
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	e8 f4 f0 ff ff       	call   8007fa <fd_lookup>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 18                	js     801725 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	ff 75 f4             	pushl  -0xc(%ebp)
  801713:	e8 7c f0 ff ff       	call   800794 <fd2data>
	return _pipeisclosed(fd, p);
  801718:	89 c2                	mov    %eax,%edx
  80171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171d:	e8 30 fd ff ff       	call   801452 <_pipeisclosed>
  801722:	83 c4 10             	add    $0x10,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	5d                   	pop    %ebp
  801730:	c3                   	ret    

00801731 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801737:	68 37 24 80 00       	push   $0x802437
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	e8 37 ea ff ff       	call   80017b <strcpy>
	return 0;
}
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <devcons_write>:
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	57                   	push   %edi
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
  801751:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801757:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80175c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801762:	eb 2f                	jmp    801793 <devcons_write+0x48>
		m = n - tot;
  801764:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801767:	29 f3                	sub    %esi,%ebx
  801769:	83 fb 7f             	cmp    $0x7f,%ebx
  80176c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801771:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	53                   	push   %ebx
  801778:	89 f0                	mov    %esi,%eax
  80177a:	03 45 0c             	add    0xc(%ebp),%eax
  80177d:	50                   	push   %eax
  80177e:	57                   	push   %edi
  80177f:	e8 85 eb ff ff       	call   800309 <memmove>
		sys_cputs(buf, m);
  801784:	83 c4 08             	add    $0x8,%esp
  801787:	53                   	push   %ebx
  801788:	57                   	push   %edi
  801789:	e8 2a ed ff ff       	call   8004b8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80178e:	01 de                	add    %ebx,%esi
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	3b 75 10             	cmp    0x10(%ebp),%esi
  801796:	72 cc                	jb     801764 <devcons_write+0x19>
}
  801798:	89 f0                	mov    %esi,%eax
  80179a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5e                   	pop    %esi
  80179f:	5f                   	pop    %edi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <devcons_read>:
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8017ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b1:	75 07                	jne    8017ba <devcons_read+0x18>
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    
		sys_yield();
  8017b5:	e8 9b ed ff ff       	call   800555 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8017ba:	e8 17 ed ff ff       	call   8004d6 <sys_cgetc>
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	74 f2                	je     8017b5 <devcons_read+0x13>
	if (c < 0)
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 ec                	js     8017b3 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8017c7:	83 f8 04             	cmp    $0x4,%eax
  8017ca:	74 0c                	je     8017d8 <devcons_read+0x36>
	*(char*)vbuf = c;
  8017cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cf:	88 02                	mov    %al,(%edx)
	return 1;
  8017d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d6:	eb db                	jmp    8017b3 <devcons_read+0x11>
		return 0;
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dd:	eb d4                	jmp    8017b3 <devcons_read+0x11>

008017df <cputchar>:
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8017eb:	6a 01                	push   $0x1
  8017ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017f0:	50                   	push   %eax
  8017f1:	e8 c2 ec ff ff       	call   8004b8 <sys_cputs>
}
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <getchar>:
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801801:	6a 01                	push   $0x1
  801803:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801806:	50                   	push   %eax
  801807:	6a 00                	push   $0x0
  801809:	e8 5d f2 ff ff       	call   800a6b <read>
	if (r < 0)
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	85 c0                	test   %eax,%eax
  801813:	78 08                	js     80181d <getchar+0x22>
	if (r < 1)
  801815:	85 c0                	test   %eax,%eax
  801817:	7e 06                	jle    80181f <getchar+0x24>
	return c;
  801819:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    
		return -E_EOF;
  80181f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801824:	eb f7                	jmp    80181d <getchar+0x22>

00801826 <iscons>:
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80182c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182f:	50                   	push   %eax
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	e8 c2 ef ff ff       	call   8007fa <fd_lookup>
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	85 c0                	test   %eax,%eax
  80183d:	78 11                	js     801850 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801848:	39 10                	cmp    %edx,(%eax)
  80184a:	0f 94 c0             	sete   %al
  80184d:	0f b6 c0             	movzbl %al,%eax
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <opencons>:
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801858:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185b:	50                   	push   %eax
  80185c:	e8 4a ef ff ff       	call   8007ab <fd_alloc>
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	78 3a                	js     8018a2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	68 07 04 00 00       	push   $0x407
  801870:	ff 75 f4             	pushl  -0xc(%ebp)
  801873:	6a 00                	push   $0x0
  801875:	e8 fa ec ff ff       	call   800574 <sys_page_alloc>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 21                	js     8018a2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801884:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80188a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	50                   	push   %eax
  80189a:	e8 e5 ee ff ff       	call   800784 <fd2num>
  80189f:	83 c4 10             	add    $0x10,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	56                   	push   %esi
  8018a8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8018a9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8018ac:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8018b2:	e8 7f ec ff ff       	call   800536 <sys_getenvid>
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	56                   	push   %esi
  8018c1:	50                   	push   %eax
  8018c2:	68 44 24 80 00       	push   $0x802444
  8018c7:	e8 b3 00 00 00       	call   80197f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8018cc:	83 c4 18             	add    $0x18,%esp
  8018cf:	53                   	push   %ebx
  8018d0:	ff 75 10             	pushl  0x10(%ebp)
  8018d3:	e8 56 00 00 00       	call   80192e <vcprintf>
	cprintf("\n");
  8018d8:	c7 04 24 30 24 80 00 	movl   $0x802430,(%esp)
  8018df:	e8 9b 00 00 00       	call   80197f <cprintf>
  8018e4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018e7:	cc                   	int3   
  8018e8:	eb fd                	jmp    8018e7 <_panic+0x43>

008018ea <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	53                   	push   %ebx
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018f4:	8b 13                	mov    (%ebx),%edx
  8018f6:	8d 42 01             	lea    0x1(%edx),%eax
  8018f9:	89 03                	mov    %eax,(%ebx)
  8018fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801902:	3d ff 00 00 00       	cmp    $0xff,%eax
  801907:	74 09                	je     801912 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801909:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80190d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801910:	c9                   	leave  
  801911:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801912:	83 ec 08             	sub    $0x8,%esp
  801915:	68 ff 00 00 00       	push   $0xff
  80191a:	8d 43 08             	lea    0x8(%ebx),%eax
  80191d:	50                   	push   %eax
  80191e:	e8 95 eb ff ff       	call   8004b8 <sys_cputs>
		b->idx = 0;
  801923:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	eb db                	jmp    801909 <putch+0x1f>

0080192e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801937:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80193e:	00 00 00 
	b.cnt = 0;
  801941:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801948:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801957:	50                   	push   %eax
  801958:	68 ea 18 80 00       	push   $0x8018ea
  80195d:	e8 1a 01 00 00       	call   801a7c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801962:	83 c4 08             	add    $0x8,%esp
  801965:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80196b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801971:	50                   	push   %eax
  801972:	e8 41 eb ff ff       	call   8004b8 <sys_cputs>

	return b.cnt;
}
  801977:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801985:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801988:	50                   	push   %eax
  801989:	ff 75 08             	pushl  0x8(%ebp)
  80198c:	e8 9d ff ff ff       	call   80192e <vcprintf>
	va_end(ap);

	return cnt;
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	57                   	push   %edi
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
  801999:	83 ec 1c             	sub    $0x1c,%esp
  80199c:	89 c7                	mov    %eax,%edi
  80199e:	89 d6                	mov    %edx,%esi
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8019ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8019b7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8019ba:	39 d3                	cmp    %edx,%ebx
  8019bc:	72 05                	jb     8019c3 <printnum+0x30>
  8019be:	39 45 10             	cmp    %eax,0x10(%ebp)
  8019c1:	77 7a                	ja     801a3d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019c3:	83 ec 0c             	sub    $0xc,%esp
  8019c6:	ff 75 18             	pushl  0x18(%ebp)
  8019c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8019cf:	53                   	push   %ebx
  8019d0:	ff 75 10             	pushl  0x10(%ebp)
  8019d3:	83 ec 08             	sub    $0x8,%esp
  8019d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8019dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8019df:	ff 75 d8             	pushl  -0x28(%ebp)
  8019e2:	e8 b9 06 00 00       	call   8020a0 <__udivdi3>
  8019e7:	83 c4 18             	add    $0x18,%esp
  8019ea:	52                   	push   %edx
  8019eb:	50                   	push   %eax
  8019ec:	89 f2                	mov    %esi,%edx
  8019ee:	89 f8                	mov    %edi,%eax
  8019f0:	e8 9e ff ff ff       	call   801993 <printnum>
  8019f5:	83 c4 20             	add    $0x20,%esp
  8019f8:	eb 13                	jmp    801a0d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	56                   	push   %esi
  8019fe:	ff 75 18             	pushl  0x18(%ebp)
  801a01:	ff d7                	call   *%edi
  801a03:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801a06:	83 eb 01             	sub    $0x1,%ebx
  801a09:	85 db                	test   %ebx,%ebx
  801a0b:	7f ed                	jg     8019fa <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	56                   	push   %esi
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a17:	ff 75 e0             	pushl  -0x20(%ebp)
  801a1a:	ff 75 dc             	pushl  -0x24(%ebp)
  801a1d:	ff 75 d8             	pushl  -0x28(%ebp)
  801a20:	e8 9b 07 00 00       	call   8021c0 <__umoddi3>
  801a25:	83 c4 14             	add    $0x14,%esp
  801a28:	0f be 80 67 24 80 00 	movsbl 0x802467(%eax),%eax
  801a2f:	50                   	push   %eax
  801a30:	ff d7                	call   *%edi
}
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a38:	5b                   	pop    %ebx
  801a39:	5e                   	pop    %esi
  801a3a:	5f                   	pop    %edi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    
  801a3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a40:	eb c4                	jmp    801a06 <printnum+0x73>

00801a42 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a48:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a4c:	8b 10                	mov    (%eax),%edx
  801a4e:	3b 50 04             	cmp    0x4(%eax),%edx
  801a51:	73 0a                	jae    801a5d <sprintputch+0x1b>
		*b->buf++ = ch;
  801a53:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a56:	89 08                	mov    %ecx,(%eax)
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	88 02                	mov    %al,(%edx)
}
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <printfmt>:
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801a65:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a68:	50                   	push   %eax
  801a69:	ff 75 10             	pushl  0x10(%ebp)
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	ff 75 08             	pushl  0x8(%ebp)
  801a72:	e8 05 00 00 00       	call   801a7c <vprintfmt>
}
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <vprintfmt>:
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	57                   	push   %edi
  801a80:	56                   	push   %esi
  801a81:	53                   	push   %ebx
  801a82:	83 ec 2c             	sub    $0x2c,%esp
  801a85:	8b 75 08             	mov    0x8(%ebp),%esi
  801a88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a8b:	8b 7d 10             	mov    0x10(%ebp),%edi
  801a8e:	e9 c1 03 00 00       	jmp    801e54 <vprintfmt+0x3d8>
		padc = ' ';
  801a93:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801a97:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801a9e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801aa5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801aac:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801ab1:	8d 47 01             	lea    0x1(%edi),%eax
  801ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ab7:	0f b6 17             	movzbl (%edi),%edx
  801aba:	8d 42 dd             	lea    -0x23(%edx),%eax
  801abd:	3c 55                	cmp    $0x55,%al
  801abf:	0f 87 12 04 00 00    	ja     801ed7 <vprintfmt+0x45b>
  801ac5:	0f b6 c0             	movzbl %al,%eax
  801ac8:	ff 24 85 a0 25 80 00 	jmp    *0x8025a0(,%eax,4)
  801acf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801ad2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801ad6:	eb d9                	jmp    801ab1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801ad8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801adb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801adf:	eb d0                	jmp    801ab1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801ae1:	0f b6 d2             	movzbl %dl,%edx
  801ae4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801aef:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801af2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801af6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801af9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801afc:	83 f9 09             	cmp    $0x9,%ecx
  801aff:	77 55                	ja     801b56 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801b01:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801b04:	eb e9                	jmp    801aef <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801b06:	8b 45 14             	mov    0x14(%ebp),%eax
  801b09:	8b 00                	mov    (%eax),%eax
  801b0b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	8d 40 04             	lea    0x4(%eax),%eax
  801b14:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801b17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801b1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b1e:	79 91                	jns    801ab1 <vprintfmt+0x35>
				width = precision, precision = -1;
  801b20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b26:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801b2d:	eb 82                	jmp    801ab1 <vprintfmt+0x35>
  801b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b32:	85 c0                	test   %eax,%eax
  801b34:	ba 00 00 00 00       	mov    $0x0,%edx
  801b39:	0f 49 d0             	cmovns %eax,%edx
  801b3c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801b3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801b42:	e9 6a ff ff ff       	jmp    801ab1 <vprintfmt+0x35>
  801b47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801b4a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801b51:	e9 5b ff ff ff       	jmp    801ab1 <vprintfmt+0x35>
  801b56:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801b59:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b5c:	eb bc                	jmp    801b1a <vprintfmt+0x9e>
			lflag++;
  801b5e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801b61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801b64:	e9 48 ff ff ff       	jmp    801ab1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801b69:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6c:	8d 78 04             	lea    0x4(%eax),%edi
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	53                   	push   %ebx
  801b73:	ff 30                	pushl  (%eax)
  801b75:	ff d6                	call   *%esi
			break;
  801b77:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801b7a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801b7d:	e9 cf 02 00 00       	jmp    801e51 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801b82:	8b 45 14             	mov    0x14(%ebp),%eax
  801b85:	8d 78 04             	lea    0x4(%eax),%edi
  801b88:	8b 00                	mov    (%eax),%eax
  801b8a:	99                   	cltd   
  801b8b:	31 d0                	xor    %edx,%eax
  801b8d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b8f:	83 f8 0f             	cmp    $0xf,%eax
  801b92:	7f 23                	jg     801bb7 <vprintfmt+0x13b>
  801b94:	8b 14 85 00 27 80 00 	mov    0x802700(,%eax,4),%edx
  801b9b:	85 d2                	test   %edx,%edx
  801b9d:	74 18                	je     801bb7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801b9f:	52                   	push   %edx
  801ba0:	68 c5 23 80 00       	push   $0x8023c5
  801ba5:	53                   	push   %ebx
  801ba6:	56                   	push   %esi
  801ba7:	e8 b3 fe ff ff       	call   801a5f <printfmt>
  801bac:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801baf:	89 7d 14             	mov    %edi,0x14(%ebp)
  801bb2:	e9 9a 02 00 00       	jmp    801e51 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  801bb7:	50                   	push   %eax
  801bb8:	68 7f 24 80 00       	push   $0x80247f
  801bbd:	53                   	push   %ebx
  801bbe:	56                   	push   %esi
  801bbf:	e8 9b fe ff ff       	call   801a5f <printfmt>
  801bc4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801bc7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801bca:	e9 82 02 00 00       	jmp    801e51 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  801bcf:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd2:	83 c0 04             	add    $0x4,%eax
  801bd5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801bd8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801bdd:	85 ff                	test   %edi,%edi
  801bdf:	b8 78 24 80 00       	mov    $0x802478,%eax
  801be4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801be7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801beb:	0f 8e bd 00 00 00    	jle    801cae <vprintfmt+0x232>
  801bf1:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801bf5:	75 0e                	jne    801c05 <vprintfmt+0x189>
  801bf7:	89 75 08             	mov    %esi,0x8(%ebp)
  801bfa:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801bfd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801c00:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801c03:	eb 6d                	jmp    801c72 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c05:	83 ec 08             	sub    $0x8,%esp
  801c08:	ff 75 d0             	pushl  -0x30(%ebp)
  801c0b:	57                   	push   %edi
  801c0c:	e8 4b e5 ff ff       	call   80015c <strnlen>
  801c11:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c14:	29 c1                	sub    %eax,%ecx
  801c16:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801c19:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801c1c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801c20:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c23:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801c26:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801c28:	eb 0f                	jmp    801c39 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801c2a:	83 ec 08             	sub    $0x8,%esp
  801c2d:	53                   	push   %ebx
  801c2e:	ff 75 e0             	pushl  -0x20(%ebp)
  801c31:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801c33:	83 ef 01             	sub    $0x1,%edi
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	85 ff                	test   %edi,%edi
  801c3b:	7f ed                	jg     801c2a <vprintfmt+0x1ae>
  801c3d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801c40:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801c43:	85 c9                	test   %ecx,%ecx
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4a:	0f 49 c1             	cmovns %ecx,%eax
  801c4d:	29 c1                	sub    %eax,%ecx
  801c4f:	89 75 08             	mov    %esi,0x8(%ebp)
  801c52:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801c55:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801c58:	89 cb                	mov    %ecx,%ebx
  801c5a:	eb 16                	jmp    801c72 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801c5c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c60:	75 31                	jne    801c93 <vprintfmt+0x217>
					putch(ch, putdat);
  801c62:	83 ec 08             	sub    $0x8,%esp
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	50                   	push   %eax
  801c69:	ff 55 08             	call   *0x8(%ebp)
  801c6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c6f:	83 eb 01             	sub    $0x1,%ebx
  801c72:	83 c7 01             	add    $0x1,%edi
  801c75:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801c79:	0f be c2             	movsbl %dl,%eax
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	74 59                	je     801cd9 <vprintfmt+0x25d>
  801c80:	85 f6                	test   %esi,%esi
  801c82:	78 d8                	js     801c5c <vprintfmt+0x1e0>
  801c84:	83 ee 01             	sub    $0x1,%esi
  801c87:	79 d3                	jns    801c5c <vprintfmt+0x1e0>
  801c89:	89 df                	mov    %ebx,%edi
  801c8b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c91:	eb 37                	jmp    801cca <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801c93:	0f be d2             	movsbl %dl,%edx
  801c96:	83 ea 20             	sub    $0x20,%edx
  801c99:	83 fa 5e             	cmp    $0x5e,%edx
  801c9c:	76 c4                	jbe    801c62 <vprintfmt+0x1e6>
					putch('?', putdat);
  801c9e:	83 ec 08             	sub    $0x8,%esp
  801ca1:	ff 75 0c             	pushl  0xc(%ebp)
  801ca4:	6a 3f                	push   $0x3f
  801ca6:	ff 55 08             	call   *0x8(%ebp)
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	eb c1                	jmp    801c6f <vprintfmt+0x1f3>
  801cae:	89 75 08             	mov    %esi,0x8(%ebp)
  801cb1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801cb4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801cb7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801cba:	eb b6                	jmp    801c72 <vprintfmt+0x1f6>
				putch(' ', putdat);
  801cbc:	83 ec 08             	sub    $0x8,%esp
  801cbf:	53                   	push   %ebx
  801cc0:	6a 20                	push   $0x20
  801cc2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801cc4:	83 ef 01             	sub    $0x1,%edi
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	85 ff                	test   %edi,%edi
  801ccc:	7f ee                	jg     801cbc <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cd1:	89 45 14             	mov    %eax,0x14(%ebp)
  801cd4:	e9 78 01 00 00       	jmp    801e51 <vprintfmt+0x3d5>
  801cd9:	89 df                	mov    %ebx,%edi
  801cdb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ce1:	eb e7                	jmp    801cca <vprintfmt+0x24e>
	if (lflag >= 2)
  801ce3:	83 f9 01             	cmp    $0x1,%ecx
  801ce6:	7e 3f                	jle    801d27 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  801ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ceb:	8b 50 04             	mov    0x4(%eax),%edx
  801cee:	8b 00                	mov    (%eax),%eax
  801cf0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cf3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801cf6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf9:	8d 40 08             	lea    0x8(%eax),%eax
  801cfc:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801cff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801d03:	79 5c                	jns    801d61 <vprintfmt+0x2e5>
				putch('-', putdat);
  801d05:	83 ec 08             	sub    $0x8,%esp
  801d08:	53                   	push   %ebx
  801d09:	6a 2d                	push   $0x2d
  801d0b:	ff d6                	call   *%esi
				num = -(long long) num;
  801d0d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d10:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801d13:	f7 da                	neg    %edx
  801d15:	83 d1 00             	adc    $0x0,%ecx
  801d18:	f7 d9                	neg    %ecx
  801d1a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801d1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d22:	e9 10 01 00 00       	jmp    801e37 <vprintfmt+0x3bb>
	else if (lflag)
  801d27:	85 c9                	test   %ecx,%ecx
  801d29:	75 1b                	jne    801d46 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2e:	8b 00                	mov    (%eax),%eax
  801d30:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d33:	89 c1                	mov    %eax,%ecx
  801d35:	c1 f9 1f             	sar    $0x1f,%ecx
  801d38:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3e:	8d 40 04             	lea    0x4(%eax),%eax
  801d41:	89 45 14             	mov    %eax,0x14(%ebp)
  801d44:	eb b9                	jmp    801cff <vprintfmt+0x283>
		return va_arg(*ap, long);
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	8b 00                	mov    (%eax),%eax
  801d4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d4e:	89 c1                	mov    %eax,%ecx
  801d50:	c1 f9 1f             	sar    $0x1f,%ecx
  801d53:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d56:	8b 45 14             	mov    0x14(%ebp),%eax
  801d59:	8d 40 04             	lea    0x4(%eax),%eax
  801d5c:	89 45 14             	mov    %eax,0x14(%ebp)
  801d5f:	eb 9e                	jmp    801cff <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801d61:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d64:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801d67:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d6c:	e9 c6 00 00 00       	jmp    801e37 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801d71:	83 f9 01             	cmp    $0x1,%ecx
  801d74:	7e 18                	jle    801d8e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801d76:	8b 45 14             	mov    0x14(%ebp),%eax
  801d79:	8b 10                	mov    (%eax),%edx
  801d7b:	8b 48 04             	mov    0x4(%eax),%ecx
  801d7e:	8d 40 08             	lea    0x8(%eax),%eax
  801d81:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801d84:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d89:	e9 a9 00 00 00       	jmp    801e37 <vprintfmt+0x3bb>
	else if (lflag)
  801d8e:	85 c9                	test   %ecx,%ecx
  801d90:	75 1a                	jne    801dac <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  801d92:	8b 45 14             	mov    0x14(%ebp),%eax
  801d95:	8b 10                	mov    (%eax),%edx
  801d97:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d9c:	8d 40 04             	lea    0x4(%eax),%eax
  801d9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801da2:	b8 0a 00 00 00       	mov    $0xa,%eax
  801da7:	e9 8b 00 00 00       	jmp    801e37 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801dac:	8b 45 14             	mov    0x14(%ebp),%eax
  801daf:	8b 10                	mov    (%eax),%edx
  801db1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db6:	8d 40 04             	lea    0x4(%eax),%eax
  801db9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801dbc:	b8 0a 00 00 00       	mov    $0xa,%eax
  801dc1:	eb 74                	jmp    801e37 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801dc3:	83 f9 01             	cmp    $0x1,%ecx
  801dc6:	7e 15                	jle    801ddd <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  801dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcb:	8b 10                	mov    (%eax),%edx
  801dcd:	8b 48 04             	mov    0x4(%eax),%ecx
  801dd0:	8d 40 08             	lea    0x8(%eax),%eax
  801dd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801dd6:	b8 08 00 00 00       	mov    $0x8,%eax
  801ddb:	eb 5a                	jmp    801e37 <vprintfmt+0x3bb>
	else if (lflag)
  801ddd:	85 c9                	test   %ecx,%ecx
  801ddf:	75 17                	jne    801df8 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  801de1:	8b 45 14             	mov    0x14(%ebp),%eax
  801de4:	8b 10                	mov    (%eax),%edx
  801de6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801deb:	8d 40 04             	lea    0x4(%eax),%eax
  801dee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801df1:	b8 08 00 00 00       	mov    $0x8,%eax
  801df6:	eb 3f                	jmp    801e37 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801df8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dfb:	8b 10                	mov    (%eax),%edx
  801dfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e02:	8d 40 04             	lea    0x4(%eax),%eax
  801e05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801e08:	b8 08 00 00 00       	mov    $0x8,%eax
  801e0d:	eb 28                	jmp    801e37 <vprintfmt+0x3bb>
			putch('0', putdat);
  801e0f:	83 ec 08             	sub    $0x8,%esp
  801e12:	53                   	push   %ebx
  801e13:	6a 30                	push   $0x30
  801e15:	ff d6                	call   *%esi
			putch('x', putdat);
  801e17:	83 c4 08             	add    $0x8,%esp
  801e1a:	53                   	push   %ebx
  801e1b:	6a 78                	push   $0x78
  801e1d:	ff d6                	call   *%esi
			num = (unsigned long long)
  801e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e22:	8b 10                	mov    (%eax),%edx
  801e24:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801e29:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801e2c:	8d 40 04             	lea    0x4(%eax),%eax
  801e2f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801e32:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801e37:	83 ec 0c             	sub    $0xc,%esp
  801e3a:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801e3e:	57                   	push   %edi
  801e3f:	ff 75 e0             	pushl  -0x20(%ebp)
  801e42:	50                   	push   %eax
  801e43:	51                   	push   %ecx
  801e44:	52                   	push   %edx
  801e45:	89 da                	mov    %ebx,%edx
  801e47:	89 f0                	mov    %esi,%eax
  801e49:	e8 45 fb ff ff       	call   801993 <printnum>
			break;
  801e4e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801e51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e54:	83 c7 01             	add    $0x1,%edi
  801e57:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801e5b:	83 f8 25             	cmp    $0x25,%eax
  801e5e:	0f 84 2f fc ff ff    	je     801a93 <vprintfmt+0x17>
			if (ch == '\0')
  801e64:	85 c0                	test   %eax,%eax
  801e66:	0f 84 8b 00 00 00    	je     801ef7 <vprintfmt+0x47b>
			putch(ch, putdat);
  801e6c:	83 ec 08             	sub    $0x8,%esp
  801e6f:	53                   	push   %ebx
  801e70:	50                   	push   %eax
  801e71:	ff d6                	call   *%esi
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	eb dc                	jmp    801e54 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801e78:	83 f9 01             	cmp    $0x1,%ecx
  801e7b:	7e 15                	jle    801e92 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e80:	8b 10                	mov    (%eax),%edx
  801e82:	8b 48 04             	mov    0x4(%eax),%ecx
  801e85:	8d 40 08             	lea    0x8(%eax),%eax
  801e88:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801e8b:	b8 10 00 00 00       	mov    $0x10,%eax
  801e90:	eb a5                	jmp    801e37 <vprintfmt+0x3bb>
	else if (lflag)
  801e92:	85 c9                	test   %ecx,%ecx
  801e94:	75 17                	jne    801ead <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801e96:	8b 45 14             	mov    0x14(%ebp),%eax
  801e99:	8b 10                	mov    (%eax),%edx
  801e9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ea0:	8d 40 04             	lea    0x4(%eax),%eax
  801ea3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ea6:	b8 10 00 00 00       	mov    $0x10,%eax
  801eab:	eb 8a                	jmp    801e37 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801ead:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb0:	8b 10                	mov    (%eax),%edx
  801eb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eb7:	8d 40 04             	lea    0x4(%eax),%eax
  801eba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ebd:	b8 10 00 00 00       	mov    $0x10,%eax
  801ec2:	e9 70 ff ff ff       	jmp    801e37 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801ec7:	83 ec 08             	sub    $0x8,%esp
  801eca:	53                   	push   %ebx
  801ecb:	6a 25                	push   $0x25
  801ecd:	ff d6                	call   *%esi
			break;
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	e9 7a ff ff ff       	jmp    801e51 <vprintfmt+0x3d5>
			putch('%', putdat);
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	53                   	push   %ebx
  801edb:	6a 25                	push   $0x25
  801edd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	89 f8                	mov    %edi,%eax
  801ee4:	eb 03                	jmp    801ee9 <vprintfmt+0x46d>
  801ee6:	83 e8 01             	sub    $0x1,%eax
  801ee9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801eed:	75 f7                	jne    801ee6 <vprintfmt+0x46a>
  801eef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ef2:	e9 5a ff ff ff       	jmp    801e51 <vprintfmt+0x3d5>
}
  801ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801efa:	5b                   	pop    %ebx
  801efb:	5e                   	pop    %esi
  801efc:	5f                   	pop    %edi
  801efd:	5d                   	pop    %ebp
  801efe:	c3                   	ret    

00801eff <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 18             	sub    $0x18,%esp
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f0e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801f12:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801f15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	74 26                	je     801f46 <vsnprintf+0x47>
  801f20:	85 d2                	test   %edx,%edx
  801f22:	7e 22                	jle    801f46 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f24:	ff 75 14             	pushl  0x14(%ebp)
  801f27:	ff 75 10             	pushl  0x10(%ebp)
  801f2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f2d:	50                   	push   %eax
  801f2e:	68 42 1a 80 00       	push   $0x801a42
  801f33:	e8 44 fb ff ff       	call   801a7c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	83 c4 10             	add    $0x10,%esp
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    
		return -E_INVAL;
  801f46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f4b:	eb f7                	jmp    801f44 <vsnprintf+0x45>

00801f4d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f53:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f56:	50                   	push   %eax
  801f57:	ff 75 10             	pushl  0x10(%ebp)
  801f5a:	ff 75 0c             	pushl  0xc(%ebp)
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	e8 9a ff ff ff       	call   801eff <vsnprintf>
	va_end(ap);

	return rc;
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	56                   	push   %esi
  801f6b:	53                   	push   %ebx
  801f6c:	8b 75 08             	mov    0x8(%ebp),%esi
  801f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f75:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f77:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f7c:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	50                   	push   %eax
  801f83:	e8 9c e7 ff ff       	call   800724 <sys_ipc_recv>
	if (from_env_store)
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	85 f6                	test   %esi,%esi
  801f8d:	74 14                	je     801fa3 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 09                	js     801fa1 <ipc_recv+0x3a>
  801f98:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f9e:	8b 52 74             	mov    0x74(%edx),%edx
  801fa1:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801fa3:	85 db                	test   %ebx,%ebx
  801fa5:	74 14                	je     801fbb <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 09                	js     801fb9 <ipc_recv+0x52>
  801fb0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fb6:	8b 52 78             	mov    0x78(%edx),%edx
  801fb9:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 08                	js     801fc7 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801fbf:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc4:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801fc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fca:	5b                   	pop    %ebx
  801fcb:	5e                   	pop    %esi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    

00801fce <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	57                   	push   %edi
  801fd2:	56                   	push   %esi
  801fd3:	53                   	push   %ebx
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fda:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801fe0:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801fe2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fe7:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801fea:	ff 75 14             	pushl  0x14(%ebp)
  801fed:	53                   	push   %ebx
  801fee:	56                   	push   %esi
  801fef:	57                   	push   %edi
  801ff0:	e8 0c e7 ff ff       	call   800701 <sys_ipc_try_send>
		if (ret == 0)
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	74 1e                	je     80201a <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801ffc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fff:	75 07                	jne    802008 <ipc_send+0x3a>
			sys_yield();
  802001:	e8 4f e5 ff ff       	call   800555 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802006:	eb e2                	jmp    801fea <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802008:	50                   	push   %eax
  802009:	68 60 27 80 00       	push   $0x802760
  80200e:	6a 3d                	push   $0x3d
  802010:	68 74 27 80 00       	push   $0x802774
  802015:	e8 8a f8 ff ff       	call   8018a4 <_panic>
	}
	// panic("ipc_send not implemented");
}
  80201a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5f                   	pop    %edi
  802020:	5d                   	pop    %ebp
  802021:	c3                   	ret    

00802022 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80202d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802030:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802036:	8b 52 50             	mov    0x50(%edx),%edx
  802039:	39 ca                	cmp    %ecx,%edx
  80203b:	74 11                	je     80204e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80203d:	83 c0 01             	add    $0x1,%eax
  802040:	3d 00 04 00 00       	cmp    $0x400,%eax
  802045:	75 e6                	jne    80202d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	eb 0b                	jmp    802059 <ipc_find_env+0x37>
			return envs[i].env_id;
  80204e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802051:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802056:	8b 40 48             	mov    0x48(%eax),%eax
}
  802059:	5d                   	pop    %ebp
  80205a:	c3                   	ret    

0080205b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802061:	89 d0                	mov    %edx,%eax
  802063:	c1 e8 16             	shr    $0x16,%eax
  802066:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802072:	f6 c1 01             	test   $0x1,%cl
  802075:	74 1d                	je     802094 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802077:	c1 ea 0c             	shr    $0xc,%edx
  80207a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802081:	f6 c2 01             	test   $0x1,%dl
  802084:	74 0e                	je     802094 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802086:	c1 ea 0c             	shr    $0xc,%edx
  802089:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802090:	ef 
  802091:	0f b7 c0             	movzwl %ax,%eax
}
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    
  802096:	66 90                	xchg   %ax,%ax
  802098:	66 90                	xchg   %ax,%ax
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	66 90                	xchg   %ax,%ax
  80209e:	66 90                	xchg   %ax,%ax

008020a0 <__udivdi3>:
  8020a0:	55                   	push   %ebp
  8020a1:	57                   	push   %edi
  8020a2:	56                   	push   %esi
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 1c             	sub    $0x1c,%esp
  8020a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020b7:	85 d2                	test   %edx,%edx
  8020b9:	75 35                	jne    8020f0 <__udivdi3+0x50>
  8020bb:	39 f3                	cmp    %esi,%ebx
  8020bd:	0f 87 bd 00 00 00    	ja     802180 <__udivdi3+0xe0>
  8020c3:	85 db                	test   %ebx,%ebx
  8020c5:	89 d9                	mov    %ebx,%ecx
  8020c7:	75 0b                	jne    8020d4 <__udivdi3+0x34>
  8020c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ce:	31 d2                	xor    %edx,%edx
  8020d0:	f7 f3                	div    %ebx
  8020d2:	89 c1                	mov    %eax,%ecx
  8020d4:	31 d2                	xor    %edx,%edx
  8020d6:	89 f0                	mov    %esi,%eax
  8020d8:	f7 f1                	div    %ecx
  8020da:	89 c6                	mov    %eax,%esi
  8020dc:	89 e8                	mov    %ebp,%eax
  8020de:	89 f7                	mov    %esi,%edi
  8020e0:	f7 f1                	div    %ecx
  8020e2:	89 fa                	mov    %edi,%edx
  8020e4:	83 c4 1c             	add    $0x1c,%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    
  8020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	39 f2                	cmp    %esi,%edx
  8020f2:	77 7c                	ja     802170 <__udivdi3+0xd0>
  8020f4:	0f bd fa             	bsr    %edx,%edi
  8020f7:	83 f7 1f             	xor    $0x1f,%edi
  8020fa:	0f 84 98 00 00 00    	je     802198 <__udivdi3+0xf8>
  802100:	89 f9                	mov    %edi,%ecx
  802102:	b8 20 00 00 00       	mov    $0x20,%eax
  802107:	29 f8                	sub    %edi,%eax
  802109:	d3 e2                	shl    %cl,%edx
  80210b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80210f:	89 c1                	mov    %eax,%ecx
  802111:	89 da                	mov    %ebx,%edx
  802113:	d3 ea                	shr    %cl,%edx
  802115:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802119:	09 d1                	or     %edx,%ecx
  80211b:	89 f2                	mov    %esi,%edx
  80211d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802121:	89 f9                	mov    %edi,%ecx
  802123:	d3 e3                	shl    %cl,%ebx
  802125:	89 c1                	mov    %eax,%ecx
  802127:	d3 ea                	shr    %cl,%edx
  802129:	89 f9                	mov    %edi,%ecx
  80212b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80212f:	d3 e6                	shl    %cl,%esi
  802131:	89 eb                	mov    %ebp,%ebx
  802133:	89 c1                	mov    %eax,%ecx
  802135:	d3 eb                	shr    %cl,%ebx
  802137:	09 de                	or     %ebx,%esi
  802139:	89 f0                	mov    %esi,%eax
  80213b:	f7 74 24 08          	divl   0x8(%esp)
  80213f:	89 d6                	mov    %edx,%esi
  802141:	89 c3                	mov    %eax,%ebx
  802143:	f7 64 24 0c          	mull   0xc(%esp)
  802147:	39 d6                	cmp    %edx,%esi
  802149:	72 0c                	jb     802157 <__udivdi3+0xb7>
  80214b:	89 f9                	mov    %edi,%ecx
  80214d:	d3 e5                	shl    %cl,%ebp
  80214f:	39 c5                	cmp    %eax,%ebp
  802151:	73 5d                	jae    8021b0 <__udivdi3+0x110>
  802153:	39 d6                	cmp    %edx,%esi
  802155:	75 59                	jne    8021b0 <__udivdi3+0x110>
  802157:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80215a:	31 ff                	xor    %edi,%edi
  80215c:	89 fa                	mov    %edi,%edx
  80215e:	83 c4 1c             	add    $0x1c,%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    
  802166:	8d 76 00             	lea    0x0(%esi),%esi
  802169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802170:	31 ff                	xor    %edi,%edi
  802172:	31 c0                	xor    %eax,%eax
  802174:	89 fa                	mov    %edi,%edx
  802176:	83 c4 1c             	add    $0x1c,%esp
  802179:	5b                   	pop    %ebx
  80217a:	5e                   	pop    %esi
  80217b:	5f                   	pop    %edi
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    
  80217e:	66 90                	xchg   %ax,%ax
  802180:	31 ff                	xor    %edi,%edi
  802182:	89 e8                	mov    %ebp,%eax
  802184:	89 f2                	mov    %esi,%edx
  802186:	f7 f3                	div    %ebx
  802188:	89 fa                	mov    %edi,%edx
  80218a:	83 c4 1c             	add    $0x1c,%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5e                   	pop    %esi
  80218f:	5f                   	pop    %edi
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    
  802192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802198:	39 f2                	cmp    %esi,%edx
  80219a:	72 06                	jb     8021a2 <__udivdi3+0x102>
  80219c:	31 c0                	xor    %eax,%eax
  80219e:	39 eb                	cmp    %ebp,%ebx
  8021a0:	77 d2                	ja     802174 <__udivdi3+0xd4>
  8021a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a7:	eb cb                	jmp    802174 <__udivdi3+0xd4>
  8021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	89 d8                	mov    %ebx,%eax
  8021b2:	31 ff                	xor    %edi,%edi
  8021b4:	eb be                	jmp    802174 <__udivdi3+0xd4>
  8021b6:	66 90                	xchg   %ax,%ax
  8021b8:	66 90                	xchg   %ax,%ax
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__umoddi3>:
  8021c0:	55                   	push   %ebp
  8021c1:	57                   	push   %edi
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 1c             	sub    $0x1c,%esp
  8021c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021d7:	85 ed                	test   %ebp,%ebp
  8021d9:	89 f0                	mov    %esi,%eax
  8021db:	89 da                	mov    %ebx,%edx
  8021dd:	75 19                	jne    8021f8 <__umoddi3+0x38>
  8021df:	39 df                	cmp    %ebx,%edi
  8021e1:	0f 86 b1 00 00 00    	jbe    802298 <__umoddi3+0xd8>
  8021e7:	f7 f7                	div    %edi
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	39 dd                	cmp    %ebx,%ebp
  8021fa:	77 f1                	ja     8021ed <__umoddi3+0x2d>
  8021fc:	0f bd cd             	bsr    %ebp,%ecx
  8021ff:	83 f1 1f             	xor    $0x1f,%ecx
  802202:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802206:	0f 84 b4 00 00 00    	je     8022c0 <__umoddi3+0x100>
  80220c:	b8 20 00 00 00       	mov    $0x20,%eax
  802211:	89 c2                	mov    %eax,%edx
  802213:	8b 44 24 04          	mov    0x4(%esp),%eax
  802217:	29 c2                	sub    %eax,%edx
  802219:	89 c1                	mov    %eax,%ecx
  80221b:	89 f8                	mov    %edi,%eax
  80221d:	d3 e5                	shl    %cl,%ebp
  80221f:	89 d1                	mov    %edx,%ecx
  802221:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802225:	d3 e8                	shr    %cl,%eax
  802227:	09 c5                	or     %eax,%ebp
  802229:	8b 44 24 04          	mov    0x4(%esp),%eax
  80222d:	89 c1                	mov    %eax,%ecx
  80222f:	d3 e7                	shl    %cl,%edi
  802231:	89 d1                	mov    %edx,%ecx
  802233:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802237:	89 df                	mov    %ebx,%edi
  802239:	d3 ef                	shr    %cl,%edi
  80223b:	89 c1                	mov    %eax,%ecx
  80223d:	89 f0                	mov    %esi,%eax
  80223f:	d3 e3                	shl    %cl,%ebx
  802241:	89 d1                	mov    %edx,%ecx
  802243:	89 fa                	mov    %edi,%edx
  802245:	d3 e8                	shr    %cl,%eax
  802247:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80224c:	09 d8                	or     %ebx,%eax
  80224e:	f7 f5                	div    %ebp
  802250:	d3 e6                	shl    %cl,%esi
  802252:	89 d1                	mov    %edx,%ecx
  802254:	f7 64 24 08          	mull   0x8(%esp)
  802258:	39 d1                	cmp    %edx,%ecx
  80225a:	89 c3                	mov    %eax,%ebx
  80225c:	89 d7                	mov    %edx,%edi
  80225e:	72 06                	jb     802266 <__umoddi3+0xa6>
  802260:	75 0e                	jne    802270 <__umoddi3+0xb0>
  802262:	39 c6                	cmp    %eax,%esi
  802264:	73 0a                	jae    802270 <__umoddi3+0xb0>
  802266:	2b 44 24 08          	sub    0x8(%esp),%eax
  80226a:	19 ea                	sbb    %ebp,%edx
  80226c:	89 d7                	mov    %edx,%edi
  80226e:	89 c3                	mov    %eax,%ebx
  802270:	89 ca                	mov    %ecx,%edx
  802272:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802277:	29 de                	sub    %ebx,%esi
  802279:	19 fa                	sbb    %edi,%edx
  80227b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	d3 e0                	shl    %cl,%eax
  802283:	89 d9                	mov    %ebx,%ecx
  802285:	d3 ee                	shr    %cl,%esi
  802287:	d3 ea                	shr    %cl,%edx
  802289:	09 f0                	or     %esi,%eax
  80228b:	83 c4 1c             	add    $0x1c,%esp
  80228e:	5b                   	pop    %ebx
  80228f:	5e                   	pop    %esi
  802290:	5f                   	pop    %edi
  802291:	5d                   	pop    %ebp
  802292:	c3                   	ret    
  802293:	90                   	nop
  802294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802298:	85 ff                	test   %edi,%edi
  80229a:	89 f9                	mov    %edi,%ecx
  80229c:	75 0b                	jne    8022a9 <__umoddi3+0xe9>
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	31 d2                	xor    %edx,%edx
  8022a5:	f7 f7                	div    %edi
  8022a7:	89 c1                	mov    %eax,%ecx
  8022a9:	89 d8                	mov    %ebx,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 f0                	mov    %esi,%eax
  8022b1:	f7 f1                	div    %ecx
  8022b3:	e9 31 ff ff ff       	jmp    8021e9 <__umoddi3+0x29>
  8022b8:	90                   	nop
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	39 dd                	cmp    %ebx,%ebp
  8022c2:	72 08                	jb     8022cc <__umoddi3+0x10c>
  8022c4:	39 f7                	cmp    %esi,%edi
  8022c6:	0f 87 21 ff ff ff    	ja     8021ed <__umoddi3+0x2d>
  8022cc:	89 da                	mov    %ebx,%edx
  8022ce:	89 f0                	mov    %esi,%eax
  8022d0:	29 f8                	sub    %edi,%eax
  8022d2:	19 ea                	sbb    %ebp,%edx
  8022d4:	e9 14 ff ff ff       	jmp    8021ed <__umoddi3+0x2d>


obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 30 80 00    	pushl  0x803000
  800044:	e8 65 00 00 00       	call   8000ae <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 ce 00 00 00       	call   80012c <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 b1 04 00 00       	call   800550 <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 42 00 00 00       	call   8000eb <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bf:	89 c3                	mov    %eax,%ebx
  8000c1:	89 c7                	mov    %eax,%edi
  8000c3:	89 c6                	mov    %eax,%esi
  8000c5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	57                   	push   %edi
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000dc:	89 d1                	mov    %edx,%ecx
  8000de:	89 d3                	mov    %edx,%ebx
  8000e0:	89 d7                	mov    %edx,%edi
  8000e2:	89 d6                	mov    %edx,%esi
  8000e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800101:	89 cb                	mov    %ecx,%ebx
  800103:	89 cf                	mov    %ecx,%edi
  800105:	89 ce                	mov    %ecx,%esi
  800107:	cd 30                	int    $0x30
	if(check && ret > 0)
  800109:	85 c0                	test   %eax,%eax
  80010b:	7f 08                	jg     800115 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5f                   	pop    %edi
  800113:	5d                   	pop    %ebp
  800114:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	50                   	push   %eax
  800119:	6a 03                	push   $0x3
  80011b:	68 58 22 80 00       	push   $0x802258
  800120:	6a 23                	push   $0x23
  800122:	68 75 22 80 00       	push   $0x802275
  800127:	e8 6e 13 00 00       	call   80149a <_panic>

0080012c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	57                   	push   %edi
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
	asm volatile("int %1\n"
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	b8 02 00 00 00       	mov    $0x2,%eax
  80013c:	89 d1                	mov    %edx,%ecx
  80013e:	89 d3                	mov    %edx,%ebx
  800140:	89 d7                	mov    %edx,%edi
  800142:	89 d6                	mov    %edx,%esi
  800144:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    

0080014b <sys_yield>:

void
sys_yield(void)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	57                   	push   %edi
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
	asm volatile("int %1\n"
  800151:	ba 00 00 00 00       	mov    $0x0,%edx
  800156:	b8 0b 00 00 00       	mov    $0xb,%eax
  80015b:	89 d1                	mov    %edx,%ecx
  80015d:	89 d3                	mov    %edx,%ebx
  80015f:	89 d7                	mov    %edx,%edi
  800161:	89 d6                	mov    %edx,%esi
  800163:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5f                   	pop    %edi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    

0080016a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	57                   	push   %edi
  80016e:	56                   	push   %esi
  80016f:	53                   	push   %ebx
  800170:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800173:	be 00 00 00 00       	mov    $0x0,%esi
  800178:	8b 55 08             	mov    0x8(%ebp),%edx
  80017b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017e:	b8 04 00 00 00       	mov    $0x4,%eax
  800183:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800186:	89 f7                	mov    %esi,%edi
  800188:	cd 30                	int    $0x30
	if(check && ret > 0)
  80018a:	85 c0                	test   %eax,%eax
  80018c:	7f 08                	jg     800196 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800191:	5b                   	pop    %ebx
  800192:	5e                   	pop    %esi
  800193:	5f                   	pop    %edi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	50                   	push   %eax
  80019a:	6a 04                	push   $0x4
  80019c:	68 58 22 80 00       	push   $0x802258
  8001a1:	6a 23                	push   $0x23
  8001a3:	68 75 22 80 00       	push   $0x802275
  8001a8:	e8 ed 12 00 00       	call   80149a <_panic>

008001ad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	57                   	push   %edi
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bc:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	7f 08                	jg     8001d8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d3:	5b                   	pop    %ebx
  8001d4:	5e                   	pop    %esi
  8001d5:	5f                   	pop    %edi
  8001d6:	5d                   	pop    %ebp
  8001d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d8:	83 ec 0c             	sub    $0xc,%esp
  8001db:	50                   	push   %eax
  8001dc:	6a 05                	push   $0x5
  8001de:	68 58 22 80 00       	push   $0x802258
  8001e3:	6a 23                	push   $0x23
  8001e5:	68 75 22 80 00       	push   $0x802275
  8001ea:	e8 ab 12 00 00       	call   80149a <_panic>

008001ef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	57                   	push   %edi
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800203:	b8 06 00 00 00       	mov    $0x6,%eax
  800208:	89 df                	mov    %ebx,%edi
  80020a:	89 de                	mov    %ebx,%esi
  80020c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020e:	85 c0                	test   %eax,%eax
  800210:	7f 08                	jg     80021a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	50                   	push   %eax
  80021e:	6a 06                	push   $0x6
  800220:	68 58 22 80 00       	push   $0x802258
  800225:	6a 23                	push   $0x23
  800227:	68 75 22 80 00       	push   $0x802275
  80022c:	e8 69 12 00 00       	call   80149a <_panic>

00800231 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	57                   	push   %edi
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
  800237:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023f:	8b 55 08             	mov    0x8(%ebp),%edx
  800242:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800245:	b8 08 00 00 00       	mov    $0x8,%eax
  80024a:	89 df                	mov    %ebx,%edi
  80024c:	89 de                	mov    %ebx,%esi
  80024e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800250:	85 c0                	test   %eax,%eax
  800252:	7f 08                	jg     80025c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800254:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800257:	5b                   	pop    %ebx
  800258:	5e                   	pop    %esi
  800259:	5f                   	pop    %edi
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	6a 08                	push   $0x8
  800262:	68 58 22 80 00       	push   $0x802258
  800267:	6a 23                	push   $0x23
  800269:	68 75 22 80 00       	push   $0x802275
  80026e:	e8 27 12 00 00       	call   80149a <_panic>

00800273 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800281:	8b 55 08             	mov    0x8(%ebp),%edx
  800284:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800287:	b8 09 00 00 00       	mov    $0x9,%eax
  80028c:	89 df                	mov    %ebx,%edi
  80028e:	89 de                	mov    %ebx,%esi
  800290:	cd 30                	int    $0x30
	if(check && ret > 0)
  800292:	85 c0                	test   %eax,%eax
  800294:	7f 08                	jg     80029e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029e:	83 ec 0c             	sub    $0xc,%esp
  8002a1:	50                   	push   %eax
  8002a2:	6a 09                	push   $0x9
  8002a4:	68 58 22 80 00       	push   $0x802258
  8002a9:	6a 23                	push   $0x23
  8002ab:	68 75 22 80 00       	push   $0x802275
  8002b0:	e8 e5 11 00 00       	call   80149a <_panic>

008002b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	57                   	push   %edi
  8002b9:	56                   	push   %esi
  8002ba:	53                   	push   %ebx
  8002bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ce:	89 df                	mov    %ebx,%edi
  8002d0:	89 de                	mov    %ebx,%esi
  8002d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d4:	85 c0                	test   %eax,%eax
  8002d6:	7f 08                	jg     8002e0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002db:	5b                   	pop    %ebx
  8002dc:	5e                   	pop    %esi
  8002dd:	5f                   	pop    %edi
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	50                   	push   %eax
  8002e4:	6a 0a                	push   $0xa
  8002e6:	68 58 22 80 00       	push   $0x802258
  8002eb:	6a 23                	push   $0x23
  8002ed:	68 75 22 80 00       	push   $0x802275
  8002f2:	e8 a3 11 00 00       	call   80149a <_panic>

008002f7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800300:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800303:	b8 0c 00 00 00       	mov    $0xc,%eax
  800308:	be 00 00 00 00       	mov    $0x0,%esi
  80030d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800310:	8b 7d 14             	mov    0x14(%ebp),%edi
  800313:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800315:	5b                   	pop    %ebx
  800316:	5e                   	pop    %esi
  800317:	5f                   	pop    %edi
  800318:	5d                   	pop    %ebp
  800319:	c3                   	ret    

0080031a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800323:	b9 00 00 00 00       	mov    $0x0,%ecx
  800328:	8b 55 08             	mov    0x8(%ebp),%edx
  80032b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800330:	89 cb                	mov    %ecx,%ebx
  800332:	89 cf                	mov    %ecx,%edi
  800334:	89 ce                	mov    %ecx,%esi
  800336:	cd 30                	int    $0x30
	if(check && ret > 0)
  800338:	85 c0                	test   %eax,%eax
  80033a:	7f 08                	jg     800344 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80033c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033f:	5b                   	pop    %ebx
  800340:	5e                   	pop    %esi
  800341:	5f                   	pop    %edi
  800342:	5d                   	pop    %ebp
  800343:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800344:	83 ec 0c             	sub    $0xc,%esp
  800347:	50                   	push   %eax
  800348:	6a 0d                	push   $0xd
  80034a:	68 58 22 80 00       	push   $0x802258
  80034f:	6a 23                	push   $0x23
  800351:	68 75 22 80 00       	push   $0x802275
  800356:	e8 3f 11 00 00       	call   80149a <_panic>

0080035b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	57                   	push   %edi
  80035f:	56                   	push   %esi
  800360:	53                   	push   %ebx
	asm volatile("int %1\n"
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	b8 0e 00 00 00       	mov    $0xe,%eax
  80036b:	89 d1                	mov    %edx,%ecx
  80036d:	89 d3                	mov    %edx,%ebx
  80036f:	89 d7                	mov    %edx,%edi
  800371:	89 d6                	mov    %edx,%esi
  800373:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800375:	5b                   	pop    %ebx
  800376:	5e                   	pop    %esi
  800377:	5f                   	pop    %edi
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	05 00 00 00 30       	add    $0x30000000,%eax
  800385:	c1 e8 0c             	shr    $0xc,%eax
}
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    

0080038a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80038d:	8b 45 08             	mov    0x8(%ebp),%eax
  800390:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800395:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003ac:	89 c2                	mov    %eax,%edx
  8003ae:	c1 ea 16             	shr    $0x16,%edx
  8003b1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b8:	f6 c2 01             	test   $0x1,%dl
  8003bb:	74 2a                	je     8003e7 <fd_alloc+0x46>
  8003bd:	89 c2                	mov    %eax,%edx
  8003bf:	c1 ea 0c             	shr    $0xc,%edx
  8003c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c9:	f6 c2 01             	test   $0x1,%dl
  8003cc:	74 19                	je     8003e7 <fd_alloc+0x46>
  8003ce:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003d3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d8:	75 d2                	jne    8003ac <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003da:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003e0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003e5:	eb 07                	jmp    8003ee <fd_alloc+0x4d>
			*fd_store = fd;
  8003e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003f6:	83 f8 1f             	cmp    $0x1f,%eax
  8003f9:	77 36                	ja     800431 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003fb:	c1 e0 0c             	shl    $0xc,%eax
  8003fe:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800403:	89 c2                	mov    %eax,%edx
  800405:	c1 ea 16             	shr    $0x16,%edx
  800408:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80040f:	f6 c2 01             	test   $0x1,%dl
  800412:	74 24                	je     800438 <fd_lookup+0x48>
  800414:	89 c2                	mov    %eax,%edx
  800416:	c1 ea 0c             	shr    $0xc,%edx
  800419:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800420:	f6 c2 01             	test   $0x1,%dl
  800423:	74 1a                	je     80043f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800425:	8b 55 0c             	mov    0xc(%ebp),%edx
  800428:	89 02                	mov    %eax,(%edx)
	return 0;
  80042a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042f:	5d                   	pop    %ebp
  800430:	c3                   	ret    
		return -E_INVAL;
  800431:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800436:	eb f7                	jmp    80042f <fd_lookup+0x3f>
		return -E_INVAL;
  800438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80043d:	eb f0                	jmp    80042f <fd_lookup+0x3f>
  80043f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800444:	eb e9                	jmp    80042f <fd_lookup+0x3f>

00800446 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044f:	ba 00 23 80 00       	mov    $0x802300,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800454:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800459:	39 08                	cmp    %ecx,(%eax)
  80045b:	74 33                	je     800490 <dev_lookup+0x4a>
  80045d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800460:	8b 02                	mov    (%edx),%eax
  800462:	85 c0                	test   %eax,%eax
  800464:	75 f3                	jne    800459 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800466:	a1 08 40 80 00       	mov    0x804008,%eax
  80046b:	8b 40 48             	mov    0x48(%eax),%eax
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	51                   	push   %ecx
  800472:	50                   	push   %eax
  800473:	68 84 22 80 00       	push   $0x802284
  800478:	e8 f8 10 00 00       	call   801575 <cprintf>
	*dev = 0;
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    
			*dev = devtab[i];
  800490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800493:	89 01                	mov    %eax,(%ecx)
			return 0;
  800495:	b8 00 00 00 00       	mov    $0x0,%eax
  80049a:	eb f2                	jmp    80048e <dev_lookup+0x48>

0080049c <fd_close>:
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	57                   	push   %edi
  8004a0:	56                   	push   %esi
  8004a1:	53                   	push   %ebx
  8004a2:	83 ec 1c             	sub    $0x1c,%esp
  8004a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004ae:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004af:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004b5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b8:	50                   	push   %eax
  8004b9:	e8 32 ff ff ff       	call   8003f0 <fd_lookup>
  8004be:	89 c3                	mov    %eax,%ebx
  8004c0:	83 c4 08             	add    $0x8,%esp
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	78 05                	js     8004cc <fd_close+0x30>
	    || fd != fd2)
  8004c7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004ca:	74 16                	je     8004e2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004cc:	89 f8                	mov    %edi,%eax
  8004ce:	84 c0                	test   %al,%al
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d8:	89 d8                	mov    %ebx,%eax
  8004da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004dd:	5b                   	pop    %ebx
  8004de:	5e                   	pop    %esi
  8004df:	5f                   	pop    %edi
  8004e0:	5d                   	pop    %ebp
  8004e1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e8:	50                   	push   %eax
  8004e9:	ff 36                	pushl  (%esi)
  8004eb:	e8 56 ff ff ff       	call   800446 <dev_lookup>
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	78 15                	js     80050e <fd_close+0x72>
		if (dev->dev_close)
  8004f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fc:	8b 40 10             	mov    0x10(%eax),%eax
  8004ff:	85 c0                	test   %eax,%eax
  800501:	74 1b                	je     80051e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	56                   	push   %esi
  800507:	ff d0                	call   *%eax
  800509:	89 c3                	mov    %eax,%ebx
  80050b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	56                   	push   %esi
  800512:	6a 00                	push   $0x0
  800514:	e8 d6 fc ff ff       	call   8001ef <sys_page_unmap>
	return r;
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	eb ba                	jmp    8004d8 <fd_close+0x3c>
			r = 0;
  80051e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800523:	eb e9                	jmp    80050e <fd_close+0x72>

00800525 <close>:

int
close(int fdnum)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80052b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80052e:	50                   	push   %eax
  80052f:	ff 75 08             	pushl  0x8(%ebp)
  800532:	e8 b9 fe ff ff       	call   8003f0 <fd_lookup>
  800537:	83 c4 08             	add    $0x8,%esp
  80053a:	85 c0                	test   %eax,%eax
  80053c:	78 10                	js     80054e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	6a 01                	push   $0x1
  800543:	ff 75 f4             	pushl  -0xc(%ebp)
  800546:	e8 51 ff ff ff       	call   80049c <fd_close>
  80054b:	83 c4 10             	add    $0x10,%esp
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <close_all>:

void
close_all(void)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	53                   	push   %ebx
  800554:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800557:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	53                   	push   %ebx
  800560:	e8 c0 ff ff ff       	call   800525 <close>
	for (i = 0; i < MAXFD; i++)
  800565:	83 c3 01             	add    $0x1,%ebx
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	83 fb 20             	cmp    $0x20,%ebx
  80056e:	75 ec                	jne    80055c <close_all+0xc>
}
  800570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800573:	c9                   	leave  
  800574:	c3                   	ret    

00800575 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	57                   	push   %edi
  800579:	56                   	push   %esi
  80057a:	53                   	push   %ebx
  80057b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80057e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800581:	50                   	push   %eax
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	e8 66 fe ff ff       	call   8003f0 <fd_lookup>
  80058a:	89 c3                	mov    %eax,%ebx
  80058c:	83 c4 08             	add    $0x8,%esp
  80058f:	85 c0                	test   %eax,%eax
  800591:	0f 88 81 00 00 00    	js     800618 <dup+0xa3>
		return r;
	close(newfdnum);
  800597:	83 ec 0c             	sub    $0xc,%esp
  80059a:	ff 75 0c             	pushl  0xc(%ebp)
  80059d:	e8 83 ff ff ff       	call   800525 <close>

	newfd = INDEX2FD(newfdnum);
  8005a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a5:	c1 e6 0c             	shl    $0xc,%esi
  8005a8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005ae:	83 c4 04             	add    $0x4,%esp
  8005b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b4:	e8 d1 fd ff ff       	call   80038a <fd2data>
  8005b9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005bb:	89 34 24             	mov    %esi,(%esp)
  8005be:	e8 c7 fd ff ff       	call   80038a <fd2data>
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c8:	89 d8                	mov    %ebx,%eax
  8005ca:	c1 e8 16             	shr    $0x16,%eax
  8005cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005d4:	a8 01                	test   $0x1,%al
  8005d6:	74 11                	je     8005e9 <dup+0x74>
  8005d8:	89 d8                	mov    %ebx,%eax
  8005da:	c1 e8 0c             	shr    $0xc,%eax
  8005dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005e4:	f6 c2 01             	test   $0x1,%dl
  8005e7:	75 39                	jne    800622 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	c1 e8 0c             	shr    $0xc,%eax
  8005f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f8:	83 ec 0c             	sub    $0xc,%esp
  8005fb:	25 07 0e 00 00       	and    $0xe07,%eax
  800600:	50                   	push   %eax
  800601:	56                   	push   %esi
  800602:	6a 00                	push   $0x0
  800604:	52                   	push   %edx
  800605:	6a 00                	push   $0x0
  800607:	e8 a1 fb ff ff       	call   8001ad <sys_page_map>
  80060c:	89 c3                	mov    %eax,%ebx
  80060e:	83 c4 20             	add    $0x20,%esp
  800611:	85 c0                	test   %eax,%eax
  800613:	78 31                	js     800646 <dup+0xd1>
		goto err;

	return newfdnum;
  800615:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800618:	89 d8                	mov    %ebx,%eax
  80061a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061d:	5b                   	pop    %ebx
  80061e:	5e                   	pop    %esi
  80061f:	5f                   	pop    %edi
  800620:	5d                   	pop    %ebp
  800621:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800622:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800629:	83 ec 0c             	sub    $0xc,%esp
  80062c:	25 07 0e 00 00       	and    $0xe07,%eax
  800631:	50                   	push   %eax
  800632:	57                   	push   %edi
  800633:	6a 00                	push   $0x0
  800635:	53                   	push   %ebx
  800636:	6a 00                	push   $0x0
  800638:	e8 70 fb ff ff       	call   8001ad <sys_page_map>
  80063d:	89 c3                	mov    %eax,%ebx
  80063f:	83 c4 20             	add    $0x20,%esp
  800642:	85 c0                	test   %eax,%eax
  800644:	79 a3                	jns    8005e9 <dup+0x74>
	sys_page_unmap(0, newfd);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	56                   	push   %esi
  80064a:	6a 00                	push   $0x0
  80064c:	e8 9e fb ff ff       	call   8001ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  800651:	83 c4 08             	add    $0x8,%esp
  800654:	57                   	push   %edi
  800655:	6a 00                	push   $0x0
  800657:	e8 93 fb ff ff       	call   8001ef <sys_page_unmap>
	return r;
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb b7                	jmp    800618 <dup+0xa3>

00800661 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	53                   	push   %ebx
  800665:	83 ec 14             	sub    $0x14,%esp
  800668:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80066b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	53                   	push   %ebx
  800670:	e8 7b fd ff ff       	call   8003f0 <fd_lookup>
  800675:	83 c4 08             	add    $0x8,%esp
  800678:	85 c0                	test   %eax,%eax
  80067a:	78 3f                	js     8006bb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800682:	50                   	push   %eax
  800683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800686:	ff 30                	pushl  (%eax)
  800688:	e8 b9 fd ff ff       	call   800446 <dev_lookup>
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	85 c0                	test   %eax,%eax
  800692:	78 27                	js     8006bb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800697:	8b 42 08             	mov    0x8(%edx),%eax
  80069a:	83 e0 03             	and    $0x3,%eax
  80069d:	83 f8 01             	cmp    $0x1,%eax
  8006a0:	74 1e                	je     8006c0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a5:	8b 40 08             	mov    0x8(%eax),%eax
  8006a8:	85 c0                	test   %eax,%eax
  8006aa:	74 35                	je     8006e1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006ac:	83 ec 04             	sub    $0x4,%esp
  8006af:	ff 75 10             	pushl  0x10(%ebp)
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	52                   	push   %edx
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
}
  8006bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006be:	c9                   	leave  
  8006bf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8006c5:	8b 40 48             	mov    0x48(%eax),%eax
  8006c8:	83 ec 04             	sub    $0x4,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	50                   	push   %eax
  8006cd:	68 c5 22 80 00       	push   $0x8022c5
  8006d2:	e8 9e 0e 00 00       	call   801575 <cprintf>
		return -E_INVAL;
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006df:	eb da                	jmp    8006bb <read+0x5a>
		return -E_NOT_SUPP;
  8006e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006e6:	eb d3                	jmp    8006bb <read+0x5a>

008006e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	57                   	push   %edi
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fc:	39 f3                	cmp    %esi,%ebx
  8006fe:	73 25                	jae    800725 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800700:	83 ec 04             	sub    $0x4,%esp
  800703:	89 f0                	mov    %esi,%eax
  800705:	29 d8                	sub    %ebx,%eax
  800707:	50                   	push   %eax
  800708:	89 d8                	mov    %ebx,%eax
  80070a:	03 45 0c             	add    0xc(%ebp),%eax
  80070d:	50                   	push   %eax
  80070e:	57                   	push   %edi
  80070f:	e8 4d ff ff ff       	call   800661 <read>
		if (m < 0)
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	85 c0                	test   %eax,%eax
  800719:	78 08                	js     800723 <readn+0x3b>
			return m;
		if (m == 0)
  80071b:	85 c0                	test   %eax,%eax
  80071d:	74 06                	je     800725 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80071f:	01 c3                	add    %eax,%ebx
  800721:	eb d9                	jmp    8006fc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800723:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800725:	89 d8                	mov    %ebx,%eax
  800727:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80072a:	5b                   	pop    %ebx
  80072b:	5e                   	pop    %esi
  80072c:	5f                   	pop    %edi
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	53                   	push   %ebx
  800733:	83 ec 14             	sub    $0x14,%esp
  800736:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800739:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	53                   	push   %ebx
  80073e:	e8 ad fc ff ff       	call   8003f0 <fd_lookup>
  800743:	83 c4 08             	add    $0x8,%esp
  800746:	85 c0                	test   %eax,%eax
  800748:	78 3a                	js     800784 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800750:	50                   	push   %eax
  800751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800754:	ff 30                	pushl  (%eax)
  800756:	e8 eb fc ff ff       	call   800446 <dev_lookup>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	78 22                	js     800784 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800765:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800769:	74 1e                	je     800789 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80076b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076e:	8b 52 0c             	mov    0xc(%edx),%edx
  800771:	85 d2                	test   %edx,%edx
  800773:	74 35                	je     8007aa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	ff 75 10             	pushl  0x10(%ebp)
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	ff d2                	call   *%edx
  800781:	83 c4 10             	add    $0x10,%esp
}
  800784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800787:	c9                   	leave  
  800788:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800789:	a1 08 40 80 00       	mov    0x804008,%eax
  80078e:	8b 40 48             	mov    0x48(%eax),%eax
  800791:	83 ec 04             	sub    $0x4,%esp
  800794:	53                   	push   %ebx
  800795:	50                   	push   %eax
  800796:	68 e1 22 80 00       	push   $0x8022e1
  80079b:	e8 d5 0d 00 00       	call   801575 <cprintf>
		return -E_INVAL;
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a8:	eb da                	jmp    800784 <write+0x55>
		return -E_NOT_SUPP;
  8007aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007af:	eb d3                	jmp    800784 <write+0x55>

008007b1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b7:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007ba:	50                   	push   %eax
  8007bb:	ff 75 08             	pushl  0x8(%ebp)
  8007be:	e8 2d fc ff ff       	call   8003f0 <fd_lookup>
  8007c3:	83 c4 08             	add    $0x8,%esp
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	78 0e                	js     8007d8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007d0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d8:	c9                   	leave  
  8007d9:	c3                   	ret    

008007da <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 14             	sub    $0x14,%esp
  8007e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	53                   	push   %ebx
  8007e9:	e8 02 fc ff ff       	call   8003f0 <fd_lookup>
  8007ee:	83 c4 08             	add    $0x8,%esp
  8007f1:	85 c0                	test   %eax,%eax
  8007f3:	78 37                	js     80082c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007fb:	50                   	push   %eax
  8007fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ff:	ff 30                	pushl  (%eax)
  800801:	e8 40 fc ff ff       	call   800446 <dev_lookup>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	85 c0                	test   %eax,%eax
  80080b:	78 1f                	js     80082c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80080d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800810:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800814:	74 1b                	je     800831 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800819:	8b 52 18             	mov    0x18(%edx),%edx
  80081c:	85 d2                	test   %edx,%edx
  80081e:	74 32                	je     800852 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	50                   	push   %eax
  800827:	ff d2                	call   *%edx
  800829:	83 c4 10             	add    $0x10,%esp
}
  80082c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082f:	c9                   	leave  
  800830:	c3                   	ret    
			thisenv->env_id, fdnum);
  800831:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800836:	8b 40 48             	mov    0x48(%eax),%eax
  800839:	83 ec 04             	sub    $0x4,%esp
  80083c:	53                   	push   %ebx
  80083d:	50                   	push   %eax
  80083e:	68 a4 22 80 00       	push   $0x8022a4
  800843:	e8 2d 0d 00 00       	call   801575 <cprintf>
		return -E_INVAL;
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800850:	eb da                	jmp    80082c <ftruncate+0x52>
		return -E_NOT_SUPP;
  800852:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800857:	eb d3                	jmp    80082c <ftruncate+0x52>

00800859 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	83 ec 14             	sub    $0x14,%esp
  800860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800863:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800866:	50                   	push   %eax
  800867:	ff 75 08             	pushl  0x8(%ebp)
  80086a:	e8 81 fb ff ff       	call   8003f0 <fd_lookup>
  80086f:	83 c4 08             	add    $0x8,%esp
  800872:	85 c0                	test   %eax,%eax
  800874:	78 4b                	js     8008c1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087c:	50                   	push   %eax
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800880:	ff 30                	pushl  (%eax)
  800882:	e8 bf fb ff ff       	call   800446 <dev_lookup>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	85 c0                	test   %eax,%eax
  80088c:	78 33                	js     8008c1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800891:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800895:	74 2f                	je     8008c6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800897:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80089a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008a1:	00 00 00 
	stat->st_isdir = 0;
  8008a4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008ab:	00 00 00 
	stat->st_dev = dev;
  8008ae:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	53                   	push   %ebx
  8008b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008bb:	ff 50 14             	call   *0x14(%eax)
  8008be:	83 c4 10             	add    $0x10,%esp
}
  8008c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    
		return -E_NOT_SUPP;
  8008c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008cb:	eb f4                	jmp    8008c1 <fstat+0x68>

008008cd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	56                   	push   %esi
  8008d1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	6a 00                	push   $0x0
  8008d7:	ff 75 08             	pushl  0x8(%ebp)
  8008da:	e8 e7 01 00 00       	call   800ac6 <open>
  8008df:	89 c3                	mov    %eax,%ebx
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	78 1b                	js     800903 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	e8 65 ff ff ff       	call   800859 <fstat>
  8008f4:	89 c6                	mov    %eax,%esi
	close(fd);
  8008f6:	89 1c 24             	mov    %ebx,(%esp)
  8008f9:	e8 27 fc ff ff       	call   800525 <close>
	return r;
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	89 f3                	mov    %esi,%ebx
}
  800903:	89 d8                	mov    %ebx,%eax
  800905:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800908:	5b                   	pop    %ebx
  800909:	5e                   	pop    %esi
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	56                   	push   %esi
  800910:	53                   	push   %ebx
  800911:	89 c6                	mov    %eax,%esi
  800913:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800915:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80091c:	74 27                	je     800945 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80091e:	6a 07                	push   $0x7
  800920:	68 00 50 80 00       	push   $0x805000
  800925:	56                   	push   %esi
  800926:	ff 35 00 40 80 00    	pushl  0x804000
  80092c:	e8 07 16 00 00       	call   801f38 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800931:	83 c4 0c             	add    $0xc,%esp
  800934:	6a 00                	push   $0x0
  800936:	53                   	push   %ebx
  800937:	6a 00                	push   $0x0
  800939:	e8 93 15 00 00       	call   801ed1 <ipc_recv>
}
  80093e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800945:	83 ec 0c             	sub    $0xc,%esp
  800948:	6a 01                	push   $0x1
  80094a:	e8 3d 16 00 00       	call   801f8c <ipc_find_env>
  80094f:	a3 00 40 80 00       	mov    %eax,0x804000
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	eb c5                	jmp    80091e <fsipc+0x12>

00800959 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 40 0c             	mov    0xc(%eax),%eax
  800965:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	b8 02 00 00 00       	mov    $0x2,%eax
  80097c:	e8 8b ff ff ff       	call   80090c <fsipc>
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <devfile_flush>:
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 40 0c             	mov    0xc(%eax),%eax
  80098f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	b8 06 00 00 00       	mov    $0x6,%eax
  80099e:	e8 69 ff ff ff       	call   80090c <fsipc>
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <devfile_stat>:
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	53                   	push   %ebx
  8009a9:	83 ec 04             	sub    $0x4,%esp
  8009ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8009c4:	e8 43 ff ff ff       	call   80090c <fsipc>
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	78 2c                	js     8009f9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	68 00 50 80 00       	push   $0x805000
  8009d5:	53                   	push   %ebx
  8009d6:	e8 b9 11 00 00       	call   801b94 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009db:	a1 80 50 80 00       	mov    0x805080,%eax
  8009e0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009e6:	a1 84 50 80 00       	mov    0x805084,%eax
  8009eb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <devfile_write>:
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 0c             	sub    $0xc,%esp
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a0c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a11:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a14:	8b 55 08             	mov    0x8(%ebp),%edx
  800a17:	8b 52 0c             	mov    0xc(%edx),%edx
  800a1a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a20:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a25:	50                   	push   %eax
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	68 08 50 80 00       	push   $0x805008
  800a2e:	e8 ef 12 00 00       	call   801d22 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a33:	ba 00 00 00 00       	mov    $0x0,%edx
  800a38:	b8 04 00 00 00       	mov    $0x4,%eax
  800a3d:	e8 ca fe ff ff       	call   80090c <fsipc>
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <devfile_read>:
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	56                   	push   %esi
  800a48:	53                   	push   %ebx
  800a49:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a52:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a57:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a62:	b8 03 00 00 00       	mov    $0x3,%eax
  800a67:	e8 a0 fe ff ff       	call   80090c <fsipc>
  800a6c:	89 c3                	mov    %eax,%ebx
  800a6e:	85 c0                	test   %eax,%eax
  800a70:	78 1f                	js     800a91 <devfile_read+0x4d>
	assert(r <= n);
  800a72:	39 f0                	cmp    %esi,%eax
  800a74:	77 24                	ja     800a9a <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a76:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a7b:	7f 33                	jg     800ab0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	50                   	push   %eax
  800a81:	68 00 50 80 00       	push   $0x805000
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	e8 94 12 00 00       	call   801d22 <memmove>
	return r;
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	89 d8                	mov    %ebx,%eax
  800a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a96:	5b                   	pop    %ebx
  800a97:	5e                   	pop    %esi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    
	assert(r <= n);
  800a9a:	68 14 23 80 00       	push   $0x802314
  800a9f:	68 1b 23 80 00       	push   $0x80231b
  800aa4:	6a 7b                	push   $0x7b
  800aa6:	68 30 23 80 00       	push   $0x802330
  800aab:	e8 ea 09 00 00       	call   80149a <_panic>
	assert(r <= PGSIZE);
  800ab0:	68 3b 23 80 00       	push   $0x80233b
  800ab5:	68 1b 23 80 00       	push   $0x80231b
  800aba:	6a 7c                	push   $0x7c
  800abc:	68 30 23 80 00       	push   $0x802330
  800ac1:	e8 d4 09 00 00       	call   80149a <_panic>

00800ac6 <open>:
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	56                   	push   %esi
  800aca:	53                   	push   %ebx
  800acb:	83 ec 1c             	sub    $0x1c,%esp
  800ace:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ad1:	56                   	push   %esi
  800ad2:	e8 86 10 00 00       	call   801b5d <strlen>
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800adf:	7f 6c                	jg     800b4d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ae1:	83 ec 0c             	sub    $0xc,%esp
  800ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ae7:	50                   	push   %eax
  800ae8:	e8 b4 f8 ff ff       	call   8003a1 <fd_alloc>
  800aed:	89 c3                	mov    %eax,%ebx
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	85 c0                	test   %eax,%eax
  800af4:	78 3c                	js     800b32 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	56                   	push   %esi
  800afa:	68 00 50 80 00       	push   $0x805000
  800aff:	e8 90 10 00 00       	call   801b94 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800b0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b14:	e8 f3 fd ff ff       	call   80090c <fsipc>
  800b19:	89 c3                	mov    %eax,%ebx
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	85 c0                	test   %eax,%eax
  800b20:	78 19                	js     800b3b <open+0x75>
	return fd2num(fd);
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	ff 75 f4             	pushl  -0xc(%ebp)
  800b28:	e8 4d f8 ff ff       	call   80037a <fd2num>
  800b2d:	89 c3                	mov    %eax,%ebx
  800b2f:	83 c4 10             	add    $0x10,%esp
}
  800b32:	89 d8                	mov    %ebx,%eax
  800b34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    
		fd_close(fd, 0);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	6a 00                	push   $0x0
  800b40:	ff 75 f4             	pushl  -0xc(%ebp)
  800b43:	e8 54 f9 ff ff       	call   80049c <fd_close>
		return r;
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	eb e5                	jmp    800b32 <open+0x6c>
		return -E_BAD_PATH;
  800b4d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b52:	eb de                	jmp    800b32 <open+0x6c>

00800b54 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5f:	b8 08 00 00 00       	mov    $0x8,%eax
  800b64:	e8 a3 fd ff ff       	call   80090c <fsipc>
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b71:	68 47 23 80 00       	push   $0x802347
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	e8 16 10 00 00       	call   801b94 <strcpy>
	return 0;
}
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <devsock_close>:
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	53                   	push   %ebx
  800b89:	83 ec 10             	sub    $0x10,%esp
  800b8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800b8f:	53                   	push   %ebx
  800b90:	e8 30 14 00 00       	call   801fc5 <pageref>
  800b95:	83 c4 10             	add    $0x10,%esp
		return 0;
  800b98:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800b9d:	83 f8 01             	cmp    $0x1,%eax
  800ba0:	74 07                	je     800ba9 <devsock_close+0x24>
}
  800ba2:	89 d0                	mov    %edx,%eax
  800ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800ba9:	83 ec 0c             	sub    $0xc,%esp
  800bac:	ff 73 0c             	pushl  0xc(%ebx)
  800baf:	e8 b7 02 00 00       	call   800e6b <nsipc_close>
  800bb4:	89 c2                	mov    %eax,%edx
  800bb6:	83 c4 10             	add    $0x10,%esp
  800bb9:	eb e7                	jmp    800ba2 <devsock_close+0x1d>

00800bbb <devsock_write>:
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bc1:	6a 00                	push   $0x0
  800bc3:	ff 75 10             	pushl  0x10(%ebp)
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff 70 0c             	pushl  0xc(%eax)
  800bcf:	e8 74 03 00 00       	call   800f48 <nsipc_send>
}
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <devsock_read>:
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bdc:	6a 00                	push   $0x0
  800bde:	ff 75 10             	pushl  0x10(%ebp)
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff 70 0c             	pushl  0xc(%eax)
  800bea:	e8 ed 02 00 00       	call   800edc <nsipc_recv>
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <fd2sockid>:
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800bf7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800bfa:	52                   	push   %edx
  800bfb:	50                   	push   %eax
  800bfc:	e8 ef f7 ff ff       	call   8003f0 <fd_lookup>
  800c01:	83 c4 10             	add    $0x10,%esp
  800c04:	85 c0                	test   %eax,%eax
  800c06:	78 10                	js     800c18 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c0b:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  800c11:	39 08                	cmp    %ecx,(%eax)
  800c13:	75 05                	jne    800c1a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c15:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    
		return -E_NOT_SUPP;
  800c1a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c1f:	eb f7                	jmp    800c18 <fd2sockid+0x27>

00800c21 <alloc_sockfd>:
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
  800c26:	83 ec 1c             	sub    $0x1c,%esp
  800c29:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c2e:	50                   	push   %eax
  800c2f:	e8 6d f7 ff ff       	call   8003a1 <fd_alloc>
  800c34:	89 c3                	mov    %eax,%ebx
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	78 43                	js     800c80 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c3d:	83 ec 04             	sub    $0x4,%esp
  800c40:	68 07 04 00 00       	push   $0x407
  800c45:	ff 75 f4             	pushl  -0xc(%ebp)
  800c48:	6a 00                	push   $0x0
  800c4a:	e8 1b f5 ff ff       	call   80016a <sys_page_alloc>
  800c4f:	89 c3                	mov    %eax,%ebx
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	85 c0                	test   %eax,%eax
  800c56:	78 28                	js     800c80 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c5b:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800c61:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c66:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c6d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	50                   	push   %eax
  800c74:	e8 01 f7 ff ff       	call   80037a <fd2num>
  800c79:	89 c3                	mov    %eax,%ebx
  800c7b:	83 c4 10             	add    $0x10,%esp
  800c7e:	eb 0c                	jmp    800c8c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	56                   	push   %esi
  800c84:	e8 e2 01 00 00       	call   800e6b <nsipc_close>
		return r;
  800c89:	83 c4 10             	add    $0x10,%esp
}
  800c8c:	89 d8                	mov    %ebx,%eax
  800c8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <accept>:
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	e8 4e ff ff ff       	call   800bf1 <fd2sockid>
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	78 1b                	js     800cc2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800ca7:	83 ec 04             	sub    $0x4,%esp
  800caa:	ff 75 10             	pushl  0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	50                   	push   %eax
  800cb1:	e8 0e 01 00 00       	call   800dc4 <nsipc_accept>
  800cb6:	83 c4 10             	add    $0x10,%esp
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	78 05                	js     800cc2 <accept+0x2d>
	return alloc_sockfd(r);
  800cbd:	e8 5f ff ff ff       	call   800c21 <alloc_sockfd>
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <bind>:
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	e8 1f ff ff ff       	call   800bf1 <fd2sockid>
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	78 12                	js     800ce8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800cd6:	83 ec 04             	sub    $0x4,%esp
  800cd9:	ff 75 10             	pushl  0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	50                   	push   %eax
  800ce0:	e8 2f 01 00 00       	call   800e14 <nsipc_bind>
  800ce5:	83 c4 10             	add    $0x10,%esp
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <shutdown>:
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	e8 f9 fe ff ff       	call   800bf1 <fd2sockid>
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	78 0f                	js     800d0b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	50                   	push   %eax
  800d03:	e8 41 01 00 00       	call   800e49 <nsipc_shutdown>
  800d08:	83 c4 10             	add    $0x10,%esp
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <connect>:
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	e8 d6 fe ff ff       	call   800bf1 <fd2sockid>
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	78 12                	js     800d31 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d1f:	83 ec 04             	sub    $0x4,%esp
  800d22:	ff 75 10             	pushl  0x10(%ebp)
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	50                   	push   %eax
  800d29:	e8 57 01 00 00       	call   800e85 <nsipc_connect>
  800d2e:	83 c4 10             	add    $0x10,%esp
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <listen>:
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	e8 b0 fe ff ff       	call   800bf1 <fd2sockid>
  800d41:	85 c0                	test   %eax,%eax
  800d43:	78 0f                	js     800d54 <listen+0x21>
	return nsipc_listen(r, backlog);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	50                   	push   %eax
  800d4c:	e8 69 01 00 00       	call   800eba <nsipc_listen>
  800d51:	83 c4 10             	add    $0x10,%esp
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    

00800d56 <socket>:

int
socket(int domain, int type, int protocol)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d5c:	ff 75 10             	pushl  0x10(%ebp)
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 3c 02 00 00       	call   800fa6 <nsipc_socket>
  800d6a:	83 c4 10             	add    $0x10,%esp
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	78 05                	js     800d76 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d71:	e8 ab fe ff ff       	call   800c21 <alloc_sockfd>
}
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	53                   	push   %ebx
  800d7c:	83 ec 04             	sub    $0x4,%esp
  800d7f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d81:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d88:	74 26                	je     800db0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800d8a:	6a 07                	push   $0x7
  800d8c:	68 00 60 80 00       	push   $0x806000
  800d91:	53                   	push   %ebx
  800d92:	ff 35 04 40 80 00    	pushl  0x804004
  800d98:	e8 9b 11 00 00       	call   801f38 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800d9d:	83 c4 0c             	add    $0xc,%esp
  800da0:	6a 00                	push   $0x0
  800da2:	6a 00                	push   $0x0
  800da4:	6a 00                	push   $0x0
  800da6:	e8 26 11 00 00       	call   801ed1 <ipc_recv>
}
  800dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	6a 02                	push   $0x2
  800db5:	e8 d2 11 00 00       	call   801f8c <ipc_find_env>
  800dba:	a3 04 40 80 00       	mov    %eax,0x804004
  800dbf:	83 c4 10             	add    $0x10,%esp
  800dc2:	eb c6                	jmp    800d8a <nsipc+0x12>

00800dc4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800dd4:	8b 06                	mov    (%esi),%eax
  800dd6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800ddb:	b8 01 00 00 00       	mov    $0x1,%eax
  800de0:	e8 93 ff ff ff       	call   800d78 <nsipc>
  800de5:	89 c3                	mov    %eax,%ebx
  800de7:	85 c0                	test   %eax,%eax
  800de9:	78 20                	js     800e0b <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	ff 35 10 60 80 00    	pushl  0x806010
  800df4:	68 00 60 80 00       	push   $0x806000
  800df9:	ff 75 0c             	pushl  0xc(%ebp)
  800dfc:	e8 21 0f 00 00       	call   801d22 <memmove>
		*addrlen = ret->ret_addrlen;
  800e01:	a1 10 60 80 00       	mov    0x806010,%eax
  800e06:	89 06                	mov    %eax,(%esi)
  800e08:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800e0b:	89 d8                	mov    %ebx,%eax
  800e0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	53                   	push   %ebx
  800e18:	83 ec 08             	sub    $0x8,%esp
  800e1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e26:	53                   	push   %ebx
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	68 04 60 80 00       	push   $0x806004
  800e2f:	e8 ee 0e 00 00       	call   801d22 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e34:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e3a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e3f:	e8 34 ff ff ff       	call   800d78 <nsipc>
}
  800e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e64:	e8 0f ff ff ff       	call   800d78 <nsipc>
}
  800e69:	c9                   	leave  
  800e6a:	c3                   	ret    

00800e6b <nsipc_close>:

int
nsipc_close(int s)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e79:	b8 04 00 00 00       	mov    $0x4,%eax
  800e7e:	e8 f5 fe ff ff       	call   800d78 <nsipc>
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	53                   	push   %ebx
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800e97:	53                   	push   %ebx
  800e98:	ff 75 0c             	pushl  0xc(%ebp)
  800e9b:	68 04 60 80 00       	push   $0x806004
  800ea0:	e8 7d 0e 00 00       	call   801d22 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800ea5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800eab:	b8 05 00 00 00       	mov    $0x5,%eax
  800eb0:	e8 c3 fe ff ff       	call   800d78 <nsipc>
}
  800eb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb8:	c9                   	leave  
  800eb9:	c3                   	ret    

00800eba <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ed0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ed5:	e8 9e fe ff ff       	call   800d78 <nsipc>
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	56                   	push   %esi
  800ee0:	53                   	push   %ebx
  800ee1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800eec:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef5:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800efa:	b8 07 00 00 00       	mov    $0x7,%eax
  800eff:	e8 74 fe ff ff       	call   800d78 <nsipc>
  800f04:	89 c3                	mov    %eax,%ebx
  800f06:	85 c0                	test   %eax,%eax
  800f08:	78 1f                	js     800f29 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800f0a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800f0f:	7f 21                	jg     800f32 <nsipc_recv+0x56>
  800f11:	39 c6                	cmp    %eax,%esi
  800f13:	7c 1d                	jl     800f32 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	68 00 60 80 00       	push   $0x806000
  800f1e:	ff 75 0c             	pushl  0xc(%ebp)
  800f21:	e8 fc 0d 00 00       	call   801d22 <memmove>
  800f26:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f29:	89 d8                	mov    %ebx,%eax
  800f2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f32:	68 53 23 80 00       	push   $0x802353
  800f37:	68 1b 23 80 00       	push   $0x80231b
  800f3c:	6a 62                	push   $0x62
  800f3e:	68 68 23 80 00       	push   $0x802368
  800f43:	e8 52 05 00 00       	call   80149a <_panic>

00800f48 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f5a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f60:	7f 2e                	jg     800f90 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f62:	83 ec 04             	sub    $0x4,%esp
  800f65:	53                   	push   %ebx
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	68 0c 60 80 00       	push   $0x80600c
  800f6e:	e8 af 0d 00 00       	call   801d22 <memmove>
	nsipcbuf.send.req_size = size;
  800f73:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f81:	b8 08 00 00 00       	mov    $0x8,%eax
  800f86:	e8 ed fd ff ff       	call   800d78 <nsipc>
}
  800f8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f8e:	c9                   	leave  
  800f8f:	c3                   	ret    
	assert(size < 1600);
  800f90:	68 74 23 80 00       	push   $0x802374
  800f95:	68 1b 23 80 00       	push   $0x80231b
  800f9a:	6a 6d                	push   $0x6d
  800f9c:	68 68 23 80 00       	push   $0x802368
  800fa1:	e8 f4 04 00 00       	call   80149a <_panic>

00800fa6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800fc4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc9:	e8 aa fd ff ff       	call   800d78 <nsipc>
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	ff 75 08             	pushl  0x8(%ebp)
  800fde:	e8 a7 f3 ff ff       	call   80038a <fd2data>
  800fe3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fe5:	83 c4 08             	add    $0x8,%esp
  800fe8:	68 80 23 80 00       	push   $0x802380
  800fed:	53                   	push   %ebx
  800fee:	e8 a1 0b 00 00       	call   801b94 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800ff3:	8b 46 04             	mov    0x4(%esi),%eax
  800ff6:	2b 06                	sub    (%esi),%eax
  800ff8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ffe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801005:	00 00 00 
	stat->st_dev = &devpipe;
  801008:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  80100f:	30 80 00 
	return 0;
}
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
  801017:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	53                   	push   %ebx
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801028:	53                   	push   %ebx
  801029:	6a 00                	push   $0x0
  80102b:	e8 bf f1 ff ff       	call   8001ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801030:	89 1c 24             	mov    %ebx,(%esp)
  801033:	e8 52 f3 ff ff       	call   80038a <fd2data>
  801038:	83 c4 08             	add    $0x8,%esp
  80103b:	50                   	push   %eax
  80103c:	6a 00                	push   $0x0
  80103e:	e8 ac f1 ff ff       	call   8001ef <sys_page_unmap>
}
  801043:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <_pipeisclosed>:
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	57                   	push   %edi
  80104c:	56                   	push   %esi
  80104d:	53                   	push   %ebx
  80104e:	83 ec 1c             	sub    $0x1c,%esp
  801051:	89 c7                	mov    %eax,%edi
  801053:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801055:	a1 08 40 80 00       	mov    0x804008,%eax
  80105a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80105d:	83 ec 0c             	sub    $0xc,%esp
  801060:	57                   	push   %edi
  801061:	e8 5f 0f 00 00       	call   801fc5 <pageref>
  801066:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801069:	89 34 24             	mov    %esi,(%esp)
  80106c:	e8 54 0f 00 00       	call   801fc5 <pageref>
		nn = thisenv->env_runs;
  801071:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801077:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80107a:	83 c4 10             	add    $0x10,%esp
  80107d:	39 cb                	cmp    %ecx,%ebx
  80107f:	74 1b                	je     80109c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801081:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801084:	75 cf                	jne    801055 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801086:	8b 42 58             	mov    0x58(%edx),%eax
  801089:	6a 01                	push   $0x1
  80108b:	50                   	push   %eax
  80108c:	53                   	push   %ebx
  80108d:	68 87 23 80 00       	push   $0x802387
  801092:	e8 de 04 00 00       	call   801575 <cprintf>
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	eb b9                	jmp    801055 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80109c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80109f:	0f 94 c0             	sete   %al
  8010a2:	0f b6 c0             	movzbl %al,%eax
}
  8010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <devpipe_write>:
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 28             	sub    $0x28,%esp
  8010b6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010b9:	56                   	push   %esi
  8010ba:	e8 cb f2 ff ff       	call   80038a <fd2data>
  8010bf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010c1:	83 c4 10             	add    $0x10,%esp
  8010c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010cc:	74 4f                	je     80111d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010ce:	8b 43 04             	mov    0x4(%ebx),%eax
  8010d1:	8b 0b                	mov    (%ebx),%ecx
  8010d3:	8d 51 20             	lea    0x20(%ecx),%edx
  8010d6:	39 d0                	cmp    %edx,%eax
  8010d8:	72 14                	jb     8010ee <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010da:	89 da                	mov    %ebx,%edx
  8010dc:	89 f0                	mov    %esi,%eax
  8010de:	e8 65 ff ff ff       	call   801048 <_pipeisclosed>
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	75 3a                	jne    801121 <devpipe_write+0x74>
			sys_yield();
  8010e7:	e8 5f f0 ff ff       	call   80014b <sys_yield>
  8010ec:	eb e0                	jmp    8010ce <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010f5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010f8:	89 c2                	mov    %eax,%edx
  8010fa:	c1 fa 1f             	sar    $0x1f,%edx
  8010fd:	89 d1                	mov    %edx,%ecx
  8010ff:	c1 e9 1b             	shr    $0x1b,%ecx
  801102:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801105:	83 e2 1f             	and    $0x1f,%edx
  801108:	29 ca                	sub    %ecx,%edx
  80110a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80110e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801112:	83 c0 01             	add    $0x1,%eax
  801115:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801118:	83 c7 01             	add    $0x1,%edi
  80111b:	eb ac                	jmp    8010c9 <devpipe_write+0x1c>
	return i;
  80111d:	89 f8                	mov    %edi,%eax
  80111f:	eb 05                	jmp    801126 <devpipe_write+0x79>
				return 0;
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801126:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801129:	5b                   	pop    %ebx
  80112a:	5e                   	pop    %esi
  80112b:	5f                   	pop    %edi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <devpipe_read>:
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	57                   	push   %edi
  801132:	56                   	push   %esi
  801133:	53                   	push   %ebx
  801134:	83 ec 18             	sub    $0x18,%esp
  801137:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80113a:	57                   	push   %edi
  80113b:	e8 4a f2 ff ff       	call   80038a <fd2data>
  801140:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801142:	83 c4 10             	add    $0x10,%esp
  801145:	be 00 00 00 00       	mov    $0x0,%esi
  80114a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80114d:	74 47                	je     801196 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80114f:	8b 03                	mov    (%ebx),%eax
  801151:	3b 43 04             	cmp    0x4(%ebx),%eax
  801154:	75 22                	jne    801178 <devpipe_read+0x4a>
			if (i > 0)
  801156:	85 f6                	test   %esi,%esi
  801158:	75 14                	jne    80116e <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80115a:	89 da                	mov    %ebx,%edx
  80115c:	89 f8                	mov    %edi,%eax
  80115e:	e8 e5 fe ff ff       	call   801048 <_pipeisclosed>
  801163:	85 c0                	test   %eax,%eax
  801165:	75 33                	jne    80119a <devpipe_read+0x6c>
			sys_yield();
  801167:	e8 df ef ff ff       	call   80014b <sys_yield>
  80116c:	eb e1                	jmp    80114f <devpipe_read+0x21>
				return i;
  80116e:	89 f0                	mov    %esi,%eax
}
  801170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801173:	5b                   	pop    %ebx
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801178:	99                   	cltd   
  801179:	c1 ea 1b             	shr    $0x1b,%edx
  80117c:	01 d0                	add    %edx,%eax
  80117e:	83 e0 1f             	and    $0x1f,%eax
  801181:	29 d0                	sub    %edx,%eax
  801183:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801188:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80118e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801191:	83 c6 01             	add    $0x1,%esi
  801194:	eb b4                	jmp    80114a <devpipe_read+0x1c>
	return i;
  801196:	89 f0                	mov    %esi,%eax
  801198:	eb d6                	jmp    801170 <devpipe_read+0x42>
				return 0;
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
  80119f:	eb cf                	jmp    801170 <devpipe_read+0x42>

008011a1 <pipe>:
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ac:	50                   	push   %eax
  8011ad:	e8 ef f1 ff ff       	call   8003a1 <fd_alloc>
  8011b2:	89 c3                	mov    %eax,%ebx
  8011b4:	83 c4 10             	add    $0x10,%esp
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	78 5b                	js     801216 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	68 07 04 00 00       	push   $0x407
  8011c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c6:	6a 00                	push   $0x0
  8011c8:	e8 9d ef ff ff       	call   80016a <sys_page_alloc>
  8011cd:	89 c3                	mov    %eax,%ebx
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	78 40                	js     801216 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011dc:	50                   	push   %eax
  8011dd:	e8 bf f1 ff ff       	call   8003a1 <fd_alloc>
  8011e2:	89 c3                	mov    %eax,%ebx
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	78 1b                	js     801206 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011eb:	83 ec 04             	sub    $0x4,%esp
  8011ee:	68 07 04 00 00       	push   $0x407
  8011f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8011f6:	6a 00                	push   $0x0
  8011f8:	e8 6d ef ff ff       	call   80016a <sys_page_alloc>
  8011fd:	89 c3                	mov    %eax,%ebx
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	79 19                	jns    80121f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	ff 75 f4             	pushl  -0xc(%ebp)
  80120c:	6a 00                	push   $0x0
  80120e:	e8 dc ef ff ff       	call   8001ef <sys_page_unmap>
  801213:	83 c4 10             	add    $0x10,%esp
}
  801216:	89 d8                	mov    %ebx,%eax
  801218:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5d                   	pop    %ebp
  80121e:	c3                   	ret    
	va = fd2data(fd0);
  80121f:	83 ec 0c             	sub    $0xc,%esp
  801222:	ff 75 f4             	pushl  -0xc(%ebp)
  801225:	e8 60 f1 ff ff       	call   80038a <fd2data>
  80122a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80122c:	83 c4 0c             	add    $0xc,%esp
  80122f:	68 07 04 00 00       	push   $0x407
  801234:	50                   	push   %eax
  801235:	6a 00                	push   $0x0
  801237:	e8 2e ef ff ff       	call   80016a <sys_page_alloc>
  80123c:	89 c3                	mov    %eax,%ebx
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	0f 88 8c 00 00 00    	js     8012d5 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801249:	83 ec 0c             	sub    $0xc,%esp
  80124c:	ff 75 f0             	pushl  -0x10(%ebp)
  80124f:	e8 36 f1 ff ff       	call   80038a <fd2data>
  801254:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80125b:	50                   	push   %eax
  80125c:	6a 00                	push   $0x0
  80125e:	56                   	push   %esi
  80125f:	6a 00                	push   $0x0
  801261:	e8 47 ef ff ff       	call   8001ad <sys_page_map>
  801266:	89 c3                	mov    %eax,%ebx
  801268:	83 c4 20             	add    $0x20,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	78 58                	js     8012c7 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80126f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801272:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801278:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80127a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801287:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80128d:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80128f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801292:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801299:	83 ec 0c             	sub    $0xc,%esp
  80129c:	ff 75 f4             	pushl  -0xc(%ebp)
  80129f:	e8 d6 f0 ff ff       	call   80037a <fd2num>
  8012a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8012a9:	83 c4 04             	add    $0x4,%esp
  8012ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8012af:	e8 c6 f0 ff ff       	call   80037a <fd2num>
  8012b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c2:	e9 4f ff ff ff       	jmp    801216 <pipe+0x75>
	sys_page_unmap(0, va);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	56                   	push   %esi
  8012cb:	6a 00                	push   $0x0
  8012cd:	e8 1d ef ff ff       	call   8001ef <sys_page_unmap>
  8012d2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012db:	6a 00                	push   $0x0
  8012dd:	e8 0d ef ff ff       	call   8001ef <sys_page_unmap>
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	e9 1c ff ff ff       	jmp    801206 <pipe+0x65>

008012ea <pipeisclosed>:
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 08             	pushl  0x8(%ebp)
  8012f7:	e8 f4 f0 ff ff       	call   8003f0 <fd_lookup>
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 18                	js     80131b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801303:	83 ec 0c             	sub    $0xc,%esp
  801306:	ff 75 f4             	pushl  -0xc(%ebp)
  801309:	e8 7c f0 ff ff       	call   80038a <fd2data>
	return _pipeisclosed(fd, p);
  80130e:	89 c2                	mov    %eax,%edx
  801310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801313:	e8 30 fd ff ff       	call   801048 <_pipeisclosed>
  801318:	83 c4 10             	add    $0x10,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801320:	b8 00 00 00 00       	mov    $0x0,%eax
  801325:	5d                   	pop    %ebp
  801326:	c3                   	ret    

00801327 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80132d:	68 9f 23 80 00       	push   $0x80239f
  801332:	ff 75 0c             	pushl  0xc(%ebp)
  801335:	e8 5a 08 00 00       	call   801b94 <strcpy>
	return 0;
}
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <devcons_write>:
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	57                   	push   %edi
  801345:	56                   	push   %esi
  801346:	53                   	push   %ebx
  801347:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80134d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801352:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801358:	eb 2f                	jmp    801389 <devcons_write+0x48>
		m = n - tot;
  80135a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80135d:	29 f3                	sub    %esi,%ebx
  80135f:	83 fb 7f             	cmp    $0x7f,%ebx
  801362:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801367:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80136a:	83 ec 04             	sub    $0x4,%esp
  80136d:	53                   	push   %ebx
  80136e:	89 f0                	mov    %esi,%eax
  801370:	03 45 0c             	add    0xc(%ebp),%eax
  801373:	50                   	push   %eax
  801374:	57                   	push   %edi
  801375:	e8 a8 09 00 00       	call   801d22 <memmove>
		sys_cputs(buf, m);
  80137a:	83 c4 08             	add    $0x8,%esp
  80137d:	53                   	push   %ebx
  80137e:	57                   	push   %edi
  80137f:	e8 2a ed ff ff       	call   8000ae <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801384:	01 de                	add    %ebx,%esi
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	3b 75 10             	cmp    0x10(%ebp),%esi
  80138c:	72 cc                	jb     80135a <devcons_write+0x19>
}
  80138e:	89 f0                	mov    %esi,%eax
  801390:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801393:	5b                   	pop    %ebx
  801394:	5e                   	pop    %esi
  801395:	5f                   	pop    %edi
  801396:	5d                   	pop    %ebp
  801397:	c3                   	ret    

00801398 <devcons_read>:
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 08             	sub    $0x8,%esp
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a7:	75 07                	jne    8013b0 <devcons_read+0x18>
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    
		sys_yield();
  8013ab:	e8 9b ed ff ff       	call   80014b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013b0:	e8 17 ed ff ff       	call   8000cc <sys_cgetc>
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	74 f2                	je     8013ab <devcons_read+0x13>
	if (c < 0)
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 ec                	js     8013a9 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013bd:	83 f8 04             	cmp    $0x4,%eax
  8013c0:	74 0c                	je     8013ce <devcons_read+0x36>
	*(char*)vbuf = c;
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	88 02                	mov    %al,(%edx)
	return 1;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8013cc:	eb db                	jmp    8013a9 <devcons_read+0x11>
		return 0;
  8013ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d3:	eb d4                	jmp    8013a9 <devcons_read+0x11>

008013d5 <cputchar>:
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013e1:	6a 01                	push   $0x1
  8013e3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013e6:	50                   	push   %eax
  8013e7:	e8 c2 ec ff ff       	call   8000ae <sys_cputs>
}
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <getchar>:
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013f7:	6a 01                	push   $0x1
  8013f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013fc:	50                   	push   %eax
  8013fd:	6a 00                	push   $0x0
  8013ff:	e8 5d f2 ff ff       	call   800661 <read>
	if (r < 0)
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	85 c0                	test   %eax,%eax
  801409:	78 08                	js     801413 <getchar+0x22>
	if (r < 1)
  80140b:	85 c0                	test   %eax,%eax
  80140d:	7e 06                	jle    801415 <getchar+0x24>
	return c;
  80140f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    
		return -E_EOF;
  801415:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80141a:	eb f7                	jmp    801413 <getchar+0x22>

0080141c <iscons>:
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801422:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	ff 75 08             	pushl  0x8(%ebp)
  801429:	e8 c2 ef ff ff       	call   8003f0 <fd_lookup>
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 11                	js     801446 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801438:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80143e:	39 10                	cmp    %edx,(%eax)
  801440:	0f 94 c0             	sete   %al
  801443:	0f b6 c0             	movzbl %al,%eax
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <opencons>:
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80144e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	e8 4a ef ff ff       	call   8003a1 <fd_alloc>
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 3a                	js     801498 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	68 07 04 00 00       	push   $0x407
  801466:	ff 75 f4             	pushl  -0xc(%ebp)
  801469:	6a 00                	push   $0x0
  80146b:	e8 fa ec ff ff       	call   80016a <sys_page_alloc>
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	78 21                	js     801498 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147a:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801480:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801485:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80148c:	83 ec 0c             	sub    $0xc,%esp
  80148f:	50                   	push   %eax
  801490:	e8 e5 ee ff ff       	call   80037a <fd2num>
  801495:	83 c4 10             	add    $0x10,%esp
}
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	56                   	push   %esi
  80149e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80149f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014a2:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8014a8:	e8 7f ec ff ff       	call   80012c <sys_getenvid>
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	56                   	push   %esi
  8014b7:	50                   	push   %eax
  8014b8:	68 ac 23 80 00       	push   $0x8023ac
  8014bd:	e8 b3 00 00 00       	call   801575 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014c2:	83 c4 18             	add    $0x18,%esp
  8014c5:	53                   	push   %ebx
  8014c6:	ff 75 10             	pushl  0x10(%ebp)
  8014c9:	e8 56 00 00 00       	call   801524 <vcprintf>
	cprintf("\n");
  8014ce:	c7 04 24 98 23 80 00 	movl   $0x802398,(%esp)
  8014d5:	e8 9b 00 00 00       	call   801575 <cprintf>
  8014da:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014dd:	cc                   	int3   
  8014de:	eb fd                	jmp    8014dd <_panic+0x43>

008014e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014ea:	8b 13                	mov    (%ebx),%edx
  8014ec:	8d 42 01             	lea    0x1(%edx),%eax
  8014ef:	89 03                	mov    %eax,(%ebx)
  8014f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014f4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014fd:	74 09                	je     801508 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801503:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801506:	c9                   	leave  
  801507:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	68 ff 00 00 00       	push   $0xff
  801510:	8d 43 08             	lea    0x8(%ebx),%eax
  801513:	50                   	push   %eax
  801514:	e8 95 eb ff ff       	call   8000ae <sys_cputs>
		b->idx = 0;
  801519:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	eb db                	jmp    8014ff <putch+0x1f>

00801524 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80152d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801534:	00 00 00 
	b.cnt = 0;
  801537:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80153e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80154d:	50                   	push   %eax
  80154e:	68 e0 14 80 00       	push   $0x8014e0
  801553:	e8 1a 01 00 00       	call   801672 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801558:	83 c4 08             	add    $0x8,%esp
  80155b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801561:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801567:	50                   	push   %eax
  801568:	e8 41 eb ff ff       	call   8000ae <sys_cputs>

	return b.cnt;
}
  80156d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80157b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80157e:	50                   	push   %eax
  80157f:	ff 75 08             	pushl  0x8(%ebp)
  801582:	e8 9d ff ff ff       	call   801524 <vcprintf>
	va_end(ap);

	return cnt;
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	57                   	push   %edi
  80158d:	56                   	push   %esi
  80158e:	53                   	push   %ebx
  80158f:	83 ec 1c             	sub    $0x1c,%esp
  801592:	89 c7                	mov    %eax,%edi
  801594:	89 d6                	mov    %edx,%esi
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80159f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015b0:	39 d3                	cmp    %edx,%ebx
  8015b2:	72 05                	jb     8015b9 <printnum+0x30>
  8015b4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015b7:	77 7a                	ja     801633 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015b9:	83 ec 0c             	sub    $0xc,%esp
  8015bc:	ff 75 18             	pushl  0x18(%ebp)
  8015bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015c5:	53                   	push   %ebx
  8015c6:	ff 75 10             	pushl  0x10(%ebp)
  8015c9:	83 ec 08             	sub    $0x8,%esp
  8015cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8015d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8015d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8015d8:	e8 23 0a 00 00       	call   802000 <__udivdi3>
  8015dd:	83 c4 18             	add    $0x18,%esp
  8015e0:	52                   	push   %edx
  8015e1:	50                   	push   %eax
  8015e2:	89 f2                	mov    %esi,%edx
  8015e4:	89 f8                	mov    %edi,%eax
  8015e6:	e8 9e ff ff ff       	call   801589 <printnum>
  8015eb:	83 c4 20             	add    $0x20,%esp
  8015ee:	eb 13                	jmp    801603 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	56                   	push   %esi
  8015f4:	ff 75 18             	pushl  0x18(%ebp)
  8015f7:	ff d7                	call   *%edi
  8015f9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015fc:	83 eb 01             	sub    $0x1,%ebx
  8015ff:	85 db                	test   %ebx,%ebx
  801601:	7f ed                	jg     8015f0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	56                   	push   %esi
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80160d:	ff 75 e0             	pushl  -0x20(%ebp)
  801610:	ff 75 dc             	pushl  -0x24(%ebp)
  801613:	ff 75 d8             	pushl  -0x28(%ebp)
  801616:	e8 05 0b 00 00       	call   802120 <__umoddi3>
  80161b:	83 c4 14             	add    $0x14,%esp
  80161e:	0f be 80 cf 23 80 00 	movsbl 0x8023cf(%eax),%eax
  801625:	50                   	push   %eax
  801626:	ff d7                	call   *%edi
}
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162e:	5b                   	pop    %ebx
  80162f:	5e                   	pop    %esi
  801630:	5f                   	pop    %edi
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    
  801633:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801636:	eb c4                	jmp    8015fc <printnum+0x73>

00801638 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80163e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801642:	8b 10                	mov    (%eax),%edx
  801644:	3b 50 04             	cmp    0x4(%eax),%edx
  801647:	73 0a                	jae    801653 <sprintputch+0x1b>
		*b->buf++ = ch;
  801649:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164c:	89 08                	mov    %ecx,(%eax)
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	88 02                	mov    %al,(%edx)
}
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    

00801655 <printfmt>:
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80165b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80165e:	50                   	push   %eax
  80165f:	ff 75 10             	pushl  0x10(%ebp)
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	e8 05 00 00 00       	call   801672 <vprintfmt>
}
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vprintfmt>:
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	57                   	push   %edi
  801676:	56                   	push   %esi
  801677:	53                   	push   %ebx
  801678:	83 ec 2c             	sub    $0x2c,%esp
  80167b:	8b 75 08             	mov    0x8(%ebp),%esi
  80167e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801681:	8b 7d 10             	mov    0x10(%ebp),%edi
  801684:	e9 c1 03 00 00       	jmp    801a4a <vprintfmt+0x3d8>
		padc = ' ';
  801689:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80168d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801694:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80169b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016a7:	8d 47 01             	lea    0x1(%edi),%eax
  8016aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016ad:	0f b6 17             	movzbl (%edi),%edx
  8016b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016b3:	3c 55                	cmp    $0x55,%al
  8016b5:	0f 87 12 04 00 00    	ja     801acd <vprintfmt+0x45b>
  8016bb:	0f b6 c0             	movzbl %al,%eax
  8016be:	ff 24 85 20 25 80 00 	jmp    *0x802520(,%eax,4)
  8016c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016c8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016cc:	eb d9                	jmp    8016a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016d1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016d5:	eb d0                	jmp    8016a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016d7:	0f b6 d2             	movzbl %dl,%edx
  8016da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016e5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016e8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016ec:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016ef:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016f2:	83 f9 09             	cmp    $0x9,%ecx
  8016f5:	77 55                	ja     80174c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016f7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016fa:	eb e9                	jmp    8016e5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801704:	8b 45 14             	mov    0x14(%ebp),%eax
  801707:	8d 40 04             	lea    0x4(%eax),%eax
  80170a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80170d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801710:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801714:	79 91                	jns    8016a7 <vprintfmt+0x35>
				width = precision, precision = -1;
  801716:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801719:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80171c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801723:	eb 82                	jmp    8016a7 <vprintfmt+0x35>
  801725:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801728:	85 c0                	test   %eax,%eax
  80172a:	ba 00 00 00 00       	mov    $0x0,%edx
  80172f:	0f 49 d0             	cmovns %eax,%edx
  801732:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801735:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801738:	e9 6a ff ff ff       	jmp    8016a7 <vprintfmt+0x35>
  80173d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801740:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801747:	e9 5b ff ff ff       	jmp    8016a7 <vprintfmt+0x35>
  80174c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80174f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801752:	eb bc                	jmp    801710 <vprintfmt+0x9e>
			lflag++;
  801754:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801757:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80175a:	e9 48 ff ff ff       	jmp    8016a7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80175f:	8b 45 14             	mov    0x14(%ebp),%eax
  801762:	8d 78 04             	lea    0x4(%eax),%edi
  801765:	83 ec 08             	sub    $0x8,%esp
  801768:	53                   	push   %ebx
  801769:	ff 30                	pushl  (%eax)
  80176b:	ff d6                	call   *%esi
			break;
  80176d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801770:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801773:	e9 cf 02 00 00       	jmp    801a47 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801778:	8b 45 14             	mov    0x14(%ebp),%eax
  80177b:	8d 78 04             	lea    0x4(%eax),%edi
  80177e:	8b 00                	mov    (%eax),%eax
  801780:	99                   	cltd   
  801781:	31 d0                	xor    %edx,%eax
  801783:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801785:	83 f8 0f             	cmp    $0xf,%eax
  801788:	7f 23                	jg     8017ad <vprintfmt+0x13b>
  80178a:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  801791:	85 d2                	test   %edx,%edx
  801793:	74 18                	je     8017ad <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801795:	52                   	push   %edx
  801796:	68 2d 23 80 00       	push   $0x80232d
  80179b:	53                   	push   %ebx
  80179c:	56                   	push   %esi
  80179d:	e8 b3 fe ff ff       	call   801655 <printfmt>
  8017a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017a5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017a8:	e9 9a 02 00 00       	jmp    801a47 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8017ad:	50                   	push   %eax
  8017ae:	68 e7 23 80 00       	push   $0x8023e7
  8017b3:	53                   	push   %ebx
  8017b4:	56                   	push   %esi
  8017b5:	e8 9b fe ff ff       	call   801655 <printfmt>
  8017ba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017bd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017c0:	e9 82 02 00 00       	jmp    801a47 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017d3:	85 ff                	test   %edi,%edi
  8017d5:	b8 e0 23 80 00       	mov    $0x8023e0,%eax
  8017da:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017e1:	0f 8e bd 00 00 00    	jle    8018a4 <vprintfmt+0x232>
  8017e7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017eb:	75 0e                	jne    8017fb <vprintfmt+0x189>
  8017ed:	89 75 08             	mov    %esi,0x8(%ebp)
  8017f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017f6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017f9:	eb 6d                	jmp    801868 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	ff 75 d0             	pushl  -0x30(%ebp)
  801801:	57                   	push   %edi
  801802:	e8 6e 03 00 00       	call   801b75 <strnlen>
  801807:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80180a:	29 c1                	sub    %eax,%ecx
  80180c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80180f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801812:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801816:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801819:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80181c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80181e:	eb 0f                	jmp    80182f <vprintfmt+0x1bd>
					putch(padc, putdat);
  801820:	83 ec 08             	sub    $0x8,%esp
  801823:	53                   	push   %ebx
  801824:	ff 75 e0             	pushl  -0x20(%ebp)
  801827:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801829:	83 ef 01             	sub    $0x1,%edi
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 ff                	test   %edi,%edi
  801831:	7f ed                	jg     801820 <vprintfmt+0x1ae>
  801833:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801836:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801839:	85 c9                	test   %ecx,%ecx
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
  801840:	0f 49 c1             	cmovns %ecx,%eax
  801843:	29 c1                	sub    %eax,%ecx
  801845:	89 75 08             	mov    %esi,0x8(%ebp)
  801848:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80184b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80184e:	89 cb                	mov    %ecx,%ebx
  801850:	eb 16                	jmp    801868 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801852:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801856:	75 31                	jne    801889 <vprintfmt+0x217>
					putch(ch, putdat);
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	50                   	push   %eax
  80185f:	ff 55 08             	call   *0x8(%ebp)
  801862:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801865:	83 eb 01             	sub    $0x1,%ebx
  801868:	83 c7 01             	add    $0x1,%edi
  80186b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80186f:	0f be c2             	movsbl %dl,%eax
  801872:	85 c0                	test   %eax,%eax
  801874:	74 59                	je     8018cf <vprintfmt+0x25d>
  801876:	85 f6                	test   %esi,%esi
  801878:	78 d8                	js     801852 <vprintfmt+0x1e0>
  80187a:	83 ee 01             	sub    $0x1,%esi
  80187d:	79 d3                	jns    801852 <vprintfmt+0x1e0>
  80187f:	89 df                	mov    %ebx,%edi
  801881:	8b 75 08             	mov    0x8(%ebp),%esi
  801884:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801887:	eb 37                	jmp    8018c0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801889:	0f be d2             	movsbl %dl,%edx
  80188c:	83 ea 20             	sub    $0x20,%edx
  80188f:	83 fa 5e             	cmp    $0x5e,%edx
  801892:	76 c4                	jbe    801858 <vprintfmt+0x1e6>
					putch('?', putdat);
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	6a 3f                	push   $0x3f
  80189c:	ff 55 08             	call   *0x8(%ebp)
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	eb c1                	jmp    801865 <vprintfmt+0x1f3>
  8018a4:	89 75 08             	mov    %esi,0x8(%ebp)
  8018a7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018aa:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018ad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018b0:	eb b6                	jmp    801868 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018b2:	83 ec 08             	sub    $0x8,%esp
  8018b5:	53                   	push   %ebx
  8018b6:	6a 20                	push   $0x20
  8018b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018ba:	83 ef 01             	sub    $0x1,%edi
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	85 ff                	test   %edi,%edi
  8018c2:	7f ee                	jg     8018b2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8018ca:	e9 78 01 00 00       	jmp    801a47 <vprintfmt+0x3d5>
  8018cf:	89 df                	mov    %ebx,%edi
  8018d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8018d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018d7:	eb e7                	jmp    8018c0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8018d9:	83 f9 01             	cmp    $0x1,%ecx
  8018dc:	7e 3f                	jle    80191d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018de:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e1:	8b 50 04             	mov    0x4(%eax),%edx
  8018e4:	8b 00                	mov    (%eax),%eax
  8018e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ef:	8d 40 08             	lea    0x8(%eax),%eax
  8018f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018f9:	79 5c                	jns    801957 <vprintfmt+0x2e5>
				putch('-', putdat);
  8018fb:	83 ec 08             	sub    $0x8,%esp
  8018fe:	53                   	push   %ebx
  8018ff:	6a 2d                	push   $0x2d
  801901:	ff d6                	call   *%esi
				num = -(long long) num;
  801903:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801906:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801909:	f7 da                	neg    %edx
  80190b:	83 d1 00             	adc    $0x0,%ecx
  80190e:	f7 d9                	neg    %ecx
  801910:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801913:	b8 0a 00 00 00       	mov    $0xa,%eax
  801918:	e9 10 01 00 00       	jmp    801a2d <vprintfmt+0x3bb>
	else if (lflag)
  80191d:	85 c9                	test   %ecx,%ecx
  80191f:	75 1b                	jne    80193c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801921:	8b 45 14             	mov    0x14(%ebp),%eax
  801924:	8b 00                	mov    (%eax),%eax
  801926:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801929:	89 c1                	mov    %eax,%ecx
  80192b:	c1 f9 1f             	sar    $0x1f,%ecx
  80192e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801931:	8b 45 14             	mov    0x14(%ebp),%eax
  801934:	8d 40 04             	lea    0x4(%eax),%eax
  801937:	89 45 14             	mov    %eax,0x14(%ebp)
  80193a:	eb b9                	jmp    8018f5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80193c:	8b 45 14             	mov    0x14(%ebp),%eax
  80193f:	8b 00                	mov    (%eax),%eax
  801941:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801944:	89 c1                	mov    %eax,%ecx
  801946:	c1 f9 1f             	sar    $0x1f,%ecx
  801949:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8d 40 04             	lea    0x4(%eax),%eax
  801952:	89 45 14             	mov    %eax,0x14(%ebp)
  801955:	eb 9e                	jmp    8018f5 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801957:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80195a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80195d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801962:	e9 c6 00 00 00       	jmp    801a2d <vprintfmt+0x3bb>
	if (lflag >= 2)
  801967:	83 f9 01             	cmp    $0x1,%ecx
  80196a:	7e 18                	jle    801984 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	8b 10                	mov    (%eax),%edx
  801971:	8b 48 04             	mov    0x4(%eax),%ecx
  801974:	8d 40 08             	lea    0x8(%eax),%eax
  801977:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80197a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80197f:	e9 a9 00 00 00       	jmp    801a2d <vprintfmt+0x3bb>
	else if (lflag)
  801984:	85 c9                	test   %ecx,%ecx
  801986:	75 1a                	jne    8019a2 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  801988:	8b 45 14             	mov    0x14(%ebp),%eax
  80198b:	8b 10                	mov    (%eax),%edx
  80198d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801992:	8d 40 04             	lea    0x4(%eax),%eax
  801995:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801998:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199d:	e9 8b 00 00 00       	jmp    801a2d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a5:	8b 10                	mov    (%eax),%edx
  8019a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ac:	8d 40 04             	lea    0x4(%eax),%eax
  8019af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b7:	eb 74                	jmp    801a2d <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019b9:	83 f9 01             	cmp    $0x1,%ecx
  8019bc:	7e 15                	jle    8019d3 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019be:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c1:	8b 10                	mov    (%eax),%edx
  8019c3:	8b 48 04             	mov    0x4(%eax),%ecx
  8019c6:	8d 40 08             	lea    0x8(%eax),%eax
  8019c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d1:	eb 5a                	jmp    801a2d <vprintfmt+0x3bb>
	else if (lflag)
  8019d3:	85 c9                	test   %ecx,%ecx
  8019d5:	75 17                	jne    8019ee <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019da:	8b 10                	mov    (%eax),%edx
  8019dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e1:	8d 40 04             	lea    0x4(%eax),%eax
  8019e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ec:	eb 3f                	jmp    801a2d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f1:	8b 10                	mov    (%eax),%edx
  8019f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f8:	8d 40 04             	lea    0x4(%eax),%eax
  8019fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801a03:	eb 28                	jmp    801a2d <vprintfmt+0x3bb>
			putch('0', putdat);
  801a05:	83 ec 08             	sub    $0x8,%esp
  801a08:	53                   	push   %ebx
  801a09:	6a 30                	push   $0x30
  801a0b:	ff d6                	call   *%esi
			putch('x', putdat);
  801a0d:	83 c4 08             	add    $0x8,%esp
  801a10:	53                   	push   %ebx
  801a11:	6a 78                	push   $0x78
  801a13:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a15:	8b 45 14             	mov    0x14(%ebp),%eax
  801a18:	8b 10                	mov    (%eax),%edx
  801a1a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a1f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a22:	8d 40 04             	lea    0x4(%eax),%eax
  801a25:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a28:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a34:	57                   	push   %edi
  801a35:	ff 75 e0             	pushl  -0x20(%ebp)
  801a38:	50                   	push   %eax
  801a39:	51                   	push   %ecx
  801a3a:	52                   	push   %edx
  801a3b:	89 da                	mov    %ebx,%edx
  801a3d:	89 f0                	mov    %esi,%eax
  801a3f:	e8 45 fb ff ff       	call   801589 <printnum>
			break;
  801a44:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a4a:	83 c7 01             	add    $0x1,%edi
  801a4d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a51:	83 f8 25             	cmp    $0x25,%eax
  801a54:	0f 84 2f fc ff ff    	je     801689 <vprintfmt+0x17>
			if (ch == '\0')
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	0f 84 8b 00 00 00    	je     801aed <vprintfmt+0x47b>
			putch(ch, putdat);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	53                   	push   %ebx
  801a66:	50                   	push   %eax
  801a67:	ff d6                	call   *%esi
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	eb dc                	jmp    801a4a <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a6e:	83 f9 01             	cmp    $0x1,%ecx
  801a71:	7e 15                	jle    801a88 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a73:	8b 45 14             	mov    0x14(%ebp),%eax
  801a76:	8b 10                	mov    (%eax),%edx
  801a78:	8b 48 04             	mov    0x4(%eax),%ecx
  801a7b:	8d 40 08             	lea    0x8(%eax),%eax
  801a7e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a81:	b8 10 00 00 00       	mov    $0x10,%eax
  801a86:	eb a5                	jmp    801a2d <vprintfmt+0x3bb>
	else if (lflag)
  801a88:	85 c9                	test   %ecx,%ecx
  801a8a:	75 17                	jne    801aa3 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8f:	8b 10                	mov    (%eax),%edx
  801a91:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a96:	8d 40 04             	lea    0x4(%eax),%eax
  801a99:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a9c:	b8 10 00 00 00       	mov    $0x10,%eax
  801aa1:	eb 8a                	jmp    801a2d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa6:	8b 10                	mov    (%eax),%edx
  801aa8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aad:	8d 40 04             	lea    0x4(%eax),%eax
  801ab0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ab3:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab8:	e9 70 ff ff ff       	jmp    801a2d <vprintfmt+0x3bb>
			putch(ch, putdat);
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	53                   	push   %ebx
  801ac1:	6a 25                	push   $0x25
  801ac3:	ff d6                	call   *%esi
			break;
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	e9 7a ff ff ff       	jmp    801a47 <vprintfmt+0x3d5>
			putch('%', putdat);
  801acd:	83 ec 08             	sub    $0x8,%esp
  801ad0:	53                   	push   %ebx
  801ad1:	6a 25                	push   $0x25
  801ad3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	89 f8                	mov    %edi,%eax
  801ada:	eb 03                	jmp    801adf <vprintfmt+0x46d>
  801adc:	83 e8 01             	sub    $0x1,%eax
  801adf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ae3:	75 f7                	jne    801adc <vprintfmt+0x46a>
  801ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ae8:	e9 5a ff ff ff       	jmp    801a47 <vprintfmt+0x3d5>
}
  801aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5f                   	pop    %edi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    

00801af5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 18             	sub    $0x18,%esp
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b04:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b08:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b12:	85 c0                	test   %eax,%eax
  801b14:	74 26                	je     801b3c <vsnprintf+0x47>
  801b16:	85 d2                	test   %edx,%edx
  801b18:	7e 22                	jle    801b3c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b1a:	ff 75 14             	pushl  0x14(%ebp)
  801b1d:	ff 75 10             	pushl  0x10(%ebp)
  801b20:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b23:	50                   	push   %eax
  801b24:	68 38 16 80 00       	push   $0x801638
  801b29:	e8 44 fb ff ff       	call   801672 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b31:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b37:	83 c4 10             	add    $0x10,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    
		return -E_INVAL;
  801b3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b41:	eb f7                	jmp    801b3a <vsnprintf+0x45>

00801b43 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b49:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b4c:	50                   	push   %eax
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 9a ff ff ff       	call   801af5 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b63:	b8 00 00 00 00       	mov    $0x0,%eax
  801b68:	eb 03                	jmp    801b6d <strlen+0x10>
		n++;
  801b6a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b6d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b71:	75 f7                	jne    801b6a <strlen+0xd>
	return n;
}
  801b73:	5d                   	pop    %ebp
  801b74:	c3                   	ret    

00801b75 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b83:	eb 03                	jmp    801b88 <strnlen+0x13>
		n++;
  801b85:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b88:	39 d0                	cmp    %edx,%eax
  801b8a:	74 06                	je     801b92 <strnlen+0x1d>
  801b8c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801b90:	75 f3                	jne    801b85 <strnlen+0x10>
	return n;
}
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    

00801b94 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	53                   	push   %ebx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b9e:	89 c2                	mov    %eax,%edx
  801ba0:	83 c1 01             	add    $0x1,%ecx
  801ba3:	83 c2 01             	add    $0x1,%edx
  801ba6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801baa:	88 5a ff             	mov    %bl,-0x1(%edx)
  801bad:	84 db                	test   %bl,%bl
  801baf:	75 ef                	jne    801ba0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801bb1:	5b                   	pop    %ebx
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    

00801bb4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	53                   	push   %ebx
  801bb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bbb:	53                   	push   %ebx
  801bbc:	e8 9c ff ff ff       	call   801b5d <strlen>
  801bc1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bc4:	ff 75 0c             	pushl  0xc(%ebp)
  801bc7:	01 d8                	add    %ebx,%eax
  801bc9:	50                   	push   %eax
  801bca:	e8 c5 ff ff ff       	call   801b94 <strcpy>
	return dst;
}
  801bcf:	89 d8                	mov    %ebx,%eax
  801bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	8b 75 08             	mov    0x8(%ebp),%esi
  801bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801be1:	89 f3                	mov    %esi,%ebx
  801be3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801be6:	89 f2                	mov    %esi,%edx
  801be8:	eb 0f                	jmp    801bf9 <strncpy+0x23>
		*dst++ = *src;
  801bea:	83 c2 01             	add    $0x1,%edx
  801bed:	0f b6 01             	movzbl (%ecx),%eax
  801bf0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bf3:	80 39 01             	cmpb   $0x1,(%ecx)
  801bf6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801bf9:	39 da                	cmp    %ebx,%edx
  801bfb:	75 ed                	jne    801bea <strncpy+0x14>
	}
	return ret;
}
  801bfd:	89 f0                	mov    %esi,%eax
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    

00801c03 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	8b 75 08             	mov    0x8(%ebp),%esi
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c11:	89 f0                	mov    %esi,%eax
  801c13:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c17:	85 c9                	test   %ecx,%ecx
  801c19:	75 0b                	jne    801c26 <strlcpy+0x23>
  801c1b:	eb 17                	jmp    801c34 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c1d:	83 c2 01             	add    $0x1,%edx
  801c20:	83 c0 01             	add    $0x1,%eax
  801c23:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c26:	39 d8                	cmp    %ebx,%eax
  801c28:	74 07                	je     801c31 <strlcpy+0x2e>
  801c2a:	0f b6 0a             	movzbl (%edx),%ecx
  801c2d:	84 c9                	test   %cl,%cl
  801c2f:	75 ec                	jne    801c1d <strlcpy+0x1a>
		*dst = '\0';
  801c31:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c34:	29 f0                	sub    %esi,%eax
}
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c43:	eb 06                	jmp    801c4b <strcmp+0x11>
		p++, q++;
  801c45:	83 c1 01             	add    $0x1,%ecx
  801c48:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c4b:	0f b6 01             	movzbl (%ecx),%eax
  801c4e:	84 c0                	test   %al,%al
  801c50:	74 04                	je     801c56 <strcmp+0x1c>
  801c52:	3a 02                	cmp    (%edx),%al
  801c54:	74 ef                	je     801c45 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c56:	0f b6 c0             	movzbl %al,%eax
  801c59:	0f b6 12             	movzbl (%edx),%edx
  801c5c:	29 d0                	sub    %edx,%eax
}
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    

00801c60 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	53                   	push   %ebx
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c6f:	eb 06                	jmp    801c77 <strncmp+0x17>
		n--, p++, q++;
  801c71:	83 c0 01             	add    $0x1,%eax
  801c74:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c77:	39 d8                	cmp    %ebx,%eax
  801c79:	74 16                	je     801c91 <strncmp+0x31>
  801c7b:	0f b6 08             	movzbl (%eax),%ecx
  801c7e:	84 c9                	test   %cl,%cl
  801c80:	74 04                	je     801c86 <strncmp+0x26>
  801c82:	3a 0a                	cmp    (%edx),%cl
  801c84:	74 eb                	je     801c71 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c86:	0f b6 00             	movzbl (%eax),%eax
  801c89:	0f b6 12             	movzbl (%edx),%edx
  801c8c:	29 d0                	sub    %edx,%eax
}
  801c8e:	5b                   	pop    %ebx
  801c8f:	5d                   	pop    %ebp
  801c90:	c3                   	ret    
		return 0;
  801c91:	b8 00 00 00 00       	mov    $0x0,%eax
  801c96:	eb f6                	jmp    801c8e <strncmp+0x2e>

00801c98 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ca2:	0f b6 10             	movzbl (%eax),%edx
  801ca5:	84 d2                	test   %dl,%dl
  801ca7:	74 09                	je     801cb2 <strchr+0x1a>
		if (*s == c)
  801ca9:	38 ca                	cmp    %cl,%dl
  801cab:	74 0a                	je     801cb7 <strchr+0x1f>
	for (; *s; s++)
  801cad:	83 c0 01             	add    $0x1,%eax
  801cb0:	eb f0                	jmp    801ca2 <strchr+0xa>
			return (char *) s;
	return 0;
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    

00801cb9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cc3:	eb 03                	jmp    801cc8 <strfind+0xf>
  801cc5:	83 c0 01             	add    $0x1,%eax
  801cc8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801ccb:	38 ca                	cmp    %cl,%dl
  801ccd:	74 04                	je     801cd3 <strfind+0x1a>
  801ccf:	84 d2                	test   %dl,%dl
  801cd1:	75 f2                	jne    801cc5 <strfind+0xc>
			break;
	return (char *) s;
}
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    

00801cd5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	57                   	push   %edi
  801cd9:	56                   	push   %esi
  801cda:	53                   	push   %ebx
  801cdb:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ce1:	85 c9                	test   %ecx,%ecx
  801ce3:	74 13                	je     801cf8 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ce5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801ceb:	75 05                	jne    801cf2 <memset+0x1d>
  801ced:	f6 c1 03             	test   $0x3,%cl
  801cf0:	74 0d                	je     801cff <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf5:	fc                   	cld    
  801cf6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801cf8:	89 f8                	mov    %edi,%eax
  801cfa:	5b                   	pop    %ebx
  801cfb:	5e                   	pop    %esi
  801cfc:	5f                   	pop    %edi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    
		c &= 0xFF;
  801cff:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d03:	89 d3                	mov    %edx,%ebx
  801d05:	c1 e3 08             	shl    $0x8,%ebx
  801d08:	89 d0                	mov    %edx,%eax
  801d0a:	c1 e0 18             	shl    $0x18,%eax
  801d0d:	89 d6                	mov    %edx,%esi
  801d0f:	c1 e6 10             	shl    $0x10,%esi
  801d12:	09 f0                	or     %esi,%eax
  801d14:	09 c2                	or     %eax,%edx
  801d16:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d18:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d1b:	89 d0                	mov    %edx,%eax
  801d1d:	fc                   	cld    
  801d1e:	f3 ab                	rep stos %eax,%es:(%edi)
  801d20:	eb d6                	jmp    801cf8 <memset+0x23>

00801d22 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	57                   	push   %edi
  801d26:	56                   	push   %esi
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d30:	39 c6                	cmp    %eax,%esi
  801d32:	73 35                	jae    801d69 <memmove+0x47>
  801d34:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d37:	39 c2                	cmp    %eax,%edx
  801d39:	76 2e                	jbe    801d69 <memmove+0x47>
		s += n;
		d += n;
  801d3b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d3e:	89 d6                	mov    %edx,%esi
  801d40:	09 fe                	or     %edi,%esi
  801d42:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d48:	74 0c                	je     801d56 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d4a:	83 ef 01             	sub    $0x1,%edi
  801d4d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d50:	fd                   	std    
  801d51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d53:	fc                   	cld    
  801d54:	eb 21                	jmp    801d77 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d56:	f6 c1 03             	test   $0x3,%cl
  801d59:	75 ef                	jne    801d4a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d5b:	83 ef 04             	sub    $0x4,%edi
  801d5e:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d61:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d64:	fd                   	std    
  801d65:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d67:	eb ea                	jmp    801d53 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d69:	89 f2                	mov    %esi,%edx
  801d6b:	09 c2                	or     %eax,%edx
  801d6d:	f6 c2 03             	test   $0x3,%dl
  801d70:	74 09                	je     801d7b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d72:	89 c7                	mov    %eax,%edi
  801d74:	fc                   	cld    
  801d75:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d77:	5e                   	pop    %esi
  801d78:	5f                   	pop    %edi
  801d79:	5d                   	pop    %ebp
  801d7a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d7b:	f6 c1 03             	test   $0x3,%cl
  801d7e:	75 f2                	jne    801d72 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d80:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d83:	89 c7                	mov    %eax,%edi
  801d85:	fc                   	cld    
  801d86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d88:	eb ed                	jmp    801d77 <memmove+0x55>

00801d8a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801d8d:	ff 75 10             	pushl  0x10(%ebp)
  801d90:	ff 75 0c             	pushl  0xc(%ebp)
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	e8 87 ff ff ff       	call   801d22 <memmove>
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da8:	89 c6                	mov    %eax,%esi
  801daa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801dad:	39 f0                	cmp    %esi,%eax
  801daf:	74 1c                	je     801dcd <memcmp+0x30>
		if (*s1 != *s2)
  801db1:	0f b6 08             	movzbl (%eax),%ecx
  801db4:	0f b6 1a             	movzbl (%edx),%ebx
  801db7:	38 d9                	cmp    %bl,%cl
  801db9:	75 08                	jne    801dc3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801dbb:	83 c0 01             	add    $0x1,%eax
  801dbe:	83 c2 01             	add    $0x1,%edx
  801dc1:	eb ea                	jmp    801dad <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dc3:	0f b6 c1             	movzbl %cl,%eax
  801dc6:	0f b6 db             	movzbl %bl,%ebx
  801dc9:	29 d8                	sub    %ebx,%eax
  801dcb:	eb 05                	jmp    801dd2 <memcmp+0x35>
	}

	return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    

00801dd6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801ddf:	89 c2                	mov    %eax,%edx
  801de1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801de4:	39 d0                	cmp    %edx,%eax
  801de6:	73 09                	jae    801df1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801de8:	38 08                	cmp    %cl,(%eax)
  801dea:	74 05                	je     801df1 <memfind+0x1b>
	for (; s < ends; s++)
  801dec:	83 c0 01             	add    $0x1,%eax
  801def:	eb f3                	jmp    801de4 <memfind+0xe>
			break;
	return (void *) s;
}
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    

00801df3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	57                   	push   %edi
  801df7:	56                   	push   %esi
  801df8:	53                   	push   %ebx
  801df9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dff:	eb 03                	jmp    801e04 <strtol+0x11>
		s++;
  801e01:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e04:	0f b6 01             	movzbl (%ecx),%eax
  801e07:	3c 20                	cmp    $0x20,%al
  801e09:	74 f6                	je     801e01 <strtol+0xe>
  801e0b:	3c 09                	cmp    $0x9,%al
  801e0d:	74 f2                	je     801e01 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e0f:	3c 2b                	cmp    $0x2b,%al
  801e11:	74 2e                	je     801e41 <strtol+0x4e>
	int neg = 0;
  801e13:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e18:	3c 2d                	cmp    $0x2d,%al
  801e1a:	74 2f                	je     801e4b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e1c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e22:	75 05                	jne    801e29 <strtol+0x36>
  801e24:	80 39 30             	cmpb   $0x30,(%ecx)
  801e27:	74 2c                	je     801e55 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e29:	85 db                	test   %ebx,%ebx
  801e2b:	75 0a                	jne    801e37 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e2d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e32:	80 39 30             	cmpb   $0x30,(%ecx)
  801e35:	74 28                	je     801e5f <strtol+0x6c>
		base = 10;
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e3f:	eb 50                	jmp    801e91 <strtol+0x9e>
		s++;
  801e41:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e44:	bf 00 00 00 00       	mov    $0x0,%edi
  801e49:	eb d1                	jmp    801e1c <strtol+0x29>
		s++, neg = 1;
  801e4b:	83 c1 01             	add    $0x1,%ecx
  801e4e:	bf 01 00 00 00       	mov    $0x1,%edi
  801e53:	eb c7                	jmp    801e1c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e55:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e59:	74 0e                	je     801e69 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e5b:	85 db                	test   %ebx,%ebx
  801e5d:	75 d8                	jne    801e37 <strtol+0x44>
		s++, base = 8;
  801e5f:	83 c1 01             	add    $0x1,%ecx
  801e62:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e67:	eb ce                	jmp    801e37 <strtol+0x44>
		s += 2, base = 16;
  801e69:	83 c1 02             	add    $0x2,%ecx
  801e6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e71:	eb c4                	jmp    801e37 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e73:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e76:	89 f3                	mov    %esi,%ebx
  801e78:	80 fb 19             	cmp    $0x19,%bl
  801e7b:	77 29                	ja     801ea6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e7d:	0f be d2             	movsbl %dl,%edx
  801e80:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e83:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e86:	7d 30                	jge    801eb8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e88:	83 c1 01             	add    $0x1,%ecx
  801e8b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e8f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e91:	0f b6 11             	movzbl (%ecx),%edx
  801e94:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e97:	89 f3                	mov    %esi,%ebx
  801e99:	80 fb 09             	cmp    $0x9,%bl
  801e9c:	77 d5                	ja     801e73 <strtol+0x80>
			dig = *s - '0';
  801e9e:	0f be d2             	movsbl %dl,%edx
  801ea1:	83 ea 30             	sub    $0x30,%edx
  801ea4:	eb dd                	jmp    801e83 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801ea6:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ea9:	89 f3                	mov    %esi,%ebx
  801eab:	80 fb 19             	cmp    $0x19,%bl
  801eae:	77 08                	ja     801eb8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801eb0:	0f be d2             	movsbl %dl,%edx
  801eb3:	83 ea 37             	sub    $0x37,%edx
  801eb6:	eb cb                	jmp    801e83 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801eb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ebc:	74 05                	je     801ec3 <strtol+0xd0>
		*endptr = (char *) s;
  801ebe:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ec1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ec3:	89 c2                	mov    %eax,%edx
  801ec5:	f7 da                	neg    %edx
  801ec7:	85 ff                	test   %edi,%edi
  801ec9:	0f 45 c2             	cmovne %edx,%eax
}
  801ecc:	5b                   	pop    %ebx
  801ecd:	5e                   	pop    %esi
  801ece:	5f                   	pop    %edi
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    

00801ed1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	56                   	push   %esi
  801ed5:	53                   	push   %ebx
  801ed6:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801edf:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ee1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ee6:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	50                   	push   %eax
  801eed:	e8 28 e4 ff ff       	call   80031a <sys_ipc_recv>
	if (from_env_store)
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 f6                	test   %esi,%esi
  801ef7:	74 14                	je     801f0d <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801ef9:	ba 00 00 00 00       	mov    $0x0,%edx
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 09                	js     801f0b <ipc_recv+0x3a>
  801f02:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f08:	8b 52 74             	mov    0x74(%edx),%edx
  801f0b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f0d:	85 db                	test   %ebx,%ebx
  801f0f:	74 14                	je     801f25 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f11:	ba 00 00 00 00       	mov    $0x0,%edx
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 09                	js     801f23 <ipc_recv+0x52>
  801f1a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f20:	8b 52 78             	mov    0x78(%edx),%edx
  801f23:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 08                	js     801f31 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f29:	a1 08 40 80 00       	mov    0x804008,%eax
  801f2e:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f34:	5b                   	pop    %ebx
  801f35:	5e                   	pop    %esi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    

00801f38 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	57                   	push   %edi
  801f3c:	56                   	push   %esi
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f44:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f4a:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f4c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f51:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f54:	ff 75 14             	pushl  0x14(%ebp)
  801f57:	53                   	push   %ebx
  801f58:	56                   	push   %esi
  801f59:	57                   	push   %edi
  801f5a:	e8 98 e3 ff ff       	call   8002f7 <sys_ipc_try_send>
		if (ret == 0)
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 1e                	je     801f84 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f66:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f69:	75 07                	jne    801f72 <ipc_send+0x3a>
			sys_yield();
  801f6b:	e8 db e1 ff ff       	call   80014b <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f70:	eb e2                	jmp    801f54 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f72:	50                   	push   %eax
  801f73:	68 e0 26 80 00       	push   $0x8026e0
  801f78:	6a 3d                	push   $0x3d
  801f7a:	68 f4 26 80 00       	push   $0x8026f4
  801f7f:	e8 16 f5 ff ff       	call   80149a <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f87:	5b                   	pop    %ebx
  801f88:	5e                   	pop    %esi
  801f89:	5f                   	pop    %edi
  801f8a:	5d                   	pop    %ebp
  801f8b:	c3                   	ret    

00801f8c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f97:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f9a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fa0:	8b 52 50             	mov    0x50(%edx),%edx
  801fa3:	39 ca                	cmp    %ecx,%edx
  801fa5:	74 11                	je     801fb8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fa7:	83 c0 01             	add    $0x1,%eax
  801faa:	3d 00 04 00 00       	cmp    $0x400,%eax
  801faf:	75 e6                	jne    801f97 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	eb 0b                	jmp    801fc3 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fb8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fbb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fc0:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	c1 e8 16             	shr    $0x16,%eax
  801fd0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fdc:	f6 c1 01             	test   $0x1,%cl
  801fdf:	74 1d                	je     801ffe <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fe1:	c1 ea 0c             	shr    $0xc,%edx
  801fe4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801feb:	f6 c2 01             	test   $0x1,%dl
  801fee:	74 0e                	je     801ffe <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ff0:	c1 ea 0c             	shr    $0xc,%edx
  801ff3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ffa:	ef 
  801ffb:	0f b7 c0             	movzwl %ax,%eax
}
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <__udivdi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	83 ec 1c             	sub    $0x1c,%esp
  802007:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80200b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80200f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802013:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802017:	85 d2                	test   %edx,%edx
  802019:	75 35                	jne    802050 <__udivdi3+0x50>
  80201b:	39 f3                	cmp    %esi,%ebx
  80201d:	0f 87 bd 00 00 00    	ja     8020e0 <__udivdi3+0xe0>
  802023:	85 db                	test   %ebx,%ebx
  802025:	89 d9                	mov    %ebx,%ecx
  802027:	75 0b                	jne    802034 <__udivdi3+0x34>
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	31 d2                	xor    %edx,%edx
  802030:	f7 f3                	div    %ebx
  802032:	89 c1                	mov    %eax,%ecx
  802034:	31 d2                	xor    %edx,%edx
  802036:	89 f0                	mov    %esi,%eax
  802038:	f7 f1                	div    %ecx
  80203a:	89 c6                	mov    %eax,%esi
  80203c:	89 e8                	mov    %ebp,%eax
  80203e:	89 f7                	mov    %esi,%edi
  802040:	f7 f1                	div    %ecx
  802042:	89 fa                	mov    %edi,%edx
  802044:	83 c4 1c             	add    $0x1c,%esp
  802047:	5b                   	pop    %ebx
  802048:	5e                   	pop    %esi
  802049:	5f                   	pop    %edi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    
  80204c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802050:	39 f2                	cmp    %esi,%edx
  802052:	77 7c                	ja     8020d0 <__udivdi3+0xd0>
  802054:	0f bd fa             	bsr    %edx,%edi
  802057:	83 f7 1f             	xor    $0x1f,%edi
  80205a:	0f 84 98 00 00 00    	je     8020f8 <__udivdi3+0xf8>
  802060:	89 f9                	mov    %edi,%ecx
  802062:	b8 20 00 00 00       	mov    $0x20,%eax
  802067:	29 f8                	sub    %edi,%eax
  802069:	d3 e2                	shl    %cl,%edx
  80206b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80206f:	89 c1                	mov    %eax,%ecx
  802071:	89 da                	mov    %ebx,%edx
  802073:	d3 ea                	shr    %cl,%edx
  802075:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802079:	09 d1                	or     %edx,%ecx
  80207b:	89 f2                	mov    %esi,%edx
  80207d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802081:	89 f9                	mov    %edi,%ecx
  802083:	d3 e3                	shl    %cl,%ebx
  802085:	89 c1                	mov    %eax,%ecx
  802087:	d3 ea                	shr    %cl,%edx
  802089:	89 f9                	mov    %edi,%ecx
  80208b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80208f:	d3 e6                	shl    %cl,%esi
  802091:	89 eb                	mov    %ebp,%ebx
  802093:	89 c1                	mov    %eax,%ecx
  802095:	d3 eb                	shr    %cl,%ebx
  802097:	09 de                	or     %ebx,%esi
  802099:	89 f0                	mov    %esi,%eax
  80209b:	f7 74 24 08          	divl   0x8(%esp)
  80209f:	89 d6                	mov    %edx,%esi
  8020a1:	89 c3                	mov    %eax,%ebx
  8020a3:	f7 64 24 0c          	mull   0xc(%esp)
  8020a7:	39 d6                	cmp    %edx,%esi
  8020a9:	72 0c                	jb     8020b7 <__udivdi3+0xb7>
  8020ab:	89 f9                	mov    %edi,%ecx
  8020ad:	d3 e5                	shl    %cl,%ebp
  8020af:	39 c5                	cmp    %eax,%ebp
  8020b1:	73 5d                	jae    802110 <__udivdi3+0x110>
  8020b3:	39 d6                	cmp    %edx,%esi
  8020b5:	75 59                	jne    802110 <__udivdi3+0x110>
  8020b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020ba:	31 ff                	xor    %edi,%edi
  8020bc:	89 fa                	mov    %edi,%edx
  8020be:	83 c4 1c             	add    $0x1c,%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5f                   	pop    %edi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    
  8020c6:	8d 76 00             	lea    0x0(%esi),%esi
  8020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8020d0:	31 ff                	xor    %edi,%edi
  8020d2:	31 c0                	xor    %eax,%eax
  8020d4:	89 fa                	mov    %edi,%edx
  8020d6:	83 c4 1c             	add    $0x1c,%esp
  8020d9:	5b                   	pop    %ebx
  8020da:	5e                   	pop    %esi
  8020db:	5f                   	pop    %edi
  8020dc:	5d                   	pop    %ebp
  8020dd:	c3                   	ret    
  8020de:	66 90                	xchg   %ax,%ax
  8020e0:	31 ff                	xor    %edi,%edi
  8020e2:	89 e8                	mov    %ebp,%eax
  8020e4:	89 f2                	mov    %esi,%edx
  8020e6:	f7 f3                	div    %ebx
  8020e8:	89 fa                	mov    %edi,%edx
  8020ea:	83 c4 1c             	add    $0x1c,%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5f                   	pop    %edi
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    
  8020f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020f8:	39 f2                	cmp    %esi,%edx
  8020fa:	72 06                	jb     802102 <__udivdi3+0x102>
  8020fc:	31 c0                	xor    %eax,%eax
  8020fe:	39 eb                	cmp    %ebp,%ebx
  802100:	77 d2                	ja     8020d4 <__udivdi3+0xd4>
  802102:	b8 01 00 00 00       	mov    $0x1,%eax
  802107:	eb cb                	jmp    8020d4 <__udivdi3+0xd4>
  802109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802110:	89 d8                	mov    %ebx,%eax
  802112:	31 ff                	xor    %edi,%edi
  802114:	eb be                	jmp    8020d4 <__udivdi3+0xd4>
  802116:	66 90                	xchg   %ax,%ax
  802118:	66 90                	xchg   %ax,%ax
  80211a:	66 90                	xchg   %ax,%ax
  80211c:	66 90                	xchg   %ax,%ax
  80211e:	66 90                	xchg   %ax,%ax

00802120 <__umoddi3>:
  802120:	55                   	push   %ebp
  802121:	57                   	push   %edi
  802122:	56                   	push   %esi
  802123:	53                   	push   %ebx
  802124:	83 ec 1c             	sub    $0x1c,%esp
  802127:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80212b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80212f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802137:	85 ed                	test   %ebp,%ebp
  802139:	89 f0                	mov    %esi,%eax
  80213b:	89 da                	mov    %ebx,%edx
  80213d:	75 19                	jne    802158 <__umoddi3+0x38>
  80213f:	39 df                	cmp    %ebx,%edi
  802141:	0f 86 b1 00 00 00    	jbe    8021f8 <__umoddi3+0xd8>
  802147:	f7 f7                	div    %edi
  802149:	89 d0                	mov    %edx,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	83 c4 1c             	add    $0x1c,%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5f                   	pop    %edi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	39 dd                	cmp    %ebx,%ebp
  80215a:	77 f1                	ja     80214d <__umoddi3+0x2d>
  80215c:	0f bd cd             	bsr    %ebp,%ecx
  80215f:	83 f1 1f             	xor    $0x1f,%ecx
  802162:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802166:	0f 84 b4 00 00 00    	je     802220 <__umoddi3+0x100>
  80216c:	b8 20 00 00 00       	mov    $0x20,%eax
  802171:	89 c2                	mov    %eax,%edx
  802173:	8b 44 24 04          	mov    0x4(%esp),%eax
  802177:	29 c2                	sub    %eax,%edx
  802179:	89 c1                	mov    %eax,%ecx
  80217b:	89 f8                	mov    %edi,%eax
  80217d:	d3 e5                	shl    %cl,%ebp
  80217f:	89 d1                	mov    %edx,%ecx
  802181:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802185:	d3 e8                	shr    %cl,%eax
  802187:	09 c5                	or     %eax,%ebp
  802189:	8b 44 24 04          	mov    0x4(%esp),%eax
  80218d:	89 c1                	mov    %eax,%ecx
  80218f:	d3 e7                	shl    %cl,%edi
  802191:	89 d1                	mov    %edx,%ecx
  802193:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802197:	89 df                	mov    %ebx,%edi
  802199:	d3 ef                	shr    %cl,%edi
  80219b:	89 c1                	mov    %eax,%ecx
  80219d:	89 f0                	mov    %esi,%eax
  80219f:	d3 e3                	shl    %cl,%ebx
  8021a1:	89 d1                	mov    %edx,%ecx
  8021a3:	89 fa                	mov    %edi,%edx
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021ac:	09 d8                	or     %ebx,%eax
  8021ae:	f7 f5                	div    %ebp
  8021b0:	d3 e6                	shl    %cl,%esi
  8021b2:	89 d1                	mov    %edx,%ecx
  8021b4:	f7 64 24 08          	mull   0x8(%esp)
  8021b8:	39 d1                	cmp    %edx,%ecx
  8021ba:	89 c3                	mov    %eax,%ebx
  8021bc:	89 d7                	mov    %edx,%edi
  8021be:	72 06                	jb     8021c6 <__umoddi3+0xa6>
  8021c0:	75 0e                	jne    8021d0 <__umoddi3+0xb0>
  8021c2:	39 c6                	cmp    %eax,%esi
  8021c4:	73 0a                	jae    8021d0 <__umoddi3+0xb0>
  8021c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8021ca:	19 ea                	sbb    %ebp,%edx
  8021cc:	89 d7                	mov    %edx,%edi
  8021ce:	89 c3                	mov    %eax,%ebx
  8021d0:	89 ca                	mov    %ecx,%edx
  8021d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8021d7:	29 de                	sub    %ebx,%esi
  8021d9:	19 fa                	sbb    %edi,%edx
  8021db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021df:	89 d0                	mov    %edx,%eax
  8021e1:	d3 e0                	shl    %cl,%eax
  8021e3:	89 d9                	mov    %ebx,%ecx
  8021e5:	d3 ee                	shr    %cl,%esi
  8021e7:	d3 ea                	shr    %cl,%edx
  8021e9:	09 f0                	or     %esi,%eax
  8021eb:	83 c4 1c             	add    $0x1c,%esp
  8021ee:	5b                   	pop    %ebx
  8021ef:	5e                   	pop    %esi
  8021f0:	5f                   	pop    %edi
  8021f1:	5d                   	pop    %ebp
  8021f2:	c3                   	ret    
  8021f3:	90                   	nop
  8021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f8:	85 ff                	test   %edi,%edi
  8021fa:	89 f9                	mov    %edi,%ecx
  8021fc:	75 0b                	jne    802209 <__umoddi3+0xe9>
  8021fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802203:	31 d2                	xor    %edx,%edx
  802205:	f7 f7                	div    %edi
  802207:	89 c1                	mov    %eax,%ecx
  802209:	89 d8                	mov    %ebx,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f1                	div    %ecx
  80220f:	89 f0                	mov    %esi,%eax
  802211:	f7 f1                	div    %ecx
  802213:	e9 31 ff ff ff       	jmp    802149 <__umoddi3+0x29>
  802218:	90                   	nop
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	39 dd                	cmp    %ebx,%ebp
  802222:	72 08                	jb     80222c <__umoddi3+0x10c>
  802224:	39 f7                	cmp    %esi,%edi
  802226:	0f 87 21 ff ff ff    	ja     80214d <__umoddi3+0x2d>
  80222c:	89 da                	mov    %ebx,%edx
  80222e:	89 f0                	mov    %esi,%eax
  802230:	29 f8                	sub    %edi,%eax
  802232:	19 ea                	sbb    %ebp,%edx
  802234:	e9 14 ff ff ff       	jmp    80214d <__umoddi3+0x2d>

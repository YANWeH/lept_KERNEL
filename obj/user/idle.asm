
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 30 80 00 40 	movl   $0x802240,0x803000
  800040:	22 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 ff 00 00 00       	call   800147 <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800055:	e8 ce 00 00 00       	call   800128 <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x2d>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800096:	e8 b1 04 00 00       	call   80054c <close_all>
	sys_env_destroy(0);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	e8 42 00 00 00       	call   8000e7 <sys_env_destroy>
}
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	c9                   	leave  
  8000a9:	c3                   	ret    

008000aa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	57                   	push   %edi
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bb:	89 c3                	mov    %eax,%ebx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c3:	5b                   	pop    %ebx
  8000c4:	5e                   	pop    %esi
  8000c5:	5f                   	pop    %edi
  8000c6:	5d                   	pop    %ebp
  8000c7:	c3                   	ret    

008000c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	57                   	push   %edi
  8000cc:	56                   	push   %esi
  8000cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d8:	89 d1                	mov    %edx,%ecx
  8000da:	89 d3                	mov    %edx,%ebx
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	89 d6                	mov    %edx,%esi
  8000e0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5f                   	pop    %edi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	57                   	push   %edi
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fd:	89 cb                	mov    %ecx,%ebx
  8000ff:	89 cf                	mov    %ecx,%edi
  800101:	89 ce                	mov    %ecx,%esi
  800103:	cd 30                	int    $0x30
	if(check && ret > 0)
  800105:	85 c0                	test   %eax,%eax
  800107:	7f 08                	jg     800111 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	6a 03                	push   $0x3
  800117:	68 4f 22 80 00       	push   $0x80224f
  80011c:	6a 23                	push   $0x23
  80011e:	68 6c 22 80 00       	push   $0x80226c
  800123:	e8 6e 13 00 00       	call   801496 <_panic>

00800128 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	57                   	push   %edi
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012e:	ba 00 00 00 00       	mov    $0x0,%edx
  800133:	b8 02 00 00 00       	mov    $0x2,%eax
  800138:	89 d1                	mov    %edx,%ecx
  80013a:	89 d3                	mov    %edx,%ebx
  80013c:	89 d7                	mov    %edx,%edi
  80013e:	89 d6                	mov    %edx,%esi
  800140:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <sys_yield>:

void
sys_yield(void)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	57                   	push   %edi
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014d:	ba 00 00 00 00       	mov    $0x0,%edx
  800152:	b8 0b 00 00 00       	mov    $0xb,%eax
  800157:	89 d1                	mov    %edx,%ecx
  800159:	89 d3                	mov    %edx,%ebx
  80015b:	89 d7                	mov    %edx,%edi
  80015d:	89 d6                	mov    %edx,%esi
  80015f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800161:	5b                   	pop    %ebx
  800162:	5e                   	pop    %esi
  800163:	5f                   	pop    %edi
  800164:	5d                   	pop    %ebp
  800165:	c3                   	ret    

00800166 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	57                   	push   %edi
  80016a:	56                   	push   %esi
  80016b:	53                   	push   %ebx
  80016c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016f:	be 00 00 00 00       	mov    $0x0,%esi
  800174:	8b 55 08             	mov    0x8(%ebp),%edx
  800177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017a:	b8 04 00 00 00       	mov    $0x4,%eax
  80017f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800182:	89 f7                	mov    %esi,%edi
  800184:	cd 30                	int    $0x30
	if(check && ret > 0)
  800186:	85 c0                	test   %eax,%eax
  800188:	7f 08                	jg     800192 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018d:	5b                   	pop    %ebx
  80018e:	5e                   	pop    %esi
  80018f:	5f                   	pop    %edi
  800190:	5d                   	pop    %ebp
  800191:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	6a 04                	push   $0x4
  800198:	68 4f 22 80 00       	push   $0x80224f
  80019d:	6a 23                	push   $0x23
  80019f:	68 6c 22 80 00       	push   $0x80226c
  8001a4:	e8 ed 12 00 00       	call   801496 <_panic>

008001a9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	57                   	push   %edi
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c8:	85 c0                	test   %eax,%eax
  8001ca:	7f 08                	jg     8001d4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	50                   	push   %eax
  8001d8:	6a 05                	push   $0x5
  8001da:	68 4f 22 80 00       	push   $0x80224f
  8001df:	6a 23                	push   $0x23
  8001e1:	68 6c 22 80 00       	push   $0x80226c
  8001e6:	e8 ab 12 00 00       	call   801496 <_panic>

008001eb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	57                   	push   %edi
  8001ef:	56                   	push   %esi
  8001f0:	53                   	push   %ebx
  8001f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ff:	b8 06 00 00 00       	mov    $0x6,%eax
  800204:	89 df                	mov    %ebx,%edi
  800206:	89 de                	mov    %ebx,%esi
  800208:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020a:	85 c0                	test   %eax,%eax
  80020c:	7f 08                	jg     800216 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800211:	5b                   	pop    %ebx
  800212:	5e                   	pop    %esi
  800213:	5f                   	pop    %edi
  800214:	5d                   	pop    %ebp
  800215:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	50                   	push   %eax
  80021a:	6a 06                	push   $0x6
  80021c:	68 4f 22 80 00       	push   $0x80224f
  800221:	6a 23                	push   $0x23
  800223:	68 6c 22 80 00       	push   $0x80226c
  800228:	e8 69 12 00 00       	call   801496 <_panic>

0080022d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	57                   	push   %edi
  800231:	56                   	push   %esi
  800232:	53                   	push   %ebx
  800233:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023b:	8b 55 08             	mov    0x8(%ebp),%edx
  80023e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800241:	b8 08 00 00 00       	mov    $0x8,%eax
  800246:	89 df                	mov    %ebx,%edi
  800248:	89 de                	mov    %ebx,%esi
  80024a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024c:	85 c0                	test   %eax,%eax
  80024e:	7f 08                	jg     800258 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800253:	5b                   	pop    %ebx
  800254:	5e                   	pop    %esi
  800255:	5f                   	pop    %edi
  800256:	5d                   	pop    %ebp
  800257:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	50                   	push   %eax
  80025c:	6a 08                	push   $0x8
  80025e:	68 4f 22 80 00       	push   $0x80224f
  800263:	6a 23                	push   $0x23
  800265:	68 6c 22 80 00       	push   $0x80226c
  80026a:	e8 27 12 00 00       	call   801496 <_panic>

0080026f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	57                   	push   %edi
  800273:	56                   	push   %esi
  800274:	53                   	push   %ebx
  800275:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800278:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027d:	8b 55 08             	mov    0x8(%ebp),%edx
  800280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800283:	b8 09 00 00 00       	mov    $0x9,%eax
  800288:	89 df                	mov    %ebx,%edi
  80028a:	89 de                	mov    %ebx,%esi
  80028c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028e:	85 c0                	test   %eax,%eax
  800290:	7f 08                	jg     80029a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800295:	5b                   	pop    %ebx
  800296:	5e                   	pop    %esi
  800297:	5f                   	pop    %edi
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	50                   	push   %eax
  80029e:	6a 09                	push   $0x9
  8002a0:	68 4f 22 80 00       	push   $0x80224f
  8002a5:	6a 23                	push   $0x23
  8002a7:	68 6c 22 80 00       	push   $0x80226c
  8002ac:	e8 e5 11 00 00       	call   801496 <_panic>

008002b1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ca:	89 df                	mov    %ebx,%edi
  8002cc:	89 de                	mov    %ebx,%esi
  8002ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	7f 08                	jg     8002dc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d7:	5b                   	pop    %ebx
  8002d8:	5e                   	pop    %esi
  8002d9:	5f                   	pop    %edi
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	50                   	push   %eax
  8002e0:	6a 0a                	push   $0xa
  8002e2:	68 4f 22 80 00       	push   $0x80224f
  8002e7:	6a 23                	push   $0x23
  8002e9:	68 6c 22 80 00       	push   $0x80226c
  8002ee:	e8 a3 11 00 00       	call   801496 <_panic>

008002f3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ff:	b8 0c 00 00 00       	mov    $0xc,%eax
  800304:	be 00 00 00 00       	mov    $0x0,%esi
  800309:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5f                   	pop    %edi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	57                   	push   %edi
  80031a:	56                   	push   %esi
  80031b:	53                   	push   %ebx
  80031c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800324:	8b 55 08             	mov    0x8(%ebp),%edx
  800327:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032c:	89 cb                	mov    %ecx,%ebx
  80032e:	89 cf                	mov    %ecx,%edi
  800330:	89 ce                	mov    %ecx,%esi
  800332:	cd 30                	int    $0x30
	if(check && ret > 0)
  800334:	85 c0                	test   %eax,%eax
  800336:	7f 08                	jg     800340 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800338:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033b:	5b                   	pop    %ebx
  80033c:	5e                   	pop    %esi
  80033d:	5f                   	pop    %edi
  80033e:	5d                   	pop    %ebp
  80033f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	6a 0d                	push   $0xd
  800346:	68 4f 22 80 00       	push   $0x80224f
  80034b:	6a 23                	push   $0x23
  80034d:	68 6c 22 80 00       	push   $0x80226c
  800352:	e8 3f 11 00 00       	call   801496 <_panic>

00800357 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	57                   	push   %edi
  80035b:	56                   	push   %esi
  80035c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035d:	ba 00 00 00 00       	mov    $0x0,%edx
  800362:	b8 0e 00 00 00       	mov    $0xe,%eax
  800367:	89 d1                	mov    %edx,%ecx
  800369:	89 d3                	mov    %edx,%ebx
  80036b:	89 d7                	mov    %edx,%edi
  80036d:	89 d6                	mov    %edx,%esi
  80036f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800371:	5b                   	pop    %ebx
  800372:	5e                   	pop    %esi
  800373:	5f                   	pop    %edi
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	05 00 00 00 30       	add    $0x30000000,%eax
  800381:	c1 e8 0c             	shr    $0xc,%eax
}
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    

00800386 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800391:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800396:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80039b:	5d                   	pop    %ebp
  80039c:	c3                   	ret    

0080039d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a8:	89 c2                	mov    %eax,%edx
  8003aa:	c1 ea 16             	shr    $0x16,%edx
  8003ad:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b4:	f6 c2 01             	test   $0x1,%dl
  8003b7:	74 2a                	je     8003e3 <fd_alloc+0x46>
  8003b9:	89 c2                	mov    %eax,%edx
  8003bb:	c1 ea 0c             	shr    $0xc,%edx
  8003be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c5:	f6 c2 01             	test   $0x1,%dl
  8003c8:	74 19                	je     8003e3 <fd_alloc+0x46>
  8003ca:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003cf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d4:	75 d2                	jne    8003a8 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003d6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003dc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003e1:	eb 07                	jmp    8003ea <fd_alloc+0x4d>
			*fd_store = fd;
  8003e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003f2:	83 f8 1f             	cmp    $0x1f,%eax
  8003f5:	77 36                	ja     80042d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003f7:	c1 e0 0c             	shl    $0xc,%eax
  8003fa:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ff:	89 c2                	mov    %eax,%edx
  800401:	c1 ea 16             	shr    $0x16,%edx
  800404:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80040b:	f6 c2 01             	test   $0x1,%dl
  80040e:	74 24                	je     800434 <fd_lookup+0x48>
  800410:	89 c2                	mov    %eax,%edx
  800412:	c1 ea 0c             	shr    $0xc,%edx
  800415:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80041c:	f6 c2 01             	test   $0x1,%dl
  80041f:	74 1a                	je     80043b <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800421:	8b 55 0c             	mov    0xc(%ebp),%edx
  800424:	89 02                	mov    %eax,(%edx)
	return 0;
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    
		return -E_INVAL;
  80042d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800432:	eb f7                	jmp    80042b <fd_lookup+0x3f>
		return -E_INVAL;
  800434:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800439:	eb f0                	jmp    80042b <fd_lookup+0x3f>
  80043b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800440:	eb e9                	jmp    80042b <fd_lookup+0x3f>

00800442 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044b:	ba f8 22 80 00       	mov    $0x8022f8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800450:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800455:	39 08                	cmp    %ecx,(%eax)
  800457:	74 33                	je     80048c <dev_lookup+0x4a>
  800459:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80045c:	8b 02                	mov    (%edx),%eax
  80045e:	85 c0                	test   %eax,%eax
  800460:	75 f3                	jne    800455 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800462:	a1 08 40 80 00       	mov    0x804008,%eax
  800467:	8b 40 48             	mov    0x48(%eax),%eax
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	51                   	push   %ecx
  80046e:	50                   	push   %eax
  80046f:	68 7c 22 80 00       	push   $0x80227c
  800474:	e8 f8 10 00 00       	call   801571 <cprintf>
	*dev = 0;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80048a:	c9                   	leave  
  80048b:	c3                   	ret    
			*dev = devtab[i];
  80048c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
  800496:	eb f2                	jmp    80048a <dev_lookup+0x48>

00800498 <fd_close>:
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	57                   	push   %edi
  80049c:	56                   	push   %esi
  80049d:	53                   	push   %ebx
  80049e:	83 ec 1c             	sub    $0x1c,%esp
  8004a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004aa:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004b1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b4:	50                   	push   %eax
  8004b5:	e8 32 ff ff ff       	call   8003ec <fd_lookup>
  8004ba:	89 c3                	mov    %eax,%ebx
  8004bc:	83 c4 08             	add    $0x8,%esp
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	78 05                	js     8004c8 <fd_close+0x30>
	    || fd != fd2)
  8004c3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004c6:	74 16                	je     8004de <fd_close+0x46>
		return (must_exist ? r : 0);
  8004c8:	89 f8                	mov    %edi,%eax
  8004ca:	84 c0                	test   %al,%al
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d4:	89 d8                	mov    %ebx,%eax
  8004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d9:	5b                   	pop    %ebx
  8004da:	5e                   	pop    %esi
  8004db:	5f                   	pop    %edi
  8004dc:	5d                   	pop    %ebp
  8004dd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e4:	50                   	push   %eax
  8004e5:	ff 36                	pushl  (%esi)
  8004e7:	e8 56 ff ff ff       	call   800442 <dev_lookup>
  8004ec:	89 c3                	mov    %eax,%ebx
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	78 15                	js     80050a <fd_close+0x72>
		if (dev->dev_close)
  8004f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f8:	8b 40 10             	mov    0x10(%eax),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	74 1b                	je     80051a <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004ff:	83 ec 0c             	sub    $0xc,%esp
  800502:	56                   	push   %esi
  800503:	ff d0                	call   *%eax
  800505:	89 c3                	mov    %eax,%ebx
  800507:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	56                   	push   %esi
  80050e:	6a 00                	push   $0x0
  800510:	e8 d6 fc ff ff       	call   8001eb <sys_page_unmap>
	return r;
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	eb ba                	jmp    8004d4 <fd_close+0x3c>
			r = 0;
  80051a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80051f:	eb e9                	jmp    80050a <fd_close+0x72>

00800521 <close>:

int
close(int fdnum)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800527:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80052a:	50                   	push   %eax
  80052b:	ff 75 08             	pushl  0x8(%ebp)
  80052e:	e8 b9 fe ff ff       	call   8003ec <fd_lookup>
  800533:	83 c4 08             	add    $0x8,%esp
  800536:	85 c0                	test   %eax,%eax
  800538:	78 10                	js     80054a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	6a 01                	push   $0x1
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	e8 51 ff ff ff       	call   800498 <fd_close>
  800547:	83 c4 10             	add    $0x10,%esp
}
  80054a:	c9                   	leave  
  80054b:	c3                   	ret    

0080054c <close_all>:

void
close_all(void)
{
  80054c:	55                   	push   %ebp
  80054d:	89 e5                	mov    %esp,%ebp
  80054f:	53                   	push   %ebx
  800550:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800553:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	53                   	push   %ebx
  80055c:	e8 c0 ff ff ff       	call   800521 <close>
	for (i = 0; i < MAXFD; i++)
  800561:	83 c3 01             	add    $0x1,%ebx
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	83 fb 20             	cmp    $0x20,%ebx
  80056a:	75 ec                	jne    800558 <close_all+0xc>
}
  80056c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	57                   	push   %edi
  800575:	56                   	push   %esi
  800576:	53                   	push   %ebx
  800577:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80057a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80057d:	50                   	push   %eax
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	e8 66 fe ff ff       	call   8003ec <fd_lookup>
  800586:	89 c3                	mov    %eax,%ebx
  800588:	83 c4 08             	add    $0x8,%esp
  80058b:	85 c0                	test   %eax,%eax
  80058d:	0f 88 81 00 00 00    	js     800614 <dup+0xa3>
		return r;
	close(newfdnum);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	e8 83 ff ff ff       	call   800521 <close>

	newfd = INDEX2FD(newfdnum);
  80059e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a1:	c1 e6 0c             	shl    $0xc,%esi
  8005a4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005aa:	83 c4 04             	add    $0x4,%esp
  8005ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b0:	e8 d1 fd ff ff       	call   800386 <fd2data>
  8005b5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005b7:	89 34 24             	mov    %esi,(%esp)
  8005ba:	e8 c7 fd ff ff       	call   800386 <fd2data>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	c1 e8 16             	shr    $0x16,%eax
  8005c9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005d0:	a8 01                	test   $0x1,%al
  8005d2:	74 11                	je     8005e5 <dup+0x74>
  8005d4:	89 d8                	mov    %ebx,%eax
  8005d6:	c1 e8 0c             	shr    $0xc,%eax
  8005d9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005e0:	f6 c2 01             	test   $0x1,%dl
  8005e3:	75 39                	jne    80061e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e8:	89 d0                	mov    %edx,%eax
  8005ea:	c1 e8 0c             	shr    $0xc,%eax
  8005ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f4:	83 ec 0c             	sub    $0xc,%esp
  8005f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8005fc:	50                   	push   %eax
  8005fd:	56                   	push   %esi
  8005fe:	6a 00                	push   $0x0
  800600:	52                   	push   %edx
  800601:	6a 00                	push   $0x0
  800603:	e8 a1 fb ff ff       	call   8001a9 <sys_page_map>
  800608:	89 c3                	mov    %eax,%ebx
  80060a:	83 c4 20             	add    $0x20,%esp
  80060d:	85 c0                	test   %eax,%eax
  80060f:	78 31                	js     800642 <dup+0xd1>
		goto err;

	return newfdnum;
  800611:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800614:	89 d8                	mov    %ebx,%eax
  800616:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800619:	5b                   	pop    %ebx
  80061a:	5e                   	pop    %esi
  80061b:	5f                   	pop    %edi
  80061c:	5d                   	pop    %ebp
  80061d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80061e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	25 07 0e 00 00       	and    $0xe07,%eax
  80062d:	50                   	push   %eax
  80062e:	57                   	push   %edi
  80062f:	6a 00                	push   $0x0
  800631:	53                   	push   %ebx
  800632:	6a 00                	push   $0x0
  800634:	e8 70 fb ff ff       	call   8001a9 <sys_page_map>
  800639:	89 c3                	mov    %eax,%ebx
  80063b:	83 c4 20             	add    $0x20,%esp
  80063e:	85 c0                	test   %eax,%eax
  800640:	79 a3                	jns    8005e5 <dup+0x74>
	sys_page_unmap(0, newfd);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	56                   	push   %esi
  800646:	6a 00                	push   $0x0
  800648:	e8 9e fb ff ff       	call   8001eb <sys_page_unmap>
	sys_page_unmap(0, nva);
  80064d:	83 c4 08             	add    $0x8,%esp
  800650:	57                   	push   %edi
  800651:	6a 00                	push   $0x0
  800653:	e8 93 fb ff ff       	call   8001eb <sys_page_unmap>
	return r;
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	eb b7                	jmp    800614 <dup+0xa3>

0080065d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80065d:	55                   	push   %ebp
  80065e:	89 e5                	mov    %esp,%ebp
  800660:	53                   	push   %ebx
  800661:	83 ec 14             	sub    $0x14,%esp
  800664:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800667:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80066a:	50                   	push   %eax
  80066b:	53                   	push   %ebx
  80066c:	e8 7b fd ff ff       	call   8003ec <fd_lookup>
  800671:	83 c4 08             	add    $0x8,%esp
  800674:	85 c0                	test   %eax,%eax
  800676:	78 3f                	js     8006b7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80067e:	50                   	push   %eax
  80067f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800682:	ff 30                	pushl  (%eax)
  800684:	e8 b9 fd ff ff       	call   800442 <dev_lookup>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	85 c0                	test   %eax,%eax
  80068e:	78 27                	js     8006b7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800690:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800693:	8b 42 08             	mov    0x8(%edx),%eax
  800696:	83 e0 03             	and    $0x3,%eax
  800699:	83 f8 01             	cmp    $0x1,%eax
  80069c:	74 1e                	je     8006bc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80069e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a1:	8b 40 08             	mov    0x8(%eax),%eax
  8006a4:	85 c0                	test   %eax,%eax
  8006a6:	74 35                	je     8006dd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006a8:	83 ec 04             	sub    $0x4,%esp
  8006ab:	ff 75 10             	pushl  0x10(%ebp)
  8006ae:	ff 75 0c             	pushl  0xc(%ebp)
  8006b1:	52                   	push   %edx
  8006b2:	ff d0                	call   *%eax
  8006b4:	83 c4 10             	add    $0x10,%esp
}
  8006b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8006c1:	8b 40 48             	mov    0x48(%eax),%eax
  8006c4:	83 ec 04             	sub    $0x4,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	50                   	push   %eax
  8006c9:	68 bd 22 80 00       	push   $0x8022bd
  8006ce:	e8 9e 0e 00 00       	call   801571 <cprintf>
		return -E_INVAL;
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006db:	eb da                	jmp    8006b7 <read+0x5a>
		return -E_NOT_SUPP;
  8006dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006e2:	eb d3                	jmp    8006b7 <read+0x5a>

008006e4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	57                   	push   %edi
  8006e8:	56                   	push   %esi
  8006e9:	53                   	push   %ebx
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006f0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f8:	39 f3                	cmp    %esi,%ebx
  8006fa:	73 25                	jae    800721 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	89 f0                	mov    %esi,%eax
  800701:	29 d8                	sub    %ebx,%eax
  800703:	50                   	push   %eax
  800704:	89 d8                	mov    %ebx,%eax
  800706:	03 45 0c             	add    0xc(%ebp),%eax
  800709:	50                   	push   %eax
  80070a:	57                   	push   %edi
  80070b:	e8 4d ff ff ff       	call   80065d <read>
		if (m < 0)
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	85 c0                	test   %eax,%eax
  800715:	78 08                	js     80071f <readn+0x3b>
			return m;
		if (m == 0)
  800717:	85 c0                	test   %eax,%eax
  800719:	74 06                	je     800721 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80071b:	01 c3                	add    %eax,%ebx
  80071d:	eb d9                	jmp    8006f8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80071f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800721:	89 d8                	mov    %ebx,%eax
  800723:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800726:	5b                   	pop    %ebx
  800727:	5e                   	pop    %esi
  800728:	5f                   	pop    %edi
  800729:	5d                   	pop    %ebp
  80072a:	c3                   	ret    

0080072b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 14             	sub    $0x14,%esp
  800732:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800735:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	53                   	push   %ebx
  80073a:	e8 ad fc ff ff       	call   8003ec <fd_lookup>
  80073f:	83 c4 08             	add    $0x8,%esp
  800742:	85 c0                	test   %eax,%eax
  800744:	78 3a                	js     800780 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800750:	ff 30                	pushl  (%eax)
  800752:	e8 eb fc ff ff       	call   800442 <dev_lookup>
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	85 c0                	test   %eax,%eax
  80075c:	78 22                	js     800780 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800761:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800765:	74 1e                	je     800785 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076a:	8b 52 0c             	mov    0xc(%edx),%edx
  80076d:	85 d2                	test   %edx,%edx
  80076f:	74 35                	je     8007a6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800771:	83 ec 04             	sub    $0x4,%esp
  800774:	ff 75 10             	pushl  0x10(%ebp)
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	50                   	push   %eax
  80077b:	ff d2                	call   *%edx
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800783:	c9                   	leave  
  800784:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800785:	a1 08 40 80 00       	mov    0x804008,%eax
  80078a:	8b 40 48             	mov    0x48(%eax),%eax
  80078d:	83 ec 04             	sub    $0x4,%esp
  800790:	53                   	push   %ebx
  800791:	50                   	push   %eax
  800792:	68 d9 22 80 00       	push   $0x8022d9
  800797:	e8 d5 0d 00 00       	call   801571 <cprintf>
		return -E_INVAL;
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a4:	eb da                	jmp    800780 <write+0x55>
		return -E_NOT_SUPP;
  8007a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007ab:	eb d3                	jmp    800780 <write+0x55>

008007ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007b6:	50                   	push   %eax
  8007b7:	ff 75 08             	pushl  0x8(%ebp)
  8007ba:	e8 2d fc ff ff       	call   8003ec <fd_lookup>
  8007bf:	83 c4 08             	add    $0x8,%esp
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	78 0e                	js     8007d4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007cc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 14             	sub    $0x14,%esp
  8007dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	53                   	push   %ebx
  8007e5:	e8 02 fc ff ff       	call   8003ec <fd_lookup>
  8007ea:	83 c4 08             	add    $0x8,%esp
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	78 37                	js     800828 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	ff 30                	pushl  (%eax)
  8007fd:	e8 40 fc ff ff       	call   800442 <dev_lookup>
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	85 c0                	test   %eax,%eax
  800807:	78 1f                	js     800828 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800810:	74 1b                	je     80082d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800815:	8b 52 18             	mov    0x18(%edx),%edx
  800818:	85 d2                	test   %edx,%edx
  80081a:	74 32                	je     80084e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	ff d2                	call   *%edx
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082b:	c9                   	leave  
  80082c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80082d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800832:	8b 40 48             	mov    0x48(%eax),%eax
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	53                   	push   %ebx
  800839:	50                   	push   %eax
  80083a:	68 9c 22 80 00       	push   $0x80229c
  80083f:	e8 2d 0d 00 00       	call   801571 <cprintf>
		return -E_INVAL;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084c:	eb da                	jmp    800828 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80084e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800853:	eb d3                	jmp    800828 <ftruncate+0x52>

00800855 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	83 ec 14             	sub    $0x14,%esp
  80085c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800862:	50                   	push   %eax
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 81 fb ff ff       	call   8003ec <fd_lookup>
  80086b:	83 c4 08             	add    $0x8,%esp
  80086e:	85 c0                	test   %eax,%eax
  800870:	78 4b                	js     8008bd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087c:	ff 30                	pushl  (%eax)
  80087e:	e8 bf fb ff ff       	call   800442 <dev_lookup>
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	85 c0                	test   %eax,%eax
  800888:	78 33                	js     8008bd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80088a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800891:	74 2f                	je     8008c2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800893:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800896:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80089d:	00 00 00 
	stat->st_isdir = 0;
  8008a0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008a7:	00 00 00 
	stat->st_dev = dev;
  8008aa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b7:	ff 50 14             	call   *0x14(%eax)
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c7:	eb f4                	jmp    8008bd <fstat+0x68>

008008c9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	56                   	push   %esi
  8008cd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	6a 00                	push   $0x0
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	e8 e7 01 00 00       	call   800ac2 <open>
  8008db:	89 c3                	mov    %eax,%ebx
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	78 1b                	js     8008ff <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	e8 65 ff ff ff       	call   800855 <fstat>
  8008f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8008f2:	89 1c 24             	mov    %ebx,(%esp)
  8008f5:	e8 27 fc ff ff       	call   800521 <close>
	return r;
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	89 f3                	mov    %esi,%ebx
}
  8008ff:	89 d8                	mov    %ebx,%eax
  800901:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	89 c6                	mov    %eax,%esi
  80090f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800911:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800918:	74 27                	je     800941 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80091a:	6a 07                	push   $0x7
  80091c:	68 00 50 80 00       	push   $0x805000
  800921:	56                   	push   %esi
  800922:	ff 35 00 40 80 00    	pushl  0x804000
  800928:	e8 07 16 00 00       	call   801f34 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80092d:	83 c4 0c             	add    $0xc,%esp
  800930:	6a 00                	push   $0x0
  800932:	53                   	push   %ebx
  800933:	6a 00                	push   $0x0
  800935:	e8 93 15 00 00       	call   801ecd <ipc_recv>
}
  80093a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093d:	5b                   	pop    %ebx
  80093e:	5e                   	pop    %esi
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800941:	83 ec 0c             	sub    $0xc,%esp
  800944:	6a 01                	push   $0x1
  800946:	e8 3d 16 00 00       	call   801f88 <ipc_find_env>
  80094b:	a3 00 40 80 00       	mov    %eax,0x804000
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	eb c5                	jmp    80091a <fsipc+0x12>

00800955 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 40 0c             	mov    0xc(%eax),%eax
  800961:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	b8 02 00 00 00       	mov    $0x2,%eax
  800978:	e8 8b ff ff ff       	call   800908 <fsipc>
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <devfile_flush>:
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 40 0c             	mov    0xc(%eax),%eax
  80098b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800990:	ba 00 00 00 00       	mov    $0x0,%edx
  800995:	b8 06 00 00 00       	mov    $0x6,%eax
  80099a:	e8 69 ff ff ff       	call   800908 <fsipc>
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <devfile_stat>:
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	53                   	push   %ebx
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8009b1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8009c0:	e8 43 ff ff ff       	call   800908 <fsipc>
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	78 2c                	js     8009f5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	68 00 50 80 00       	push   $0x805000
  8009d1:	53                   	push   %ebx
  8009d2:	e8 b9 11 00 00       	call   801b90 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009d7:	a1 80 50 80 00       	mov    0x805080,%eax
  8009dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009e2:	a1 84 50 80 00       	mov    0x805084,%eax
  8009e7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ed:	83 c4 10             	add    $0x10,%esp
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <devfile_write>:
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 0c             	sub    $0xc,%esp
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a08:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a0d:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a10:	8b 55 08             	mov    0x8(%ebp),%edx
  800a13:	8b 52 0c             	mov    0xc(%edx),%edx
  800a16:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a1c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a21:	50                   	push   %eax
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	68 08 50 80 00       	push   $0x805008
  800a2a:	e8 ef 12 00 00       	call   801d1e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a34:	b8 04 00 00 00       	mov    $0x4,%eax
  800a39:	e8 ca fe ff ff       	call   800908 <fsipc>
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <devfile_read>:
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	56                   	push   %esi
  800a44:	53                   	push   %ebx
  800a45:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a4e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a53:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a59:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5e:	b8 03 00 00 00       	mov    $0x3,%eax
  800a63:	e8 a0 fe ff ff       	call   800908 <fsipc>
  800a68:	89 c3                	mov    %eax,%ebx
  800a6a:	85 c0                	test   %eax,%eax
  800a6c:	78 1f                	js     800a8d <devfile_read+0x4d>
	assert(r <= n);
  800a6e:	39 f0                	cmp    %esi,%eax
  800a70:	77 24                	ja     800a96 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a72:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a77:	7f 33                	jg     800aac <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a79:	83 ec 04             	sub    $0x4,%esp
  800a7c:	50                   	push   %eax
  800a7d:	68 00 50 80 00       	push   $0x805000
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	e8 94 12 00 00       	call   801d1e <memmove>
	return r;
  800a8a:	83 c4 10             	add    $0x10,%esp
}
  800a8d:	89 d8                	mov    %ebx,%eax
  800a8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    
	assert(r <= n);
  800a96:	68 0c 23 80 00       	push   $0x80230c
  800a9b:	68 13 23 80 00       	push   $0x802313
  800aa0:	6a 7b                	push   $0x7b
  800aa2:	68 28 23 80 00       	push   $0x802328
  800aa7:	e8 ea 09 00 00       	call   801496 <_panic>
	assert(r <= PGSIZE);
  800aac:	68 33 23 80 00       	push   $0x802333
  800ab1:	68 13 23 80 00       	push   $0x802313
  800ab6:	6a 7c                	push   $0x7c
  800ab8:	68 28 23 80 00       	push   $0x802328
  800abd:	e8 d4 09 00 00       	call   801496 <_panic>

00800ac2 <open>:
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	56                   	push   %esi
  800ac6:	53                   	push   %ebx
  800ac7:	83 ec 1c             	sub    $0x1c,%esp
  800aca:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800acd:	56                   	push   %esi
  800ace:	e8 86 10 00 00       	call   801b59 <strlen>
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800adb:	7f 6c                	jg     800b49 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800add:	83 ec 0c             	sub    $0xc,%esp
  800ae0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ae3:	50                   	push   %eax
  800ae4:	e8 b4 f8 ff ff       	call   80039d <fd_alloc>
  800ae9:	89 c3                	mov    %eax,%ebx
  800aeb:	83 c4 10             	add    $0x10,%esp
  800aee:	85 c0                	test   %eax,%eax
  800af0:	78 3c                	js     800b2e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	56                   	push   %esi
  800af6:	68 00 50 80 00       	push   $0x805000
  800afb:	e8 90 10 00 00       	call   801b90 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800b08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b10:	e8 f3 fd ff ff       	call   800908 <fsipc>
  800b15:	89 c3                	mov    %eax,%ebx
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	85 c0                	test   %eax,%eax
  800b1c:	78 19                	js     800b37 <open+0x75>
	return fd2num(fd);
  800b1e:	83 ec 0c             	sub    $0xc,%esp
  800b21:	ff 75 f4             	pushl  -0xc(%ebp)
  800b24:	e8 4d f8 ff ff       	call   800376 <fd2num>
  800b29:	89 c3                	mov    %eax,%ebx
  800b2b:	83 c4 10             	add    $0x10,%esp
}
  800b2e:	89 d8                	mov    %ebx,%eax
  800b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    
		fd_close(fd, 0);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	6a 00                	push   $0x0
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	e8 54 f9 ff ff       	call   800498 <fd_close>
		return r;
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	eb e5                	jmp    800b2e <open+0x6c>
		return -E_BAD_PATH;
  800b49:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b4e:	eb de                	jmp    800b2e <open+0x6c>

00800b50 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b56:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5b:	b8 08 00 00 00       	mov    $0x8,%eax
  800b60:	e8 a3 fd ff ff       	call   800908 <fsipc>
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b6d:	68 3f 23 80 00       	push   $0x80233f
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	e8 16 10 00 00       	call   801b90 <strcpy>
	return 0;
}
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <devsock_close>:
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	53                   	push   %ebx
  800b85:	83 ec 10             	sub    $0x10,%esp
  800b88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800b8b:	53                   	push   %ebx
  800b8c:	e8 30 14 00 00       	call   801fc1 <pageref>
  800b91:	83 c4 10             	add    $0x10,%esp
		return 0;
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800b99:	83 f8 01             	cmp    $0x1,%eax
  800b9c:	74 07                	je     800ba5 <devsock_close+0x24>
}
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800ba5:	83 ec 0c             	sub    $0xc,%esp
  800ba8:	ff 73 0c             	pushl  0xc(%ebx)
  800bab:	e8 b7 02 00 00       	call   800e67 <nsipc_close>
  800bb0:	89 c2                	mov    %eax,%edx
  800bb2:	83 c4 10             	add    $0x10,%esp
  800bb5:	eb e7                	jmp    800b9e <devsock_close+0x1d>

00800bb7 <devsock_write>:
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bbd:	6a 00                	push   $0x0
  800bbf:	ff 75 10             	pushl  0x10(%ebp)
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff 70 0c             	pushl  0xc(%eax)
  800bcb:	e8 74 03 00 00       	call   800f44 <nsipc_send>
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <devsock_read>:
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bd8:	6a 00                	push   $0x0
  800bda:	ff 75 10             	pushl  0x10(%ebp)
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff 70 0c             	pushl  0xc(%eax)
  800be6:	e8 ed 02 00 00       	call   800ed8 <nsipc_recv>
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <fd2sockid>:
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800bf3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800bf6:	52                   	push   %edx
  800bf7:	50                   	push   %eax
  800bf8:	e8 ef f7 ff ff       	call   8003ec <fd_lookup>
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	85 c0                	test   %eax,%eax
  800c02:	78 10                	js     800c14 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c07:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800c0d:	39 08                	cmp    %ecx,(%eax)
  800c0f:	75 05                	jne    800c16 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c11:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    
		return -E_NOT_SUPP;
  800c16:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c1b:	eb f7                	jmp    800c14 <fd2sockid+0x27>

00800c1d <alloc_sockfd>:
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	83 ec 1c             	sub    $0x1c,%esp
  800c25:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c2a:	50                   	push   %eax
  800c2b:	e8 6d f7 ff ff       	call   80039d <fd_alloc>
  800c30:	89 c3                	mov    %eax,%ebx
  800c32:	83 c4 10             	add    $0x10,%esp
  800c35:	85 c0                	test   %eax,%eax
  800c37:	78 43                	js     800c7c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c39:	83 ec 04             	sub    $0x4,%esp
  800c3c:	68 07 04 00 00       	push   $0x407
  800c41:	ff 75 f4             	pushl  -0xc(%ebp)
  800c44:	6a 00                	push   $0x0
  800c46:	e8 1b f5 ff ff       	call   800166 <sys_page_alloc>
  800c4b:	89 c3                	mov    %eax,%ebx
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	85 c0                	test   %eax,%eax
  800c52:	78 28                	js     800c7c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c57:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c5d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c62:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c69:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	50                   	push   %eax
  800c70:	e8 01 f7 ff ff       	call   800376 <fd2num>
  800c75:	89 c3                	mov    %eax,%ebx
  800c77:	83 c4 10             	add    $0x10,%esp
  800c7a:	eb 0c                	jmp    800c88 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c7c:	83 ec 0c             	sub    $0xc,%esp
  800c7f:	56                   	push   %esi
  800c80:	e8 e2 01 00 00       	call   800e67 <nsipc_close>
		return r;
  800c85:	83 c4 10             	add    $0x10,%esp
}
  800c88:	89 d8                	mov    %ebx,%eax
  800c8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <accept>:
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	e8 4e ff ff ff       	call   800bed <fd2sockid>
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	78 1b                	js     800cbe <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800ca3:	83 ec 04             	sub    $0x4,%esp
  800ca6:	ff 75 10             	pushl  0x10(%ebp)
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	e8 0e 01 00 00       	call   800dc0 <nsipc_accept>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	78 05                	js     800cbe <accept+0x2d>
	return alloc_sockfd(r);
  800cb9:	e8 5f ff ff ff       	call   800c1d <alloc_sockfd>
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <bind>:
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	e8 1f ff ff ff       	call   800bed <fd2sockid>
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	78 12                	js     800ce4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800cd2:	83 ec 04             	sub    $0x4,%esp
  800cd5:	ff 75 10             	pushl  0x10(%ebp)
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	50                   	push   %eax
  800cdc:	e8 2f 01 00 00       	call   800e10 <nsipc_bind>
  800ce1:	83 c4 10             	add    $0x10,%esp
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <shutdown>:
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	e8 f9 fe ff ff       	call   800bed <fd2sockid>
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	78 0f                	js     800d07 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800cf8:	83 ec 08             	sub    $0x8,%esp
  800cfb:	ff 75 0c             	pushl  0xc(%ebp)
  800cfe:	50                   	push   %eax
  800cff:	e8 41 01 00 00       	call   800e45 <nsipc_shutdown>
  800d04:	83 c4 10             	add    $0x10,%esp
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <connect>:
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	e8 d6 fe ff ff       	call   800bed <fd2sockid>
  800d17:	85 c0                	test   %eax,%eax
  800d19:	78 12                	js     800d2d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	ff 75 10             	pushl  0x10(%ebp)
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	50                   	push   %eax
  800d25:	e8 57 01 00 00       	call   800e81 <nsipc_connect>
  800d2a:	83 c4 10             	add    $0x10,%esp
}
  800d2d:	c9                   	leave  
  800d2e:	c3                   	ret    

00800d2f <listen>:
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	e8 b0 fe ff ff       	call   800bed <fd2sockid>
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	78 0f                	js     800d50 <listen+0x21>
	return nsipc_listen(r, backlog);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	50                   	push   %eax
  800d48:	e8 69 01 00 00       	call   800eb6 <nsipc_listen>
  800d4d:	83 c4 10             	add    $0x10,%esp
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <socket>:

int
socket(int domain, int type, int protocol)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d58:	ff 75 10             	pushl  0x10(%ebp)
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	e8 3c 02 00 00       	call   800fa2 <nsipc_socket>
  800d66:	83 c4 10             	add    $0x10,%esp
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	78 05                	js     800d72 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d6d:	e8 ab fe ff ff       	call   800c1d <alloc_sockfd>
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	53                   	push   %ebx
  800d78:	83 ec 04             	sub    $0x4,%esp
  800d7b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d7d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d84:	74 26                	je     800dac <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800d86:	6a 07                	push   $0x7
  800d88:	68 00 60 80 00       	push   $0x806000
  800d8d:	53                   	push   %ebx
  800d8e:	ff 35 04 40 80 00    	pushl  0x804004
  800d94:	e8 9b 11 00 00       	call   801f34 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800d99:	83 c4 0c             	add    $0xc,%esp
  800d9c:	6a 00                	push   $0x0
  800d9e:	6a 00                	push   $0x0
  800da0:	6a 00                	push   $0x0
  800da2:	e8 26 11 00 00       	call   801ecd <ipc_recv>
}
  800da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	6a 02                	push   $0x2
  800db1:	e8 d2 11 00 00       	call   801f88 <ipc_find_env>
  800db6:	a3 04 40 80 00       	mov    %eax,0x804004
  800dbb:	83 c4 10             	add    $0x10,%esp
  800dbe:	eb c6                	jmp    800d86 <nsipc+0x12>

00800dc0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800dd0:	8b 06                	mov    (%esi),%eax
  800dd2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  800ddc:	e8 93 ff ff ff       	call   800d74 <nsipc>
  800de1:	89 c3                	mov    %eax,%ebx
  800de3:	85 c0                	test   %eax,%eax
  800de5:	78 20                	js     800e07 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800de7:	83 ec 04             	sub    $0x4,%esp
  800dea:	ff 35 10 60 80 00    	pushl  0x806010
  800df0:	68 00 60 80 00       	push   $0x806000
  800df5:	ff 75 0c             	pushl  0xc(%ebp)
  800df8:	e8 21 0f 00 00       	call   801d1e <memmove>
		*addrlen = ret->ret_addrlen;
  800dfd:	a1 10 60 80 00       	mov    0x806010,%eax
  800e02:	89 06                	mov    %eax,(%esi)
  800e04:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800e07:	89 d8                	mov    %ebx,%eax
  800e09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e0c:	5b                   	pop    %ebx
  800e0d:	5e                   	pop    %esi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	53                   	push   %ebx
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e22:	53                   	push   %ebx
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	68 04 60 80 00       	push   $0x806004
  800e2b:	e8 ee 0e 00 00       	call   801d1e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e30:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e36:	b8 02 00 00 00       	mov    $0x2,%eax
  800e3b:	e8 34 ff ff ff       	call   800d74 <nsipc>
}
  800e40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e60:	e8 0f ff ff ff       	call   800d74 <nsipc>
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <nsipc_close>:

int
nsipc_close(int s)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e75:	b8 04 00 00 00       	mov    $0x4,%eax
  800e7a:	e8 f5 fe ff ff       	call   800d74 <nsipc>
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	53                   	push   %ebx
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800e93:	53                   	push   %ebx
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	68 04 60 80 00       	push   $0x806004
  800e9c:	e8 7d 0e 00 00       	call   801d1e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800ea1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800ea7:	b8 05 00 00 00       	mov    $0x5,%eax
  800eac:	e8 c3 fe ff ff       	call   800d74 <nsipc>
}
  800eb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ecc:	b8 06 00 00 00       	mov    $0x6,%eax
  800ed1:	e8 9e fe ff ff       	call   800d74 <nsipc>
}
  800ed6:	c9                   	leave  
  800ed7:	c3                   	ret    

00800ed8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800ee8:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800ef6:	b8 07 00 00 00       	mov    $0x7,%eax
  800efb:	e8 74 fe ff ff       	call   800d74 <nsipc>
  800f00:	89 c3                	mov    %eax,%ebx
  800f02:	85 c0                	test   %eax,%eax
  800f04:	78 1f                	js     800f25 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800f06:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800f0b:	7f 21                	jg     800f2e <nsipc_recv+0x56>
  800f0d:	39 c6                	cmp    %eax,%esi
  800f0f:	7c 1d                	jl     800f2e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f11:	83 ec 04             	sub    $0x4,%esp
  800f14:	50                   	push   %eax
  800f15:	68 00 60 80 00       	push   $0x806000
  800f1a:	ff 75 0c             	pushl  0xc(%ebp)
  800f1d:	e8 fc 0d 00 00       	call   801d1e <memmove>
  800f22:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f25:	89 d8                	mov    %ebx,%eax
  800f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f2e:	68 4b 23 80 00       	push   $0x80234b
  800f33:	68 13 23 80 00       	push   $0x802313
  800f38:	6a 62                	push   $0x62
  800f3a:	68 60 23 80 00       	push   $0x802360
  800f3f:	e8 52 05 00 00       	call   801496 <_panic>

00800f44 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	53                   	push   %ebx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f56:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f5c:	7f 2e                	jg     800f8c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f5e:	83 ec 04             	sub    $0x4,%esp
  800f61:	53                   	push   %ebx
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	68 0c 60 80 00       	push   $0x80600c
  800f6a:	e8 af 0d 00 00       	call   801d1e <memmove>
	nsipcbuf.send.req_size = size;
  800f6f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f7d:	b8 08 00 00 00       	mov    $0x8,%eax
  800f82:	e8 ed fd ff ff       	call   800d74 <nsipc>
}
  800f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    
	assert(size < 1600);
  800f8c:	68 6c 23 80 00       	push   $0x80236c
  800f91:	68 13 23 80 00       	push   $0x802313
  800f96:	6a 6d                	push   $0x6d
  800f98:	68 60 23 80 00       	push   $0x802360
  800f9d:	e8 f4 04 00 00       	call   801496 <_panic>

00800fa2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800fc0:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc5:	e8 aa fd ff ff       	call   800d74 <nsipc>
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	ff 75 08             	pushl  0x8(%ebp)
  800fda:	e8 a7 f3 ff ff       	call   800386 <fd2data>
  800fdf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fe1:	83 c4 08             	add    $0x8,%esp
  800fe4:	68 78 23 80 00       	push   $0x802378
  800fe9:	53                   	push   %ebx
  800fea:	e8 a1 0b 00 00       	call   801b90 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fef:	8b 46 04             	mov    0x4(%esi),%eax
  800ff2:	2b 06                	sub    (%esi),%eax
  800ff4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ffa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801001:	00 00 00 
	stat->st_dev = &devpipe;
  801004:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80100b:	30 80 00 
	return 0;
}
  80100e:	b8 00 00 00 00       	mov    $0x0,%eax
  801013:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	53                   	push   %ebx
  80101e:	83 ec 0c             	sub    $0xc,%esp
  801021:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801024:	53                   	push   %ebx
  801025:	6a 00                	push   $0x0
  801027:	e8 bf f1 ff ff       	call   8001eb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80102c:	89 1c 24             	mov    %ebx,(%esp)
  80102f:	e8 52 f3 ff ff       	call   800386 <fd2data>
  801034:	83 c4 08             	add    $0x8,%esp
  801037:	50                   	push   %eax
  801038:	6a 00                	push   $0x0
  80103a:	e8 ac f1 ff ff       	call   8001eb <sys_page_unmap>
}
  80103f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <_pipeisclosed>:
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
  80104a:	83 ec 1c             	sub    $0x1c,%esp
  80104d:	89 c7                	mov    %eax,%edi
  80104f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801051:	a1 08 40 80 00       	mov    0x804008,%eax
  801056:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801059:	83 ec 0c             	sub    $0xc,%esp
  80105c:	57                   	push   %edi
  80105d:	e8 5f 0f 00 00       	call   801fc1 <pageref>
  801062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801065:	89 34 24             	mov    %esi,(%esp)
  801068:	e8 54 0f 00 00       	call   801fc1 <pageref>
		nn = thisenv->env_runs;
  80106d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801073:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	39 cb                	cmp    %ecx,%ebx
  80107b:	74 1b                	je     801098 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80107d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801080:	75 cf                	jne    801051 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801082:	8b 42 58             	mov    0x58(%edx),%eax
  801085:	6a 01                	push   $0x1
  801087:	50                   	push   %eax
  801088:	53                   	push   %ebx
  801089:	68 7f 23 80 00       	push   $0x80237f
  80108e:	e8 de 04 00 00       	call   801571 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	eb b9                	jmp    801051 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801098:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80109b:	0f 94 c0             	sete   %al
  80109e:	0f b6 c0             	movzbl %al,%eax
}
  8010a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <devpipe_write>:
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	57                   	push   %edi
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
  8010af:	83 ec 28             	sub    $0x28,%esp
  8010b2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010b5:	56                   	push   %esi
  8010b6:	e8 cb f2 ff ff       	call   800386 <fd2data>
  8010bb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010c8:	74 4f                	je     801119 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010ca:	8b 43 04             	mov    0x4(%ebx),%eax
  8010cd:	8b 0b                	mov    (%ebx),%ecx
  8010cf:	8d 51 20             	lea    0x20(%ecx),%edx
  8010d2:	39 d0                	cmp    %edx,%eax
  8010d4:	72 14                	jb     8010ea <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010d6:	89 da                	mov    %ebx,%edx
  8010d8:	89 f0                	mov    %esi,%eax
  8010da:	e8 65 ff ff ff       	call   801044 <_pipeisclosed>
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	75 3a                	jne    80111d <devpipe_write+0x74>
			sys_yield();
  8010e3:	e8 5f f0 ff ff       	call   800147 <sys_yield>
  8010e8:	eb e0                	jmp    8010ca <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ed:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010f1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010f4:	89 c2                	mov    %eax,%edx
  8010f6:	c1 fa 1f             	sar    $0x1f,%edx
  8010f9:	89 d1                	mov    %edx,%ecx
  8010fb:	c1 e9 1b             	shr    $0x1b,%ecx
  8010fe:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801101:	83 e2 1f             	and    $0x1f,%edx
  801104:	29 ca                	sub    %ecx,%edx
  801106:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80110a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80110e:	83 c0 01             	add    $0x1,%eax
  801111:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801114:	83 c7 01             	add    $0x1,%edi
  801117:	eb ac                	jmp    8010c5 <devpipe_write+0x1c>
	return i;
  801119:	89 f8                	mov    %edi,%eax
  80111b:	eb 05                	jmp    801122 <devpipe_write+0x79>
				return 0;
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <devpipe_read>:
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	57                   	push   %edi
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	83 ec 18             	sub    $0x18,%esp
  801133:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801136:	57                   	push   %edi
  801137:	e8 4a f2 ff ff       	call   800386 <fd2data>
  80113c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	be 00 00 00 00       	mov    $0x0,%esi
  801146:	3b 75 10             	cmp    0x10(%ebp),%esi
  801149:	74 47                	je     801192 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80114b:	8b 03                	mov    (%ebx),%eax
  80114d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801150:	75 22                	jne    801174 <devpipe_read+0x4a>
			if (i > 0)
  801152:	85 f6                	test   %esi,%esi
  801154:	75 14                	jne    80116a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801156:	89 da                	mov    %ebx,%edx
  801158:	89 f8                	mov    %edi,%eax
  80115a:	e8 e5 fe ff ff       	call   801044 <_pipeisclosed>
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 33                	jne    801196 <devpipe_read+0x6c>
			sys_yield();
  801163:	e8 df ef ff ff       	call   800147 <sys_yield>
  801168:	eb e1                	jmp    80114b <devpipe_read+0x21>
				return i;
  80116a:	89 f0                	mov    %esi,%eax
}
  80116c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116f:	5b                   	pop    %ebx
  801170:	5e                   	pop    %esi
  801171:	5f                   	pop    %edi
  801172:	5d                   	pop    %ebp
  801173:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801174:	99                   	cltd   
  801175:	c1 ea 1b             	shr    $0x1b,%edx
  801178:	01 d0                	add    %edx,%eax
  80117a:	83 e0 1f             	and    $0x1f,%eax
  80117d:	29 d0                	sub    %edx,%eax
  80117f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801184:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801187:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80118a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80118d:	83 c6 01             	add    $0x1,%esi
  801190:	eb b4                	jmp    801146 <devpipe_read+0x1c>
	return i;
  801192:	89 f0                	mov    %esi,%eax
  801194:	eb d6                	jmp    80116c <devpipe_read+0x42>
				return 0;
  801196:	b8 00 00 00 00       	mov    $0x0,%eax
  80119b:	eb cf                	jmp    80116c <devpipe_read+0x42>

0080119d <pipe>:
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	e8 ef f1 ff ff       	call   80039d <fd_alloc>
  8011ae:	89 c3                	mov    %eax,%ebx
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	78 5b                	js     801212 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011b7:	83 ec 04             	sub    $0x4,%esp
  8011ba:	68 07 04 00 00       	push   $0x407
  8011bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c2:	6a 00                	push   $0x0
  8011c4:	e8 9d ef ff ff       	call   800166 <sys_page_alloc>
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 40                	js     801212 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d8:	50                   	push   %eax
  8011d9:	e8 bf f1 ff ff       	call   80039d <fd_alloc>
  8011de:	89 c3                	mov    %eax,%ebx
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	78 1b                	js     801202 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011e7:	83 ec 04             	sub    $0x4,%esp
  8011ea:	68 07 04 00 00       	push   $0x407
  8011ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8011f2:	6a 00                	push   $0x0
  8011f4:	e8 6d ef ff ff       	call   800166 <sys_page_alloc>
  8011f9:	89 c3                	mov    %eax,%ebx
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	79 19                	jns    80121b <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801202:	83 ec 08             	sub    $0x8,%esp
  801205:	ff 75 f4             	pushl  -0xc(%ebp)
  801208:	6a 00                	push   $0x0
  80120a:	e8 dc ef ff ff       	call   8001eb <sys_page_unmap>
  80120f:	83 c4 10             	add    $0x10,%esp
}
  801212:	89 d8                	mov    %ebx,%eax
  801214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5d                   	pop    %ebp
  80121a:	c3                   	ret    
	va = fd2data(fd0);
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	ff 75 f4             	pushl  -0xc(%ebp)
  801221:	e8 60 f1 ff ff       	call   800386 <fd2data>
  801226:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801228:	83 c4 0c             	add    $0xc,%esp
  80122b:	68 07 04 00 00       	push   $0x407
  801230:	50                   	push   %eax
  801231:	6a 00                	push   $0x0
  801233:	e8 2e ef ff ff       	call   800166 <sys_page_alloc>
  801238:	89 c3                	mov    %eax,%ebx
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	85 c0                	test   %eax,%eax
  80123f:	0f 88 8c 00 00 00    	js     8012d1 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801245:	83 ec 0c             	sub    $0xc,%esp
  801248:	ff 75 f0             	pushl  -0x10(%ebp)
  80124b:	e8 36 f1 ff ff       	call   800386 <fd2data>
  801250:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801257:	50                   	push   %eax
  801258:	6a 00                	push   $0x0
  80125a:	56                   	push   %esi
  80125b:	6a 00                	push   $0x0
  80125d:	e8 47 ef ff ff       	call   8001a9 <sys_page_map>
  801262:	89 c3                	mov    %eax,%ebx
  801264:	83 c4 20             	add    $0x20,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	78 58                	js     8012c3 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80126b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801274:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801279:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801283:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801289:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 f4             	pushl  -0xc(%ebp)
  80129b:	e8 d6 f0 ff ff       	call   800376 <fd2num>
  8012a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8012a5:	83 c4 04             	add    $0x4,%esp
  8012a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012ab:	e8 c6 f0 ff ff       	call   800376 <fd2num>
  8012b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012be:	e9 4f ff ff ff       	jmp    801212 <pipe+0x75>
	sys_page_unmap(0, va);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	56                   	push   %esi
  8012c7:	6a 00                	push   $0x0
  8012c9:	e8 1d ef ff ff       	call   8001eb <sys_page_unmap>
  8012ce:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 0d ef ff ff       	call   8001eb <sys_page_unmap>
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	e9 1c ff ff ff       	jmp    801202 <pipe+0x65>

008012e6 <pipeisclosed>:
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ef:	50                   	push   %eax
  8012f0:	ff 75 08             	pushl  0x8(%ebp)
  8012f3:	e8 f4 f0 ff ff       	call   8003ec <fd_lookup>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 18                	js     801317 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012ff:	83 ec 0c             	sub    $0xc,%esp
  801302:	ff 75 f4             	pushl  -0xc(%ebp)
  801305:	e8 7c f0 ff ff       	call   800386 <fd2data>
	return _pipeisclosed(fd, p);
  80130a:	89 c2                	mov    %eax,%edx
  80130c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130f:	e8 30 fd ff ff       	call   801044 <_pipeisclosed>
  801314:	83 c4 10             	add    $0x10,%esp
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801329:	68 97 23 80 00       	push   $0x802397
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	e8 5a 08 00 00       	call   801b90 <strcpy>
	return 0;
}
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <devcons_write>:
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	57                   	push   %edi
  801341:	56                   	push   %esi
  801342:	53                   	push   %ebx
  801343:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801349:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80134e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801354:	eb 2f                	jmp    801385 <devcons_write+0x48>
		m = n - tot;
  801356:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801359:	29 f3                	sub    %esi,%ebx
  80135b:	83 fb 7f             	cmp    $0x7f,%ebx
  80135e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801363:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801366:	83 ec 04             	sub    $0x4,%esp
  801369:	53                   	push   %ebx
  80136a:	89 f0                	mov    %esi,%eax
  80136c:	03 45 0c             	add    0xc(%ebp),%eax
  80136f:	50                   	push   %eax
  801370:	57                   	push   %edi
  801371:	e8 a8 09 00 00       	call   801d1e <memmove>
		sys_cputs(buf, m);
  801376:	83 c4 08             	add    $0x8,%esp
  801379:	53                   	push   %ebx
  80137a:	57                   	push   %edi
  80137b:	e8 2a ed ff ff       	call   8000aa <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801380:	01 de                	add    %ebx,%esi
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	3b 75 10             	cmp    0x10(%ebp),%esi
  801388:	72 cc                	jb     801356 <devcons_write+0x19>
}
  80138a:	89 f0                	mov    %esi,%eax
  80138c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5f                   	pop    %edi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    

00801394 <devcons_read>:
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 08             	sub    $0x8,%esp
  80139a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80139f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a3:	75 07                	jne    8013ac <devcons_read+0x18>
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    
		sys_yield();
  8013a7:	e8 9b ed ff ff       	call   800147 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013ac:	e8 17 ed ff ff       	call   8000c8 <sys_cgetc>
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	74 f2                	je     8013a7 <devcons_read+0x13>
	if (c < 0)
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 ec                	js     8013a5 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013b9:	83 f8 04             	cmp    $0x4,%eax
  8013bc:	74 0c                	je     8013ca <devcons_read+0x36>
	*(char*)vbuf = c;
  8013be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c1:	88 02                	mov    %al,(%edx)
	return 1;
  8013c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8013c8:	eb db                	jmp    8013a5 <devcons_read+0x11>
		return 0;
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cf:	eb d4                	jmp    8013a5 <devcons_read+0x11>

008013d1 <cputchar>:
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013dd:	6a 01                	push   $0x1
  8013df:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013e2:	50                   	push   %eax
  8013e3:	e8 c2 ec ff ff       	call   8000aa <sys_cputs>
}
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <getchar>:
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013f3:	6a 01                	push   $0x1
  8013f5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013f8:	50                   	push   %eax
  8013f9:	6a 00                	push   $0x0
  8013fb:	e8 5d f2 ff ff       	call   80065d <read>
	if (r < 0)
  801400:	83 c4 10             	add    $0x10,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	78 08                	js     80140f <getchar+0x22>
	if (r < 1)
  801407:	85 c0                	test   %eax,%eax
  801409:	7e 06                	jle    801411 <getchar+0x24>
	return c;
  80140b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    
		return -E_EOF;
  801411:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801416:	eb f7                	jmp    80140f <getchar+0x22>

00801418 <iscons>:
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80141e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801421:	50                   	push   %eax
  801422:	ff 75 08             	pushl  0x8(%ebp)
  801425:	e8 c2 ef ff ff       	call   8003ec <fd_lookup>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 11                	js     801442 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801434:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80143a:	39 10                	cmp    %edx,(%eax)
  80143c:	0f 94 c0             	sete   %al
  80143f:	0f b6 c0             	movzbl %al,%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <opencons>:
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80144a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144d:	50                   	push   %eax
  80144e:	e8 4a ef ff ff       	call   80039d <fd_alloc>
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 3a                	js     801494 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	68 07 04 00 00       	push   $0x407
  801462:	ff 75 f4             	pushl  -0xc(%ebp)
  801465:	6a 00                	push   $0x0
  801467:	e8 fa ec ff ff       	call   800166 <sys_page_alloc>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 21                	js     801494 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801476:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80147c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80147e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801481:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	50                   	push   %eax
  80148c:	e8 e5 ee ff ff       	call   800376 <fd2num>
  801491:	83 c4 10             	add    $0x10,%esp
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	56                   	push   %esi
  80149a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80149b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80149e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014a4:	e8 7f ec ff ff       	call   800128 <sys_getenvid>
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	ff 75 0c             	pushl  0xc(%ebp)
  8014af:	ff 75 08             	pushl  0x8(%ebp)
  8014b2:	56                   	push   %esi
  8014b3:	50                   	push   %eax
  8014b4:	68 a4 23 80 00       	push   $0x8023a4
  8014b9:	e8 b3 00 00 00       	call   801571 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014be:	83 c4 18             	add    $0x18,%esp
  8014c1:	53                   	push   %ebx
  8014c2:	ff 75 10             	pushl  0x10(%ebp)
  8014c5:	e8 56 00 00 00       	call   801520 <vcprintf>
	cprintf("\n");
  8014ca:	c7 04 24 90 23 80 00 	movl   $0x802390,(%esp)
  8014d1:	e8 9b 00 00 00       	call   801571 <cprintf>
  8014d6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014d9:	cc                   	int3   
  8014da:	eb fd                	jmp    8014d9 <_panic+0x43>

008014dc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	53                   	push   %ebx
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014e6:	8b 13                	mov    (%ebx),%edx
  8014e8:	8d 42 01             	lea    0x1(%edx),%eax
  8014eb:	89 03                	mov    %eax,(%ebx)
  8014ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014f0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014f9:	74 09                	je     801504 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014fb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801502:	c9                   	leave  
  801503:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	68 ff 00 00 00       	push   $0xff
  80150c:	8d 43 08             	lea    0x8(%ebx),%eax
  80150f:	50                   	push   %eax
  801510:	e8 95 eb ff ff       	call   8000aa <sys_cputs>
		b->idx = 0;
  801515:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	eb db                	jmp    8014fb <putch+0x1f>

00801520 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801529:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801530:	00 00 00 
	b.cnt = 0;
  801533:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80153a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80153d:	ff 75 0c             	pushl  0xc(%ebp)
  801540:	ff 75 08             	pushl  0x8(%ebp)
  801543:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	68 dc 14 80 00       	push   $0x8014dc
  80154f:	e8 1a 01 00 00       	call   80166e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801554:	83 c4 08             	add    $0x8,%esp
  801557:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80155d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801563:	50                   	push   %eax
  801564:	e8 41 eb ff ff       	call   8000aa <sys_cputs>

	return b.cnt;
}
  801569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801577:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80157a:	50                   	push   %eax
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	e8 9d ff ff ff       	call   801520 <vcprintf>
	va_end(ap);

	return cnt;
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	57                   	push   %edi
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	83 ec 1c             	sub    $0x1c,%esp
  80158e:	89 c7                	mov    %eax,%edi
  801590:	89 d6                	mov    %edx,%esi
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	8b 55 0c             	mov    0xc(%ebp),%edx
  801598:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80159b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80159e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015ac:	39 d3                	cmp    %edx,%ebx
  8015ae:	72 05                	jb     8015b5 <printnum+0x30>
  8015b0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015b3:	77 7a                	ja     80162f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015b5:	83 ec 0c             	sub    $0xc,%esp
  8015b8:	ff 75 18             	pushl  0x18(%ebp)
  8015bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015be:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015c1:	53                   	push   %ebx
  8015c2:	ff 75 10             	pushl  0x10(%ebp)
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8015ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8015d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8015d4:	e8 27 0a 00 00       	call   802000 <__udivdi3>
  8015d9:	83 c4 18             	add    $0x18,%esp
  8015dc:	52                   	push   %edx
  8015dd:	50                   	push   %eax
  8015de:	89 f2                	mov    %esi,%edx
  8015e0:	89 f8                	mov    %edi,%eax
  8015e2:	e8 9e ff ff ff       	call   801585 <printnum>
  8015e7:	83 c4 20             	add    $0x20,%esp
  8015ea:	eb 13                	jmp    8015ff <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015ec:	83 ec 08             	sub    $0x8,%esp
  8015ef:	56                   	push   %esi
  8015f0:	ff 75 18             	pushl  0x18(%ebp)
  8015f3:	ff d7                	call   *%edi
  8015f5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015f8:	83 eb 01             	sub    $0x1,%ebx
  8015fb:	85 db                	test   %ebx,%ebx
  8015fd:	7f ed                	jg     8015ec <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	56                   	push   %esi
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 e4             	pushl  -0x1c(%ebp)
  801609:	ff 75 e0             	pushl  -0x20(%ebp)
  80160c:	ff 75 dc             	pushl  -0x24(%ebp)
  80160f:	ff 75 d8             	pushl  -0x28(%ebp)
  801612:	e8 09 0b 00 00       	call   802120 <__umoddi3>
  801617:	83 c4 14             	add    $0x14,%esp
  80161a:	0f be 80 c7 23 80 00 	movsbl 0x8023c7(%eax),%eax
  801621:	50                   	push   %eax
  801622:	ff d7                	call   *%edi
}
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162a:	5b                   	pop    %ebx
  80162b:	5e                   	pop    %esi
  80162c:	5f                   	pop    %edi
  80162d:	5d                   	pop    %ebp
  80162e:	c3                   	ret    
  80162f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801632:	eb c4                	jmp    8015f8 <printnum+0x73>

00801634 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80163a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80163e:	8b 10                	mov    (%eax),%edx
  801640:	3b 50 04             	cmp    0x4(%eax),%edx
  801643:	73 0a                	jae    80164f <sprintputch+0x1b>
		*b->buf++ = ch;
  801645:	8d 4a 01             	lea    0x1(%edx),%ecx
  801648:	89 08                	mov    %ecx,(%eax)
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	88 02                	mov    %al,(%edx)
}
  80164f:	5d                   	pop    %ebp
  801650:	c3                   	ret    

00801651 <printfmt>:
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801657:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80165a:	50                   	push   %eax
  80165b:	ff 75 10             	pushl  0x10(%ebp)
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	e8 05 00 00 00       	call   80166e <vprintfmt>
}
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <vprintfmt>:
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	57                   	push   %edi
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
  801674:	83 ec 2c             	sub    $0x2c,%esp
  801677:	8b 75 08             	mov    0x8(%ebp),%esi
  80167a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80167d:	8b 7d 10             	mov    0x10(%ebp),%edi
  801680:	e9 c1 03 00 00       	jmp    801a46 <vprintfmt+0x3d8>
		padc = ' ';
  801685:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801689:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801690:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801697:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80169e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016a3:	8d 47 01             	lea    0x1(%edi),%eax
  8016a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016a9:	0f b6 17             	movzbl (%edi),%edx
  8016ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016af:	3c 55                	cmp    $0x55,%al
  8016b1:	0f 87 12 04 00 00    	ja     801ac9 <vprintfmt+0x45b>
  8016b7:	0f b6 c0             	movzbl %al,%eax
  8016ba:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  8016c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016c4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016c8:	eb d9                	jmp    8016a3 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016cd:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016d1:	eb d0                	jmp    8016a3 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016d3:	0f b6 d2             	movzbl %dl,%edx
  8016d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016e1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016e4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016e8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016eb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016ee:	83 f9 09             	cmp    $0x9,%ecx
  8016f1:	77 55                	ja     801748 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016f3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016f6:	eb e9                	jmp    8016e1 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fb:	8b 00                	mov    (%eax),%eax
  8016fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801700:	8b 45 14             	mov    0x14(%ebp),%eax
  801703:	8d 40 04             	lea    0x4(%eax),%eax
  801706:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801709:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80170c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801710:	79 91                	jns    8016a3 <vprintfmt+0x35>
				width = precision, precision = -1;
  801712:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801715:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801718:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80171f:	eb 82                	jmp    8016a3 <vprintfmt+0x35>
  801721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801724:	85 c0                	test   %eax,%eax
  801726:	ba 00 00 00 00       	mov    $0x0,%edx
  80172b:	0f 49 d0             	cmovns %eax,%edx
  80172e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801731:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801734:	e9 6a ff ff ff       	jmp    8016a3 <vprintfmt+0x35>
  801739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80173c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801743:	e9 5b ff ff ff       	jmp    8016a3 <vprintfmt+0x35>
  801748:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80174b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80174e:	eb bc                	jmp    80170c <vprintfmt+0x9e>
			lflag++;
  801750:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801753:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801756:	e9 48 ff ff ff       	jmp    8016a3 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80175b:	8b 45 14             	mov    0x14(%ebp),%eax
  80175e:	8d 78 04             	lea    0x4(%eax),%edi
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	53                   	push   %ebx
  801765:	ff 30                	pushl  (%eax)
  801767:	ff d6                	call   *%esi
			break;
  801769:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80176c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80176f:	e9 cf 02 00 00       	jmp    801a43 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801774:	8b 45 14             	mov    0x14(%ebp),%eax
  801777:	8d 78 04             	lea    0x4(%eax),%edi
  80177a:	8b 00                	mov    (%eax),%eax
  80177c:	99                   	cltd   
  80177d:	31 d0                	xor    %edx,%eax
  80177f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801781:	83 f8 0f             	cmp    $0xf,%eax
  801784:	7f 23                	jg     8017a9 <vprintfmt+0x13b>
  801786:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  80178d:	85 d2                	test   %edx,%edx
  80178f:	74 18                	je     8017a9 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801791:	52                   	push   %edx
  801792:	68 25 23 80 00       	push   $0x802325
  801797:	53                   	push   %ebx
  801798:	56                   	push   %esi
  801799:	e8 b3 fe ff ff       	call   801651 <printfmt>
  80179e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017a4:	e9 9a 02 00 00       	jmp    801a43 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8017a9:	50                   	push   %eax
  8017aa:	68 df 23 80 00       	push   $0x8023df
  8017af:	53                   	push   %ebx
  8017b0:	56                   	push   %esi
  8017b1:	e8 9b fe ff ff       	call   801651 <printfmt>
  8017b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017b9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017bc:	e9 82 02 00 00       	jmp    801a43 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c4:	83 c0 04             	add    $0x4,%eax
  8017c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cd:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017cf:	85 ff                	test   %edi,%edi
  8017d1:	b8 d8 23 80 00       	mov    $0x8023d8,%eax
  8017d6:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017dd:	0f 8e bd 00 00 00    	jle    8018a0 <vprintfmt+0x232>
  8017e3:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017e7:	75 0e                	jne    8017f7 <vprintfmt+0x189>
  8017e9:	89 75 08             	mov    %esi,0x8(%ebp)
  8017ec:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017ef:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017f2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017f5:	eb 6d                	jmp    801864 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017f7:	83 ec 08             	sub    $0x8,%esp
  8017fa:	ff 75 d0             	pushl  -0x30(%ebp)
  8017fd:	57                   	push   %edi
  8017fe:	e8 6e 03 00 00       	call   801b71 <strnlen>
  801803:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801806:	29 c1                	sub    %eax,%ecx
  801808:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80180b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80180e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801812:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801815:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801818:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80181a:	eb 0f                	jmp    80182b <vprintfmt+0x1bd>
					putch(padc, putdat);
  80181c:	83 ec 08             	sub    $0x8,%esp
  80181f:	53                   	push   %ebx
  801820:	ff 75 e0             	pushl  -0x20(%ebp)
  801823:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801825:	83 ef 01             	sub    $0x1,%edi
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 ff                	test   %edi,%edi
  80182d:	7f ed                	jg     80181c <vprintfmt+0x1ae>
  80182f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801832:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801835:	85 c9                	test   %ecx,%ecx
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
  80183c:	0f 49 c1             	cmovns %ecx,%eax
  80183f:	29 c1                	sub    %eax,%ecx
  801841:	89 75 08             	mov    %esi,0x8(%ebp)
  801844:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801847:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80184a:	89 cb                	mov    %ecx,%ebx
  80184c:	eb 16                	jmp    801864 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80184e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801852:	75 31                	jne    801885 <vprintfmt+0x217>
					putch(ch, putdat);
  801854:	83 ec 08             	sub    $0x8,%esp
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	50                   	push   %eax
  80185b:	ff 55 08             	call   *0x8(%ebp)
  80185e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801861:	83 eb 01             	sub    $0x1,%ebx
  801864:	83 c7 01             	add    $0x1,%edi
  801867:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80186b:	0f be c2             	movsbl %dl,%eax
  80186e:	85 c0                	test   %eax,%eax
  801870:	74 59                	je     8018cb <vprintfmt+0x25d>
  801872:	85 f6                	test   %esi,%esi
  801874:	78 d8                	js     80184e <vprintfmt+0x1e0>
  801876:	83 ee 01             	sub    $0x1,%esi
  801879:	79 d3                	jns    80184e <vprintfmt+0x1e0>
  80187b:	89 df                	mov    %ebx,%edi
  80187d:	8b 75 08             	mov    0x8(%ebp),%esi
  801880:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801883:	eb 37                	jmp    8018bc <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801885:	0f be d2             	movsbl %dl,%edx
  801888:	83 ea 20             	sub    $0x20,%edx
  80188b:	83 fa 5e             	cmp    $0x5e,%edx
  80188e:	76 c4                	jbe    801854 <vprintfmt+0x1e6>
					putch('?', putdat);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	6a 3f                	push   $0x3f
  801898:	ff 55 08             	call   *0x8(%ebp)
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	eb c1                	jmp    801861 <vprintfmt+0x1f3>
  8018a0:	89 75 08             	mov    %esi,0x8(%ebp)
  8018a3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018a6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018a9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018ac:	eb b6                	jmp    801864 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	53                   	push   %ebx
  8018b2:	6a 20                	push   $0x20
  8018b4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018b6:	83 ef 01             	sub    $0x1,%edi
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	85 ff                	test   %edi,%edi
  8018be:	7f ee                	jg     8018ae <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8018c6:	e9 78 01 00 00       	jmp    801a43 <vprintfmt+0x3d5>
  8018cb:	89 df                	mov    %ebx,%edi
  8018cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8018d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018d3:	eb e7                	jmp    8018bc <vprintfmt+0x24e>
	if (lflag >= 2)
  8018d5:	83 f9 01             	cmp    $0x1,%ecx
  8018d8:	7e 3f                	jle    801919 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018da:	8b 45 14             	mov    0x14(%ebp),%eax
  8018dd:	8b 50 04             	mov    0x4(%eax),%edx
  8018e0:	8b 00                	mov    (%eax),%eax
  8018e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018eb:	8d 40 08             	lea    0x8(%eax),%eax
  8018ee:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018f5:	79 5c                	jns    801953 <vprintfmt+0x2e5>
				putch('-', putdat);
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	53                   	push   %ebx
  8018fb:	6a 2d                	push   $0x2d
  8018fd:	ff d6                	call   *%esi
				num = -(long long) num;
  8018ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801902:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801905:	f7 da                	neg    %edx
  801907:	83 d1 00             	adc    $0x0,%ecx
  80190a:	f7 d9                	neg    %ecx
  80190c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80190f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801914:	e9 10 01 00 00       	jmp    801a29 <vprintfmt+0x3bb>
	else if (lflag)
  801919:	85 c9                	test   %ecx,%ecx
  80191b:	75 1b                	jne    801938 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801925:	89 c1                	mov    %eax,%ecx
  801927:	c1 f9 1f             	sar    $0x1f,%ecx
  80192a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80192d:	8b 45 14             	mov    0x14(%ebp),%eax
  801930:	8d 40 04             	lea    0x4(%eax),%eax
  801933:	89 45 14             	mov    %eax,0x14(%ebp)
  801936:	eb b9                	jmp    8018f1 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801938:	8b 45 14             	mov    0x14(%ebp),%eax
  80193b:	8b 00                	mov    (%eax),%eax
  80193d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801940:	89 c1                	mov    %eax,%ecx
  801942:	c1 f9 1f             	sar    $0x1f,%ecx
  801945:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801948:	8b 45 14             	mov    0x14(%ebp),%eax
  80194b:	8d 40 04             	lea    0x4(%eax),%eax
  80194e:	89 45 14             	mov    %eax,0x14(%ebp)
  801951:	eb 9e                	jmp    8018f1 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801953:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801956:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801959:	b8 0a 00 00 00       	mov    $0xa,%eax
  80195e:	e9 c6 00 00 00       	jmp    801a29 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801963:	83 f9 01             	cmp    $0x1,%ecx
  801966:	7e 18                	jle    801980 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801968:	8b 45 14             	mov    0x14(%ebp),%eax
  80196b:	8b 10                	mov    (%eax),%edx
  80196d:	8b 48 04             	mov    0x4(%eax),%ecx
  801970:	8d 40 08             	lea    0x8(%eax),%eax
  801973:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801976:	b8 0a 00 00 00       	mov    $0xa,%eax
  80197b:	e9 a9 00 00 00       	jmp    801a29 <vprintfmt+0x3bb>
	else if (lflag)
  801980:	85 c9                	test   %ecx,%ecx
  801982:	75 1a                	jne    80199e <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  801984:	8b 45 14             	mov    0x14(%ebp),%eax
  801987:	8b 10                	mov    (%eax),%edx
  801989:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198e:	8d 40 04             	lea    0x4(%eax),%eax
  801991:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801994:	b8 0a 00 00 00       	mov    $0xa,%eax
  801999:	e9 8b 00 00 00       	jmp    801a29 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80199e:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a1:	8b 10                	mov    (%eax),%edx
  8019a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a8:	8d 40 04             	lea    0x4(%eax),%eax
  8019ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b3:	eb 74                	jmp    801a29 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019b5:	83 f9 01             	cmp    $0x1,%ecx
  8019b8:	7e 15                	jle    8019cf <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bd:	8b 10                	mov    (%eax),%edx
  8019bf:	8b 48 04             	mov    0x4(%eax),%ecx
  8019c2:	8d 40 08             	lea    0x8(%eax),%eax
  8019c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019cd:	eb 5a                	jmp    801a29 <vprintfmt+0x3bb>
	else if (lflag)
  8019cf:	85 c9                	test   %ecx,%ecx
  8019d1:	75 17                	jne    8019ea <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d6:	8b 10                	mov    (%eax),%edx
  8019d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dd:	8d 40 04             	lea    0x4(%eax),%eax
  8019e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e8:	eb 3f                	jmp    801a29 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	8b 10                	mov    (%eax),%edx
  8019ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f4:	8d 40 04             	lea    0x4(%eax),%eax
  8019f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019fa:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ff:	eb 28                	jmp    801a29 <vprintfmt+0x3bb>
			putch('0', putdat);
  801a01:	83 ec 08             	sub    $0x8,%esp
  801a04:	53                   	push   %ebx
  801a05:	6a 30                	push   $0x30
  801a07:	ff d6                	call   *%esi
			putch('x', putdat);
  801a09:	83 c4 08             	add    $0x8,%esp
  801a0c:	53                   	push   %ebx
  801a0d:	6a 78                	push   $0x78
  801a0f:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a11:	8b 45 14             	mov    0x14(%ebp),%eax
  801a14:	8b 10                	mov    (%eax),%edx
  801a16:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a1b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a1e:	8d 40 04             	lea    0x4(%eax),%eax
  801a21:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a24:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a30:	57                   	push   %edi
  801a31:	ff 75 e0             	pushl  -0x20(%ebp)
  801a34:	50                   	push   %eax
  801a35:	51                   	push   %ecx
  801a36:	52                   	push   %edx
  801a37:	89 da                	mov    %ebx,%edx
  801a39:	89 f0                	mov    %esi,%eax
  801a3b:	e8 45 fb ff ff       	call   801585 <printnum>
			break;
  801a40:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a43:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a46:	83 c7 01             	add    $0x1,%edi
  801a49:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a4d:	83 f8 25             	cmp    $0x25,%eax
  801a50:	0f 84 2f fc ff ff    	je     801685 <vprintfmt+0x17>
			if (ch == '\0')
  801a56:	85 c0                	test   %eax,%eax
  801a58:	0f 84 8b 00 00 00    	je     801ae9 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	53                   	push   %ebx
  801a62:	50                   	push   %eax
  801a63:	ff d6                	call   *%esi
  801a65:	83 c4 10             	add    $0x10,%esp
  801a68:	eb dc                	jmp    801a46 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a6a:	83 f9 01             	cmp    $0x1,%ecx
  801a6d:	7e 15                	jle    801a84 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a72:	8b 10                	mov    (%eax),%edx
  801a74:	8b 48 04             	mov    0x4(%eax),%ecx
  801a77:	8d 40 08             	lea    0x8(%eax),%eax
  801a7a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a7d:	b8 10 00 00 00       	mov    $0x10,%eax
  801a82:	eb a5                	jmp    801a29 <vprintfmt+0x3bb>
	else if (lflag)
  801a84:	85 c9                	test   %ecx,%ecx
  801a86:	75 17                	jne    801a9f <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a88:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8b:	8b 10                	mov    (%eax),%edx
  801a8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a92:	8d 40 04             	lea    0x4(%eax),%eax
  801a95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a98:	b8 10 00 00 00       	mov    $0x10,%eax
  801a9d:	eb 8a                	jmp    801a29 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa2:	8b 10                	mov    (%eax),%edx
  801aa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa9:	8d 40 04             	lea    0x4(%eax),%eax
  801aac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aaf:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab4:	e9 70 ff ff ff       	jmp    801a29 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	53                   	push   %ebx
  801abd:	6a 25                	push   $0x25
  801abf:	ff d6                	call   *%esi
			break;
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	e9 7a ff ff ff       	jmp    801a43 <vprintfmt+0x3d5>
			putch('%', putdat);
  801ac9:	83 ec 08             	sub    $0x8,%esp
  801acc:	53                   	push   %ebx
  801acd:	6a 25                	push   $0x25
  801acf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	89 f8                	mov    %edi,%eax
  801ad6:	eb 03                	jmp    801adb <vprintfmt+0x46d>
  801ad8:	83 e8 01             	sub    $0x1,%eax
  801adb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801adf:	75 f7                	jne    801ad8 <vprintfmt+0x46a>
  801ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ae4:	e9 5a ff ff ff       	jmp    801a43 <vprintfmt+0x3d5>
}
  801ae9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aec:	5b                   	pop    %ebx
  801aed:	5e                   	pop    %esi
  801aee:	5f                   	pop    %edi
  801aef:	5d                   	pop    %ebp
  801af0:	c3                   	ret    

00801af1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 18             	sub    $0x18,%esp
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b00:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b04:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	74 26                	je     801b38 <vsnprintf+0x47>
  801b12:	85 d2                	test   %edx,%edx
  801b14:	7e 22                	jle    801b38 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b16:	ff 75 14             	pushl  0x14(%ebp)
  801b19:	ff 75 10             	pushl  0x10(%ebp)
  801b1c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b1f:	50                   	push   %eax
  801b20:	68 34 16 80 00       	push   $0x801634
  801b25:	e8 44 fb ff ff       	call   80166e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b33:	83 c4 10             	add    $0x10,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    
		return -E_INVAL;
  801b38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3d:	eb f7                	jmp    801b36 <vsnprintf+0x45>

00801b3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b45:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b48:	50                   	push   %eax
  801b49:	ff 75 10             	pushl  0x10(%ebp)
  801b4c:	ff 75 0c             	pushl  0xc(%ebp)
  801b4f:	ff 75 08             	pushl  0x8(%ebp)
  801b52:	e8 9a ff ff ff       	call   801af1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b64:	eb 03                	jmp    801b69 <strlen+0x10>
		n++;
  801b66:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b69:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b6d:	75 f7                	jne    801b66 <strlen+0xd>
	return n;
}
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b77:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7f:	eb 03                	jmp    801b84 <strnlen+0x13>
		n++;
  801b81:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b84:	39 d0                	cmp    %edx,%eax
  801b86:	74 06                	je     801b8e <strnlen+0x1d>
  801b88:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801b8c:	75 f3                	jne    801b81 <strnlen+0x10>
	return n;
}
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	53                   	push   %ebx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b9a:	89 c2                	mov    %eax,%edx
  801b9c:	83 c1 01             	add    $0x1,%ecx
  801b9f:	83 c2 01             	add    $0x1,%edx
  801ba2:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801ba6:	88 5a ff             	mov    %bl,-0x1(%edx)
  801ba9:	84 db                	test   %bl,%bl
  801bab:	75 ef                	jne    801b9c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801bad:	5b                   	pop    %ebx
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	53                   	push   %ebx
  801bb4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bb7:	53                   	push   %ebx
  801bb8:	e8 9c ff ff ff       	call   801b59 <strlen>
  801bbd:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	01 d8                	add    %ebx,%eax
  801bc5:	50                   	push   %eax
  801bc6:	e8 c5 ff ff ff       	call   801b90 <strcpy>
	return dst;
}
  801bcb:	89 d8                	mov    %ebx,%eax
  801bcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	56                   	push   %esi
  801bd6:	53                   	push   %ebx
  801bd7:	8b 75 08             	mov    0x8(%ebp),%esi
  801bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bdd:	89 f3                	mov    %esi,%ebx
  801bdf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801be2:	89 f2                	mov    %esi,%edx
  801be4:	eb 0f                	jmp    801bf5 <strncpy+0x23>
		*dst++ = *src;
  801be6:	83 c2 01             	add    $0x1,%edx
  801be9:	0f b6 01             	movzbl (%ecx),%eax
  801bec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bef:	80 39 01             	cmpb   $0x1,(%ecx)
  801bf2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801bf5:	39 da                	cmp    %ebx,%edx
  801bf7:	75 ed                	jne    801be6 <strncpy+0x14>
	}
	return ret;
}
  801bf9:	89 f0                	mov    %esi,%eax
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    

00801bff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	8b 75 08             	mov    0x8(%ebp),%esi
  801c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0d:	89 f0                	mov    %esi,%eax
  801c0f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c13:	85 c9                	test   %ecx,%ecx
  801c15:	75 0b                	jne    801c22 <strlcpy+0x23>
  801c17:	eb 17                	jmp    801c30 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c19:	83 c2 01             	add    $0x1,%edx
  801c1c:	83 c0 01             	add    $0x1,%eax
  801c1f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c22:	39 d8                	cmp    %ebx,%eax
  801c24:	74 07                	je     801c2d <strlcpy+0x2e>
  801c26:	0f b6 0a             	movzbl (%edx),%ecx
  801c29:	84 c9                	test   %cl,%cl
  801c2b:	75 ec                	jne    801c19 <strlcpy+0x1a>
		*dst = '\0';
  801c2d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c30:	29 f0                	sub    %esi,%eax
}
  801c32:	5b                   	pop    %ebx
  801c33:	5e                   	pop    %esi
  801c34:	5d                   	pop    %ebp
  801c35:	c3                   	ret    

00801c36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c3f:	eb 06                	jmp    801c47 <strcmp+0x11>
		p++, q++;
  801c41:	83 c1 01             	add    $0x1,%ecx
  801c44:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c47:	0f b6 01             	movzbl (%ecx),%eax
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 04                	je     801c52 <strcmp+0x1c>
  801c4e:	3a 02                	cmp    (%edx),%al
  801c50:	74 ef                	je     801c41 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c52:	0f b6 c0             	movzbl %al,%eax
  801c55:	0f b6 12             	movzbl (%edx),%edx
  801c58:	29 d0                	sub    %edx,%eax
}
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    

00801c5c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	53                   	push   %ebx
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c66:	89 c3                	mov    %eax,%ebx
  801c68:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c6b:	eb 06                	jmp    801c73 <strncmp+0x17>
		n--, p++, q++;
  801c6d:	83 c0 01             	add    $0x1,%eax
  801c70:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c73:	39 d8                	cmp    %ebx,%eax
  801c75:	74 16                	je     801c8d <strncmp+0x31>
  801c77:	0f b6 08             	movzbl (%eax),%ecx
  801c7a:	84 c9                	test   %cl,%cl
  801c7c:	74 04                	je     801c82 <strncmp+0x26>
  801c7e:	3a 0a                	cmp    (%edx),%cl
  801c80:	74 eb                	je     801c6d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c82:	0f b6 00             	movzbl (%eax),%eax
  801c85:	0f b6 12             	movzbl (%edx),%edx
  801c88:	29 d0                	sub    %edx,%eax
}
  801c8a:	5b                   	pop    %ebx
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
		return 0;
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c92:	eb f6                	jmp    801c8a <strncmp+0x2e>

00801c94 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c9e:	0f b6 10             	movzbl (%eax),%edx
  801ca1:	84 d2                	test   %dl,%dl
  801ca3:	74 09                	je     801cae <strchr+0x1a>
		if (*s == c)
  801ca5:	38 ca                	cmp    %cl,%dl
  801ca7:	74 0a                	je     801cb3 <strchr+0x1f>
	for (; *s; s++)
  801ca9:	83 c0 01             	add    $0x1,%eax
  801cac:	eb f0                	jmp    801c9e <strchr+0xa>
			return (char *) s;
	return 0;
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cbf:	eb 03                	jmp    801cc4 <strfind+0xf>
  801cc1:	83 c0 01             	add    $0x1,%eax
  801cc4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cc7:	38 ca                	cmp    %cl,%dl
  801cc9:	74 04                	je     801ccf <strfind+0x1a>
  801ccb:	84 d2                	test   %dl,%dl
  801ccd:	75 f2                	jne    801cc1 <strfind+0xc>
			break;
	return (char *) s;
}
  801ccf:	5d                   	pop    %ebp
  801cd0:	c3                   	ret    

00801cd1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	57                   	push   %edi
  801cd5:	56                   	push   %esi
  801cd6:	53                   	push   %ebx
  801cd7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cdd:	85 c9                	test   %ecx,%ecx
  801cdf:	74 13                	je     801cf4 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ce1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801ce7:	75 05                	jne    801cee <memset+0x1d>
  801ce9:	f6 c1 03             	test   $0x3,%cl
  801cec:	74 0d                	je     801cfb <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	fc                   	cld    
  801cf2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801cf4:	89 f8                	mov    %edi,%eax
  801cf6:	5b                   	pop    %ebx
  801cf7:	5e                   	pop    %esi
  801cf8:	5f                   	pop    %edi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    
		c &= 0xFF;
  801cfb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cff:	89 d3                	mov    %edx,%ebx
  801d01:	c1 e3 08             	shl    $0x8,%ebx
  801d04:	89 d0                	mov    %edx,%eax
  801d06:	c1 e0 18             	shl    $0x18,%eax
  801d09:	89 d6                	mov    %edx,%esi
  801d0b:	c1 e6 10             	shl    $0x10,%esi
  801d0e:	09 f0                	or     %esi,%eax
  801d10:	09 c2                	or     %eax,%edx
  801d12:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d14:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d17:	89 d0                	mov    %edx,%eax
  801d19:	fc                   	cld    
  801d1a:	f3 ab                	rep stos %eax,%es:(%edi)
  801d1c:	eb d6                	jmp    801cf4 <memset+0x23>

00801d1e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d29:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d2c:	39 c6                	cmp    %eax,%esi
  801d2e:	73 35                	jae    801d65 <memmove+0x47>
  801d30:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d33:	39 c2                	cmp    %eax,%edx
  801d35:	76 2e                	jbe    801d65 <memmove+0x47>
		s += n;
		d += n;
  801d37:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d3a:	89 d6                	mov    %edx,%esi
  801d3c:	09 fe                	or     %edi,%esi
  801d3e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d44:	74 0c                	je     801d52 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d46:	83 ef 01             	sub    $0x1,%edi
  801d49:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d4c:	fd                   	std    
  801d4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d4f:	fc                   	cld    
  801d50:	eb 21                	jmp    801d73 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d52:	f6 c1 03             	test   $0x3,%cl
  801d55:	75 ef                	jne    801d46 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d57:	83 ef 04             	sub    $0x4,%edi
  801d5a:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d5d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d60:	fd                   	std    
  801d61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d63:	eb ea                	jmp    801d4f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d65:	89 f2                	mov    %esi,%edx
  801d67:	09 c2                	or     %eax,%edx
  801d69:	f6 c2 03             	test   $0x3,%dl
  801d6c:	74 09                	je     801d77 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d6e:	89 c7                	mov    %eax,%edi
  801d70:	fc                   	cld    
  801d71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d73:	5e                   	pop    %esi
  801d74:	5f                   	pop    %edi
  801d75:	5d                   	pop    %ebp
  801d76:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d77:	f6 c1 03             	test   $0x3,%cl
  801d7a:	75 f2                	jne    801d6e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d7f:	89 c7                	mov    %eax,%edi
  801d81:	fc                   	cld    
  801d82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d84:	eb ed                	jmp    801d73 <memmove+0x55>

00801d86 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801d89:	ff 75 10             	pushl  0x10(%ebp)
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	ff 75 08             	pushl  0x8(%ebp)
  801d92:	e8 87 ff ff ff       	call   801d1e <memmove>
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da4:	89 c6                	mov    %eax,%esi
  801da6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801da9:	39 f0                	cmp    %esi,%eax
  801dab:	74 1c                	je     801dc9 <memcmp+0x30>
		if (*s1 != *s2)
  801dad:	0f b6 08             	movzbl (%eax),%ecx
  801db0:	0f b6 1a             	movzbl (%edx),%ebx
  801db3:	38 d9                	cmp    %bl,%cl
  801db5:	75 08                	jne    801dbf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801db7:	83 c0 01             	add    $0x1,%eax
  801dba:	83 c2 01             	add    $0x1,%edx
  801dbd:	eb ea                	jmp    801da9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dbf:	0f b6 c1             	movzbl %cl,%eax
  801dc2:	0f b6 db             	movzbl %bl,%ebx
  801dc5:	29 d8                	sub    %ebx,%eax
  801dc7:	eb 05                	jmp    801dce <memcmp+0x35>
	}

	return 0;
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801ddb:	89 c2                	mov    %eax,%edx
  801ddd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801de0:	39 d0                	cmp    %edx,%eax
  801de2:	73 09                	jae    801ded <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801de4:	38 08                	cmp    %cl,(%eax)
  801de6:	74 05                	je     801ded <memfind+0x1b>
	for (; s < ends; s++)
  801de8:	83 c0 01             	add    $0x1,%eax
  801deb:	eb f3                	jmp    801de0 <memfind+0xe>
			break;
	return (void *) s;
}
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    

00801def <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	57                   	push   %edi
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dfb:	eb 03                	jmp    801e00 <strtol+0x11>
		s++;
  801dfd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e00:	0f b6 01             	movzbl (%ecx),%eax
  801e03:	3c 20                	cmp    $0x20,%al
  801e05:	74 f6                	je     801dfd <strtol+0xe>
  801e07:	3c 09                	cmp    $0x9,%al
  801e09:	74 f2                	je     801dfd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e0b:	3c 2b                	cmp    $0x2b,%al
  801e0d:	74 2e                	je     801e3d <strtol+0x4e>
	int neg = 0;
  801e0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e14:	3c 2d                	cmp    $0x2d,%al
  801e16:	74 2f                	je     801e47 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e1e:	75 05                	jne    801e25 <strtol+0x36>
  801e20:	80 39 30             	cmpb   $0x30,(%ecx)
  801e23:	74 2c                	je     801e51 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e25:	85 db                	test   %ebx,%ebx
  801e27:	75 0a                	jne    801e33 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e29:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e2e:	80 39 30             	cmpb   $0x30,(%ecx)
  801e31:	74 28                	je     801e5b <strtol+0x6c>
		base = 10;
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
  801e38:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e3b:	eb 50                	jmp    801e8d <strtol+0x9e>
		s++;
  801e3d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e40:	bf 00 00 00 00       	mov    $0x0,%edi
  801e45:	eb d1                	jmp    801e18 <strtol+0x29>
		s++, neg = 1;
  801e47:	83 c1 01             	add    $0x1,%ecx
  801e4a:	bf 01 00 00 00       	mov    $0x1,%edi
  801e4f:	eb c7                	jmp    801e18 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e51:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e55:	74 0e                	je     801e65 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e57:	85 db                	test   %ebx,%ebx
  801e59:	75 d8                	jne    801e33 <strtol+0x44>
		s++, base = 8;
  801e5b:	83 c1 01             	add    $0x1,%ecx
  801e5e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e63:	eb ce                	jmp    801e33 <strtol+0x44>
		s += 2, base = 16;
  801e65:	83 c1 02             	add    $0x2,%ecx
  801e68:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e6d:	eb c4                	jmp    801e33 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e6f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e72:	89 f3                	mov    %esi,%ebx
  801e74:	80 fb 19             	cmp    $0x19,%bl
  801e77:	77 29                	ja     801ea2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e79:	0f be d2             	movsbl %dl,%edx
  801e7c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e7f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e82:	7d 30                	jge    801eb4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e84:	83 c1 01             	add    $0x1,%ecx
  801e87:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e8b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e8d:	0f b6 11             	movzbl (%ecx),%edx
  801e90:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e93:	89 f3                	mov    %esi,%ebx
  801e95:	80 fb 09             	cmp    $0x9,%bl
  801e98:	77 d5                	ja     801e6f <strtol+0x80>
			dig = *s - '0';
  801e9a:	0f be d2             	movsbl %dl,%edx
  801e9d:	83 ea 30             	sub    $0x30,%edx
  801ea0:	eb dd                	jmp    801e7f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801ea2:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ea5:	89 f3                	mov    %esi,%ebx
  801ea7:	80 fb 19             	cmp    $0x19,%bl
  801eaa:	77 08                	ja     801eb4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801eac:	0f be d2             	movsbl %dl,%edx
  801eaf:	83 ea 37             	sub    $0x37,%edx
  801eb2:	eb cb                	jmp    801e7f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801eb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb8:	74 05                	je     801ebf <strtol+0xd0>
		*endptr = (char *) s;
  801eba:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ebd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ebf:	89 c2                	mov    %eax,%edx
  801ec1:	f7 da                	neg    %edx
  801ec3:	85 ff                	test   %edi,%edi
  801ec5:	0f 45 c2             	cmovne %edx,%eax
}
  801ec8:	5b                   	pop    %ebx
  801ec9:	5e                   	pop    %esi
  801eca:	5f                   	pop    %edi
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    

00801ecd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	56                   	push   %esi
  801ed1:	53                   	push   %ebx
  801ed2:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801edb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801edd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ee2:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	50                   	push   %eax
  801ee9:	e8 28 e4 ff ff       	call   800316 <sys_ipc_recv>
	if (from_env_store)
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 f6                	test   %esi,%esi
  801ef3:	74 14                	je     801f09 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 09                	js     801f07 <ipc_recv+0x3a>
  801efe:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f04:	8b 52 74             	mov    0x74(%edx),%edx
  801f07:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f09:	85 db                	test   %ebx,%ebx
  801f0b:	74 14                	je     801f21 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f12:	85 c0                	test   %eax,%eax
  801f14:	78 09                	js     801f1f <ipc_recv+0x52>
  801f16:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f1c:	8b 52 78             	mov    0x78(%edx),%edx
  801f1f:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 08                	js     801f2d <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f25:	a1 08 40 80 00       	mov    0x804008,%eax
  801f2a:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5d                   	pop    %ebp
  801f33:	c3                   	ret    

00801f34 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	57                   	push   %edi
  801f38:	56                   	push   %esi
  801f39:	53                   	push   %ebx
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f40:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f46:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f48:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f4d:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f50:	ff 75 14             	pushl  0x14(%ebp)
  801f53:	53                   	push   %ebx
  801f54:	56                   	push   %esi
  801f55:	57                   	push   %edi
  801f56:	e8 98 e3 ff ff       	call   8002f3 <sys_ipc_try_send>
		if (ret == 0)
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	74 1e                	je     801f80 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f62:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f65:	75 07                	jne    801f6e <ipc_send+0x3a>
			sys_yield();
  801f67:	e8 db e1 ff ff       	call   800147 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f6c:	eb e2                	jmp    801f50 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f6e:	50                   	push   %eax
  801f6f:	68 c0 26 80 00       	push   $0x8026c0
  801f74:	6a 3d                	push   $0x3d
  801f76:	68 d4 26 80 00       	push   $0x8026d4
  801f7b:	e8 16 f5 ff ff       	call   801496 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f83:	5b                   	pop    %ebx
  801f84:	5e                   	pop    %esi
  801f85:	5f                   	pop    %edi
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f93:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f96:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f9c:	8b 52 50             	mov    0x50(%edx),%edx
  801f9f:	39 ca                	cmp    %ecx,%edx
  801fa1:	74 11                	je     801fb4 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fa3:	83 c0 01             	add    $0x1,%eax
  801fa6:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fab:	75 e6                	jne    801f93 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb2:	eb 0b                	jmp    801fbf <ipc_find_env+0x37>
			return envs[i].env_id;
  801fb4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fb7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fbc:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fc7:	89 d0                	mov    %edx,%eax
  801fc9:	c1 e8 16             	shr    $0x16,%eax
  801fcc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fd8:	f6 c1 01             	test   $0x1,%cl
  801fdb:	74 1d                	je     801ffa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fdd:	c1 ea 0c             	shr    $0xc,%edx
  801fe0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fe7:	f6 c2 01             	test   $0x1,%dl
  801fea:	74 0e                	je     801ffa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fec:	c1 ea 0c             	shr    $0xc,%edx
  801fef:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ff6:	ef 
  801ff7:	0f b7 c0             	movzwl %ax,%eax
}
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    
  801ffc:	66 90                	xchg   %ax,%ax
  801ffe:	66 90                	xchg   %ax,%ax

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


obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 80 03 80 00       	push   $0x800380
  80003e:	6a 00                	push   $0x0
  800040:	e8 76 02 00 00       	call   8002bb <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 ce 00 00 00       	call   800132 <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800071:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x2d>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a0:	e8 d7 04 00 00       	call   80057c <close_all>
	sys_env_destroy(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 42 00 00 00       	call   8000f1 <sys_env_destroy>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	89 c7                	mov    %eax,%edi
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e2:	89 d1                	mov    %edx,%ecx
  8000e4:	89 d3                	mov    %edx,%ebx
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	89 d6                	mov    %edx,%esi
  8000ea:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800102:	b8 03 00 00 00       	mov    $0x3,%eax
  800107:	89 cb                	mov    %ecx,%ebx
  800109:	89 cf                	mov    %ecx,%edi
  80010b:	89 ce                	mov    %ecx,%esi
  80010d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	7f 08                	jg     80011b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800113:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800116:	5b                   	pop    %ebx
  800117:	5e                   	pop    %esi
  800118:	5f                   	pop    %edi
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	6a 03                	push   $0x3
  800121:	68 ea 22 80 00       	push   $0x8022ea
  800126:	6a 23                	push   $0x23
  800128:	68 07 23 80 00       	push   $0x802307
  80012d:	e8 94 13 00 00       	call   8014c6 <_panic>

00800132 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 02 00 00 00       	mov    $0x2,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_yield>:

void
sys_yield(void)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
	asm volatile("int %1\n"
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800161:	89 d1                	mov    %edx,%ecx
  800163:	89 d3                	mov    %edx,%ebx
  800165:	89 d7                	mov    %edx,%edi
  800167:	89 d6                	mov    %edx,%esi
  800169:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016b:	5b                   	pop    %ebx
  80016c:	5e                   	pop    %esi
  80016d:	5f                   	pop    %edi
  80016e:	5d                   	pop    %ebp
  80016f:	c3                   	ret    

00800170 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800179:	be 00 00 00 00       	mov    $0x0,%esi
  80017e:	8b 55 08             	mov    0x8(%ebp),%edx
  800181:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800184:	b8 04 00 00 00       	mov    $0x4,%eax
  800189:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80018c:	89 f7                	mov    %esi,%edi
  80018e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800190:	85 c0                	test   %eax,%eax
  800192:	7f 08                	jg     80019c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800197:	5b                   	pop    %ebx
  800198:	5e                   	pop    %esi
  800199:	5f                   	pop    %edi
  80019a:	5d                   	pop    %ebp
  80019b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	6a 04                	push   $0x4
  8001a2:	68 ea 22 80 00       	push   $0x8022ea
  8001a7:	6a 23                	push   $0x23
  8001a9:	68 07 23 80 00       	push   $0x802307
  8001ae:	e8 13 13 00 00       	call   8014c6 <_panic>

008001b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	57                   	push   %edi
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ca:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	7f 08                	jg     8001de <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	6a 05                	push   $0x5
  8001e4:	68 ea 22 80 00       	push   $0x8022ea
  8001e9:	6a 23                	push   $0x23
  8001eb:	68 07 23 80 00       	push   $0x802307
  8001f0:	e8 d1 12 00 00       	call   8014c6 <_panic>

008001f5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	57                   	push   %edi
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800203:	8b 55 08             	mov    0x8(%ebp),%edx
  800206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800209:	b8 06 00 00 00       	mov    $0x6,%eax
  80020e:	89 df                	mov    %ebx,%edi
  800210:	89 de                	mov    %ebx,%esi
  800212:	cd 30                	int    $0x30
	if(check && ret > 0)
  800214:	85 c0                	test   %eax,%eax
  800216:	7f 08                	jg     800220 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021b:	5b                   	pop    %ebx
  80021c:	5e                   	pop    %esi
  80021d:	5f                   	pop    %edi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	50                   	push   %eax
  800224:	6a 06                	push   $0x6
  800226:	68 ea 22 80 00       	push   $0x8022ea
  80022b:	6a 23                	push   $0x23
  80022d:	68 07 23 80 00       	push   $0x802307
  800232:	e8 8f 12 00 00       	call   8014c6 <_panic>

00800237 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800240:	bb 00 00 00 00       	mov    $0x0,%ebx
  800245:	8b 55 08             	mov    0x8(%ebp),%edx
  800248:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024b:	b8 08 00 00 00       	mov    $0x8,%eax
  800250:	89 df                	mov    %ebx,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	cd 30                	int    $0x30
	if(check && ret > 0)
  800256:	85 c0                	test   %eax,%eax
  800258:	7f 08                	jg     800262 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80025a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025d:	5b                   	pop    %ebx
  80025e:	5e                   	pop    %esi
  80025f:	5f                   	pop    %edi
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	50                   	push   %eax
  800266:	6a 08                	push   $0x8
  800268:	68 ea 22 80 00       	push   $0x8022ea
  80026d:	6a 23                	push   $0x23
  80026f:	68 07 23 80 00       	push   $0x802307
  800274:	e8 4d 12 00 00       	call   8014c6 <_panic>

00800279 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	57                   	push   %edi
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800282:	bb 00 00 00 00       	mov    $0x0,%ebx
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028d:	b8 09 00 00 00       	mov    $0x9,%eax
  800292:	89 df                	mov    %ebx,%edi
  800294:	89 de                	mov    %ebx,%esi
  800296:	cd 30                	int    $0x30
	if(check && ret > 0)
  800298:	85 c0                	test   %eax,%eax
  80029a:	7f 08                	jg     8002a4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	50                   	push   %eax
  8002a8:	6a 09                	push   $0x9
  8002aa:	68 ea 22 80 00       	push   $0x8022ea
  8002af:	6a 23                	push   $0x23
  8002b1:	68 07 23 80 00       	push   $0x802307
  8002b6:	e8 0b 12 00 00       	call   8014c6 <_panic>

008002bb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002d4:	89 df                	mov    %ebx,%edi
  8002d6:	89 de                	mov    %ebx,%esi
  8002d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	7f 08                	jg     8002e6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	6a 0a                	push   $0xa
  8002ec:	68 ea 22 80 00       	push   $0x8022ea
  8002f1:	6a 23                	push   $0x23
  8002f3:	68 07 23 80 00       	push   $0x802307
  8002f8:	e8 c9 11 00 00       	call   8014c6 <_panic>

008002fd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	57                   	push   %edi
  800301:	56                   	push   %esi
  800302:	53                   	push   %ebx
	asm volatile("int %1\n"
  800303:	8b 55 08             	mov    0x8(%ebp),%edx
  800306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800309:	b8 0c 00 00 00       	mov    $0xc,%eax
  80030e:	be 00 00 00 00       	mov    $0x0,%esi
  800313:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800316:	8b 7d 14             	mov    0x14(%ebp),%edi
  800319:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800329:	b9 00 00 00 00       	mov    $0x0,%ecx
  80032e:	8b 55 08             	mov    0x8(%ebp),%edx
  800331:	b8 0d 00 00 00       	mov    $0xd,%eax
  800336:	89 cb                	mov    %ecx,%ebx
  800338:	89 cf                	mov    %ecx,%edi
  80033a:	89 ce                	mov    %ecx,%esi
  80033c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80033e:	85 c0                	test   %eax,%eax
  800340:	7f 08                	jg     80034a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	50                   	push   %eax
  80034e:	6a 0d                	push   $0xd
  800350:	68 ea 22 80 00       	push   $0x8022ea
  800355:	6a 23                	push   $0x23
  800357:	68 07 23 80 00       	push   $0x802307
  80035c:	e8 65 11 00 00       	call   8014c6 <_panic>

00800361 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
	asm volatile("int %1\n"
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
  80036c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800371:	89 d1                	mov    %edx,%ecx
  800373:	89 d3                	mov    %edx,%ebx
  800375:	89 d7                	mov    %edx,%edi
  800377:	89 d6                	mov    %edx,%esi
  800379:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80037b:	5b                   	pop    %ebx
  80037c:	5e                   	pop    %esi
  80037d:	5f                   	pop    %edi
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    

00800380 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800380:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800381:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  800386:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800388:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  80038b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  80038f:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  800392:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  800396:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  80039a:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  80039c:	83 c4 08             	add    $0x8,%esp
	popal
  80039f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8003a0:	83 c4 04             	add    $0x4,%esp
	popfl
  8003a3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8003a4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8003a5:	c3                   	ret    

008003a6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	05 00 00 00 30       	add    $0x30000000,%eax
  8003b1:	c1 e8 0c             	shr    $0xc,%eax
}
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	c1 ea 16             	shr    $0x16,%edx
  8003dd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003e4:	f6 c2 01             	test   $0x1,%dl
  8003e7:	74 2a                	je     800413 <fd_alloc+0x46>
  8003e9:	89 c2                	mov    %eax,%edx
  8003eb:	c1 ea 0c             	shr    $0xc,%edx
  8003ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003f5:	f6 c2 01             	test   $0x1,%dl
  8003f8:	74 19                	je     800413 <fd_alloc+0x46>
  8003fa:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003ff:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800404:	75 d2                	jne    8003d8 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800406:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80040c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800411:	eb 07                	jmp    80041a <fd_alloc+0x4d>
			*fd_store = fd;
  800413:	89 01                	mov    %eax,(%ecx)
			return 0;
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800422:	83 f8 1f             	cmp    $0x1f,%eax
  800425:	77 36                	ja     80045d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800427:	c1 e0 0c             	shl    $0xc,%eax
  80042a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80042f:	89 c2                	mov    %eax,%edx
  800431:	c1 ea 16             	shr    $0x16,%edx
  800434:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80043b:	f6 c2 01             	test   $0x1,%dl
  80043e:	74 24                	je     800464 <fd_lookup+0x48>
  800440:	89 c2                	mov    %eax,%edx
  800442:	c1 ea 0c             	shr    $0xc,%edx
  800445:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80044c:	f6 c2 01             	test   $0x1,%dl
  80044f:	74 1a                	je     80046b <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800451:	8b 55 0c             	mov    0xc(%ebp),%edx
  800454:	89 02                	mov    %eax,(%edx)
	return 0;
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    
		return -E_INVAL;
  80045d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800462:	eb f7                	jmp    80045b <fd_lookup+0x3f>
		return -E_INVAL;
  800464:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800469:	eb f0                	jmp    80045b <fd_lookup+0x3f>
  80046b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800470:	eb e9                	jmp    80045b <fd_lookup+0x3f>

00800472 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80047b:	ba 94 23 80 00       	mov    $0x802394,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800480:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800485:	39 08                	cmp    %ecx,(%eax)
  800487:	74 33                	je     8004bc <dev_lookup+0x4a>
  800489:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80048c:	8b 02                	mov    (%edx),%eax
  80048e:	85 c0                	test   %eax,%eax
  800490:	75 f3                	jne    800485 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800492:	a1 08 40 80 00       	mov    0x804008,%eax
  800497:	8b 40 48             	mov    0x48(%eax),%eax
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	51                   	push   %ecx
  80049e:	50                   	push   %eax
  80049f:	68 18 23 80 00       	push   $0x802318
  8004a4:	e8 f8 10 00 00       	call   8015a1 <cprintf>
	*dev = 0;
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    
			*dev = devtab[i];
  8004bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	eb f2                	jmp    8004ba <dev_lookup+0x48>

008004c8 <fd_close>:
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	57                   	push   %edi
  8004cc:	56                   	push   %esi
  8004cd:	53                   	push   %ebx
  8004ce:	83 ec 1c             	sub    $0x1c,%esp
  8004d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004da:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004e1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004e4:	50                   	push   %eax
  8004e5:	e8 32 ff ff ff       	call   80041c <fd_lookup>
  8004ea:	89 c3                	mov    %eax,%ebx
  8004ec:	83 c4 08             	add    $0x8,%esp
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	78 05                	js     8004f8 <fd_close+0x30>
	    || fd != fd2)
  8004f3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004f6:	74 16                	je     80050e <fd_close+0x46>
		return (must_exist ? r : 0);
  8004f8:	89 f8                	mov    %edi,%eax
  8004fa:	84 c0                	test   %al,%al
  8004fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800501:	0f 44 d8             	cmove  %eax,%ebx
}
  800504:	89 d8                	mov    %ebx,%eax
  800506:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800509:	5b                   	pop    %ebx
  80050a:	5e                   	pop    %esi
  80050b:	5f                   	pop    %edi
  80050c:	5d                   	pop    %ebp
  80050d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800514:	50                   	push   %eax
  800515:	ff 36                	pushl  (%esi)
  800517:	e8 56 ff ff ff       	call   800472 <dev_lookup>
  80051c:	89 c3                	mov    %eax,%ebx
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	85 c0                	test   %eax,%eax
  800523:	78 15                	js     80053a <fd_close+0x72>
		if (dev->dev_close)
  800525:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800528:	8b 40 10             	mov    0x10(%eax),%eax
  80052b:	85 c0                	test   %eax,%eax
  80052d:	74 1b                	je     80054a <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	56                   	push   %esi
  800533:	ff d0                	call   *%eax
  800535:	89 c3                	mov    %eax,%ebx
  800537:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	56                   	push   %esi
  80053e:	6a 00                	push   $0x0
  800540:	e8 b0 fc ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	eb ba                	jmp    800504 <fd_close+0x3c>
			r = 0;
  80054a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054f:	eb e9                	jmp    80053a <fd_close+0x72>

00800551 <close>:

int
close(int fdnum)
{
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800557:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80055a:	50                   	push   %eax
  80055b:	ff 75 08             	pushl  0x8(%ebp)
  80055e:	e8 b9 fe ff ff       	call   80041c <fd_lookup>
  800563:	83 c4 08             	add    $0x8,%esp
  800566:	85 c0                	test   %eax,%eax
  800568:	78 10                	js     80057a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	6a 01                	push   $0x1
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	e8 51 ff ff ff       	call   8004c8 <fd_close>
  800577:	83 c4 10             	add    $0x10,%esp
}
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <close_all>:

void
close_all(void)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	53                   	push   %ebx
  800580:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800583:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800588:	83 ec 0c             	sub    $0xc,%esp
  80058b:	53                   	push   %ebx
  80058c:	e8 c0 ff ff ff       	call   800551 <close>
	for (i = 0; i < MAXFD; i++)
  800591:	83 c3 01             	add    $0x1,%ebx
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	83 fb 20             	cmp    $0x20,%ebx
  80059a:	75 ec                	jne    800588 <close_all+0xc>
}
  80059c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	57                   	push   %edi
  8005a5:	56                   	push   %esi
  8005a6:	53                   	push   %ebx
  8005a7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005ad:	50                   	push   %eax
  8005ae:	ff 75 08             	pushl  0x8(%ebp)
  8005b1:	e8 66 fe ff ff       	call   80041c <fd_lookup>
  8005b6:	89 c3                	mov    %eax,%ebx
  8005b8:	83 c4 08             	add    $0x8,%esp
  8005bb:	85 c0                	test   %eax,%eax
  8005bd:	0f 88 81 00 00 00    	js     800644 <dup+0xa3>
		return r;
	close(newfdnum);
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff 75 0c             	pushl  0xc(%ebp)
  8005c9:	e8 83 ff ff ff       	call   800551 <close>

	newfd = INDEX2FD(newfdnum);
  8005ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005d1:	c1 e6 0c             	shl    $0xc,%esi
  8005d4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005da:	83 c4 04             	add    $0x4,%esp
  8005dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e0:	e8 d1 fd ff ff       	call   8003b6 <fd2data>
  8005e5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005e7:	89 34 24             	mov    %esi,(%esp)
  8005ea:	e8 c7 fd ff ff       	call   8003b6 <fd2data>
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005f4:	89 d8                	mov    %ebx,%eax
  8005f6:	c1 e8 16             	shr    $0x16,%eax
  8005f9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800600:	a8 01                	test   $0x1,%al
  800602:	74 11                	je     800615 <dup+0x74>
  800604:	89 d8                	mov    %ebx,%eax
  800606:	c1 e8 0c             	shr    $0xc,%eax
  800609:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800610:	f6 c2 01             	test   $0x1,%dl
  800613:	75 39                	jne    80064e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800615:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800618:	89 d0                	mov    %edx,%eax
  80061a:	c1 e8 0c             	shr    $0xc,%eax
  80061d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	25 07 0e 00 00       	and    $0xe07,%eax
  80062c:	50                   	push   %eax
  80062d:	56                   	push   %esi
  80062e:	6a 00                	push   $0x0
  800630:	52                   	push   %edx
  800631:	6a 00                	push   $0x0
  800633:	e8 7b fb ff ff       	call   8001b3 <sys_page_map>
  800638:	89 c3                	mov    %eax,%ebx
  80063a:	83 c4 20             	add    $0x20,%esp
  80063d:	85 c0                	test   %eax,%eax
  80063f:	78 31                	js     800672 <dup+0xd1>
		goto err;

	return newfdnum;
  800641:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800644:	89 d8                	mov    %ebx,%eax
  800646:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800649:	5b                   	pop    %ebx
  80064a:	5e                   	pop    %esi
  80064b:	5f                   	pop    %edi
  80064c:	5d                   	pop    %ebp
  80064d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80064e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800655:	83 ec 0c             	sub    $0xc,%esp
  800658:	25 07 0e 00 00       	and    $0xe07,%eax
  80065d:	50                   	push   %eax
  80065e:	57                   	push   %edi
  80065f:	6a 00                	push   $0x0
  800661:	53                   	push   %ebx
  800662:	6a 00                	push   $0x0
  800664:	e8 4a fb ff ff       	call   8001b3 <sys_page_map>
  800669:	89 c3                	mov    %eax,%ebx
  80066b:	83 c4 20             	add    $0x20,%esp
  80066e:	85 c0                	test   %eax,%eax
  800670:	79 a3                	jns    800615 <dup+0x74>
	sys_page_unmap(0, newfd);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	56                   	push   %esi
  800676:	6a 00                	push   $0x0
  800678:	e8 78 fb ff ff       	call   8001f5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80067d:	83 c4 08             	add    $0x8,%esp
  800680:	57                   	push   %edi
  800681:	6a 00                	push   $0x0
  800683:	e8 6d fb ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  800688:	83 c4 10             	add    $0x10,%esp
  80068b:	eb b7                	jmp    800644 <dup+0xa3>

0080068d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	53                   	push   %ebx
  800691:	83 ec 14             	sub    $0x14,%esp
  800694:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800697:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80069a:	50                   	push   %eax
  80069b:	53                   	push   %ebx
  80069c:	e8 7b fd ff ff       	call   80041c <fd_lookup>
  8006a1:	83 c4 08             	add    $0x8,%esp
  8006a4:	85 c0                	test   %eax,%eax
  8006a6:	78 3f                	js     8006e7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006ae:	50                   	push   %eax
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	ff 30                	pushl  (%eax)
  8006b4:	e8 b9 fd ff ff       	call   800472 <dev_lookup>
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	85 c0                	test   %eax,%eax
  8006be:	78 27                	js     8006e7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006c3:	8b 42 08             	mov    0x8(%edx),%eax
  8006c6:	83 e0 03             	and    $0x3,%eax
  8006c9:	83 f8 01             	cmp    $0x1,%eax
  8006cc:	74 1e                	je     8006ec <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d1:	8b 40 08             	mov    0x8(%eax),%eax
  8006d4:	85 c0                	test   %eax,%eax
  8006d6:	74 35                	je     80070d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006d8:	83 ec 04             	sub    $0x4,%esp
  8006db:	ff 75 10             	pushl  0x10(%ebp)
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	ff d0                	call   *%eax
  8006e4:	83 c4 10             	add    $0x10,%esp
}
  8006e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ea:	c9                   	leave  
  8006eb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8006f1:	8b 40 48             	mov    0x48(%eax),%eax
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	50                   	push   %eax
  8006f9:	68 59 23 80 00       	push   $0x802359
  8006fe:	e8 9e 0e 00 00       	call   8015a1 <cprintf>
		return -E_INVAL;
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070b:	eb da                	jmp    8006e7 <read+0x5a>
		return -E_NOT_SUPP;
  80070d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800712:	eb d3                	jmp    8006e7 <read+0x5a>

00800714 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	57                   	push   %edi
  800718:	56                   	push   %esi
  800719:	53                   	push   %ebx
  80071a:	83 ec 0c             	sub    $0xc,%esp
  80071d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800720:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800723:	bb 00 00 00 00       	mov    $0x0,%ebx
  800728:	39 f3                	cmp    %esi,%ebx
  80072a:	73 25                	jae    800751 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80072c:	83 ec 04             	sub    $0x4,%esp
  80072f:	89 f0                	mov    %esi,%eax
  800731:	29 d8                	sub    %ebx,%eax
  800733:	50                   	push   %eax
  800734:	89 d8                	mov    %ebx,%eax
  800736:	03 45 0c             	add    0xc(%ebp),%eax
  800739:	50                   	push   %eax
  80073a:	57                   	push   %edi
  80073b:	e8 4d ff ff ff       	call   80068d <read>
		if (m < 0)
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	85 c0                	test   %eax,%eax
  800745:	78 08                	js     80074f <readn+0x3b>
			return m;
		if (m == 0)
  800747:	85 c0                	test   %eax,%eax
  800749:	74 06                	je     800751 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80074b:	01 c3                	add    %eax,%ebx
  80074d:	eb d9                	jmp    800728 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80074f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800751:	89 d8                	mov    %ebx,%eax
  800753:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800756:	5b                   	pop    %ebx
  800757:	5e                   	pop    %esi
  800758:	5f                   	pop    %edi
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	53                   	push   %ebx
  80075f:	83 ec 14             	sub    $0x14,%esp
  800762:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800765:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800768:	50                   	push   %eax
  800769:	53                   	push   %ebx
  80076a:	e8 ad fc ff ff       	call   80041c <fd_lookup>
  80076f:	83 c4 08             	add    $0x8,%esp
  800772:	85 c0                	test   %eax,%eax
  800774:	78 3a                	js     8007b0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	ff 30                	pushl  (%eax)
  800782:	e8 eb fc ff ff       	call   800472 <dev_lookup>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	85 c0                	test   %eax,%eax
  80078c:	78 22                	js     8007b0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80078e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800791:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800795:	74 1e                	je     8007b5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079a:	8b 52 0c             	mov    0xc(%edx),%edx
  80079d:	85 d2                	test   %edx,%edx
  80079f:	74 35                	je     8007d6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007a1:	83 ec 04             	sub    $0x4,%esp
  8007a4:	ff 75 10             	pushl  0x10(%ebp)
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	ff d2                	call   *%edx
  8007ad:	83 c4 10             	add    $0x10,%esp
}
  8007b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8007ba:	8b 40 48             	mov    0x48(%eax),%eax
  8007bd:	83 ec 04             	sub    $0x4,%esp
  8007c0:	53                   	push   %ebx
  8007c1:	50                   	push   %eax
  8007c2:	68 75 23 80 00       	push   $0x802375
  8007c7:	e8 d5 0d 00 00       	call   8015a1 <cprintf>
		return -E_INVAL;
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d4:	eb da                	jmp    8007b0 <write+0x55>
		return -E_NOT_SUPP;
  8007d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007db:	eb d3                	jmp    8007b0 <write+0x55>

008007dd <seek>:

int
seek(int fdnum, off_t offset)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007e3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 08             	pushl  0x8(%ebp)
  8007ea:	e8 2d fc ff ff       	call   80041c <fd_lookup>
  8007ef:	83 c4 08             	add    $0x8,%esp
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	78 0e                	js     800804 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007fc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800804:	c9                   	leave  
  800805:	c3                   	ret    

00800806 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	53                   	push   %ebx
  80080a:	83 ec 14             	sub    $0x14,%esp
  80080d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800810:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800813:	50                   	push   %eax
  800814:	53                   	push   %ebx
  800815:	e8 02 fc ff ff       	call   80041c <fd_lookup>
  80081a:	83 c4 08             	add    $0x8,%esp
  80081d:	85 c0                	test   %eax,%eax
  80081f:	78 37                	js     800858 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800827:	50                   	push   %eax
  800828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082b:	ff 30                	pushl  (%eax)
  80082d:	e8 40 fc ff ff       	call   800472 <dev_lookup>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	85 c0                	test   %eax,%eax
  800837:	78 1f                	js     800858 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800840:	74 1b                	je     80085d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800845:	8b 52 18             	mov    0x18(%edx),%edx
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 32                	je     80087e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	ff d2                	call   *%edx
  800855:	83 c4 10             	add    $0x10,%esp
}
  800858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80085d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800862:	8b 40 48             	mov    0x48(%eax),%eax
  800865:	83 ec 04             	sub    $0x4,%esp
  800868:	53                   	push   %ebx
  800869:	50                   	push   %eax
  80086a:	68 38 23 80 00       	push   $0x802338
  80086f:	e8 2d 0d 00 00       	call   8015a1 <cprintf>
		return -E_INVAL;
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087c:	eb da                	jmp    800858 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80087e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800883:	eb d3                	jmp    800858 <ftruncate+0x52>

00800885 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 14             	sub    $0x14,%esp
  80088c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80088f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800892:	50                   	push   %eax
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 81 fb ff ff       	call   80041c <fd_lookup>
  80089b:	83 c4 08             	add    $0x8,%esp
  80089e:	85 c0                	test   %eax,%eax
  8008a0:	78 4b                	js     8008ed <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008a8:	50                   	push   %eax
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ac:	ff 30                	pushl  (%eax)
  8008ae:	e8 bf fb ff ff       	call   800472 <dev_lookup>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	78 33                	js     8008ed <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008c1:	74 2f                	je     8008f2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008c3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008c6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008cd:	00 00 00 
	stat->st_isdir = 0;
  8008d0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008d7:	00 00 00 
	stat->st_dev = dev;
  8008da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	53                   	push   %ebx
  8008e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e7:	ff 50 14             	call   *0x14(%eax)
  8008ea:	83 c4 10             	add    $0x10,%esp
}
  8008ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008f7:	eb f4                	jmp    8008ed <fstat+0x68>

008008f9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	56                   	push   %esi
  8008fd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	6a 00                	push   $0x0
  800903:	ff 75 08             	pushl  0x8(%ebp)
  800906:	e8 e7 01 00 00       	call   800af2 <open>
  80090b:	89 c3                	mov    %eax,%ebx
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	85 c0                	test   %eax,%eax
  800912:	78 1b                	js     80092f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	50                   	push   %eax
  80091b:	e8 65 ff ff ff       	call   800885 <fstat>
  800920:	89 c6                	mov    %eax,%esi
	close(fd);
  800922:	89 1c 24             	mov    %ebx,(%esp)
  800925:	e8 27 fc ff ff       	call   800551 <close>
	return r;
  80092a:	83 c4 10             	add    $0x10,%esp
  80092d:	89 f3                	mov    %esi,%ebx
}
  80092f:	89 d8                	mov    %ebx,%eax
  800931:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800934:	5b                   	pop    %ebx
  800935:	5e                   	pop    %esi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	89 c6                	mov    %eax,%esi
  80093f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800941:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800948:	74 27                	je     800971 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80094a:	6a 07                	push   $0x7
  80094c:	68 00 50 80 00       	push   $0x805000
  800951:	56                   	push   %esi
  800952:	ff 35 00 40 80 00    	pushl  0x804000
  800958:	e8 6c 16 00 00       	call   801fc9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80095d:	83 c4 0c             	add    $0xc,%esp
  800960:	6a 00                	push   $0x0
  800962:	53                   	push   %ebx
  800963:	6a 00                	push   $0x0
  800965:	e8 f8 15 00 00       	call   801f62 <ipc_recv>
}
  80096a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800971:	83 ec 0c             	sub    $0xc,%esp
  800974:	6a 01                	push   $0x1
  800976:	e8 a2 16 00 00       	call   80201d <ipc_find_env>
  80097b:	a3 00 40 80 00       	mov    %eax,0x804000
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	eb c5                	jmp    80094a <fsipc+0x12>

00800985 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 40 0c             	mov    0xc(%eax),%eax
  800991:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80099e:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a3:	b8 02 00 00 00       	mov    $0x2,%eax
  8009a8:	e8 8b ff ff ff       	call   800938 <fsipc>
}
  8009ad:	c9                   	leave  
  8009ae:	c3                   	ret    

008009af <devfile_flush>:
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8009bb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	b8 06 00 00 00       	mov    $0x6,%eax
  8009ca:	e8 69 ff ff ff       	call   800938 <fsipc>
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <devfile_stat>:
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	53                   	push   %ebx
  8009d5:	83 ec 04             	sub    $0x4,%esp
  8009d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009eb:	b8 05 00 00 00       	mov    $0x5,%eax
  8009f0:	e8 43 ff ff ff       	call   800938 <fsipc>
  8009f5:	85 c0                	test   %eax,%eax
  8009f7:	78 2c                	js     800a25 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	68 00 50 80 00       	push   $0x805000
  800a01:	53                   	push   %ebx
  800a02:	e8 b9 11 00 00       	call   801bc0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a07:	a1 80 50 80 00       	mov    0x805080,%eax
  800a0c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a12:	a1 84 50 80 00       	mov    0x805084,%eax
  800a17:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a1d:	83 c4 10             	add    $0x10,%esp
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <devfile_write>:
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 0c             	sub    $0xc,%esp
  800a30:	8b 45 10             	mov    0x10(%ebp),%eax
  800a33:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a38:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a3d:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a40:	8b 55 08             	mov    0x8(%ebp),%edx
  800a43:	8b 52 0c             	mov    0xc(%edx),%edx
  800a46:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a4c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a51:	50                   	push   %eax
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	68 08 50 80 00       	push   $0x805008
  800a5a:	e8 ef 12 00 00       	call   801d4e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a64:	b8 04 00 00 00       	mov    $0x4,%eax
  800a69:	e8 ca fe ff ff       	call   800938 <fsipc>
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <devfile_read>:
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	56                   	push   %esi
  800a74:	53                   	push   %ebx
  800a75:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a7e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a83:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a89:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800a93:	e8 a0 fe ff ff       	call   800938 <fsipc>
  800a98:	89 c3                	mov    %eax,%ebx
  800a9a:	85 c0                	test   %eax,%eax
  800a9c:	78 1f                	js     800abd <devfile_read+0x4d>
	assert(r <= n);
  800a9e:	39 f0                	cmp    %esi,%eax
  800aa0:	77 24                	ja     800ac6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aa2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aa7:	7f 33                	jg     800adc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aa9:	83 ec 04             	sub    $0x4,%esp
  800aac:	50                   	push   %eax
  800aad:	68 00 50 80 00       	push   $0x805000
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	e8 94 12 00 00       	call   801d4e <memmove>
	return r;
  800aba:	83 c4 10             	add    $0x10,%esp
}
  800abd:	89 d8                	mov    %ebx,%eax
  800abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    
	assert(r <= n);
  800ac6:	68 a8 23 80 00       	push   $0x8023a8
  800acb:	68 af 23 80 00       	push   $0x8023af
  800ad0:	6a 7b                	push   $0x7b
  800ad2:	68 c4 23 80 00       	push   $0x8023c4
  800ad7:	e8 ea 09 00 00       	call   8014c6 <_panic>
	assert(r <= PGSIZE);
  800adc:	68 cf 23 80 00       	push   $0x8023cf
  800ae1:	68 af 23 80 00       	push   $0x8023af
  800ae6:	6a 7c                	push   $0x7c
  800ae8:	68 c4 23 80 00       	push   $0x8023c4
  800aed:	e8 d4 09 00 00       	call   8014c6 <_panic>

00800af2 <open>:
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
  800af7:	83 ec 1c             	sub    $0x1c,%esp
  800afa:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800afd:	56                   	push   %esi
  800afe:	e8 86 10 00 00       	call   801b89 <strlen>
  800b03:	83 c4 10             	add    $0x10,%esp
  800b06:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b0b:	7f 6c                	jg     800b79 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b0d:	83 ec 0c             	sub    $0xc,%esp
  800b10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b13:	50                   	push   %eax
  800b14:	e8 b4 f8 ff ff       	call   8003cd <fd_alloc>
  800b19:	89 c3                	mov    %eax,%ebx
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	85 c0                	test   %eax,%eax
  800b20:	78 3c                	js     800b5e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	56                   	push   %esi
  800b26:	68 00 50 80 00       	push   $0x805000
  800b2b:	e8 90 10 00 00       	call   801bc0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800b38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b40:	e8 f3 fd ff ff       	call   800938 <fsipc>
  800b45:	89 c3                	mov    %eax,%ebx
  800b47:	83 c4 10             	add    $0x10,%esp
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	78 19                	js     800b67 <open+0x75>
	return fd2num(fd);
  800b4e:	83 ec 0c             	sub    $0xc,%esp
  800b51:	ff 75 f4             	pushl  -0xc(%ebp)
  800b54:	e8 4d f8 ff ff       	call   8003a6 <fd2num>
  800b59:	89 c3                	mov    %eax,%ebx
  800b5b:	83 c4 10             	add    $0x10,%esp
}
  800b5e:	89 d8                	mov    %ebx,%eax
  800b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    
		fd_close(fd, 0);
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	6a 00                	push   $0x0
  800b6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6f:	e8 54 f9 ff ff       	call   8004c8 <fd_close>
		return r;
  800b74:	83 c4 10             	add    $0x10,%esp
  800b77:	eb e5                	jmp    800b5e <open+0x6c>
		return -E_BAD_PATH;
  800b79:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b7e:	eb de                	jmp    800b5e <open+0x6c>

00800b80 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b86:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800b90:	e8 a3 fd ff ff       	call   800938 <fsipc>
}
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b9d:	68 db 23 80 00       	push   $0x8023db
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	e8 16 10 00 00       	call   801bc0 <strcpy>
	return 0;
}
  800baa:	b8 00 00 00 00       	mov    $0x0,%eax
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <devsock_close>:
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	53                   	push   %ebx
  800bb5:	83 ec 10             	sub    $0x10,%esp
  800bb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800bbb:	53                   	push   %ebx
  800bbc:	e8 95 14 00 00       	call   802056 <pageref>
  800bc1:	83 c4 10             	add    $0x10,%esp
		return 0;
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800bc9:	83 f8 01             	cmp    $0x1,%eax
  800bcc:	74 07                	je     800bd5 <devsock_close+0x24>
}
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800bd5:	83 ec 0c             	sub    $0xc,%esp
  800bd8:	ff 73 0c             	pushl  0xc(%ebx)
  800bdb:	e8 b7 02 00 00       	call   800e97 <nsipc_close>
  800be0:	89 c2                	mov    %eax,%edx
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	eb e7                	jmp    800bce <devsock_close+0x1d>

00800be7 <devsock_write>:
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bed:	6a 00                	push   $0x0
  800bef:	ff 75 10             	pushl  0x10(%ebp)
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	ff 70 0c             	pushl  0xc(%eax)
  800bfb:	e8 74 03 00 00       	call   800f74 <nsipc_send>
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <devsock_read>:
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c08:	6a 00                	push   $0x0
  800c0a:	ff 75 10             	pushl  0x10(%ebp)
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	ff 70 0c             	pushl  0xc(%eax)
  800c16:	e8 ed 02 00 00       	call   800f08 <nsipc_recv>
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <fd2sockid>:
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800c23:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800c26:	52                   	push   %edx
  800c27:	50                   	push   %eax
  800c28:	e8 ef f7 ff ff       	call   80041c <fd_lookup>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	85 c0                	test   %eax,%eax
  800c32:	78 10                	js     800c44 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c37:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800c3d:	39 08                	cmp    %ecx,(%eax)
  800c3f:	75 05                	jne    800c46 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c41:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    
		return -E_NOT_SUPP;
  800c46:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c4b:	eb f7                	jmp    800c44 <fd2sockid+0x27>

00800c4d <alloc_sockfd>:
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 1c             	sub    $0x1c,%esp
  800c55:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c5a:	50                   	push   %eax
  800c5b:	e8 6d f7 ff ff       	call   8003cd <fd_alloc>
  800c60:	89 c3                	mov    %eax,%ebx
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	85 c0                	test   %eax,%eax
  800c67:	78 43                	js     800cac <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c69:	83 ec 04             	sub    $0x4,%esp
  800c6c:	68 07 04 00 00       	push   $0x407
  800c71:	ff 75 f4             	pushl  -0xc(%ebp)
  800c74:	6a 00                	push   $0x0
  800c76:	e8 f5 f4 ff ff       	call   800170 <sys_page_alloc>
  800c7b:	89 c3                	mov    %eax,%ebx
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	85 c0                	test   %eax,%eax
  800c82:	78 28                	js     800cac <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c87:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c8d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c92:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c99:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	e8 01 f7 ff ff       	call   8003a6 <fd2num>
  800ca5:	89 c3                	mov    %eax,%ebx
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	eb 0c                	jmp    800cb8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	56                   	push   %esi
  800cb0:	e8 e2 01 00 00       	call   800e97 <nsipc_close>
		return r;
  800cb5:	83 c4 10             	add    $0x10,%esp
}
  800cb8:	89 d8                	mov    %ebx,%eax
  800cba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <accept>:
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	e8 4e ff ff ff       	call   800c1d <fd2sockid>
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	78 1b                	js     800cee <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800cd3:	83 ec 04             	sub    $0x4,%esp
  800cd6:	ff 75 10             	pushl  0x10(%ebp)
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	50                   	push   %eax
  800cdd:	e8 0e 01 00 00       	call   800df0 <nsipc_accept>
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	78 05                	js     800cee <accept+0x2d>
	return alloc_sockfd(r);
  800ce9:	e8 5f ff ff ff       	call   800c4d <alloc_sockfd>
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <bind>:
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	e8 1f ff ff ff       	call   800c1d <fd2sockid>
  800cfe:	85 c0                	test   %eax,%eax
  800d00:	78 12                	js     800d14 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800d02:	83 ec 04             	sub    $0x4,%esp
  800d05:	ff 75 10             	pushl  0x10(%ebp)
  800d08:	ff 75 0c             	pushl  0xc(%ebp)
  800d0b:	50                   	push   %eax
  800d0c:	e8 2f 01 00 00       	call   800e40 <nsipc_bind>
  800d11:	83 c4 10             	add    $0x10,%esp
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <shutdown>:
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	e8 f9 fe ff ff       	call   800c1d <fd2sockid>
  800d24:	85 c0                	test   %eax,%eax
  800d26:	78 0f                	js     800d37 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	e8 41 01 00 00       	call   800e75 <nsipc_shutdown>
  800d34:	83 c4 10             	add    $0x10,%esp
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <connect>:
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	e8 d6 fe ff ff       	call   800c1d <fd2sockid>
  800d47:	85 c0                	test   %eax,%eax
  800d49:	78 12                	js     800d5d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d4b:	83 ec 04             	sub    $0x4,%esp
  800d4e:	ff 75 10             	pushl  0x10(%ebp)
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	50                   	push   %eax
  800d55:	e8 57 01 00 00       	call   800eb1 <nsipc_connect>
  800d5a:	83 c4 10             	add    $0x10,%esp
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <listen>:
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	e8 b0 fe ff ff       	call   800c1d <fd2sockid>
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	78 0f                	js     800d80 <listen+0x21>
	return nsipc_listen(r, backlog);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	50                   	push   %eax
  800d78:	e8 69 01 00 00       	call   800ee6 <nsipc_listen>
  800d7d:	83 c4 10             	add    $0x10,%esp
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <socket>:

int
socket(int domain, int type, int protocol)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d88:	ff 75 10             	pushl  0x10(%ebp)
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	ff 75 08             	pushl  0x8(%ebp)
  800d91:	e8 3c 02 00 00       	call   800fd2 <nsipc_socket>
  800d96:	83 c4 10             	add    $0x10,%esp
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	78 05                	js     800da2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d9d:	e8 ab fe ff ff       	call   800c4d <alloc_sockfd>
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	53                   	push   %ebx
  800da8:	83 ec 04             	sub    $0x4,%esp
  800dab:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800dad:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800db4:	74 26                	je     800ddc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800db6:	6a 07                	push   $0x7
  800db8:	68 00 60 80 00       	push   $0x806000
  800dbd:	53                   	push   %ebx
  800dbe:	ff 35 04 40 80 00    	pushl  0x804004
  800dc4:	e8 00 12 00 00       	call   801fc9 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800dc9:	83 c4 0c             	add    $0xc,%esp
  800dcc:	6a 00                	push   $0x0
  800dce:	6a 00                	push   $0x0
  800dd0:	6a 00                	push   $0x0
  800dd2:	e8 8b 11 00 00       	call   801f62 <ipc_recv>
}
  800dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	6a 02                	push   $0x2
  800de1:	e8 37 12 00 00       	call   80201d <ipc_find_env>
  800de6:	a3 04 40 80 00       	mov    %eax,0x804004
  800deb:	83 c4 10             	add    $0x10,%esp
  800dee:	eb c6                	jmp    800db6 <nsipc+0x12>

00800df0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800e00:	8b 06                	mov    (%esi),%eax
  800e02:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800e07:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0c:	e8 93 ff ff ff       	call   800da4 <nsipc>
  800e11:	89 c3                	mov    %eax,%ebx
  800e13:	85 c0                	test   %eax,%eax
  800e15:	78 20                	js     800e37 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800e17:	83 ec 04             	sub    $0x4,%esp
  800e1a:	ff 35 10 60 80 00    	pushl  0x806010
  800e20:	68 00 60 80 00       	push   $0x806000
  800e25:	ff 75 0c             	pushl  0xc(%ebp)
  800e28:	e8 21 0f 00 00       	call   801d4e <memmove>
		*addrlen = ret->ret_addrlen;
  800e2d:	a1 10 60 80 00       	mov    0x806010,%eax
  800e32:	89 06                	mov    %eax,(%esi)
  800e34:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800e37:	89 d8                	mov    %ebx,%eax
  800e39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	53                   	push   %ebx
  800e44:	83 ec 08             	sub    $0x8,%esp
  800e47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e52:	53                   	push   %ebx
  800e53:	ff 75 0c             	pushl  0xc(%ebp)
  800e56:	68 04 60 80 00       	push   $0x806004
  800e5b:	e8 ee 0e 00 00       	call   801d4e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e60:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e66:	b8 02 00 00 00       	mov    $0x2,%eax
  800e6b:	e8 34 ff ff ff       	call   800da4 <nsipc>
}
  800e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e73:	c9                   	leave  
  800e74:	c3                   	ret    

00800e75 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e86:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e90:	e8 0f ff ff ff       	call   800da4 <nsipc>
}
  800e95:	c9                   	leave  
  800e96:	c3                   	ret    

00800e97 <nsipc_close>:

int
nsipc_close(int s)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800ea5:	b8 04 00 00 00       	mov    $0x4,%eax
  800eaa:	e8 f5 fe ff ff       	call   800da4 <nsipc>
}
  800eaf:	c9                   	leave  
  800eb0:	c3                   	ret    

00800eb1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	53                   	push   %ebx
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800ec3:	53                   	push   %ebx
  800ec4:	ff 75 0c             	pushl  0xc(%ebp)
  800ec7:	68 04 60 80 00       	push   $0x806004
  800ecc:	e8 7d 0e 00 00       	call   801d4e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800ed1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800ed7:	b8 05 00 00 00       	mov    $0x5,%eax
  800edc:	e8 c3 fe ff ff       	call   800da4 <nsipc>
}
  800ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800efc:	b8 06 00 00 00       	mov    $0x6,%eax
  800f01:	e8 9e fe ff ff       	call   800da4 <nsipc>
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800f18:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800f1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f21:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800f26:	b8 07 00 00 00       	mov    $0x7,%eax
  800f2b:	e8 74 fe ff ff       	call   800da4 <nsipc>
  800f30:	89 c3                	mov    %eax,%ebx
  800f32:	85 c0                	test   %eax,%eax
  800f34:	78 1f                	js     800f55 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800f36:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800f3b:	7f 21                	jg     800f5e <nsipc_recv+0x56>
  800f3d:	39 c6                	cmp    %eax,%esi
  800f3f:	7c 1d                	jl     800f5e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f41:	83 ec 04             	sub    $0x4,%esp
  800f44:	50                   	push   %eax
  800f45:	68 00 60 80 00       	push   $0x806000
  800f4a:	ff 75 0c             	pushl  0xc(%ebp)
  800f4d:	e8 fc 0d 00 00       	call   801d4e <memmove>
  800f52:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f55:	89 d8                	mov    %ebx,%eax
  800f57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f5e:	68 e7 23 80 00       	push   $0x8023e7
  800f63:	68 af 23 80 00       	push   $0x8023af
  800f68:	6a 62                	push   $0x62
  800f6a:	68 fc 23 80 00       	push   $0x8023fc
  800f6f:	e8 52 05 00 00       	call   8014c6 <_panic>

00800f74 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	53                   	push   %ebx
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f86:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f8c:	7f 2e                	jg     800fbc <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f8e:	83 ec 04             	sub    $0x4,%esp
  800f91:	53                   	push   %ebx
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	68 0c 60 80 00       	push   $0x80600c
  800f9a:	e8 af 0d 00 00       	call   801d4e <memmove>
	nsipcbuf.send.req_size = size;
  800f9f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800fad:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb2:	e8 ed fd ff ff       	call   800da4 <nsipc>
}
  800fb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    
	assert(size < 1600);
  800fbc:	68 08 24 80 00       	push   $0x802408
  800fc1:	68 af 23 80 00       	push   $0x8023af
  800fc6:	6a 6d                	push   $0x6d
  800fc8:	68 fc 23 80 00       	push   $0x8023fc
  800fcd:	e8 f4 04 00 00       	call   8014c6 <_panic>

00800fd2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800ff0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ff5:	e8 aa fd ff ff       	call   800da4 <nsipc>
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
  801001:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	ff 75 08             	pushl  0x8(%ebp)
  80100a:	e8 a7 f3 ff ff       	call   8003b6 <fd2data>
  80100f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801011:	83 c4 08             	add    $0x8,%esp
  801014:	68 14 24 80 00       	push   $0x802414
  801019:	53                   	push   %ebx
  80101a:	e8 a1 0b 00 00       	call   801bc0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80101f:	8b 46 04             	mov    0x4(%esi),%eax
  801022:	2b 06                	sub    (%esi),%eax
  801024:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80102a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801031:	00 00 00 
	stat->st_dev = &devpipe;
  801034:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80103b:	30 80 00 
	return 0;
}
  80103e:	b8 00 00 00 00       	mov    $0x0,%eax
  801043:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	53                   	push   %ebx
  80104e:	83 ec 0c             	sub    $0xc,%esp
  801051:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801054:	53                   	push   %ebx
  801055:	6a 00                	push   $0x0
  801057:	e8 99 f1 ff ff       	call   8001f5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80105c:	89 1c 24             	mov    %ebx,(%esp)
  80105f:	e8 52 f3 ff ff       	call   8003b6 <fd2data>
  801064:	83 c4 08             	add    $0x8,%esp
  801067:	50                   	push   %eax
  801068:	6a 00                	push   $0x0
  80106a:	e8 86 f1 ff ff       	call   8001f5 <sys_page_unmap>
}
  80106f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <_pipeisclosed>:
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	57                   	push   %edi
  801078:	56                   	push   %esi
  801079:	53                   	push   %ebx
  80107a:	83 ec 1c             	sub    $0x1c,%esp
  80107d:	89 c7                	mov    %eax,%edi
  80107f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801081:	a1 08 40 80 00       	mov    0x804008,%eax
  801086:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801089:	83 ec 0c             	sub    $0xc,%esp
  80108c:	57                   	push   %edi
  80108d:	e8 c4 0f 00 00       	call   802056 <pageref>
  801092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801095:	89 34 24             	mov    %esi,(%esp)
  801098:	e8 b9 0f 00 00       	call   802056 <pageref>
		nn = thisenv->env_runs;
  80109d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8010a3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	39 cb                	cmp    %ecx,%ebx
  8010ab:	74 1b                	je     8010c8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8010ad:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010b0:	75 cf                	jne    801081 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8010b2:	8b 42 58             	mov    0x58(%edx),%eax
  8010b5:	6a 01                	push   $0x1
  8010b7:	50                   	push   %eax
  8010b8:	53                   	push   %ebx
  8010b9:	68 1b 24 80 00       	push   $0x80241b
  8010be:	e8 de 04 00 00       	call   8015a1 <cprintf>
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	eb b9                	jmp    801081 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8010c8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010cb:	0f 94 c0             	sete   %al
  8010ce:	0f b6 c0             	movzbl %al,%eax
}
  8010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <devpipe_write>:
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 28             	sub    $0x28,%esp
  8010e2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010e5:	56                   	push   %esi
  8010e6:	e8 cb f2 ff ff       	call   8003b6 <fd2data>
  8010eb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8010f5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010f8:	74 4f                	je     801149 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010fa:	8b 43 04             	mov    0x4(%ebx),%eax
  8010fd:	8b 0b                	mov    (%ebx),%ecx
  8010ff:	8d 51 20             	lea    0x20(%ecx),%edx
  801102:	39 d0                	cmp    %edx,%eax
  801104:	72 14                	jb     80111a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801106:	89 da                	mov    %ebx,%edx
  801108:	89 f0                	mov    %esi,%eax
  80110a:	e8 65 ff ff ff       	call   801074 <_pipeisclosed>
  80110f:	85 c0                	test   %eax,%eax
  801111:	75 3a                	jne    80114d <devpipe_write+0x74>
			sys_yield();
  801113:	e8 39 f0 ff ff       	call   800151 <sys_yield>
  801118:	eb e0                	jmp    8010fa <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80111a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801121:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801124:	89 c2                	mov    %eax,%edx
  801126:	c1 fa 1f             	sar    $0x1f,%edx
  801129:	89 d1                	mov    %edx,%ecx
  80112b:	c1 e9 1b             	shr    $0x1b,%ecx
  80112e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801131:	83 e2 1f             	and    $0x1f,%edx
  801134:	29 ca                	sub    %ecx,%edx
  801136:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80113a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80113e:	83 c0 01             	add    $0x1,%eax
  801141:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801144:	83 c7 01             	add    $0x1,%edi
  801147:	eb ac                	jmp    8010f5 <devpipe_write+0x1c>
	return i;
  801149:	89 f8                	mov    %edi,%eax
  80114b:	eb 05                	jmp    801152 <devpipe_write+0x79>
				return 0;
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801152:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <devpipe_read>:
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	57                   	push   %edi
  80115e:	56                   	push   %esi
  80115f:	53                   	push   %ebx
  801160:	83 ec 18             	sub    $0x18,%esp
  801163:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801166:	57                   	push   %edi
  801167:	e8 4a f2 ff ff       	call   8003b6 <fd2data>
  80116c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	be 00 00 00 00       	mov    $0x0,%esi
  801176:	3b 75 10             	cmp    0x10(%ebp),%esi
  801179:	74 47                	je     8011c2 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80117b:	8b 03                	mov    (%ebx),%eax
  80117d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801180:	75 22                	jne    8011a4 <devpipe_read+0x4a>
			if (i > 0)
  801182:	85 f6                	test   %esi,%esi
  801184:	75 14                	jne    80119a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801186:	89 da                	mov    %ebx,%edx
  801188:	89 f8                	mov    %edi,%eax
  80118a:	e8 e5 fe ff ff       	call   801074 <_pipeisclosed>
  80118f:	85 c0                	test   %eax,%eax
  801191:	75 33                	jne    8011c6 <devpipe_read+0x6c>
			sys_yield();
  801193:	e8 b9 ef ff ff       	call   800151 <sys_yield>
  801198:	eb e1                	jmp    80117b <devpipe_read+0x21>
				return i;
  80119a:	89 f0                	mov    %esi,%eax
}
  80119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5f                   	pop    %edi
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8011a4:	99                   	cltd   
  8011a5:	c1 ea 1b             	shr    $0x1b,%edx
  8011a8:	01 d0                	add    %edx,%eax
  8011aa:	83 e0 1f             	and    $0x1f,%eax
  8011ad:	29 d0                	sub    %edx,%eax
  8011af:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8011b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8011ba:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8011bd:	83 c6 01             	add    $0x1,%esi
  8011c0:	eb b4                	jmp    801176 <devpipe_read+0x1c>
	return i;
  8011c2:	89 f0                	mov    %esi,%eax
  8011c4:	eb d6                	jmp    80119c <devpipe_read+0x42>
				return 0;
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	eb cf                	jmp    80119c <devpipe_read+0x42>

008011cd <pipe>:
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	56                   	push   %esi
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d8:	50                   	push   %eax
  8011d9:	e8 ef f1 ff ff       	call   8003cd <fd_alloc>
  8011de:	89 c3                	mov    %eax,%ebx
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	78 5b                	js     801242 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011e7:	83 ec 04             	sub    $0x4,%esp
  8011ea:	68 07 04 00 00       	push   $0x407
  8011ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f2:	6a 00                	push   $0x0
  8011f4:	e8 77 ef ff ff       	call   800170 <sys_page_alloc>
  8011f9:	89 c3                	mov    %eax,%ebx
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	78 40                	js     801242 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801208:	50                   	push   %eax
  801209:	e8 bf f1 ff ff       	call   8003cd <fd_alloc>
  80120e:	89 c3                	mov    %eax,%ebx
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	78 1b                	js     801232 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	68 07 04 00 00       	push   $0x407
  80121f:	ff 75 f0             	pushl  -0x10(%ebp)
  801222:	6a 00                	push   $0x0
  801224:	e8 47 ef ff ff       	call   800170 <sys_page_alloc>
  801229:	89 c3                	mov    %eax,%ebx
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	79 19                	jns    80124b <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	6a 00                	push   $0x0
  80123a:	e8 b6 ef ff ff       	call   8001f5 <sys_page_unmap>
  80123f:	83 c4 10             	add    $0x10,%esp
}
  801242:	89 d8                	mov    %ebx,%eax
  801244:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    
	va = fd2data(fd0);
  80124b:	83 ec 0c             	sub    $0xc,%esp
  80124e:	ff 75 f4             	pushl  -0xc(%ebp)
  801251:	e8 60 f1 ff ff       	call   8003b6 <fd2data>
  801256:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801258:	83 c4 0c             	add    $0xc,%esp
  80125b:	68 07 04 00 00       	push   $0x407
  801260:	50                   	push   %eax
  801261:	6a 00                	push   $0x0
  801263:	e8 08 ef ff ff       	call   800170 <sys_page_alloc>
  801268:	89 c3                	mov    %eax,%ebx
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	0f 88 8c 00 00 00    	js     801301 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801275:	83 ec 0c             	sub    $0xc,%esp
  801278:	ff 75 f0             	pushl  -0x10(%ebp)
  80127b:	e8 36 f1 ff ff       	call   8003b6 <fd2data>
  801280:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801287:	50                   	push   %eax
  801288:	6a 00                	push   $0x0
  80128a:	56                   	push   %esi
  80128b:	6a 00                	push   $0x0
  80128d:	e8 21 ef ff ff       	call   8001b3 <sys_page_map>
  801292:	89 c3                	mov    %eax,%ebx
  801294:	83 c4 20             	add    $0x20,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	78 58                	js     8012f3 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80129b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8012a4:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8012a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8012b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8012b9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8012bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012be:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8012cb:	e8 d6 f0 ff ff       	call   8003a6 <fd2num>
  8012d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8012d5:	83 c4 04             	add    $0x4,%esp
  8012d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012db:	e8 c6 f0 ff ff       	call   8003a6 <fd2num>
  8012e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012e6:	83 c4 10             	add    $0x10,%esp
  8012e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ee:	e9 4f ff ff ff       	jmp    801242 <pipe+0x75>
	sys_page_unmap(0, va);
  8012f3:	83 ec 08             	sub    $0x8,%esp
  8012f6:	56                   	push   %esi
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 f7 ee ff ff       	call   8001f5 <sys_page_unmap>
  8012fe:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	ff 75 f0             	pushl  -0x10(%ebp)
  801307:	6a 00                	push   $0x0
  801309:	e8 e7 ee ff ff       	call   8001f5 <sys_page_unmap>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	e9 1c ff ff ff       	jmp    801232 <pipe+0x65>

00801316 <pipeisclosed>:
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80131c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 08             	pushl  0x8(%ebp)
  801323:	e8 f4 f0 ff ff       	call   80041c <fd_lookup>
  801328:	83 c4 10             	add    $0x10,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	78 18                	js     801347 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80132f:	83 ec 0c             	sub    $0xc,%esp
  801332:	ff 75 f4             	pushl  -0xc(%ebp)
  801335:	e8 7c f0 ff ff       	call   8003b6 <fd2data>
	return _pipeisclosed(fd, p);
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133f:	e8 30 fd ff ff       	call   801074 <_pipeisclosed>
  801344:	83 c4 10             	add    $0x10,%esp
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80134c:	b8 00 00 00 00       	mov    $0x0,%eax
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    

00801353 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801359:	68 33 24 80 00       	push   $0x802433
  80135e:	ff 75 0c             	pushl  0xc(%ebp)
  801361:	e8 5a 08 00 00       	call   801bc0 <strcpy>
	return 0;
}
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <devcons_write>:
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801379:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80137e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801384:	eb 2f                	jmp    8013b5 <devcons_write+0x48>
		m = n - tot;
  801386:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801389:	29 f3                	sub    %esi,%ebx
  80138b:	83 fb 7f             	cmp    $0x7f,%ebx
  80138e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801393:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	53                   	push   %ebx
  80139a:	89 f0                	mov    %esi,%eax
  80139c:	03 45 0c             	add    0xc(%ebp),%eax
  80139f:	50                   	push   %eax
  8013a0:	57                   	push   %edi
  8013a1:	e8 a8 09 00 00       	call   801d4e <memmove>
		sys_cputs(buf, m);
  8013a6:	83 c4 08             	add    $0x8,%esp
  8013a9:	53                   	push   %ebx
  8013aa:	57                   	push   %edi
  8013ab:	e8 04 ed ff ff       	call   8000b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013b0:	01 de                	add    %ebx,%esi
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013b8:	72 cc                	jb     801386 <devcons_write+0x19>
}
  8013ba:	89 f0                	mov    %esi,%eax
  8013bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013bf:	5b                   	pop    %ebx
  8013c0:	5e                   	pop    %esi
  8013c1:	5f                   	pop    %edi
  8013c2:	5d                   	pop    %ebp
  8013c3:	c3                   	ret    

008013c4 <devcons_read>:
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d3:	75 07                	jne    8013dc <devcons_read+0x18>
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    
		sys_yield();
  8013d7:	e8 75 ed ff ff       	call   800151 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013dc:	e8 f1 ec ff ff       	call   8000d2 <sys_cgetc>
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	74 f2                	je     8013d7 <devcons_read+0x13>
	if (c < 0)
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 ec                	js     8013d5 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013e9:	83 f8 04             	cmp    $0x4,%eax
  8013ec:	74 0c                	je     8013fa <devcons_read+0x36>
	*(char*)vbuf = c;
  8013ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f1:	88 02                	mov    %al,(%edx)
	return 1;
  8013f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8013f8:	eb db                	jmp    8013d5 <devcons_read+0x11>
		return 0;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ff:	eb d4                	jmp    8013d5 <devcons_read+0x11>

00801401 <cputchar>:
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80140d:	6a 01                	push   $0x1
  80140f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	e8 9c ec ff ff       	call   8000b4 <sys_cputs>
}
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <getchar>:
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801423:	6a 01                	push   $0x1
  801425:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801428:	50                   	push   %eax
  801429:	6a 00                	push   $0x0
  80142b:	e8 5d f2 ff ff       	call   80068d <read>
	if (r < 0)
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 08                	js     80143f <getchar+0x22>
	if (r < 1)
  801437:	85 c0                	test   %eax,%eax
  801439:	7e 06                	jle    801441 <getchar+0x24>
	return c;
  80143b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    
		return -E_EOF;
  801441:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801446:	eb f7                	jmp    80143f <getchar+0x22>

00801448 <iscons>:
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	ff 75 08             	pushl  0x8(%ebp)
  801455:	e8 c2 ef ff ff       	call   80041c <fd_lookup>
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 11                	js     801472 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80146a:	39 10                	cmp    %edx,(%eax)
  80146c:	0f 94 c0             	sete   %al
  80146f:	0f b6 c0             	movzbl %al,%eax
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <opencons>:
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80147a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147d:	50                   	push   %eax
  80147e:	e8 4a ef ff ff       	call   8003cd <fd_alloc>
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	78 3a                	js     8014c4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	68 07 04 00 00       	push   $0x407
  801492:	ff 75 f4             	pushl  -0xc(%ebp)
  801495:	6a 00                	push   $0x0
  801497:	e8 d4 ec ff ff       	call   800170 <sys_page_alloc>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 21                	js     8014c4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014b8:	83 ec 0c             	sub    $0xc,%esp
  8014bb:	50                   	push   %eax
  8014bc:	e8 e5 ee ff ff       	call   8003a6 <fd2num>
  8014c1:	83 c4 10             	add    $0x10,%esp
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014cb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014ce:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014d4:	e8 59 ec ff ff       	call   800132 <sys_getenvid>
  8014d9:	83 ec 0c             	sub    $0xc,%esp
  8014dc:	ff 75 0c             	pushl  0xc(%ebp)
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	56                   	push   %esi
  8014e3:	50                   	push   %eax
  8014e4:	68 40 24 80 00       	push   $0x802440
  8014e9:	e8 b3 00 00 00       	call   8015a1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ee:	83 c4 18             	add    $0x18,%esp
  8014f1:	53                   	push   %ebx
  8014f2:	ff 75 10             	pushl  0x10(%ebp)
  8014f5:	e8 56 00 00 00       	call   801550 <vcprintf>
	cprintf("\n");
  8014fa:	c7 04 24 2c 24 80 00 	movl   $0x80242c,(%esp)
  801501:	e8 9b 00 00 00       	call   8015a1 <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801509:	cc                   	int3   
  80150a:	eb fd                	jmp    801509 <_panic+0x43>

0080150c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	53                   	push   %ebx
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801516:	8b 13                	mov    (%ebx),%edx
  801518:	8d 42 01             	lea    0x1(%edx),%eax
  80151b:	89 03                	mov    %eax,(%ebx)
  80151d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801520:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801524:	3d ff 00 00 00       	cmp    $0xff,%eax
  801529:	74 09                	je     801534 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80152b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80152f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801532:	c9                   	leave  
  801533:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801534:	83 ec 08             	sub    $0x8,%esp
  801537:	68 ff 00 00 00       	push   $0xff
  80153c:	8d 43 08             	lea    0x8(%ebx),%eax
  80153f:	50                   	push   %eax
  801540:	e8 6f eb ff ff       	call   8000b4 <sys_cputs>
		b->idx = 0;
  801545:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	eb db                	jmp    80152b <putch+0x1f>

00801550 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801559:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801560:	00 00 00 
	b.cnt = 0;
  801563:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80156a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	ff 75 08             	pushl  0x8(%ebp)
  801573:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801579:	50                   	push   %eax
  80157a:	68 0c 15 80 00       	push   $0x80150c
  80157f:	e8 1a 01 00 00       	call   80169e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801584:	83 c4 08             	add    $0x8,%esp
  801587:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80158d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801593:	50                   	push   %eax
  801594:	e8 1b eb ff ff       	call   8000b4 <sys_cputs>

	return b.cnt;
}
  801599:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015a7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015aa:	50                   	push   %eax
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 9d ff ff ff       	call   801550 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	57                   	push   %edi
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
  8015bb:	83 ec 1c             	sub    $0x1c,%esp
  8015be:	89 c7                	mov    %eax,%edi
  8015c0:	89 d6                	mov    %edx,%esi
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015dc:	39 d3                	cmp    %edx,%ebx
  8015de:	72 05                	jb     8015e5 <printnum+0x30>
  8015e0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015e3:	77 7a                	ja     80165f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	83 ec 0c             	sub    $0xc,%esp
  8015e8:	ff 75 18             	pushl  0x18(%ebp)
  8015eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015f1:	53                   	push   %ebx
  8015f2:	ff 75 10             	pushl  0x10(%ebp)
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8015fe:	ff 75 dc             	pushl  -0x24(%ebp)
  801601:	ff 75 d8             	pushl  -0x28(%ebp)
  801604:	e8 97 0a 00 00       	call   8020a0 <__udivdi3>
  801609:	83 c4 18             	add    $0x18,%esp
  80160c:	52                   	push   %edx
  80160d:	50                   	push   %eax
  80160e:	89 f2                	mov    %esi,%edx
  801610:	89 f8                	mov    %edi,%eax
  801612:	e8 9e ff ff ff       	call   8015b5 <printnum>
  801617:	83 c4 20             	add    $0x20,%esp
  80161a:	eb 13                	jmp    80162f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	56                   	push   %esi
  801620:	ff 75 18             	pushl  0x18(%ebp)
  801623:	ff d7                	call   *%edi
  801625:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801628:	83 eb 01             	sub    $0x1,%ebx
  80162b:	85 db                	test   %ebx,%ebx
  80162d:	7f ed                	jg     80161c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	56                   	push   %esi
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	ff 75 e4             	pushl  -0x1c(%ebp)
  801639:	ff 75 e0             	pushl  -0x20(%ebp)
  80163c:	ff 75 dc             	pushl  -0x24(%ebp)
  80163f:	ff 75 d8             	pushl  -0x28(%ebp)
  801642:	e8 79 0b 00 00       	call   8021c0 <__umoddi3>
  801647:	83 c4 14             	add    $0x14,%esp
  80164a:	0f be 80 63 24 80 00 	movsbl 0x802463(%eax),%eax
  801651:	50                   	push   %eax
  801652:	ff d7                	call   *%edi
}
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165a:	5b                   	pop    %ebx
  80165b:	5e                   	pop    %esi
  80165c:	5f                   	pop    %edi
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    
  80165f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801662:	eb c4                	jmp    801628 <printnum+0x73>

00801664 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80166a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80166e:	8b 10                	mov    (%eax),%edx
  801670:	3b 50 04             	cmp    0x4(%eax),%edx
  801673:	73 0a                	jae    80167f <sprintputch+0x1b>
		*b->buf++ = ch;
  801675:	8d 4a 01             	lea    0x1(%edx),%ecx
  801678:	89 08                	mov    %ecx,(%eax)
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	88 02                	mov    %al,(%edx)
}
  80167f:	5d                   	pop    %ebp
  801680:	c3                   	ret    

00801681 <printfmt>:
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801687:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80168a:	50                   	push   %eax
  80168b:	ff 75 10             	pushl  0x10(%ebp)
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	e8 05 00 00 00       	call   80169e <vprintfmt>
}
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <vprintfmt>:
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	57                   	push   %edi
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 2c             	sub    $0x2c,%esp
  8016a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8016aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ad:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016b0:	e9 c1 03 00 00       	jmp    801a76 <vprintfmt+0x3d8>
		padc = ' ';
  8016b5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016b9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016c0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016ce:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016d3:	8d 47 01             	lea    0x1(%edi),%eax
  8016d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016d9:	0f b6 17             	movzbl (%edi),%edx
  8016dc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016df:	3c 55                	cmp    $0x55,%al
  8016e1:	0f 87 12 04 00 00    	ja     801af9 <vprintfmt+0x45b>
  8016e7:	0f b6 c0             	movzbl %al,%eax
  8016ea:	ff 24 85 a0 25 80 00 	jmp    *0x8025a0(,%eax,4)
  8016f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016f4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016f8:	eb d9                	jmp    8016d3 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016fd:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801701:	eb d0                	jmp    8016d3 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801703:	0f b6 d2             	movzbl %dl,%edx
  801706:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
  80170e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801711:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801714:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801718:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80171b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80171e:	83 f9 09             	cmp    $0x9,%ecx
  801721:	77 55                	ja     801778 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801723:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801726:	eb e9                	jmp    801711 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801728:	8b 45 14             	mov    0x14(%ebp),%eax
  80172b:	8b 00                	mov    (%eax),%eax
  80172d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801730:	8b 45 14             	mov    0x14(%ebp),%eax
  801733:	8d 40 04             	lea    0x4(%eax),%eax
  801736:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80173c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801740:	79 91                	jns    8016d3 <vprintfmt+0x35>
				width = precision, precision = -1;
  801742:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801745:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801748:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80174f:	eb 82                	jmp    8016d3 <vprintfmt+0x35>
  801751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801754:	85 c0                	test   %eax,%eax
  801756:	ba 00 00 00 00       	mov    $0x0,%edx
  80175b:	0f 49 d0             	cmovns %eax,%edx
  80175e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801764:	e9 6a ff ff ff       	jmp    8016d3 <vprintfmt+0x35>
  801769:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80176c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801773:	e9 5b ff ff ff       	jmp    8016d3 <vprintfmt+0x35>
  801778:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80177b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80177e:	eb bc                	jmp    80173c <vprintfmt+0x9e>
			lflag++;
  801780:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801783:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801786:	e9 48 ff ff ff       	jmp    8016d3 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80178b:	8b 45 14             	mov    0x14(%ebp),%eax
  80178e:	8d 78 04             	lea    0x4(%eax),%edi
  801791:	83 ec 08             	sub    $0x8,%esp
  801794:	53                   	push   %ebx
  801795:	ff 30                	pushl  (%eax)
  801797:	ff d6                	call   *%esi
			break;
  801799:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80179c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80179f:	e9 cf 02 00 00       	jmp    801a73 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8017a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a7:	8d 78 04             	lea    0x4(%eax),%edi
  8017aa:	8b 00                	mov    (%eax),%eax
  8017ac:	99                   	cltd   
  8017ad:	31 d0                	xor    %edx,%eax
  8017af:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017b1:	83 f8 0f             	cmp    $0xf,%eax
  8017b4:	7f 23                	jg     8017d9 <vprintfmt+0x13b>
  8017b6:	8b 14 85 00 27 80 00 	mov    0x802700(,%eax,4),%edx
  8017bd:	85 d2                	test   %edx,%edx
  8017bf:	74 18                	je     8017d9 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017c1:	52                   	push   %edx
  8017c2:	68 c1 23 80 00       	push   $0x8023c1
  8017c7:	53                   	push   %ebx
  8017c8:	56                   	push   %esi
  8017c9:	e8 b3 fe ff ff       	call   801681 <printfmt>
  8017ce:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017d1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017d4:	e9 9a 02 00 00       	jmp    801a73 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8017d9:	50                   	push   %eax
  8017da:	68 7b 24 80 00       	push   $0x80247b
  8017df:	53                   	push   %ebx
  8017e0:	56                   	push   %esi
  8017e1:	e8 9b fe ff ff       	call   801681 <printfmt>
  8017e6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017e9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017ec:	e9 82 02 00 00       	jmp    801a73 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f4:	83 c0 04             	add    $0x4,%eax
  8017f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fd:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017ff:	85 ff                	test   %edi,%edi
  801801:	b8 74 24 80 00       	mov    $0x802474,%eax
  801806:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801809:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80180d:	0f 8e bd 00 00 00    	jle    8018d0 <vprintfmt+0x232>
  801813:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801817:	75 0e                	jne    801827 <vprintfmt+0x189>
  801819:	89 75 08             	mov    %esi,0x8(%ebp)
  80181c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80181f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801822:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801825:	eb 6d                	jmp    801894 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801827:	83 ec 08             	sub    $0x8,%esp
  80182a:	ff 75 d0             	pushl  -0x30(%ebp)
  80182d:	57                   	push   %edi
  80182e:	e8 6e 03 00 00       	call   801ba1 <strnlen>
  801833:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801836:	29 c1                	sub    %eax,%ecx
  801838:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80183b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80183e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801842:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801845:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801848:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80184a:	eb 0f                	jmp    80185b <vprintfmt+0x1bd>
					putch(padc, putdat);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	53                   	push   %ebx
  801850:	ff 75 e0             	pushl  -0x20(%ebp)
  801853:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801855:	83 ef 01             	sub    $0x1,%edi
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 ff                	test   %edi,%edi
  80185d:	7f ed                	jg     80184c <vprintfmt+0x1ae>
  80185f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801862:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801865:	85 c9                	test   %ecx,%ecx
  801867:	b8 00 00 00 00       	mov    $0x0,%eax
  80186c:	0f 49 c1             	cmovns %ecx,%eax
  80186f:	29 c1                	sub    %eax,%ecx
  801871:	89 75 08             	mov    %esi,0x8(%ebp)
  801874:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801877:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80187a:	89 cb                	mov    %ecx,%ebx
  80187c:	eb 16                	jmp    801894 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80187e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801882:	75 31                	jne    8018b5 <vprintfmt+0x217>
					putch(ch, putdat);
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	ff 55 08             	call   *0x8(%ebp)
  80188e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801891:	83 eb 01             	sub    $0x1,%ebx
  801894:	83 c7 01             	add    $0x1,%edi
  801897:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80189b:	0f be c2             	movsbl %dl,%eax
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	74 59                	je     8018fb <vprintfmt+0x25d>
  8018a2:	85 f6                	test   %esi,%esi
  8018a4:	78 d8                	js     80187e <vprintfmt+0x1e0>
  8018a6:	83 ee 01             	sub    $0x1,%esi
  8018a9:	79 d3                	jns    80187e <vprintfmt+0x1e0>
  8018ab:	89 df                	mov    %ebx,%edi
  8018ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8018b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018b3:	eb 37                	jmp    8018ec <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018b5:	0f be d2             	movsbl %dl,%edx
  8018b8:	83 ea 20             	sub    $0x20,%edx
  8018bb:	83 fa 5e             	cmp    $0x5e,%edx
  8018be:	76 c4                	jbe    801884 <vprintfmt+0x1e6>
					putch('?', putdat);
  8018c0:	83 ec 08             	sub    $0x8,%esp
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	6a 3f                	push   $0x3f
  8018c8:	ff 55 08             	call   *0x8(%ebp)
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	eb c1                	jmp    801891 <vprintfmt+0x1f3>
  8018d0:	89 75 08             	mov    %esi,0x8(%ebp)
  8018d3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018d6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018d9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018dc:	eb b6                	jmp    801894 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	53                   	push   %ebx
  8018e2:	6a 20                	push   $0x20
  8018e4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018e6:	83 ef 01             	sub    $0x1,%edi
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 ff                	test   %edi,%edi
  8018ee:	7f ee                	jg     8018de <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f6:	e9 78 01 00 00       	jmp    801a73 <vprintfmt+0x3d5>
  8018fb:	89 df                	mov    %ebx,%edi
  8018fd:	8b 75 08             	mov    0x8(%ebp),%esi
  801900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801903:	eb e7                	jmp    8018ec <vprintfmt+0x24e>
	if (lflag >= 2)
  801905:	83 f9 01             	cmp    $0x1,%ecx
  801908:	7e 3f                	jle    801949 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80190a:	8b 45 14             	mov    0x14(%ebp),%eax
  80190d:	8b 50 04             	mov    0x4(%eax),%edx
  801910:	8b 00                	mov    (%eax),%eax
  801912:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801915:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801918:	8b 45 14             	mov    0x14(%ebp),%eax
  80191b:	8d 40 08             	lea    0x8(%eax),%eax
  80191e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801921:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801925:	79 5c                	jns    801983 <vprintfmt+0x2e5>
				putch('-', putdat);
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	53                   	push   %ebx
  80192b:	6a 2d                	push   $0x2d
  80192d:	ff d6                	call   *%esi
				num = -(long long) num;
  80192f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801932:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801935:	f7 da                	neg    %edx
  801937:	83 d1 00             	adc    $0x0,%ecx
  80193a:	f7 d9                	neg    %ecx
  80193c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80193f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801944:	e9 10 01 00 00       	jmp    801a59 <vprintfmt+0x3bb>
	else if (lflag)
  801949:	85 c9                	test   %ecx,%ecx
  80194b:	75 1b                	jne    801968 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80194d:	8b 45 14             	mov    0x14(%ebp),%eax
  801950:	8b 00                	mov    (%eax),%eax
  801952:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801955:	89 c1                	mov    %eax,%ecx
  801957:	c1 f9 1f             	sar    $0x1f,%ecx
  80195a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80195d:	8b 45 14             	mov    0x14(%ebp),%eax
  801960:	8d 40 04             	lea    0x4(%eax),%eax
  801963:	89 45 14             	mov    %eax,0x14(%ebp)
  801966:	eb b9                	jmp    801921 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801968:	8b 45 14             	mov    0x14(%ebp),%eax
  80196b:	8b 00                	mov    (%eax),%eax
  80196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801970:	89 c1                	mov    %eax,%ecx
  801972:	c1 f9 1f             	sar    $0x1f,%ecx
  801975:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801978:	8b 45 14             	mov    0x14(%ebp),%eax
  80197b:	8d 40 04             	lea    0x4(%eax),%eax
  80197e:	89 45 14             	mov    %eax,0x14(%ebp)
  801981:	eb 9e                	jmp    801921 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801983:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801986:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801989:	b8 0a 00 00 00       	mov    $0xa,%eax
  80198e:	e9 c6 00 00 00       	jmp    801a59 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801993:	83 f9 01             	cmp    $0x1,%ecx
  801996:	7e 18                	jle    8019b0 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801998:	8b 45 14             	mov    0x14(%ebp),%eax
  80199b:	8b 10                	mov    (%eax),%edx
  80199d:	8b 48 04             	mov    0x4(%eax),%ecx
  8019a0:	8d 40 08             	lea    0x8(%eax),%eax
  8019a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019ab:	e9 a9 00 00 00       	jmp    801a59 <vprintfmt+0x3bb>
	else if (lflag)
  8019b0:	85 c9                	test   %ecx,%ecx
  8019b2:	75 1a                	jne    8019ce <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8019b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b7:	8b 10                	mov    (%eax),%edx
  8019b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019be:	8d 40 04             	lea    0x4(%eax),%eax
  8019c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019c9:	e9 8b 00 00 00       	jmp    801a59 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	8b 10                	mov    (%eax),%edx
  8019d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d8:	8d 40 04             	lea    0x4(%eax),%eax
  8019db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019e3:	eb 74                	jmp    801a59 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019e5:	83 f9 01             	cmp    $0x1,%ecx
  8019e8:	7e 15                	jle    8019ff <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	8b 10                	mov    (%eax),%edx
  8019ef:	8b 48 04             	mov    0x4(%eax),%ecx
  8019f2:	8d 40 08             	lea    0x8(%eax),%eax
  8019f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019fd:	eb 5a                	jmp    801a59 <vprintfmt+0x3bb>
	else if (lflag)
  8019ff:	85 c9                	test   %ecx,%ecx
  801a01:	75 17                	jne    801a1a <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	8b 10                	mov    (%eax),%edx
  801a08:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0d:	8d 40 04             	lea    0x4(%eax),%eax
  801a10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a13:	b8 08 00 00 00       	mov    $0x8,%eax
  801a18:	eb 3f                	jmp    801a59 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1d:	8b 10                	mov    (%eax),%edx
  801a1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a24:	8d 40 04             	lea    0x4(%eax),%eax
  801a27:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a2a:	b8 08 00 00 00       	mov    $0x8,%eax
  801a2f:	eb 28                	jmp    801a59 <vprintfmt+0x3bb>
			putch('0', putdat);
  801a31:	83 ec 08             	sub    $0x8,%esp
  801a34:	53                   	push   %ebx
  801a35:	6a 30                	push   $0x30
  801a37:	ff d6                	call   *%esi
			putch('x', putdat);
  801a39:	83 c4 08             	add    $0x8,%esp
  801a3c:	53                   	push   %ebx
  801a3d:	6a 78                	push   $0x78
  801a3f:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a41:	8b 45 14             	mov    0x14(%ebp),%eax
  801a44:	8b 10                	mov    (%eax),%edx
  801a46:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a4b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a4e:	8d 40 04             	lea    0x4(%eax),%eax
  801a51:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a54:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a59:	83 ec 0c             	sub    $0xc,%esp
  801a5c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a60:	57                   	push   %edi
  801a61:	ff 75 e0             	pushl  -0x20(%ebp)
  801a64:	50                   	push   %eax
  801a65:	51                   	push   %ecx
  801a66:	52                   	push   %edx
  801a67:	89 da                	mov    %ebx,%edx
  801a69:	89 f0                	mov    %esi,%eax
  801a6b:	e8 45 fb ff ff       	call   8015b5 <printnum>
			break;
  801a70:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a73:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a76:	83 c7 01             	add    $0x1,%edi
  801a79:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a7d:	83 f8 25             	cmp    $0x25,%eax
  801a80:	0f 84 2f fc ff ff    	je     8016b5 <vprintfmt+0x17>
			if (ch == '\0')
  801a86:	85 c0                	test   %eax,%eax
  801a88:	0f 84 8b 00 00 00    	je     801b19 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a8e:	83 ec 08             	sub    $0x8,%esp
  801a91:	53                   	push   %ebx
  801a92:	50                   	push   %eax
  801a93:	ff d6                	call   *%esi
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	eb dc                	jmp    801a76 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a9a:	83 f9 01             	cmp    $0x1,%ecx
  801a9d:	7e 15                	jle    801ab4 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa2:	8b 10                	mov    (%eax),%edx
  801aa4:	8b 48 04             	mov    0x4(%eax),%ecx
  801aa7:	8d 40 08             	lea    0x8(%eax),%eax
  801aaa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aad:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab2:	eb a5                	jmp    801a59 <vprintfmt+0x3bb>
	else if (lflag)
  801ab4:	85 c9                	test   %ecx,%ecx
  801ab6:	75 17                	jne    801acf <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  801abb:	8b 10                	mov    (%eax),%edx
  801abd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac2:	8d 40 04             	lea    0x4(%eax),%eax
  801ac5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ac8:	b8 10 00 00 00       	mov    $0x10,%eax
  801acd:	eb 8a                	jmp    801a59 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801acf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad2:	8b 10                	mov    (%eax),%edx
  801ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad9:	8d 40 04             	lea    0x4(%eax),%eax
  801adc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801adf:	b8 10 00 00 00       	mov    $0x10,%eax
  801ae4:	e9 70 ff ff ff       	jmp    801a59 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801ae9:	83 ec 08             	sub    $0x8,%esp
  801aec:	53                   	push   %ebx
  801aed:	6a 25                	push   $0x25
  801aef:	ff d6                	call   *%esi
			break;
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	e9 7a ff ff ff       	jmp    801a73 <vprintfmt+0x3d5>
			putch('%', putdat);
  801af9:	83 ec 08             	sub    $0x8,%esp
  801afc:	53                   	push   %ebx
  801afd:	6a 25                	push   $0x25
  801aff:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	89 f8                	mov    %edi,%eax
  801b06:	eb 03                	jmp    801b0b <vprintfmt+0x46d>
  801b08:	83 e8 01             	sub    $0x1,%eax
  801b0b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b0f:	75 f7                	jne    801b08 <vprintfmt+0x46a>
  801b11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b14:	e9 5a ff ff ff       	jmp    801a73 <vprintfmt+0x3d5>
}
  801b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1c:	5b                   	pop    %ebx
  801b1d:	5e                   	pop    %esi
  801b1e:	5f                   	pop    %edi
  801b1f:	5d                   	pop    %ebp
  801b20:	c3                   	ret    

00801b21 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 18             	sub    $0x18,%esp
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b30:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b34:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	74 26                	je     801b68 <vsnprintf+0x47>
  801b42:	85 d2                	test   %edx,%edx
  801b44:	7e 22                	jle    801b68 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b46:	ff 75 14             	pushl  0x14(%ebp)
  801b49:	ff 75 10             	pushl  0x10(%ebp)
  801b4c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b4f:	50                   	push   %eax
  801b50:	68 64 16 80 00       	push   $0x801664
  801b55:	e8 44 fb ff ff       	call   80169e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b63:	83 c4 10             	add    $0x10,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    
		return -E_INVAL;
  801b68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b6d:	eb f7                	jmp    801b66 <vsnprintf+0x45>

00801b6f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b75:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b78:	50                   	push   %eax
  801b79:	ff 75 10             	pushl  0x10(%ebp)
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	ff 75 08             	pushl  0x8(%ebp)
  801b82:	e8 9a ff ff ff       	call   801b21 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b94:	eb 03                	jmp    801b99 <strlen+0x10>
		n++;
  801b96:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b99:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b9d:	75 f7                	jne    801b96 <strlen+0xd>
	return n;
}
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    

00801ba1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801baa:	b8 00 00 00 00       	mov    $0x0,%eax
  801baf:	eb 03                	jmp    801bb4 <strnlen+0x13>
		n++;
  801bb1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bb4:	39 d0                	cmp    %edx,%eax
  801bb6:	74 06                	je     801bbe <strnlen+0x1d>
  801bb8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801bbc:	75 f3                	jne    801bb1 <strnlen+0x10>
	return n;
}
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	53                   	push   %ebx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801bca:	89 c2                	mov    %eax,%edx
  801bcc:	83 c1 01             	add    $0x1,%ecx
  801bcf:	83 c2 01             	add    $0x1,%edx
  801bd2:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801bd6:	88 5a ff             	mov    %bl,-0x1(%edx)
  801bd9:	84 db                	test   %bl,%bl
  801bdb:	75 ef                	jne    801bcc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801bdd:	5b                   	pop    %ebx
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	53                   	push   %ebx
  801be4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801be7:	53                   	push   %ebx
  801be8:	e8 9c ff ff ff       	call   801b89 <strlen>
  801bed:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	01 d8                	add    %ebx,%eax
  801bf5:	50                   	push   %eax
  801bf6:	e8 c5 ff ff ff       	call   801bc0 <strcpy>
	return dst;
}
  801bfb:	89 d8                	mov    %ebx,%eax
  801bfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	56                   	push   %esi
  801c06:	53                   	push   %ebx
  801c07:	8b 75 08             	mov    0x8(%ebp),%esi
  801c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c0d:	89 f3                	mov    %esi,%ebx
  801c0f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c12:	89 f2                	mov    %esi,%edx
  801c14:	eb 0f                	jmp    801c25 <strncpy+0x23>
		*dst++ = *src;
  801c16:	83 c2 01             	add    $0x1,%edx
  801c19:	0f b6 01             	movzbl (%ecx),%eax
  801c1c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801c1f:	80 39 01             	cmpb   $0x1,(%ecx)
  801c22:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801c25:	39 da                	cmp    %ebx,%edx
  801c27:	75 ed                	jne    801c16 <strncpy+0x14>
	}
	return ret;
}
  801c29:	89 f0                	mov    %esi,%eax
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5d                   	pop    %ebp
  801c2e:	c3                   	ret    

00801c2f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	8b 75 08             	mov    0x8(%ebp),%esi
  801c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3d:	89 f0                	mov    %esi,%eax
  801c3f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c43:	85 c9                	test   %ecx,%ecx
  801c45:	75 0b                	jne    801c52 <strlcpy+0x23>
  801c47:	eb 17                	jmp    801c60 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c49:	83 c2 01             	add    $0x1,%edx
  801c4c:	83 c0 01             	add    $0x1,%eax
  801c4f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c52:	39 d8                	cmp    %ebx,%eax
  801c54:	74 07                	je     801c5d <strlcpy+0x2e>
  801c56:	0f b6 0a             	movzbl (%edx),%ecx
  801c59:	84 c9                	test   %cl,%cl
  801c5b:	75 ec                	jne    801c49 <strlcpy+0x1a>
		*dst = '\0';
  801c5d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c60:	29 f0                	sub    %esi,%eax
}
  801c62:	5b                   	pop    %ebx
  801c63:	5e                   	pop    %esi
  801c64:	5d                   	pop    %ebp
  801c65:	c3                   	ret    

00801c66 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c6f:	eb 06                	jmp    801c77 <strcmp+0x11>
		p++, q++;
  801c71:	83 c1 01             	add    $0x1,%ecx
  801c74:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c77:	0f b6 01             	movzbl (%ecx),%eax
  801c7a:	84 c0                	test   %al,%al
  801c7c:	74 04                	je     801c82 <strcmp+0x1c>
  801c7e:	3a 02                	cmp    (%edx),%al
  801c80:	74 ef                	je     801c71 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c82:	0f b6 c0             	movzbl %al,%eax
  801c85:	0f b6 12             	movzbl (%edx),%edx
  801c88:	29 d0                	sub    %edx,%eax
}
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    

00801c8c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	53                   	push   %ebx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c96:	89 c3                	mov    %eax,%ebx
  801c98:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c9b:	eb 06                	jmp    801ca3 <strncmp+0x17>
		n--, p++, q++;
  801c9d:	83 c0 01             	add    $0x1,%eax
  801ca0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801ca3:	39 d8                	cmp    %ebx,%eax
  801ca5:	74 16                	je     801cbd <strncmp+0x31>
  801ca7:	0f b6 08             	movzbl (%eax),%ecx
  801caa:	84 c9                	test   %cl,%cl
  801cac:	74 04                	je     801cb2 <strncmp+0x26>
  801cae:	3a 0a                	cmp    (%edx),%cl
  801cb0:	74 eb                	je     801c9d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801cb2:	0f b6 00             	movzbl (%eax),%eax
  801cb5:	0f b6 12             	movzbl (%edx),%edx
  801cb8:	29 d0                	sub    %edx,%eax
}
  801cba:	5b                   	pop    %ebx
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    
		return 0;
  801cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc2:	eb f6                	jmp    801cba <strncmp+0x2e>

00801cc4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cce:	0f b6 10             	movzbl (%eax),%edx
  801cd1:	84 d2                	test   %dl,%dl
  801cd3:	74 09                	je     801cde <strchr+0x1a>
		if (*s == c)
  801cd5:	38 ca                	cmp    %cl,%dl
  801cd7:	74 0a                	je     801ce3 <strchr+0x1f>
	for (; *s; s++)
  801cd9:	83 c0 01             	add    $0x1,%eax
  801cdc:	eb f0                	jmp    801cce <strchr+0xa>
			return (char *) s;
	return 0;
  801cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    

00801ce5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cef:	eb 03                	jmp    801cf4 <strfind+0xf>
  801cf1:	83 c0 01             	add    $0x1,%eax
  801cf4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cf7:	38 ca                	cmp    %cl,%dl
  801cf9:	74 04                	je     801cff <strfind+0x1a>
  801cfb:	84 d2                	test   %dl,%dl
  801cfd:	75 f2                	jne    801cf1 <strfind+0xc>
			break;
	return (char *) s;
}
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    

00801d01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	57                   	push   %edi
  801d05:	56                   	push   %esi
  801d06:	53                   	push   %ebx
  801d07:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d0d:	85 c9                	test   %ecx,%ecx
  801d0f:	74 13                	je     801d24 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d11:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801d17:	75 05                	jne    801d1e <memset+0x1d>
  801d19:	f6 c1 03             	test   $0x3,%cl
  801d1c:	74 0d                	je     801d2b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d21:	fc                   	cld    
  801d22:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d24:	89 f8                	mov    %edi,%eax
  801d26:	5b                   	pop    %ebx
  801d27:	5e                   	pop    %esi
  801d28:	5f                   	pop    %edi
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    
		c &= 0xFF;
  801d2b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d2f:	89 d3                	mov    %edx,%ebx
  801d31:	c1 e3 08             	shl    $0x8,%ebx
  801d34:	89 d0                	mov    %edx,%eax
  801d36:	c1 e0 18             	shl    $0x18,%eax
  801d39:	89 d6                	mov    %edx,%esi
  801d3b:	c1 e6 10             	shl    $0x10,%esi
  801d3e:	09 f0                	or     %esi,%eax
  801d40:	09 c2                	or     %eax,%edx
  801d42:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d44:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d47:	89 d0                	mov    %edx,%eax
  801d49:	fc                   	cld    
  801d4a:	f3 ab                	rep stos %eax,%es:(%edi)
  801d4c:	eb d6                	jmp    801d24 <memset+0x23>

00801d4e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	57                   	push   %edi
  801d52:	56                   	push   %esi
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d5c:	39 c6                	cmp    %eax,%esi
  801d5e:	73 35                	jae    801d95 <memmove+0x47>
  801d60:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d63:	39 c2                	cmp    %eax,%edx
  801d65:	76 2e                	jbe    801d95 <memmove+0x47>
		s += n;
		d += n;
  801d67:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d6a:	89 d6                	mov    %edx,%esi
  801d6c:	09 fe                	or     %edi,%esi
  801d6e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d74:	74 0c                	je     801d82 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d76:	83 ef 01             	sub    $0x1,%edi
  801d79:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d7c:	fd                   	std    
  801d7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d7f:	fc                   	cld    
  801d80:	eb 21                	jmp    801da3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d82:	f6 c1 03             	test   $0x3,%cl
  801d85:	75 ef                	jne    801d76 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d87:	83 ef 04             	sub    $0x4,%edi
  801d8a:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d8d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d90:	fd                   	std    
  801d91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d93:	eb ea                	jmp    801d7f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d95:	89 f2                	mov    %esi,%edx
  801d97:	09 c2                	or     %eax,%edx
  801d99:	f6 c2 03             	test   $0x3,%dl
  801d9c:	74 09                	je     801da7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d9e:	89 c7                	mov    %eax,%edi
  801da0:	fc                   	cld    
  801da1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801da3:	5e                   	pop    %esi
  801da4:	5f                   	pop    %edi
  801da5:	5d                   	pop    %ebp
  801da6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801da7:	f6 c1 03             	test   $0x3,%cl
  801daa:	75 f2                	jne    801d9e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801dac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801daf:	89 c7                	mov    %eax,%edi
  801db1:	fc                   	cld    
  801db2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801db4:	eb ed                	jmp    801da3 <memmove+0x55>

00801db6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801db9:	ff 75 10             	pushl  0x10(%ebp)
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	e8 87 ff ff ff       	call   801d4e <memmove>
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	56                   	push   %esi
  801dcd:	53                   	push   %ebx
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd4:	89 c6                	mov    %eax,%esi
  801dd6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801dd9:	39 f0                	cmp    %esi,%eax
  801ddb:	74 1c                	je     801df9 <memcmp+0x30>
		if (*s1 != *s2)
  801ddd:	0f b6 08             	movzbl (%eax),%ecx
  801de0:	0f b6 1a             	movzbl (%edx),%ebx
  801de3:	38 d9                	cmp    %bl,%cl
  801de5:	75 08                	jne    801def <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801de7:	83 c0 01             	add    $0x1,%eax
  801dea:	83 c2 01             	add    $0x1,%edx
  801ded:	eb ea                	jmp    801dd9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801def:	0f b6 c1             	movzbl %cl,%eax
  801df2:	0f b6 db             	movzbl %bl,%ebx
  801df5:	29 d8                	sub    %ebx,%eax
  801df7:	eb 05                	jmp    801dfe <memcmp+0x35>
	}

	return 0;
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfe:	5b                   	pop    %ebx
  801dff:	5e                   	pop    %esi
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e10:	39 d0                	cmp    %edx,%eax
  801e12:	73 09                	jae    801e1d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e14:	38 08                	cmp    %cl,(%eax)
  801e16:	74 05                	je     801e1d <memfind+0x1b>
	for (; s < ends; s++)
  801e18:	83 c0 01             	add    $0x1,%eax
  801e1b:	eb f3                	jmp    801e10 <memfind+0xe>
			break;
	return (void *) s;
}
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	57                   	push   %edi
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
  801e25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e2b:	eb 03                	jmp    801e30 <strtol+0x11>
		s++;
  801e2d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e30:	0f b6 01             	movzbl (%ecx),%eax
  801e33:	3c 20                	cmp    $0x20,%al
  801e35:	74 f6                	je     801e2d <strtol+0xe>
  801e37:	3c 09                	cmp    $0x9,%al
  801e39:	74 f2                	je     801e2d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e3b:	3c 2b                	cmp    $0x2b,%al
  801e3d:	74 2e                	je     801e6d <strtol+0x4e>
	int neg = 0;
  801e3f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e44:	3c 2d                	cmp    $0x2d,%al
  801e46:	74 2f                	je     801e77 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e48:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e4e:	75 05                	jne    801e55 <strtol+0x36>
  801e50:	80 39 30             	cmpb   $0x30,(%ecx)
  801e53:	74 2c                	je     801e81 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e55:	85 db                	test   %ebx,%ebx
  801e57:	75 0a                	jne    801e63 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e59:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e5e:	80 39 30             	cmpb   $0x30,(%ecx)
  801e61:	74 28                	je     801e8b <strtol+0x6c>
		base = 10;
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e6b:	eb 50                	jmp    801ebd <strtol+0x9e>
		s++;
  801e6d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e70:	bf 00 00 00 00       	mov    $0x0,%edi
  801e75:	eb d1                	jmp    801e48 <strtol+0x29>
		s++, neg = 1;
  801e77:	83 c1 01             	add    $0x1,%ecx
  801e7a:	bf 01 00 00 00       	mov    $0x1,%edi
  801e7f:	eb c7                	jmp    801e48 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e81:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e85:	74 0e                	je     801e95 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e87:	85 db                	test   %ebx,%ebx
  801e89:	75 d8                	jne    801e63 <strtol+0x44>
		s++, base = 8;
  801e8b:	83 c1 01             	add    $0x1,%ecx
  801e8e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e93:	eb ce                	jmp    801e63 <strtol+0x44>
		s += 2, base = 16;
  801e95:	83 c1 02             	add    $0x2,%ecx
  801e98:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e9d:	eb c4                	jmp    801e63 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e9f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801ea2:	89 f3                	mov    %esi,%ebx
  801ea4:	80 fb 19             	cmp    $0x19,%bl
  801ea7:	77 29                	ja     801ed2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801ea9:	0f be d2             	movsbl %dl,%edx
  801eac:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801eaf:	3b 55 10             	cmp    0x10(%ebp),%edx
  801eb2:	7d 30                	jge    801ee4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801eb4:	83 c1 01             	add    $0x1,%ecx
  801eb7:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ebb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ebd:	0f b6 11             	movzbl (%ecx),%edx
  801ec0:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ec3:	89 f3                	mov    %esi,%ebx
  801ec5:	80 fb 09             	cmp    $0x9,%bl
  801ec8:	77 d5                	ja     801e9f <strtol+0x80>
			dig = *s - '0';
  801eca:	0f be d2             	movsbl %dl,%edx
  801ecd:	83 ea 30             	sub    $0x30,%edx
  801ed0:	eb dd                	jmp    801eaf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801ed2:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ed5:	89 f3                	mov    %esi,%ebx
  801ed7:	80 fb 19             	cmp    $0x19,%bl
  801eda:	77 08                	ja     801ee4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801edc:	0f be d2             	movsbl %dl,%edx
  801edf:	83 ea 37             	sub    $0x37,%edx
  801ee2:	eb cb                	jmp    801eaf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ee4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ee8:	74 05                	je     801eef <strtol+0xd0>
		*endptr = (char *) s;
  801eea:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eed:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eef:	89 c2                	mov    %eax,%edx
  801ef1:	f7 da                	neg    %edx
  801ef3:	85 ff                	test   %edi,%edi
  801ef5:	0f 45 c2             	cmovne %edx,%eax
}
  801ef8:	5b                   	pop    %ebx
  801ef9:	5e                   	pop    %esi
  801efa:	5f                   	pop    %edi
  801efb:	5d                   	pop    %ebp
  801efc:	c3                   	ret    

00801efd <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  801f03:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  801f0a:	74 0a                	je     801f16 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	a3 00 70 80 00       	mov    %eax,0x807000
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  801f16:	a1 08 40 80 00       	mov    0x804008,%eax
  801f1b:	8b 40 48             	mov    0x48(%eax),%eax
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	6a 07                	push   $0x7
  801f23:	68 00 f0 bf ee       	push   $0xeebff000
  801f28:	50                   	push   %eax
  801f29:	e8 42 e2 ff ff       	call   800170 <sys_page_alloc>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	85 c0                	test   %eax,%eax
  801f33:	78 1b                	js     801f50 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  801f35:	a1 08 40 80 00       	mov    0x804008,%eax
  801f3a:	8b 40 48             	mov    0x48(%eax),%eax
  801f3d:	83 ec 08             	sub    $0x8,%esp
  801f40:	68 80 03 80 00       	push   $0x800380
  801f45:	50                   	push   %eax
  801f46:	e8 70 e3 ff ff       	call   8002bb <sys_env_set_pgfault_upcall>
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	eb bc                	jmp    801f0c <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  801f50:	50                   	push   %eax
  801f51:	68 60 27 80 00       	push   $0x802760
  801f56:	6a 22                	push   $0x22
  801f58:	68 78 27 80 00       	push   $0x802778
  801f5d:	e8 64 f5 ff ff       	call   8014c6 <_panic>

00801f62 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	56                   	push   %esi
  801f66:	53                   	push   %ebx
  801f67:	8b 75 08             	mov    0x8(%ebp),%esi
  801f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f70:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f72:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f77:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	50                   	push   %eax
  801f7e:	e8 9d e3 ff ff       	call   800320 <sys_ipc_recv>
	if (from_env_store)
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	85 f6                	test   %esi,%esi
  801f88:	74 14                	je     801f9e <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	78 09                	js     801f9c <ipc_recv+0x3a>
  801f93:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f99:	8b 52 74             	mov    0x74(%edx),%edx
  801f9c:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f9e:	85 db                	test   %ebx,%ebx
  801fa0:	74 14                	je     801fb6 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801fa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	78 09                	js     801fb4 <ipc_recv+0x52>
  801fab:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fb1:	8b 52 78             	mov    0x78(%edx),%edx
  801fb4:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	78 08                	js     801fc2 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801fba:	a1 08 40 80 00       	mov    0x804008,%eax
  801fbf:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801fc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc5:	5b                   	pop    %ebx
  801fc6:	5e                   	pop    %esi
  801fc7:	5d                   	pop    %ebp
  801fc8:	c3                   	ret    

00801fc9 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	57                   	push   %edi
  801fcd:	56                   	push   %esi
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801fdb:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801fdd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fe2:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801fe5:	ff 75 14             	pushl  0x14(%ebp)
  801fe8:	53                   	push   %ebx
  801fe9:	56                   	push   %esi
  801fea:	57                   	push   %edi
  801feb:	e8 0d e3 ff ff       	call   8002fd <sys_ipc_try_send>
		if (ret == 0)
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	74 1e                	je     802015 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801ff7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ffa:	75 07                	jne    802003 <ipc_send+0x3a>
			sys_yield();
  801ffc:	e8 50 e1 ff ff       	call   800151 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802001:	eb e2                	jmp    801fe5 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802003:	50                   	push   %eax
  802004:	68 86 27 80 00       	push   $0x802786
  802009:	6a 3d                	push   $0x3d
  80200b:	68 9a 27 80 00       	push   $0x80279a
  802010:	e8 b1 f4 ff ff       	call   8014c6 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802015:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802018:	5b                   	pop    %ebx
  802019:	5e                   	pop    %esi
  80201a:	5f                   	pop    %edi
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    

0080201d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802028:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80202b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802031:	8b 52 50             	mov    0x50(%edx),%edx
  802034:	39 ca                	cmp    %ecx,%edx
  802036:	74 11                	je     802049 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802038:	83 c0 01             	add    $0x1,%eax
  80203b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802040:	75 e6                	jne    802028 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
  802047:	eb 0b                	jmp    802054 <ipc_find_env+0x37>
			return envs[i].env_id;
  802049:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80204c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802051:	8b 40 48             	mov    0x48(%eax),%eax
}
  802054:	5d                   	pop    %ebp
  802055:	c3                   	ret    

00802056 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80205c:	89 d0                	mov    %edx,%eax
  80205e:	c1 e8 16             	shr    $0x16,%eax
  802061:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80206d:	f6 c1 01             	test   $0x1,%cl
  802070:	74 1d                	je     80208f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802072:	c1 ea 0c             	shr    $0xc,%edx
  802075:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80207c:	f6 c2 01             	test   $0x1,%dl
  80207f:	74 0e                	je     80208f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802081:	c1 ea 0c             	shr    $0xc,%edx
  802084:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80208b:	ef 
  80208c:	0f b7 c0             	movzwl %ax,%eax
}
  80208f:	5d                   	pop    %ebp
  802090:	c3                   	ret    
  802091:	66 90                	xchg   %ax,%ax
  802093:	66 90                	xchg   %ax,%ax
  802095:	66 90                	xchg   %ax,%ax
  802097:	66 90                	xchg   %ax,%ax
  802099:	66 90                	xchg   %ax,%ax
  80209b:	66 90                	xchg   %ax,%ax
  80209d:	66 90                	xchg   %ax,%ax
  80209f:	90                   	nop

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

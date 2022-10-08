
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 3a 01 00 00       	call   800181 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 76 02 00 00       	call   8002cc <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 ce 00 00 00       	call   800143 <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	7e 07                	jle    800092 <libmain+0x2d>
		binaryname = argv[0];
  80008b:	8b 06                	mov    (%esi),%eax
  80008d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	e8 97 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0a 00 00 00       	call   8000ab <exit>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b1:	e8 b1 04 00 00       	call   800567 <close_all>
	sys_env_destroy(0);
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	6a 00                	push   $0x0
  8000bb:	e8 42 00 00 00       	call   800102 <sys_env_destroy>
}
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d6:	89 c3                	mov    %eax,%ebx
  8000d8:	89 c7                	mov    %eax,%edi
  8000da:	89 c6                	mov    %eax,%esi
  8000dc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f3:	89 d1                	mov    %edx,%ecx
  8000f5:	89 d3                	mov    %edx,%ebx
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	89 d6                	mov    %edx,%esi
  8000fb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000fd:	5b                   	pop    %ebx
  8000fe:	5e                   	pop    %esi
  8000ff:	5f                   	pop    %edi
  800100:	5d                   	pop    %ebp
  800101:	c3                   	ret    

00800102 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	57                   	push   %edi
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80010b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800110:	8b 55 08             	mov    0x8(%ebp),%edx
  800113:	b8 03 00 00 00       	mov    $0x3,%eax
  800118:	89 cb                	mov    %ecx,%ebx
  80011a:	89 cf                	mov    %ecx,%edi
  80011c:	89 ce                	mov    %ecx,%esi
  80011e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800120:	85 c0                	test   %eax,%eax
  800122:	7f 08                	jg     80012c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800124:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800127:	5b                   	pop    %ebx
  800128:	5e                   	pop    %esi
  800129:	5f                   	pop    %edi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	50                   	push   %eax
  800130:	6a 03                	push   $0x3
  800132:	68 6a 22 80 00       	push   $0x80226a
  800137:	6a 23                	push   $0x23
  800139:	68 87 22 80 00       	push   $0x802287
  80013e:	e8 6e 13 00 00       	call   8014b1 <_panic>

00800143 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
	asm volatile("int %1\n"
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	b8 02 00 00 00       	mov    $0x2,%eax
  800153:	89 d1                	mov    %edx,%ecx
  800155:	89 d3                	mov    %edx,%ebx
  800157:	89 d7                	mov    %edx,%edi
  800159:	89 d6                	mov    %edx,%esi
  80015b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <sys_yield>:

void
sys_yield(void)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
	asm volatile("int %1\n"
  800168:	ba 00 00 00 00       	mov    $0x0,%edx
  80016d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800172:	89 d1                	mov    %edx,%ecx
  800174:	89 d3                	mov    %edx,%ebx
  800176:	89 d7                	mov    %edx,%edi
  800178:	89 d6                	mov    %edx,%esi
  80017a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    

00800181 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80018a:	be 00 00 00 00       	mov    $0x0,%esi
  80018f:	8b 55 08             	mov    0x8(%ebp),%edx
  800192:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800195:	b8 04 00 00 00       	mov    $0x4,%eax
  80019a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019d:	89 f7                	mov    %esi,%edi
  80019f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a1:	85 c0                	test   %eax,%eax
  8001a3:	7f 08                	jg     8001ad <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	50                   	push   %eax
  8001b1:	6a 04                	push   $0x4
  8001b3:	68 6a 22 80 00       	push   $0x80226a
  8001b8:	6a 23                	push   $0x23
  8001ba:	68 87 22 80 00       	push   $0x802287
  8001bf:	e8 ed 12 00 00       	call   8014b1 <_panic>

008001c4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001db:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001de:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e3:	85 c0                	test   %eax,%eax
  8001e5:	7f 08                	jg     8001ef <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5e                   	pop    %esi
  8001ec:	5f                   	pop    %edi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	50                   	push   %eax
  8001f3:	6a 05                	push   $0x5
  8001f5:	68 6a 22 80 00       	push   $0x80226a
  8001fa:	6a 23                	push   $0x23
  8001fc:	68 87 22 80 00       	push   $0x802287
  800201:	e8 ab 12 00 00       	call   8014b1 <_panic>

00800206 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800214:	8b 55 08             	mov    0x8(%ebp),%edx
  800217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021a:	b8 06 00 00 00       	mov    $0x6,%eax
  80021f:	89 df                	mov    %ebx,%edi
  800221:	89 de                	mov    %ebx,%esi
  800223:	cd 30                	int    $0x30
	if(check && ret > 0)
  800225:	85 c0                	test   %eax,%eax
  800227:	7f 08                	jg     800231 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022c:	5b                   	pop    %ebx
  80022d:	5e                   	pop    %esi
  80022e:	5f                   	pop    %edi
  80022f:	5d                   	pop    %ebp
  800230:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	50                   	push   %eax
  800235:	6a 06                	push   $0x6
  800237:	68 6a 22 80 00       	push   $0x80226a
  80023c:	6a 23                	push   $0x23
  80023e:	68 87 22 80 00       	push   $0x802287
  800243:	e8 69 12 00 00       	call   8014b1 <_panic>

00800248 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800251:	bb 00 00 00 00       	mov    $0x0,%ebx
  800256:	8b 55 08             	mov    0x8(%ebp),%edx
  800259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025c:	b8 08 00 00 00       	mov    $0x8,%eax
  800261:	89 df                	mov    %ebx,%edi
  800263:	89 de                	mov    %ebx,%esi
  800265:	cd 30                	int    $0x30
	if(check && ret > 0)
  800267:	85 c0                	test   %eax,%eax
  800269:	7f 08                	jg     800273 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	50                   	push   %eax
  800277:	6a 08                	push   $0x8
  800279:	68 6a 22 80 00       	push   $0x80226a
  80027e:	6a 23                	push   $0x23
  800280:	68 87 22 80 00       	push   $0x802287
  800285:	e8 27 12 00 00       	call   8014b1 <_panic>

0080028a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800293:	bb 00 00 00 00       	mov    $0x0,%ebx
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029e:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a3:	89 df                	mov    %ebx,%edi
  8002a5:	89 de                	mov    %ebx,%esi
  8002a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a9:	85 c0                	test   %eax,%eax
  8002ab:	7f 08                	jg     8002b5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	6a 09                	push   $0x9
  8002bb:	68 6a 22 80 00       	push   $0x80226a
  8002c0:	6a 23                	push   $0x23
  8002c2:	68 87 22 80 00       	push   $0x802287
  8002c7:	e8 e5 11 00 00       	call   8014b1 <_panic>

008002cc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	57                   	push   %edi
  8002d0:	56                   	push   %esi
  8002d1:	53                   	push   %ebx
  8002d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002da:	8b 55 08             	mov    0x8(%ebp),%edx
  8002dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002e5:	89 df                	mov    %ebx,%edi
  8002e7:	89 de                	mov    %ebx,%esi
  8002e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002eb:	85 c0                	test   %eax,%eax
  8002ed:	7f 08                	jg     8002f7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	50                   	push   %eax
  8002fb:	6a 0a                	push   $0xa
  8002fd:	68 6a 22 80 00       	push   $0x80226a
  800302:	6a 23                	push   $0x23
  800304:	68 87 22 80 00       	push   $0x802287
  800309:	e8 a3 11 00 00       	call   8014b1 <_panic>

0080030e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
	asm volatile("int %1\n"
  800314:	8b 55 08             	mov    0x8(%ebp),%edx
  800317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80031f:	be 00 00 00 00       	mov    $0x0,%esi
  800324:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800327:	8b 7d 14             	mov    0x14(%ebp),%edi
  80032a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80032c:	5b                   	pop    %ebx
  80032d:	5e                   	pop    %esi
  80032e:	5f                   	pop    %edi
  80032f:	5d                   	pop    %ebp
  800330:	c3                   	ret    

00800331 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80033a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	b8 0d 00 00 00       	mov    $0xd,%eax
  800347:	89 cb                	mov    %ecx,%ebx
  800349:	89 cf                	mov    %ecx,%edi
  80034b:	89 ce                	mov    %ecx,%esi
  80034d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80034f:	85 c0                	test   %eax,%eax
  800351:	7f 08                	jg     80035b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800353:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80035b:	83 ec 0c             	sub    $0xc,%esp
  80035e:	50                   	push   %eax
  80035f:	6a 0d                	push   $0xd
  800361:	68 6a 22 80 00       	push   $0x80226a
  800366:	6a 23                	push   $0x23
  800368:	68 87 22 80 00       	push   $0x802287
  80036d:	e8 3f 11 00 00       	call   8014b1 <_panic>

00800372 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	57                   	push   %edi
  800376:	56                   	push   %esi
  800377:	53                   	push   %ebx
	asm volatile("int %1\n"
  800378:	ba 00 00 00 00       	mov    $0x0,%edx
  80037d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800382:	89 d1                	mov    %edx,%ecx
  800384:	89 d3                	mov    %edx,%ebx
  800386:	89 d7                	mov    %edx,%edi
  800388:	89 d6                	mov    %edx,%esi
  80038a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800394:	8b 45 08             	mov    0x8(%ebp),%eax
  800397:	05 00 00 00 30       	add    $0x30000000,%eax
  80039c:	c1 e8 0c             	shr    $0xc,%eax
}
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003b6:	5d                   	pop    %ebp
  8003b7:	c3                   	ret    

008003b8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003be:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003c3:	89 c2                	mov    %eax,%edx
  8003c5:	c1 ea 16             	shr    $0x16,%edx
  8003c8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003cf:	f6 c2 01             	test   $0x1,%dl
  8003d2:	74 2a                	je     8003fe <fd_alloc+0x46>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	c1 ea 0c             	shr    $0xc,%edx
  8003d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003e0:	f6 c2 01             	test   $0x1,%dl
  8003e3:	74 19                	je     8003fe <fd_alloc+0x46>
  8003e5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003ea:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003ef:	75 d2                	jne    8003c3 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003f1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003f7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003fc:	eb 07                	jmp    800405 <fd_alloc+0x4d>
			*fd_store = fd;
  8003fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  800400:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800405:	5d                   	pop    %ebp
  800406:	c3                   	ret    

00800407 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80040d:	83 f8 1f             	cmp    $0x1f,%eax
  800410:	77 36                	ja     800448 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800412:	c1 e0 0c             	shl    $0xc,%eax
  800415:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80041a:	89 c2                	mov    %eax,%edx
  80041c:	c1 ea 16             	shr    $0x16,%edx
  80041f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800426:	f6 c2 01             	test   $0x1,%dl
  800429:	74 24                	je     80044f <fd_lookup+0x48>
  80042b:	89 c2                	mov    %eax,%edx
  80042d:	c1 ea 0c             	shr    $0xc,%edx
  800430:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800437:	f6 c2 01             	test   $0x1,%dl
  80043a:	74 1a                	je     800456 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80043c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043f:	89 02                	mov    %eax,(%edx)
	return 0;
  800441:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    
		return -E_INVAL;
  800448:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80044d:	eb f7                	jmp    800446 <fd_lookup+0x3f>
		return -E_INVAL;
  80044f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800454:	eb f0                	jmp    800446 <fd_lookup+0x3f>
  800456:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80045b:	eb e9                	jmp    800446 <fd_lookup+0x3f>

0080045d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800466:	ba 14 23 80 00       	mov    $0x802314,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80046b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800470:	39 08                	cmp    %ecx,(%eax)
  800472:	74 33                	je     8004a7 <dev_lookup+0x4a>
  800474:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800477:	8b 02                	mov    (%edx),%eax
  800479:	85 c0                	test   %eax,%eax
  80047b:	75 f3                	jne    800470 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80047d:	a1 08 40 80 00       	mov    0x804008,%eax
  800482:	8b 40 48             	mov    0x48(%eax),%eax
  800485:	83 ec 04             	sub    $0x4,%esp
  800488:	51                   	push   %ecx
  800489:	50                   	push   %eax
  80048a:	68 98 22 80 00       	push   $0x802298
  80048f:	e8 f8 10 00 00       	call   80158c <cprintf>
	*dev = 0;
  800494:	8b 45 0c             	mov    0xc(%ebp),%eax
  800497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    
			*dev = devtab[i];
  8004a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b1:	eb f2                	jmp    8004a5 <dev_lookup+0x48>

008004b3 <fd_close>:
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	57                   	push   %edi
  8004b7:	56                   	push   %esi
  8004b8:	53                   	push   %ebx
  8004b9:	83 ec 1c             	sub    $0x1c,%esp
  8004bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004c5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004c6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004cc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004cf:	50                   	push   %eax
  8004d0:	e8 32 ff ff ff       	call   800407 <fd_lookup>
  8004d5:	89 c3                	mov    %eax,%ebx
  8004d7:	83 c4 08             	add    $0x8,%esp
  8004da:	85 c0                	test   %eax,%eax
  8004dc:	78 05                	js     8004e3 <fd_close+0x30>
	    || fd != fd2)
  8004de:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004e1:	74 16                	je     8004f9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004e3:	89 f8                	mov    %edi,%eax
  8004e5:	84 c0                	test   %al,%al
  8004e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ec:	0f 44 d8             	cmove  %eax,%ebx
}
  8004ef:	89 d8                	mov    %ebx,%eax
  8004f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f4:	5b                   	pop    %ebx
  8004f5:	5e                   	pop    %esi
  8004f6:	5f                   	pop    %edi
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004ff:	50                   	push   %eax
  800500:	ff 36                	pushl  (%esi)
  800502:	e8 56 ff ff ff       	call   80045d <dev_lookup>
  800507:	89 c3                	mov    %eax,%ebx
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	85 c0                	test   %eax,%eax
  80050e:	78 15                	js     800525 <fd_close+0x72>
		if (dev->dev_close)
  800510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800513:	8b 40 10             	mov    0x10(%eax),%eax
  800516:	85 c0                	test   %eax,%eax
  800518:	74 1b                	je     800535 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	56                   	push   %esi
  80051e:	ff d0                	call   *%eax
  800520:	89 c3                	mov    %eax,%ebx
  800522:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	56                   	push   %esi
  800529:	6a 00                	push   $0x0
  80052b:	e8 d6 fc ff ff       	call   800206 <sys_page_unmap>
	return r;
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	eb ba                	jmp    8004ef <fd_close+0x3c>
			r = 0;
  800535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053a:	eb e9                	jmp    800525 <fd_close+0x72>

0080053c <close>:

int
close(int fdnum)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800545:	50                   	push   %eax
  800546:	ff 75 08             	pushl  0x8(%ebp)
  800549:	e8 b9 fe ff ff       	call   800407 <fd_lookup>
  80054e:	83 c4 08             	add    $0x8,%esp
  800551:	85 c0                	test   %eax,%eax
  800553:	78 10                	js     800565 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	6a 01                	push   $0x1
  80055a:	ff 75 f4             	pushl  -0xc(%ebp)
  80055d:	e8 51 ff ff ff       	call   8004b3 <fd_close>
  800562:	83 c4 10             	add    $0x10,%esp
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <close_all>:

void
close_all(void)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	53                   	push   %ebx
  80056b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80056e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	53                   	push   %ebx
  800577:	e8 c0 ff ff ff       	call   80053c <close>
	for (i = 0; i < MAXFD; i++)
  80057c:	83 c3 01             	add    $0x1,%ebx
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	83 fb 20             	cmp    $0x20,%ebx
  800585:	75 ec                	jne    800573 <close_all+0xc>
}
  800587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	57                   	push   %edi
  800590:	56                   	push   %esi
  800591:	53                   	push   %ebx
  800592:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800595:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	ff 75 08             	pushl  0x8(%ebp)
  80059c:	e8 66 fe ff ff       	call   800407 <fd_lookup>
  8005a1:	89 c3                	mov    %eax,%ebx
  8005a3:	83 c4 08             	add    $0x8,%esp
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	0f 88 81 00 00 00    	js     80062f <dup+0xa3>
		return r;
	close(newfdnum);
  8005ae:	83 ec 0c             	sub    $0xc,%esp
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	e8 83 ff ff ff       	call   80053c <close>

	newfd = INDEX2FD(newfdnum);
  8005b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005bc:	c1 e6 0c             	shl    $0xc,%esi
  8005bf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005c5:	83 c4 04             	add    $0x4,%esp
  8005c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005cb:	e8 d1 fd ff ff       	call   8003a1 <fd2data>
  8005d0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005d2:	89 34 24             	mov    %esi,(%esp)
  8005d5:	e8 c7 fd ff ff       	call   8003a1 <fd2data>
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005df:	89 d8                	mov    %ebx,%eax
  8005e1:	c1 e8 16             	shr    $0x16,%eax
  8005e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005eb:	a8 01                	test   $0x1,%al
  8005ed:	74 11                	je     800600 <dup+0x74>
  8005ef:	89 d8                	mov    %ebx,%eax
  8005f1:	c1 e8 0c             	shr    $0xc,%eax
  8005f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005fb:	f6 c2 01             	test   $0x1,%dl
  8005fe:	75 39                	jne    800639 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800603:	89 d0                	mov    %edx,%eax
  800605:	c1 e8 0c             	shr    $0xc,%eax
  800608:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	25 07 0e 00 00       	and    $0xe07,%eax
  800617:	50                   	push   %eax
  800618:	56                   	push   %esi
  800619:	6a 00                	push   $0x0
  80061b:	52                   	push   %edx
  80061c:	6a 00                	push   $0x0
  80061e:	e8 a1 fb ff ff       	call   8001c4 <sys_page_map>
  800623:	89 c3                	mov    %eax,%ebx
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	85 c0                	test   %eax,%eax
  80062a:	78 31                	js     80065d <dup+0xd1>
		goto err;

	return newfdnum;
  80062c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80062f:	89 d8                	mov    %ebx,%eax
  800631:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800634:	5b                   	pop    %ebx
  800635:	5e                   	pop    %esi
  800636:	5f                   	pop    %edi
  800637:	5d                   	pop    %ebp
  800638:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800639:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800640:	83 ec 0c             	sub    $0xc,%esp
  800643:	25 07 0e 00 00       	and    $0xe07,%eax
  800648:	50                   	push   %eax
  800649:	57                   	push   %edi
  80064a:	6a 00                	push   $0x0
  80064c:	53                   	push   %ebx
  80064d:	6a 00                	push   $0x0
  80064f:	e8 70 fb ff ff       	call   8001c4 <sys_page_map>
  800654:	89 c3                	mov    %eax,%ebx
  800656:	83 c4 20             	add    $0x20,%esp
  800659:	85 c0                	test   %eax,%eax
  80065b:	79 a3                	jns    800600 <dup+0x74>
	sys_page_unmap(0, newfd);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	56                   	push   %esi
  800661:	6a 00                	push   $0x0
  800663:	e8 9e fb ff ff       	call   800206 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800668:	83 c4 08             	add    $0x8,%esp
  80066b:	57                   	push   %edi
  80066c:	6a 00                	push   $0x0
  80066e:	e8 93 fb ff ff       	call   800206 <sys_page_unmap>
	return r;
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	eb b7                	jmp    80062f <dup+0xa3>

00800678 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	53                   	push   %ebx
  80067c:	83 ec 14             	sub    $0x14,%esp
  80067f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800682:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800685:	50                   	push   %eax
  800686:	53                   	push   %ebx
  800687:	e8 7b fd ff ff       	call   800407 <fd_lookup>
  80068c:	83 c4 08             	add    $0x8,%esp
  80068f:	85 c0                	test   %eax,%eax
  800691:	78 3f                	js     8006d2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800699:	50                   	push   %eax
  80069a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069d:	ff 30                	pushl  (%eax)
  80069f:	e8 b9 fd ff ff       	call   80045d <dev_lookup>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	78 27                	js     8006d2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006ae:	8b 42 08             	mov    0x8(%edx),%eax
  8006b1:	83 e0 03             	and    $0x3,%eax
  8006b4:	83 f8 01             	cmp    $0x1,%eax
  8006b7:	74 1e                	je     8006d7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bc:	8b 40 08             	mov    0x8(%eax),%eax
  8006bf:	85 c0                	test   %eax,%eax
  8006c1:	74 35                	je     8006f8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 10             	pushl  0x10(%ebp)
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	52                   	push   %edx
  8006cd:	ff d0                	call   *%eax
  8006cf:	83 c4 10             	add    $0x10,%esp
}
  8006d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8006dc:	8b 40 48             	mov    0x48(%eax),%eax
  8006df:	83 ec 04             	sub    $0x4,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	50                   	push   %eax
  8006e4:	68 d9 22 80 00       	push   $0x8022d9
  8006e9:	e8 9e 0e 00 00       	call   80158c <cprintf>
		return -E_INVAL;
  8006ee:	83 c4 10             	add    $0x10,%esp
  8006f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006f6:	eb da                	jmp    8006d2 <read+0x5a>
		return -E_NOT_SUPP;
  8006f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006fd:	eb d3                	jmp    8006d2 <read+0x5a>

008006ff <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	57                   	push   %edi
  800703:	56                   	push   %esi
  800704:	53                   	push   %ebx
  800705:	83 ec 0c             	sub    $0xc,%esp
  800708:	8b 7d 08             	mov    0x8(%ebp),%edi
  80070b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80070e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800713:	39 f3                	cmp    %esi,%ebx
  800715:	73 25                	jae    80073c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	89 f0                	mov    %esi,%eax
  80071c:	29 d8                	sub    %ebx,%eax
  80071e:	50                   	push   %eax
  80071f:	89 d8                	mov    %ebx,%eax
  800721:	03 45 0c             	add    0xc(%ebp),%eax
  800724:	50                   	push   %eax
  800725:	57                   	push   %edi
  800726:	e8 4d ff ff ff       	call   800678 <read>
		if (m < 0)
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	85 c0                	test   %eax,%eax
  800730:	78 08                	js     80073a <readn+0x3b>
			return m;
		if (m == 0)
  800732:	85 c0                	test   %eax,%eax
  800734:	74 06                	je     80073c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800736:	01 c3                	add    %eax,%ebx
  800738:	eb d9                	jmp    800713 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80073a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80073c:	89 d8                	mov    %ebx,%eax
  80073e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800741:	5b                   	pop    %ebx
  800742:	5e                   	pop    %esi
  800743:	5f                   	pop    %edi
  800744:	5d                   	pop    %ebp
  800745:	c3                   	ret    

00800746 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	53                   	push   %ebx
  80074a:	83 ec 14             	sub    $0x14,%esp
  80074d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800753:	50                   	push   %eax
  800754:	53                   	push   %ebx
  800755:	e8 ad fc ff ff       	call   800407 <fd_lookup>
  80075a:	83 c4 08             	add    $0x8,%esp
  80075d:	85 c0                	test   %eax,%eax
  80075f:	78 3a                	js     80079b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800767:	50                   	push   %eax
  800768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076b:	ff 30                	pushl  (%eax)
  80076d:	e8 eb fc ff ff       	call   80045d <dev_lookup>
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	85 c0                	test   %eax,%eax
  800777:	78 22                	js     80079b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800780:	74 1e                	je     8007a0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800785:	8b 52 0c             	mov    0xc(%edx),%edx
  800788:	85 d2                	test   %edx,%edx
  80078a:	74 35                	je     8007c1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80078c:	83 ec 04             	sub    $0x4,%esp
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	50                   	push   %eax
  800796:	ff d2                	call   *%edx
  800798:	83 c4 10             	add    $0x10,%esp
}
  80079b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8007a5:	8b 40 48             	mov    0x48(%eax),%eax
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	50                   	push   %eax
  8007ad:	68 f5 22 80 00       	push   $0x8022f5
  8007b2:	e8 d5 0d 00 00       	call   80158c <cprintf>
		return -E_INVAL;
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bf:	eb da                	jmp    80079b <write+0x55>
		return -E_NOT_SUPP;
  8007c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007c6:	eb d3                	jmp    80079b <write+0x55>

008007c8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007ce:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	ff 75 08             	pushl  0x8(%ebp)
  8007d5:	e8 2d fc ff ff       	call   800407 <fd_lookup>
  8007da:	83 c4 08             	add    $0x8,%esp
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	78 0e                	js     8007ef <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007e7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    

008007f1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 14             	sub    $0x14,%esp
  8007f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007fe:	50                   	push   %eax
  8007ff:	53                   	push   %ebx
  800800:	e8 02 fc ff ff       	call   800407 <fd_lookup>
  800805:	83 c4 08             	add    $0x8,%esp
  800808:	85 c0                	test   %eax,%eax
  80080a:	78 37                	js     800843 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800816:	ff 30                	pushl  (%eax)
  800818:	e8 40 fc ff ff       	call   80045d <dev_lookup>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	85 c0                	test   %eax,%eax
  800822:	78 1f                	js     800843 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800827:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80082b:	74 1b                	je     800848 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80082d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800830:	8b 52 18             	mov    0x18(%edx),%edx
  800833:	85 d2                	test   %edx,%edx
  800835:	74 32                	je     800869 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	50                   	push   %eax
  80083e:	ff d2                	call   *%edx
  800840:	83 c4 10             	add    $0x10,%esp
}
  800843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800846:	c9                   	leave  
  800847:	c3                   	ret    
			thisenv->env_id, fdnum);
  800848:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80084d:	8b 40 48             	mov    0x48(%eax),%eax
  800850:	83 ec 04             	sub    $0x4,%esp
  800853:	53                   	push   %ebx
  800854:	50                   	push   %eax
  800855:	68 b8 22 80 00       	push   $0x8022b8
  80085a:	e8 2d 0d 00 00       	call   80158c <cprintf>
		return -E_INVAL;
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800867:	eb da                	jmp    800843 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800869:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80086e:	eb d3                	jmp    800843 <ftruncate+0x52>

00800870 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	53                   	push   %ebx
  800874:	83 ec 14             	sub    $0x14,%esp
  800877:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80087a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80087d:	50                   	push   %eax
  80087e:	ff 75 08             	pushl  0x8(%ebp)
  800881:	e8 81 fb ff ff       	call   800407 <fd_lookup>
  800886:	83 c4 08             	add    $0x8,%esp
  800889:	85 c0                	test   %eax,%eax
  80088b:	78 4b                	js     8008d8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	ff 30                	pushl  (%eax)
  800899:	e8 bf fb ff ff       	call   80045d <dev_lookup>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	85 c0                	test   %eax,%eax
  8008a3:	78 33                	js     8008d8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8008a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008ac:	74 2f                	je     8008dd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008ae:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008b1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008b8:	00 00 00 
	stat->st_isdir = 0;
  8008bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008c2:	00 00 00 
	stat->st_dev = dev;
  8008c5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	53                   	push   %ebx
  8008cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d2:	ff 50 14             	call   *0x14(%eax)
  8008d5:	83 c4 10             	add    $0x10,%esp
}
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    
		return -E_NOT_SUPP;
  8008dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008e2:	eb f4                	jmp    8008d8 <fstat+0x68>

008008e4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	6a 00                	push   $0x0
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 e7 01 00 00       	call   800add <open>
  8008f6:	89 c3                	mov    %eax,%ebx
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	78 1b                	js     80091a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	50                   	push   %eax
  800906:	e8 65 ff ff ff       	call   800870 <fstat>
  80090b:	89 c6                	mov    %eax,%esi
	close(fd);
  80090d:	89 1c 24             	mov    %ebx,(%esp)
  800910:	e8 27 fc ff ff       	call   80053c <close>
	return r;
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	89 f3                	mov    %esi,%ebx
}
  80091a:	89 d8                	mov    %ebx,%eax
  80091c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	89 c6                	mov    %eax,%esi
  80092a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80092c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800933:	74 27                	je     80095c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800935:	6a 07                	push   $0x7
  800937:	68 00 50 80 00       	push   $0x805000
  80093c:	56                   	push   %esi
  80093d:	ff 35 00 40 80 00    	pushl  0x804000
  800943:	e8 07 16 00 00       	call   801f4f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800948:	83 c4 0c             	add    $0xc,%esp
  80094b:	6a 00                	push   $0x0
  80094d:	53                   	push   %ebx
  80094e:	6a 00                	push   $0x0
  800950:	e8 93 15 00 00       	call   801ee8 <ipc_recv>
}
  800955:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800958:	5b                   	pop    %ebx
  800959:	5e                   	pop    %esi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	6a 01                	push   $0x1
  800961:	e8 3d 16 00 00       	call   801fa3 <ipc_find_env>
  800966:	a3 00 40 80 00       	mov    %eax,0x804000
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	eb c5                	jmp    800935 <fsipc+0x12>

00800970 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 40 0c             	mov    0xc(%eax),%eax
  80097c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800989:	ba 00 00 00 00       	mov    $0x0,%edx
  80098e:	b8 02 00 00 00       	mov    $0x2,%eax
  800993:	e8 8b ff ff ff       	call   800923 <fsipc>
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <devfile_flush>:
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b0:	b8 06 00 00 00       	mov    $0x6,%eax
  8009b5:	e8 69 ff ff ff       	call   800923 <fsipc>
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <devfile_stat>:
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 04             	sub    $0x4,%esp
  8009c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8009cc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d6:	b8 05 00 00 00       	mov    $0x5,%eax
  8009db:	e8 43 ff ff ff       	call   800923 <fsipc>
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	78 2c                	js     800a10 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	68 00 50 80 00       	push   $0x805000
  8009ec:	53                   	push   %ebx
  8009ed:	e8 b9 11 00 00       	call   801bab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009f2:	a1 80 50 80 00       	mov    0x805080,%eax
  8009f7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009fd:	a1 84 50 80 00       	mov    0x805084,%eax
  800a02:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <devfile_write>:
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 0c             	sub    $0xc,%esp
  800a1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a23:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a28:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a2e:	8b 52 0c             	mov    0xc(%edx),%edx
  800a31:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a37:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a3c:	50                   	push   %eax
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	68 08 50 80 00       	push   $0x805008
  800a45:	e8 ef 12 00 00       	call   801d39 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4f:	b8 04 00 00 00       	mov    $0x4,%eax
  800a54:	e8 ca fe ff ff       	call   800923 <fsipc>
}
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <devfile_read>:
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 40 0c             	mov    0xc(%eax),%eax
  800a69:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a6e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a74:	ba 00 00 00 00       	mov    $0x0,%edx
  800a79:	b8 03 00 00 00       	mov    $0x3,%eax
  800a7e:	e8 a0 fe ff ff       	call   800923 <fsipc>
  800a83:	89 c3                	mov    %eax,%ebx
  800a85:	85 c0                	test   %eax,%eax
  800a87:	78 1f                	js     800aa8 <devfile_read+0x4d>
	assert(r <= n);
  800a89:	39 f0                	cmp    %esi,%eax
  800a8b:	77 24                	ja     800ab1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a8d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a92:	7f 33                	jg     800ac7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a94:	83 ec 04             	sub    $0x4,%esp
  800a97:	50                   	push   %eax
  800a98:	68 00 50 80 00       	push   $0x805000
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	e8 94 12 00 00       	call   801d39 <memmove>
	return r;
  800aa5:	83 c4 10             	add    $0x10,%esp
}
  800aa8:	89 d8                	mov    %ebx,%eax
  800aaa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aad:	5b                   	pop    %ebx
  800aae:	5e                   	pop    %esi
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    
	assert(r <= n);
  800ab1:	68 28 23 80 00       	push   $0x802328
  800ab6:	68 2f 23 80 00       	push   $0x80232f
  800abb:	6a 7b                	push   $0x7b
  800abd:	68 44 23 80 00       	push   $0x802344
  800ac2:	e8 ea 09 00 00       	call   8014b1 <_panic>
	assert(r <= PGSIZE);
  800ac7:	68 4f 23 80 00       	push   $0x80234f
  800acc:	68 2f 23 80 00       	push   $0x80232f
  800ad1:	6a 7c                	push   $0x7c
  800ad3:	68 44 23 80 00       	push   $0x802344
  800ad8:	e8 d4 09 00 00       	call   8014b1 <_panic>

00800add <open>:
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	83 ec 1c             	sub    $0x1c,%esp
  800ae5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ae8:	56                   	push   %esi
  800ae9:	e8 86 10 00 00       	call   801b74 <strlen>
  800aee:	83 c4 10             	add    $0x10,%esp
  800af1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800af6:	7f 6c                	jg     800b64 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800af8:	83 ec 0c             	sub    $0xc,%esp
  800afb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800afe:	50                   	push   %eax
  800aff:	e8 b4 f8 ff ff       	call   8003b8 <fd_alloc>
  800b04:	89 c3                	mov    %eax,%ebx
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	78 3c                	js     800b49 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	56                   	push   %esi
  800b11:	68 00 50 80 00       	push   $0x805000
  800b16:	e8 90 10 00 00       	call   801bab <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b26:	b8 01 00 00 00       	mov    $0x1,%eax
  800b2b:	e8 f3 fd ff ff       	call   800923 <fsipc>
  800b30:	89 c3                	mov    %eax,%ebx
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	85 c0                	test   %eax,%eax
  800b37:	78 19                	js     800b52 <open+0x75>
	return fd2num(fd);
  800b39:	83 ec 0c             	sub    $0xc,%esp
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	e8 4d f8 ff ff       	call   800391 <fd2num>
  800b44:	89 c3                	mov    %eax,%ebx
  800b46:	83 c4 10             	add    $0x10,%esp
}
  800b49:	89 d8                	mov    %ebx,%eax
  800b4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    
		fd_close(fd, 0);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	6a 00                	push   $0x0
  800b57:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5a:	e8 54 f9 ff ff       	call   8004b3 <fd_close>
		return r;
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	eb e5                	jmp    800b49 <open+0x6c>
		return -E_BAD_PATH;
  800b64:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b69:	eb de                	jmp    800b49 <open+0x6c>

00800b6b <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
  800b76:	b8 08 00 00 00       	mov    $0x8,%eax
  800b7b:	e8 a3 fd ff ff       	call   800923 <fsipc>
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b88:	68 5b 23 80 00       	push   $0x80235b
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	e8 16 10 00 00       	call   801bab <strcpy>
	return 0;
}
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <devsock_close>:
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	53                   	push   %ebx
  800ba0:	83 ec 10             	sub    $0x10,%esp
  800ba3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800ba6:	53                   	push   %ebx
  800ba7:	e8 30 14 00 00       	call   801fdc <pageref>
  800bac:	83 c4 10             	add    $0x10,%esp
		return 0;
  800baf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800bb4:	83 f8 01             	cmp    $0x1,%eax
  800bb7:	74 07                	je     800bc0 <devsock_close+0x24>
}
  800bb9:	89 d0                	mov    %edx,%eax
  800bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800bc0:	83 ec 0c             	sub    $0xc,%esp
  800bc3:	ff 73 0c             	pushl  0xc(%ebx)
  800bc6:	e8 b7 02 00 00       	call   800e82 <nsipc_close>
  800bcb:	89 c2                	mov    %eax,%edx
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	eb e7                	jmp    800bb9 <devsock_close+0x1d>

00800bd2 <devsock_write>:
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bd8:	6a 00                	push   $0x0
  800bda:	ff 75 10             	pushl  0x10(%ebp)
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff 70 0c             	pushl  0xc(%eax)
  800be6:	e8 74 03 00 00       	call   800f5f <nsipc_send>
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <devsock_read>:
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bf3:	6a 00                	push   $0x0
  800bf5:	ff 75 10             	pushl  0x10(%ebp)
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff 70 0c             	pushl  0xc(%eax)
  800c01:	e8 ed 02 00 00       	call   800ef3 <nsipc_recv>
}
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <fd2sockid>:
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800c0e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800c11:	52                   	push   %edx
  800c12:	50                   	push   %eax
  800c13:	e8 ef f7 ff ff       	call   800407 <fd_lookup>
  800c18:	83 c4 10             	add    $0x10,%esp
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	78 10                	js     800c2f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c22:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800c28:	39 08                	cmp    %ecx,(%eax)
  800c2a:	75 05                	jne    800c31 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c2c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    
		return -E_NOT_SUPP;
  800c31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c36:	eb f7                	jmp    800c2f <fd2sockid+0x27>

00800c38 <alloc_sockfd>:
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	83 ec 1c             	sub    $0x1c,%esp
  800c40:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c45:	50                   	push   %eax
  800c46:	e8 6d f7 ff ff       	call   8003b8 <fd_alloc>
  800c4b:	89 c3                	mov    %eax,%ebx
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	85 c0                	test   %eax,%eax
  800c52:	78 43                	js     800c97 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c54:	83 ec 04             	sub    $0x4,%esp
  800c57:	68 07 04 00 00       	push   $0x407
  800c5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5f:	6a 00                	push   $0x0
  800c61:	e8 1b f5 ff ff       	call   800181 <sys_page_alloc>
  800c66:	89 c3                	mov    %eax,%ebx
  800c68:	83 c4 10             	add    $0x10,%esp
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	78 28                	js     800c97 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c72:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c78:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c7d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c84:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c87:	83 ec 0c             	sub    $0xc,%esp
  800c8a:	50                   	push   %eax
  800c8b:	e8 01 f7 ff ff       	call   800391 <fd2num>
  800c90:	89 c3                	mov    %eax,%ebx
  800c92:	83 c4 10             	add    $0x10,%esp
  800c95:	eb 0c                	jmp    800ca3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c97:	83 ec 0c             	sub    $0xc,%esp
  800c9a:	56                   	push   %esi
  800c9b:	e8 e2 01 00 00       	call   800e82 <nsipc_close>
		return r;
  800ca0:	83 c4 10             	add    $0x10,%esp
}
  800ca3:	89 d8                	mov    %ebx,%eax
  800ca5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <accept>:
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	e8 4e ff ff ff       	call   800c08 <fd2sockid>
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	78 1b                	js     800cd9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800cbe:	83 ec 04             	sub    $0x4,%esp
  800cc1:	ff 75 10             	pushl  0x10(%ebp)
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	50                   	push   %eax
  800cc8:	e8 0e 01 00 00       	call   800ddb <nsipc_accept>
  800ccd:	83 c4 10             	add    $0x10,%esp
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	78 05                	js     800cd9 <accept+0x2d>
	return alloc_sockfd(r);
  800cd4:	e8 5f ff ff ff       	call   800c38 <alloc_sockfd>
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <bind>:
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	e8 1f ff ff ff       	call   800c08 <fd2sockid>
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	78 12                	js     800cff <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	ff 75 10             	pushl  0x10(%ebp)
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	50                   	push   %eax
  800cf7:	e8 2f 01 00 00       	call   800e2b <nsipc_bind>
  800cfc:	83 c4 10             	add    $0x10,%esp
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <shutdown>:
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	e8 f9 fe ff ff       	call   800c08 <fd2sockid>
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	78 0f                	js     800d22 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800d13:	83 ec 08             	sub    $0x8,%esp
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	50                   	push   %eax
  800d1a:	e8 41 01 00 00       	call   800e60 <nsipc_shutdown>
  800d1f:	83 c4 10             	add    $0x10,%esp
}
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <connect>:
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	e8 d6 fe ff ff       	call   800c08 <fd2sockid>
  800d32:	85 c0                	test   %eax,%eax
  800d34:	78 12                	js     800d48 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	ff 75 10             	pushl  0x10(%ebp)
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	50                   	push   %eax
  800d40:	e8 57 01 00 00       	call   800e9c <nsipc_connect>
  800d45:	83 c4 10             	add    $0x10,%esp
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <listen>:
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	e8 b0 fe ff ff       	call   800c08 <fd2sockid>
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	78 0f                	js     800d6b <listen+0x21>
	return nsipc_listen(r, backlog);
  800d5c:	83 ec 08             	sub    $0x8,%esp
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	50                   	push   %eax
  800d63:	e8 69 01 00 00       	call   800ed1 <nsipc_listen>
  800d68:	83 c4 10             	add    $0x10,%esp
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <socket>:

int
socket(int domain, int type, int protocol)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d73:	ff 75 10             	pushl  0x10(%ebp)
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	ff 75 08             	pushl  0x8(%ebp)
  800d7c:	e8 3c 02 00 00       	call   800fbd <nsipc_socket>
  800d81:	83 c4 10             	add    $0x10,%esp
  800d84:	85 c0                	test   %eax,%eax
  800d86:	78 05                	js     800d8d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d88:	e8 ab fe ff ff       	call   800c38 <alloc_sockfd>
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	53                   	push   %ebx
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d98:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d9f:	74 26                	je     800dc7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800da1:	6a 07                	push   $0x7
  800da3:	68 00 60 80 00       	push   $0x806000
  800da8:	53                   	push   %ebx
  800da9:	ff 35 04 40 80 00    	pushl  0x804004
  800daf:	e8 9b 11 00 00       	call   801f4f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800db4:	83 c4 0c             	add    $0xc,%esp
  800db7:	6a 00                	push   $0x0
  800db9:	6a 00                	push   $0x0
  800dbb:	6a 00                	push   $0x0
  800dbd:	e8 26 11 00 00       	call   801ee8 <ipc_recv>
}
  800dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800dc7:	83 ec 0c             	sub    $0xc,%esp
  800dca:	6a 02                	push   $0x2
  800dcc:	e8 d2 11 00 00       	call   801fa3 <ipc_find_env>
  800dd1:	a3 04 40 80 00       	mov    %eax,0x804004
  800dd6:	83 c4 10             	add    $0x10,%esp
  800dd9:	eb c6                	jmp    800da1 <nsipc+0x12>

00800ddb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800deb:	8b 06                	mov    (%esi),%eax
  800ded:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800df2:	b8 01 00 00 00       	mov    $0x1,%eax
  800df7:	e8 93 ff ff ff       	call   800d8f <nsipc>
  800dfc:	89 c3                	mov    %eax,%ebx
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	78 20                	js     800e22 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800e02:	83 ec 04             	sub    $0x4,%esp
  800e05:	ff 35 10 60 80 00    	pushl  0x806010
  800e0b:	68 00 60 80 00       	push   $0x806000
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	e8 21 0f 00 00       	call   801d39 <memmove>
		*addrlen = ret->ret_addrlen;
  800e18:	a1 10 60 80 00       	mov    0x806010,%eax
  800e1d:	89 06                	mov    %eax,(%esi)
  800e1f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800e22:	89 d8                	mov    %ebx,%eax
  800e24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 08             	sub    $0x8,%esp
  800e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e3d:	53                   	push   %ebx
  800e3e:	ff 75 0c             	pushl  0xc(%ebp)
  800e41:	68 04 60 80 00       	push   $0x806004
  800e46:	e8 ee 0e 00 00       	call   801d39 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e4b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e51:	b8 02 00 00 00       	mov    $0x2,%eax
  800e56:	e8 34 ff ff ff       	call   800d8f <nsipc>
}
  800e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e76:	b8 03 00 00 00       	mov    $0x3,%eax
  800e7b:	e8 0f ff ff ff       	call   800d8f <nsipc>
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <nsipc_close>:

int
nsipc_close(int s)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e90:	b8 04 00 00 00       	mov    $0x4,%eax
  800e95:	e8 f5 fe ff ff       	call   800d8f <nsipc>
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800eae:	53                   	push   %ebx
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	68 04 60 80 00       	push   $0x806004
  800eb7:	e8 7d 0e 00 00       	call   801d39 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800ebc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800ec2:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec7:	e8 c3 fe ff ff       	call   800d8f <nsipc>
}
  800ecc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ee7:	b8 06 00 00 00       	mov    $0x6,%eax
  800eec:	e8 9e fe ff ff       	call   800d8f <nsipc>
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800f03:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800f09:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0c:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800f11:	b8 07 00 00 00       	mov    $0x7,%eax
  800f16:	e8 74 fe ff ff       	call   800d8f <nsipc>
  800f1b:	89 c3                	mov    %eax,%ebx
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	78 1f                	js     800f40 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800f21:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800f26:	7f 21                	jg     800f49 <nsipc_recv+0x56>
  800f28:	39 c6                	cmp    %eax,%esi
  800f2a:	7c 1d                	jl     800f49 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f2c:	83 ec 04             	sub    $0x4,%esp
  800f2f:	50                   	push   %eax
  800f30:	68 00 60 80 00       	push   $0x806000
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	e8 fc 0d 00 00       	call   801d39 <memmove>
  800f3d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f40:	89 d8                	mov    %ebx,%eax
  800f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f49:	68 67 23 80 00       	push   $0x802367
  800f4e:	68 2f 23 80 00       	push   $0x80232f
  800f53:	6a 62                	push   $0x62
  800f55:	68 7c 23 80 00       	push   $0x80237c
  800f5a:	e8 52 05 00 00       	call   8014b1 <_panic>

00800f5f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	53                   	push   %ebx
  800f63:	83 ec 04             	sub    $0x4,%esp
  800f66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f71:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f77:	7f 2e                	jg     800fa7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f79:	83 ec 04             	sub    $0x4,%esp
  800f7c:	53                   	push   %ebx
  800f7d:	ff 75 0c             	pushl  0xc(%ebp)
  800f80:	68 0c 60 80 00       	push   $0x80600c
  800f85:	e8 af 0d 00 00       	call   801d39 <memmove>
	nsipcbuf.send.req_size = size;
  800f8a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f90:	8b 45 14             	mov    0x14(%ebp),%eax
  800f93:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f98:	b8 08 00 00 00       	mov    $0x8,%eax
  800f9d:	e8 ed fd ff ff       	call   800d8f <nsipc>
}
  800fa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    
	assert(size < 1600);
  800fa7:	68 88 23 80 00       	push   $0x802388
  800fac:	68 2f 23 80 00       	push   $0x80232f
  800fb1:	6a 6d                	push   $0x6d
  800fb3:	68 7c 23 80 00       	push   $0x80237c
  800fb8:	e8 f4 04 00 00       	call   8014b1 <_panic>

00800fbd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800fdb:	b8 09 00 00 00       	mov    $0x9,%eax
  800fe0:	e8 aa fd ff ff       	call   800d8f <nsipc>
}
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
  800fec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 a7 f3 ff ff       	call   8003a1 <fd2data>
  800ffa:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800ffc:	83 c4 08             	add    $0x8,%esp
  800fff:	68 94 23 80 00       	push   $0x802394
  801004:	53                   	push   %ebx
  801005:	e8 a1 0b 00 00       	call   801bab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80100a:	8b 46 04             	mov    0x4(%esi),%eax
  80100d:	2b 06                	sub    (%esi),%eax
  80100f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801015:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80101c:	00 00 00 
	stat->st_dev = &devpipe;
  80101f:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801026:	30 80 00 
	return 0;
}
  801029:	b8 00 00 00 00       	mov    $0x0,%eax
  80102e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	53                   	push   %ebx
  801039:	83 ec 0c             	sub    $0xc,%esp
  80103c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80103f:	53                   	push   %ebx
  801040:	6a 00                	push   $0x0
  801042:	e8 bf f1 ff ff       	call   800206 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801047:	89 1c 24             	mov    %ebx,(%esp)
  80104a:	e8 52 f3 ff ff       	call   8003a1 <fd2data>
  80104f:	83 c4 08             	add    $0x8,%esp
  801052:	50                   	push   %eax
  801053:	6a 00                	push   $0x0
  801055:	e8 ac f1 ff ff       	call   800206 <sys_page_unmap>
}
  80105a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105d:	c9                   	leave  
  80105e:	c3                   	ret    

0080105f <_pipeisclosed>:
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
  801065:	83 ec 1c             	sub    $0x1c,%esp
  801068:	89 c7                	mov    %eax,%edi
  80106a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80106c:	a1 08 40 80 00       	mov    0x804008,%eax
  801071:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	57                   	push   %edi
  801078:	e8 5f 0f 00 00       	call   801fdc <pageref>
  80107d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801080:	89 34 24             	mov    %esi,(%esp)
  801083:	e8 54 0f 00 00       	call   801fdc <pageref>
		nn = thisenv->env_runs;
  801088:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80108e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	39 cb                	cmp    %ecx,%ebx
  801096:	74 1b                	je     8010b3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801098:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80109b:	75 cf                	jne    80106c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80109d:	8b 42 58             	mov    0x58(%edx),%eax
  8010a0:	6a 01                	push   $0x1
  8010a2:	50                   	push   %eax
  8010a3:	53                   	push   %ebx
  8010a4:	68 9b 23 80 00       	push   $0x80239b
  8010a9:	e8 de 04 00 00       	call   80158c <cprintf>
  8010ae:	83 c4 10             	add    $0x10,%esp
  8010b1:	eb b9                	jmp    80106c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8010b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010b6:	0f 94 c0             	sete   %al
  8010b9:	0f b6 c0             	movzbl %al,%eax
}
  8010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <devpipe_write>:
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
  8010ca:	83 ec 28             	sub    $0x28,%esp
  8010cd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010d0:	56                   	push   %esi
  8010d1:	e8 cb f2 ff ff       	call   8003a1 <fd2data>
  8010d6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	bf 00 00 00 00       	mov    $0x0,%edi
  8010e0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010e3:	74 4f                	je     801134 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010e5:	8b 43 04             	mov    0x4(%ebx),%eax
  8010e8:	8b 0b                	mov    (%ebx),%ecx
  8010ea:	8d 51 20             	lea    0x20(%ecx),%edx
  8010ed:	39 d0                	cmp    %edx,%eax
  8010ef:	72 14                	jb     801105 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010f1:	89 da                	mov    %ebx,%edx
  8010f3:	89 f0                	mov    %esi,%eax
  8010f5:	e8 65 ff ff ff       	call   80105f <_pipeisclosed>
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 3a                	jne    801138 <devpipe_write+0x74>
			sys_yield();
  8010fe:	e8 5f f0 ff ff       	call   800162 <sys_yield>
  801103:	eb e0                	jmp    8010e5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801105:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801108:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80110c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80110f:	89 c2                	mov    %eax,%edx
  801111:	c1 fa 1f             	sar    $0x1f,%edx
  801114:	89 d1                	mov    %edx,%ecx
  801116:	c1 e9 1b             	shr    $0x1b,%ecx
  801119:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80111c:	83 e2 1f             	and    $0x1f,%edx
  80111f:	29 ca                	sub    %ecx,%edx
  801121:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801125:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801129:	83 c0 01             	add    $0x1,%eax
  80112c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80112f:	83 c7 01             	add    $0x1,%edi
  801132:	eb ac                	jmp    8010e0 <devpipe_write+0x1c>
	return i;
  801134:	89 f8                	mov    %edi,%eax
  801136:	eb 05                	jmp    80113d <devpipe_write+0x79>
				return 0;
  801138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801140:	5b                   	pop    %ebx
  801141:	5e                   	pop    %esi
  801142:	5f                   	pop    %edi
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <devpipe_read>:
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
  80114b:	83 ec 18             	sub    $0x18,%esp
  80114e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801151:	57                   	push   %edi
  801152:	e8 4a f2 ff ff       	call   8003a1 <fd2data>
  801157:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	be 00 00 00 00       	mov    $0x0,%esi
  801161:	3b 75 10             	cmp    0x10(%ebp),%esi
  801164:	74 47                	je     8011ad <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801166:	8b 03                	mov    (%ebx),%eax
  801168:	3b 43 04             	cmp    0x4(%ebx),%eax
  80116b:	75 22                	jne    80118f <devpipe_read+0x4a>
			if (i > 0)
  80116d:	85 f6                	test   %esi,%esi
  80116f:	75 14                	jne    801185 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801171:	89 da                	mov    %ebx,%edx
  801173:	89 f8                	mov    %edi,%eax
  801175:	e8 e5 fe ff ff       	call   80105f <_pipeisclosed>
  80117a:	85 c0                	test   %eax,%eax
  80117c:	75 33                	jne    8011b1 <devpipe_read+0x6c>
			sys_yield();
  80117e:	e8 df ef ff ff       	call   800162 <sys_yield>
  801183:	eb e1                	jmp    801166 <devpipe_read+0x21>
				return i;
  801185:	89 f0                	mov    %esi,%eax
}
  801187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80118f:	99                   	cltd   
  801190:	c1 ea 1b             	shr    $0x1b,%edx
  801193:	01 d0                	add    %edx,%eax
  801195:	83 e0 1f             	and    $0x1f,%eax
  801198:	29 d0                	sub    %edx,%eax
  80119a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80119f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8011a5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8011a8:	83 c6 01             	add    $0x1,%esi
  8011ab:	eb b4                	jmp    801161 <devpipe_read+0x1c>
	return i;
  8011ad:	89 f0                	mov    %esi,%eax
  8011af:	eb d6                	jmp    801187 <devpipe_read+0x42>
				return 0;
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b6:	eb cf                	jmp    801187 <devpipe_read+0x42>

008011b8 <pipe>:
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	56                   	push   %esi
  8011bc:	53                   	push   %ebx
  8011bd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c3:	50                   	push   %eax
  8011c4:	e8 ef f1 ff ff       	call   8003b8 <fd_alloc>
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 5b                	js     80122d <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	68 07 04 00 00       	push   $0x407
  8011da:	ff 75 f4             	pushl  -0xc(%ebp)
  8011dd:	6a 00                	push   $0x0
  8011df:	e8 9d ef ff ff       	call   800181 <sys_page_alloc>
  8011e4:	89 c3                	mov    %eax,%ebx
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	78 40                	js     80122d <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011ed:	83 ec 0c             	sub    $0xc,%esp
  8011f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 bf f1 ff ff       	call   8003b8 <fd_alloc>
  8011f9:	89 c3                	mov    %eax,%ebx
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	78 1b                	js     80121d <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	68 07 04 00 00       	push   $0x407
  80120a:	ff 75 f0             	pushl  -0x10(%ebp)
  80120d:	6a 00                	push   $0x0
  80120f:	e8 6d ef ff ff       	call   800181 <sys_page_alloc>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	79 19                	jns    801236 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	ff 75 f4             	pushl  -0xc(%ebp)
  801223:	6a 00                	push   $0x0
  801225:	e8 dc ef ff ff       	call   800206 <sys_page_unmap>
  80122a:	83 c4 10             	add    $0x10,%esp
}
  80122d:	89 d8                	mov    %ebx,%eax
  80122f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801232:	5b                   	pop    %ebx
  801233:	5e                   	pop    %esi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    
	va = fd2data(fd0);
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	ff 75 f4             	pushl  -0xc(%ebp)
  80123c:	e8 60 f1 ff ff       	call   8003a1 <fd2data>
  801241:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801243:	83 c4 0c             	add    $0xc,%esp
  801246:	68 07 04 00 00       	push   $0x407
  80124b:	50                   	push   %eax
  80124c:	6a 00                	push   $0x0
  80124e:	e8 2e ef ff ff       	call   800181 <sys_page_alloc>
  801253:	89 c3                	mov    %eax,%ebx
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	0f 88 8c 00 00 00    	js     8012ec <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	ff 75 f0             	pushl  -0x10(%ebp)
  801266:	e8 36 f1 ff ff       	call   8003a1 <fd2data>
  80126b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801272:	50                   	push   %eax
  801273:	6a 00                	push   $0x0
  801275:	56                   	push   %esi
  801276:	6a 00                	push   $0x0
  801278:	e8 47 ef ff ff       	call   8001c4 <sys_page_map>
  80127d:	89 c3                	mov    %eax,%ebx
  80127f:	83 c4 20             	add    $0x20,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	78 58                	js     8012de <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801289:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80128f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801294:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80129b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8012a4:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8012a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8012b0:	83 ec 0c             	sub    $0xc,%esp
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	e8 d6 f0 ff ff       	call   800391 <fd2num>
  8012bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012be:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8012c0:	83 c4 04             	add    $0x4,%esp
  8012c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8012c6:	e8 c6 f0 ff ff       	call   800391 <fd2num>
  8012cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ce:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d9:	e9 4f ff ff ff       	jmp    80122d <pipe+0x75>
	sys_page_unmap(0, va);
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	56                   	push   %esi
  8012e2:	6a 00                	push   $0x0
  8012e4:	e8 1d ef ff ff       	call   800206 <sys_page_unmap>
  8012e9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f2:	6a 00                	push   $0x0
  8012f4:	e8 0d ef ff ff       	call   800206 <sys_page_unmap>
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	e9 1c ff ff ff       	jmp    80121d <pipe+0x65>

00801301 <pipeisclosed>:
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801307:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130a:	50                   	push   %eax
  80130b:	ff 75 08             	pushl  0x8(%ebp)
  80130e:	e8 f4 f0 ff ff       	call   800407 <fd_lookup>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	78 18                	js     801332 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80131a:	83 ec 0c             	sub    $0xc,%esp
  80131d:	ff 75 f4             	pushl  -0xc(%ebp)
  801320:	e8 7c f0 ff ff       	call   8003a1 <fd2data>
	return _pipeisclosed(fd, p);
  801325:	89 c2                	mov    %eax,%edx
  801327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132a:	e8 30 fd ff ff       	call   80105f <_pipeisclosed>
  80132f:	83 c4 10             	add    $0x10,%esp
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801337:	b8 00 00 00 00       	mov    $0x0,%eax
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801344:	68 b3 23 80 00       	push   $0x8023b3
  801349:	ff 75 0c             	pushl  0xc(%ebp)
  80134c:	e8 5a 08 00 00       	call   801bab <strcpy>
	return 0;
}
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <devcons_write>:
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	57                   	push   %edi
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801364:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801369:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80136f:	eb 2f                	jmp    8013a0 <devcons_write+0x48>
		m = n - tot;
  801371:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801374:	29 f3                	sub    %esi,%ebx
  801376:	83 fb 7f             	cmp    $0x7f,%ebx
  801379:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80137e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	53                   	push   %ebx
  801385:	89 f0                	mov    %esi,%eax
  801387:	03 45 0c             	add    0xc(%ebp),%eax
  80138a:	50                   	push   %eax
  80138b:	57                   	push   %edi
  80138c:	e8 a8 09 00 00       	call   801d39 <memmove>
		sys_cputs(buf, m);
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	53                   	push   %ebx
  801395:	57                   	push   %edi
  801396:	e8 2a ed ff ff       	call   8000c5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80139b:	01 de                	add    %ebx,%esi
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013a3:	72 cc                	jb     801371 <devcons_write+0x19>
}
  8013a5:	89 f0                	mov    %esi,%eax
  8013a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5f                   	pop    %edi
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    

008013af <devcons_read>:
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013be:	75 07                	jne    8013c7 <devcons_read+0x18>
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    
		sys_yield();
  8013c2:	e8 9b ed ff ff       	call   800162 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013c7:	e8 17 ed ff ff       	call   8000e3 <sys_cgetc>
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	74 f2                	je     8013c2 <devcons_read+0x13>
	if (c < 0)
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 ec                	js     8013c0 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013d4:	83 f8 04             	cmp    $0x4,%eax
  8013d7:	74 0c                	je     8013e5 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dc:	88 02                	mov    %al,(%edx)
	return 1;
  8013de:	b8 01 00 00 00       	mov    $0x1,%eax
  8013e3:	eb db                	jmp    8013c0 <devcons_read+0x11>
		return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ea:	eb d4                	jmp    8013c0 <devcons_read+0x11>

008013ec <cputchar>:
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013f8:	6a 01                	push   $0x1
  8013fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013fd:	50                   	push   %eax
  8013fe:	e8 c2 ec ff ff       	call   8000c5 <sys_cputs>
}
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <getchar>:
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80140e:	6a 01                	push   $0x1
  801410:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801413:	50                   	push   %eax
  801414:	6a 00                	push   $0x0
  801416:	e8 5d f2 ff ff       	call   800678 <read>
	if (r < 0)
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 08                	js     80142a <getchar+0x22>
	if (r < 1)
  801422:	85 c0                	test   %eax,%eax
  801424:	7e 06                	jle    80142c <getchar+0x24>
	return c;
  801426:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    
		return -E_EOF;
  80142c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801431:	eb f7                	jmp    80142a <getchar+0x22>

00801433 <iscons>:
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 c2 ef ff ff       	call   800407 <fd_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 11                	js     80145d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801455:	39 10                	cmp    %edx,(%eax)
  801457:	0f 94 c0             	sete   %al
  80145a:	0f b6 c0             	movzbl %al,%eax
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <opencons>:
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801468:	50                   	push   %eax
  801469:	e8 4a ef ff ff       	call   8003b8 <fd_alloc>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 3a                	js     8014af <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	68 07 04 00 00       	push   $0x407
  80147d:	ff 75 f4             	pushl  -0xc(%ebp)
  801480:	6a 00                	push   $0x0
  801482:	e8 fa ec ff ff       	call   800181 <sys_page_alloc>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 21                	js     8014af <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80148e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801491:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801497:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014a3:	83 ec 0c             	sub    $0xc,%esp
  8014a6:	50                   	push   %eax
  8014a7:	e8 e5 ee ff ff       	call   800391 <fd2num>
  8014ac:	83 c4 10             	add    $0x10,%esp
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	56                   	push   %esi
  8014b5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014b6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014b9:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014bf:	e8 7f ec ff ff       	call   800143 <sys_getenvid>
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	ff 75 08             	pushl  0x8(%ebp)
  8014cd:	56                   	push   %esi
  8014ce:	50                   	push   %eax
  8014cf:	68 c0 23 80 00       	push   $0x8023c0
  8014d4:	e8 b3 00 00 00       	call   80158c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014d9:	83 c4 18             	add    $0x18,%esp
  8014dc:	53                   	push   %ebx
  8014dd:	ff 75 10             	pushl  0x10(%ebp)
  8014e0:	e8 56 00 00 00       	call   80153b <vcprintf>
	cprintf("\n");
  8014e5:	c7 04 24 ac 23 80 00 	movl   $0x8023ac,(%esp)
  8014ec:	e8 9b 00 00 00       	call   80158c <cprintf>
  8014f1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014f4:	cc                   	int3   
  8014f5:	eb fd                	jmp    8014f4 <_panic+0x43>

008014f7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801501:	8b 13                	mov    (%ebx),%edx
  801503:	8d 42 01             	lea    0x1(%edx),%eax
  801506:	89 03                	mov    %eax,(%ebx)
  801508:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80150f:	3d ff 00 00 00       	cmp    $0xff,%eax
  801514:	74 09                	je     80151f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801516:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80151a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	68 ff 00 00 00       	push   $0xff
  801527:	8d 43 08             	lea    0x8(%ebx),%eax
  80152a:	50                   	push   %eax
  80152b:	e8 95 eb ff ff       	call   8000c5 <sys_cputs>
		b->idx = 0;
  801530:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	eb db                	jmp    801516 <putch+0x1f>

0080153b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801544:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80154b:	00 00 00 
	b.cnt = 0;
  80154e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801555:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	ff 75 08             	pushl  0x8(%ebp)
  80155e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801564:	50                   	push   %eax
  801565:	68 f7 14 80 00       	push   $0x8014f7
  80156a:	e8 1a 01 00 00       	call   801689 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80156f:	83 c4 08             	add    $0x8,%esp
  801572:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801578:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80157e:	50                   	push   %eax
  80157f:	e8 41 eb ff ff       	call   8000c5 <sys_cputs>

	return b.cnt;
}
  801584:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801592:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801595:	50                   	push   %eax
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	e8 9d ff ff ff       	call   80153b <vcprintf>
	va_end(ap);

	return cnt;
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	57                   	push   %edi
  8015a4:	56                   	push   %esi
  8015a5:	53                   	push   %ebx
  8015a6:	83 ec 1c             	sub    $0x1c,%esp
  8015a9:	89 c7                	mov    %eax,%edi
  8015ab:	89 d6                	mov    %edx,%esi
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015c4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015c7:	39 d3                	cmp    %edx,%ebx
  8015c9:	72 05                	jb     8015d0 <printnum+0x30>
  8015cb:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015ce:	77 7a                	ja     80164a <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	ff 75 18             	pushl  0x18(%ebp)
  8015d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015dc:	53                   	push   %ebx
  8015dd:	ff 75 10             	pushl  0x10(%ebp)
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8015e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8015ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8015ef:	e8 2c 0a 00 00       	call   802020 <__udivdi3>
  8015f4:	83 c4 18             	add    $0x18,%esp
  8015f7:	52                   	push   %edx
  8015f8:	50                   	push   %eax
  8015f9:	89 f2                	mov    %esi,%edx
  8015fb:	89 f8                	mov    %edi,%eax
  8015fd:	e8 9e ff ff ff       	call   8015a0 <printnum>
  801602:	83 c4 20             	add    $0x20,%esp
  801605:	eb 13                	jmp    80161a <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	56                   	push   %esi
  80160b:	ff 75 18             	pushl  0x18(%ebp)
  80160e:	ff d7                	call   *%edi
  801610:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801613:	83 eb 01             	sub    $0x1,%ebx
  801616:	85 db                	test   %ebx,%ebx
  801618:	7f ed                	jg     801607 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	56                   	push   %esi
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	ff 75 e4             	pushl  -0x1c(%ebp)
  801624:	ff 75 e0             	pushl  -0x20(%ebp)
  801627:	ff 75 dc             	pushl  -0x24(%ebp)
  80162a:	ff 75 d8             	pushl  -0x28(%ebp)
  80162d:	e8 0e 0b 00 00       	call   802140 <__umoddi3>
  801632:	83 c4 14             	add    $0x14,%esp
  801635:	0f be 80 e3 23 80 00 	movsbl 0x8023e3(%eax),%eax
  80163c:	50                   	push   %eax
  80163d:	ff d7                	call   *%edi
}
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5f                   	pop    %edi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    
  80164a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164d:	eb c4                	jmp    801613 <printnum+0x73>

0080164f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801655:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801659:	8b 10                	mov    (%eax),%edx
  80165b:	3b 50 04             	cmp    0x4(%eax),%edx
  80165e:	73 0a                	jae    80166a <sprintputch+0x1b>
		*b->buf++ = ch;
  801660:	8d 4a 01             	lea    0x1(%edx),%ecx
  801663:	89 08                	mov    %ecx,(%eax)
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	88 02                	mov    %al,(%edx)
}
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <printfmt>:
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801672:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801675:	50                   	push   %eax
  801676:	ff 75 10             	pushl  0x10(%ebp)
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 05 00 00 00       	call   801689 <vprintfmt>
}
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <vprintfmt>:
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	57                   	push   %edi
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
  80168f:	83 ec 2c             	sub    $0x2c,%esp
  801692:	8b 75 08             	mov    0x8(%ebp),%esi
  801695:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801698:	8b 7d 10             	mov    0x10(%ebp),%edi
  80169b:	e9 c1 03 00 00       	jmp    801a61 <vprintfmt+0x3d8>
		padc = ' ';
  8016a0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8016a4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8016ab:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8016b2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016b9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016be:	8d 47 01             	lea    0x1(%edi),%eax
  8016c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016c4:	0f b6 17             	movzbl (%edi),%edx
  8016c7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016ca:	3c 55                	cmp    $0x55,%al
  8016cc:	0f 87 12 04 00 00    	ja     801ae4 <vprintfmt+0x45b>
  8016d2:	0f b6 c0             	movzbl %al,%eax
  8016d5:	ff 24 85 20 25 80 00 	jmp    *0x802520(,%eax,4)
  8016dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016df:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016e3:	eb d9                	jmp    8016be <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016e8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016ec:	eb d0                	jmp    8016be <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016ee:	0f b6 d2             	movzbl %dl,%edx
  8016f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016fc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016ff:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801703:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801706:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801709:	83 f9 09             	cmp    $0x9,%ecx
  80170c:	77 55                	ja     801763 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80170e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801711:	eb e9                	jmp    8016fc <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801713:	8b 45 14             	mov    0x14(%ebp),%eax
  801716:	8b 00                	mov    (%eax),%eax
  801718:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80171b:	8b 45 14             	mov    0x14(%ebp),%eax
  80171e:	8d 40 04             	lea    0x4(%eax),%eax
  801721:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801724:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801727:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80172b:	79 91                	jns    8016be <vprintfmt+0x35>
				width = precision, precision = -1;
  80172d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801730:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801733:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80173a:	eb 82                	jmp    8016be <vprintfmt+0x35>
  80173c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173f:	85 c0                	test   %eax,%eax
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	0f 49 d0             	cmovns %eax,%edx
  801749:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80174c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80174f:	e9 6a ff ff ff       	jmp    8016be <vprintfmt+0x35>
  801754:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801757:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80175e:	e9 5b ff ff ff       	jmp    8016be <vprintfmt+0x35>
  801763:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801766:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801769:	eb bc                	jmp    801727 <vprintfmt+0x9e>
			lflag++;
  80176b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80176e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801771:	e9 48 ff ff ff       	jmp    8016be <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801776:	8b 45 14             	mov    0x14(%ebp),%eax
  801779:	8d 78 04             	lea    0x4(%eax),%edi
  80177c:	83 ec 08             	sub    $0x8,%esp
  80177f:	53                   	push   %ebx
  801780:	ff 30                	pushl  (%eax)
  801782:	ff d6                	call   *%esi
			break;
  801784:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801787:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80178a:	e9 cf 02 00 00       	jmp    801a5e <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80178f:	8b 45 14             	mov    0x14(%ebp),%eax
  801792:	8d 78 04             	lea    0x4(%eax),%edi
  801795:	8b 00                	mov    (%eax),%eax
  801797:	99                   	cltd   
  801798:	31 d0                	xor    %edx,%eax
  80179a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80179c:	83 f8 0f             	cmp    $0xf,%eax
  80179f:	7f 23                	jg     8017c4 <vprintfmt+0x13b>
  8017a1:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  8017a8:	85 d2                	test   %edx,%edx
  8017aa:	74 18                	je     8017c4 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8017ac:	52                   	push   %edx
  8017ad:	68 41 23 80 00       	push   $0x802341
  8017b2:	53                   	push   %ebx
  8017b3:	56                   	push   %esi
  8017b4:	e8 b3 fe ff ff       	call   80166c <printfmt>
  8017b9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017bc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017bf:	e9 9a 02 00 00       	jmp    801a5e <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8017c4:	50                   	push   %eax
  8017c5:	68 fb 23 80 00       	push   $0x8023fb
  8017ca:	53                   	push   %ebx
  8017cb:	56                   	push   %esi
  8017cc:	e8 9b fe ff ff       	call   80166c <printfmt>
  8017d1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017d4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017d7:	e9 82 02 00 00       	jmp    801a5e <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	83 c0 04             	add    $0x4,%eax
  8017e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e8:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017ea:	85 ff                	test   %edi,%edi
  8017ec:	b8 f4 23 80 00       	mov    $0x8023f4,%eax
  8017f1:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017f8:	0f 8e bd 00 00 00    	jle    8018bb <vprintfmt+0x232>
  8017fe:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801802:	75 0e                	jne    801812 <vprintfmt+0x189>
  801804:	89 75 08             	mov    %esi,0x8(%ebp)
  801807:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80180a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80180d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801810:	eb 6d                	jmp    80187f <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	ff 75 d0             	pushl  -0x30(%ebp)
  801818:	57                   	push   %edi
  801819:	e8 6e 03 00 00       	call   801b8c <strnlen>
  80181e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801821:	29 c1                	sub    %eax,%ecx
  801823:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801826:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801829:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80182d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801830:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801833:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801835:	eb 0f                	jmp    801846 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801837:	83 ec 08             	sub    $0x8,%esp
  80183a:	53                   	push   %ebx
  80183b:	ff 75 e0             	pushl  -0x20(%ebp)
  80183e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801840:	83 ef 01             	sub    $0x1,%edi
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	85 ff                	test   %edi,%edi
  801848:	7f ed                	jg     801837 <vprintfmt+0x1ae>
  80184a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80184d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801850:	85 c9                	test   %ecx,%ecx
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	0f 49 c1             	cmovns %ecx,%eax
  80185a:	29 c1                	sub    %eax,%ecx
  80185c:	89 75 08             	mov    %esi,0x8(%ebp)
  80185f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801862:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801865:	89 cb                	mov    %ecx,%ebx
  801867:	eb 16                	jmp    80187f <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801869:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80186d:	75 31                	jne    8018a0 <vprintfmt+0x217>
					putch(ch, putdat);
  80186f:	83 ec 08             	sub    $0x8,%esp
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	50                   	push   %eax
  801876:	ff 55 08             	call   *0x8(%ebp)
  801879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80187c:	83 eb 01             	sub    $0x1,%ebx
  80187f:	83 c7 01             	add    $0x1,%edi
  801882:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801886:	0f be c2             	movsbl %dl,%eax
  801889:	85 c0                	test   %eax,%eax
  80188b:	74 59                	je     8018e6 <vprintfmt+0x25d>
  80188d:	85 f6                	test   %esi,%esi
  80188f:	78 d8                	js     801869 <vprintfmt+0x1e0>
  801891:	83 ee 01             	sub    $0x1,%esi
  801894:	79 d3                	jns    801869 <vprintfmt+0x1e0>
  801896:	89 df                	mov    %ebx,%edi
  801898:	8b 75 08             	mov    0x8(%ebp),%esi
  80189b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80189e:	eb 37                	jmp    8018d7 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8018a0:	0f be d2             	movsbl %dl,%edx
  8018a3:	83 ea 20             	sub    $0x20,%edx
  8018a6:	83 fa 5e             	cmp    $0x5e,%edx
  8018a9:	76 c4                	jbe    80186f <vprintfmt+0x1e6>
					putch('?', putdat);
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	ff 75 0c             	pushl  0xc(%ebp)
  8018b1:	6a 3f                	push   $0x3f
  8018b3:	ff 55 08             	call   *0x8(%ebp)
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	eb c1                	jmp    80187c <vprintfmt+0x1f3>
  8018bb:	89 75 08             	mov    %esi,0x8(%ebp)
  8018be:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018c1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018c4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018c7:	eb b6                	jmp    80187f <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	53                   	push   %ebx
  8018cd:	6a 20                	push   $0x20
  8018cf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018d1:	83 ef 01             	sub    $0x1,%edi
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	85 ff                	test   %edi,%edi
  8018d9:	7f ee                	jg     8018c9 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018de:	89 45 14             	mov    %eax,0x14(%ebp)
  8018e1:	e9 78 01 00 00       	jmp    801a5e <vprintfmt+0x3d5>
  8018e6:	89 df                	mov    %ebx,%edi
  8018e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8018eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018ee:	eb e7                	jmp    8018d7 <vprintfmt+0x24e>
	if (lflag >= 2)
  8018f0:	83 f9 01             	cmp    $0x1,%ecx
  8018f3:	7e 3f                	jle    801934 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f8:	8b 50 04             	mov    0x4(%eax),%edx
  8018fb:	8b 00                	mov    (%eax),%eax
  8018fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801900:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801903:	8b 45 14             	mov    0x14(%ebp),%eax
  801906:	8d 40 08             	lea    0x8(%eax),%eax
  801909:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80190c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801910:	79 5c                	jns    80196e <vprintfmt+0x2e5>
				putch('-', putdat);
  801912:	83 ec 08             	sub    $0x8,%esp
  801915:	53                   	push   %ebx
  801916:	6a 2d                	push   $0x2d
  801918:	ff d6                	call   *%esi
				num = -(long long) num;
  80191a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80191d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801920:	f7 da                	neg    %edx
  801922:	83 d1 00             	adc    $0x0,%ecx
  801925:	f7 d9                	neg    %ecx
  801927:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80192a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80192f:	e9 10 01 00 00       	jmp    801a44 <vprintfmt+0x3bb>
	else if (lflag)
  801934:	85 c9                	test   %ecx,%ecx
  801936:	75 1b                	jne    801953 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801938:	8b 45 14             	mov    0x14(%ebp),%eax
  80193b:	8b 00                	mov    (%eax),%eax
  80193d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801940:	89 c1                	mov    %eax,%ecx
  801942:	c1 f9 1f             	sar    $0x1f,%ecx
  801945:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801948:	8b 45 14             	mov    0x14(%ebp),%eax
  80194b:	8d 40 04             	lea    0x4(%eax),%eax
  80194e:	89 45 14             	mov    %eax,0x14(%ebp)
  801951:	eb b9                	jmp    80190c <vprintfmt+0x283>
		return va_arg(*ap, long);
  801953:	8b 45 14             	mov    0x14(%ebp),%eax
  801956:	8b 00                	mov    (%eax),%eax
  801958:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80195b:	89 c1                	mov    %eax,%ecx
  80195d:	c1 f9 1f             	sar    $0x1f,%ecx
  801960:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801963:	8b 45 14             	mov    0x14(%ebp),%eax
  801966:	8d 40 04             	lea    0x4(%eax),%eax
  801969:	89 45 14             	mov    %eax,0x14(%ebp)
  80196c:	eb 9e                	jmp    80190c <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80196e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801971:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801974:	b8 0a 00 00 00       	mov    $0xa,%eax
  801979:	e9 c6 00 00 00       	jmp    801a44 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80197e:	83 f9 01             	cmp    $0x1,%ecx
  801981:	7e 18                	jle    80199b <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	8b 10                	mov    (%eax),%edx
  801988:	8b 48 04             	mov    0x4(%eax),%ecx
  80198b:	8d 40 08             	lea    0x8(%eax),%eax
  80198e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801991:	b8 0a 00 00 00       	mov    $0xa,%eax
  801996:	e9 a9 00 00 00       	jmp    801a44 <vprintfmt+0x3bb>
	else if (lflag)
  80199b:	85 c9                	test   %ecx,%ecx
  80199d:	75 1a                	jne    8019b9 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80199f:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a2:	8b 10                	mov    (%eax),%edx
  8019a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a9:	8d 40 04             	lea    0x4(%eax),%eax
  8019ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b4:	e9 8b 00 00 00       	jmp    801a44 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bc:	8b 10                	mov    (%eax),%edx
  8019be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c3:	8d 40 04             	lea    0x4(%eax),%eax
  8019c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019ce:	eb 74                	jmp    801a44 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019d0:	83 f9 01             	cmp    $0x1,%ecx
  8019d3:	7e 15                	jle    8019ea <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d8:	8b 10                	mov    (%eax),%edx
  8019da:	8b 48 04             	mov    0x4(%eax),%ecx
  8019dd:	8d 40 08             	lea    0x8(%eax),%eax
  8019e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e8:	eb 5a                	jmp    801a44 <vprintfmt+0x3bb>
	else if (lflag)
  8019ea:	85 c9                	test   %ecx,%ecx
  8019ec:	75 17                	jne    801a05 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f1:	8b 10                	mov    (%eax),%edx
  8019f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f8:	8d 40 04             	lea    0x4(%eax),%eax
  8019fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801a03:	eb 3f                	jmp    801a44 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a05:	8b 45 14             	mov    0x14(%ebp),%eax
  801a08:	8b 10                	mov    (%eax),%edx
  801a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0f:	8d 40 04             	lea    0x4(%eax),%eax
  801a12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a15:	b8 08 00 00 00       	mov    $0x8,%eax
  801a1a:	eb 28                	jmp    801a44 <vprintfmt+0x3bb>
			putch('0', putdat);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	53                   	push   %ebx
  801a20:	6a 30                	push   $0x30
  801a22:	ff d6                	call   *%esi
			putch('x', putdat);
  801a24:	83 c4 08             	add    $0x8,%esp
  801a27:	53                   	push   %ebx
  801a28:	6a 78                	push   $0x78
  801a2a:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2f:	8b 10                	mov    (%eax),%edx
  801a31:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a36:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a39:	8d 40 04             	lea    0x4(%eax),%eax
  801a3c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a3f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a4b:	57                   	push   %edi
  801a4c:	ff 75 e0             	pushl  -0x20(%ebp)
  801a4f:	50                   	push   %eax
  801a50:	51                   	push   %ecx
  801a51:	52                   	push   %edx
  801a52:	89 da                	mov    %ebx,%edx
  801a54:	89 f0                	mov    %esi,%eax
  801a56:	e8 45 fb ff ff       	call   8015a0 <printnum>
			break;
  801a5b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a5e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a61:	83 c7 01             	add    $0x1,%edi
  801a64:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a68:	83 f8 25             	cmp    $0x25,%eax
  801a6b:	0f 84 2f fc ff ff    	je     8016a0 <vprintfmt+0x17>
			if (ch == '\0')
  801a71:	85 c0                	test   %eax,%eax
  801a73:	0f 84 8b 00 00 00    	je     801b04 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a79:	83 ec 08             	sub    $0x8,%esp
  801a7c:	53                   	push   %ebx
  801a7d:	50                   	push   %eax
  801a7e:	ff d6                	call   *%esi
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	eb dc                	jmp    801a61 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a85:	83 f9 01             	cmp    $0x1,%ecx
  801a88:	7e 15                	jle    801a9f <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8d:	8b 10                	mov    (%eax),%edx
  801a8f:	8b 48 04             	mov    0x4(%eax),%ecx
  801a92:	8d 40 08             	lea    0x8(%eax),%eax
  801a95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a98:	b8 10 00 00 00       	mov    $0x10,%eax
  801a9d:	eb a5                	jmp    801a44 <vprintfmt+0x3bb>
	else if (lflag)
  801a9f:	85 c9                	test   %ecx,%ecx
  801aa1:	75 17                	jne    801aba <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa6:	8b 10                	mov    (%eax),%edx
  801aa8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aad:	8d 40 04             	lea    0x4(%eax),%eax
  801ab0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ab3:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab8:	eb 8a                	jmp    801a44 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801aba:	8b 45 14             	mov    0x14(%ebp),%eax
  801abd:	8b 10                	mov    (%eax),%edx
  801abf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac4:	8d 40 04             	lea    0x4(%eax),%eax
  801ac7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aca:	b8 10 00 00 00       	mov    $0x10,%eax
  801acf:	e9 70 ff ff ff       	jmp    801a44 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	53                   	push   %ebx
  801ad8:	6a 25                	push   $0x25
  801ada:	ff d6                	call   *%esi
			break;
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	e9 7a ff ff ff       	jmp    801a5e <vprintfmt+0x3d5>
			putch('%', putdat);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	53                   	push   %ebx
  801ae8:	6a 25                	push   $0x25
  801aea:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	89 f8                	mov    %edi,%eax
  801af1:	eb 03                	jmp    801af6 <vprintfmt+0x46d>
  801af3:	83 e8 01             	sub    $0x1,%eax
  801af6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801afa:	75 f7                	jne    801af3 <vprintfmt+0x46a>
  801afc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aff:	e9 5a ff ff ff       	jmp    801a5e <vprintfmt+0x3d5>
}
  801b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    

00801b0c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 18             	sub    $0x18,%esp
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b1b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b1f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	74 26                	je     801b53 <vsnprintf+0x47>
  801b2d:	85 d2                	test   %edx,%edx
  801b2f:	7e 22                	jle    801b53 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b31:	ff 75 14             	pushl  0x14(%ebp)
  801b34:	ff 75 10             	pushl  0x10(%ebp)
  801b37:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b3a:	50                   	push   %eax
  801b3b:	68 4f 16 80 00       	push   $0x80164f
  801b40:	e8 44 fb ff ff       	call   801689 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b48:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4e:	83 c4 10             	add    $0x10,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    
		return -E_INVAL;
  801b53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b58:	eb f7                	jmp    801b51 <vsnprintf+0x45>

00801b5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b60:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b63:	50                   	push   %eax
  801b64:	ff 75 10             	pushl  0x10(%ebp)
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	e8 9a ff ff ff       	call   801b0c <vsnprintf>
	va_end(ap);

	return rc;
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7f:	eb 03                	jmp    801b84 <strlen+0x10>
		n++;
  801b81:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b84:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b88:	75 f7                	jne    801b81 <strlen+0xd>
	return n;
}
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    

00801b8c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b92:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9a:	eb 03                	jmp    801b9f <strnlen+0x13>
		n++;
  801b9c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b9f:	39 d0                	cmp    %edx,%eax
  801ba1:	74 06                	je     801ba9 <strnlen+0x1d>
  801ba3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801ba7:	75 f3                	jne    801b9c <strnlen+0x10>
	return n;
}
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    

00801bab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	53                   	push   %ebx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801bb5:	89 c2                	mov    %eax,%edx
  801bb7:	83 c1 01             	add    $0x1,%ecx
  801bba:	83 c2 01             	add    $0x1,%edx
  801bbd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801bc1:	88 5a ff             	mov    %bl,-0x1(%edx)
  801bc4:	84 db                	test   %bl,%bl
  801bc6:	75 ef                	jne    801bb7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801bc8:	5b                   	pop    %ebx
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    

00801bcb <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	53                   	push   %ebx
  801bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bd2:	53                   	push   %ebx
  801bd3:	e8 9c ff ff ff       	call   801b74 <strlen>
  801bd8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	01 d8                	add    %ebx,%eax
  801be0:	50                   	push   %eax
  801be1:	e8 c5 ff ff ff       	call   801bab <strcpy>
	return dst;
}
  801be6:	89 d8                	mov    %ebx,%eax
  801be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	56                   	push   %esi
  801bf1:	53                   	push   %ebx
  801bf2:	8b 75 08             	mov    0x8(%ebp),%esi
  801bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf8:	89 f3                	mov    %esi,%ebx
  801bfa:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bfd:	89 f2                	mov    %esi,%edx
  801bff:	eb 0f                	jmp    801c10 <strncpy+0x23>
		*dst++ = *src;
  801c01:	83 c2 01             	add    $0x1,%edx
  801c04:	0f b6 01             	movzbl (%ecx),%eax
  801c07:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801c0a:	80 39 01             	cmpb   $0x1,(%ecx)
  801c0d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801c10:	39 da                	cmp    %ebx,%edx
  801c12:	75 ed                	jne    801c01 <strncpy+0x14>
	}
	return ret;
}
  801c14:	89 f0                	mov    %esi,%eax
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    

00801c1a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	56                   	push   %esi
  801c1e:	53                   	push   %ebx
  801c1f:	8b 75 08             	mov    0x8(%ebp),%esi
  801c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c28:	89 f0                	mov    %esi,%eax
  801c2a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c2e:	85 c9                	test   %ecx,%ecx
  801c30:	75 0b                	jne    801c3d <strlcpy+0x23>
  801c32:	eb 17                	jmp    801c4b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c34:	83 c2 01             	add    $0x1,%edx
  801c37:	83 c0 01             	add    $0x1,%eax
  801c3a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c3d:	39 d8                	cmp    %ebx,%eax
  801c3f:	74 07                	je     801c48 <strlcpy+0x2e>
  801c41:	0f b6 0a             	movzbl (%edx),%ecx
  801c44:	84 c9                	test   %cl,%cl
  801c46:	75 ec                	jne    801c34 <strlcpy+0x1a>
		*dst = '\0';
  801c48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c4b:	29 f0                	sub    %esi,%eax
}
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    

00801c51 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c57:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c5a:	eb 06                	jmp    801c62 <strcmp+0x11>
		p++, q++;
  801c5c:	83 c1 01             	add    $0x1,%ecx
  801c5f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c62:	0f b6 01             	movzbl (%ecx),%eax
  801c65:	84 c0                	test   %al,%al
  801c67:	74 04                	je     801c6d <strcmp+0x1c>
  801c69:	3a 02                	cmp    (%edx),%al
  801c6b:	74 ef                	je     801c5c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c6d:	0f b6 c0             	movzbl %al,%eax
  801c70:	0f b6 12             	movzbl (%edx),%edx
  801c73:	29 d0                	sub    %edx,%eax
}
  801c75:	5d                   	pop    %ebp
  801c76:	c3                   	ret    

00801c77 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	53                   	push   %ebx
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c86:	eb 06                	jmp    801c8e <strncmp+0x17>
		n--, p++, q++;
  801c88:	83 c0 01             	add    $0x1,%eax
  801c8b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c8e:	39 d8                	cmp    %ebx,%eax
  801c90:	74 16                	je     801ca8 <strncmp+0x31>
  801c92:	0f b6 08             	movzbl (%eax),%ecx
  801c95:	84 c9                	test   %cl,%cl
  801c97:	74 04                	je     801c9d <strncmp+0x26>
  801c99:	3a 0a                	cmp    (%edx),%cl
  801c9b:	74 eb                	je     801c88 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c9d:	0f b6 00             	movzbl (%eax),%eax
  801ca0:	0f b6 12             	movzbl (%edx),%edx
  801ca3:	29 d0                	sub    %edx,%eax
}
  801ca5:	5b                   	pop    %ebx
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
		return 0;
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cad:	eb f6                	jmp    801ca5 <strncmp+0x2e>

00801caf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cb9:	0f b6 10             	movzbl (%eax),%edx
  801cbc:	84 d2                	test   %dl,%dl
  801cbe:	74 09                	je     801cc9 <strchr+0x1a>
		if (*s == c)
  801cc0:	38 ca                	cmp    %cl,%dl
  801cc2:	74 0a                	je     801cce <strchr+0x1f>
	for (; *s; s++)
  801cc4:	83 c0 01             	add    $0x1,%eax
  801cc7:	eb f0                	jmp    801cb9 <strchr+0xa>
			return (char *) s;
	return 0;
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    

00801cd0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cda:	eb 03                	jmp    801cdf <strfind+0xf>
  801cdc:	83 c0 01             	add    $0x1,%eax
  801cdf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801ce2:	38 ca                	cmp    %cl,%dl
  801ce4:	74 04                	je     801cea <strfind+0x1a>
  801ce6:	84 d2                	test   %dl,%dl
  801ce8:	75 f2                	jne    801cdc <strfind+0xc>
			break;
	return (char *) s;
}
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    

00801cec <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	57                   	push   %edi
  801cf0:	56                   	push   %esi
  801cf1:	53                   	push   %ebx
  801cf2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cf5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cf8:	85 c9                	test   %ecx,%ecx
  801cfa:	74 13                	je     801d0f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cfc:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801d02:	75 05                	jne    801d09 <memset+0x1d>
  801d04:	f6 c1 03             	test   $0x3,%cl
  801d07:	74 0d                	je     801d16 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0c:	fc                   	cld    
  801d0d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d0f:	89 f8                	mov    %edi,%eax
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5f                   	pop    %edi
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    
		c &= 0xFF;
  801d16:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d1a:	89 d3                	mov    %edx,%ebx
  801d1c:	c1 e3 08             	shl    $0x8,%ebx
  801d1f:	89 d0                	mov    %edx,%eax
  801d21:	c1 e0 18             	shl    $0x18,%eax
  801d24:	89 d6                	mov    %edx,%esi
  801d26:	c1 e6 10             	shl    $0x10,%esi
  801d29:	09 f0                	or     %esi,%eax
  801d2b:	09 c2                	or     %eax,%edx
  801d2d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d2f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d32:	89 d0                	mov    %edx,%eax
  801d34:	fc                   	cld    
  801d35:	f3 ab                	rep stos %eax,%es:(%edi)
  801d37:	eb d6                	jmp    801d0f <memset+0x23>

00801d39 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	57                   	push   %edi
  801d3d:	56                   	push   %esi
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d44:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d47:	39 c6                	cmp    %eax,%esi
  801d49:	73 35                	jae    801d80 <memmove+0x47>
  801d4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d4e:	39 c2                	cmp    %eax,%edx
  801d50:	76 2e                	jbe    801d80 <memmove+0x47>
		s += n;
		d += n;
  801d52:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d55:	89 d6                	mov    %edx,%esi
  801d57:	09 fe                	or     %edi,%esi
  801d59:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d5f:	74 0c                	je     801d6d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d61:	83 ef 01             	sub    $0x1,%edi
  801d64:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d67:	fd                   	std    
  801d68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d6a:	fc                   	cld    
  801d6b:	eb 21                	jmp    801d8e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d6d:	f6 c1 03             	test   $0x3,%cl
  801d70:	75 ef                	jne    801d61 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d72:	83 ef 04             	sub    $0x4,%edi
  801d75:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d78:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d7b:	fd                   	std    
  801d7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d7e:	eb ea                	jmp    801d6a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d80:	89 f2                	mov    %esi,%edx
  801d82:	09 c2                	or     %eax,%edx
  801d84:	f6 c2 03             	test   $0x3,%dl
  801d87:	74 09                	je     801d92 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d89:	89 c7                	mov    %eax,%edi
  801d8b:	fc                   	cld    
  801d8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d8e:	5e                   	pop    %esi
  801d8f:	5f                   	pop    %edi
  801d90:	5d                   	pop    %ebp
  801d91:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d92:	f6 c1 03             	test   $0x3,%cl
  801d95:	75 f2                	jne    801d89 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d97:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d9a:	89 c7                	mov    %eax,%edi
  801d9c:	fc                   	cld    
  801d9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d9f:	eb ed                	jmp    801d8e <memmove+0x55>

00801da1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801da4:	ff 75 10             	pushl  0x10(%ebp)
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	e8 87 ff ff ff       	call   801d39 <memmove>
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	56                   	push   %esi
  801db8:	53                   	push   %ebx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbf:	89 c6                	mov    %eax,%esi
  801dc1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801dc4:	39 f0                	cmp    %esi,%eax
  801dc6:	74 1c                	je     801de4 <memcmp+0x30>
		if (*s1 != *s2)
  801dc8:	0f b6 08             	movzbl (%eax),%ecx
  801dcb:	0f b6 1a             	movzbl (%edx),%ebx
  801dce:	38 d9                	cmp    %bl,%cl
  801dd0:	75 08                	jne    801dda <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801dd2:	83 c0 01             	add    $0x1,%eax
  801dd5:	83 c2 01             	add    $0x1,%edx
  801dd8:	eb ea                	jmp    801dc4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dda:	0f b6 c1             	movzbl %cl,%eax
  801ddd:	0f b6 db             	movzbl %bl,%ebx
  801de0:	29 d8                	sub    %ebx,%eax
  801de2:	eb 05                	jmp    801de9 <memcmp+0x35>
	}

	return 0;
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de9:	5b                   	pop    %ebx
  801dea:	5e                   	pop    %esi
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801df6:	89 c2                	mov    %eax,%edx
  801df8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dfb:	39 d0                	cmp    %edx,%eax
  801dfd:	73 09                	jae    801e08 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dff:	38 08                	cmp    %cl,(%eax)
  801e01:	74 05                	je     801e08 <memfind+0x1b>
	for (; s < ends; s++)
  801e03:	83 c0 01             	add    $0x1,%eax
  801e06:	eb f3                	jmp    801dfb <memfind+0xe>
			break;
	return (void *) s;
}
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	57                   	push   %edi
  801e0e:	56                   	push   %esi
  801e0f:	53                   	push   %ebx
  801e10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e16:	eb 03                	jmp    801e1b <strtol+0x11>
		s++;
  801e18:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e1b:	0f b6 01             	movzbl (%ecx),%eax
  801e1e:	3c 20                	cmp    $0x20,%al
  801e20:	74 f6                	je     801e18 <strtol+0xe>
  801e22:	3c 09                	cmp    $0x9,%al
  801e24:	74 f2                	je     801e18 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e26:	3c 2b                	cmp    $0x2b,%al
  801e28:	74 2e                	je     801e58 <strtol+0x4e>
	int neg = 0;
  801e2a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e2f:	3c 2d                	cmp    $0x2d,%al
  801e31:	74 2f                	je     801e62 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e33:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e39:	75 05                	jne    801e40 <strtol+0x36>
  801e3b:	80 39 30             	cmpb   $0x30,(%ecx)
  801e3e:	74 2c                	je     801e6c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e40:	85 db                	test   %ebx,%ebx
  801e42:	75 0a                	jne    801e4e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e44:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e49:	80 39 30             	cmpb   $0x30,(%ecx)
  801e4c:	74 28                	je     801e76 <strtol+0x6c>
		base = 10;
  801e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e53:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e56:	eb 50                	jmp    801ea8 <strtol+0x9e>
		s++;
  801e58:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e60:	eb d1                	jmp    801e33 <strtol+0x29>
		s++, neg = 1;
  801e62:	83 c1 01             	add    $0x1,%ecx
  801e65:	bf 01 00 00 00       	mov    $0x1,%edi
  801e6a:	eb c7                	jmp    801e33 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e6c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e70:	74 0e                	je     801e80 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e72:	85 db                	test   %ebx,%ebx
  801e74:	75 d8                	jne    801e4e <strtol+0x44>
		s++, base = 8;
  801e76:	83 c1 01             	add    $0x1,%ecx
  801e79:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e7e:	eb ce                	jmp    801e4e <strtol+0x44>
		s += 2, base = 16;
  801e80:	83 c1 02             	add    $0x2,%ecx
  801e83:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e88:	eb c4                	jmp    801e4e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e8a:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e8d:	89 f3                	mov    %esi,%ebx
  801e8f:	80 fb 19             	cmp    $0x19,%bl
  801e92:	77 29                	ja     801ebd <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e94:	0f be d2             	movsbl %dl,%edx
  801e97:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e9a:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e9d:	7d 30                	jge    801ecf <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e9f:	83 c1 01             	add    $0x1,%ecx
  801ea2:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ea6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ea8:	0f b6 11             	movzbl (%ecx),%edx
  801eab:	8d 72 d0             	lea    -0x30(%edx),%esi
  801eae:	89 f3                	mov    %esi,%ebx
  801eb0:	80 fb 09             	cmp    $0x9,%bl
  801eb3:	77 d5                	ja     801e8a <strtol+0x80>
			dig = *s - '0';
  801eb5:	0f be d2             	movsbl %dl,%edx
  801eb8:	83 ea 30             	sub    $0x30,%edx
  801ebb:	eb dd                	jmp    801e9a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801ebd:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ec0:	89 f3                	mov    %esi,%ebx
  801ec2:	80 fb 19             	cmp    $0x19,%bl
  801ec5:	77 08                	ja     801ecf <strtol+0xc5>
			dig = *s - 'A' + 10;
  801ec7:	0f be d2             	movsbl %dl,%edx
  801eca:	83 ea 37             	sub    $0x37,%edx
  801ecd:	eb cb                	jmp    801e9a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ecf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed3:	74 05                	je     801eda <strtol+0xd0>
		*endptr = (char *) s;
  801ed5:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ed8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eda:	89 c2                	mov    %eax,%edx
  801edc:	f7 da                	neg    %edx
  801ede:	85 ff                	test   %edi,%edi
  801ee0:	0f 45 c2             	cmovne %edx,%eax
}
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5f                   	pop    %edi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	8b 75 08             	mov    0x8(%ebp),%esi
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801ef6:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ef8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801efd:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	50                   	push   %eax
  801f04:	e8 28 e4 ff ff       	call   800331 <sys_ipc_recv>
	if (from_env_store)
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	85 f6                	test   %esi,%esi
  801f0e:	74 14                	je     801f24 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f10:	ba 00 00 00 00       	mov    $0x0,%edx
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 09                	js     801f22 <ipc_recv+0x3a>
  801f19:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f1f:	8b 52 74             	mov    0x74(%edx),%edx
  801f22:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f24:	85 db                	test   %ebx,%ebx
  801f26:	74 14                	je     801f3c <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f28:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 09                	js     801f3a <ipc_recv+0x52>
  801f31:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f37:	8b 52 78             	mov    0x78(%edx),%edx
  801f3a:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 08                	js     801f48 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f40:	a1 08 40 80 00       	mov    0x804008,%eax
  801f45:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5e                   	pop    %esi
  801f4d:	5d                   	pop    %ebp
  801f4e:	c3                   	ret    

00801f4f <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	57                   	push   %edi
  801f53:	56                   	push   %esi
  801f54:	53                   	push   %ebx
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f61:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f63:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f68:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f6b:	ff 75 14             	pushl  0x14(%ebp)
  801f6e:	53                   	push   %ebx
  801f6f:	56                   	push   %esi
  801f70:	57                   	push   %edi
  801f71:	e8 98 e3 ff ff       	call   80030e <sys_ipc_try_send>
		if (ret == 0)
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	74 1e                	je     801f9b <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f7d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f80:	75 07                	jne    801f89 <ipc_send+0x3a>
			sys_yield();
  801f82:	e8 db e1 ff ff       	call   800162 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f87:	eb e2                	jmp    801f6b <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f89:	50                   	push   %eax
  801f8a:	68 e0 26 80 00       	push   $0x8026e0
  801f8f:	6a 3d                	push   $0x3d
  801f91:	68 f4 26 80 00       	push   $0x8026f4
  801f96:	e8 16 f5 ff ff       	call   8014b1 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9e:	5b                   	pop    %ebx
  801f9f:	5e                   	pop    %esi
  801fa0:	5f                   	pop    %edi
  801fa1:	5d                   	pop    %ebp
  801fa2:	c3                   	ret    

00801fa3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fae:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fb1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fb7:	8b 52 50             	mov    0x50(%edx),%edx
  801fba:	39 ca                	cmp    %ecx,%edx
  801fbc:	74 11                	je     801fcf <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fbe:	83 c0 01             	add    $0x1,%eax
  801fc1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fc6:	75 e6                	jne    801fae <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcd:	eb 0b                	jmp    801fda <ipc_find_env+0x37>
			return envs[i].env_id;
  801fcf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fd2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fd7:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fda:	5d                   	pop    %ebp
  801fdb:	c3                   	ret    

00801fdc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	c1 e8 16             	shr    $0x16,%eax
  801fe7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ff3:	f6 c1 01             	test   $0x1,%cl
  801ff6:	74 1d                	je     802015 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ff8:	c1 ea 0c             	shr    $0xc,%edx
  801ffb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802002:	f6 c2 01             	test   $0x1,%dl
  802005:	74 0e                	je     802015 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802007:	c1 ea 0c             	shr    $0xc,%edx
  80200a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802011:	ef 
  802012:	0f b7 c0             	movzwl %ax,%eax
}
  802015:	5d                   	pop    %ebp
  802016:	c3                   	ret    
  802017:	66 90                	xchg   %ax,%ax
  802019:	66 90                	xchg   %ax,%ax
  80201b:	66 90                	xchg   %ax,%ax
  80201d:	66 90                	xchg   %ax,%ax
  80201f:	90                   	nop

00802020 <__udivdi3>:
  802020:	55                   	push   %ebp
  802021:	57                   	push   %edi
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	83 ec 1c             	sub    $0x1c,%esp
  802027:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80202b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80202f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802033:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802037:	85 d2                	test   %edx,%edx
  802039:	75 35                	jne    802070 <__udivdi3+0x50>
  80203b:	39 f3                	cmp    %esi,%ebx
  80203d:	0f 87 bd 00 00 00    	ja     802100 <__udivdi3+0xe0>
  802043:	85 db                	test   %ebx,%ebx
  802045:	89 d9                	mov    %ebx,%ecx
  802047:	75 0b                	jne    802054 <__udivdi3+0x34>
  802049:	b8 01 00 00 00       	mov    $0x1,%eax
  80204e:	31 d2                	xor    %edx,%edx
  802050:	f7 f3                	div    %ebx
  802052:	89 c1                	mov    %eax,%ecx
  802054:	31 d2                	xor    %edx,%edx
  802056:	89 f0                	mov    %esi,%eax
  802058:	f7 f1                	div    %ecx
  80205a:	89 c6                	mov    %eax,%esi
  80205c:	89 e8                	mov    %ebp,%eax
  80205e:	89 f7                	mov    %esi,%edi
  802060:	f7 f1                	div    %ecx
  802062:	89 fa                	mov    %edi,%edx
  802064:	83 c4 1c             	add    $0x1c,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    
  80206c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802070:	39 f2                	cmp    %esi,%edx
  802072:	77 7c                	ja     8020f0 <__udivdi3+0xd0>
  802074:	0f bd fa             	bsr    %edx,%edi
  802077:	83 f7 1f             	xor    $0x1f,%edi
  80207a:	0f 84 98 00 00 00    	je     802118 <__udivdi3+0xf8>
  802080:	89 f9                	mov    %edi,%ecx
  802082:	b8 20 00 00 00       	mov    $0x20,%eax
  802087:	29 f8                	sub    %edi,%eax
  802089:	d3 e2                	shl    %cl,%edx
  80208b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80208f:	89 c1                	mov    %eax,%ecx
  802091:	89 da                	mov    %ebx,%edx
  802093:	d3 ea                	shr    %cl,%edx
  802095:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802099:	09 d1                	or     %edx,%ecx
  80209b:	89 f2                	mov    %esi,%edx
  80209d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020a1:	89 f9                	mov    %edi,%ecx
  8020a3:	d3 e3                	shl    %cl,%ebx
  8020a5:	89 c1                	mov    %eax,%ecx
  8020a7:	d3 ea                	shr    %cl,%edx
  8020a9:	89 f9                	mov    %edi,%ecx
  8020ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020af:	d3 e6                	shl    %cl,%esi
  8020b1:	89 eb                	mov    %ebp,%ebx
  8020b3:	89 c1                	mov    %eax,%ecx
  8020b5:	d3 eb                	shr    %cl,%ebx
  8020b7:	09 de                	or     %ebx,%esi
  8020b9:	89 f0                	mov    %esi,%eax
  8020bb:	f7 74 24 08          	divl   0x8(%esp)
  8020bf:	89 d6                	mov    %edx,%esi
  8020c1:	89 c3                	mov    %eax,%ebx
  8020c3:	f7 64 24 0c          	mull   0xc(%esp)
  8020c7:	39 d6                	cmp    %edx,%esi
  8020c9:	72 0c                	jb     8020d7 <__udivdi3+0xb7>
  8020cb:	89 f9                	mov    %edi,%ecx
  8020cd:	d3 e5                	shl    %cl,%ebp
  8020cf:	39 c5                	cmp    %eax,%ebp
  8020d1:	73 5d                	jae    802130 <__udivdi3+0x110>
  8020d3:	39 d6                	cmp    %edx,%esi
  8020d5:	75 59                	jne    802130 <__udivdi3+0x110>
  8020d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020da:	31 ff                	xor    %edi,%edi
  8020dc:	89 fa                	mov    %edi,%edx
  8020de:	83 c4 1c             	add    $0x1c,%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    
  8020e6:	8d 76 00             	lea    0x0(%esi),%esi
  8020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8020f0:	31 ff                	xor    %edi,%edi
  8020f2:	31 c0                	xor    %eax,%eax
  8020f4:	89 fa                	mov    %edi,%edx
  8020f6:	83 c4 1c             	add    $0x1c,%esp
  8020f9:	5b                   	pop    %ebx
  8020fa:	5e                   	pop    %esi
  8020fb:	5f                   	pop    %edi
  8020fc:	5d                   	pop    %ebp
  8020fd:	c3                   	ret    
  8020fe:	66 90                	xchg   %ax,%ax
  802100:	31 ff                	xor    %edi,%edi
  802102:	89 e8                	mov    %ebp,%eax
  802104:	89 f2                	mov    %esi,%edx
  802106:	f7 f3                	div    %ebx
  802108:	89 fa                	mov    %edi,%edx
  80210a:	83 c4 1c             	add    $0x1c,%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5f                   	pop    %edi
  802110:	5d                   	pop    %ebp
  802111:	c3                   	ret    
  802112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802118:	39 f2                	cmp    %esi,%edx
  80211a:	72 06                	jb     802122 <__udivdi3+0x102>
  80211c:	31 c0                	xor    %eax,%eax
  80211e:	39 eb                	cmp    %ebp,%ebx
  802120:	77 d2                	ja     8020f4 <__udivdi3+0xd4>
  802122:	b8 01 00 00 00       	mov    $0x1,%eax
  802127:	eb cb                	jmp    8020f4 <__udivdi3+0xd4>
  802129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802130:	89 d8                	mov    %ebx,%eax
  802132:	31 ff                	xor    %edi,%edi
  802134:	eb be                	jmp    8020f4 <__udivdi3+0xd4>
  802136:	66 90                	xchg   %ax,%ax
  802138:	66 90                	xchg   %ax,%ax
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	66 90                	xchg   %ax,%ax
  80213e:	66 90                	xchg   %ax,%ax

00802140 <__umoddi3>:
  802140:	55                   	push   %ebp
  802141:	57                   	push   %edi
  802142:	56                   	push   %esi
  802143:	53                   	push   %ebx
  802144:	83 ec 1c             	sub    $0x1c,%esp
  802147:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80214b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80214f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802153:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802157:	85 ed                	test   %ebp,%ebp
  802159:	89 f0                	mov    %esi,%eax
  80215b:	89 da                	mov    %ebx,%edx
  80215d:	75 19                	jne    802178 <__umoddi3+0x38>
  80215f:	39 df                	cmp    %ebx,%edi
  802161:	0f 86 b1 00 00 00    	jbe    802218 <__umoddi3+0xd8>
  802167:	f7 f7                	div    %edi
  802169:	89 d0                	mov    %edx,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	83 c4 1c             	add    $0x1c,%esp
  802170:	5b                   	pop    %ebx
  802171:	5e                   	pop    %esi
  802172:	5f                   	pop    %edi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
  802175:	8d 76 00             	lea    0x0(%esi),%esi
  802178:	39 dd                	cmp    %ebx,%ebp
  80217a:	77 f1                	ja     80216d <__umoddi3+0x2d>
  80217c:	0f bd cd             	bsr    %ebp,%ecx
  80217f:	83 f1 1f             	xor    $0x1f,%ecx
  802182:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802186:	0f 84 b4 00 00 00    	je     802240 <__umoddi3+0x100>
  80218c:	b8 20 00 00 00       	mov    $0x20,%eax
  802191:	89 c2                	mov    %eax,%edx
  802193:	8b 44 24 04          	mov    0x4(%esp),%eax
  802197:	29 c2                	sub    %eax,%edx
  802199:	89 c1                	mov    %eax,%ecx
  80219b:	89 f8                	mov    %edi,%eax
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	89 d1                	mov    %edx,%ecx
  8021a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	09 c5                	or     %eax,%ebp
  8021a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ad:	89 c1                	mov    %eax,%ecx
  8021af:	d3 e7                	shl    %cl,%edi
  8021b1:	89 d1                	mov    %edx,%ecx
  8021b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021b7:	89 df                	mov    %ebx,%edi
  8021b9:	d3 ef                	shr    %cl,%edi
  8021bb:	89 c1                	mov    %eax,%ecx
  8021bd:	89 f0                	mov    %esi,%eax
  8021bf:	d3 e3                	shl    %cl,%ebx
  8021c1:	89 d1                	mov    %edx,%ecx
  8021c3:	89 fa                	mov    %edi,%edx
  8021c5:	d3 e8                	shr    %cl,%eax
  8021c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021cc:	09 d8                	or     %ebx,%eax
  8021ce:	f7 f5                	div    %ebp
  8021d0:	d3 e6                	shl    %cl,%esi
  8021d2:	89 d1                	mov    %edx,%ecx
  8021d4:	f7 64 24 08          	mull   0x8(%esp)
  8021d8:	39 d1                	cmp    %edx,%ecx
  8021da:	89 c3                	mov    %eax,%ebx
  8021dc:	89 d7                	mov    %edx,%edi
  8021de:	72 06                	jb     8021e6 <__umoddi3+0xa6>
  8021e0:	75 0e                	jne    8021f0 <__umoddi3+0xb0>
  8021e2:	39 c6                	cmp    %eax,%esi
  8021e4:	73 0a                	jae    8021f0 <__umoddi3+0xb0>
  8021e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8021ea:	19 ea                	sbb    %ebp,%edx
  8021ec:	89 d7                	mov    %edx,%edi
  8021ee:	89 c3                	mov    %eax,%ebx
  8021f0:	89 ca                	mov    %ecx,%edx
  8021f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8021f7:	29 de                	sub    %ebx,%esi
  8021f9:	19 fa                	sbb    %edi,%edx
  8021fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021ff:	89 d0                	mov    %edx,%eax
  802201:	d3 e0                	shl    %cl,%eax
  802203:	89 d9                	mov    %ebx,%ecx
  802205:	d3 ee                	shr    %cl,%esi
  802207:	d3 ea                	shr    %cl,%edx
  802209:	09 f0                	or     %esi,%eax
  80220b:	83 c4 1c             	add    $0x1c,%esp
  80220e:	5b                   	pop    %ebx
  80220f:	5e                   	pop    %esi
  802210:	5f                   	pop    %edi
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    
  802213:	90                   	nop
  802214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802218:	85 ff                	test   %edi,%edi
  80221a:	89 f9                	mov    %edi,%ecx
  80221c:	75 0b                	jne    802229 <__umoddi3+0xe9>
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f7                	div    %edi
  802227:	89 c1                	mov    %eax,%ecx
  802229:	89 d8                	mov    %ebx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f1                	div    %ecx
  80222f:	89 f0                	mov    %esi,%eax
  802231:	f7 f1                	div    %ecx
  802233:	e9 31 ff ff ff       	jmp    802169 <__umoddi3+0x29>
  802238:	90                   	nop
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	39 dd                	cmp    %ebx,%ebp
  802242:	72 08                	jb     80224c <__umoddi3+0x10c>
  802244:	39 f7                	cmp    %esi,%edi
  802246:	0f 87 21 ff ff ff    	ja     80216d <__umoddi3+0x2d>
  80224c:	89 da                	mov    %ebx,%edx
  80224e:	89 f0                	mov    %esi,%eax
  802250:	29 f8                	sub    %edi,%eax
  802252:	19 ea                	sbb    %ebp,%edx
  802254:	e9 14 ff ff ff       	jmp    80216d <__umoddi3+0x2d>

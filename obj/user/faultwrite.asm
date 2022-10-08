
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0 = 0;
  800036:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004d:	e8 ce 00 00 00       	call   800120 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x2d>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008e:	e8 b1 04 00 00       	call   800544 <close_all>
	sys_env_destroy(0);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 4a 22 80 00       	push   $0x80224a
  800114:	6a 23                	push   $0x23
  800116:	68 67 22 80 00       	push   $0x802267
  80011b:	e8 6e 13 00 00       	call   80148e <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
	asm volatile("int %1\n"
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	asm volatile("int %1\n"
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 4a 22 80 00       	push   $0x80224a
  800195:	6a 23                	push   $0x23
  800197:	68 67 22 80 00       	push   $0x802267
  80019c:	e8 ed 12 00 00       	call   80148e <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 4a 22 80 00       	push   $0x80224a
  8001d7:	6a 23                	push   $0x23
  8001d9:	68 67 22 80 00       	push   $0x802267
  8001de:	e8 ab 12 00 00       	call   80148e <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
	if(check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 4a 22 80 00       	push   $0x80224a
  800219:	6a 23                	push   $0x23
  80021b:	68 67 22 80 00       	push   $0x802267
  800220:	e8 69 12 00 00       	call   80148e <_panic>

00800225 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
	if(check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7f 08                	jg     800250 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	50                   	push   %eax
  800254:	6a 08                	push   $0x8
  800256:	68 4a 22 80 00       	push   $0x80224a
  80025b:	6a 23                	push   $0x23
  80025d:	68 67 22 80 00       	push   $0x802267
  800262:	e8 27 12 00 00       	call   80148e <_panic>

00800267 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 09 00 00 00       	mov    $0x9,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 09                	push   $0x9
  800298:	68 4a 22 80 00       	push   $0x80224a
  80029d:	6a 23                	push   $0x23
  80029f:	68 67 22 80 00       	push   $0x802267
  8002a4:	e8 e5 11 00 00       	call   80148e <_panic>

008002a9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c2:	89 df                	mov    %ebx,%edi
  8002c4:	89 de                	mov    %ebx,%esi
  8002c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	7f 08                	jg     8002d4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	50                   	push   %eax
  8002d8:	6a 0a                	push   $0xa
  8002da:	68 4a 22 80 00       	push   $0x80224a
  8002df:	6a 23                	push   $0x23
  8002e1:	68 67 22 80 00       	push   $0x802267
  8002e6:	e8 a3 11 00 00       	call   80148e <_panic>

008002eb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	57                   	push   %edi
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800304:	8b 7d 14             	mov    0x14(%ebp),%edi
  800307:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
  800314:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031c:	8b 55 08             	mov    0x8(%ebp),%edx
  80031f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800324:	89 cb                	mov    %ecx,%ebx
  800326:	89 cf                	mov    %ecx,%edi
  800328:	89 ce                	mov    %ecx,%esi
  80032a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80032c:	85 c0                	test   %eax,%eax
  80032e:	7f 08                	jg     800338 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	50                   	push   %eax
  80033c:	6a 0d                	push   $0xd
  80033e:	68 4a 22 80 00       	push   $0x80224a
  800343:	6a 23                	push   $0x23
  800345:	68 67 22 80 00       	push   $0x802267
  80034a:	e8 3f 11 00 00       	call   80148e <_panic>

0080034f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	57                   	push   %edi
  800353:	56                   	push   %esi
  800354:	53                   	push   %ebx
	asm volatile("int %1\n"
  800355:	ba 00 00 00 00       	mov    $0x0,%edx
  80035a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035f:	89 d1                	mov    %edx,%ecx
  800361:	89 d3                	mov    %edx,%ebx
  800363:	89 d7                	mov    %edx,%edi
  800365:	89 d6                	mov    %edx,%esi
  800367:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800369:	5b                   	pop    %ebx
  80036a:	5e                   	pop    %esi
  80036b:	5f                   	pop    %edi
  80036c:	5d                   	pop    %ebp
  80036d:	c3                   	ret    

0080036e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800371:	8b 45 08             	mov    0x8(%ebp),%eax
  800374:	05 00 00 00 30       	add    $0x30000000,%eax
  800379:	c1 e8 0c             	shr    $0xc,%eax
}
  80037c:	5d                   	pop    %ebp
  80037d:	c3                   	ret    

0080037e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    

00800395 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	c1 ea 16             	shr    $0x16,%edx
  8003a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ac:	f6 c2 01             	test   $0x1,%dl
  8003af:	74 2a                	je     8003db <fd_alloc+0x46>
  8003b1:	89 c2                	mov    %eax,%edx
  8003b3:	c1 ea 0c             	shr    $0xc,%edx
  8003b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003bd:	f6 c2 01             	test   $0x1,%dl
  8003c0:	74 19                	je     8003db <fd_alloc+0x46>
  8003c2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003c7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003cc:	75 d2                	jne    8003a0 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003ce:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d9:	eb 07                	jmp    8003e2 <fd_alloc+0x4d>
			*fd_store = fd;
  8003db:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003ea:	83 f8 1f             	cmp    $0x1f,%eax
  8003ed:	77 36                	ja     800425 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003ef:	c1 e0 0c             	shl    $0xc,%eax
  8003f2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003f7:	89 c2                	mov    %eax,%edx
  8003f9:	c1 ea 16             	shr    $0x16,%edx
  8003fc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800403:	f6 c2 01             	test   $0x1,%dl
  800406:	74 24                	je     80042c <fd_lookup+0x48>
  800408:	89 c2                	mov    %eax,%edx
  80040a:	c1 ea 0c             	shr    $0xc,%edx
  80040d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800414:	f6 c2 01             	test   $0x1,%dl
  800417:	74 1a                	je     800433 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041c:	89 02                	mov    %eax,(%edx)
	return 0;
  80041e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800423:	5d                   	pop    %ebp
  800424:	c3                   	ret    
		return -E_INVAL;
  800425:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042a:	eb f7                	jmp    800423 <fd_lookup+0x3f>
		return -E_INVAL;
  80042c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800431:	eb f0                	jmp    800423 <fd_lookup+0x3f>
  800433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800438:	eb e9                	jmp    800423 <fd_lookup+0x3f>

0080043a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800443:	ba f4 22 80 00       	mov    $0x8022f4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800448:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80044d:	39 08                	cmp    %ecx,(%eax)
  80044f:	74 33                	je     800484 <dev_lookup+0x4a>
  800451:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800454:	8b 02                	mov    (%edx),%eax
  800456:	85 c0                	test   %eax,%eax
  800458:	75 f3                	jne    80044d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80045a:	a1 08 40 80 00       	mov    0x804008,%eax
  80045f:	8b 40 48             	mov    0x48(%eax),%eax
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	51                   	push   %ecx
  800466:	50                   	push   %eax
  800467:	68 78 22 80 00       	push   $0x802278
  80046c:	e8 f8 10 00 00       	call   801569 <cprintf>
	*dev = 0;
  800471:	8b 45 0c             	mov    0xc(%ebp),%eax
  800474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    
			*dev = devtab[i];
  800484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800487:	89 01                	mov    %eax,(%ecx)
			return 0;
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	eb f2                	jmp    800482 <dev_lookup+0x48>

00800490 <fd_close>:
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	57                   	push   %edi
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	83 ec 1c             	sub    $0x1c,%esp
  800499:	8b 75 08             	mov    0x8(%ebp),%esi
  80049c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80049f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004a3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004ac:	50                   	push   %eax
  8004ad:	e8 32 ff ff ff       	call   8003e4 <fd_lookup>
  8004b2:	89 c3                	mov    %eax,%ebx
  8004b4:	83 c4 08             	add    $0x8,%esp
  8004b7:	85 c0                	test   %eax,%eax
  8004b9:	78 05                	js     8004c0 <fd_close+0x30>
	    || fd != fd2)
  8004bb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004be:	74 16                	je     8004d6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004c0:	89 f8                	mov    %edi,%eax
  8004c2:	84 c0                	test   %al,%al
  8004c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c9:	0f 44 d8             	cmove  %eax,%ebx
}
  8004cc:	89 d8                	mov    %ebx,%eax
  8004ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d1:	5b                   	pop    %ebx
  8004d2:	5e                   	pop    %esi
  8004d3:	5f                   	pop    %edi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004dc:	50                   	push   %eax
  8004dd:	ff 36                	pushl  (%esi)
  8004df:	e8 56 ff ff ff       	call   80043a <dev_lookup>
  8004e4:	89 c3                	mov    %eax,%ebx
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 c0                	test   %eax,%eax
  8004eb:	78 15                	js     800502 <fd_close+0x72>
		if (dev->dev_close)
  8004ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f0:	8b 40 10             	mov    0x10(%eax),%eax
  8004f3:	85 c0                	test   %eax,%eax
  8004f5:	74 1b                	je     800512 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004f7:	83 ec 0c             	sub    $0xc,%esp
  8004fa:	56                   	push   %esi
  8004fb:	ff d0                	call   *%eax
  8004fd:	89 c3                	mov    %eax,%ebx
  8004ff:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	56                   	push   %esi
  800506:	6a 00                	push   $0x0
  800508:	e8 d6 fc ff ff       	call   8001e3 <sys_page_unmap>
	return r;
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	eb ba                	jmp    8004cc <fd_close+0x3c>
			r = 0;
  800512:	bb 00 00 00 00       	mov    $0x0,%ebx
  800517:	eb e9                	jmp    800502 <fd_close+0x72>

00800519 <close>:

int
close(int fdnum)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80051f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800522:	50                   	push   %eax
  800523:	ff 75 08             	pushl  0x8(%ebp)
  800526:	e8 b9 fe ff ff       	call   8003e4 <fd_lookup>
  80052b:	83 c4 08             	add    $0x8,%esp
  80052e:	85 c0                	test   %eax,%eax
  800530:	78 10                	js     800542 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	6a 01                	push   $0x1
  800537:	ff 75 f4             	pushl  -0xc(%ebp)
  80053a:	e8 51 ff ff ff       	call   800490 <fd_close>
  80053f:	83 c4 10             	add    $0x10,%esp
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <close_all>:

void
close_all(void)
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	53                   	push   %ebx
  800548:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80054b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	53                   	push   %ebx
  800554:	e8 c0 ff ff ff       	call   800519 <close>
	for (i = 0; i < MAXFD; i++)
  800559:	83 c3 01             	add    $0x1,%ebx
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 fb 20             	cmp    $0x20,%ebx
  800562:	75 ec                	jne    800550 <close_all+0xc>
}
  800564:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	57                   	push   %edi
  80056d:	56                   	push   %esi
  80056e:	53                   	push   %ebx
  80056f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800572:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800575:	50                   	push   %eax
  800576:	ff 75 08             	pushl  0x8(%ebp)
  800579:	e8 66 fe ff ff       	call   8003e4 <fd_lookup>
  80057e:	89 c3                	mov    %eax,%ebx
  800580:	83 c4 08             	add    $0x8,%esp
  800583:	85 c0                	test   %eax,%eax
  800585:	0f 88 81 00 00 00    	js     80060c <dup+0xa3>
		return r;
	close(newfdnum);
  80058b:	83 ec 0c             	sub    $0xc,%esp
  80058e:	ff 75 0c             	pushl  0xc(%ebp)
  800591:	e8 83 ff ff ff       	call   800519 <close>

	newfd = INDEX2FD(newfdnum);
  800596:	8b 75 0c             	mov    0xc(%ebp),%esi
  800599:	c1 e6 0c             	shl    $0xc,%esi
  80059c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005a2:	83 c4 04             	add    $0x4,%esp
  8005a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a8:	e8 d1 fd ff ff       	call   80037e <fd2data>
  8005ad:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005af:	89 34 24             	mov    %esi,(%esp)
  8005b2:	e8 c7 fd ff ff       	call   80037e <fd2data>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005bc:	89 d8                	mov    %ebx,%eax
  8005be:	c1 e8 16             	shr    $0x16,%eax
  8005c1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c8:	a8 01                	test   $0x1,%al
  8005ca:	74 11                	je     8005dd <dup+0x74>
  8005cc:	89 d8                	mov    %ebx,%eax
  8005ce:	c1 e8 0c             	shr    $0xc,%eax
  8005d1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d8:	f6 c2 01             	test   $0x1,%dl
  8005db:	75 39                	jne    800616 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e0:	89 d0                	mov    %edx,%eax
  8005e2:	c1 e8 0c             	shr    $0xc,%eax
  8005e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	25 07 0e 00 00       	and    $0xe07,%eax
  8005f4:	50                   	push   %eax
  8005f5:	56                   	push   %esi
  8005f6:	6a 00                	push   $0x0
  8005f8:	52                   	push   %edx
  8005f9:	6a 00                	push   $0x0
  8005fb:	e8 a1 fb ff ff       	call   8001a1 <sys_page_map>
  800600:	89 c3                	mov    %eax,%ebx
  800602:	83 c4 20             	add    $0x20,%esp
  800605:	85 c0                	test   %eax,%eax
  800607:	78 31                	js     80063a <dup+0xd1>
		goto err;

	return newfdnum;
  800609:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80060c:	89 d8                	mov    %ebx,%eax
  80060e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800611:	5b                   	pop    %ebx
  800612:	5e                   	pop    %esi
  800613:	5f                   	pop    %edi
  800614:	5d                   	pop    %ebp
  800615:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800616:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80061d:	83 ec 0c             	sub    $0xc,%esp
  800620:	25 07 0e 00 00       	and    $0xe07,%eax
  800625:	50                   	push   %eax
  800626:	57                   	push   %edi
  800627:	6a 00                	push   $0x0
  800629:	53                   	push   %ebx
  80062a:	6a 00                	push   $0x0
  80062c:	e8 70 fb ff ff       	call   8001a1 <sys_page_map>
  800631:	89 c3                	mov    %eax,%ebx
  800633:	83 c4 20             	add    $0x20,%esp
  800636:	85 c0                	test   %eax,%eax
  800638:	79 a3                	jns    8005dd <dup+0x74>
	sys_page_unmap(0, newfd);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	56                   	push   %esi
  80063e:	6a 00                	push   $0x0
  800640:	e8 9e fb ff ff       	call   8001e3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800645:	83 c4 08             	add    $0x8,%esp
  800648:	57                   	push   %edi
  800649:	6a 00                	push   $0x0
  80064b:	e8 93 fb ff ff       	call   8001e3 <sys_page_unmap>
	return r;
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	eb b7                	jmp    80060c <dup+0xa3>

00800655 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	53                   	push   %ebx
  800659:	83 ec 14             	sub    $0x14,%esp
  80065c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80065f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800662:	50                   	push   %eax
  800663:	53                   	push   %ebx
  800664:	e8 7b fd ff ff       	call   8003e4 <fd_lookup>
  800669:	83 c4 08             	add    $0x8,%esp
  80066c:	85 c0                	test   %eax,%eax
  80066e:	78 3f                	js     8006af <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800676:	50                   	push   %eax
  800677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067a:	ff 30                	pushl  (%eax)
  80067c:	e8 b9 fd ff ff       	call   80043a <dev_lookup>
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	85 c0                	test   %eax,%eax
  800686:	78 27                	js     8006af <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800688:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80068b:	8b 42 08             	mov    0x8(%edx),%eax
  80068e:	83 e0 03             	and    $0x3,%eax
  800691:	83 f8 01             	cmp    $0x1,%eax
  800694:	74 1e                	je     8006b4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800699:	8b 40 08             	mov    0x8(%eax),%eax
  80069c:	85 c0                	test   %eax,%eax
  80069e:	74 35                	je     8006d5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	ff 75 10             	pushl  0x10(%ebp)
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	52                   	push   %edx
  8006aa:	ff d0                	call   *%eax
  8006ac:	83 c4 10             	add    $0x10,%esp
}
  8006af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b9:	8b 40 48             	mov    0x48(%eax),%eax
  8006bc:	83 ec 04             	sub    $0x4,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	50                   	push   %eax
  8006c1:	68 b9 22 80 00       	push   $0x8022b9
  8006c6:	e8 9e 0e 00 00       	call   801569 <cprintf>
		return -E_INVAL;
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d3:	eb da                	jmp    8006af <read+0x5a>
		return -E_NOT_SUPP;
  8006d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006da:	eb d3                	jmp    8006af <read+0x5a>

008006dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	57                   	push   %edi
  8006e0:	56                   	push   %esi
  8006e1:	53                   	push   %ebx
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f0:	39 f3                	cmp    %esi,%ebx
  8006f2:	73 25                	jae    800719 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	89 f0                	mov    %esi,%eax
  8006f9:	29 d8                	sub    %ebx,%eax
  8006fb:	50                   	push   %eax
  8006fc:	89 d8                	mov    %ebx,%eax
  8006fe:	03 45 0c             	add    0xc(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	57                   	push   %edi
  800703:	e8 4d ff ff ff       	call   800655 <read>
		if (m < 0)
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	85 c0                	test   %eax,%eax
  80070d:	78 08                	js     800717 <readn+0x3b>
			return m;
		if (m == 0)
  80070f:	85 c0                	test   %eax,%eax
  800711:	74 06                	je     800719 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800713:	01 c3                	add    %eax,%ebx
  800715:	eb d9                	jmp    8006f0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800717:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800719:	89 d8                	mov    %ebx,%eax
  80071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071e:	5b                   	pop    %ebx
  80071f:	5e                   	pop    %esi
  800720:	5f                   	pop    %edi
  800721:	5d                   	pop    %ebp
  800722:	c3                   	ret    

00800723 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	53                   	push   %ebx
  800727:	83 ec 14             	sub    $0x14,%esp
  80072a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80072d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800730:	50                   	push   %eax
  800731:	53                   	push   %ebx
  800732:	e8 ad fc ff ff       	call   8003e4 <fd_lookup>
  800737:	83 c4 08             	add    $0x8,%esp
  80073a:	85 c0                	test   %eax,%eax
  80073c:	78 3a                	js     800778 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800748:	ff 30                	pushl  (%eax)
  80074a:	e8 eb fc ff ff       	call   80043a <dev_lookup>
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	85 c0                	test   %eax,%eax
  800754:	78 22                	js     800778 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800759:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80075d:	74 1e                	je     80077d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80075f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800762:	8b 52 0c             	mov    0xc(%edx),%edx
  800765:	85 d2                	test   %edx,%edx
  800767:	74 35                	je     80079e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800769:	83 ec 04             	sub    $0x4,%esp
  80076c:	ff 75 10             	pushl  0x10(%ebp)
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	50                   	push   %eax
  800773:	ff d2                	call   *%edx
  800775:	83 c4 10             	add    $0x10,%esp
}
  800778:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80077d:	a1 08 40 80 00       	mov    0x804008,%eax
  800782:	8b 40 48             	mov    0x48(%eax),%eax
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	53                   	push   %ebx
  800789:	50                   	push   %eax
  80078a:	68 d5 22 80 00       	push   $0x8022d5
  80078f:	e8 d5 0d 00 00       	call   801569 <cprintf>
		return -E_INVAL;
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079c:	eb da                	jmp    800778 <write+0x55>
		return -E_NOT_SUPP;
  80079e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007a3:	eb d3                	jmp    800778 <write+0x55>

008007a5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007ab:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007ae:	50                   	push   %eax
  8007af:	ff 75 08             	pushl  0x8(%ebp)
  8007b2:	e8 2d fc ff ff       	call   8003e4 <fd_lookup>
  8007b7:	83 c4 08             	add    $0x8,%esp
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	78 0e                	js     8007cc <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007c4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    

008007ce <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 14             	sub    $0x14,%esp
  8007d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	53                   	push   %ebx
  8007dd:	e8 02 fc ff ff       	call   8003e4 <fd_lookup>
  8007e2:	83 c4 08             	add    $0x8,%esp
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	78 37                	js     800820 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ef:	50                   	push   %eax
  8007f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f3:	ff 30                	pushl  (%eax)
  8007f5:	e8 40 fc ff ff       	call   80043a <dev_lookup>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	78 1f                	js     800820 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800808:	74 1b                	je     800825 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80080a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080d:	8b 52 18             	mov    0x18(%edx),%edx
  800810:	85 d2                	test   %edx,%edx
  800812:	74 32                	je     800846 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	ff d2                	call   *%edx
  80081d:	83 c4 10             	add    $0x10,%esp
}
  800820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800823:	c9                   	leave  
  800824:	c3                   	ret    
			thisenv->env_id, fdnum);
  800825:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80082a:	8b 40 48             	mov    0x48(%eax),%eax
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	53                   	push   %ebx
  800831:	50                   	push   %eax
  800832:	68 98 22 80 00       	push   $0x802298
  800837:	e8 2d 0d 00 00       	call   801569 <cprintf>
		return -E_INVAL;
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800844:	eb da                	jmp    800820 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800846:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80084b:	eb d3                	jmp    800820 <ftruncate+0x52>

0080084d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	53                   	push   %ebx
  800851:	83 ec 14             	sub    $0x14,%esp
  800854:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800857:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085a:	50                   	push   %eax
  80085b:	ff 75 08             	pushl  0x8(%ebp)
  80085e:	e8 81 fb ff ff       	call   8003e4 <fd_lookup>
  800863:	83 c4 08             	add    $0x8,%esp
  800866:	85 c0                	test   %eax,%eax
  800868:	78 4b                	js     8008b5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800870:	50                   	push   %eax
  800871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800874:	ff 30                	pushl  (%eax)
  800876:	e8 bf fb ff ff       	call   80043a <dev_lookup>
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	85 c0                	test   %eax,%eax
  800880:	78 33                	js     8008b5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800885:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800889:	74 2f                	je     8008ba <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80088b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80088e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800895:	00 00 00 
	stat->st_isdir = 0;
  800898:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80089f:	00 00 00 
	stat->st_dev = dev;
  8008a2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	53                   	push   %ebx
  8008ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8008af:	ff 50 14             	call   *0x14(%eax)
  8008b2:	83 c4 10             	add    $0x10,%esp
}
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    
		return -E_NOT_SUPP;
  8008ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008bf:	eb f4                	jmp    8008b5 <fstat+0x68>

008008c1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	56                   	push   %esi
  8008c5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	6a 00                	push   $0x0
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 e7 01 00 00       	call   800aba <open>
  8008d3:	89 c3                	mov    %eax,%ebx
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	78 1b                	js     8008f7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	e8 65 ff ff ff       	call   80084d <fstat>
  8008e8:	89 c6                	mov    %eax,%esi
	close(fd);
  8008ea:	89 1c 24             	mov    %ebx,(%esp)
  8008ed:	e8 27 fc ff ff       	call   800519 <close>
	return r;
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	89 f3                	mov    %esi,%ebx
}
  8008f7:	89 d8                	mov    %ebx,%eax
  8008f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	56                   	push   %esi
  800904:	53                   	push   %ebx
  800905:	89 c6                	mov    %eax,%esi
  800907:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800909:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800910:	74 27                	je     800939 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800912:	6a 07                	push   $0x7
  800914:	68 00 50 80 00       	push   $0x805000
  800919:	56                   	push   %esi
  80091a:	ff 35 00 40 80 00    	pushl  0x804000
  800920:	e8 07 16 00 00       	call   801f2c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800925:	83 c4 0c             	add    $0xc,%esp
  800928:	6a 00                	push   $0x0
  80092a:	53                   	push   %ebx
  80092b:	6a 00                	push   $0x0
  80092d:	e8 93 15 00 00       	call   801ec5 <ipc_recv>
}
  800932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	6a 01                	push   $0x1
  80093e:	e8 3d 16 00 00       	call   801f80 <ipc_find_env>
  800943:	a3 00 40 80 00       	mov    %eax,0x804000
  800948:	83 c4 10             	add    $0x10,%esp
  80094b:	eb c5                	jmp    800912 <fsipc+0x12>

0080094d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 40 0c             	mov    0xc(%eax),%eax
  800959:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	b8 02 00 00 00       	mov    $0x2,%eax
  800970:	e8 8b ff ff ff       	call   800900 <fsipc>
}
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <devfile_flush>:
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 40 0c             	mov    0xc(%eax),%eax
  800983:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
  80098d:	b8 06 00 00 00       	mov    $0x6,%eax
  800992:	e8 69 ff ff ff       	call   800900 <fsipc>
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <devfile_stat>:
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b8:	e8 43 ff ff ff       	call   800900 <fsipc>
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	78 2c                	js     8009ed <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	68 00 50 80 00       	push   $0x805000
  8009c9:	53                   	push   %ebx
  8009ca:	e8 b9 11 00 00       	call   801b88 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009cf:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009da:	a1 84 50 80 00       	mov    0x805084,%eax
  8009df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <devfile_write>:
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 0c             	sub    $0xc,%esp
  8009f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fb:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a00:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a05:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a08:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0b:	8b 52 0c             	mov    0xc(%edx),%edx
  800a0e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a14:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a19:	50                   	push   %eax
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	68 08 50 80 00       	push   $0x805008
  800a22:	e8 ef 12 00 00       	call   801d16 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a27:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2c:	b8 04 00 00 00       	mov    $0x4,%eax
  800a31:	e8 ca fe ff ff       	call   800900 <fsipc>
}
  800a36:	c9                   	leave  
  800a37:	c3                   	ret    

00800a38 <devfile_read>:
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 40 0c             	mov    0xc(%eax),%eax
  800a46:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a4b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a51:	ba 00 00 00 00       	mov    $0x0,%edx
  800a56:	b8 03 00 00 00       	mov    $0x3,%eax
  800a5b:	e8 a0 fe ff ff       	call   800900 <fsipc>
  800a60:	89 c3                	mov    %eax,%ebx
  800a62:	85 c0                	test   %eax,%eax
  800a64:	78 1f                	js     800a85 <devfile_read+0x4d>
	assert(r <= n);
  800a66:	39 f0                	cmp    %esi,%eax
  800a68:	77 24                	ja     800a8e <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a6f:	7f 33                	jg     800aa4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a71:	83 ec 04             	sub    $0x4,%esp
  800a74:	50                   	push   %eax
  800a75:	68 00 50 80 00       	push   $0x805000
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	e8 94 12 00 00       	call   801d16 <memmove>
	return r;
  800a82:	83 c4 10             	add    $0x10,%esp
}
  800a85:	89 d8                	mov    %ebx,%eax
  800a87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a8a:	5b                   	pop    %ebx
  800a8b:	5e                   	pop    %esi
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    
	assert(r <= n);
  800a8e:	68 08 23 80 00       	push   $0x802308
  800a93:	68 0f 23 80 00       	push   $0x80230f
  800a98:	6a 7b                	push   $0x7b
  800a9a:	68 24 23 80 00       	push   $0x802324
  800a9f:	e8 ea 09 00 00       	call   80148e <_panic>
	assert(r <= PGSIZE);
  800aa4:	68 2f 23 80 00       	push   $0x80232f
  800aa9:	68 0f 23 80 00       	push   $0x80230f
  800aae:	6a 7c                	push   $0x7c
  800ab0:	68 24 23 80 00       	push   $0x802324
  800ab5:	e8 d4 09 00 00       	call   80148e <_panic>

00800aba <open>:
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	83 ec 1c             	sub    $0x1c,%esp
  800ac2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ac5:	56                   	push   %esi
  800ac6:	e8 86 10 00 00       	call   801b51 <strlen>
  800acb:	83 c4 10             	add    $0x10,%esp
  800ace:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ad3:	7f 6c                	jg     800b41 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ad5:	83 ec 0c             	sub    $0xc,%esp
  800ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 b4 f8 ff ff       	call   800395 <fd_alloc>
  800ae1:	89 c3                	mov    %eax,%ebx
  800ae3:	83 c4 10             	add    $0x10,%esp
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	78 3c                	js     800b26 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	56                   	push   %esi
  800aee:	68 00 50 80 00       	push   $0x805000
  800af3:	e8 90 10 00 00       	call   801b88 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b03:	b8 01 00 00 00       	mov    $0x1,%eax
  800b08:	e8 f3 fd ff ff       	call   800900 <fsipc>
  800b0d:	89 c3                	mov    %eax,%ebx
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	85 c0                	test   %eax,%eax
  800b14:	78 19                	js     800b2f <open+0x75>
	return fd2num(fd);
  800b16:	83 ec 0c             	sub    $0xc,%esp
  800b19:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1c:	e8 4d f8 ff ff       	call   80036e <fd2num>
  800b21:	89 c3                	mov    %eax,%ebx
  800b23:	83 c4 10             	add    $0x10,%esp
}
  800b26:	89 d8                	mov    %ebx,%eax
  800b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    
		fd_close(fd, 0);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	6a 00                	push   $0x0
  800b34:	ff 75 f4             	pushl  -0xc(%ebp)
  800b37:	e8 54 f9 ff ff       	call   800490 <fd_close>
		return r;
  800b3c:	83 c4 10             	add    $0x10,%esp
  800b3f:	eb e5                	jmp    800b26 <open+0x6c>
		return -E_BAD_PATH;
  800b41:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b46:	eb de                	jmp    800b26 <open+0x6c>

00800b48 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b53:	b8 08 00 00 00       	mov    $0x8,%eax
  800b58:	e8 a3 fd ff ff       	call   800900 <fsipc>
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b65:	68 3b 23 80 00       	push   $0x80233b
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	e8 16 10 00 00       	call   801b88 <strcpy>
	return 0;
}
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <devsock_close>:
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	53                   	push   %ebx
  800b7d:	83 ec 10             	sub    $0x10,%esp
  800b80:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800b83:	53                   	push   %ebx
  800b84:	e8 30 14 00 00       	call   801fb9 <pageref>
  800b89:	83 c4 10             	add    $0x10,%esp
		return 0;
  800b8c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800b91:	83 f8 01             	cmp    $0x1,%eax
  800b94:	74 07                	je     800b9d <devsock_close+0x24>
}
  800b96:	89 d0                	mov    %edx,%eax
  800b98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800b9d:	83 ec 0c             	sub    $0xc,%esp
  800ba0:	ff 73 0c             	pushl  0xc(%ebx)
  800ba3:	e8 b7 02 00 00       	call   800e5f <nsipc_close>
  800ba8:	89 c2                	mov    %eax,%edx
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	eb e7                	jmp    800b96 <devsock_close+0x1d>

00800baf <devsock_write>:
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bb5:	6a 00                	push   $0x0
  800bb7:	ff 75 10             	pushl  0x10(%ebp)
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	ff 70 0c             	pushl  0xc(%eax)
  800bc3:	e8 74 03 00 00       	call   800f3c <nsipc_send>
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <devsock_read>:
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bd0:	6a 00                	push   $0x0
  800bd2:	ff 75 10             	pushl  0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff 70 0c             	pushl  0xc(%eax)
  800bde:	e8 ed 02 00 00       	call   800ed0 <nsipc_recv>
}
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <fd2sockid>:
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800beb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800bee:	52                   	push   %edx
  800bef:	50                   	push   %eax
  800bf0:	e8 ef f7 ff ff       	call   8003e4 <fd_lookup>
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	85 c0                	test   %eax,%eax
  800bfa:	78 10                	js     800c0c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bff:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800c05:	39 08                	cmp    %ecx,(%eax)
  800c07:	75 05                	jne    800c0e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c09:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    
		return -E_NOT_SUPP;
  800c0e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c13:	eb f7                	jmp    800c0c <fd2sockid+0x27>

00800c15 <alloc_sockfd>:
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
  800c1a:	83 ec 1c             	sub    $0x1c,%esp
  800c1d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c22:	50                   	push   %eax
  800c23:	e8 6d f7 ff ff       	call   800395 <fd_alloc>
  800c28:	89 c3                	mov    %eax,%ebx
  800c2a:	83 c4 10             	add    $0x10,%esp
  800c2d:	85 c0                	test   %eax,%eax
  800c2f:	78 43                	js     800c74 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c31:	83 ec 04             	sub    $0x4,%esp
  800c34:	68 07 04 00 00       	push   $0x407
  800c39:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3c:	6a 00                	push   $0x0
  800c3e:	e8 1b f5 ff ff       	call   80015e <sys_page_alloc>
  800c43:	89 c3                	mov    %eax,%ebx
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	85 c0                	test   %eax,%eax
  800c4a:	78 28                	js     800c74 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c4f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c55:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c5a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c61:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c64:	83 ec 0c             	sub    $0xc,%esp
  800c67:	50                   	push   %eax
  800c68:	e8 01 f7 ff ff       	call   80036e <fd2num>
  800c6d:	89 c3                	mov    %eax,%ebx
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	eb 0c                	jmp    800c80 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	56                   	push   %esi
  800c78:	e8 e2 01 00 00       	call   800e5f <nsipc_close>
		return r;
  800c7d:	83 c4 10             	add    $0x10,%esp
}
  800c80:	89 d8                	mov    %ebx,%eax
  800c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <accept>:
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	e8 4e ff ff ff       	call   800be5 <fd2sockid>
  800c97:	85 c0                	test   %eax,%eax
  800c99:	78 1b                	js     800cb6 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	ff 75 10             	pushl  0x10(%ebp)
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	50                   	push   %eax
  800ca5:	e8 0e 01 00 00       	call   800db8 <nsipc_accept>
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	85 c0                	test   %eax,%eax
  800caf:	78 05                	js     800cb6 <accept+0x2d>
	return alloc_sockfd(r);
  800cb1:	e8 5f ff ff ff       	call   800c15 <alloc_sockfd>
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <bind>:
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	e8 1f ff ff ff       	call   800be5 <fd2sockid>
  800cc6:	85 c0                	test   %eax,%eax
  800cc8:	78 12                	js     800cdc <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800cca:	83 ec 04             	sub    $0x4,%esp
  800ccd:	ff 75 10             	pushl  0x10(%ebp)
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	e8 2f 01 00 00       	call   800e08 <nsipc_bind>
  800cd9:	83 c4 10             	add    $0x10,%esp
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <shutdown>:
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	e8 f9 fe ff ff       	call   800be5 <fd2sockid>
  800cec:	85 c0                	test   %eax,%eax
  800cee:	78 0f                	js     800cff <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	50                   	push   %eax
  800cf7:	e8 41 01 00 00       	call   800e3d <nsipc_shutdown>
  800cfc:	83 c4 10             	add    $0x10,%esp
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <connect>:
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	e8 d6 fe ff ff       	call   800be5 <fd2sockid>
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	78 12                	js     800d25 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	ff 75 10             	pushl  0x10(%ebp)
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	50                   	push   %eax
  800d1d:	e8 57 01 00 00       	call   800e79 <nsipc_connect>
  800d22:	83 c4 10             	add    $0x10,%esp
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <listen>:
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	e8 b0 fe ff ff       	call   800be5 <fd2sockid>
  800d35:	85 c0                	test   %eax,%eax
  800d37:	78 0f                	js     800d48 <listen+0x21>
	return nsipc_listen(r, backlog);
  800d39:	83 ec 08             	sub    $0x8,%esp
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	50                   	push   %eax
  800d40:	e8 69 01 00 00       	call   800eae <nsipc_listen>
  800d45:	83 c4 10             	add    $0x10,%esp
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <socket>:

int
socket(int domain, int type, int protocol)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d50:	ff 75 10             	pushl  0x10(%ebp)
  800d53:	ff 75 0c             	pushl  0xc(%ebp)
  800d56:	ff 75 08             	pushl  0x8(%ebp)
  800d59:	e8 3c 02 00 00       	call   800f9a <nsipc_socket>
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	85 c0                	test   %eax,%eax
  800d63:	78 05                	js     800d6a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d65:	e8 ab fe ff ff       	call   800c15 <alloc_sockfd>
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 04             	sub    $0x4,%esp
  800d73:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d75:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d7c:	74 26                	je     800da4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800d7e:	6a 07                	push   $0x7
  800d80:	68 00 60 80 00       	push   $0x806000
  800d85:	53                   	push   %ebx
  800d86:	ff 35 04 40 80 00    	pushl  0x804004
  800d8c:	e8 9b 11 00 00       	call   801f2c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800d91:	83 c4 0c             	add    $0xc,%esp
  800d94:	6a 00                	push   $0x0
  800d96:	6a 00                	push   $0x0
  800d98:	6a 00                	push   $0x0
  800d9a:	e8 26 11 00 00       	call   801ec5 <ipc_recv>
}
  800d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	6a 02                	push   $0x2
  800da9:	e8 d2 11 00 00       	call   801f80 <ipc_find_env>
  800dae:	a3 04 40 80 00       	mov    %eax,0x804004
  800db3:	83 c4 10             	add    $0x10,%esp
  800db6:	eb c6                	jmp    800d7e <nsipc+0x12>

00800db8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800dc8:	8b 06                	mov    (%esi),%eax
  800dca:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800dcf:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd4:	e8 93 ff ff ff       	call   800d6c <nsipc>
  800dd9:	89 c3                	mov    %eax,%ebx
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	78 20                	js     800dff <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	ff 35 10 60 80 00    	pushl  0x806010
  800de8:	68 00 60 80 00       	push   $0x806000
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	e8 21 0f 00 00       	call   801d16 <memmove>
		*addrlen = ret->ret_addrlen;
  800df5:	a1 10 60 80 00       	mov    0x806010,%eax
  800dfa:	89 06                	mov    %eax,(%esi)
  800dfc:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800dff:	89 d8                	mov    %ebx,%eax
  800e01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e1a:	53                   	push   %ebx
  800e1b:	ff 75 0c             	pushl  0xc(%ebp)
  800e1e:	68 04 60 80 00       	push   $0x806004
  800e23:	e8 ee 0e 00 00       	call   801d16 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e28:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e2e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e33:	e8 34 ff ff ff       	call   800d6c <nsipc>
}
  800e38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e53:	b8 03 00 00 00       	mov    $0x3,%eax
  800e58:	e8 0f ff ff ff       	call   800d6c <nsipc>
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <nsipc_close>:

int
nsipc_close(int s)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e6d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e72:	e8 f5 fe ff ff       	call   800d6c <nsipc>
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	53                   	push   %ebx
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800e8b:	53                   	push   %ebx
  800e8c:	ff 75 0c             	pushl  0xc(%ebp)
  800e8f:	68 04 60 80 00       	push   $0x806004
  800e94:	e8 7d 0e 00 00       	call   801d16 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800e99:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800e9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea4:	e8 c3 fe ff ff       	call   800d6c <nsipc>
}
  800ea9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ec4:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec9:	e8 9e fe ff ff       	call   800d6c <nsipc>
}
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800ee0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800ee6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800eee:	b8 07 00 00 00       	mov    $0x7,%eax
  800ef3:	e8 74 fe ff ff       	call   800d6c <nsipc>
  800ef8:	89 c3                	mov    %eax,%ebx
  800efa:	85 c0                	test   %eax,%eax
  800efc:	78 1f                	js     800f1d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800efe:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800f03:	7f 21                	jg     800f26 <nsipc_recv+0x56>
  800f05:	39 c6                	cmp    %eax,%esi
  800f07:	7c 1d                	jl     800f26 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f09:	83 ec 04             	sub    $0x4,%esp
  800f0c:	50                   	push   %eax
  800f0d:	68 00 60 80 00       	push   $0x806000
  800f12:	ff 75 0c             	pushl  0xc(%ebp)
  800f15:	e8 fc 0d 00 00       	call   801d16 <memmove>
  800f1a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f1d:	89 d8                	mov    %ebx,%eax
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f26:	68 47 23 80 00       	push   $0x802347
  800f2b:	68 0f 23 80 00       	push   $0x80230f
  800f30:	6a 62                	push   $0x62
  800f32:	68 5c 23 80 00       	push   $0x80235c
  800f37:	e8 52 05 00 00       	call   80148e <_panic>

00800f3c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 04             	sub    $0x4,%esp
  800f43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f4e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f54:	7f 2e                	jg     800f84 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f56:	83 ec 04             	sub    $0x4,%esp
  800f59:	53                   	push   %ebx
  800f5a:	ff 75 0c             	pushl  0xc(%ebp)
  800f5d:	68 0c 60 80 00       	push   $0x80600c
  800f62:	e8 af 0d 00 00       	call   801d16 <memmove>
	nsipcbuf.send.req_size = size;
  800f67:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f70:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f75:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7a:	e8 ed fd ff ff       	call   800d6c <nsipc>
}
  800f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    
	assert(size < 1600);
  800f84:	68 68 23 80 00       	push   $0x802368
  800f89:	68 0f 23 80 00       	push   $0x80230f
  800f8e:	6a 6d                	push   $0x6d
  800f90:	68 5c 23 80 00       	push   $0x80235c
  800f95:	e8 f4 04 00 00       	call   80148e <_panic>

00800f9a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800fb8:	b8 09 00 00 00       	mov    $0x9,%eax
  800fbd:	e8 aa fd ff ff       	call   800d6c <nsipc>
}
  800fc2:	c9                   	leave  
  800fc3:	c3                   	ret    

00800fc4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	ff 75 08             	pushl  0x8(%ebp)
  800fd2:	e8 a7 f3 ff ff       	call   80037e <fd2data>
  800fd7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fd9:	83 c4 08             	add    $0x8,%esp
  800fdc:	68 74 23 80 00       	push   $0x802374
  800fe1:	53                   	push   %ebx
  800fe2:	e8 a1 0b 00 00       	call   801b88 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fe7:	8b 46 04             	mov    0x4(%esi),%eax
  800fea:	2b 06                	sub    (%esi),%eax
  800fec:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ff2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ff9:	00 00 00 
	stat->st_dev = &devpipe;
  800ffc:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801003:	30 80 00 
	return 0;
}
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	53                   	push   %ebx
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80101c:	53                   	push   %ebx
  80101d:	6a 00                	push   $0x0
  80101f:	e8 bf f1 ff ff       	call   8001e3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801024:	89 1c 24             	mov    %ebx,(%esp)
  801027:	e8 52 f3 ff ff       	call   80037e <fd2data>
  80102c:	83 c4 08             	add    $0x8,%esp
  80102f:	50                   	push   %eax
  801030:	6a 00                	push   $0x0
  801032:	e8 ac f1 ff ff       	call   8001e3 <sys_page_unmap>
}
  801037:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <_pipeisclosed>:
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	57                   	push   %edi
  801040:	56                   	push   %esi
  801041:	53                   	push   %ebx
  801042:	83 ec 1c             	sub    $0x1c,%esp
  801045:	89 c7                	mov    %eax,%edi
  801047:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801049:	a1 08 40 80 00       	mov    0x804008,%eax
  80104e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	57                   	push   %edi
  801055:	e8 5f 0f 00 00       	call   801fb9 <pageref>
  80105a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80105d:	89 34 24             	mov    %esi,(%esp)
  801060:	e8 54 0f 00 00       	call   801fb9 <pageref>
		nn = thisenv->env_runs;
  801065:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80106b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	39 cb                	cmp    %ecx,%ebx
  801073:	74 1b                	je     801090 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801075:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801078:	75 cf                	jne    801049 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80107a:	8b 42 58             	mov    0x58(%edx),%eax
  80107d:	6a 01                	push   $0x1
  80107f:	50                   	push   %eax
  801080:	53                   	push   %ebx
  801081:	68 7b 23 80 00       	push   $0x80237b
  801086:	e8 de 04 00 00       	call   801569 <cprintf>
  80108b:	83 c4 10             	add    $0x10,%esp
  80108e:	eb b9                	jmp    801049 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801090:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801093:	0f 94 c0             	sete   %al
  801096:	0f b6 c0             	movzbl %al,%eax
}
  801099:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <devpipe_write>:
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	57                   	push   %edi
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 28             	sub    $0x28,%esp
  8010aa:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010ad:	56                   	push   %esi
  8010ae:	e8 cb f2 ff ff       	call   80037e <fd2data>
  8010b3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8010bd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010c0:	74 4f                	je     801111 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010c2:	8b 43 04             	mov    0x4(%ebx),%eax
  8010c5:	8b 0b                	mov    (%ebx),%ecx
  8010c7:	8d 51 20             	lea    0x20(%ecx),%edx
  8010ca:	39 d0                	cmp    %edx,%eax
  8010cc:	72 14                	jb     8010e2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010ce:	89 da                	mov    %ebx,%edx
  8010d0:	89 f0                	mov    %esi,%eax
  8010d2:	e8 65 ff ff ff       	call   80103c <_pipeisclosed>
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	75 3a                	jne    801115 <devpipe_write+0x74>
			sys_yield();
  8010db:	e8 5f f0 ff ff       	call   80013f <sys_yield>
  8010e0:	eb e0                	jmp    8010c2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010e9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	c1 fa 1f             	sar    $0x1f,%edx
  8010f1:	89 d1                	mov    %edx,%ecx
  8010f3:	c1 e9 1b             	shr    $0x1b,%ecx
  8010f6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010f9:	83 e2 1f             	and    $0x1f,%edx
  8010fc:	29 ca                	sub    %ecx,%edx
  8010fe:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801102:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801106:	83 c0 01             	add    $0x1,%eax
  801109:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80110c:	83 c7 01             	add    $0x1,%edi
  80110f:	eb ac                	jmp    8010bd <devpipe_write+0x1c>
	return i;
  801111:	89 f8                	mov    %edi,%eax
  801113:	eb 05                	jmp    80111a <devpipe_write+0x79>
				return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111d:	5b                   	pop    %ebx
  80111e:	5e                   	pop    %esi
  80111f:	5f                   	pop    %edi
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    

00801122 <devpipe_read>:
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	57                   	push   %edi
  801126:	56                   	push   %esi
  801127:	53                   	push   %ebx
  801128:	83 ec 18             	sub    $0x18,%esp
  80112b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80112e:	57                   	push   %edi
  80112f:	e8 4a f2 ff ff       	call   80037e <fd2data>
  801134:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	be 00 00 00 00       	mov    $0x0,%esi
  80113e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801141:	74 47                	je     80118a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801143:	8b 03                	mov    (%ebx),%eax
  801145:	3b 43 04             	cmp    0x4(%ebx),%eax
  801148:	75 22                	jne    80116c <devpipe_read+0x4a>
			if (i > 0)
  80114a:	85 f6                	test   %esi,%esi
  80114c:	75 14                	jne    801162 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80114e:	89 da                	mov    %ebx,%edx
  801150:	89 f8                	mov    %edi,%eax
  801152:	e8 e5 fe ff ff       	call   80103c <_pipeisclosed>
  801157:	85 c0                	test   %eax,%eax
  801159:	75 33                	jne    80118e <devpipe_read+0x6c>
			sys_yield();
  80115b:	e8 df ef ff ff       	call   80013f <sys_yield>
  801160:	eb e1                	jmp    801143 <devpipe_read+0x21>
				return i;
  801162:	89 f0                	mov    %esi,%eax
}
  801164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80116c:	99                   	cltd   
  80116d:	c1 ea 1b             	shr    $0x1b,%edx
  801170:	01 d0                	add    %edx,%eax
  801172:	83 e0 1f             	and    $0x1f,%eax
  801175:	29 d0                	sub    %edx,%eax
  801177:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80117c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801182:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801185:	83 c6 01             	add    $0x1,%esi
  801188:	eb b4                	jmp    80113e <devpipe_read+0x1c>
	return i;
  80118a:	89 f0                	mov    %esi,%eax
  80118c:	eb d6                	jmp    801164 <devpipe_read+0x42>
				return 0;
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	eb cf                	jmp    801164 <devpipe_read+0x42>

00801195 <pipe>:
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	56                   	push   %esi
  801199:	53                   	push   %ebx
  80119a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80119d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a0:	50                   	push   %eax
  8011a1:	e8 ef f1 ff ff       	call   800395 <fd_alloc>
  8011a6:	89 c3                	mov    %eax,%ebx
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	78 5b                	js     80120a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011af:	83 ec 04             	sub    $0x4,%esp
  8011b2:	68 07 04 00 00       	push   $0x407
  8011b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ba:	6a 00                	push   $0x0
  8011bc:	e8 9d ef ff ff       	call   80015e <sys_page_alloc>
  8011c1:	89 c3                	mov    %eax,%ebx
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	78 40                	js     80120a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d0:	50                   	push   %eax
  8011d1:	e8 bf f1 ff ff       	call   800395 <fd_alloc>
  8011d6:	89 c3                	mov    %eax,%ebx
  8011d8:	83 c4 10             	add    $0x10,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	78 1b                	js     8011fa <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	68 07 04 00 00       	push   $0x407
  8011e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ea:	6a 00                	push   $0x0
  8011ec:	e8 6d ef ff ff       	call   80015e <sys_page_alloc>
  8011f1:	89 c3                	mov    %eax,%ebx
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	79 19                	jns    801213 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801200:	6a 00                	push   $0x0
  801202:	e8 dc ef ff ff       	call   8001e3 <sys_page_unmap>
  801207:	83 c4 10             	add    $0x10,%esp
}
  80120a:	89 d8                	mov    %ebx,%eax
  80120c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80120f:	5b                   	pop    %ebx
  801210:	5e                   	pop    %esi
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    
	va = fd2data(fd0);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	ff 75 f4             	pushl  -0xc(%ebp)
  801219:	e8 60 f1 ff ff       	call   80037e <fd2data>
  80121e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801220:	83 c4 0c             	add    $0xc,%esp
  801223:	68 07 04 00 00       	push   $0x407
  801228:	50                   	push   %eax
  801229:	6a 00                	push   $0x0
  80122b:	e8 2e ef ff ff       	call   80015e <sys_page_alloc>
  801230:	89 c3                	mov    %eax,%ebx
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	0f 88 8c 00 00 00    	js     8012c9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	ff 75 f0             	pushl  -0x10(%ebp)
  801243:	e8 36 f1 ff ff       	call   80037e <fd2data>
  801248:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80124f:	50                   	push   %eax
  801250:	6a 00                	push   $0x0
  801252:	56                   	push   %esi
  801253:	6a 00                	push   $0x0
  801255:	e8 47 ef ff ff       	call   8001a1 <sys_page_map>
  80125a:	89 c3                	mov    %eax,%ebx
  80125c:	83 c4 20             	add    $0x20,%esp
  80125f:	85 c0                	test   %eax,%eax
  801261:	78 58                	js     8012bb <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801266:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80126c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801271:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801281:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801286:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	e8 d6 f0 ff ff       	call   80036e <fd2num>
  801298:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80129b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80129d:	83 c4 04             	add    $0x4,%esp
  8012a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8012a3:	e8 c6 f0 ff ff       	call   80036e <fd2num>
  8012a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ab:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b6:	e9 4f ff ff ff       	jmp    80120a <pipe+0x75>
	sys_page_unmap(0, va);
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	56                   	push   %esi
  8012bf:	6a 00                	push   $0x0
  8012c1:	e8 1d ef ff ff       	call   8001e3 <sys_page_unmap>
  8012c6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012c9:	83 ec 08             	sub    $0x8,%esp
  8012cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 0d ef ff ff       	call   8001e3 <sys_page_unmap>
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	e9 1c ff ff ff       	jmp    8011fa <pipe+0x65>

008012de <pipeisclosed>:
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e7:	50                   	push   %eax
  8012e8:	ff 75 08             	pushl  0x8(%ebp)
  8012eb:	e8 f4 f0 ff ff       	call   8003e4 <fd_lookup>
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 18                	js     80130f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012f7:	83 ec 0c             	sub    $0xc,%esp
  8012fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fd:	e8 7c f0 ff ff       	call   80037e <fd2data>
	return _pipeisclosed(fd, p);
  801302:	89 c2                	mov    %eax,%edx
  801304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801307:	e8 30 fd ff ff       	call   80103c <_pipeisclosed>
  80130c:	83 c4 10             	add    $0x10,%esp
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    

0080131b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801321:	68 93 23 80 00       	push   $0x802393
  801326:	ff 75 0c             	pushl  0xc(%ebp)
  801329:	e8 5a 08 00 00       	call   801b88 <strcpy>
	return 0;
}
  80132e:	b8 00 00 00 00       	mov    $0x0,%eax
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <devcons_write>:
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801341:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801346:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80134c:	eb 2f                	jmp    80137d <devcons_write+0x48>
		m = n - tot;
  80134e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801351:	29 f3                	sub    %esi,%ebx
  801353:	83 fb 7f             	cmp    $0x7f,%ebx
  801356:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80135b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80135e:	83 ec 04             	sub    $0x4,%esp
  801361:	53                   	push   %ebx
  801362:	89 f0                	mov    %esi,%eax
  801364:	03 45 0c             	add    0xc(%ebp),%eax
  801367:	50                   	push   %eax
  801368:	57                   	push   %edi
  801369:	e8 a8 09 00 00       	call   801d16 <memmove>
		sys_cputs(buf, m);
  80136e:	83 c4 08             	add    $0x8,%esp
  801371:	53                   	push   %ebx
  801372:	57                   	push   %edi
  801373:	e8 2a ed ff ff       	call   8000a2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801378:	01 de                	add    %ebx,%esi
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801380:	72 cc                	jb     80134e <devcons_write+0x19>
}
  801382:	89 f0                	mov    %esi,%eax
  801384:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5f                   	pop    %edi
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    

0080138c <devcons_read>:
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 08             	sub    $0x8,%esp
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	75 07                	jne    8013a4 <devcons_read+0x18>
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    
		sys_yield();
  80139f:	e8 9b ed ff ff       	call   80013f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013a4:	e8 17 ed ff ff       	call   8000c0 <sys_cgetc>
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	74 f2                	je     80139f <devcons_read+0x13>
	if (c < 0)
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 ec                	js     80139d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013b1:	83 f8 04             	cmp    $0x4,%eax
  8013b4:	74 0c                	je     8013c2 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	88 02                	mov    %al,(%edx)
	return 1;
  8013bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8013c0:	eb db                	jmp    80139d <devcons_read+0x11>
		return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	eb d4                	jmp    80139d <devcons_read+0x11>

008013c9 <cputchar>:
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013d5:	6a 01                	push   $0x1
  8013d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013da:	50                   	push   %eax
  8013db:	e8 c2 ec ff ff       	call   8000a2 <sys_cputs>
}
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <getchar>:
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013eb:	6a 01                	push   $0x1
  8013ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 5d f2 ff ff       	call   800655 <read>
	if (r < 0)
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 08                	js     801407 <getchar+0x22>
	if (r < 1)
  8013ff:	85 c0                	test   %eax,%eax
  801401:	7e 06                	jle    801409 <getchar+0x24>
	return c;
  801403:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    
		return -E_EOF;
  801409:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80140e:	eb f7                	jmp    801407 <getchar+0x22>

00801410 <iscons>:
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801416:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801419:	50                   	push   %eax
  80141a:	ff 75 08             	pushl  0x8(%ebp)
  80141d:	e8 c2 ef ff ff       	call   8003e4 <fd_lookup>
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	78 11                	js     80143a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801432:	39 10                	cmp    %edx,(%eax)
  801434:	0f 94 c0             	sete   %al
  801437:	0f b6 c0             	movzbl %al,%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <opencons>:
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801442:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801445:	50                   	push   %eax
  801446:	e8 4a ef ff ff       	call   800395 <fd_alloc>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 3a                	js     80148c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801452:	83 ec 04             	sub    $0x4,%esp
  801455:	68 07 04 00 00       	push   $0x407
  80145a:	ff 75 f4             	pushl  -0xc(%ebp)
  80145d:	6a 00                	push   $0x0
  80145f:	e8 fa ec ff ff       	call   80015e <sys_page_alloc>
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 21                	js     80148c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801474:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801479:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801480:	83 ec 0c             	sub    $0xc,%esp
  801483:	50                   	push   %eax
  801484:	e8 e5 ee ff ff       	call   80036e <fd2num>
  801489:	83 c4 10             	add    $0x10,%esp
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	56                   	push   %esi
  801492:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801493:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801496:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80149c:	e8 7f ec ff ff       	call   800120 <sys_getenvid>
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	ff 75 08             	pushl  0x8(%ebp)
  8014aa:	56                   	push   %esi
  8014ab:	50                   	push   %eax
  8014ac:	68 a0 23 80 00       	push   $0x8023a0
  8014b1:	e8 b3 00 00 00       	call   801569 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014b6:	83 c4 18             	add    $0x18,%esp
  8014b9:	53                   	push   %ebx
  8014ba:	ff 75 10             	pushl  0x10(%ebp)
  8014bd:	e8 56 00 00 00       	call   801518 <vcprintf>
	cprintf("\n");
  8014c2:	c7 04 24 8c 23 80 00 	movl   $0x80238c,(%esp)
  8014c9:	e8 9b 00 00 00       	call   801569 <cprintf>
  8014ce:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014d1:	cc                   	int3   
  8014d2:	eb fd                	jmp    8014d1 <_panic+0x43>

008014d4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014de:	8b 13                	mov    (%ebx),%edx
  8014e0:	8d 42 01             	lea    0x1(%edx),%eax
  8014e3:	89 03                	mov    %eax,(%ebx)
  8014e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014f1:	74 09                	je     8014fc <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014f3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014fc:	83 ec 08             	sub    $0x8,%esp
  8014ff:	68 ff 00 00 00       	push   $0xff
  801504:	8d 43 08             	lea    0x8(%ebx),%eax
  801507:	50                   	push   %eax
  801508:	e8 95 eb ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  80150d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	eb db                	jmp    8014f3 <putch+0x1f>

00801518 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801521:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801528:	00 00 00 
	b.cnt = 0;
  80152b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801532:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801535:	ff 75 0c             	pushl  0xc(%ebp)
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801541:	50                   	push   %eax
  801542:	68 d4 14 80 00       	push   $0x8014d4
  801547:	e8 1a 01 00 00       	call   801666 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80154c:	83 c4 08             	add    $0x8,%esp
  80154f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801555:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	e8 41 eb ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  801561:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80156f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801572:	50                   	push   %eax
  801573:	ff 75 08             	pushl  0x8(%ebp)
  801576:	e8 9d ff ff ff       	call   801518 <vcprintf>
	va_end(ap);

	return cnt;
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	57                   	push   %edi
  801581:	56                   	push   %esi
  801582:	53                   	push   %ebx
  801583:	83 ec 1c             	sub    $0x1c,%esp
  801586:	89 c7                	mov    %eax,%edi
  801588:	89 d6                	mov    %edx,%esi
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801590:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801593:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801596:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801599:	bb 00 00 00 00       	mov    $0x0,%ebx
  80159e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015a1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015a4:	39 d3                	cmp    %edx,%ebx
  8015a6:	72 05                	jb     8015ad <printnum+0x30>
  8015a8:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015ab:	77 7a                	ja     801627 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015ad:	83 ec 0c             	sub    $0xc,%esp
  8015b0:	ff 75 18             	pushl  0x18(%ebp)
  8015b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015b9:	53                   	push   %ebx
  8015ba:	ff 75 10             	pushl  0x10(%ebp)
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8015c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8015c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8015cc:	e8 2f 0a 00 00       	call   802000 <__udivdi3>
  8015d1:	83 c4 18             	add    $0x18,%esp
  8015d4:	52                   	push   %edx
  8015d5:	50                   	push   %eax
  8015d6:	89 f2                	mov    %esi,%edx
  8015d8:	89 f8                	mov    %edi,%eax
  8015da:	e8 9e ff ff ff       	call   80157d <printnum>
  8015df:	83 c4 20             	add    $0x20,%esp
  8015e2:	eb 13                	jmp    8015f7 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015e4:	83 ec 08             	sub    $0x8,%esp
  8015e7:	56                   	push   %esi
  8015e8:	ff 75 18             	pushl  0x18(%ebp)
  8015eb:	ff d7                	call   *%edi
  8015ed:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015f0:	83 eb 01             	sub    $0x1,%ebx
  8015f3:	85 db                	test   %ebx,%ebx
  8015f5:	7f ed                	jg     8015e4 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	56                   	push   %esi
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801601:	ff 75 e0             	pushl  -0x20(%ebp)
  801604:	ff 75 dc             	pushl  -0x24(%ebp)
  801607:	ff 75 d8             	pushl  -0x28(%ebp)
  80160a:	e8 11 0b 00 00       	call   802120 <__umoddi3>
  80160f:	83 c4 14             	add    $0x14,%esp
  801612:	0f be 80 c3 23 80 00 	movsbl 0x8023c3(%eax),%eax
  801619:	50                   	push   %eax
  80161a:	ff d7                	call   *%edi
}
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801622:	5b                   	pop    %ebx
  801623:	5e                   	pop    %esi
  801624:	5f                   	pop    %edi
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    
  801627:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162a:	eb c4                	jmp    8015f0 <printnum+0x73>

0080162c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801632:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801636:	8b 10                	mov    (%eax),%edx
  801638:	3b 50 04             	cmp    0x4(%eax),%edx
  80163b:	73 0a                	jae    801647 <sprintputch+0x1b>
		*b->buf++ = ch;
  80163d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801640:	89 08                	mov    %ecx,(%eax)
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	88 02                	mov    %al,(%edx)
}
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    

00801649 <printfmt>:
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80164f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801652:	50                   	push   %eax
  801653:	ff 75 10             	pushl  0x10(%ebp)
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 05 00 00 00       	call   801666 <vprintfmt>
}
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <vprintfmt>:
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	57                   	push   %edi
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
  80166c:	83 ec 2c             	sub    $0x2c,%esp
  80166f:	8b 75 08             	mov    0x8(%ebp),%esi
  801672:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801675:	8b 7d 10             	mov    0x10(%ebp),%edi
  801678:	e9 c1 03 00 00       	jmp    801a3e <vprintfmt+0x3d8>
		padc = ' ';
  80167d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801681:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801688:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80168f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801696:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80169b:	8d 47 01             	lea    0x1(%edi),%eax
  80169e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016a1:	0f b6 17             	movzbl (%edi),%edx
  8016a4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016a7:	3c 55                	cmp    $0x55,%al
  8016a9:	0f 87 12 04 00 00    	ja     801ac1 <vprintfmt+0x45b>
  8016af:	0f b6 c0             	movzbl %al,%eax
  8016b2:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  8016b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016bc:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016c0:	eb d9                	jmp    80169b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016c5:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016c9:	eb d0                	jmp    80169b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016cb:	0f b6 d2             	movzbl %dl,%edx
  8016ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016d9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016dc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016e0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016e3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016e6:	83 f9 09             	cmp    $0x9,%ecx
  8016e9:	77 55                	ja     801740 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016eb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016ee:	eb e9                	jmp    8016d9 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f3:	8b 00                	mov    (%eax),%eax
  8016f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8016f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fb:	8d 40 04             	lea    0x4(%eax),%eax
  8016fe:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801701:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801704:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801708:	79 91                	jns    80169b <vprintfmt+0x35>
				width = precision, precision = -1;
  80170a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80170d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801710:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801717:	eb 82                	jmp    80169b <vprintfmt+0x35>
  801719:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80171c:	85 c0                	test   %eax,%eax
  80171e:	ba 00 00 00 00       	mov    $0x0,%edx
  801723:	0f 49 d0             	cmovns %eax,%edx
  801726:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801729:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80172c:	e9 6a ff ff ff       	jmp    80169b <vprintfmt+0x35>
  801731:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801734:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80173b:	e9 5b ff ff ff       	jmp    80169b <vprintfmt+0x35>
  801740:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801743:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801746:	eb bc                	jmp    801704 <vprintfmt+0x9e>
			lflag++;
  801748:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80174b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80174e:	e9 48 ff ff ff       	jmp    80169b <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	8d 78 04             	lea    0x4(%eax),%edi
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	53                   	push   %ebx
  80175d:	ff 30                	pushl  (%eax)
  80175f:	ff d6                	call   *%esi
			break;
  801761:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801764:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801767:	e9 cf 02 00 00       	jmp    801a3b <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80176c:	8b 45 14             	mov    0x14(%ebp),%eax
  80176f:	8d 78 04             	lea    0x4(%eax),%edi
  801772:	8b 00                	mov    (%eax),%eax
  801774:	99                   	cltd   
  801775:	31 d0                	xor    %edx,%eax
  801777:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801779:	83 f8 0f             	cmp    $0xf,%eax
  80177c:	7f 23                	jg     8017a1 <vprintfmt+0x13b>
  80177e:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  801785:	85 d2                	test   %edx,%edx
  801787:	74 18                	je     8017a1 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801789:	52                   	push   %edx
  80178a:	68 21 23 80 00       	push   $0x802321
  80178f:	53                   	push   %ebx
  801790:	56                   	push   %esi
  801791:	e8 b3 fe ff ff       	call   801649 <printfmt>
  801796:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801799:	89 7d 14             	mov    %edi,0x14(%ebp)
  80179c:	e9 9a 02 00 00       	jmp    801a3b <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8017a1:	50                   	push   %eax
  8017a2:	68 db 23 80 00       	push   $0x8023db
  8017a7:	53                   	push   %ebx
  8017a8:	56                   	push   %esi
  8017a9:	e8 9b fe ff ff       	call   801649 <printfmt>
  8017ae:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017b1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017b4:	e9 82 02 00 00       	jmp    801a3b <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bc:	83 c0 04             	add    $0x4,%eax
  8017bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c5:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017c7:	85 ff                	test   %edi,%edi
  8017c9:	b8 d4 23 80 00       	mov    $0x8023d4,%eax
  8017ce:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017d5:	0f 8e bd 00 00 00    	jle    801898 <vprintfmt+0x232>
  8017db:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017df:	75 0e                	jne    8017ef <vprintfmt+0x189>
  8017e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8017e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017e7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017ea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017ed:	eb 6d                	jmp    80185c <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017ef:	83 ec 08             	sub    $0x8,%esp
  8017f2:	ff 75 d0             	pushl  -0x30(%ebp)
  8017f5:	57                   	push   %edi
  8017f6:	e8 6e 03 00 00       	call   801b69 <strnlen>
  8017fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017fe:	29 c1                	sub    %eax,%ecx
  801800:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801803:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801806:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80180a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80180d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801810:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801812:	eb 0f                	jmp    801823 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801814:	83 ec 08             	sub    $0x8,%esp
  801817:	53                   	push   %ebx
  801818:	ff 75 e0             	pushl  -0x20(%ebp)
  80181b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80181d:	83 ef 01             	sub    $0x1,%edi
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	85 ff                	test   %edi,%edi
  801825:	7f ed                	jg     801814 <vprintfmt+0x1ae>
  801827:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80182a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80182d:	85 c9                	test   %ecx,%ecx
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	0f 49 c1             	cmovns %ecx,%eax
  801837:	29 c1                	sub    %eax,%ecx
  801839:	89 75 08             	mov    %esi,0x8(%ebp)
  80183c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80183f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801842:	89 cb                	mov    %ecx,%ebx
  801844:	eb 16                	jmp    80185c <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801846:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80184a:	75 31                	jne    80187d <vprintfmt+0x217>
					putch(ch, putdat);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	50                   	push   %eax
  801853:	ff 55 08             	call   *0x8(%ebp)
  801856:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801859:	83 eb 01             	sub    $0x1,%ebx
  80185c:	83 c7 01             	add    $0x1,%edi
  80185f:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801863:	0f be c2             	movsbl %dl,%eax
  801866:	85 c0                	test   %eax,%eax
  801868:	74 59                	je     8018c3 <vprintfmt+0x25d>
  80186a:	85 f6                	test   %esi,%esi
  80186c:	78 d8                	js     801846 <vprintfmt+0x1e0>
  80186e:	83 ee 01             	sub    $0x1,%esi
  801871:	79 d3                	jns    801846 <vprintfmt+0x1e0>
  801873:	89 df                	mov    %ebx,%edi
  801875:	8b 75 08             	mov    0x8(%ebp),%esi
  801878:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80187b:	eb 37                	jmp    8018b4 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80187d:	0f be d2             	movsbl %dl,%edx
  801880:	83 ea 20             	sub    $0x20,%edx
  801883:	83 fa 5e             	cmp    $0x5e,%edx
  801886:	76 c4                	jbe    80184c <vprintfmt+0x1e6>
					putch('?', putdat);
  801888:	83 ec 08             	sub    $0x8,%esp
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	6a 3f                	push   $0x3f
  801890:	ff 55 08             	call   *0x8(%ebp)
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	eb c1                	jmp    801859 <vprintfmt+0x1f3>
  801898:	89 75 08             	mov    %esi,0x8(%ebp)
  80189b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80189e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018a1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018a4:	eb b6                	jmp    80185c <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018a6:	83 ec 08             	sub    $0x8,%esp
  8018a9:	53                   	push   %ebx
  8018aa:	6a 20                	push   $0x20
  8018ac:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018ae:	83 ef 01             	sub    $0x1,%edi
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	85 ff                	test   %edi,%edi
  8018b6:	7f ee                	jg     8018a6 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8018be:	e9 78 01 00 00       	jmp    801a3b <vprintfmt+0x3d5>
  8018c3:	89 df                	mov    %ebx,%edi
  8018c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018cb:	eb e7                	jmp    8018b4 <vprintfmt+0x24e>
	if (lflag >= 2)
  8018cd:	83 f9 01             	cmp    $0x1,%ecx
  8018d0:	7e 3f                	jle    801911 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d5:	8b 50 04             	mov    0x4(%eax),%edx
  8018d8:	8b 00                	mov    (%eax),%eax
  8018da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e3:	8d 40 08             	lea    0x8(%eax),%eax
  8018e6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018ed:	79 5c                	jns    80194b <vprintfmt+0x2e5>
				putch('-', putdat);
  8018ef:	83 ec 08             	sub    $0x8,%esp
  8018f2:	53                   	push   %ebx
  8018f3:	6a 2d                	push   $0x2d
  8018f5:	ff d6                	call   *%esi
				num = -(long long) num;
  8018f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8018fd:	f7 da                	neg    %edx
  8018ff:	83 d1 00             	adc    $0x0,%ecx
  801902:	f7 d9                	neg    %ecx
  801904:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801907:	b8 0a 00 00 00       	mov    $0xa,%eax
  80190c:	e9 10 01 00 00       	jmp    801a21 <vprintfmt+0x3bb>
	else if (lflag)
  801911:	85 c9                	test   %ecx,%ecx
  801913:	75 1b                	jne    801930 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801915:	8b 45 14             	mov    0x14(%ebp),%eax
  801918:	8b 00                	mov    (%eax),%eax
  80191a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80191d:	89 c1                	mov    %eax,%ecx
  80191f:	c1 f9 1f             	sar    $0x1f,%ecx
  801922:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801925:	8b 45 14             	mov    0x14(%ebp),%eax
  801928:	8d 40 04             	lea    0x4(%eax),%eax
  80192b:	89 45 14             	mov    %eax,0x14(%ebp)
  80192e:	eb b9                	jmp    8018e9 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	8b 00                	mov    (%eax),%eax
  801935:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801938:	89 c1                	mov    %eax,%ecx
  80193a:	c1 f9 1f             	sar    $0x1f,%ecx
  80193d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801940:	8b 45 14             	mov    0x14(%ebp),%eax
  801943:	8d 40 04             	lea    0x4(%eax),%eax
  801946:	89 45 14             	mov    %eax,0x14(%ebp)
  801949:	eb 9e                	jmp    8018e9 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80194b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80194e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801951:	b8 0a 00 00 00       	mov    $0xa,%eax
  801956:	e9 c6 00 00 00       	jmp    801a21 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80195b:	83 f9 01             	cmp    $0x1,%ecx
  80195e:	7e 18                	jle    801978 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801960:	8b 45 14             	mov    0x14(%ebp),%eax
  801963:	8b 10                	mov    (%eax),%edx
  801965:	8b 48 04             	mov    0x4(%eax),%ecx
  801968:	8d 40 08             	lea    0x8(%eax),%eax
  80196b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80196e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801973:	e9 a9 00 00 00       	jmp    801a21 <vprintfmt+0x3bb>
	else if (lflag)
  801978:	85 c9                	test   %ecx,%ecx
  80197a:	75 1a                	jne    801996 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80197c:	8b 45 14             	mov    0x14(%ebp),%eax
  80197f:	8b 10                	mov    (%eax),%edx
  801981:	b9 00 00 00 00       	mov    $0x0,%ecx
  801986:	8d 40 04             	lea    0x4(%eax),%eax
  801989:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80198c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801991:	e9 8b 00 00 00       	jmp    801a21 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801996:	8b 45 14             	mov    0x14(%ebp),%eax
  801999:	8b 10                	mov    (%eax),%edx
  80199b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a0:	8d 40 04             	lea    0x4(%eax),%eax
  8019a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019ab:	eb 74                	jmp    801a21 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019ad:	83 f9 01             	cmp    $0x1,%ecx
  8019b0:	7e 15                	jle    8019c7 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b5:	8b 10                	mov    (%eax),%edx
  8019b7:	8b 48 04             	mov    0x4(%eax),%ecx
  8019ba:	8d 40 08             	lea    0x8(%eax),%eax
  8019bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019c0:	b8 08 00 00 00       	mov    $0x8,%eax
  8019c5:	eb 5a                	jmp    801a21 <vprintfmt+0x3bb>
	else if (lflag)
  8019c7:	85 c9                	test   %ecx,%ecx
  8019c9:	75 17                	jne    8019e2 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ce:	8b 10                	mov    (%eax),%edx
  8019d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d5:	8d 40 04             	lea    0x4(%eax),%eax
  8019d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019db:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e0:	eb 3f                	jmp    801a21 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e5:	8b 10                	mov    (%eax),%edx
  8019e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ec:	8d 40 04             	lea    0x4(%eax),%eax
  8019ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f7:	eb 28                	jmp    801a21 <vprintfmt+0x3bb>
			putch('0', putdat);
  8019f9:	83 ec 08             	sub    $0x8,%esp
  8019fc:	53                   	push   %ebx
  8019fd:	6a 30                	push   $0x30
  8019ff:	ff d6                	call   *%esi
			putch('x', putdat);
  801a01:	83 c4 08             	add    $0x8,%esp
  801a04:	53                   	push   %ebx
  801a05:	6a 78                	push   $0x78
  801a07:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a09:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0c:	8b 10                	mov    (%eax),%edx
  801a0e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a13:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a16:	8d 40 04             	lea    0x4(%eax),%eax
  801a19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a1c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a21:	83 ec 0c             	sub    $0xc,%esp
  801a24:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a28:	57                   	push   %edi
  801a29:	ff 75 e0             	pushl  -0x20(%ebp)
  801a2c:	50                   	push   %eax
  801a2d:	51                   	push   %ecx
  801a2e:	52                   	push   %edx
  801a2f:	89 da                	mov    %ebx,%edx
  801a31:	89 f0                	mov    %esi,%eax
  801a33:	e8 45 fb ff ff       	call   80157d <printnum>
			break;
  801a38:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a3b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a3e:	83 c7 01             	add    $0x1,%edi
  801a41:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a45:	83 f8 25             	cmp    $0x25,%eax
  801a48:	0f 84 2f fc ff ff    	je     80167d <vprintfmt+0x17>
			if (ch == '\0')
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	0f 84 8b 00 00 00    	je     801ae1 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a56:	83 ec 08             	sub    $0x8,%esp
  801a59:	53                   	push   %ebx
  801a5a:	50                   	push   %eax
  801a5b:	ff d6                	call   *%esi
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	eb dc                	jmp    801a3e <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a62:	83 f9 01             	cmp    $0x1,%ecx
  801a65:	7e 15                	jle    801a7c <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a67:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6a:	8b 10                	mov    (%eax),%edx
  801a6c:	8b 48 04             	mov    0x4(%eax),%ecx
  801a6f:	8d 40 08             	lea    0x8(%eax),%eax
  801a72:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a75:	b8 10 00 00 00       	mov    $0x10,%eax
  801a7a:	eb a5                	jmp    801a21 <vprintfmt+0x3bb>
	else if (lflag)
  801a7c:	85 c9                	test   %ecx,%ecx
  801a7e:	75 17                	jne    801a97 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a80:	8b 45 14             	mov    0x14(%ebp),%eax
  801a83:	8b 10                	mov    (%eax),%edx
  801a85:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8a:	8d 40 04             	lea    0x4(%eax),%eax
  801a8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a90:	b8 10 00 00 00       	mov    $0x10,%eax
  801a95:	eb 8a                	jmp    801a21 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a97:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9a:	8b 10                	mov    (%eax),%edx
  801a9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa1:	8d 40 04             	lea    0x4(%eax),%eax
  801aa4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa7:	b8 10 00 00 00       	mov    $0x10,%eax
  801aac:	e9 70 ff ff ff       	jmp    801a21 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801ab1:	83 ec 08             	sub    $0x8,%esp
  801ab4:	53                   	push   %ebx
  801ab5:	6a 25                	push   $0x25
  801ab7:	ff d6                	call   *%esi
			break;
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	e9 7a ff ff ff       	jmp    801a3b <vprintfmt+0x3d5>
			putch('%', putdat);
  801ac1:	83 ec 08             	sub    $0x8,%esp
  801ac4:	53                   	push   %ebx
  801ac5:	6a 25                	push   $0x25
  801ac7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ac9:	83 c4 10             	add    $0x10,%esp
  801acc:	89 f8                	mov    %edi,%eax
  801ace:	eb 03                	jmp    801ad3 <vprintfmt+0x46d>
  801ad0:	83 e8 01             	sub    $0x1,%eax
  801ad3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ad7:	75 f7                	jne    801ad0 <vprintfmt+0x46a>
  801ad9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801adc:	e9 5a ff ff ff       	jmp    801a3b <vprintfmt+0x3d5>
}
  801ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5f                   	pop    %edi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 18             	sub    $0x18,%esp
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801af8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801afc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b06:	85 c0                	test   %eax,%eax
  801b08:	74 26                	je     801b30 <vsnprintf+0x47>
  801b0a:	85 d2                	test   %edx,%edx
  801b0c:	7e 22                	jle    801b30 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b0e:	ff 75 14             	pushl  0x14(%ebp)
  801b11:	ff 75 10             	pushl  0x10(%ebp)
  801b14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b17:	50                   	push   %eax
  801b18:	68 2c 16 80 00       	push   $0x80162c
  801b1d:	e8 44 fb ff ff       	call   801666 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b25:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2b:	83 c4 10             	add    $0x10,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    
		return -E_INVAL;
  801b30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b35:	eb f7                	jmp    801b2e <vsnprintf+0x45>

00801b37 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b3d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b40:	50                   	push   %eax
  801b41:	ff 75 10             	pushl  0x10(%ebp)
  801b44:	ff 75 0c             	pushl  0xc(%ebp)
  801b47:	ff 75 08             	pushl  0x8(%ebp)
  801b4a:	e8 9a ff ff ff       	call   801ae9 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	eb 03                	jmp    801b61 <strlen+0x10>
		n++;
  801b5e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b61:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b65:	75 f7                	jne    801b5e <strlen+0xd>
	return n;
}
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    

00801b69 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b72:	b8 00 00 00 00       	mov    $0x0,%eax
  801b77:	eb 03                	jmp    801b7c <strnlen+0x13>
		n++;
  801b79:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b7c:	39 d0                	cmp    %edx,%eax
  801b7e:	74 06                	je     801b86 <strnlen+0x1d>
  801b80:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801b84:	75 f3                	jne    801b79 <strnlen+0x10>
	return n;
}
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    

00801b88 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	53                   	push   %ebx
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b92:	89 c2                	mov    %eax,%edx
  801b94:	83 c1 01             	add    $0x1,%ecx
  801b97:	83 c2 01             	add    $0x1,%edx
  801b9a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801b9e:	88 5a ff             	mov    %bl,-0x1(%edx)
  801ba1:	84 db                	test   %bl,%bl
  801ba3:	75 ef                	jne    801b94 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801ba5:	5b                   	pop    %ebx
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    

00801ba8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	53                   	push   %ebx
  801bac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801baf:	53                   	push   %ebx
  801bb0:	e8 9c ff ff ff       	call   801b51 <strlen>
  801bb5:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	01 d8                	add    %ebx,%eax
  801bbd:	50                   	push   %eax
  801bbe:	e8 c5 ff ff ff       	call   801b88 <strcpy>
	return dst;
}
  801bc3:	89 d8                	mov    %ebx,%eax
  801bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	8b 75 08             	mov    0x8(%ebp),%esi
  801bd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bd5:	89 f3                	mov    %esi,%ebx
  801bd7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bda:	89 f2                	mov    %esi,%edx
  801bdc:	eb 0f                	jmp    801bed <strncpy+0x23>
		*dst++ = *src;
  801bde:	83 c2 01             	add    $0x1,%edx
  801be1:	0f b6 01             	movzbl (%ecx),%eax
  801be4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801be7:	80 39 01             	cmpb   $0x1,(%ecx)
  801bea:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801bed:	39 da                	cmp    %ebx,%edx
  801bef:	75 ed                	jne    801bde <strncpy+0x14>
	}
	return ret;
}
  801bf1:	89 f0                	mov    %esi,%eax
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	56                   	push   %esi
  801bfb:	53                   	push   %ebx
  801bfc:	8b 75 08             	mov    0x8(%ebp),%esi
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c05:	89 f0                	mov    %esi,%eax
  801c07:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c0b:	85 c9                	test   %ecx,%ecx
  801c0d:	75 0b                	jne    801c1a <strlcpy+0x23>
  801c0f:	eb 17                	jmp    801c28 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c11:	83 c2 01             	add    $0x1,%edx
  801c14:	83 c0 01             	add    $0x1,%eax
  801c17:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c1a:	39 d8                	cmp    %ebx,%eax
  801c1c:	74 07                	je     801c25 <strlcpy+0x2e>
  801c1e:	0f b6 0a             	movzbl (%edx),%ecx
  801c21:	84 c9                	test   %cl,%cl
  801c23:	75 ec                	jne    801c11 <strlcpy+0x1a>
		*dst = '\0';
  801c25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c28:	29 f0                	sub    %esi,%eax
}
  801c2a:	5b                   	pop    %ebx
  801c2b:	5e                   	pop    %esi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c34:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c37:	eb 06                	jmp    801c3f <strcmp+0x11>
		p++, q++;
  801c39:	83 c1 01             	add    $0x1,%ecx
  801c3c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c3f:	0f b6 01             	movzbl (%ecx),%eax
  801c42:	84 c0                	test   %al,%al
  801c44:	74 04                	je     801c4a <strcmp+0x1c>
  801c46:	3a 02                	cmp    (%edx),%al
  801c48:	74 ef                	je     801c39 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c4a:	0f b6 c0             	movzbl %al,%eax
  801c4d:	0f b6 12             	movzbl (%edx),%edx
  801c50:	29 d0                	sub    %edx,%eax
}
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    

00801c54 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	53                   	push   %ebx
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c63:	eb 06                	jmp    801c6b <strncmp+0x17>
		n--, p++, q++;
  801c65:	83 c0 01             	add    $0x1,%eax
  801c68:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c6b:	39 d8                	cmp    %ebx,%eax
  801c6d:	74 16                	je     801c85 <strncmp+0x31>
  801c6f:	0f b6 08             	movzbl (%eax),%ecx
  801c72:	84 c9                	test   %cl,%cl
  801c74:	74 04                	je     801c7a <strncmp+0x26>
  801c76:	3a 0a                	cmp    (%edx),%cl
  801c78:	74 eb                	je     801c65 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c7a:	0f b6 00             	movzbl (%eax),%eax
  801c7d:	0f b6 12             	movzbl (%edx),%edx
  801c80:	29 d0                	sub    %edx,%eax
}
  801c82:	5b                   	pop    %ebx
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
		return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8a:	eb f6                	jmp    801c82 <strncmp+0x2e>

00801c8c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c96:	0f b6 10             	movzbl (%eax),%edx
  801c99:	84 d2                	test   %dl,%dl
  801c9b:	74 09                	je     801ca6 <strchr+0x1a>
		if (*s == c)
  801c9d:	38 ca                	cmp    %cl,%dl
  801c9f:	74 0a                	je     801cab <strchr+0x1f>
	for (; *s; s++)
  801ca1:	83 c0 01             	add    $0x1,%eax
  801ca4:	eb f0                	jmp    801c96 <strchr+0xa>
			return (char *) s;
	return 0;
  801ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    

00801cad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cb7:	eb 03                	jmp    801cbc <strfind+0xf>
  801cb9:	83 c0 01             	add    $0x1,%eax
  801cbc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cbf:	38 ca                	cmp    %cl,%dl
  801cc1:	74 04                	je     801cc7 <strfind+0x1a>
  801cc3:	84 d2                	test   %dl,%dl
  801cc5:	75 f2                	jne    801cb9 <strfind+0xc>
			break;
	return (char *) s;
}
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    

00801cc9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cd5:	85 c9                	test   %ecx,%ecx
  801cd7:	74 13                	je     801cec <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cd9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801cdf:	75 05                	jne    801ce6 <memset+0x1d>
  801ce1:	f6 c1 03             	test   $0x3,%cl
  801ce4:	74 0d                	je     801cf3 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce9:	fc                   	cld    
  801cea:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801cec:	89 f8                	mov    %edi,%eax
  801cee:	5b                   	pop    %ebx
  801cef:	5e                   	pop    %esi
  801cf0:	5f                   	pop    %edi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    
		c &= 0xFF;
  801cf3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cf7:	89 d3                	mov    %edx,%ebx
  801cf9:	c1 e3 08             	shl    $0x8,%ebx
  801cfc:	89 d0                	mov    %edx,%eax
  801cfe:	c1 e0 18             	shl    $0x18,%eax
  801d01:	89 d6                	mov    %edx,%esi
  801d03:	c1 e6 10             	shl    $0x10,%esi
  801d06:	09 f0                	or     %esi,%eax
  801d08:	09 c2                	or     %eax,%edx
  801d0a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d0c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	fc                   	cld    
  801d12:	f3 ab                	rep stos %eax,%es:(%edi)
  801d14:	eb d6                	jmp    801cec <memset+0x23>

00801d16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	57                   	push   %edi
  801d1a:	56                   	push   %esi
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d24:	39 c6                	cmp    %eax,%esi
  801d26:	73 35                	jae    801d5d <memmove+0x47>
  801d28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d2b:	39 c2                	cmp    %eax,%edx
  801d2d:	76 2e                	jbe    801d5d <memmove+0x47>
		s += n;
		d += n;
  801d2f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d32:	89 d6                	mov    %edx,%esi
  801d34:	09 fe                	or     %edi,%esi
  801d36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d3c:	74 0c                	je     801d4a <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d3e:	83 ef 01             	sub    $0x1,%edi
  801d41:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d44:	fd                   	std    
  801d45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d47:	fc                   	cld    
  801d48:	eb 21                	jmp    801d6b <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d4a:	f6 c1 03             	test   $0x3,%cl
  801d4d:	75 ef                	jne    801d3e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d4f:	83 ef 04             	sub    $0x4,%edi
  801d52:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d55:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d58:	fd                   	std    
  801d59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d5b:	eb ea                	jmp    801d47 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d5d:	89 f2                	mov    %esi,%edx
  801d5f:	09 c2                	or     %eax,%edx
  801d61:	f6 c2 03             	test   $0x3,%dl
  801d64:	74 09                	je     801d6f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d66:	89 c7                	mov    %eax,%edi
  801d68:	fc                   	cld    
  801d69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d6b:	5e                   	pop    %esi
  801d6c:	5f                   	pop    %edi
  801d6d:	5d                   	pop    %ebp
  801d6e:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d6f:	f6 c1 03             	test   $0x3,%cl
  801d72:	75 f2                	jne    801d66 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d74:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d77:	89 c7                	mov    %eax,%edi
  801d79:	fc                   	cld    
  801d7a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d7c:	eb ed                	jmp    801d6b <memmove+0x55>

00801d7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801d81:	ff 75 10             	pushl  0x10(%ebp)
  801d84:	ff 75 0c             	pushl  0xc(%ebp)
  801d87:	ff 75 08             	pushl  0x8(%ebp)
  801d8a:	e8 87 ff ff ff       	call   801d16 <memmove>
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	89 c6                	mov    %eax,%esi
  801d9e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801da1:	39 f0                	cmp    %esi,%eax
  801da3:	74 1c                	je     801dc1 <memcmp+0x30>
		if (*s1 != *s2)
  801da5:	0f b6 08             	movzbl (%eax),%ecx
  801da8:	0f b6 1a             	movzbl (%edx),%ebx
  801dab:	38 d9                	cmp    %bl,%cl
  801dad:	75 08                	jne    801db7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801daf:	83 c0 01             	add    $0x1,%eax
  801db2:	83 c2 01             	add    $0x1,%edx
  801db5:	eb ea                	jmp    801da1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801db7:	0f b6 c1             	movzbl %cl,%eax
  801dba:	0f b6 db             	movzbl %bl,%ebx
  801dbd:	29 d8                	sub    %ebx,%eax
  801dbf:	eb 05                	jmp    801dc6 <memcmp+0x35>
	}

	return 0;
  801dc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc6:	5b                   	pop    %ebx
  801dc7:	5e                   	pop    %esi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dd3:	89 c2                	mov    %eax,%edx
  801dd5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dd8:	39 d0                	cmp    %edx,%eax
  801dda:	73 09                	jae    801de5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ddc:	38 08                	cmp    %cl,(%eax)
  801dde:	74 05                	je     801de5 <memfind+0x1b>
	for (; s < ends; s++)
  801de0:	83 c0 01             	add    $0x1,%eax
  801de3:	eb f3                	jmp    801dd8 <memfind+0xe>
			break;
	return (void *) s;
}
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	57                   	push   %edi
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
  801ded:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801df3:	eb 03                	jmp    801df8 <strtol+0x11>
		s++;
  801df5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801df8:	0f b6 01             	movzbl (%ecx),%eax
  801dfb:	3c 20                	cmp    $0x20,%al
  801dfd:	74 f6                	je     801df5 <strtol+0xe>
  801dff:	3c 09                	cmp    $0x9,%al
  801e01:	74 f2                	je     801df5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e03:	3c 2b                	cmp    $0x2b,%al
  801e05:	74 2e                	je     801e35 <strtol+0x4e>
	int neg = 0;
  801e07:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e0c:	3c 2d                	cmp    $0x2d,%al
  801e0e:	74 2f                	je     801e3f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e10:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e16:	75 05                	jne    801e1d <strtol+0x36>
  801e18:	80 39 30             	cmpb   $0x30,(%ecx)
  801e1b:	74 2c                	je     801e49 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e1d:	85 db                	test   %ebx,%ebx
  801e1f:	75 0a                	jne    801e2b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e21:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e26:	80 39 30             	cmpb   $0x30,(%ecx)
  801e29:	74 28                	je     801e53 <strtol+0x6c>
		base = 10;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e30:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e33:	eb 50                	jmp    801e85 <strtol+0x9e>
		s++;
  801e35:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e38:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3d:	eb d1                	jmp    801e10 <strtol+0x29>
		s++, neg = 1;
  801e3f:	83 c1 01             	add    $0x1,%ecx
  801e42:	bf 01 00 00 00       	mov    $0x1,%edi
  801e47:	eb c7                	jmp    801e10 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e49:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e4d:	74 0e                	je     801e5d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e4f:	85 db                	test   %ebx,%ebx
  801e51:	75 d8                	jne    801e2b <strtol+0x44>
		s++, base = 8;
  801e53:	83 c1 01             	add    $0x1,%ecx
  801e56:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e5b:	eb ce                	jmp    801e2b <strtol+0x44>
		s += 2, base = 16;
  801e5d:	83 c1 02             	add    $0x2,%ecx
  801e60:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e65:	eb c4                	jmp    801e2b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e67:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e6a:	89 f3                	mov    %esi,%ebx
  801e6c:	80 fb 19             	cmp    $0x19,%bl
  801e6f:	77 29                	ja     801e9a <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e71:	0f be d2             	movsbl %dl,%edx
  801e74:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e77:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e7a:	7d 30                	jge    801eac <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e7c:	83 c1 01             	add    $0x1,%ecx
  801e7f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e83:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e85:	0f b6 11             	movzbl (%ecx),%edx
  801e88:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e8b:	89 f3                	mov    %esi,%ebx
  801e8d:	80 fb 09             	cmp    $0x9,%bl
  801e90:	77 d5                	ja     801e67 <strtol+0x80>
			dig = *s - '0';
  801e92:	0f be d2             	movsbl %dl,%edx
  801e95:	83 ea 30             	sub    $0x30,%edx
  801e98:	eb dd                	jmp    801e77 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801e9a:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e9d:	89 f3                	mov    %esi,%ebx
  801e9f:	80 fb 19             	cmp    $0x19,%bl
  801ea2:	77 08                	ja     801eac <strtol+0xc5>
			dig = *s - 'A' + 10;
  801ea4:	0f be d2             	movsbl %dl,%edx
  801ea7:	83 ea 37             	sub    $0x37,%edx
  801eaa:	eb cb                	jmp    801e77 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801eac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb0:	74 05                	je     801eb7 <strtol+0xd0>
		*endptr = (char *) s;
  801eb2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eb5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eb7:	89 c2                	mov    %eax,%edx
  801eb9:	f7 da                	neg    %edx
  801ebb:	85 ff                	test   %edi,%edi
  801ebd:	0f 45 c2             	cmovne %edx,%eax
}
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	5f                   	pop    %edi
  801ec3:	5d                   	pop    %ebp
  801ec4:	c3                   	ret    

00801ec5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	56                   	push   %esi
  801ec9:	53                   	push   %ebx
  801eca:	8b 75 08             	mov    0x8(%ebp),%esi
  801ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801ed3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ed5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801eda:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	50                   	push   %eax
  801ee1:	e8 28 e4 ff ff       	call   80030e <sys_ipc_recv>
	if (from_env_store)
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	85 f6                	test   %esi,%esi
  801eeb:	74 14                	je     801f01 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801eed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	78 09                	js     801eff <ipc_recv+0x3a>
  801ef6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801efc:	8b 52 74             	mov    0x74(%edx),%edx
  801eff:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f01:	85 db                	test   %ebx,%ebx
  801f03:	74 14                	je     801f19 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f05:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 09                	js     801f17 <ipc_recv+0x52>
  801f0e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f14:	8b 52 78             	mov    0x78(%edx),%edx
  801f17:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	78 08                	js     801f25 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f1d:	a1 08 40 80 00       	mov    0x804008,%eax
  801f22:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5e                   	pop    %esi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    

00801f2c <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	57                   	push   %edi
  801f30:	56                   	push   %esi
  801f31:	53                   	push   %ebx
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f38:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f3e:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f40:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f45:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f48:	ff 75 14             	pushl  0x14(%ebp)
  801f4b:	53                   	push   %ebx
  801f4c:	56                   	push   %esi
  801f4d:	57                   	push   %edi
  801f4e:	e8 98 e3 ff ff       	call   8002eb <sys_ipc_try_send>
		if (ret == 0)
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	85 c0                	test   %eax,%eax
  801f58:	74 1e                	je     801f78 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f5a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f5d:	75 07                	jne    801f66 <ipc_send+0x3a>
			sys_yield();
  801f5f:	e8 db e1 ff ff       	call   80013f <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f64:	eb e2                	jmp    801f48 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f66:	50                   	push   %eax
  801f67:	68 c0 26 80 00       	push   $0x8026c0
  801f6c:	6a 3d                	push   $0x3d
  801f6e:	68 d4 26 80 00       	push   $0x8026d4
  801f73:	e8 16 f5 ff ff       	call   80148e <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7b:	5b                   	pop    %ebx
  801f7c:	5e                   	pop    %esi
  801f7d:	5f                   	pop    %edi
  801f7e:	5d                   	pop    %ebp
  801f7f:	c3                   	ret    

00801f80 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f8b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f8e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f94:	8b 52 50             	mov    0x50(%edx),%edx
  801f97:	39 ca                	cmp    %ecx,%edx
  801f99:	74 11                	je     801fac <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801f9b:	83 c0 01             	add    $0x1,%eax
  801f9e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fa3:	75 e6                	jne    801f8b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	eb 0b                	jmp    801fb7 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801faf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fb4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fbf:	89 d0                	mov    %edx,%eax
  801fc1:	c1 e8 16             	shr    $0x16,%eax
  801fc4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fd0:	f6 c1 01             	test   $0x1,%cl
  801fd3:	74 1d                	je     801ff2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fd5:	c1 ea 0c             	shr    $0xc,%edx
  801fd8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fdf:	f6 c2 01             	test   $0x1,%dl
  801fe2:	74 0e                	je     801ff2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fe4:	c1 ea 0c             	shr    $0xc,%edx
  801fe7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fee:	ef 
  801fef:	0f b7 c0             	movzwl %ax,%eax
}
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	66 90                	xchg   %ax,%ax
  801ff6:	66 90                	xchg   %ax,%ax
  801ff8:	66 90                	xchg   %ax,%ax
  801ffa:	66 90                	xchg   %ax,%ax
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

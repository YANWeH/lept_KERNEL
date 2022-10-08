
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800045:	e8 ce 00 00 00       	call   800118 <sys_getenvid>
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800052:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800057:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005c:	85 db                	test   %ebx,%ebx
  80005e:	7e 07                	jle    800067 <libmain+0x2d>
		binaryname = argv[0];
  800060:	8b 06                	mov    (%esi),%eax
  800062:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800067:	83 ec 08             	sub    $0x8,%esp
  80006a:	56                   	push   %esi
  80006b:	53                   	push   %ebx
  80006c:	e8 c2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800071:	e8 0a 00 00 00       	call   800080 <exit>
}
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007c:	5b                   	pop    %ebx
  80007d:	5e                   	pop    %esi
  80007e:	5d                   	pop    %ebp
  80007f:	c3                   	ret    

00800080 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800086:	e8 b1 04 00 00       	call   80053c <close_all>
	sys_env_destroy(0);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	6a 00                	push   $0x0
  800090:	e8 42 00 00 00       	call   8000d7 <sys_env_destroy>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ab:	89 c3                	mov    %eax,%ebx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 c6                	mov    %eax,%esi
  8000b1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b3:	5b                   	pop    %ebx
  8000b4:	5e                   	pop    %esi
  8000b5:	5f                   	pop    %edi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c8:	89 d1                	mov    %edx,%ecx
  8000ca:	89 d3                	mov    %edx,%ebx
  8000cc:	89 d7                	mov    %edx,%edi
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ed:	89 cb                	mov    %ecx,%ebx
  8000ef:	89 cf                	mov    %ecx,%edi
  8000f1:	89 ce                	mov    %ecx,%esi
  8000f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	7f 08                	jg     800101 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fc:	5b                   	pop    %ebx
  8000fd:	5e                   	pop    %esi
  8000fe:	5f                   	pop    %edi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	50                   	push   %eax
  800105:	6a 03                	push   $0x3
  800107:	68 4a 22 80 00       	push   $0x80224a
  80010c:	6a 23                	push   $0x23
  80010e:	68 67 22 80 00       	push   $0x802267
  800113:	e8 6e 13 00 00       	call   801486 <_panic>

00800118 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011e:	ba 00 00 00 00       	mov    $0x0,%edx
  800123:	b8 02 00 00 00       	mov    $0x2,%eax
  800128:	89 d1                	mov    %edx,%ecx
  80012a:	89 d3                	mov    %edx,%ebx
  80012c:	89 d7                	mov    %edx,%edi
  80012e:	89 d6                	mov    %edx,%esi
  800130:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800132:	5b                   	pop    %ebx
  800133:	5e                   	pop    %esi
  800134:	5f                   	pop    %edi
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <sys_yield>:

void
sys_yield(void)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	57                   	push   %edi
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013d:	ba 00 00 00 00       	mov    $0x0,%edx
  800142:	b8 0b 00 00 00       	mov    $0xb,%eax
  800147:	89 d1                	mov    %edx,%ecx
  800149:	89 d3                	mov    %edx,%ebx
  80014b:	89 d7                	mov    %edx,%edi
  80014d:	89 d6                	mov    %edx,%esi
  80014f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    

00800156 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	57                   	push   %edi
  80015a:	56                   	push   %esi
  80015b:	53                   	push   %ebx
  80015c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015f:	be 00 00 00 00       	mov    $0x0,%esi
  800164:	8b 55 08             	mov    0x8(%ebp),%edx
  800167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016a:	b8 04 00 00 00       	mov    $0x4,%eax
  80016f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800172:	89 f7                	mov    %esi,%edi
  800174:	cd 30                	int    $0x30
	if(check && ret > 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	7f 08                	jg     800182 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	6a 04                	push   $0x4
  800188:	68 4a 22 80 00       	push   $0x80224a
  80018d:	6a 23                	push   $0x23
  80018f:	68 67 22 80 00       	push   $0x802267
  800194:	e8 ed 12 00 00       	call   801486 <_panic>

00800199 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	57                   	push   %edi
  80019d:	56                   	push   %esi
  80019e:	53                   	push   %ebx
  80019f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	7f 08                	jg     8001c4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bf:	5b                   	pop    %ebx
  8001c0:	5e                   	pop    %esi
  8001c1:	5f                   	pop    %edi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	6a 05                	push   $0x5
  8001ca:	68 4a 22 80 00       	push   $0x80224a
  8001cf:	6a 23                	push   $0x23
  8001d1:	68 67 22 80 00       	push   $0x802267
  8001d6:	e8 ab 12 00 00       	call   801486 <_panic>

008001db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f4:	89 df                	mov    %ebx,%edi
  8001f6:	89 de                	mov    %ebx,%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 06                	push   $0x6
  80020c:	68 4a 22 80 00       	push   $0x80224a
  800211:	6a 23                	push   $0x23
  800213:	68 67 22 80 00       	push   $0x802267
  800218:	e8 69 12 00 00       	call   801486 <_panic>

0080021d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	57                   	push   %edi
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800231:	b8 08 00 00 00       	mov    $0x8,%eax
  800236:	89 df                	mov    %ebx,%edi
  800238:	89 de                	mov    %ebx,%esi
  80023a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023c:	85 c0                	test   %eax,%eax
  80023e:	7f 08                	jg     800248 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	50                   	push   %eax
  80024c:	6a 08                	push   $0x8
  80024e:	68 4a 22 80 00       	push   $0x80224a
  800253:	6a 23                	push   $0x23
  800255:	68 67 22 80 00       	push   $0x802267
  80025a:	e8 27 12 00 00       	call   801486 <_panic>

0080025f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	57                   	push   %edi
  800263:	56                   	push   %esi
  800264:	53                   	push   %ebx
  800265:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800273:	b8 09 00 00 00       	mov    $0x9,%eax
  800278:	89 df                	mov    %ebx,%edi
  80027a:	89 de                	mov    %ebx,%esi
  80027c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	7f 08                	jg     80028a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	50                   	push   %eax
  80028e:	6a 09                	push   $0x9
  800290:	68 4a 22 80 00       	push   $0x80224a
  800295:	6a 23                	push   $0x23
  800297:	68 67 22 80 00       	push   $0x802267
  80029c:	e8 e5 11 00 00       	call   801486 <_panic>

008002a1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
  8002a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002af:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ba:	89 df                	mov    %ebx,%edi
  8002bc:	89 de                	mov    %ebx,%esi
  8002be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c0:	85 c0                	test   %eax,%eax
  8002c2:	7f 08                	jg     8002cc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	6a 0a                	push   $0xa
  8002d2:	68 4a 22 80 00       	push   $0x80224a
  8002d7:	6a 23                	push   $0x23
  8002d9:	68 67 22 80 00       	push   $0x802267
  8002de:	e8 a3 11 00 00       	call   801486 <_panic>

008002e3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ef:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f4:	be 00 00 00 00       	mov    $0x0,%esi
  8002f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002ff:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5f                   	pop    %edi
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800314:	8b 55 08             	mov    0x8(%ebp),%edx
  800317:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031c:	89 cb                	mov    %ecx,%ebx
  80031e:	89 cf                	mov    %ecx,%edi
  800320:	89 ce                	mov    %ecx,%esi
  800322:	cd 30                	int    $0x30
	if(check && ret > 0)
  800324:	85 c0                	test   %eax,%eax
  800326:	7f 08                	jg     800330 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	50                   	push   %eax
  800334:	6a 0d                	push   $0xd
  800336:	68 4a 22 80 00       	push   $0x80224a
  80033b:	6a 23                	push   $0x23
  80033d:	68 67 22 80 00       	push   $0x802267
  800342:	e8 3f 11 00 00       	call   801486 <_panic>

00800347 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	57                   	push   %edi
  80034b:	56                   	push   %esi
  80034c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	b8 0e 00 00 00       	mov    $0xe,%eax
  800357:	89 d1                	mov    %edx,%ecx
  800359:	89 d3                	mov    %edx,%ebx
  80035b:	89 d7                	mov    %edx,%edi
  80035d:	89 d6                	mov    %edx,%esi
  80035f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800361:	5b                   	pop    %ebx
  800362:	5e                   	pop    %esi
  800363:	5f                   	pop    %edi
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800369:	8b 45 08             	mov    0x8(%ebp),%eax
  80036c:	05 00 00 00 30       	add    $0x30000000,%eax
  800371:	c1 e8 0c             	shr    $0xc,%eax
}
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800381:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800386:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038b:	5d                   	pop    %ebp
  80038c:	c3                   	ret    

0080038d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800393:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800398:	89 c2                	mov    %eax,%edx
  80039a:	c1 ea 16             	shr    $0x16,%edx
  80039d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a4:	f6 c2 01             	test   $0x1,%dl
  8003a7:	74 2a                	je     8003d3 <fd_alloc+0x46>
  8003a9:	89 c2                	mov    %eax,%edx
  8003ab:	c1 ea 0c             	shr    $0xc,%edx
  8003ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b5:	f6 c2 01             	test   $0x1,%dl
  8003b8:	74 19                	je     8003d3 <fd_alloc+0x46>
  8003ba:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003bf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c4:	75 d2                	jne    800398 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003c6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003cc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d1:	eb 07                	jmp    8003da <fd_alloc+0x4d>
			*fd_store = fd;
  8003d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e2:	83 f8 1f             	cmp    $0x1f,%eax
  8003e5:	77 36                	ja     80041d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003e7:	c1 e0 0c             	shl    $0xc,%eax
  8003ea:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ef:	89 c2                	mov    %eax,%edx
  8003f1:	c1 ea 16             	shr    $0x16,%edx
  8003f4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003fb:	f6 c2 01             	test   $0x1,%dl
  8003fe:	74 24                	je     800424 <fd_lookup+0x48>
  800400:	89 c2                	mov    %eax,%edx
  800402:	c1 ea 0c             	shr    $0xc,%edx
  800405:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80040c:	f6 c2 01             	test   $0x1,%dl
  80040f:	74 1a                	je     80042b <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800411:	8b 55 0c             	mov    0xc(%ebp),%edx
  800414:	89 02                	mov    %eax,(%edx)
	return 0;
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041b:	5d                   	pop    %ebp
  80041c:	c3                   	ret    
		return -E_INVAL;
  80041d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800422:	eb f7                	jmp    80041b <fd_lookup+0x3f>
		return -E_INVAL;
  800424:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800429:	eb f0                	jmp    80041b <fd_lookup+0x3f>
  80042b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800430:	eb e9                	jmp    80041b <fd_lookup+0x3f>

00800432 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 08             	sub    $0x8,%esp
  800438:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043b:	ba f4 22 80 00       	mov    $0x8022f4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800440:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800445:	39 08                	cmp    %ecx,(%eax)
  800447:	74 33                	je     80047c <dev_lookup+0x4a>
  800449:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80044c:	8b 02                	mov    (%edx),%eax
  80044e:	85 c0                	test   %eax,%eax
  800450:	75 f3                	jne    800445 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800452:	a1 08 40 80 00       	mov    0x804008,%eax
  800457:	8b 40 48             	mov    0x48(%eax),%eax
  80045a:	83 ec 04             	sub    $0x4,%esp
  80045d:	51                   	push   %ecx
  80045e:	50                   	push   %eax
  80045f:	68 78 22 80 00       	push   $0x802278
  800464:	e8 f8 10 00 00       	call   801561 <cprintf>
	*dev = 0;
  800469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800472:	83 c4 10             	add    $0x10,%esp
  800475:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80047a:	c9                   	leave  
  80047b:	c3                   	ret    
			*dev = devtab[i];
  80047c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800481:	b8 00 00 00 00       	mov    $0x0,%eax
  800486:	eb f2                	jmp    80047a <dev_lookup+0x48>

00800488 <fd_close>:
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	57                   	push   %edi
  80048c:	56                   	push   %esi
  80048d:	53                   	push   %ebx
  80048e:	83 ec 1c             	sub    $0x1c,%esp
  800491:	8b 75 08             	mov    0x8(%ebp),%esi
  800494:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800497:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80049a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80049b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a4:	50                   	push   %eax
  8004a5:	e8 32 ff ff ff       	call   8003dc <fd_lookup>
  8004aa:	89 c3                	mov    %eax,%ebx
  8004ac:	83 c4 08             	add    $0x8,%esp
  8004af:	85 c0                	test   %eax,%eax
  8004b1:	78 05                	js     8004b8 <fd_close+0x30>
	    || fd != fd2)
  8004b3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004b6:	74 16                	je     8004ce <fd_close+0x46>
		return (must_exist ? r : 0);
  8004b8:	89 f8                	mov    %edi,%eax
  8004ba:	84 c0                	test   %al,%al
  8004bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c1:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c4:	89 d8                	mov    %ebx,%eax
  8004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c9:	5b                   	pop    %ebx
  8004ca:	5e                   	pop    %esi
  8004cb:	5f                   	pop    %edi
  8004cc:	5d                   	pop    %ebp
  8004cd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d4:	50                   	push   %eax
  8004d5:	ff 36                	pushl  (%esi)
  8004d7:	e8 56 ff ff ff       	call   800432 <dev_lookup>
  8004dc:	89 c3                	mov    %eax,%ebx
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	85 c0                	test   %eax,%eax
  8004e3:	78 15                	js     8004fa <fd_close+0x72>
		if (dev->dev_close)
  8004e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e8:	8b 40 10             	mov    0x10(%eax),%eax
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	74 1b                	je     80050a <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004ef:	83 ec 0c             	sub    $0xc,%esp
  8004f2:	56                   	push   %esi
  8004f3:	ff d0                	call   *%eax
  8004f5:	89 c3                	mov    %eax,%ebx
  8004f7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	56                   	push   %esi
  8004fe:	6a 00                	push   $0x0
  800500:	e8 d6 fc ff ff       	call   8001db <sys_page_unmap>
	return r;
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	eb ba                	jmp    8004c4 <fd_close+0x3c>
			r = 0;
  80050a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80050f:	eb e9                	jmp    8004fa <fd_close+0x72>

00800511 <close>:

int
close(int fdnum)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800517:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80051a:	50                   	push   %eax
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	e8 b9 fe ff ff       	call   8003dc <fd_lookup>
  800523:	83 c4 08             	add    $0x8,%esp
  800526:	85 c0                	test   %eax,%eax
  800528:	78 10                	js     80053a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	6a 01                	push   $0x1
  80052f:	ff 75 f4             	pushl  -0xc(%ebp)
  800532:	e8 51 ff ff ff       	call   800488 <fd_close>
  800537:	83 c4 10             	add    $0x10,%esp
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <close_all>:

void
close_all(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	53                   	push   %ebx
  800540:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800543:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800548:	83 ec 0c             	sub    $0xc,%esp
  80054b:	53                   	push   %ebx
  80054c:	e8 c0 ff ff ff       	call   800511 <close>
	for (i = 0; i < MAXFD; i++)
  800551:	83 c3 01             	add    $0x1,%ebx
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	83 fb 20             	cmp    $0x20,%ebx
  80055a:	75 ec                	jne    800548 <close_all+0xc>
}
  80055c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	57                   	push   %edi
  800565:	56                   	push   %esi
  800566:	53                   	push   %ebx
  800567:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80056a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80056d:	50                   	push   %eax
  80056e:	ff 75 08             	pushl  0x8(%ebp)
  800571:	e8 66 fe ff ff       	call   8003dc <fd_lookup>
  800576:	89 c3                	mov    %eax,%ebx
  800578:	83 c4 08             	add    $0x8,%esp
  80057b:	85 c0                	test   %eax,%eax
  80057d:	0f 88 81 00 00 00    	js     800604 <dup+0xa3>
		return r;
	close(newfdnum);
  800583:	83 ec 0c             	sub    $0xc,%esp
  800586:	ff 75 0c             	pushl  0xc(%ebp)
  800589:	e8 83 ff ff ff       	call   800511 <close>

	newfd = INDEX2FD(newfdnum);
  80058e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800591:	c1 e6 0c             	shl    $0xc,%esi
  800594:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80059a:	83 c4 04             	add    $0x4,%esp
  80059d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a0:	e8 d1 fd ff ff       	call   800376 <fd2data>
  8005a5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a7:	89 34 24             	mov    %esi,(%esp)
  8005aa:	e8 c7 fd ff ff       	call   800376 <fd2data>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b4:	89 d8                	mov    %ebx,%eax
  8005b6:	c1 e8 16             	shr    $0x16,%eax
  8005b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c0:	a8 01                	test   $0x1,%al
  8005c2:	74 11                	je     8005d5 <dup+0x74>
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	c1 e8 0c             	shr    $0xc,%eax
  8005c9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d0:	f6 c2 01             	test   $0x1,%dl
  8005d3:	75 39                	jne    80060e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d8:	89 d0                	mov    %edx,%eax
  8005da:	c1 e8 0c             	shr    $0xc,%eax
  8005dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e4:	83 ec 0c             	sub    $0xc,%esp
  8005e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8005ec:	50                   	push   %eax
  8005ed:	56                   	push   %esi
  8005ee:	6a 00                	push   $0x0
  8005f0:	52                   	push   %edx
  8005f1:	6a 00                	push   $0x0
  8005f3:	e8 a1 fb ff ff       	call   800199 <sys_page_map>
  8005f8:	89 c3                	mov    %eax,%ebx
  8005fa:	83 c4 20             	add    $0x20,%esp
  8005fd:	85 c0                	test   %eax,%eax
  8005ff:	78 31                	js     800632 <dup+0xd1>
		goto err;

	return newfdnum;
  800601:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800604:	89 d8                	mov    %ebx,%eax
  800606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800609:	5b                   	pop    %ebx
  80060a:	5e                   	pop    %esi
  80060b:	5f                   	pop    %edi
  80060c:	5d                   	pop    %ebp
  80060d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80060e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800615:	83 ec 0c             	sub    $0xc,%esp
  800618:	25 07 0e 00 00       	and    $0xe07,%eax
  80061d:	50                   	push   %eax
  80061e:	57                   	push   %edi
  80061f:	6a 00                	push   $0x0
  800621:	53                   	push   %ebx
  800622:	6a 00                	push   $0x0
  800624:	e8 70 fb ff ff       	call   800199 <sys_page_map>
  800629:	89 c3                	mov    %eax,%ebx
  80062b:	83 c4 20             	add    $0x20,%esp
  80062e:	85 c0                	test   %eax,%eax
  800630:	79 a3                	jns    8005d5 <dup+0x74>
	sys_page_unmap(0, newfd);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	56                   	push   %esi
  800636:	6a 00                	push   $0x0
  800638:	e8 9e fb ff ff       	call   8001db <sys_page_unmap>
	sys_page_unmap(0, nva);
  80063d:	83 c4 08             	add    $0x8,%esp
  800640:	57                   	push   %edi
  800641:	6a 00                	push   $0x0
  800643:	e8 93 fb ff ff       	call   8001db <sys_page_unmap>
	return r;
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	eb b7                	jmp    800604 <dup+0xa3>

0080064d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	53                   	push   %ebx
  800651:	83 ec 14             	sub    $0x14,%esp
  800654:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800657:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80065a:	50                   	push   %eax
  80065b:	53                   	push   %ebx
  80065c:	e8 7b fd ff ff       	call   8003dc <fd_lookup>
  800661:	83 c4 08             	add    $0x8,%esp
  800664:	85 c0                	test   %eax,%eax
  800666:	78 3f                	js     8006a7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800672:	ff 30                	pushl  (%eax)
  800674:	e8 b9 fd ff ff       	call   800432 <dev_lookup>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	85 c0                	test   %eax,%eax
  80067e:	78 27                	js     8006a7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800680:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800683:	8b 42 08             	mov    0x8(%edx),%eax
  800686:	83 e0 03             	and    $0x3,%eax
  800689:	83 f8 01             	cmp    $0x1,%eax
  80068c:	74 1e                	je     8006ac <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80068e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800691:	8b 40 08             	mov    0x8(%eax),%eax
  800694:	85 c0                	test   %eax,%eax
  800696:	74 35                	je     8006cd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800698:	83 ec 04             	sub    $0x4,%esp
  80069b:	ff 75 10             	pushl  0x10(%ebp)
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	52                   	push   %edx
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
}
  8006a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006aa:	c9                   	leave  
  8006ab:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b1:	8b 40 48             	mov    0x48(%eax),%eax
  8006b4:	83 ec 04             	sub    $0x4,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	50                   	push   %eax
  8006b9:	68 b9 22 80 00       	push   $0x8022b9
  8006be:	e8 9e 0e 00 00       	call   801561 <cprintf>
		return -E_INVAL;
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cb:	eb da                	jmp    8006a7 <read+0x5a>
		return -E_NOT_SUPP;
  8006cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d2:	eb d3                	jmp    8006a7 <read+0x5a>

008006d4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	57                   	push   %edi
  8006d8:	56                   	push   %esi
  8006d9:	53                   	push   %ebx
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e8:	39 f3                	cmp    %esi,%ebx
  8006ea:	73 25                	jae    800711 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006ec:	83 ec 04             	sub    $0x4,%esp
  8006ef:	89 f0                	mov    %esi,%eax
  8006f1:	29 d8                	sub    %ebx,%eax
  8006f3:	50                   	push   %eax
  8006f4:	89 d8                	mov    %ebx,%eax
  8006f6:	03 45 0c             	add    0xc(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	57                   	push   %edi
  8006fb:	e8 4d ff ff ff       	call   80064d <read>
		if (m < 0)
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	85 c0                	test   %eax,%eax
  800705:	78 08                	js     80070f <readn+0x3b>
			return m;
		if (m == 0)
  800707:	85 c0                	test   %eax,%eax
  800709:	74 06                	je     800711 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80070b:	01 c3                	add    %eax,%ebx
  80070d:	eb d9                	jmp    8006e8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800711:	89 d8                	mov    %ebx,%eax
  800713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800716:	5b                   	pop    %ebx
  800717:	5e                   	pop    %esi
  800718:	5f                   	pop    %edi
  800719:	5d                   	pop    %ebp
  80071a:	c3                   	ret    

0080071b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	53                   	push   %ebx
  80071f:	83 ec 14             	sub    $0x14,%esp
  800722:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800725:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800728:	50                   	push   %eax
  800729:	53                   	push   %ebx
  80072a:	e8 ad fc ff ff       	call   8003dc <fd_lookup>
  80072f:	83 c4 08             	add    $0x8,%esp
  800732:	85 c0                	test   %eax,%eax
  800734:	78 3a                	js     800770 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800740:	ff 30                	pushl  (%eax)
  800742:	e8 eb fc ff ff       	call   800432 <dev_lookup>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	85 c0                	test   %eax,%eax
  80074c:	78 22                	js     800770 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80074e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800751:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800755:	74 1e                	je     800775 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800757:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075a:	8b 52 0c             	mov    0xc(%edx),%edx
  80075d:	85 d2                	test   %edx,%edx
  80075f:	74 35                	je     800796 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	ff 75 10             	pushl  0x10(%ebp)
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	50                   	push   %eax
  80076b:	ff d2                	call   *%edx
  80076d:	83 c4 10             	add    $0x10,%esp
}
  800770:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800773:	c9                   	leave  
  800774:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800775:	a1 08 40 80 00       	mov    0x804008,%eax
  80077a:	8b 40 48             	mov    0x48(%eax),%eax
  80077d:	83 ec 04             	sub    $0x4,%esp
  800780:	53                   	push   %ebx
  800781:	50                   	push   %eax
  800782:	68 d5 22 80 00       	push   $0x8022d5
  800787:	e8 d5 0d 00 00       	call   801561 <cprintf>
		return -E_INVAL;
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800794:	eb da                	jmp    800770 <write+0x55>
		return -E_NOT_SUPP;
  800796:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079b:	eb d3                	jmp    800770 <write+0x55>

0080079d <seek>:

int
seek(int fdnum, off_t offset)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007a6:	50                   	push   %eax
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	e8 2d fc ff ff       	call   8003dc <fd_lookup>
  8007af:	83 c4 08             	add    $0x8,%esp
  8007b2:	85 c0                	test   %eax,%eax
  8007b4:	78 0e                	js     8007c4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007bc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	53                   	push   %ebx
  8007ca:	83 ec 14             	sub    $0x14,%esp
  8007cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d3:	50                   	push   %eax
  8007d4:	53                   	push   %ebx
  8007d5:	e8 02 fc ff ff       	call   8003dc <fd_lookup>
  8007da:	83 c4 08             	add    $0x8,%esp
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	78 37                	js     800818 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007eb:	ff 30                	pushl  (%eax)
  8007ed:	e8 40 fc ff ff       	call   800432 <dev_lookup>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	78 1f                	js     800818 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800800:	74 1b                	je     80081d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800805:	8b 52 18             	mov    0x18(%edx),%edx
  800808:	85 d2                	test   %edx,%edx
  80080a:	74 32                	je     80083e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	50                   	push   %eax
  800813:	ff d2                	call   *%edx
  800815:	83 c4 10             	add    $0x10,%esp
}
  800818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80081d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800822:	8b 40 48             	mov    0x48(%eax),%eax
  800825:	83 ec 04             	sub    $0x4,%esp
  800828:	53                   	push   %ebx
  800829:	50                   	push   %eax
  80082a:	68 98 22 80 00       	push   $0x802298
  80082f:	e8 2d 0d 00 00       	call   801561 <cprintf>
		return -E_INVAL;
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083c:	eb da                	jmp    800818 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80083e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800843:	eb d3                	jmp    800818 <ftruncate+0x52>

00800845 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	53                   	push   %ebx
  800849:	83 ec 14             	sub    $0x14,%esp
  80084c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	ff 75 08             	pushl  0x8(%ebp)
  800856:	e8 81 fb ff ff       	call   8003dc <fd_lookup>
  80085b:	83 c4 08             	add    $0x8,%esp
  80085e:	85 c0                	test   %eax,%eax
  800860:	78 4b                	js     8008ad <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800868:	50                   	push   %eax
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	ff 30                	pushl  (%eax)
  80086e:	e8 bf fb ff ff       	call   800432 <dev_lookup>
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	85 c0                	test   %eax,%eax
  800878:	78 33                	js     8008ad <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800881:	74 2f                	je     8008b2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800883:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800886:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80088d:	00 00 00 
	stat->st_isdir = 0;
  800890:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800897:	00 00 00 
	stat->st_dev = dev;
  80089a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a7:	ff 50 14             	call   *0x14(%eax)
  8008aa:	83 c4 10             	add    $0x10,%esp
}
  8008ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b7:	eb f4                	jmp    8008ad <fstat+0x68>

008008b9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	6a 00                	push   $0x0
  8008c3:	ff 75 08             	pushl  0x8(%ebp)
  8008c6:	e8 e7 01 00 00       	call   800ab2 <open>
  8008cb:	89 c3                	mov    %eax,%ebx
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	78 1b                	js     8008ef <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	50                   	push   %eax
  8008db:	e8 65 ff ff ff       	call   800845 <fstat>
  8008e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e2:	89 1c 24             	mov    %ebx,(%esp)
  8008e5:	e8 27 fc ff ff       	call   800511 <close>
	return r;
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 f3                	mov    %esi,%ebx
}
  8008ef:	89 d8                	mov    %ebx,%eax
  8008f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	89 c6                	mov    %eax,%esi
  8008ff:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800901:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800908:	74 27                	je     800931 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80090a:	6a 07                	push   $0x7
  80090c:	68 00 50 80 00       	push   $0x805000
  800911:	56                   	push   %esi
  800912:	ff 35 00 40 80 00    	pushl  0x804000
  800918:	e8 07 16 00 00       	call   801f24 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80091d:	83 c4 0c             	add    $0xc,%esp
  800920:	6a 00                	push   $0x0
  800922:	53                   	push   %ebx
  800923:	6a 00                	push   $0x0
  800925:	e8 93 15 00 00       	call   801ebd <ipc_recv>
}
  80092a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80092d:	5b                   	pop    %ebx
  80092e:	5e                   	pop    %esi
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800931:	83 ec 0c             	sub    $0xc,%esp
  800934:	6a 01                	push   $0x1
  800936:	e8 3d 16 00 00       	call   801f78 <ipc_find_env>
  80093b:	a3 00 40 80 00       	mov    %eax,0x804000
  800940:	83 c4 10             	add    $0x10,%esp
  800943:	eb c5                	jmp    80090a <fsipc+0x12>

00800945 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 40 0c             	mov    0xc(%eax),%eax
  800951:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
  800963:	b8 02 00 00 00       	mov    $0x2,%eax
  800968:	e8 8b ff ff ff       	call   8008f8 <fsipc>
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <devfile_flush>:
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 40 0c             	mov    0xc(%eax),%eax
  80097b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
  800985:	b8 06 00 00 00       	mov    $0x6,%eax
  80098a:	e8 69 ff ff ff       	call   8008f8 <fsipc>
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <devfile_stat>:
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	53                   	push   %ebx
  800995:	83 ec 04             	sub    $0x4,%esp
  800998:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b0:	e8 43 ff ff ff       	call   8008f8 <fsipc>
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	78 2c                	js     8009e5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	68 00 50 80 00       	push   $0x805000
  8009c1:	53                   	push   %ebx
  8009c2:	e8 b9 11 00 00       	call   801b80 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009c7:	a1 80 50 80 00       	mov    0x805080,%eax
  8009cc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d2:	a1 84 50 80 00       	mov    0x805084,%eax
  8009d7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <devfile_write>:
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	83 ec 0c             	sub    $0xc,%esp
  8009f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009f8:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8009fd:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a00:	8b 55 08             	mov    0x8(%ebp),%edx
  800a03:	8b 52 0c             	mov    0xc(%edx),%edx
  800a06:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a0c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a11:	50                   	push   %eax
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	68 08 50 80 00       	push   $0x805008
  800a1a:	e8 ef 12 00 00       	call   801d0e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a24:	b8 04 00 00 00       	mov    $0x4,%eax
  800a29:	e8 ca fe ff ff       	call   8008f8 <fsipc>
}
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <devfile_read>:
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a3e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a43:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4e:	b8 03 00 00 00       	mov    $0x3,%eax
  800a53:	e8 a0 fe ff ff       	call   8008f8 <fsipc>
  800a58:	89 c3                	mov    %eax,%ebx
  800a5a:	85 c0                	test   %eax,%eax
  800a5c:	78 1f                	js     800a7d <devfile_read+0x4d>
	assert(r <= n);
  800a5e:	39 f0                	cmp    %esi,%eax
  800a60:	77 24                	ja     800a86 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a62:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a67:	7f 33                	jg     800a9c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	50                   	push   %eax
  800a6d:	68 00 50 80 00       	push   $0x805000
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	e8 94 12 00 00       	call   801d0e <memmove>
	return r;
  800a7a:	83 c4 10             	add    $0x10,%esp
}
  800a7d:	89 d8                	mov    %ebx,%eax
  800a7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    
	assert(r <= n);
  800a86:	68 08 23 80 00       	push   $0x802308
  800a8b:	68 0f 23 80 00       	push   $0x80230f
  800a90:	6a 7b                	push   $0x7b
  800a92:	68 24 23 80 00       	push   $0x802324
  800a97:	e8 ea 09 00 00       	call   801486 <_panic>
	assert(r <= PGSIZE);
  800a9c:	68 2f 23 80 00       	push   $0x80232f
  800aa1:	68 0f 23 80 00       	push   $0x80230f
  800aa6:	6a 7c                	push   $0x7c
  800aa8:	68 24 23 80 00       	push   $0x802324
  800aad:	e8 d4 09 00 00       	call   801486 <_panic>

00800ab2 <open>:
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
  800ab7:	83 ec 1c             	sub    $0x1c,%esp
  800aba:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800abd:	56                   	push   %esi
  800abe:	e8 86 10 00 00       	call   801b49 <strlen>
  800ac3:	83 c4 10             	add    $0x10,%esp
  800ac6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800acb:	7f 6c                	jg     800b39 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800acd:	83 ec 0c             	sub    $0xc,%esp
  800ad0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ad3:	50                   	push   %eax
  800ad4:	e8 b4 f8 ff ff       	call   80038d <fd_alloc>
  800ad9:	89 c3                	mov    %eax,%ebx
  800adb:	83 c4 10             	add    $0x10,%esp
  800ade:	85 c0                	test   %eax,%eax
  800ae0:	78 3c                	js     800b1e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	56                   	push   %esi
  800ae6:	68 00 50 80 00       	push   $0x805000
  800aeb:	e8 90 10 00 00       	call   801b80 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afb:	b8 01 00 00 00       	mov    $0x1,%eax
  800b00:	e8 f3 fd ff ff       	call   8008f8 <fsipc>
  800b05:	89 c3                	mov    %eax,%ebx
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	85 c0                	test   %eax,%eax
  800b0c:	78 19                	js     800b27 <open+0x75>
	return fd2num(fd);
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	ff 75 f4             	pushl  -0xc(%ebp)
  800b14:	e8 4d f8 ff ff       	call   800366 <fd2num>
  800b19:	89 c3                	mov    %eax,%ebx
  800b1b:	83 c4 10             	add    $0x10,%esp
}
  800b1e:	89 d8                	mov    %ebx,%eax
  800b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    
		fd_close(fd, 0);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	6a 00                	push   $0x0
  800b2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2f:	e8 54 f9 ff ff       	call   800488 <fd_close>
		return r;
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	eb e5                	jmp    800b1e <open+0x6c>
		return -E_BAD_PATH;
  800b39:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b3e:	eb de                	jmp    800b1e <open+0x6c>

00800b40 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800b50:	e8 a3 fd ff ff       	call   8008f8 <fsipc>
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b5d:	68 3b 23 80 00       	push   $0x80233b
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	e8 16 10 00 00       	call   801b80 <strcpy>
	return 0;
}
  800b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <devsock_close>:
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	53                   	push   %ebx
  800b75:	83 ec 10             	sub    $0x10,%esp
  800b78:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800b7b:	53                   	push   %ebx
  800b7c:	e8 30 14 00 00       	call   801fb1 <pageref>
  800b81:	83 c4 10             	add    $0x10,%esp
		return 0;
  800b84:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800b89:	83 f8 01             	cmp    $0x1,%eax
  800b8c:	74 07                	je     800b95 <devsock_close+0x24>
}
  800b8e:	89 d0                	mov    %edx,%eax
  800b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800b95:	83 ec 0c             	sub    $0xc,%esp
  800b98:	ff 73 0c             	pushl  0xc(%ebx)
  800b9b:	e8 b7 02 00 00       	call   800e57 <nsipc_close>
  800ba0:	89 c2                	mov    %eax,%edx
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	eb e7                	jmp    800b8e <devsock_close+0x1d>

00800ba7 <devsock_write>:
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bad:	6a 00                	push   $0x0
  800baf:	ff 75 10             	pushl  0x10(%ebp)
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff 70 0c             	pushl  0xc(%eax)
  800bbb:	e8 74 03 00 00       	call   800f34 <nsipc_send>
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <devsock_read>:
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bc8:	6a 00                	push   $0x0
  800bca:	ff 75 10             	pushl  0x10(%ebp)
  800bcd:	ff 75 0c             	pushl  0xc(%ebp)
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	ff 70 0c             	pushl  0xc(%eax)
  800bd6:	e8 ed 02 00 00       	call   800ec8 <nsipc_recv>
}
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <fd2sockid>:
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800be3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	e8 ef f7 ff ff       	call   8003dc <fd_lookup>
  800bed:	83 c4 10             	add    $0x10,%esp
  800bf0:	85 c0                	test   %eax,%eax
  800bf2:	78 10                	js     800c04 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800bfd:	39 08                	cmp    %ecx,(%eax)
  800bff:	75 05                	jne    800c06 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c01:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    
		return -E_NOT_SUPP;
  800c06:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c0b:	eb f7                	jmp    800c04 <fd2sockid+0x27>

00800c0d <alloc_sockfd>:
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	83 ec 1c             	sub    $0x1c,%esp
  800c15:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c1a:	50                   	push   %eax
  800c1b:	e8 6d f7 ff ff       	call   80038d <fd_alloc>
  800c20:	89 c3                	mov    %eax,%ebx
  800c22:	83 c4 10             	add    $0x10,%esp
  800c25:	85 c0                	test   %eax,%eax
  800c27:	78 43                	js     800c6c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c29:	83 ec 04             	sub    $0x4,%esp
  800c2c:	68 07 04 00 00       	push   $0x407
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	6a 00                	push   $0x0
  800c36:	e8 1b f5 ff ff       	call   800156 <sys_page_alloc>
  800c3b:	89 c3                	mov    %eax,%ebx
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	85 c0                	test   %eax,%eax
  800c42:	78 28                	js     800c6c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c47:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c4d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c59:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	50                   	push   %eax
  800c60:	e8 01 f7 ff ff       	call   800366 <fd2num>
  800c65:	89 c3                	mov    %eax,%ebx
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	eb 0c                	jmp    800c78 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	56                   	push   %esi
  800c70:	e8 e2 01 00 00       	call   800e57 <nsipc_close>
		return r;
  800c75:	83 c4 10             	add    $0x10,%esp
}
  800c78:	89 d8                	mov    %ebx,%eax
  800c7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <accept>:
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	e8 4e ff ff ff       	call   800bdd <fd2sockid>
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	78 1b                	js     800cae <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800c93:	83 ec 04             	sub    $0x4,%esp
  800c96:	ff 75 10             	pushl  0x10(%ebp)
  800c99:	ff 75 0c             	pushl  0xc(%ebp)
  800c9c:	50                   	push   %eax
  800c9d:	e8 0e 01 00 00       	call   800db0 <nsipc_accept>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	78 05                	js     800cae <accept+0x2d>
	return alloc_sockfd(r);
  800ca9:	e8 5f ff ff ff       	call   800c0d <alloc_sockfd>
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <bind>:
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	e8 1f ff ff ff       	call   800bdd <fd2sockid>
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	78 12                	js     800cd4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800cc2:	83 ec 04             	sub    $0x4,%esp
  800cc5:	ff 75 10             	pushl  0x10(%ebp)
  800cc8:	ff 75 0c             	pushl  0xc(%ebp)
  800ccb:	50                   	push   %eax
  800ccc:	e8 2f 01 00 00       	call   800e00 <nsipc_bind>
  800cd1:	83 c4 10             	add    $0x10,%esp
}
  800cd4:	c9                   	leave  
  800cd5:	c3                   	ret    

00800cd6 <shutdown>:
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	e8 f9 fe ff ff       	call   800bdd <fd2sockid>
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	78 0f                	js     800cf7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	e8 41 01 00 00       	call   800e35 <nsipc_shutdown>
  800cf4:	83 c4 10             	add    $0x10,%esp
}
  800cf7:	c9                   	leave  
  800cf8:	c3                   	ret    

00800cf9 <connect>:
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	e8 d6 fe ff ff       	call   800bdd <fd2sockid>
  800d07:	85 c0                	test   %eax,%eax
  800d09:	78 12                	js     800d1d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d0b:	83 ec 04             	sub    $0x4,%esp
  800d0e:	ff 75 10             	pushl  0x10(%ebp)
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	50                   	push   %eax
  800d15:	e8 57 01 00 00       	call   800e71 <nsipc_connect>
  800d1a:	83 c4 10             	add    $0x10,%esp
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <listen>:
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	e8 b0 fe ff ff       	call   800bdd <fd2sockid>
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	78 0f                	js     800d40 <listen+0x21>
	return nsipc_listen(r, backlog);
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	50                   	push   %eax
  800d38:	e8 69 01 00 00       	call   800ea6 <nsipc_listen>
  800d3d:	83 c4 10             	add    $0x10,%esp
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <socket>:

int
socket(int domain, int type, int protocol)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d48:	ff 75 10             	pushl  0x10(%ebp)
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	ff 75 08             	pushl  0x8(%ebp)
  800d51:	e8 3c 02 00 00       	call   800f92 <nsipc_socket>
  800d56:	83 c4 10             	add    $0x10,%esp
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	78 05                	js     800d62 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d5d:	e8 ab fe ff ff       	call   800c0d <alloc_sockfd>
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	53                   	push   %ebx
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d6d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d74:	74 26                	je     800d9c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800d76:	6a 07                	push   $0x7
  800d78:	68 00 60 80 00       	push   $0x806000
  800d7d:	53                   	push   %ebx
  800d7e:	ff 35 04 40 80 00    	pushl  0x804004
  800d84:	e8 9b 11 00 00       	call   801f24 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800d89:	83 c4 0c             	add    $0xc,%esp
  800d8c:	6a 00                	push   $0x0
  800d8e:	6a 00                	push   $0x0
  800d90:	6a 00                	push   $0x0
  800d92:	e8 26 11 00 00       	call   801ebd <ipc_recv>
}
  800d97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	6a 02                	push   $0x2
  800da1:	e8 d2 11 00 00       	call   801f78 <ipc_find_env>
  800da6:	a3 04 40 80 00       	mov    %eax,0x804004
  800dab:	83 c4 10             	add    $0x10,%esp
  800dae:	eb c6                	jmp    800d76 <nsipc+0x12>

00800db0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
  800db5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800dc0:	8b 06                	mov    (%esi),%eax
  800dc2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  800dcc:	e8 93 ff ff ff       	call   800d64 <nsipc>
  800dd1:	89 c3                	mov    %eax,%ebx
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	78 20                	js     800df7 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800dd7:	83 ec 04             	sub    $0x4,%esp
  800dda:	ff 35 10 60 80 00    	pushl  0x806010
  800de0:	68 00 60 80 00       	push   $0x806000
  800de5:	ff 75 0c             	pushl  0xc(%ebp)
  800de8:	e8 21 0f 00 00       	call   801d0e <memmove>
		*addrlen = ret->ret_addrlen;
  800ded:	a1 10 60 80 00       	mov    0x806010,%eax
  800df2:	89 06                	mov    %eax,(%esi)
  800df4:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800df7:	89 d8                	mov    %ebx,%eax
  800df9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dfc:	5b                   	pop    %ebx
  800dfd:	5e                   	pop    %esi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	53                   	push   %ebx
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e12:	53                   	push   %ebx
  800e13:	ff 75 0c             	pushl  0xc(%ebp)
  800e16:	68 04 60 80 00       	push   $0x806004
  800e1b:	e8 ee 0e 00 00       	call   801d0e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e20:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e26:	b8 02 00 00 00       	mov    $0x2,%eax
  800e2b:	e8 34 ff ff ff       	call   800d64 <nsipc>
}
  800e30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e33:	c9                   	leave  
  800e34:	c3                   	ret    

00800e35 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e50:	e8 0f ff ff ff       	call   800d64 <nsipc>
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <nsipc_close>:

int
nsipc_close(int s)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e65:	b8 04 00 00 00       	mov    $0x4,%eax
  800e6a:	e8 f5 fe ff ff       	call   800d64 <nsipc>
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	53                   	push   %ebx
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800e83:	53                   	push   %ebx
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	68 04 60 80 00       	push   $0x806004
  800e8c:	e8 7d 0e 00 00       	call   801d0e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800e91:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800e97:	b8 05 00 00 00       	mov    $0x5,%eax
  800e9c:	e8 c3 fe ff ff       	call   800d64 <nsipc>
}
  800ea1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ebc:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec1:	e8 9e fe ff ff       	call   800d64 <nsipc>
}
  800ec6:	c9                   	leave  
  800ec7:	c3                   	ret    

00800ec8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800ed8:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800ede:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800ee6:	b8 07 00 00 00       	mov    $0x7,%eax
  800eeb:	e8 74 fe ff ff       	call   800d64 <nsipc>
  800ef0:	89 c3                	mov    %eax,%ebx
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	78 1f                	js     800f15 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800ef6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800efb:	7f 21                	jg     800f1e <nsipc_recv+0x56>
  800efd:	39 c6                	cmp    %eax,%esi
  800eff:	7c 1d                	jl     800f1e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f01:	83 ec 04             	sub    $0x4,%esp
  800f04:	50                   	push   %eax
  800f05:	68 00 60 80 00       	push   $0x806000
  800f0a:	ff 75 0c             	pushl  0xc(%ebp)
  800f0d:	e8 fc 0d 00 00       	call   801d0e <memmove>
  800f12:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f15:	89 d8                	mov    %ebx,%eax
  800f17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f1e:	68 47 23 80 00       	push   $0x802347
  800f23:	68 0f 23 80 00       	push   $0x80230f
  800f28:	6a 62                	push   $0x62
  800f2a:	68 5c 23 80 00       	push   $0x80235c
  800f2f:	e8 52 05 00 00       	call   801486 <_panic>

00800f34 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	53                   	push   %ebx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f46:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f4c:	7f 2e                	jg     800f7c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f4e:	83 ec 04             	sub    $0x4,%esp
  800f51:	53                   	push   %ebx
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	68 0c 60 80 00       	push   $0x80600c
  800f5a:	e8 af 0d 00 00       	call   801d0e <memmove>
	nsipcbuf.send.req_size = size;
  800f5f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f65:	8b 45 14             	mov    0x14(%ebp),%eax
  800f68:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f6d:	b8 08 00 00 00       	mov    $0x8,%eax
  800f72:	e8 ed fd ff ff       	call   800d64 <nsipc>
}
  800f77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    
	assert(size < 1600);
  800f7c:	68 68 23 80 00       	push   $0x802368
  800f81:	68 0f 23 80 00       	push   $0x80230f
  800f86:	6a 6d                	push   $0x6d
  800f88:	68 5c 23 80 00       	push   $0x80235c
  800f8d:	e8 f4 04 00 00       	call   801486 <_panic>

00800f92 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fa8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fab:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800fb0:	b8 09 00 00 00       	mov    $0x9,%eax
  800fb5:	e8 aa fd ff ff       	call   800d64 <nsipc>
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
  800fc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fc4:	83 ec 0c             	sub    $0xc,%esp
  800fc7:	ff 75 08             	pushl  0x8(%ebp)
  800fca:	e8 a7 f3 ff ff       	call   800376 <fd2data>
  800fcf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fd1:	83 c4 08             	add    $0x8,%esp
  800fd4:	68 74 23 80 00       	push   $0x802374
  800fd9:	53                   	push   %ebx
  800fda:	e8 a1 0b 00 00       	call   801b80 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fdf:	8b 46 04             	mov    0x4(%esi),%eax
  800fe2:	2b 06                	sub    (%esi),%eax
  800fe4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ff1:	00 00 00 
	stat->st_dev = &devpipe;
  800ff4:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  800ffb:	30 80 00 
	return 0;
}
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  801003:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	53                   	push   %ebx
  80100e:	83 ec 0c             	sub    $0xc,%esp
  801011:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801014:	53                   	push   %ebx
  801015:	6a 00                	push   $0x0
  801017:	e8 bf f1 ff ff       	call   8001db <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80101c:	89 1c 24             	mov    %ebx,(%esp)
  80101f:	e8 52 f3 ff ff       	call   800376 <fd2data>
  801024:	83 c4 08             	add    $0x8,%esp
  801027:	50                   	push   %eax
  801028:	6a 00                	push   $0x0
  80102a:	e8 ac f1 ff ff       	call   8001db <sys_page_unmap>
}
  80102f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <_pipeisclosed>:
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	57                   	push   %edi
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
  80103a:	83 ec 1c             	sub    $0x1c,%esp
  80103d:	89 c7                	mov    %eax,%edi
  80103f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801041:	a1 08 40 80 00       	mov    0x804008,%eax
  801046:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801049:	83 ec 0c             	sub    $0xc,%esp
  80104c:	57                   	push   %edi
  80104d:	e8 5f 0f 00 00       	call   801fb1 <pageref>
  801052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801055:	89 34 24             	mov    %esi,(%esp)
  801058:	e8 54 0f 00 00       	call   801fb1 <pageref>
		nn = thisenv->env_runs;
  80105d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801063:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	39 cb                	cmp    %ecx,%ebx
  80106b:	74 1b                	je     801088 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80106d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801070:	75 cf                	jne    801041 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801072:	8b 42 58             	mov    0x58(%edx),%eax
  801075:	6a 01                	push   $0x1
  801077:	50                   	push   %eax
  801078:	53                   	push   %ebx
  801079:	68 7b 23 80 00       	push   $0x80237b
  80107e:	e8 de 04 00 00       	call   801561 <cprintf>
  801083:	83 c4 10             	add    $0x10,%esp
  801086:	eb b9                	jmp    801041 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801088:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80108b:	0f 94 c0             	sete   %al
  80108e:	0f b6 c0             	movzbl %al,%eax
}
  801091:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801094:	5b                   	pop    %ebx
  801095:	5e                   	pop    %esi
  801096:	5f                   	pop    %edi
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <devpipe_write>:
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
  80109f:	83 ec 28             	sub    $0x28,%esp
  8010a2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010a5:	56                   	push   %esi
  8010a6:	e8 cb f2 ff ff       	call   800376 <fd2data>
  8010ab:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8010b5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010b8:	74 4f                	je     801109 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010ba:	8b 43 04             	mov    0x4(%ebx),%eax
  8010bd:	8b 0b                	mov    (%ebx),%ecx
  8010bf:	8d 51 20             	lea    0x20(%ecx),%edx
  8010c2:	39 d0                	cmp    %edx,%eax
  8010c4:	72 14                	jb     8010da <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010c6:	89 da                	mov    %ebx,%edx
  8010c8:	89 f0                	mov    %esi,%eax
  8010ca:	e8 65 ff ff ff       	call   801034 <_pipeisclosed>
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	75 3a                	jne    80110d <devpipe_write+0x74>
			sys_yield();
  8010d3:	e8 5f f0 ff ff       	call   800137 <sys_yield>
  8010d8:	eb e0                	jmp    8010ba <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010dd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010e1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	c1 fa 1f             	sar    $0x1f,%edx
  8010e9:	89 d1                	mov    %edx,%ecx
  8010eb:	c1 e9 1b             	shr    $0x1b,%ecx
  8010ee:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010f1:	83 e2 1f             	and    $0x1f,%edx
  8010f4:	29 ca                	sub    %ecx,%edx
  8010f6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010fa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8010fe:	83 c0 01             	add    $0x1,%eax
  801101:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801104:	83 c7 01             	add    $0x1,%edi
  801107:	eb ac                	jmp    8010b5 <devpipe_write+0x1c>
	return i;
  801109:	89 f8                	mov    %edi,%eax
  80110b:	eb 05                	jmp    801112 <devpipe_write+0x79>
				return 0;
  80110d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801112:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <devpipe_read>:
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	57                   	push   %edi
  80111e:	56                   	push   %esi
  80111f:	53                   	push   %ebx
  801120:	83 ec 18             	sub    $0x18,%esp
  801123:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801126:	57                   	push   %edi
  801127:	e8 4a f2 ff ff       	call   800376 <fd2data>
  80112c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	be 00 00 00 00       	mov    $0x0,%esi
  801136:	3b 75 10             	cmp    0x10(%ebp),%esi
  801139:	74 47                	je     801182 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80113b:	8b 03                	mov    (%ebx),%eax
  80113d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801140:	75 22                	jne    801164 <devpipe_read+0x4a>
			if (i > 0)
  801142:	85 f6                	test   %esi,%esi
  801144:	75 14                	jne    80115a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801146:	89 da                	mov    %ebx,%edx
  801148:	89 f8                	mov    %edi,%eax
  80114a:	e8 e5 fe ff ff       	call   801034 <_pipeisclosed>
  80114f:	85 c0                	test   %eax,%eax
  801151:	75 33                	jne    801186 <devpipe_read+0x6c>
			sys_yield();
  801153:	e8 df ef ff ff       	call   800137 <sys_yield>
  801158:	eb e1                	jmp    80113b <devpipe_read+0x21>
				return i;
  80115a:	89 f0                	mov    %esi,%eax
}
  80115c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5f                   	pop    %edi
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801164:	99                   	cltd   
  801165:	c1 ea 1b             	shr    $0x1b,%edx
  801168:	01 d0                	add    %edx,%eax
  80116a:	83 e0 1f             	and    $0x1f,%eax
  80116d:	29 d0                	sub    %edx,%eax
  80116f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801177:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80117a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80117d:	83 c6 01             	add    $0x1,%esi
  801180:	eb b4                	jmp    801136 <devpipe_read+0x1c>
	return i;
  801182:	89 f0                	mov    %esi,%eax
  801184:	eb d6                	jmp    80115c <devpipe_read+0x42>
				return 0;
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
  80118b:	eb cf                	jmp    80115c <devpipe_read+0x42>

0080118d <pipe>:
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	56                   	push   %esi
  801191:	53                   	push   %ebx
  801192:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801195:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801198:	50                   	push   %eax
  801199:	e8 ef f1 ff ff       	call   80038d <fd_alloc>
  80119e:	89 c3                	mov    %eax,%ebx
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	78 5b                	js     801202 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011a7:	83 ec 04             	sub    $0x4,%esp
  8011aa:	68 07 04 00 00       	push   $0x407
  8011af:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b2:	6a 00                	push   $0x0
  8011b4:	e8 9d ef ff ff       	call   800156 <sys_page_alloc>
  8011b9:	89 c3                	mov    %eax,%ebx
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	78 40                	js     801202 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	e8 bf f1 ff ff       	call   80038d <fd_alloc>
  8011ce:	89 c3                	mov    %eax,%ebx
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	78 1b                	js     8011f2 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011d7:	83 ec 04             	sub    $0x4,%esp
  8011da:	68 07 04 00 00       	push   $0x407
  8011df:	ff 75 f0             	pushl  -0x10(%ebp)
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 6d ef ff ff       	call   800156 <sys_page_alloc>
  8011e9:	89 c3                	mov    %eax,%ebx
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	79 19                	jns    80120b <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8011f2:	83 ec 08             	sub    $0x8,%esp
  8011f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f8:	6a 00                	push   $0x0
  8011fa:	e8 dc ef ff ff       	call   8001db <sys_page_unmap>
  8011ff:	83 c4 10             	add    $0x10,%esp
}
  801202:	89 d8                	mov    %ebx,%eax
  801204:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    
	va = fd2data(fd0);
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	ff 75 f4             	pushl  -0xc(%ebp)
  801211:	e8 60 f1 ff ff       	call   800376 <fd2data>
  801216:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801218:	83 c4 0c             	add    $0xc,%esp
  80121b:	68 07 04 00 00       	push   $0x407
  801220:	50                   	push   %eax
  801221:	6a 00                	push   $0x0
  801223:	e8 2e ef ff ff       	call   800156 <sys_page_alloc>
  801228:	89 c3                	mov    %eax,%ebx
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	85 c0                	test   %eax,%eax
  80122f:	0f 88 8c 00 00 00    	js     8012c1 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 f0             	pushl  -0x10(%ebp)
  80123b:	e8 36 f1 ff ff       	call   800376 <fd2data>
  801240:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801247:	50                   	push   %eax
  801248:	6a 00                	push   $0x0
  80124a:	56                   	push   %esi
  80124b:	6a 00                	push   $0x0
  80124d:	e8 47 ef ff ff       	call   800199 <sys_page_map>
  801252:	89 c3                	mov    %eax,%ebx
  801254:	83 c4 20             	add    $0x20,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 58                	js     8012b3 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801264:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801269:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801273:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801279:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80127b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 f4             	pushl  -0xc(%ebp)
  80128b:	e8 d6 f0 ff ff       	call   800366 <fd2num>
  801290:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801293:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801295:	83 c4 04             	add    $0x4,%esp
  801298:	ff 75 f0             	pushl  -0x10(%ebp)
  80129b:	e8 c6 f0 ff ff       	call   800366 <fd2num>
  8012a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ae:	e9 4f ff ff ff       	jmp    801202 <pipe+0x75>
	sys_page_unmap(0, va);
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	56                   	push   %esi
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 1d ef ff ff       	call   8001db <sys_page_unmap>
  8012be:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8012c7:	6a 00                	push   $0x0
  8012c9:	e8 0d ef ff ff       	call   8001db <sys_page_unmap>
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	e9 1c ff ff ff       	jmp    8011f2 <pipe+0x65>

008012d6 <pipeisclosed>:
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012df:	50                   	push   %eax
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	e8 f4 f0 ff ff       	call   8003dc <fd_lookup>
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 18                	js     801307 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012ef:	83 ec 0c             	sub    $0xc,%esp
  8012f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f5:	e8 7c f0 ff ff       	call   800376 <fd2data>
	return _pipeisclosed(fd, p);
  8012fa:	89 c2                	mov    %eax,%edx
  8012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ff:	e8 30 fd ff ff       	call   801034 <_pipeisclosed>
  801304:	83 c4 10             	add    $0x10,%esp
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80130c:	b8 00 00 00 00       	mov    $0x0,%eax
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    

00801313 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801319:	68 93 23 80 00       	push   $0x802393
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	e8 5a 08 00 00       	call   801b80 <strcpy>
	return 0;
}
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <devcons_write>:
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	57                   	push   %edi
  801331:	56                   	push   %esi
  801332:	53                   	push   %ebx
  801333:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801339:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80133e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801344:	eb 2f                	jmp    801375 <devcons_write+0x48>
		m = n - tot;
  801346:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801349:	29 f3                	sub    %esi,%ebx
  80134b:	83 fb 7f             	cmp    $0x7f,%ebx
  80134e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801353:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	53                   	push   %ebx
  80135a:	89 f0                	mov    %esi,%eax
  80135c:	03 45 0c             	add    0xc(%ebp),%eax
  80135f:	50                   	push   %eax
  801360:	57                   	push   %edi
  801361:	e8 a8 09 00 00       	call   801d0e <memmove>
		sys_cputs(buf, m);
  801366:	83 c4 08             	add    $0x8,%esp
  801369:	53                   	push   %ebx
  80136a:	57                   	push   %edi
  80136b:	e8 2a ed ff ff       	call   80009a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801370:	01 de                	add    %ebx,%esi
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	3b 75 10             	cmp    0x10(%ebp),%esi
  801378:	72 cc                	jb     801346 <devcons_write+0x19>
}
  80137a:	89 f0                	mov    %esi,%eax
  80137c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137f:	5b                   	pop    %ebx
  801380:	5e                   	pop    %esi
  801381:	5f                   	pop    %edi
  801382:	5d                   	pop    %ebp
  801383:	c3                   	ret    

00801384 <devcons_read>:
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80138f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801393:	75 07                	jne    80139c <devcons_read+0x18>
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    
		sys_yield();
  801397:	e8 9b ed ff ff       	call   800137 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80139c:	e8 17 ed ff ff       	call   8000b8 <sys_cgetc>
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	74 f2                	je     801397 <devcons_read+0x13>
	if (c < 0)
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 ec                	js     801395 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013a9:	83 f8 04             	cmp    $0x4,%eax
  8013ac:	74 0c                	je     8013ba <devcons_read+0x36>
	*(char*)vbuf = c;
  8013ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b1:	88 02                	mov    %al,(%edx)
	return 1;
  8013b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8013b8:	eb db                	jmp    801395 <devcons_read+0x11>
		return 0;
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bf:	eb d4                	jmp    801395 <devcons_read+0x11>

008013c1 <cputchar>:
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013cd:	6a 01                	push   $0x1
  8013cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013d2:	50                   	push   %eax
  8013d3:	e8 c2 ec ff ff       	call   80009a <sys_cputs>
}
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <getchar>:
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013e3:	6a 01                	push   $0x1
  8013e5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	6a 00                	push   $0x0
  8013eb:	e8 5d f2 ff ff       	call   80064d <read>
	if (r < 0)
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 08                	js     8013ff <getchar+0x22>
	if (r < 1)
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	7e 06                	jle    801401 <getchar+0x24>
	return c;
  8013fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    
		return -E_EOF;
  801401:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801406:	eb f7                	jmp    8013ff <getchar+0x22>

00801408 <iscons>:
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80140e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801411:	50                   	push   %eax
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 c2 ef ff ff       	call   8003dc <fd_lookup>
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 11                	js     801432 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801424:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80142a:	39 10                	cmp    %edx,(%eax)
  80142c:	0f 94 c0             	sete   %al
  80142f:	0f b6 c0             	movzbl %al,%eax
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <opencons>:
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80143a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	e8 4a ef ff ff       	call   80038d <fd_alloc>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 3a                	js     801484 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80144a:	83 ec 04             	sub    $0x4,%esp
  80144d:	68 07 04 00 00       	push   $0x407
  801452:	ff 75 f4             	pushl  -0xc(%ebp)
  801455:	6a 00                	push   $0x0
  801457:	e8 fa ec ff ff       	call   800156 <sys_page_alloc>
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	78 21                	js     801484 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801466:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80146c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80146e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801471:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 e5 ee ff ff       	call   800366 <fd2num>
  801481:	83 c4 10             	add    $0x10,%esp
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80148b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80148e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801494:	e8 7f ec ff ff       	call   800118 <sys_getenvid>
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	ff 75 0c             	pushl  0xc(%ebp)
  80149f:	ff 75 08             	pushl  0x8(%ebp)
  8014a2:	56                   	push   %esi
  8014a3:	50                   	push   %eax
  8014a4:	68 a0 23 80 00       	push   $0x8023a0
  8014a9:	e8 b3 00 00 00       	call   801561 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ae:	83 c4 18             	add    $0x18,%esp
  8014b1:	53                   	push   %ebx
  8014b2:	ff 75 10             	pushl  0x10(%ebp)
  8014b5:	e8 56 00 00 00       	call   801510 <vcprintf>
	cprintf("\n");
  8014ba:	c7 04 24 8c 23 80 00 	movl   $0x80238c,(%esp)
  8014c1:	e8 9b 00 00 00       	call   801561 <cprintf>
  8014c6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014c9:	cc                   	int3   
  8014ca:	eb fd                	jmp    8014c9 <_panic+0x43>

008014cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014d6:	8b 13                	mov    (%ebx),%edx
  8014d8:	8d 42 01             	lea    0x1(%edx),%eax
  8014db:	89 03                	mov    %eax,(%ebx)
  8014dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014e9:	74 09                	je     8014f4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014eb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	68 ff 00 00 00       	push   $0xff
  8014fc:	8d 43 08             	lea    0x8(%ebx),%eax
  8014ff:	50                   	push   %eax
  801500:	e8 95 eb ff ff       	call   80009a <sys_cputs>
		b->idx = 0;
  801505:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	eb db                	jmp    8014eb <putch+0x1f>

00801510 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801519:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801520:	00 00 00 
	b.cnt = 0;
  801523:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80152a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	ff 75 08             	pushl  0x8(%ebp)
  801533:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	68 cc 14 80 00       	push   $0x8014cc
  80153f:	e8 1a 01 00 00       	call   80165e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801544:	83 c4 08             	add    $0x8,%esp
  801547:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80154d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	e8 41 eb ff ff       	call   80009a <sys_cputs>

	return b.cnt;
}
  801559:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801567:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80156a:	50                   	push   %eax
  80156b:	ff 75 08             	pushl  0x8(%ebp)
  80156e:	e8 9d ff ff ff       	call   801510 <vcprintf>
	va_end(ap);

	return cnt;
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	57                   	push   %edi
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
  80157b:	83 ec 1c             	sub    $0x1c,%esp
  80157e:	89 c7                	mov    %eax,%edi
  801580:	89 d6                	mov    %edx,%esi
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8b 55 0c             	mov    0xc(%ebp),%edx
  801588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80158b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80158e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801591:	bb 00 00 00 00       	mov    $0x0,%ebx
  801596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801599:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80159c:	39 d3                	cmp    %edx,%ebx
  80159e:	72 05                	jb     8015a5 <printnum+0x30>
  8015a0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015a3:	77 7a                	ja     80161f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	ff 75 18             	pushl  0x18(%ebp)
  8015ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015b1:	53                   	push   %ebx
  8015b2:	ff 75 10             	pushl  0x10(%ebp)
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8015be:	ff 75 dc             	pushl  -0x24(%ebp)
  8015c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8015c4:	e8 27 0a 00 00       	call   801ff0 <__udivdi3>
  8015c9:	83 c4 18             	add    $0x18,%esp
  8015cc:	52                   	push   %edx
  8015cd:	50                   	push   %eax
  8015ce:	89 f2                	mov    %esi,%edx
  8015d0:	89 f8                	mov    %edi,%eax
  8015d2:	e8 9e ff ff ff       	call   801575 <printnum>
  8015d7:	83 c4 20             	add    $0x20,%esp
  8015da:	eb 13                	jmp    8015ef <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	56                   	push   %esi
  8015e0:	ff 75 18             	pushl  0x18(%ebp)
  8015e3:	ff d7                	call   *%edi
  8015e5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015e8:	83 eb 01             	sub    $0x1,%ebx
  8015eb:	85 db                	test   %ebx,%ebx
  8015ed:	7f ed                	jg     8015dc <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015ef:	83 ec 08             	sub    $0x8,%esp
  8015f2:	56                   	push   %esi
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8015fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8015ff:	ff 75 d8             	pushl  -0x28(%ebp)
  801602:	e8 09 0b 00 00       	call   802110 <__umoddi3>
  801607:	83 c4 14             	add    $0x14,%esp
  80160a:	0f be 80 c3 23 80 00 	movsbl 0x8023c3(%eax),%eax
  801611:	50                   	push   %eax
  801612:	ff d7                	call   *%edi
}
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5f                   	pop    %edi
  80161d:	5d                   	pop    %ebp
  80161e:	c3                   	ret    
  80161f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801622:	eb c4                	jmp    8015e8 <printnum+0x73>

00801624 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80162a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80162e:	8b 10                	mov    (%eax),%edx
  801630:	3b 50 04             	cmp    0x4(%eax),%edx
  801633:	73 0a                	jae    80163f <sprintputch+0x1b>
		*b->buf++ = ch;
  801635:	8d 4a 01             	lea    0x1(%edx),%ecx
  801638:	89 08                	mov    %ecx,(%eax)
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	88 02                	mov    %al,(%edx)
}
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <printfmt>:
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801647:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80164a:	50                   	push   %eax
  80164b:	ff 75 10             	pushl  0x10(%ebp)
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	ff 75 08             	pushl  0x8(%ebp)
  801654:	e8 05 00 00 00       	call   80165e <vprintfmt>
}
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <vprintfmt>:
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	57                   	push   %edi
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 2c             	sub    $0x2c,%esp
  801667:	8b 75 08             	mov    0x8(%ebp),%esi
  80166a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80166d:	8b 7d 10             	mov    0x10(%ebp),%edi
  801670:	e9 c1 03 00 00       	jmp    801a36 <vprintfmt+0x3d8>
		padc = ' ';
  801675:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801679:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801680:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801687:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80168e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801693:	8d 47 01             	lea    0x1(%edi),%eax
  801696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801699:	0f b6 17             	movzbl (%edi),%edx
  80169c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80169f:	3c 55                	cmp    $0x55,%al
  8016a1:	0f 87 12 04 00 00    	ja     801ab9 <vprintfmt+0x45b>
  8016a7:	0f b6 c0             	movzbl %al,%eax
  8016aa:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  8016b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016b4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016b8:	eb d9                	jmp    801693 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016bd:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016c1:	eb d0                	jmp    801693 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016c3:	0f b6 d2             	movzbl %dl,%edx
  8016c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016d1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016d4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016d8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016db:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016de:	83 f9 09             	cmp    $0x9,%ecx
  8016e1:	77 55                	ja     801738 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016e3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016e6:	eb e9                	jmp    8016d1 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016eb:	8b 00                	mov    (%eax),%eax
  8016ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8016f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f3:	8d 40 04             	lea    0x4(%eax),%eax
  8016f6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8016fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801700:	79 91                	jns    801693 <vprintfmt+0x35>
				width = precision, precision = -1;
  801702:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801705:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801708:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80170f:	eb 82                	jmp    801693 <vprintfmt+0x35>
  801711:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801714:	85 c0                	test   %eax,%eax
  801716:	ba 00 00 00 00       	mov    $0x0,%edx
  80171b:	0f 49 d0             	cmovns %eax,%edx
  80171e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801721:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801724:	e9 6a ff ff ff       	jmp    801693 <vprintfmt+0x35>
  801729:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80172c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801733:	e9 5b ff ff ff       	jmp    801693 <vprintfmt+0x35>
  801738:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80173b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80173e:	eb bc                	jmp    8016fc <vprintfmt+0x9e>
			lflag++;
  801740:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801746:	e9 48 ff ff ff       	jmp    801693 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80174b:	8b 45 14             	mov    0x14(%ebp),%eax
  80174e:	8d 78 04             	lea    0x4(%eax),%edi
  801751:	83 ec 08             	sub    $0x8,%esp
  801754:	53                   	push   %ebx
  801755:	ff 30                	pushl  (%eax)
  801757:	ff d6                	call   *%esi
			break;
  801759:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80175c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80175f:	e9 cf 02 00 00       	jmp    801a33 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801764:	8b 45 14             	mov    0x14(%ebp),%eax
  801767:	8d 78 04             	lea    0x4(%eax),%edi
  80176a:	8b 00                	mov    (%eax),%eax
  80176c:	99                   	cltd   
  80176d:	31 d0                	xor    %edx,%eax
  80176f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801771:	83 f8 0f             	cmp    $0xf,%eax
  801774:	7f 23                	jg     801799 <vprintfmt+0x13b>
  801776:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  80177d:	85 d2                	test   %edx,%edx
  80177f:	74 18                	je     801799 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801781:	52                   	push   %edx
  801782:	68 21 23 80 00       	push   $0x802321
  801787:	53                   	push   %ebx
  801788:	56                   	push   %esi
  801789:	e8 b3 fe ff ff       	call   801641 <printfmt>
  80178e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801791:	89 7d 14             	mov    %edi,0x14(%ebp)
  801794:	e9 9a 02 00 00       	jmp    801a33 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  801799:	50                   	push   %eax
  80179a:	68 db 23 80 00       	push   $0x8023db
  80179f:	53                   	push   %ebx
  8017a0:	56                   	push   %esi
  8017a1:	e8 9b fe ff ff       	call   801641 <printfmt>
  8017a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017a9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017ac:	e9 82 02 00 00       	jmp    801a33 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b4:	83 c0 04             	add    $0x4,%eax
  8017b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bd:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017bf:	85 ff                	test   %edi,%edi
  8017c1:	b8 d4 23 80 00       	mov    $0x8023d4,%eax
  8017c6:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017cd:	0f 8e bd 00 00 00    	jle    801890 <vprintfmt+0x232>
  8017d3:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017d7:	75 0e                	jne    8017e7 <vprintfmt+0x189>
  8017d9:	89 75 08             	mov    %esi,0x8(%ebp)
  8017dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017df:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017e2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017e5:	eb 6d                	jmp    801854 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017e7:	83 ec 08             	sub    $0x8,%esp
  8017ea:	ff 75 d0             	pushl  -0x30(%ebp)
  8017ed:	57                   	push   %edi
  8017ee:	e8 6e 03 00 00       	call   801b61 <strnlen>
  8017f3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017f6:	29 c1                	sub    %eax,%ecx
  8017f8:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8017fb:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8017fe:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801802:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801805:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801808:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80180a:	eb 0f                	jmp    80181b <vprintfmt+0x1bd>
					putch(padc, putdat);
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	53                   	push   %ebx
  801810:	ff 75 e0             	pushl  -0x20(%ebp)
  801813:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801815:	83 ef 01             	sub    $0x1,%edi
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	85 ff                	test   %edi,%edi
  80181d:	7f ed                	jg     80180c <vprintfmt+0x1ae>
  80181f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801822:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801825:	85 c9                	test   %ecx,%ecx
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
  80182c:	0f 49 c1             	cmovns %ecx,%eax
  80182f:	29 c1                	sub    %eax,%ecx
  801831:	89 75 08             	mov    %esi,0x8(%ebp)
  801834:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801837:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80183a:	89 cb                	mov    %ecx,%ebx
  80183c:	eb 16                	jmp    801854 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80183e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801842:	75 31                	jne    801875 <vprintfmt+0x217>
					putch(ch, putdat);
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	50                   	push   %eax
  80184b:	ff 55 08             	call   *0x8(%ebp)
  80184e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801851:	83 eb 01             	sub    $0x1,%ebx
  801854:	83 c7 01             	add    $0x1,%edi
  801857:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80185b:	0f be c2             	movsbl %dl,%eax
  80185e:	85 c0                	test   %eax,%eax
  801860:	74 59                	je     8018bb <vprintfmt+0x25d>
  801862:	85 f6                	test   %esi,%esi
  801864:	78 d8                	js     80183e <vprintfmt+0x1e0>
  801866:	83 ee 01             	sub    $0x1,%esi
  801869:	79 d3                	jns    80183e <vprintfmt+0x1e0>
  80186b:	89 df                	mov    %ebx,%edi
  80186d:	8b 75 08             	mov    0x8(%ebp),%esi
  801870:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801873:	eb 37                	jmp    8018ac <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801875:	0f be d2             	movsbl %dl,%edx
  801878:	83 ea 20             	sub    $0x20,%edx
  80187b:	83 fa 5e             	cmp    $0x5e,%edx
  80187e:	76 c4                	jbe    801844 <vprintfmt+0x1e6>
					putch('?', putdat);
  801880:	83 ec 08             	sub    $0x8,%esp
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	6a 3f                	push   $0x3f
  801888:	ff 55 08             	call   *0x8(%ebp)
  80188b:	83 c4 10             	add    $0x10,%esp
  80188e:	eb c1                	jmp    801851 <vprintfmt+0x1f3>
  801890:	89 75 08             	mov    %esi,0x8(%ebp)
  801893:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801896:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801899:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80189c:	eb b6                	jmp    801854 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	53                   	push   %ebx
  8018a2:	6a 20                	push   $0x20
  8018a4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018a6:	83 ef 01             	sub    $0x1,%edi
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 ff                	test   %edi,%edi
  8018ae:	7f ee                	jg     80189e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8018b6:	e9 78 01 00 00       	jmp    801a33 <vprintfmt+0x3d5>
  8018bb:	89 df                	mov    %ebx,%edi
  8018bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018c3:	eb e7                	jmp    8018ac <vprintfmt+0x24e>
	if (lflag >= 2)
  8018c5:	83 f9 01             	cmp    $0x1,%ecx
  8018c8:	7e 3f                	jle    801909 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cd:	8b 50 04             	mov    0x4(%eax),%edx
  8018d0:	8b 00                	mov    (%eax),%eax
  8018d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018db:	8d 40 08             	lea    0x8(%eax),%eax
  8018de:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018e5:	79 5c                	jns    801943 <vprintfmt+0x2e5>
				putch('-', putdat);
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	53                   	push   %ebx
  8018eb:	6a 2d                	push   $0x2d
  8018ed:	ff d6                	call   *%esi
				num = -(long long) num;
  8018ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8018f5:	f7 da                	neg    %edx
  8018f7:	83 d1 00             	adc    $0x0,%ecx
  8018fa:	f7 d9                	neg    %ecx
  8018fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8018ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  801904:	e9 10 01 00 00       	jmp    801a19 <vprintfmt+0x3bb>
	else if (lflag)
  801909:	85 c9                	test   %ecx,%ecx
  80190b:	75 1b                	jne    801928 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801915:	89 c1                	mov    %eax,%ecx
  801917:	c1 f9 1f             	sar    $0x1f,%ecx
  80191a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	8d 40 04             	lea    0x4(%eax),%eax
  801923:	89 45 14             	mov    %eax,0x14(%ebp)
  801926:	eb b9                	jmp    8018e1 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801928:	8b 45 14             	mov    0x14(%ebp),%eax
  80192b:	8b 00                	mov    (%eax),%eax
  80192d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801930:	89 c1                	mov    %eax,%ecx
  801932:	c1 f9 1f             	sar    $0x1f,%ecx
  801935:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801938:	8b 45 14             	mov    0x14(%ebp),%eax
  80193b:	8d 40 04             	lea    0x4(%eax),%eax
  80193e:	89 45 14             	mov    %eax,0x14(%ebp)
  801941:	eb 9e                	jmp    8018e1 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801943:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801946:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801949:	b8 0a 00 00 00       	mov    $0xa,%eax
  80194e:	e9 c6 00 00 00       	jmp    801a19 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801953:	83 f9 01             	cmp    $0x1,%ecx
  801956:	7e 18                	jle    801970 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801958:	8b 45 14             	mov    0x14(%ebp),%eax
  80195b:	8b 10                	mov    (%eax),%edx
  80195d:	8b 48 04             	mov    0x4(%eax),%ecx
  801960:	8d 40 08             	lea    0x8(%eax),%eax
  801963:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801966:	b8 0a 00 00 00       	mov    $0xa,%eax
  80196b:	e9 a9 00 00 00       	jmp    801a19 <vprintfmt+0x3bb>
	else if (lflag)
  801970:	85 c9                	test   %ecx,%ecx
  801972:	75 1a                	jne    80198e <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  801974:	8b 45 14             	mov    0x14(%ebp),%eax
  801977:	8b 10                	mov    (%eax),%edx
  801979:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197e:	8d 40 04             	lea    0x4(%eax),%eax
  801981:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801984:	b8 0a 00 00 00       	mov    $0xa,%eax
  801989:	e9 8b 00 00 00       	jmp    801a19 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80198e:	8b 45 14             	mov    0x14(%ebp),%eax
  801991:	8b 10                	mov    (%eax),%edx
  801993:	b9 00 00 00 00       	mov    $0x0,%ecx
  801998:	8d 40 04             	lea    0x4(%eax),%eax
  80199b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80199e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a3:	eb 74                	jmp    801a19 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019a5:	83 f9 01             	cmp    $0x1,%ecx
  8019a8:	7e 15                	jle    8019bf <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ad:	8b 10                	mov    (%eax),%edx
  8019af:	8b 48 04             	mov    0x4(%eax),%ecx
  8019b2:	8d 40 08             	lea    0x8(%eax),%eax
  8019b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019bd:	eb 5a                	jmp    801a19 <vprintfmt+0x3bb>
	else if (lflag)
  8019bf:	85 c9                	test   %ecx,%ecx
  8019c1:	75 17                	jne    8019da <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c6:	8b 10                	mov    (%eax),%edx
  8019c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cd:	8d 40 04             	lea    0x4(%eax),%eax
  8019d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d8:	eb 3f                	jmp    801a19 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019da:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dd:	8b 10                	mov    (%eax),%edx
  8019df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e4:	8d 40 04             	lea    0x4(%eax),%eax
  8019e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ef:	eb 28                	jmp    801a19 <vprintfmt+0x3bb>
			putch('0', putdat);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	53                   	push   %ebx
  8019f5:	6a 30                	push   $0x30
  8019f7:	ff d6                	call   *%esi
			putch('x', putdat);
  8019f9:	83 c4 08             	add    $0x8,%esp
  8019fc:	53                   	push   %ebx
  8019fd:	6a 78                	push   $0x78
  8019ff:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a01:	8b 45 14             	mov    0x14(%ebp),%eax
  801a04:	8b 10                	mov    (%eax),%edx
  801a06:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a0b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a0e:	8d 40 04             	lea    0x4(%eax),%eax
  801a11:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a14:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a19:	83 ec 0c             	sub    $0xc,%esp
  801a1c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a20:	57                   	push   %edi
  801a21:	ff 75 e0             	pushl  -0x20(%ebp)
  801a24:	50                   	push   %eax
  801a25:	51                   	push   %ecx
  801a26:	52                   	push   %edx
  801a27:	89 da                	mov    %ebx,%edx
  801a29:	89 f0                	mov    %esi,%eax
  801a2b:	e8 45 fb ff ff       	call   801575 <printnum>
			break;
  801a30:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a33:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a36:	83 c7 01             	add    $0x1,%edi
  801a39:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a3d:	83 f8 25             	cmp    $0x25,%eax
  801a40:	0f 84 2f fc ff ff    	je     801675 <vprintfmt+0x17>
			if (ch == '\0')
  801a46:	85 c0                	test   %eax,%eax
  801a48:	0f 84 8b 00 00 00    	je     801ad9 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a4e:	83 ec 08             	sub    $0x8,%esp
  801a51:	53                   	push   %ebx
  801a52:	50                   	push   %eax
  801a53:	ff d6                	call   *%esi
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	eb dc                	jmp    801a36 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a5a:	83 f9 01             	cmp    $0x1,%ecx
  801a5d:	7e 15                	jle    801a74 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a62:	8b 10                	mov    (%eax),%edx
  801a64:	8b 48 04             	mov    0x4(%eax),%ecx
  801a67:	8d 40 08             	lea    0x8(%eax),%eax
  801a6a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a6d:	b8 10 00 00 00       	mov    $0x10,%eax
  801a72:	eb a5                	jmp    801a19 <vprintfmt+0x3bb>
	else if (lflag)
  801a74:	85 c9                	test   %ecx,%ecx
  801a76:	75 17                	jne    801a8f <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a78:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7b:	8b 10                	mov    (%eax),%edx
  801a7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a82:	8d 40 04             	lea    0x4(%eax),%eax
  801a85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a88:	b8 10 00 00 00       	mov    $0x10,%eax
  801a8d:	eb 8a                	jmp    801a19 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a92:	8b 10                	mov    (%eax),%edx
  801a94:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a99:	8d 40 04             	lea    0x4(%eax),%eax
  801a9c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a9f:	b8 10 00 00 00       	mov    $0x10,%eax
  801aa4:	e9 70 ff ff ff       	jmp    801a19 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	53                   	push   %ebx
  801aad:	6a 25                	push   $0x25
  801aaf:	ff d6                	call   *%esi
			break;
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	e9 7a ff ff ff       	jmp    801a33 <vprintfmt+0x3d5>
			putch('%', putdat);
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	53                   	push   %ebx
  801abd:	6a 25                	push   $0x25
  801abf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	89 f8                	mov    %edi,%eax
  801ac6:	eb 03                	jmp    801acb <vprintfmt+0x46d>
  801ac8:	83 e8 01             	sub    $0x1,%eax
  801acb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801acf:	75 f7                	jne    801ac8 <vprintfmt+0x46a>
  801ad1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ad4:	e9 5a ff ff ff       	jmp    801a33 <vprintfmt+0x3d5>
}
  801ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801adc:	5b                   	pop    %ebx
  801add:	5e                   	pop    %esi
  801ade:	5f                   	pop    %edi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    

00801ae1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 18             	sub    $0x18,%esp
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801af0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801af4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 26                	je     801b28 <vsnprintf+0x47>
  801b02:	85 d2                	test   %edx,%edx
  801b04:	7e 22                	jle    801b28 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b06:	ff 75 14             	pushl  0x14(%ebp)
  801b09:	ff 75 10             	pushl  0x10(%ebp)
  801b0c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b0f:	50                   	push   %eax
  801b10:	68 24 16 80 00       	push   $0x801624
  801b15:	e8 44 fb ff ff       	call   80165e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b23:	83 c4 10             	add    $0x10,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    
		return -E_INVAL;
  801b28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2d:	eb f7                	jmp    801b26 <vsnprintf+0x45>

00801b2f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b35:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b38:	50                   	push   %eax
  801b39:	ff 75 10             	pushl  0x10(%ebp)
  801b3c:	ff 75 0c             	pushl  0xc(%ebp)
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	e8 9a ff ff ff       	call   801ae1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b54:	eb 03                	jmp    801b59 <strlen+0x10>
		n++;
  801b56:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b59:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b5d:	75 f7                	jne    801b56 <strlen+0xd>
	return n;
}
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    

00801b61 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6f:	eb 03                	jmp    801b74 <strnlen+0x13>
		n++;
  801b71:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b74:	39 d0                	cmp    %edx,%eax
  801b76:	74 06                	je     801b7e <strnlen+0x1d>
  801b78:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801b7c:	75 f3                	jne    801b71 <strnlen+0x10>
	return n;
}
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    

00801b80 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b8a:	89 c2                	mov    %eax,%edx
  801b8c:	83 c1 01             	add    $0x1,%ecx
  801b8f:	83 c2 01             	add    $0x1,%edx
  801b92:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801b96:	88 5a ff             	mov    %bl,-0x1(%edx)
  801b99:	84 db                	test   %bl,%bl
  801b9b:	75 ef                	jne    801b8c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801b9d:	5b                   	pop    %ebx
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	53                   	push   %ebx
  801ba4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ba7:	53                   	push   %ebx
  801ba8:	e8 9c ff ff ff       	call   801b49 <strlen>
  801bad:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	01 d8                	add    %ebx,%eax
  801bb5:	50                   	push   %eax
  801bb6:	e8 c5 ff ff ff       	call   801b80 <strcpy>
	return dst;
}
  801bbb:	89 d8                	mov    %ebx,%eax
  801bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	8b 75 08             	mov    0x8(%ebp),%esi
  801bca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bcd:	89 f3                	mov    %esi,%ebx
  801bcf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bd2:	89 f2                	mov    %esi,%edx
  801bd4:	eb 0f                	jmp    801be5 <strncpy+0x23>
		*dst++ = *src;
  801bd6:	83 c2 01             	add    $0x1,%edx
  801bd9:	0f b6 01             	movzbl (%ecx),%eax
  801bdc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bdf:	80 39 01             	cmpb   $0x1,(%ecx)
  801be2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801be5:	39 da                	cmp    %ebx,%edx
  801be7:	75 ed                	jne    801bd6 <strncpy+0x14>
	}
	return ret;
}
  801be9:	89 f0                	mov    %esi,%eax
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    

00801bef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	8b 75 08             	mov    0x8(%ebp),%esi
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfd:	89 f0                	mov    %esi,%eax
  801bff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c03:	85 c9                	test   %ecx,%ecx
  801c05:	75 0b                	jne    801c12 <strlcpy+0x23>
  801c07:	eb 17                	jmp    801c20 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c09:	83 c2 01             	add    $0x1,%edx
  801c0c:	83 c0 01             	add    $0x1,%eax
  801c0f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c12:	39 d8                	cmp    %ebx,%eax
  801c14:	74 07                	je     801c1d <strlcpy+0x2e>
  801c16:	0f b6 0a             	movzbl (%edx),%ecx
  801c19:	84 c9                	test   %cl,%cl
  801c1b:	75 ec                	jne    801c09 <strlcpy+0x1a>
		*dst = '\0';
  801c1d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c20:	29 f0                	sub    %esi,%eax
}
  801c22:	5b                   	pop    %ebx
  801c23:	5e                   	pop    %esi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    

00801c26 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c2f:	eb 06                	jmp    801c37 <strcmp+0x11>
		p++, q++;
  801c31:	83 c1 01             	add    $0x1,%ecx
  801c34:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c37:	0f b6 01             	movzbl (%ecx),%eax
  801c3a:	84 c0                	test   %al,%al
  801c3c:	74 04                	je     801c42 <strcmp+0x1c>
  801c3e:	3a 02                	cmp    (%edx),%al
  801c40:	74 ef                	je     801c31 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c42:	0f b6 c0             	movzbl %al,%eax
  801c45:	0f b6 12             	movzbl (%edx),%edx
  801c48:	29 d0                	sub    %edx,%eax
}
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	53                   	push   %ebx
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	89 c3                	mov    %eax,%ebx
  801c58:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c5b:	eb 06                	jmp    801c63 <strncmp+0x17>
		n--, p++, q++;
  801c5d:	83 c0 01             	add    $0x1,%eax
  801c60:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c63:	39 d8                	cmp    %ebx,%eax
  801c65:	74 16                	je     801c7d <strncmp+0x31>
  801c67:	0f b6 08             	movzbl (%eax),%ecx
  801c6a:	84 c9                	test   %cl,%cl
  801c6c:	74 04                	je     801c72 <strncmp+0x26>
  801c6e:	3a 0a                	cmp    (%edx),%cl
  801c70:	74 eb                	je     801c5d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c72:	0f b6 00             	movzbl (%eax),%eax
  801c75:	0f b6 12             	movzbl (%edx),%edx
  801c78:	29 d0                	sub    %edx,%eax
}
  801c7a:	5b                   	pop    %ebx
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
		return 0;
  801c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c82:	eb f6                	jmp    801c7a <strncmp+0x2e>

00801c84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c8e:	0f b6 10             	movzbl (%eax),%edx
  801c91:	84 d2                	test   %dl,%dl
  801c93:	74 09                	je     801c9e <strchr+0x1a>
		if (*s == c)
  801c95:	38 ca                	cmp    %cl,%dl
  801c97:	74 0a                	je     801ca3 <strchr+0x1f>
	for (; *s; s++)
  801c99:	83 c0 01             	add    $0x1,%eax
  801c9c:	eb f0                	jmp    801c8e <strchr+0xa>
			return (char *) s;
	return 0;
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    

00801ca5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801caf:	eb 03                	jmp    801cb4 <strfind+0xf>
  801cb1:	83 c0 01             	add    $0x1,%eax
  801cb4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cb7:	38 ca                	cmp    %cl,%dl
  801cb9:	74 04                	je     801cbf <strfind+0x1a>
  801cbb:	84 d2                	test   %dl,%dl
  801cbd:	75 f2                	jne    801cb1 <strfind+0xc>
			break;
	return (char *) s;
}
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    

00801cc1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	57                   	push   %edi
  801cc5:	56                   	push   %esi
  801cc6:	53                   	push   %ebx
  801cc7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cca:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ccd:	85 c9                	test   %ecx,%ecx
  801ccf:	74 13                	je     801ce4 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cd1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801cd7:	75 05                	jne    801cde <memset+0x1d>
  801cd9:	f6 c1 03             	test   $0x3,%cl
  801cdc:	74 0d                	je     801ceb <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce1:	fc                   	cld    
  801ce2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ce4:	89 f8                	mov    %edi,%eax
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5f                   	pop    %edi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    
		c &= 0xFF;
  801ceb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cef:	89 d3                	mov    %edx,%ebx
  801cf1:	c1 e3 08             	shl    $0x8,%ebx
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	c1 e0 18             	shl    $0x18,%eax
  801cf9:	89 d6                	mov    %edx,%esi
  801cfb:	c1 e6 10             	shl    $0x10,%esi
  801cfe:	09 f0                	or     %esi,%eax
  801d00:	09 c2                	or     %eax,%edx
  801d02:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d04:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	fc                   	cld    
  801d0a:	f3 ab                	rep stos %eax,%es:(%edi)
  801d0c:	eb d6                	jmp    801ce4 <memset+0x23>

00801d0e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	57                   	push   %edi
  801d12:	56                   	push   %esi
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d19:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d1c:	39 c6                	cmp    %eax,%esi
  801d1e:	73 35                	jae    801d55 <memmove+0x47>
  801d20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d23:	39 c2                	cmp    %eax,%edx
  801d25:	76 2e                	jbe    801d55 <memmove+0x47>
		s += n;
		d += n;
  801d27:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d2a:	89 d6                	mov    %edx,%esi
  801d2c:	09 fe                	or     %edi,%esi
  801d2e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d34:	74 0c                	je     801d42 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d36:	83 ef 01             	sub    $0x1,%edi
  801d39:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d3c:	fd                   	std    
  801d3d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d3f:	fc                   	cld    
  801d40:	eb 21                	jmp    801d63 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d42:	f6 c1 03             	test   $0x3,%cl
  801d45:	75 ef                	jne    801d36 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d47:	83 ef 04             	sub    $0x4,%edi
  801d4a:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d4d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d50:	fd                   	std    
  801d51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d53:	eb ea                	jmp    801d3f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d55:	89 f2                	mov    %esi,%edx
  801d57:	09 c2                	or     %eax,%edx
  801d59:	f6 c2 03             	test   $0x3,%dl
  801d5c:	74 09                	je     801d67 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d5e:	89 c7                	mov    %eax,%edi
  801d60:	fc                   	cld    
  801d61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d63:	5e                   	pop    %esi
  801d64:	5f                   	pop    %edi
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d67:	f6 c1 03             	test   $0x3,%cl
  801d6a:	75 f2                	jne    801d5e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d6c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d6f:	89 c7                	mov    %eax,%edi
  801d71:	fc                   	cld    
  801d72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d74:	eb ed                	jmp    801d63 <memmove+0x55>

00801d76 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801d79:	ff 75 10             	pushl  0x10(%ebp)
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	e8 87 ff ff ff       	call   801d0e <memmove>
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	89 c6                	mov    %eax,%esi
  801d96:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d99:	39 f0                	cmp    %esi,%eax
  801d9b:	74 1c                	je     801db9 <memcmp+0x30>
		if (*s1 != *s2)
  801d9d:	0f b6 08             	movzbl (%eax),%ecx
  801da0:	0f b6 1a             	movzbl (%edx),%ebx
  801da3:	38 d9                	cmp    %bl,%cl
  801da5:	75 08                	jne    801daf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801da7:	83 c0 01             	add    $0x1,%eax
  801daa:	83 c2 01             	add    $0x1,%edx
  801dad:	eb ea                	jmp    801d99 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801daf:	0f b6 c1             	movzbl %cl,%eax
  801db2:	0f b6 db             	movzbl %bl,%ebx
  801db5:	29 d8                	sub    %ebx,%eax
  801db7:	eb 05                	jmp    801dbe <memcmp+0x35>
	}

	return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	5b                   	pop    %ebx
  801dbf:	5e                   	pop    %esi
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    

00801dc2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dcb:	89 c2                	mov    %eax,%edx
  801dcd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dd0:	39 d0                	cmp    %edx,%eax
  801dd2:	73 09                	jae    801ddd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd4:	38 08                	cmp    %cl,(%eax)
  801dd6:	74 05                	je     801ddd <memfind+0x1b>
	for (; s < ends; s++)
  801dd8:	83 c0 01             	add    $0x1,%eax
  801ddb:	eb f3                	jmp    801dd0 <memfind+0xe>
			break;
	return (void *) s;
}
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    

00801ddf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	57                   	push   %edi
  801de3:	56                   	push   %esi
  801de4:	53                   	push   %ebx
  801de5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801deb:	eb 03                	jmp    801df0 <strtol+0x11>
		s++;
  801ded:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801df0:	0f b6 01             	movzbl (%ecx),%eax
  801df3:	3c 20                	cmp    $0x20,%al
  801df5:	74 f6                	je     801ded <strtol+0xe>
  801df7:	3c 09                	cmp    $0x9,%al
  801df9:	74 f2                	je     801ded <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801dfb:	3c 2b                	cmp    $0x2b,%al
  801dfd:	74 2e                	je     801e2d <strtol+0x4e>
	int neg = 0;
  801dff:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e04:	3c 2d                	cmp    $0x2d,%al
  801e06:	74 2f                	je     801e37 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e08:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e0e:	75 05                	jne    801e15 <strtol+0x36>
  801e10:	80 39 30             	cmpb   $0x30,(%ecx)
  801e13:	74 2c                	je     801e41 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e15:	85 db                	test   %ebx,%ebx
  801e17:	75 0a                	jne    801e23 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e19:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e1e:	80 39 30             	cmpb   $0x30,(%ecx)
  801e21:	74 28                	je     801e4b <strtol+0x6c>
		base = 10;
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e2b:	eb 50                	jmp    801e7d <strtol+0x9e>
		s++;
  801e2d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e30:	bf 00 00 00 00       	mov    $0x0,%edi
  801e35:	eb d1                	jmp    801e08 <strtol+0x29>
		s++, neg = 1;
  801e37:	83 c1 01             	add    $0x1,%ecx
  801e3a:	bf 01 00 00 00       	mov    $0x1,%edi
  801e3f:	eb c7                	jmp    801e08 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e41:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e45:	74 0e                	je     801e55 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e47:	85 db                	test   %ebx,%ebx
  801e49:	75 d8                	jne    801e23 <strtol+0x44>
		s++, base = 8;
  801e4b:	83 c1 01             	add    $0x1,%ecx
  801e4e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e53:	eb ce                	jmp    801e23 <strtol+0x44>
		s += 2, base = 16;
  801e55:	83 c1 02             	add    $0x2,%ecx
  801e58:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e5d:	eb c4                	jmp    801e23 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e5f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e62:	89 f3                	mov    %esi,%ebx
  801e64:	80 fb 19             	cmp    $0x19,%bl
  801e67:	77 29                	ja     801e92 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e69:	0f be d2             	movsbl %dl,%edx
  801e6c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e6f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e72:	7d 30                	jge    801ea4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e74:	83 c1 01             	add    $0x1,%ecx
  801e77:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e7b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e7d:	0f b6 11             	movzbl (%ecx),%edx
  801e80:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e83:	89 f3                	mov    %esi,%ebx
  801e85:	80 fb 09             	cmp    $0x9,%bl
  801e88:	77 d5                	ja     801e5f <strtol+0x80>
			dig = *s - '0';
  801e8a:	0f be d2             	movsbl %dl,%edx
  801e8d:	83 ea 30             	sub    $0x30,%edx
  801e90:	eb dd                	jmp    801e6f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801e92:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e95:	89 f3                	mov    %esi,%ebx
  801e97:	80 fb 19             	cmp    $0x19,%bl
  801e9a:	77 08                	ja     801ea4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801e9c:	0f be d2             	movsbl %dl,%edx
  801e9f:	83 ea 37             	sub    $0x37,%edx
  801ea2:	eb cb                	jmp    801e6f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ea4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea8:	74 05                	je     801eaf <strtol+0xd0>
		*endptr = (char *) s;
  801eaa:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ead:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eaf:	89 c2                	mov    %eax,%edx
  801eb1:	f7 da                	neg    %edx
  801eb3:	85 ff                	test   %edi,%edi
  801eb5:	0f 45 c2             	cmovne %edx,%eax
}
  801eb8:	5b                   	pop    %ebx
  801eb9:	5e                   	pop    %esi
  801eba:	5f                   	pop    %edi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    

00801ebd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	56                   	push   %esi
  801ec1:	53                   	push   %ebx
  801ec2:	8b 75 08             	mov    0x8(%ebp),%esi
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801ecb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ecd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ed2:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	50                   	push   %eax
  801ed9:	e8 28 e4 ff ff       	call   800306 <sys_ipc_recv>
	if (from_env_store)
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	85 f6                	test   %esi,%esi
  801ee3:	74 14                	je     801ef9 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801ee5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 09                	js     801ef7 <ipc_recv+0x3a>
  801eee:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ef4:	8b 52 74             	mov    0x74(%edx),%edx
  801ef7:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801ef9:	85 db                	test   %ebx,%ebx
  801efb:	74 14                	je     801f11 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801efd:	ba 00 00 00 00       	mov    $0x0,%edx
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 09                	js     801f0f <ipc_recv+0x52>
  801f06:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f0c:	8b 52 78             	mov    0x78(%edx),%edx
  801f0f:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f11:	85 c0                	test   %eax,%eax
  801f13:	78 08                	js     801f1d <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f15:	a1 08 40 80 00       	mov    0x804008,%eax
  801f1a:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    

00801f24 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	57                   	push   %edi
  801f28:	56                   	push   %esi
  801f29:	53                   	push   %ebx
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f30:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f36:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f38:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f3d:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f40:	ff 75 14             	pushl  0x14(%ebp)
  801f43:	53                   	push   %ebx
  801f44:	56                   	push   %esi
  801f45:	57                   	push   %edi
  801f46:	e8 98 e3 ff ff       	call   8002e3 <sys_ipc_try_send>
		if (ret == 0)
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	74 1e                	je     801f70 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f52:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f55:	75 07                	jne    801f5e <ipc_send+0x3a>
			sys_yield();
  801f57:	e8 db e1 ff ff       	call   800137 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f5c:	eb e2                	jmp    801f40 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f5e:	50                   	push   %eax
  801f5f:	68 c0 26 80 00       	push   $0x8026c0
  801f64:	6a 3d                	push   $0x3d
  801f66:	68 d4 26 80 00       	push   $0x8026d4
  801f6b:	e8 16 f5 ff ff       	call   801486 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f73:	5b                   	pop    %ebx
  801f74:	5e                   	pop    %esi
  801f75:	5f                   	pop    %edi
  801f76:	5d                   	pop    %ebp
  801f77:	c3                   	ret    

00801f78 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f83:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f86:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f8c:	8b 52 50             	mov    0x50(%edx),%edx
  801f8f:	39 ca                	cmp    %ecx,%edx
  801f91:	74 11                	je     801fa4 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801f93:	83 c0 01             	add    $0x1,%eax
  801f96:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f9b:	75 e6                	jne    801f83 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa2:	eb 0b                	jmp    801faf <ipc_find_env+0x37>
			return envs[i].env_id;
  801fa4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fa7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fac:	8b 40 48             	mov    0x48(%eax),%eax
}
  801faf:	5d                   	pop    %ebp
  801fb0:	c3                   	ret    

00801fb1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fb7:	89 d0                	mov    %edx,%eax
  801fb9:	c1 e8 16             	shr    $0x16,%eax
  801fbc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fc8:	f6 c1 01             	test   $0x1,%cl
  801fcb:	74 1d                	je     801fea <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fcd:	c1 ea 0c             	shr    $0xc,%edx
  801fd0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fd7:	f6 c2 01             	test   $0x1,%dl
  801fda:	74 0e                	je     801fea <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fdc:	c1 ea 0c             	shr    $0xc,%edx
  801fdf:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fe6:	ef 
  801fe7:	0f b7 c0             	movzwl %ax,%eax
}
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    
  801fec:	66 90                	xchg   %ax,%ax
  801fee:	66 90                	xchg   %ax,%ax

00801ff0 <__udivdi3>:
  801ff0:	55                   	push   %ebp
  801ff1:	57                   	push   %edi
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 1c             	sub    $0x1c,%esp
  801ff7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801ffb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801fff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802003:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802007:	85 d2                	test   %edx,%edx
  802009:	75 35                	jne    802040 <__udivdi3+0x50>
  80200b:	39 f3                	cmp    %esi,%ebx
  80200d:	0f 87 bd 00 00 00    	ja     8020d0 <__udivdi3+0xe0>
  802013:	85 db                	test   %ebx,%ebx
  802015:	89 d9                	mov    %ebx,%ecx
  802017:	75 0b                	jne    802024 <__udivdi3+0x34>
  802019:	b8 01 00 00 00       	mov    $0x1,%eax
  80201e:	31 d2                	xor    %edx,%edx
  802020:	f7 f3                	div    %ebx
  802022:	89 c1                	mov    %eax,%ecx
  802024:	31 d2                	xor    %edx,%edx
  802026:	89 f0                	mov    %esi,%eax
  802028:	f7 f1                	div    %ecx
  80202a:	89 c6                	mov    %eax,%esi
  80202c:	89 e8                	mov    %ebp,%eax
  80202e:	89 f7                	mov    %esi,%edi
  802030:	f7 f1                	div    %ecx
  802032:	89 fa                	mov    %edi,%edx
  802034:	83 c4 1c             	add    $0x1c,%esp
  802037:	5b                   	pop    %ebx
  802038:	5e                   	pop    %esi
  802039:	5f                   	pop    %edi
  80203a:	5d                   	pop    %ebp
  80203b:	c3                   	ret    
  80203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802040:	39 f2                	cmp    %esi,%edx
  802042:	77 7c                	ja     8020c0 <__udivdi3+0xd0>
  802044:	0f bd fa             	bsr    %edx,%edi
  802047:	83 f7 1f             	xor    $0x1f,%edi
  80204a:	0f 84 98 00 00 00    	je     8020e8 <__udivdi3+0xf8>
  802050:	89 f9                	mov    %edi,%ecx
  802052:	b8 20 00 00 00       	mov    $0x20,%eax
  802057:	29 f8                	sub    %edi,%eax
  802059:	d3 e2                	shl    %cl,%edx
  80205b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80205f:	89 c1                	mov    %eax,%ecx
  802061:	89 da                	mov    %ebx,%edx
  802063:	d3 ea                	shr    %cl,%edx
  802065:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802069:	09 d1                	or     %edx,%ecx
  80206b:	89 f2                	mov    %esi,%edx
  80206d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802071:	89 f9                	mov    %edi,%ecx
  802073:	d3 e3                	shl    %cl,%ebx
  802075:	89 c1                	mov    %eax,%ecx
  802077:	d3 ea                	shr    %cl,%edx
  802079:	89 f9                	mov    %edi,%ecx
  80207b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80207f:	d3 e6                	shl    %cl,%esi
  802081:	89 eb                	mov    %ebp,%ebx
  802083:	89 c1                	mov    %eax,%ecx
  802085:	d3 eb                	shr    %cl,%ebx
  802087:	09 de                	or     %ebx,%esi
  802089:	89 f0                	mov    %esi,%eax
  80208b:	f7 74 24 08          	divl   0x8(%esp)
  80208f:	89 d6                	mov    %edx,%esi
  802091:	89 c3                	mov    %eax,%ebx
  802093:	f7 64 24 0c          	mull   0xc(%esp)
  802097:	39 d6                	cmp    %edx,%esi
  802099:	72 0c                	jb     8020a7 <__udivdi3+0xb7>
  80209b:	89 f9                	mov    %edi,%ecx
  80209d:	d3 e5                	shl    %cl,%ebp
  80209f:	39 c5                	cmp    %eax,%ebp
  8020a1:	73 5d                	jae    802100 <__udivdi3+0x110>
  8020a3:	39 d6                	cmp    %edx,%esi
  8020a5:	75 59                	jne    802100 <__udivdi3+0x110>
  8020a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020aa:	31 ff                	xor    %edi,%edi
  8020ac:	89 fa                	mov    %edi,%edx
  8020ae:	83 c4 1c             	add    $0x1c,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	8d 76 00             	lea    0x0(%esi),%esi
  8020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8020c0:	31 ff                	xor    %edi,%edi
  8020c2:	31 c0                	xor    %eax,%eax
  8020c4:	89 fa                	mov    %edi,%edx
  8020c6:	83 c4 1c             	add    $0x1c,%esp
  8020c9:	5b                   	pop    %ebx
  8020ca:	5e                   	pop    %esi
  8020cb:	5f                   	pop    %edi
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    
  8020ce:	66 90                	xchg   %ax,%ax
  8020d0:	31 ff                	xor    %edi,%edi
  8020d2:	89 e8                	mov    %ebp,%eax
  8020d4:	89 f2                	mov    %esi,%edx
  8020d6:	f7 f3                	div    %ebx
  8020d8:	89 fa                	mov    %edi,%edx
  8020da:	83 c4 1c             	add    $0x1c,%esp
  8020dd:	5b                   	pop    %ebx
  8020de:	5e                   	pop    %esi
  8020df:	5f                   	pop    %edi
  8020e0:	5d                   	pop    %ebp
  8020e1:	c3                   	ret    
  8020e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020e8:	39 f2                	cmp    %esi,%edx
  8020ea:	72 06                	jb     8020f2 <__udivdi3+0x102>
  8020ec:	31 c0                	xor    %eax,%eax
  8020ee:	39 eb                	cmp    %ebp,%ebx
  8020f0:	77 d2                	ja     8020c4 <__udivdi3+0xd4>
  8020f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f7:	eb cb                	jmp    8020c4 <__udivdi3+0xd4>
  8020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802100:	89 d8                	mov    %ebx,%eax
  802102:	31 ff                	xor    %edi,%edi
  802104:	eb be                	jmp    8020c4 <__udivdi3+0xd4>
  802106:	66 90                	xchg   %ax,%ax
  802108:	66 90                	xchg   %ax,%ax
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	66 90                	xchg   %ax,%ax
  80210e:	66 90                	xchg   %ax,%ax

00802110 <__umoddi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 1c             	sub    $0x1c,%esp
  802117:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80211b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80211f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802127:	85 ed                	test   %ebp,%ebp
  802129:	89 f0                	mov    %esi,%eax
  80212b:	89 da                	mov    %ebx,%edx
  80212d:	75 19                	jne    802148 <__umoddi3+0x38>
  80212f:	39 df                	cmp    %ebx,%edi
  802131:	0f 86 b1 00 00 00    	jbe    8021e8 <__umoddi3+0xd8>
  802137:	f7 f7                	div    %edi
  802139:	89 d0                	mov    %edx,%eax
  80213b:	31 d2                	xor    %edx,%edx
  80213d:	83 c4 1c             	add    $0x1c,%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5f                   	pop    %edi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    
  802145:	8d 76 00             	lea    0x0(%esi),%esi
  802148:	39 dd                	cmp    %ebx,%ebp
  80214a:	77 f1                	ja     80213d <__umoddi3+0x2d>
  80214c:	0f bd cd             	bsr    %ebp,%ecx
  80214f:	83 f1 1f             	xor    $0x1f,%ecx
  802152:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802156:	0f 84 b4 00 00 00    	je     802210 <__umoddi3+0x100>
  80215c:	b8 20 00 00 00       	mov    $0x20,%eax
  802161:	89 c2                	mov    %eax,%edx
  802163:	8b 44 24 04          	mov    0x4(%esp),%eax
  802167:	29 c2                	sub    %eax,%edx
  802169:	89 c1                	mov    %eax,%ecx
  80216b:	89 f8                	mov    %edi,%eax
  80216d:	d3 e5                	shl    %cl,%ebp
  80216f:	89 d1                	mov    %edx,%ecx
  802171:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802175:	d3 e8                	shr    %cl,%eax
  802177:	09 c5                	or     %eax,%ebp
  802179:	8b 44 24 04          	mov    0x4(%esp),%eax
  80217d:	89 c1                	mov    %eax,%ecx
  80217f:	d3 e7                	shl    %cl,%edi
  802181:	89 d1                	mov    %edx,%ecx
  802183:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802187:	89 df                	mov    %ebx,%edi
  802189:	d3 ef                	shr    %cl,%edi
  80218b:	89 c1                	mov    %eax,%ecx
  80218d:	89 f0                	mov    %esi,%eax
  80218f:	d3 e3                	shl    %cl,%ebx
  802191:	89 d1                	mov    %edx,%ecx
  802193:	89 fa                	mov    %edi,%edx
  802195:	d3 e8                	shr    %cl,%eax
  802197:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80219c:	09 d8                	or     %ebx,%eax
  80219e:	f7 f5                	div    %ebp
  8021a0:	d3 e6                	shl    %cl,%esi
  8021a2:	89 d1                	mov    %edx,%ecx
  8021a4:	f7 64 24 08          	mull   0x8(%esp)
  8021a8:	39 d1                	cmp    %edx,%ecx
  8021aa:	89 c3                	mov    %eax,%ebx
  8021ac:	89 d7                	mov    %edx,%edi
  8021ae:	72 06                	jb     8021b6 <__umoddi3+0xa6>
  8021b0:	75 0e                	jne    8021c0 <__umoddi3+0xb0>
  8021b2:	39 c6                	cmp    %eax,%esi
  8021b4:	73 0a                	jae    8021c0 <__umoddi3+0xb0>
  8021b6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8021ba:	19 ea                	sbb    %ebp,%edx
  8021bc:	89 d7                	mov    %edx,%edi
  8021be:	89 c3                	mov    %eax,%ebx
  8021c0:	89 ca                	mov    %ecx,%edx
  8021c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8021c7:	29 de                	sub    %ebx,%esi
  8021c9:	19 fa                	sbb    %edi,%edx
  8021cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021cf:	89 d0                	mov    %edx,%eax
  8021d1:	d3 e0                	shl    %cl,%eax
  8021d3:	89 d9                	mov    %ebx,%ecx
  8021d5:	d3 ee                	shr    %cl,%esi
  8021d7:	d3 ea                	shr    %cl,%edx
  8021d9:	09 f0                	or     %esi,%eax
  8021db:	83 c4 1c             	add    $0x1c,%esp
  8021de:	5b                   	pop    %ebx
  8021df:	5e                   	pop    %esi
  8021e0:	5f                   	pop    %edi
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    
  8021e3:	90                   	nop
  8021e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021e8:	85 ff                	test   %edi,%edi
  8021ea:	89 f9                	mov    %edi,%ecx
  8021ec:	75 0b                	jne    8021f9 <__umoddi3+0xe9>
  8021ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f3:	31 d2                	xor    %edx,%edx
  8021f5:	f7 f7                	div    %edi
  8021f7:	89 c1                	mov    %eax,%ecx
  8021f9:	89 d8                	mov    %ebx,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	f7 f1                	div    %ecx
  8021ff:	89 f0                	mov    %esi,%eax
  802201:	f7 f1                	div    %ecx
  802203:	e9 31 ff ff ff       	jmp    802139 <__umoddi3+0x29>
  802208:	90                   	nop
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	39 dd                	cmp    %ebx,%ebp
  802212:	72 08                	jb     80221c <__umoddi3+0x10c>
  802214:	39 f7                	cmp    %esi,%edi
  802216:	0f 87 21 ff ff ff    	ja     80213d <__umoddi3+0x2d>
  80221c:	89 da                	mov    %ebx,%edx
  80221e:	89 f0                	mov    %esi,%eax
  802220:	29 f8                	sub    %edi,%eax
  802222:	19 ea                	sbb    %ebp,%edx
  802224:	e9 14 ff ff ff       	jmp    80213d <__umoddi3+0x2d>

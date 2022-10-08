
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800041:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800044:	e8 ce 00 00 00       	call   800117 <sys_getenvid>
  800049:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800051:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800056:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005b:	85 db                	test   %ebx,%ebx
  80005d:	7e 07                	jle    800066 <libmain+0x2d>
		binaryname = argv[0];
  80005f:	8b 06                	mov    (%esi),%eax
  800061:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	e8 c3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800070:	e8 0a 00 00 00       	call   80007f <exit>
}
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007b:	5b                   	pop    %ebx
  80007c:	5e                   	pop    %esi
  80007d:	5d                   	pop    %ebp
  80007e:	c3                   	ret    

0080007f <exit>:

#include <inc/lib.h>

void exit(void)
{
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800085:	e8 b1 04 00 00       	call   80053b <close_all>
	sys_env_destroy(0);
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	e8 42 00 00 00       	call   8000d6 <sys_env_destroy>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	c9                   	leave  
  800098:	c3                   	ret    

00800099 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	57                   	push   %edi
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000aa:	89 c3                	mov    %eax,%ebx
  8000ac:	89 c7                	mov    %eax,%edi
  8000ae:	89 c6                	mov    %eax,%esi
  8000b0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b2:	5b                   	pop    %ebx
  8000b3:	5e                   	pop    %esi
  8000b4:	5f                   	pop    %edi
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    

008000b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c7:	89 d1                	mov    %edx,%ecx
  8000c9:	89 d3                	mov    %edx,%ebx
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	89 d6                	mov    %edx,%esi
  8000cf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5f                   	pop    %edi
  8000d4:	5d                   	pop    %ebp
  8000d5:	c3                   	ret    

008000d6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	57                   	push   %edi
  8000da:	56                   	push   %esi
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ec:	89 cb                	mov    %ecx,%ebx
  8000ee:	89 cf                	mov    %ecx,%edi
  8000f0:	89 ce                	mov    %ecx,%esi
  8000f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	7f 08                	jg     800100 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5f                   	pop    %edi
  8000fe:	5d                   	pop    %ebp
  8000ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	50                   	push   %eax
  800104:	6a 03                	push   $0x3
  800106:	68 4a 22 80 00       	push   $0x80224a
  80010b:	6a 23                	push   $0x23
  80010d:	68 67 22 80 00       	push   $0x802267
  800112:	e8 6e 13 00 00       	call   801485 <_panic>

00800117 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011d:	ba 00 00 00 00       	mov    $0x0,%edx
  800122:	b8 02 00 00 00       	mov    $0x2,%eax
  800127:	89 d1                	mov    %edx,%ecx
  800129:	89 d3                	mov    %edx,%ebx
  80012b:	89 d7                	mov    %edx,%edi
  80012d:	89 d6                	mov    %edx,%esi
  80012f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <sys_yield>:

void
sys_yield(void)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	57                   	push   %edi
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013c:	ba 00 00 00 00       	mov    $0x0,%edx
  800141:	b8 0b 00 00 00       	mov    $0xb,%eax
  800146:	89 d1                	mov    %edx,%ecx
  800148:	89 d3                	mov    %edx,%ebx
  80014a:	89 d7                	mov    %edx,%edi
  80014c:	89 d6                	mov    %edx,%esi
  80014e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	57                   	push   %edi
  800159:	56                   	push   %esi
  80015a:	53                   	push   %ebx
  80015b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015e:	be 00 00 00 00       	mov    $0x0,%esi
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
  800166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800169:	b8 04 00 00 00       	mov    $0x4,%eax
  80016e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800171:	89 f7                	mov    %esi,%edi
  800173:	cd 30                	int    $0x30
	if(check && ret > 0)
  800175:	85 c0                	test   %eax,%eax
  800177:	7f 08                	jg     800181 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	6a 04                	push   $0x4
  800187:	68 4a 22 80 00       	push   $0x80224a
  80018c:	6a 23                	push   $0x23
  80018e:	68 67 22 80 00       	push   $0x802267
  800193:	e8 ed 12 00 00       	call   801485 <_panic>

00800198 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
  80019e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	7f 08                	jg     8001c3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5e                   	pop    %esi
  8001c0:	5f                   	pop    %edi
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	50                   	push   %eax
  8001c7:	6a 05                	push   $0x5
  8001c9:	68 4a 22 80 00       	push   $0x80224a
  8001ce:	6a 23                	push   $0x23
  8001d0:	68 67 22 80 00       	push   $0x802267
  8001d5:	e8 ab 12 00 00       	call   801485 <_panic>

008001da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	57                   	push   %edi
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f3:	89 df                	mov    %ebx,%edi
  8001f5:	89 de                	mov    %ebx,%esi
  8001f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f9:	85 c0                	test   %eax,%eax
  8001fb:	7f 08                	jg     800205 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800200:	5b                   	pop    %ebx
  800201:	5e                   	pop    %esi
  800202:	5f                   	pop    %edi
  800203:	5d                   	pop    %ebp
  800204:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	50                   	push   %eax
  800209:	6a 06                	push   $0x6
  80020b:	68 4a 22 80 00       	push   $0x80224a
  800210:	6a 23                	push   $0x23
  800212:	68 67 22 80 00       	push   $0x802267
  800217:	e8 69 12 00 00       	call   801485 <_panic>

0080021c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	57                   	push   %edi
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	8b 55 08             	mov    0x8(%ebp),%edx
  80022d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800230:	b8 08 00 00 00       	mov    $0x8,%eax
  800235:	89 df                	mov    %ebx,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023b:	85 c0                	test   %eax,%eax
  80023d:	7f 08                	jg     800247 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800242:	5b                   	pop    %ebx
  800243:	5e                   	pop    %esi
  800244:	5f                   	pop    %edi
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	50                   	push   %eax
  80024b:	6a 08                	push   $0x8
  80024d:	68 4a 22 80 00       	push   $0x80224a
  800252:	6a 23                	push   $0x23
  800254:	68 67 22 80 00       	push   $0x802267
  800259:	e8 27 12 00 00       	call   801485 <_panic>

0080025e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	57                   	push   %edi
  800262:	56                   	push   %esi
  800263:	53                   	push   %ebx
  800264:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800267:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026c:	8b 55 08             	mov    0x8(%ebp),%edx
  80026f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800272:	b8 09 00 00 00       	mov    $0x9,%eax
  800277:	89 df                	mov    %ebx,%edi
  800279:	89 de                	mov    %ebx,%esi
  80027b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027d:	85 c0                	test   %eax,%eax
  80027f:	7f 08                	jg     800289 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	50                   	push   %eax
  80028d:	6a 09                	push   $0x9
  80028f:	68 4a 22 80 00       	push   $0x80224a
  800294:	6a 23                	push   $0x23
  800296:	68 67 22 80 00       	push   $0x802267
  80029b:	e8 e5 11 00 00       	call   801485 <_panic>

008002a0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b9:	89 df                	mov    %ebx,%edi
  8002bb:	89 de                	mov    %ebx,%esi
  8002bd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	7f 08                	jg     8002cb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	6a 0a                	push   $0xa
  8002d1:	68 4a 22 80 00       	push   $0x80224a
  8002d6:	6a 23                	push   $0x23
  8002d8:	68 67 22 80 00       	push   $0x802267
  8002dd:	e8 a3 11 00 00       	call   801485 <_panic>

008002e2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	57                   	push   %edi
  8002e6:	56                   	push   %esi
  8002e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ee:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f3:	be 00 00 00 00       	mov    $0x0,%esi
  8002f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800313:	8b 55 08             	mov    0x8(%ebp),%edx
  800316:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031b:	89 cb                	mov    %ecx,%ebx
  80031d:	89 cf                	mov    %ecx,%edi
  80031f:	89 ce                	mov    %ecx,%esi
  800321:	cd 30                	int    $0x30
	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7f 08                	jg     80032f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 0d                	push   $0xd
  800335:	68 4a 22 80 00       	push   $0x80224a
  80033a:	6a 23                	push   $0x23
  80033c:	68 67 22 80 00       	push   $0x802267
  800341:	e8 3f 11 00 00       	call   801485 <_panic>

00800346 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034c:	ba 00 00 00 00       	mov    $0x0,%edx
  800351:	b8 0e 00 00 00       	mov    $0xe,%eax
  800356:	89 d1                	mov    %edx,%ecx
  800358:	89 d3                	mov    %edx,%ebx
  80035a:	89 d7                	mov    %edx,%edi
  80035c:	89 d6                	mov    %edx,%esi
  80035e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800360:	5b                   	pop    %ebx
  800361:	5e                   	pop    %esi
  800362:	5f                   	pop    %edi
  800363:	5d                   	pop    %ebp
  800364:	c3                   	ret    

00800365 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	05 00 00 00 30       	add    $0x30000000,%eax
  800370:	c1 e8 0c             	shr    $0xc,%eax
}
  800373:	5d                   	pop    %ebp
  800374:	c3                   	ret    

00800375 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800380:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800385:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038a:	5d                   	pop    %ebp
  80038b:	c3                   	ret    

0080038c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800392:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800397:	89 c2                	mov    %eax,%edx
  800399:	c1 ea 16             	shr    $0x16,%edx
  80039c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a3:	f6 c2 01             	test   $0x1,%dl
  8003a6:	74 2a                	je     8003d2 <fd_alloc+0x46>
  8003a8:	89 c2                	mov    %eax,%edx
  8003aa:	c1 ea 0c             	shr    $0xc,%edx
  8003ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b4:	f6 c2 01             	test   $0x1,%dl
  8003b7:	74 19                	je     8003d2 <fd_alloc+0x46>
  8003b9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003be:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c3:	75 d2                	jne    800397 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003c5:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003cb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d0:	eb 07                	jmp    8003d9 <fd_alloc+0x4d>
			*fd_store = fd;
  8003d2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e1:	83 f8 1f             	cmp    $0x1f,%eax
  8003e4:	77 36                	ja     80041c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003e6:	c1 e0 0c             	shl    $0xc,%eax
  8003e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ee:	89 c2                	mov    %eax,%edx
  8003f0:	c1 ea 16             	shr    $0x16,%edx
  8003f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003fa:	f6 c2 01             	test   $0x1,%dl
  8003fd:	74 24                	je     800423 <fd_lookup+0x48>
  8003ff:	89 c2                	mov    %eax,%edx
  800401:	c1 ea 0c             	shr    $0xc,%edx
  800404:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80040b:	f6 c2 01             	test   $0x1,%dl
  80040e:	74 1a                	je     80042a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800410:	8b 55 0c             	mov    0xc(%ebp),%edx
  800413:	89 02                	mov    %eax,(%edx)
	return 0;
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    
		return -E_INVAL;
  80041c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800421:	eb f7                	jmp    80041a <fd_lookup+0x3f>
		return -E_INVAL;
  800423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800428:	eb f0                	jmp    80041a <fd_lookup+0x3f>
  80042a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042f:	eb e9                	jmp    80041a <fd_lookup+0x3f>

00800431 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043a:	ba f4 22 80 00       	mov    $0x8022f4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80043f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800444:	39 08                	cmp    %ecx,(%eax)
  800446:	74 33                	je     80047b <dev_lookup+0x4a>
  800448:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80044b:	8b 02                	mov    (%edx),%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 f3                	jne    800444 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800451:	a1 08 40 80 00       	mov    0x804008,%eax
  800456:	8b 40 48             	mov    0x48(%eax),%eax
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	51                   	push   %ecx
  80045d:	50                   	push   %eax
  80045e:	68 78 22 80 00       	push   $0x802278
  800463:	e8 f8 10 00 00       	call   801560 <cprintf>
	*dev = 0;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800479:	c9                   	leave  
  80047a:	c3                   	ret    
			*dev = devtab[i];
  80047b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800480:	b8 00 00 00 00       	mov    $0x0,%eax
  800485:	eb f2                	jmp    800479 <dev_lookup+0x48>

00800487 <fd_close>:
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	57                   	push   %edi
  80048b:	56                   	push   %esi
  80048c:	53                   	push   %ebx
  80048d:	83 ec 1c             	sub    $0x1c,%esp
  800490:	8b 75 08             	mov    0x8(%ebp),%esi
  800493:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800496:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800499:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80049a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a3:	50                   	push   %eax
  8004a4:	e8 32 ff ff ff       	call   8003db <fd_lookup>
  8004a9:	89 c3                	mov    %eax,%ebx
  8004ab:	83 c4 08             	add    $0x8,%esp
  8004ae:	85 c0                	test   %eax,%eax
  8004b0:	78 05                	js     8004b7 <fd_close+0x30>
	    || fd != fd2)
  8004b2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004b5:	74 16                	je     8004cd <fd_close+0x46>
		return (must_exist ? r : 0);
  8004b7:	89 f8                	mov    %edi,%eax
  8004b9:	84 c0                	test   %al,%al
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c0:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c3:	89 d8                	mov    %ebx,%eax
  8004c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c8:	5b                   	pop    %ebx
  8004c9:	5e                   	pop    %esi
  8004ca:	5f                   	pop    %edi
  8004cb:	5d                   	pop    %ebp
  8004cc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d3:	50                   	push   %eax
  8004d4:	ff 36                	pushl  (%esi)
  8004d6:	e8 56 ff ff ff       	call   800431 <dev_lookup>
  8004db:	89 c3                	mov    %eax,%ebx
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 c0                	test   %eax,%eax
  8004e2:	78 15                	js     8004f9 <fd_close+0x72>
		if (dev->dev_close)
  8004e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e7:	8b 40 10             	mov    0x10(%eax),%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 1b                	je     800509 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	56                   	push   %esi
  8004f2:	ff d0                	call   *%eax
  8004f4:	89 c3                	mov    %eax,%ebx
  8004f6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	56                   	push   %esi
  8004fd:	6a 00                	push   $0x0
  8004ff:	e8 d6 fc ff ff       	call   8001da <sys_page_unmap>
	return r;
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	eb ba                	jmp    8004c3 <fd_close+0x3c>
			r = 0;
  800509:	bb 00 00 00 00       	mov    $0x0,%ebx
  80050e:	eb e9                	jmp    8004f9 <fd_close+0x72>

00800510 <close>:

int
close(int fdnum)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800516:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800519:	50                   	push   %eax
  80051a:	ff 75 08             	pushl  0x8(%ebp)
  80051d:	e8 b9 fe ff ff       	call   8003db <fd_lookup>
  800522:	83 c4 08             	add    $0x8,%esp
  800525:	85 c0                	test   %eax,%eax
  800527:	78 10                	js     800539 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	6a 01                	push   $0x1
  80052e:	ff 75 f4             	pushl  -0xc(%ebp)
  800531:	e8 51 ff ff ff       	call   800487 <fd_close>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	c9                   	leave  
  80053a:	c3                   	ret    

0080053b <close_all>:

void
close_all(void)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	53                   	push   %ebx
  80053f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800542:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800547:	83 ec 0c             	sub    $0xc,%esp
  80054a:	53                   	push   %ebx
  80054b:	e8 c0 ff ff ff       	call   800510 <close>
	for (i = 0; i < MAXFD; i++)
  800550:	83 c3 01             	add    $0x1,%ebx
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	83 fb 20             	cmp    $0x20,%ebx
  800559:	75 ec                	jne    800547 <close_all+0xc>
}
  80055b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	57                   	push   %edi
  800564:	56                   	push   %esi
  800565:	53                   	push   %ebx
  800566:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800569:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	ff 75 08             	pushl  0x8(%ebp)
  800570:	e8 66 fe ff ff       	call   8003db <fd_lookup>
  800575:	89 c3                	mov    %eax,%ebx
  800577:	83 c4 08             	add    $0x8,%esp
  80057a:	85 c0                	test   %eax,%eax
  80057c:	0f 88 81 00 00 00    	js     800603 <dup+0xa3>
		return r;
	close(newfdnum);
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	ff 75 0c             	pushl  0xc(%ebp)
  800588:	e8 83 ff ff ff       	call   800510 <close>

	newfd = INDEX2FD(newfdnum);
  80058d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800590:	c1 e6 0c             	shl    $0xc,%esi
  800593:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800599:	83 c4 04             	add    $0x4,%esp
  80059c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059f:	e8 d1 fd ff ff       	call   800375 <fd2data>
  8005a4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a6:	89 34 24             	mov    %esi,(%esp)
  8005a9:	e8 c7 fd ff ff       	call   800375 <fd2data>
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b3:	89 d8                	mov    %ebx,%eax
  8005b5:	c1 e8 16             	shr    $0x16,%eax
  8005b8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005bf:	a8 01                	test   $0x1,%al
  8005c1:	74 11                	je     8005d4 <dup+0x74>
  8005c3:	89 d8                	mov    %ebx,%eax
  8005c5:	c1 e8 0c             	shr    $0xc,%eax
  8005c8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005cf:	f6 c2 01             	test   $0x1,%dl
  8005d2:	75 39                	jne    80060d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d7:	89 d0                	mov    %edx,%eax
  8005d9:	c1 e8 0c             	shr    $0xc,%eax
  8005dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	25 07 0e 00 00       	and    $0xe07,%eax
  8005eb:	50                   	push   %eax
  8005ec:	56                   	push   %esi
  8005ed:	6a 00                	push   $0x0
  8005ef:	52                   	push   %edx
  8005f0:	6a 00                	push   $0x0
  8005f2:	e8 a1 fb ff ff       	call   800198 <sys_page_map>
  8005f7:	89 c3                	mov    %eax,%ebx
  8005f9:	83 c4 20             	add    $0x20,%esp
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	78 31                	js     800631 <dup+0xd1>
		goto err;

	return newfdnum;
  800600:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800603:	89 d8                	mov    %ebx,%eax
  800605:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800608:	5b                   	pop    %ebx
  800609:	5e                   	pop    %esi
  80060a:	5f                   	pop    %edi
  80060b:	5d                   	pop    %ebp
  80060c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80060d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800614:	83 ec 0c             	sub    $0xc,%esp
  800617:	25 07 0e 00 00       	and    $0xe07,%eax
  80061c:	50                   	push   %eax
  80061d:	57                   	push   %edi
  80061e:	6a 00                	push   $0x0
  800620:	53                   	push   %ebx
  800621:	6a 00                	push   $0x0
  800623:	e8 70 fb ff ff       	call   800198 <sys_page_map>
  800628:	89 c3                	mov    %eax,%ebx
  80062a:	83 c4 20             	add    $0x20,%esp
  80062d:	85 c0                	test   %eax,%eax
  80062f:	79 a3                	jns    8005d4 <dup+0x74>
	sys_page_unmap(0, newfd);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	56                   	push   %esi
  800635:	6a 00                	push   $0x0
  800637:	e8 9e fb ff ff       	call   8001da <sys_page_unmap>
	sys_page_unmap(0, nva);
  80063c:	83 c4 08             	add    $0x8,%esp
  80063f:	57                   	push   %edi
  800640:	6a 00                	push   $0x0
  800642:	e8 93 fb ff ff       	call   8001da <sys_page_unmap>
	return r;
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	eb b7                	jmp    800603 <dup+0xa3>

0080064c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	53                   	push   %ebx
  800650:	83 ec 14             	sub    $0x14,%esp
  800653:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800656:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800659:	50                   	push   %eax
  80065a:	53                   	push   %ebx
  80065b:	e8 7b fd ff ff       	call   8003db <fd_lookup>
  800660:	83 c4 08             	add    $0x8,%esp
  800663:	85 c0                	test   %eax,%eax
  800665:	78 3f                	js     8006a6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80066d:	50                   	push   %eax
  80066e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800671:	ff 30                	pushl  (%eax)
  800673:	e8 b9 fd ff ff       	call   800431 <dev_lookup>
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	85 c0                	test   %eax,%eax
  80067d:	78 27                	js     8006a6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80067f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800682:	8b 42 08             	mov    0x8(%edx),%eax
  800685:	83 e0 03             	and    $0x3,%eax
  800688:	83 f8 01             	cmp    $0x1,%eax
  80068b:	74 1e                	je     8006ab <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80068d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800690:	8b 40 08             	mov    0x8(%eax),%eax
  800693:	85 c0                	test   %eax,%eax
  800695:	74 35                	je     8006cc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800697:	83 ec 04             	sub    $0x4,%esp
  80069a:	ff 75 10             	pushl  0x10(%ebp)
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	52                   	push   %edx
  8006a1:	ff d0                	call   *%eax
  8006a3:	83 c4 10             	add    $0x10,%esp
}
  8006a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b0:	8b 40 48             	mov    0x48(%eax),%eax
  8006b3:	83 ec 04             	sub    $0x4,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	50                   	push   %eax
  8006b8:	68 b9 22 80 00       	push   $0x8022b9
  8006bd:	e8 9e 0e 00 00       	call   801560 <cprintf>
		return -E_INVAL;
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ca:	eb da                	jmp    8006a6 <read+0x5a>
		return -E_NOT_SUPP;
  8006cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d1:	eb d3                	jmp    8006a6 <read+0x5a>

008006d3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	57                   	push   %edi
  8006d7:	56                   	push   %esi
  8006d8:	53                   	push   %ebx
  8006d9:	83 ec 0c             	sub    $0xc,%esp
  8006dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006df:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e7:	39 f3                	cmp    %esi,%ebx
  8006e9:	73 25                	jae    800710 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006eb:	83 ec 04             	sub    $0x4,%esp
  8006ee:	89 f0                	mov    %esi,%eax
  8006f0:	29 d8                	sub    %ebx,%eax
  8006f2:	50                   	push   %eax
  8006f3:	89 d8                	mov    %ebx,%eax
  8006f5:	03 45 0c             	add    0xc(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	57                   	push   %edi
  8006fa:	e8 4d ff ff ff       	call   80064c <read>
		if (m < 0)
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	85 c0                	test   %eax,%eax
  800704:	78 08                	js     80070e <readn+0x3b>
			return m;
		if (m == 0)
  800706:	85 c0                	test   %eax,%eax
  800708:	74 06                	je     800710 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80070a:	01 c3                	add    %eax,%ebx
  80070c:	eb d9                	jmp    8006e7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800710:	89 d8                	mov    %ebx,%eax
  800712:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800715:	5b                   	pop    %ebx
  800716:	5e                   	pop    %esi
  800717:	5f                   	pop    %edi
  800718:	5d                   	pop    %ebp
  800719:	c3                   	ret    

0080071a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	53                   	push   %ebx
  80071e:	83 ec 14             	sub    $0x14,%esp
  800721:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800724:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	53                   	push   %ebx
  800729:	e8 ad fc ff ff       	call   8003db <fd_lookup>
  80072e:	83 c4 08             	add    $0x8,%esp
  800731:	85 c0                	test   %eax,%eax
  800733:	78 3a                	js     80076f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80073b:	50                   	push   %eax
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073f:	ff 30                	pushl  (%eax)
  800741:	e8 eb fc ff ff       	call   800431 <dev_lookup>
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	85 c0                	test   %eax,%eax
  80074b:	78 22                	js     80076f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80074d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800750:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800754:	74 1e                	je     800774 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800759:	8b 52 0c             	mov    0xc(%edx),%edx
  80075c:	85 d2                	test   %edx,%edx
  80075e:	74 35                	je     800795 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800760:	83 ec 04             	sub    $0x4,%esp
  800763:	ff 75 10             	pushl  0x10(%ebp)
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	ff d2                	call   *%edx
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800772:	c9                   	leave  
  800773:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800774:	a1 08 40 80 00       	mov    0x804008,%eax
  800779:	8b 40 48             	mov    0x48(%eax),%eax
  80077c:	83 ec 04             	sub    $0x4,%esp
  80077f:	53                   	push   %ebx
  800780:	50                   	push   %eax
  800781:	68 d5 22 80 00       	push   $0x8022d5
  800786:	e8 d5 0d 00 00       	call   801560 <cprintf>
		return -E_INVAL;
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800793:	eb da                	jmp    80076f <write+0x55>
		return -E_NOT_SUPP;
  800795:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079a:	eb d3                	jmp    80076f <write+0x55>

0080079c <seek>:

int
seek(int fdnum, off_t offset)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a2:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007a5:	50                   	push   %eax
  8007a6:	ff 75 08             	pushl  0x8(%ebp)
  8007a9:	e8 2d fc ff ff       	call   8003db <fd_lookup>
  8007ae:	83 c4 08             	add    $0x8,%esp
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	78 0e                	js     8007c3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007bb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    

008007c5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	53                   	push   %ebx
  8007c9:	83 ec 14             	sub    $0x14,%esp
  8007cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	53                   	push   %ebx
  8007d4:	e8 02 fc ff ff       	call   8003db <fd_lookup>
  8007d9:	83 c4 08             	add    $0x8,%esp
  8007dc:	85 c0                	test   %eax,%eax
  8007de:	78 37                	js     800817 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	ff 30                	pushl  (%eax)
  8007ec:	e8 40 fc ff ff       	call   800431 <dev_lookup>
  8007f1:	83 c4 10             	add    $0x10,%esp
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	78 1f                	js     800817 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007ff:	74 1b                	je     80081c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800804:	8b 52 18             	mov    0x18(%edx),%edx
  800807:	85 d2                	test   %edx,%edx
  800809:	74 32                	je     80083d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	50                   	push   %eax
  800812:	ff d2                	call   *%edx
  800814:	83 c4 10             	add    $0x10,%esp
}
  800817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80081c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800821:	8b 40 48             	mov    0x48(%eax),%eax
  800824:	83 ec 04             	sub    $0x4,%esp
  800827:	53                   	push   %ebx
  800828:	50                   	push   %eax
  800829:	68 98 22 80 00       	push   $0x802298
  80082e:	e8 2d 0d 00 00       	call   801560 <cprintf>
		return -E_INVAL;
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083b:	eb da                	jmp    800817 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80083d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800842:	eb d3                	jmp    800817 <ftruncate+0x52>

00800844 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	83 ec 14             	sub    $0x14,%esp
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800851:	50                   	push   %eax
  800852:	ff 75 08             	pushl  0x8(%ebp)
  800855:	e8 81 fb ff ff       	call   8003db <fd_lookup>
  80085a:	83 c4 08             	add    $0x8,%esp
  80085d:	85 c0                	test   %eax,%eax
  80085f:	78 4b                	js     8008ac <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800867:	50                   	push   %eax
  800868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086b:	ff 30                	pushl  (%eax)
  80086d:	e8 bf fb ff ff       	call   800431 <dev_lookup>
  800872:	83 c4 10             	add    $0x10,%esp
  800875:	85 c0                	test   %eax,%eax
  800877:	78 33                	js     8008ac <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800880:	74 2f                	je     8008b1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800882:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800885:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80088c:	00 00 00 
	stat->st_isdir = 0;
  80088f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800896:	00 00 00 
	stat->st_dev = dev;
  800899:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a6:	ff 50 14             	call   *0x14(%eax)
  8008a9:	83 c4 10             	add    $0x10,%esp
}
  8008ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b6:	eb f4                	jmp    8008ac <fstat+0x68>

008008b8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	56                   	push   %esi
  8008bc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	6a 00                	push   $0x0
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 e7 01 00 00       	call   800ab1 <open>
  8008ca:	89 c3                	mov    %eax,%ebx
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	78 1b                	js     8008ee <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	e8 65 ff ff ff       	call   800844 <fstat>
  8008df:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e1:	89 1c 24             	mov    %ebx,(%esp)
  8008e4:	e8 27 fc ff ff       	call   800510 <close>
	return r;
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	89 f3                	mov    %esi,%ebx
}
  8008ee:	89 d8                	mov    %ebx,%eax
  8008f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f3:	5b                   	pop    %ebx
  8008f4:	5e                   	pop    %esi
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	56                   	push   %esi
  8008fb:	53                   	push   %ebx
  8008fc:	89 c6                	mov    %eax,%esi
  8008fe:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800900:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800907:	74 27                	je     800930 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800909:	6a 07                	push   $0x7
  80090b:	68 00 50 80 00       	push   $0x805000
  800910:	56                   	push   %esi
  800911:	ff 35 00 40 80 00    	pushl  0x804000
  800917:	e8 07 16 00 00       	call   801f23 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80091c:	83 c4 0c             	add    $0xc,%esp
  80091f:	6a 00                	push   $0x0
  800921:	53                   	push   %ebx
  800922:	6a 00                	push   $0x0
  800924:	e8 93 15 00 00       	call   801ebc <ipc_recv>
}
  800929:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80092c:	5b                   	pop    %ebx
  80092d:	5e                   	pop    %esi
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800930:	83 ec 0c             	sub    $0xc,%esp
  800933:	6a 01                	push   $0x1
  800935:	e8 3d 16 00 00       	call   801f77 <ipc_find_env>
  80093a:	a3 00 40 80 00       	mov    %eax,0x804000
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	eb c5                	jmp    800909 <fsipc+0x12>

00800944 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 40 0c             	mov    0xc(%eax),%eax
  800950:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80095d:	ba 00 00 00 00       	mov    $0x0,%edx
  800962:	b8 02 00 00 00       	mov    $0x2,%eax
  800967:	e8 8b ff ff ff       	call   8008f7 <fsipc>
}
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <devfile_flush>:
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 40 0c             	mov    0xc(%eax),%eax
  80097a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80097f:	ba 00 00 00 00       	mov    $0x0,%edx
  800984:	b8 06 00 00 00       	mov    $0x6,%eax
  800989:	e8 69 ff ff ff       	call   8008f7 <fsipc>
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <devfile_stat>:
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	83 ec 04             	sub    $0x4,%esp
  800997:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009aa:	b8 05 00 00 00       	mov    $0x5,%eax
  8009af:	e8 43 ff ff ff       	call   8008f7 <fsipc>
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	78 2c                	js     8009e4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	68 00 50 80 00       	push   $0x805000
  8009c0:	53                   	push   %ebx
  8009c1:	e8 b9 11 00 00       	call   801b7f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009c6:	a1 80 50 80 00       	mov    0x805080,%eax
  8009cb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d1:	a1 84 50 80 00       	mov    0x805084,%eax
  8009d6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <devfile_write>:
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	83 ec 0c             	sub    $0xc,%esp
  8009ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009f7:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8009fc:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800a02:	8b 52 0c             	mov    0xc(%edx),%edx
  800a05:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a0b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a10:	50                   	push   %eax
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	68 08 50 80 00       	push   $0x805008
  800a19:	e8 ef 12 00 00       	call   801d0d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a23:	b8 04 00 00 00       	mov    $0x4,%eax
  800a28:	e8 ca fe ff ff       	call   8008f7 <fsipc>
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <devfile_read>:
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	56                   	push   %esi
  800a33:	53                   	push   %ebx
  800a34:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  800a3d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a42:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a48:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a52:	e8 a0 fe ff ff       	call   8008f7 <fsipc>
  800a57:	89 c3                	mov    %eax,%ebx
  800a59:	85 c0                	test   %eax,%eax
  800a5b:	78 1f                	js     800a7c <devfile_read+0x4d>
	assert(r <= n);
  800a5d:	39 f0                	cmp    %esi,%eax
  800a5f:	77 24                	ja     800a85 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a66:	7f 33                	jg     800a9b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a68:	83 ec 04             	sub    $0x4,%esp
  800a6b:	50                   	push   %eax
  800a6c:	68 00 50 80 00       	push   $0x805000
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	e8 94 12 00 00       	call   801d0d <memmove>
	return r;
  800a79:	83 c4 10             	add    $0x10,%esp
}
  800a7c:	89 d8                	mov    %ebx,%eax
  800a7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    
	assert(r <= n);
  800a85:	68 08 23 80 00       	push   $0x802308
  800a8a:	68 0f 23 80 00       	push   $0x80230f
  800a8f:	6a 7b                	push   $0x7b
  800a91:	68 24 23 80 00       	push   $0x802324
  800a96:	e8 ea 09 00 00       	call   801485 <_panic>
	assert(r <= PGSIZE);
  800a9b:	68 2f 23 80 00       	push   $0x80232f
  800aa0:	68 0f 23 80 00       	push   $0x80230f
  800aa5:	6a 7c                	push   $0x7c
  800aa7:	68 24 23 80 00       	push   $0x802324
  800aac:	e8 d4 09 00 00       	call   801485 <_panic>

00800ab1 <open>:
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	83 ec 1c             	sub    $0x1c,%esp
  800ab9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800abc:	56                   	push   %esi
  800abd:	e8 86 10 00 00       	call   801b48 <strlen>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800aca:	7f 6c                	jg     800b38 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800acc:	83 ec 0c             	sub    $0xc,%esp
  800acf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ad2:	50                   	push   %eax
  800ad3:	e8 b4 f8 ff ff       	call   80038c <fd_alloc>
  800ad8:	89 c3                	mov    %eax,%ebx
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	85 c0                	test   %eax,%eax
  800adf:	78 3c                	js     800b1d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	56                   	push   %esi
  800ae5:	68 00 50 80 00       	push   $0x805000
  800aea:	e8 90 10 00 00       	call   801b7f <strcpy>
	fsipcbuf.open.req_omode = mode;
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afa:	b8 01 00 00 00       	mov    $0x1,%eax
  800aff:	e8 f3 fd ff ff       	call   8008f7 <fsipc>
  800b04:	89 c3                	mov    %eax,%ebx
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	78 19                	js     800b26 <open+0x75>
	return fd2num(fd);
  800b0d:	83 ec 0c             	sub    $0xc,%esp
  800b10:	ff 75 f4             	pushl  -0xc(%ebp)
  800b13:	e8 4d f8 ff ff       	call   800365 <fd2num>
  800b18:	89 c3                	mov    %eax,%ebx
  800b1a:	83 c4 10             	add    $0x10,%esp
}
  800b1d:	89 d8                	mov    %ebx,%eax
  800b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    
		fd_close(fd, 0);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	6a 00                	push   $0x0
  800b2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2e:	e8 54 f9 ff ff       	call   800487 <fd_close>
		return r;
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	eb e5                	jmp    800b1d <open+0x6c>
		return -E_BAD_PATH;
  800b38:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b3d:	eb de                	jmp    800b1d <open+0x6c>

00800b3f <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b45:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4a:	b8 08 00 00 00       	mov    $0x8,%eax
  800b4f:	e8 a3 fd ff ff       	call   8008f7 <fsipc>
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b5c:	68 3b 23 80 00       	push   $0x80233b
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	e8 16 10 00 00       	call   801b7f <strcpy>
	return 0;
}
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <devsock_close>:
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	53                   	push   %ebx
  800b74:	83 ec 10             	sub    $0x10,%esp
  800b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800b7a:	53                   	push   %ebx
  800b7b:	e8 30 14 00 00       	call   801fb0 <pageref>
  800b80:	83 c4 10             	add    $0x10,%esp
		return 0;
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800b88:	83 f8 01             	cmp    $0x1,%eax
  800b8b:	74 07                	je     800b94 <devsock_close+0x24>
}
  800b8d:	89 d0                	mov    %edx,%eax
  800b8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	ff 73 0c             	pushl  0xc(%ebx)
  800b9a:	e8 b7 02 00 00       	call   800e56 <nsipc_close>
  800b9f:	89 c2                	mov    %eax,%edx
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	eb e7                	jmp    800b8d <devsock_close+0x1d>

00800ba6 <devsock_write>:
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bac:	6a 00                	push   $0x0
  800bae:	ff 75 10             	pushl  0x10(%ebp)
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	ff 70 0c             	pushl  0xc(%eax)
  800bba:	e8 74 03 00 00       	call   800f33 <nsipc_send>
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <devsock_read>:
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bc7:	6a 00                	push   $0x0
  800bc9:	ff 75 10             	pushl  0x10(%ebp)
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff 70 0c             	pushl  0xc(%eax)
  800bd5:	e8 ed 02 00 00       	call   800ec7 <nsipc_recv>
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    

00800bdc <fd2sockid>:
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800be2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800be5:	52                   	push   %edx
  800be6:	50                   	push   %eax
  800be7:	e8 ef f7 ff ff       	call   8003db <fd_lookup>
  800bec:	83 c4 10             	add    $0x10,%esp
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	78 10                	js     800c03 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf6:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800bfc:	39 08                	cmp    %ecx,(%eax)
  800bfe:	75 05                	jne    800c05 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c00:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    
		return -E_NOT_SUPP;
  800c05:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c0a:	eb f7                	jmp    800c03 <fd2sockid+0x27>

00800c0c <alloc_sockfd>:
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	83 ec 1c             	sub    $0x1c,%esp
  800c14:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c19:	50                   	push   %eax
  800c1a:	e8 6d f7 ff ff       	call   80038c <fd_alloc>
  800c1f:	89 c3                	mov    %eax,%ebx
  800c21:	83 c4 10             	add    $0x10,%esp
  800c24:	85 c0                	test   %eax,%eax
  800c26:	78 43                	js     800c6b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c28:	83 ec 04             	sub    $0x4,%esp
  800c2b:	68 07 04 00 00       	push   $0x407
  800c30:	ff 75 f4             	pushl  -0xc(%ebp)
  800c33:	6a 00                	push   $0x0
  800c35:	e8 1b f5 ff ff       	call   800155 <sys_page_alloc>
  800c3a:	89 c3                	mov    %eax,%ebx
  800c3c:	83 c4 10             	add    $0x10,%esp
  800c3f:	85 c0                	test   %eax,%eax
  800c41:	78 28                	js     800c6b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c46:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c51:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c58:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c5b:	83 ec 0c             	sub    $0xc,%esp
  800c5e:	50                   	push   %eax
  800c5f:	e8 01 f7 ff ff       	call   800365 <fd2num>
  800c64:	89 c3                	mov    %eax,%ebx
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	eb 0c                	jmp    800c77 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c6b:	83 ec 0c             	sub    $0xc,%esp
  800c6e:	56                   	push   %esi
  800c6f:	e8 e2 01 00 00       	call   800e56 <nsipc_close>
		return r;
  800c74:	83 c4 10             	add    $0x10,%esp
}
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <accept>:
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	e8 4e ff ff ff       	call   800bdc <fd2sockid>
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	78 1b                	js     800cad <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800c92:	83 ec 04             	sub    $0x4,%esp
  800c95:	ff 75 10             	pushl  0x10(%ebp)
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	50                   	push   %eax
  800c9c:	e8 0e 01 00 00       	call   800daf <nsipc_accept>
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	78 05                	js     800cad <accept+0x2d>
	return alloc_sockfd(r);
  800ca8:	e8 5f ff ff ff       	call   800c0c <alloc_sockfd>
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <bind>:
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	e8 1f ff ff ff       	call   800bdc <fd2sockid>
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	78 12                	js     800cd3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800cc1:	83 ec 04             	sub    $0x4,%esp
  800cc4:	ff 75 10             	pushl  0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	e8 2f 01 00 00       	call   800dff <nsipc_bind>
  800cd0:	83 c4 10             	add    $0x10,%esp
}
  800cd3:	c9                   	leave  
  800cd4:	c3                   	ret    

00800cd5 <shutdown>:
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	e8 f9 fe ff ff       	call   800bdc <fd2sockid>
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	78 0f                	js     800cf6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800ce7:	83 ec 08             	sub    $0x8,%esp
  800cea:	ff 75 0c             	pushl  0xc(%ebp)
  800ced:	50                   	push   %eax
  800cee:	e8 41 01 00 00       	call   800e34 <nsipc_shutdown>
  800cf3:	83 c4 10             	add    $0x10,%esp
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <connect>:
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	e8 d6 fe ff ff       	call   800bdc <fd2sockid>
  800d06:	85 c0                	test   %eax,%eax
  800d08:	78 12                	js     800d1c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d0a:	83 ec 04             	sub    $0x4,%esp
  800d0d:	ff 75 10             	pushl  0x10(%ebp)
  800d10:	ff 75 0c             	pushl  0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	e8 57 01 00 00       	call   800e70 <nsipc_connect>
  800d19:	83 c4 10             	add    $0x10,%esp
}
  800d1c:	c9                   	leave  
  800d1d:	c3                   	ret    

00800d1e <listen>:
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	e8 b0 fe ff ff       	call   800bdc <fd2sockid>
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	78 0f                	js     800d3f <listen+0x21>
	return nsipc_listen(r, backlog);
  800d30:	83 ec 08             	sub    $0x8,%esp
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	50                   	push   %eax
  800d37:	e8 69 01 00 00       	call   800ea5 <nsipc_listen>
  800d3c:	83 c4 10             	add    $0x10,%esp
}
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <socket>:

int
socket(int domain, int type, int protocol)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d47:	ff 75 10             	pushl  0x10(%ebp)
  800d4a:	ff 75 0c             	pushl  0xc(%ebp)
  800d4d:	ff 75 08             	pushl  0x8(%ebp)
  800d50:	e8 3c 02 00 00       	call   800f91 <nsipc_socket>
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	78 05                	js     800d61 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d5c:	e8 ab fe ff ff       	call   800c0c <alloc_sockfd>
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	53                   	push   %ebx
  800d67:	83 ec 04             	sub    $0x4,%esp
  800d6a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d6c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d73:	74 26                	je     800d9b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800d75:	6a 07                	push   $0x7
  800d77:	68 00 60 80 00       	push   $0x806000
  800d7c:	53                   	push   %ebx
  800d7d:	ff 35 04 40 80 00    	pushl  0x804004
  800d83:	e8 9b 11 00 00       	call   801f23 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800d88:	83 c4 0c             	add    $0xc,%esp
  800d8b:	6a 00                	push   $0x0
  800d8d:	6a 00                	push   $0x0
  800d8f:	6a 00                	push   $0x0
  800d91:	e8 26 11 00 00       	call   801ebc <ipc_recv>
}
  800d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	6a 02                	push   $0x2
  800da0:	e8 d2 11 00 00       	call   801f77 <ipc_find_env>
  800da5:	a3 04 40 80 00       	mov    %eax,0x804004
  800daa:	83 c4 10             	add    $0x10,%esp
  800dad:	eb c6                	jmp    800d75 <nsipc+0x12>

00800daf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800dbf:	8b 06                	mov    (%esi),%eax
  800dc1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800dcb:	e8 93 ff ff ff       	call   800d63 <nsipc>
  800dd0:	89 c3                	mov    %eax,%ebx
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	78 20                	js     800df6 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800dd6:	83 ec 04             	sub    $0x4,%esp
  800dd9:	ff 35 10 60 80 00    	pushl  0x806010
  800ddf:	68 00 60 80 00       	push   $0x806000
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	e8 21 0f 00 00       	call   801d0d <memmove>
		*addrlen = ret->ret_addrlen;
  800dec:	a1 10 60 80 00       	mov    0x806010,%eax
  800df1:	89 06                	mov    %eax,(%esi)
  800df3:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800df6:	89 d8                	mov    %ebx,%eax
  800df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    

00800dff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	53                   	push   %ebx
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e11:	53                   	push   %ebx
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	68 04 60 80 00       	push   $0x806004
  800e1a:	e8 ee 0e 00 00       	call   801d0d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e1f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e25:	b8 02 00 00 00       	mov    $0x2,%eax
  800e2a:	e8 34 ff ff ff       	call   800d63 <nsipc>
}
  800e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e4a:	b8 03 00 00 00       	mov    $0x3,%eax
  800e4f:	e8 0f ff ff ff       	call   800d63 <nsipc>
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <nsipc_close>:

int
nsipc_close(int s)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e64:	b8 04 00 00 00       	mov    $0x4,%eax
  800e69:	e8 f5 fe ff ff       	call   800d63 <nsipc>
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	53                   	push   %ebx
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800e82:	53                   	push   %ebx
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	68 04 60 80 00       	push   $0x806004
  800e8b:	e8 7d 0e 00 00       	call   801d0d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800e90:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800e96:	b8 05 00 00 00       	mov    $0x5,%eax
  800e9b:	e8 c3 fe ff ff       	call   800d63 <nsipc>
}
  800ea0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ebb:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec0:	e8 9e fe ff ff       	call   800d63 <nsipc>
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
  800ecc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800ed7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800ee5:	b8 07 00 00 00       	mov    $0x7,%eax
  800eea:	e8 74 fe ff ff       	call   800d63 <nsipc>
  800eef:	89 c3                	mov    %eax,%ebx
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	78 1f                	js     800f14 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800ef5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800efa:	7f 21                	jg     800f1d <nsipc_recv+0x56>
  800efc:	39 c6                	cmp    %eax,%esi
  800efe:	7c 1d                	jl     800f1d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f00:	83 ec 04             	sub    $0x4,%esp
  800f03:	50                   	push   %eax
  800f04:	68 00 60 80 00       	push   $0x806000
  800f09:	ff 75 0c             	pushl  0xc(%ebp)
  800f0c:	e8 fc 0d 00 00       	call   801d0d <memmove>
  800f11:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f14:	89 d8                	mov    %ebx,%eax
  800f16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f1d:	68 47 23 80 00       	push   $0x802347
  800f22:	68 0f 23 80 00       	push   $0x80230f
  800f27:	6a 62                	push   $0x62
  800f29:	68 5c 23 80 00       	push   $0x80235c
  800f2e:	e8 52 05 00 00       	call   801485 <_panic>

00800f33 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	53                   	push   %ebx
  800f37:	83 ec 04             	sub    $0x4,%esp
  800f3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f45:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f4b:	7f 2e                	jg     800f7b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	53                   	push   %ebx
  800f51:	ff 75 0c             	pushl  0xc(%ebp)
  800f54:	68 0c 60 80 00       	push   $0x80600c
  800f59:	e8 af 0d 00 00       	call   801d0d <memmove>
	nsipcbuf.send.req_size = size;
  800f5e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f64:	8b 45 14             	mov    0x14(%ebp),%eax
  800f67:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f6c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f71:	e8 ed fd ff ff       	call   800d63 <nsipc>
}
  800f76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    
	assert(size < 1600);
  800f7b:	68 68 23 80 00       	push   $0x802368
  800f80:	68 0f 23 80 00       	push   $0x80230f
  800f85:	6a 6d                	push   $0x6d
  800f87:	68 5c 23 80 00       	push   $0x80235c
  800f8c:	e8 f4 04 00 00       	call   801485 <_panic>

00800f91 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800faa:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800faf:	b8 09 00 00 00       	mov    $0x9,%eax
  800fb4:	e8 aa fd ff ff       	call   800d63 <nsipc>
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	ff 75 08             	pushl  0x8(%ebp)
  800fc9:	e8 a7 f3 ff ff       	call   800375 <fd2data>
  800fce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fd0:	83 c4 08             	add    $0x8,%esp
  800fd3:	68 74 23 80 00       	push   $0x802374
  800fd8:	53                   	push   %ebx
  800fd9:	e8 a1 0b 00 00       	call   801b7f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fde:	8b 46 04             	mov    0x4(%esi),%eax
  800fe1:	2b 06                	sub    (%esi),%eax
  800fe3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fe9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ff0:	00 00 00 
	stat->st_dev = &devpipe;
  800ff3:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  800ffa:	30 80 00 
	return 0;
}
  800ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  801002:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	53                   	push   %ebx
  80100d:	83 ec 0c             	sub    $0xc,%esp
  801010:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801013:	53                   	push   %ebx
  801014:	6a 00                	push   $0x0
  801016:	e8 bf f1 ff ff       	call   8001da <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80101b:	89 1c 24             	mov    %ebx,(%esp)
  80101e:	e8 52 f3 ff ff       	call   800375 <fd2data>
  801023:	83 c4 08             	add    $0x8,%esp
  801026:	50                   	push   %eax
  801027:	6a 00                	push   $0x0
  801029:	e8 ac f1 ff ff       	call   8001da <sys_page_unmap>
}
  80102e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <_pipeisclosed>:
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 1c             	sub    $0x1c,%esp
  80103c:	89 c7                	mov    %eax,%edi
  80103e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801040:	a1 08 40 80 00       	mov    0x804008,%eax
  801045:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	57                   	push   %edi
  80104c:	e8 5f 0f 00 00       	call   801fb0 <pageref>
  801051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801054:	89 34 24             	mov    %esi,(%esp)
  801057:	e8 54 0f 00 00       	call   801fb0 <pageref>
		nn = thisenv->env_runs;
  80105c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801062:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	39 cb                	cmp    %ecx,%ebx
  80106a:	74 1b                	je     801087 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80106c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80106f:	75 cf                	jne    801040 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801071:	8b 42 58             	mov    0x58(%edx),%eax
  801074:	6a 01                	push   $0x1
  801076:	50                   	push   %eax
  801077:	53                   	push   %ebx
  801078:	68 7b 23 80 00       	push   $0x80237b
  80107d:	e8 de 04 00 00       	call   801560 <cprintf>
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	eb b9                	jmp    801040 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801087:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80108a:	0f 94 c0             	sete   %al
  80108d:	0f b6 c0             	movzbl %al,%eax
}
  801090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5f                   	pop    %edi
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    

00801098 <devpipe_write>:
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	57                   	push   %edi
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
  80109e:	83 ec 28             	sub    $0x28,%esp
  8010a1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010a4:	56                   	push   %esi
  8010a5:	e8 cb f2 ff ff       	call   800375 <fd2data>
  8010aa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010ac:	83 c4 10             	add    $0x10,%esp
  8010af:	bf 00 00 00 00       	mov    $0x0,%edi
  8010b4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010b7:	74 4f                	je     801108 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010b9:	8b 43 04             	mov    0x4(%ebx),%eax
  8010bc:	8b 0b                	mov    (%ebx),%ecx
  8010be:	8d 51 20             	lea    0x20(%ecx),%edx
  8010c1:	39 d0                	cmp    %edx,%eax
  8010c3:	72 14                	jb     8010d9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010c5:	89 da                	mov    %ebx,%edx
  8010c7:	89 f0                	mov    %esi,%eax
  8010c9:	e8 65 ff ff ff       	call   801033 <_pipeisclosed>
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	75 3a                	jne    80110c <devpipe_write+0x74>
			sys_yield();
  8010d2:	e8 5f f0 ff ff       	call   800136 <sys_yield>
  8010d7:	eb e0                	jmp    8010b9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010dc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010e0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 fa 1f             	sar    $0x1f,%edx
  8010e8:	89 d1                	mov    %edx,%ecx
  8010ea:	c1 e9 1b             	shr    $0x1b,%ecx
  8010ed:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010f0:	83 e2 1f             	and    $0x1f,%edx
  8010f3:	29 ca                	sub    %ecx,%edx
  8010f5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010f9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8010fd:	83 c0 01             	add    $0x1,%eax
  801100:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801103:	83 c7 01             	add    $0x1,%edi
  801106:	eb ac                	jmp    8010b4 <devpipe_write+0x1c>
	return i;
  801108:	89 f8                	mov    %edi,%eax
  80110a:	eb 05                	jmp    801111 <devpipe_write+0x79>
				return 0;
  80110c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801114:	5b                   	pop    %ebx
  801115:	5e                   	pop    %esi
  801116:	5f                   	pop    %edi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    

00801119 <devpipe_read>:
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	57                   	push   %edi
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
  80111f:	83 ec 18             	sub    $0x18,%esp
  801122:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801125:	57                   	push   %edi
  801126:	e8 4a f2 ff ff       	call   800375 <fd2data>
  80112b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	be 00 00 00 00       	mov    $0x0,%esi
  801135:	3b 75 10             	cmp    0x10(%ebp),%esi
  801138:	74 47                	je     801181 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80113a:	8b 03                	mov    (%ebx),%eax
  80113c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80113f:	75 22                	jne    801163 <devpipe_read+0x4a>
			if (i > 0)
  801141:	85 f6                	test   %esi,%esi
  801143:	75 14                	jne    801159 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801145:	89 da                	mov    %ebx,%edx
  801147:	89 f8                	mov    %edi,%eax
  801149:	e8 e5 fe ff ff       	call   801033 <_pipeisclosed>
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 33                	jne    801185 <devpipe_read+0x6c>
			sys_yield();
  801152:	e8 df ef ff ff       	call   800136 <sys_yield>
  801157:	eb e1                	jmp    80113a <devpipe_read+0x21>
				return i;
  801159:	89 f0                	mov    %esi,%eax
}
  80115b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115e:	5b                   	pop    %ebx
  80115f:	5e                   	pop    %esi
  801160:	5f                   	pop    %edi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801163:	99                   	cltd   
  801164:	c1 ea 1b             	shr    $0x1b,%edx
  801167:	01 d0                	add    %edx,%eax
  801169:	83 e0 1f             	and    $0x1f,%eax
  80116c:	29 d0                	sub    %edx,%eax
  80116e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801176:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801179:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80117c:	83 c6 01             	add    $0x1,%esi
  80117f:	eb b4                	jmp    801135 <devpipe_read+0x1c>
	return i;
  801181:	89 f0                	mov    %esi,%eax
  801183:	eb d6                	jmp    80115b <devpipe_read+0x42>
				return 0;
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	eb cf                	jmp    80115b <devpipe_read+0x42>

0080118c <pipe>:
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	56                   	push   %esi
  801190:	53                   	push   %ebx
  801191:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801194:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801197:	50                   	push   %eax
  801198:	e8 ef f1 ff ff       	call   80038c <fd_alloc>
  80119d:	89 c3                	mov    %eax,%ebx
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	78 5b                	js     801201 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	68 07 04 00 00       	push   $0x407
  8011ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b1:	6a 00                	push   $0x0
  8011b3:	e8 9d ef ff ff       	call   800155 <sys_page_alloc>
  8011b8:	89 c3                	mov    %eax,%ebx
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	78 40                	js     801201 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011c1:	83 ec 0c             	sub    $0xc,%esp
  8011c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c7:	50                   	push   %eax
  8011c8:	e8 bf f1 ff ff       	call   80038c <fd_alloc>
  8011cd:	89 c3                	mov    %eax,%ebx
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	78 1b                	js     8011f1 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	68 07 04 00 00       	push   $0x407
  8011de:	ff 75 f0             	pushl  -0x10(%ebp)
  8011e1:	6a 00                	push   $0x0
  8011e3:	e8 6d ef ff ff       	call   800155 <sys_page_alloc>
  8011e8:	89 c3                	mov    %eax,%ebx
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	79 19                	jns    80120a <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f7:	6a 00                	push   $0x0
  8011f9:	e8 dc ef ff ff       	call   8001da <sys_page_unmap>
  8011fe:	83 c4 10             	add    $0x10,%esp
}
  801201:	89 d8                	mov    %ebx,%eax
  801203:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    
	va = fd2data(fd0);
  80120a:	83 ec 0c             	sub    $0xc,%esp
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	e8 60 f1 ff ff       	call   800375 <fd2data>
  801215:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801217:	83 c4 0c             	add    $0xc,%esp
  80121a:	68 07 04 00 00       	push   $0x407
  80121f:	50                   	push   %eax
  801220:	6a 00                	push   $0x0
  801222:	e8 2e ef ff ff       	call   800155 <sys_page_alloc>
  801227:	89 c3                	mov    %eax,%ebx
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	0f 88 8c 00 00 00    	js     8012c0 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801234:	83 ec 0c             	sub    $0xc,%esp
  801237:	ff 75 f0             	pushl  -0x10(%ebp)
  80123a:	e8 36 f1 ff ff       	call   800375 <fd2data>
  80123f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801246:	50                   	push   %eax
  801247:	6a 00                	push   $0x0
  801249:	56                   	push   %esi
  80124a:	6a 00                	push   $0x0
  80124c:	e8 47 ef ff ff       	call   800198 <sys_page_map>
  801251:	89 c3                	mov    %eax,%ebx
  801253:	83 c4 20             	add    $0x20,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	78 58                	js     8012b2 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80125a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801263:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801268:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80126f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801272:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801278:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80127a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801284:	83 ec 0c             	sub    $0xc,%esp
  801287:	ff 75 f4             	pushl  -0xc(%ebp)
  80128a:	e8 d6 f0 ff ff       	call   800365 <fd2num>
  80128f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801292:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801294:	83 c4 04             	add    $0x4,%esp
  801297:	ff 75 f0             	pushl  -0x10(%ebp)
  80129a:	e8 c6 f0 ff ff       	call   800365 <fd2num>
  80129f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ad:	e9 4f ff ff ff       	jmp    801201 <pipe+0x75>
	sys_page_unmap(0, va);
  8012b2:	83 ec 08             	sub    $0x8,%esp
  8012b5:	56                   	push   %esi
  8012b6:	6a 00                	push   $0x0
  8012b8:	e8 1d ef ff ff       	call   8001da <sys_page_unmap>
  8012bd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 0d ef ff ff       	call   8001da <sys_page_unmap>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	e9 1c ff ff ff       	jmp    8011f1 <pipe+0x65>

008012d5 <pipeisclosed>:
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012de:	50                   	push   %eax
  8012df:	ff 75 08             	pushl  0x8(%ebp)
  8012e2:	e8 f4 f0 ff ff       	call   8003db <fd_lookup>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	78 18                	js     801306 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f4:	e8 7c f0 ff ff       	call   800375 <fd2data>
	return _pipeisclosed(fd, p);
  8012f9:	89 c2                	mov    %eax,%edx
  8012fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fe:	e8 30 fd ff ff       	call   801033 <_pipeisclosed>
  801303:	83 c4 10             	add    $0x10,%esp
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    

00801312 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801318:	68 93 23 80 00       	push   $0x802393
  80131d:	ff 75 0c             	pushl  0xc(%ebp)
  801320:	e8 5a 08 00 00       	call   801b7f <strcpy>
	return 0;
}
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <devcons_write>:
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801338:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80133d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801343:	eb 2f                	jmp    801374 <devcons_write+0x48>
		m = n - tot;
  801345:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801348:	29 f3                	sub    %esi,%ebx
  80134a:	83 fb 7f             	cmp    $0x7f,%ebx
  80134d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801352:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801355:	83 ec 04             	sub    $0x4,%esp
  801358:	53                   	push   %ebx
  801359:	89 f0                	mov    %esi,%eax
  80135b:	03 45 0c             	add    0xc(%ebp),%eax
  80135e:	50                   	push   %eax
  80135f:	57                   	push   %edi
  801360:	e8 a8 09 00 00       	call   801d0d <memmove>
		sys_cputs(buf, m);
  801365:	83 c4 08             	add    $0x8,%esp
  801368:	53                   	push   %ebx
  801369:	57                   	push   %edi
  80136a:	e8 2a ed ff ff       	call   800099 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80136f:	01 de                	add    %ebx,%esi
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	3b 75 10             	cmp    0x10(%ebp),%esi
  801377:	72 cc                	jb     801345 <devcons_write+0x19>
}
  801379:	89 f0                	mov    %esi,%eax
  80137b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5f                   	pop    %edi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <devcons_read>:
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	83 ec 08             	sub    $0x8,%esp
  801389:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80138e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801392:	75 07                	jne    80139b <devcons_read+0x18>
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    
		sys_yield();
  801396:	e8 9b ed ff ff       	call   800136 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80139b:	e8 17 ed ff ff       	call   8000b7 <sys_cgetc>
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	74 f2                	je     801396 <devcons_read+0x13>
	if (c < 0)
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 ec                	js     801394 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013a8:	83 f8 04             	cmp    $0x4,%eax
  8013ab:	74 0c                	je     8013b9 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b0:	88 02                	mov    %al,(%edx)
	return 1;
  8013b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8013b7:	eb db                	jmp    801394 <devcons_read+0x11>
		return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013be:	eb d4                	jmp    801394 <devcons_read+0x11>

008013c0 <cputchar>:
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013cc:	6a 01                	push   $0x1
  8013ce:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013d1:	50                   	push   %eax
  8013d2:	e8 c2 ec ff ff       	call   800099 <sys_cputs>
}
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <getchar>:
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013e2:	6a 01                	push   $0x1
  8013e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013e7:	50                   	push   %eax
  8013e8:	6a 00                	push   $0x0
  8013ea:	e8 5d f2 ff ff       	call   80064c <read>
	if (r < 0)
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 08                	js     8013fe <getchar+0x22>
	if (r < 1)
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	7e 06                	jle    801400 <getchar+0x24>
	return c;
  8013fa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    
		return -E_EOF;
  801400:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801405:	eb f7                	jmp    8013fe <getchar+0x22>

00801407 <iscons>:
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80140d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801410:	50                   	push   %eax
  801411:	ff 75 08             	pushl  0x8(%ebp)
  801414:	e8 c2 ef ff ff       	call   8003db <fd_lookup>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 11                	js     801431 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801423:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801429:	39 10                	cmp    %edx,(%eax)
  80142b:	0f 94 c0             	sete   %al
  80142e:	0f b6 c0             	movzbl %al,%eax
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <opencons>:
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	e8 4a ef ff ff       	call   80038c <fd_alloc>
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 3a                	js     801483 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	68 07 04 00 00       	push   $0x407
  801451:	ff 75 f4             	pushl  -0xc(%ebp)
  801454:	6a 00                	push   $0x0
  801456:	e8 fa ec ff ff       	call   800155 <sys_page_alloc>
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 21                	js     801483 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801465:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80146b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801477:	83 ec 0c             	sub    $0xc,%esp
  80147a:	50                   	push   %eax
  80147b:	e8 e5 ee ff ff       	call   800365 <fd2num>
  801480:	83 c4 10             	add    $0x10,%esp
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80148a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80148d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801493:	e8 7f ec ff ff       	call   800117 <sys_getenvid>
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	ff 75 08             	pushl  0x8(%ebp)
  8014a1:	56                   	push   %esi
  8014a2:	50                   	push   %eax
  8014a3:	68 a0 23 80 00       	push   $0x8023a0
  8014a8:	e8 b3 00 00 00       	call   801560 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014ad:	83 c4 18             	add    $0x18,%esp
  8014b0:	53                   	push   %ebx
  8014b1:	ff 75 10             	pushl  0x10(%ebp)
  8014b4:	e8 56 00 00 00       	call   80150f <vcprintf>
	cprintf("\n");
  8014b9:	c7 04 24 8c 23 80 00 	movl   $0x80238c,(%esp)
  8014c0:	e8 9b 00 00 00       	call   801560 <cprintf>
  8014c5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014c8:	cc                   	int3   
  8014c9:	eb fd                	jmp    8014c8 <_panic+0x43>

008014cb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014d5:	8b 13                	mov    (%ebx),%edx
  8014d7:	8d 42 01             	lea    0x1(%edx),%eax
  8014da:	89 03                	mov    %eax,(%ebx)
  8014dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014df:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014e8:	74 09                	je     8014f3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014ea:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	68 ff 00 00 00       	push   $0xff
  8014fb:	8d 43 08             	lea    0x8(%ebx),%eax
  8014fe:	50                   	push   %eax
  8014ff:	e8 95 eb ff ff       	call   800099 <sys_cputs>
		b->idx = 0;
  801504:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	eb db                	jmp    8014ea <putch+0x1f>

0080150f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801518:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80151f:	00 00 00 
	b.cnt = 0;
  801522:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801529:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801538:	50                   	push   %eax
  801539:	68 cb 14 80 00       	push   $0x8014cb
  80153e:	e8 1a 01 00 00       	call   80165d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801543:	83 c4 08             	add    $0x8,%esp
  801546:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80154c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801552:	50                   	push   %eax
  801553:	e8 41 eb ff ff       	call   800099 <sys_cputs>

	return b.cnt;
}
  801558:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801566:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801569:	50                   	push   %eax
  80156a:	ff 75 08             	pushl  0x8(%ebp)
  80156d:	e8 9d ff ff ff       	call   80150f <vcprintf>
	va_end(ap);

	return cnt;
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	57                   	push   %edi
  801578:	56                   	push   %esi
  801579:	53                   	push   %ebx
  80157a:	83 ec 1c             	sub    $0x1c,%esp
  80157d:	89 c7                	mov    %eax,%edi
  80157f:	89 d6                	mov    %edx,%esi
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8b 55 0c             	mov    0xc(%ebp),%edx
  801587:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80158a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80158d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801590:	bb 00 00 00 00       	mov    $0x0,%ebx
  801595:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801598:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80159b:	39 d3                	cmp    %edx,%ebx
  80159d:	72 05                	jb     8015a4 <printnum+0x30>
  80159f:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015a2:	77 7a                	ja     80161e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	ff 75 18             	pushl  0x18(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015b0:	53                   	push   %ebx
  8015b1:	ff 75 10             	pushl  0x10(%ebp)
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8015bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8015c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8015c3:	e8 28 0a 00 00       	call   801ff0 <__udivdi3>
  8015c8:	83 c4 18             	add    $0x18,%esp
  8015cb:	52                   	push   %edx
  8015cc:	50                   	push   %eax
  8015cd:	89 f2                	mov    %esi,%edx
  8015cf:	89 f8                	mov    %edi,%eax
  8015d1:	e8 9e ff ff ff       	call   801574 <printnum>
  8015d6:	83 c4 20             	add    $0x20,%esp
  8015d9:	eb 13                	jmp    8015ee <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	56                   	push   %esi
  8015df:	ff 75 18             	pushl  0x18(%ebp)
  8015e2:	ff d7                	call   *%edi
  8015e4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015e7:	83 eb 01             	sub    $0x1,%ebx
  8015ea:	85 db                	test   %ebx,%ebx
  8015ec:	7f ed                	jg     8015db <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015ee:	83 ec 08             	sub    $0x8,%esp
  8015f1:	56                   	push   %esi
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8015fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8015fe:	ff 75 d8             	pushl  -0x28(%ebp)
  801601:	e8 0a 0b 00 00       	call   802110 <__umoddi3>
  801606:	83 c4 14             	add    $0x14,%esp
  801609:	0f be 80 c3 23 80 00 	movsbl 0x8023c3(%eax),%eax
  801610:	50                   	push   %eax
  801611:	ff d7                	call   *%edi
}
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801619:	5b                   	pop    %ebx
  80161a:	5e                   	pop    %esi
  80161b:	5f                   	pop    %edi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    
  80161e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801621:	eb c4                	jmp    8015e7 <printnum+0x73>

00801623 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801629:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80162d:	8b 10                	mov    (%eax),%edx
  80162f:	3b 50 04             	cmp    0x4(%eax),%edx
  801632:	73 0a                	jae    80163e <sprintputch+0x1b>
		*b->buf++ = ch;
  801634:	8d 4a 01             	lea    0x1(%edx),%ecx
  801637:	89 08                	mov    %ecx,(%eax)
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	88 02                	mov    %al,(%edx)
}
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <printfmt>:
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801646:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801649:	50                   	push   %eax
  80164a:	ff 75 10             	pushl  0x10(%ebp)
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	ff 75 08             	pushl  0x8(%ebp)
  801653:	e8 05 00 00 00       	call   80165d <vprintfmt>
}
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <vprintfmt>:
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	57                   	push   %edi
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	83 ec 2c             	sub    $0x2c,%esp
  801666:	8b 75 08             	mov    0x8(%ebp),%esi
  801669:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80166c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80166f:	e9 c1 03 00 00       	jmp    801a35 <vprintfmt+0x3d8>
		padc = ' ';
  801674:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801678:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80167f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801686:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80168d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801692:	8d 47 01             	lea    0x1(%edi),%eax
  801695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801698:	0f b6 17             	movzbl (%edi),%edx
  80169b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80169e:	3c 55                	cmp    $0x55,%al
  8016a0:	0f 87 12 04 00 00    	ja     801ab8 <vprintfmt+0x45b>
  8016a6:	0f b6 c0             	movzbl %al,%eax
  8016a9:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  8016b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016b3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016b7:	eb d9                	jmp    801692 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016bc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016c0:	eb d0                	jmp    801692 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016c2:	0f b6 d2             	movzbl %dl,%edx
  8016c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016d3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016d7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016da:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016dd:	83 f9 09             	cmp    $0x9,%ecx
  8016e0:	77 55                	ja     801737 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016e2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016e5:	eb e9                	jmp    8016d0 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ea:	8b 00                	mov    (%eax),%eax
  8016ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8d 40 04             	lea    0x4(%eax),%eax
  8016f5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8016fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016ff:	79 91                	jns    801692 <vprintfmt+0x35>
				width = precision, precision = -1;
  801701:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801704:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801707:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80170e:	eb 82                	jmp    801692 <vprintfmt+0x35>
  801710:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801713:	85 c0                	test   %eax,%eax
  801715:	ba 00 00 00 00       	mov    $0x0,%edx
  80171a:	0f 49 d0             	cmovns %eax,%edx
  80171d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801720:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801723:	e9 6a ff ff ff       	jmp    801692 <vprintfmt+0x35>
  801728:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80172b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801732:	e9 5b ff ff ff       	jmp    801692 <vprintfmt+0x35>
  801737:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80173a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80173d:	eb bc                	jmp    8016fb <vprintfmt+0x9e>
			lflag++;
  80173f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801742:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801745:	e9 48 ff ff ff       	jmp    801692 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80174a:	8b 45 14             	mov    0x14(%ebp),%eax
  80174d:	8d 78 04             	lea    0x4(%eax),%edi
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	53                   	push   %ebx
  801754:	ff 30                	pushl  (%eax)
  801756:	ff d6                	call   *%esi
			break;
  801758:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80175b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80175e:	e9 cf 02 00 00       	jmp    801a32 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801763:	8b 45 14             	mov    0x14(%ebp),%eax
  801766:	8d 78 04             	lea    0x4(%eax),%edi
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	99                   	cltd   
  80176c:	31 d0                	xor    %edx,%eax
  80176e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801770:	83 f8 0f             	cmp    $0xf,%eax
  801773:	7f 23                	jg     801798 <vprintfmt+0x13b>
  801775:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  80177c:	85 d2                	test   %edx,%edx
  80177e:	74 18                	je     801798 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801780:	52                   	push   %edx
  801781:	68 21 23 80 00       	push   $0x802321
  801786:	53                   	push   %ebx
  801787:	56                   	push   %esi
  801788:	e8 b3 fe ff ff       	call   801640 <printfmt>
  80178d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801790:	89 7d 14             	mov    %edi,0x14(%ebp)
  801793:	e9 9a 02 00 00       	jmp    801a32 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  801798:	50                   	push   %eax
  801799:	68 db 23 80 00       	push   $0x8023db
  80179e:	53                   	push   %ebx
  80179f:	56                   	push   %esi
  8017a0:	e8 9b fe ff ff       	call   801640 <printfmt>
  8017a5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017a8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017ab:	e9 82 02 00 00       	jmp    801a32 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b3:	83 c0 04             	add    $0x4,%eax
  8017b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bc:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017be:	85 ff                	test   %edi,%edi
  8017c0:	b8 d4 23 80 00       	mov    $0x8023d4,%eax
  8017c5:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017cc:	0f 8e bd 00 00 00    	jle    80188f <vprintfmt+0x232>
  8017d2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017d6:	75 0e                	jne    8017e6 <vprintfmt+0x189>
  8017d8:	89 75 08             	mov    %esi,0x8(%ebp)
  8017db:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017de:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017e1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017e4:	eb 6d                	jmp    801853 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	ff 75 d0             	pushl  -0x30(%ebp)
  8017ec:	57                   	push   %edi
  8017ed:	e8 6e 03 00 00       	call   801b60 <strnlen>
  8017f2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017f5:	29 c1                	sub    %eax,%ecx
  8017f7:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8017fa:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8017fd:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801801:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801804:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801807:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801809:	eb 0f                	jmp    80181a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	53                   	push   %ebx
  80180f:	ff 75 e0             	pushl  -0x20(%ebp)
  801812:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801814:	83 ef 01             	sub    $0x1,%edi
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	85 ff                	test   %edi,%edi
  80181c:	7f ed                	jg     80180b <vprintfmt+0x1ae>
  80181e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801821:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801824:	85 c9                	test   %ecx,%ecx
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
  80182b:	0f 49 c1             	cmovns %ecx,%eax
  80182e:	29 c1                	sub    %eax,%ecx
  801830:	89 75 08             	mov    %esi,0x8(%ebp)
  801833:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801836:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801839:	89 cb                	mov    %ecx,%ebx
  80183b:	eb 16                	jmp    801853 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80183d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801841:	75 31                	jne    801874 <vprintfmt+0x217>
					putch(ch, putdat);
  801843:	83 ec 08             	sub    $0x8,%esp
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	ff 55 08             	call   *0x8(%ebp)
  80184d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801850:	83 eb 01             	sub    $0x1,%ebx
  801853:	83 c7 01             	add    $0x1,%edi
  801856:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80185a:	0f be c2             	movsbl %dl,%eax
  80185d:	85 c0                	test   %eax,%eax
  80185f:	74 59                	je     8018ba <vprintfmt+0x25d>
  801861:	85 f6                	test   %esi,%esi
  801863:	78 d8                	js     80183d <vprintfmt+0x1e0>
  801865:	83 ee 01             	sub    $0x1,%esi
  801868:	79 d3                	jns    80183d <vprintfmt+0x1e0>
  80186a:	89 df                	mov    %ebx,%edi
  80186c:	8b 75 08             	mov    0x8(%ebp),%esi
  80186f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801872:	eb 37                	jmp    8018ab <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801874:	0f be d2             	movsbl %dl,%edx
  801877:	83 ea 20             	sub    $0x20,%edx
  80187a:	83 fa 5e             	cmp    $0x5e,%edx
  80187d:	76 c4                	jbe    801843 <vprintfmt+0x1e6>
					putch('?', putdat);
  80187f:	83 ec 08             	sub    $0x8,%esp
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	6a 3f                	push   $0x3f
  801887:	ff 55 08             	call   *0x8(%ebp)
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	eb c1                	jmp    801850 <vprintfmt+0x1f3>
  80188f:	89 75 08             	mov    %esi,0x8(%ebp)
  801892:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801895:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801898:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80189b:	eb b6                	jmp    801853 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	53                   	push   %ebx
  8018a1:	6a 20                	push   $0x20
  8018a3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018a5:	83 ef 01             	sub    $0x1,%edi
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 ff                	test   %edi,%edi
  8018ad:	7f ee                	jg     80189d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8018b5:	e9 78 01 00 00       	jmp    801a32 <vprintfmt+0x3d5>
  8018ba:	89 df                	mov    %ebx,%edi
  8018bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8018bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018c2:	eb e7                	jmp    8018ab <vprintfmt+0x24e>
	if (lflag >= 2)
  8018c4:	83 f9 01             	cmp    $0x1,%ecx
  8018c7:	7e 3f                	jle    801908 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 50 04             	mov    0x4(%eax),%edx
  8018cf:	8b 00                	mov    (%eax),%eax
  8018d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018da:	8d 40 08             	lea    0x8(%eax),%eax
  8018dd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018e4:	79 5c                	jns    801942 <vprintfmt+0x2e5>
				putch('-', putdat);
  8018e6:	83 ec 08             	sub    $0x8,%esp
  8018e9:	53                   	push   %ebx
  8018ea:	6a 2d                	push   $0x2d
  8018ec:	ff d6                	call   *%esi
				num = -(long long) num;
  8018ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018f1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8018f4:	f7 da                	neg    %edx
  8018f6:	83 d1 00             	adc    $0x0,%ecx
  8018f9:	f7 d9                	neg    %ecx
  8018fb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8018fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  801903:	e9 10 01 00 00       	jmp    801a18 <vprintfmt+0x3bb>
	else if (lflag)
  801908:	85 c9                	test   %ecx,%ecx
  80190a:	75 1b                	jne    801927 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80190c:	8b 45 14             	mov    0x14(%ebp),%eax
  80190f:	8b 00                	mov    (%eax),%eax
  801911:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801914:	89 c1                	mov    %eax,%ecx
  801916:	c1 f9 1f             	sar    $0x1f,%ecx
  801919:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80191c:	8b 45 14             	mov    0x14(%ebp),%eax
  80191f:	8d 40 04             	lea    0x4(%eax),%eax
  801922:	89 45 14             	mov    %eax,0x14(%ebp)
  801925:	eb b9                	jmp    8018e0 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801927:	8b 45 14             	mov    0x14(%ebp),%eax
  80192a:	8b 00                	mov    (%eax),%eax
  80192c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80192f:	89 c1                	mov    %eax,%ecx
  801931:	c1 f9 1f             	sar    $0x1f,%ecx
  801934:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801937:	8b 45 14             	mov    0x14(%ebp),%eax
  80193a:	8d 40 04             	lea    0x4(%eax),%eax
  80193d:	89 45 14             	mov    %eax,0x14(%ebp)
  801940:	eb 9e                	jmp    8018e0 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801942:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801945:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801948:	b8 0a 00 00 00       	mov    $0xa,%eax
  80194d:	e9 c6 00 00 00       	jmp    801a18 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801952:	83 f9 01             	cmp    $0x1,%ecx
  801955:	7e 18                	jle    80196f <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801957:	8b 45 14             	mov    0x14(%ebp),%eax
  80195a:	8b 10                	mov    (%eax),%edx
  80195c:	8b 48 04             	mov    0x4(%eax),%ecx
  80195f:	8d 40 08             	lea    0x8(%eax),%eax
  801962:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801965:	b8 0a 00 00 00       	mov    $0xa,%eax
  80196a:	e9 a9 00 00 00       	jmp    801a18 <vprintfmt+0x3bb>
	else if (lflag)
  80196f:	85 c9                	test   %ecx,%ecx
  801971:	75 1a                	jne    80198d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  801973:	8b 45 14             	mov    0x14(%ebp),%eax
  801976:	8b 10                	mov    (%eax),%edx
  801978:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197d:	8d 40 04             	lea    0x4(%eax),%eax
  801980:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801983:	b8 0a 00 00 00       	mov    $0xa,%eax
  801988:	e9 8b 00 00 00       	jmp    801a18 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	8b 10                	mov    (%eax),%edx
  801992:	b9 00 00 00 00       	mov    $0x0,%ecx
  801997:	8d 40 04             	lea    0x4(%eax),%eax
  80199a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80199d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a2:	eb 74                	jmp    801a18 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019a4:	83 f9 01             	cmp    $0x1,%ecx
  8019a7:	7e 15                	jle    8019be <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ac:	8b 10                	mov    (%eax),%edx
  8019ae:	8b 48 04             	mov    0x4(%eax),%ecx
  8019b1:	8d 40 08             	lea    0x8(%eax),%eax
  8019b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8019bc:	eb 5a                	jmp    801a18 <vprintfmt+0x3bb>
	else if (lflag)
  8019be:	85 c9                	test   %ecx,%ecx
  8019c0:	75 17                	jne    8019d9 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c5:	8b 10                	mov    (%eax),%edx
  8019c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cc:	8d 40 04             	lea    0x4(%eax),%eax
  8019cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d7:	eb 3f                	jmp    801a18 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dc:	8b 10                	mov    (%eax),%edx
  8019de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e3:	8d 40 04             	lea    0x4(%eax),%eax
  8019e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ee:	eb 28                	jmp    801a18 <vprintfmt+0x3bb>
			putch('0', putdat);
  8019f0:	83 ec 08             	sub    $0x8,%esp
  8019f3:	53                   	push   %ebx
  8019f4:	6a 30                	push   $0x30
  8019f6:	ff d6                	call   *%esi
			putch('x', putdat);
  8019f8:	83 c4 08             	add    $0x8,%esp
  8019fb:	53                   	push   %ebx
  8019fc:	6a 78                	push   $0x78
  8019fe:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a00:	8b 45 14             	mov    0x14(%ebp),%eax
  801a03:	8b 10                	mov    (%eax),%edx
  801a05:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a0a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a0d:	8d 40 04             	lea    0x4(%eax),%eax
  801a10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a13:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a18:	83 ec 0c             	sub    $0xc,%esp
  801a1b:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a1f:	57                   	push   %edi
  801a20:	ff 75 e0             	pushl  -0x20(%ebp)
  801a23:	50                   	push   %eax
  801a24:	51                   	push   %ecx
  801a25:	52                   	push   %edx
  801a26:	89 da                	mov    %ebx,%edx
  801a28:	89 f0                	mov    %esi,%eax
  801a2a:	e8 45 fb ff ff       	call   801574 <printnum>
			break;
  801a2f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a32:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a35:	83 c7 01             	add    $0x1,%edi
  801a38:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a3c:	83 f8 25             	cmp    $0x25,%eax
  801a3f:	0f 84 2f fc ff ff    	je     801674 <vprintfmt+0x17>
			if (ch == '\0')
  801a45:	85 c0                	test   %eax,%eax
  801a47:	0f 84 8b 00 00 00    	je     801ad8 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	53                   	push   %ebx
  801a51:	50                   	push   %eax
  801a52:	ff d6                	call   *%esi
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	eb dc                	jmp    801a35 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a59:	83 f9 01             	cmp    $0x1,%ecx
  801a5c:	7e 15                	jle    801a73 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a61:	8b 10                	mov    (%eax),%edx
  801a63:	8b 48 04             	mov    0x4(%eax),%ecx
  801a66:	8d 40 08             	lea    0x8(%eax),%eax
  801a69:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a6c:	b8 10 00 00 00       	mov    $0x10,%eax
  801a71:	eb a5                	jmp    801a18 <vprintfmt+0x3bb>
	else if (lflag)
  801a73:	85 c9                	test   %ecx,%ecx
  801a75:	75 17                	jne    801a8e <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a77:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7a:	8b 10                	mov    (%eax),%edx
  801a7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a81:	8d 40 04             	lea    0x4(%eax),%eax
  801a84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a87:	b8 10 00 00 00       	mov    $0x10,%eax
  801a8c:	eb 8a                	jmp    801a18 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a91:	8b 10                	mov    (%eax),%edx
  801a93:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a98:	8d 40 04             	lea    0x4(%eax),%eax
  801a9b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a9e:	b8 10 00 00 00       	mov    $0x10,%eax
  801aa3:	e9 70 ff ff ff       	jmp    801a18 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801aa8:	83 ec 08             	sub    $0x8,%esp
  801aab:	53                   	push   %ebx
  801aac:	6a 25                	push   $0x25
  801aae:	ff d6                	call   *%esi
			break;
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	e9 7a ff ff ff       	jmp    801a32 <vprintfmt+0x3d5>
			putch('%', putdat);
  801ab8:	83 ec 08             	sub    $0x8,%esp
  801abb:	53                   	push   %ebx
  801abc:	6a 25                	push   $0x25
  801abe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	89 f8                	mov    %edi,%eax
  801ac5:	eb 03                	jmp    801aca <vprintfmt+0x46d>
  801ac7:	83 e8 01             	sub    $0x1,%eax
  801aca:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ace:	75 f7                	jne    801ac7 <vprintfmt+0x46a>
  801ad0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ad3:	e9 5a ff ff ff       	jmp    801a32 <vprintfmt+0x3d5>
}
  801ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5f                   	pop    %edi
  801ade:	5d                   	pop    %ebp
  801adf:	c3                   	ret    

00801ae0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 18             	sub    $0x18,%esp
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aef:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801af3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801af6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801afd:	85 c0                	test   %eax,%eax
  801aff:	74 26                	je     801b27 <vsnprintf+0x47>
  801b01:	85 d2                	test   %edx,%edx
  801b03:	7e 22                	jle    801b27 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b05:	ff 75 14             	pushl  0x14(%ebp)
  801b08:	ff 75 10             	pushl  0x10(%ebp)
  801b0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b0e:	50                   	push   %eax
  801b0f:	68 23 16 80 00       	push   $0x801623
  801b14:	e8 44 fb ff ff       	call   80165d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b22:	83 c4 10             	add    $0x10,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    
		return -E_INVAL;
  801b27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2c:	eb f7                	jmp    801b25 <vsnprintf+0x45>

00801b2e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b34:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b37:	50                   	push   %eax
  801b38:	ff 75 10             	pushl  0x10(%ebp)
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	ff 75 08             	pushl  0x8(%ebp)
  801b41:	e8 9a ff ff ff       	call   801ae0 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b53:	eb 03                	jmp    801b58 <strlen+0x10>
		n++;
  801b55:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b58:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b5c:	75 f7                	jne    801b55 <strlen+0xd>
	return n;
}
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6e:	eb 03                	jmp    801b73 <strnlen+0x13>
		n++;
  801b70:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b73:	39 d0                	cmp    %edx,%eax
  801b75:	74 06                	je     801b7d <strnlen+0x1d>
  801b77:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801b7b:	75 f3                	jne    801b70 <strnlen+0x10>
	return n;
}
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	53                   	push   %ebx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b89:	89 c2                	mov    %eax,%edx
  801b8b:	83 c1 01             	add    $0x1,%ecx
  801b8e:	83 c2 01             	add    $0x1,%edx
  801b91:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801b95:	88 5a ff             	mov    %bl,-0x1(%edx)
  801b98:	84 db                	test   %bl,%bl
  801b9a:	75 ef                	jne    801b8b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801b9c:	5b                   	pop    %ebx
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    

00801b9f <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	53                   	push   %ebx
  801ba3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ba6:	53                   	push   %ebx
  801ba7:	e8 9c ff ff ff       	call   801b48 <strlen>
  801bac:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	01 d8                	add    %ebx,%eax
  801bb4:	50                   	push   %eax
  801bb5:	e8 c5 ff ff ff       	call   801b7f <strcpy>
	return dst;
}
  801bba:	89 d8                	mov    %ebx,%eax
  801bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	56                   	push   %esi
  801bc5:	53                   	push   %ebx
  801bc6:	8b 75 08             	mov    0x8(%ebp),%esi
  801bc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bcc:	89 f3                	mov    %esi,%ebx
  801bce:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bd1:	89 f2                	mov    %esi,%edx
  801bd3:	eb 0f                	jmp    801be4 <strncpy+0x23>
		*dst++ = *src;
  801bd5:	83 c2 01             	add    $0x1,%edx
  801bd8:	0f b6 01             	movzbl (%ecx),%eax
  801bdb:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bde:	80 39 01             	cmpb   $0x1,(%ecx)
  801be1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801be4:	39 da                	cmp    %ebx,%edx
  801be6:	75 ed                	jne    801bd5 <strncpy+0x14>
	}
	return ret;
}
  801be8:	89 f0                	mov    %esi,%eax
  801bea:	5b                   	pop    %ebx
  801beb:	5e                   	pop    %esi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	56                   	push   %esi
  801bf2:	53                   	push   %ebx
  801bf3:	8b 75 08             	mov    0x8(%ebp),%esi
  801bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfc:	89 f0                	mov    %esi,%eax
  801bfe:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c02:	85 c9                	test   %ecx,%ecx
  801c04:	75 0b                	jne    801c11 <strlcpy+0x23>
  801c06:	eb 17                	jmp    801c1f <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c08:	83 c2 01             	add    $0x1,%edx
  801c0b:	83 c0 01             	add    $0x1,%eax
  801c0e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c11:	39 d8                	cmp    %ebx,%eax
  801c13:	74 07                	je     801c1c <strlcpy+0x2e>
  801c15:	0f b6 0a             	movzbl (%edx),%ecx
  801c18:	84 c9                	test   %cl,%cl
  801c1a:	75 ec                	jne    801c08 <strlcpy+0x1a>
		*dst = '\0';
  801c1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c1f:	29 f0                	sub    %esi,%eax
}
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    

00801c25 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c2e:	eb 06                	jmp    801c36 <strcmp+0x11>
		p++, q++;
  801c30:	83 c1 01             	add    $0x1,%ecx
  801c33:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c36:	0f b6 01             	movzbl (%ecx),%eax
  801c39:	84 c0                	test   %al,%al
  801c3b:	74 04                	je     801c41 <strcmp+0x1c>
  801c3d:	3a 02                	cmp    (%edx),%al
  801c3f:	74 ef                	je     801c30 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c41:	0f b6 c0             	movzbl %al,%eax
  801c44:	0f b6 12             	movzbl (%edx),%edx
  801c47:	29 d0                	sub    %edx,%eax
}
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    

00801c4b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	53                   	push   %ebx
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	89 c3                	mov    %eax,%ebx
  801c57:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c5a:	eb 06                	jmp    801c62 <strncmp+0x17>
		n--, p++, q++;
  801c5c:	83 c0 01             	add    $0x1,%eax
  801c5f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c62:	39 d8                	cmp    %ebx,%eax
  801c64:	74 16                	je     801c7c <strncmp+0x31>
  801c66:	0f b6 08             	movzbl (%eax),%ecx
  801c69:	84 c9                	test   %cl,%cl
  801c6b:	74 04                	je     801c71 <strncmp+0x26>
  801c6d:	3a 0a                	cmp    (%edx),%cl
  801c6f:	74 eb                	je     801c5c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c71:	0f b6 00             	movzbl (%eax),%eax
  801c74:	0f b6 12             	movzbl (%edx),%edx
  801c77:	29 d0                	sub    %edx,%eax
}
  801c79:	5b                   	pop    %ebx
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
		return 0;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c81:	eb f6                	jmp    801c79 <strncmp+0x2e>

00801c83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c8d:	0f b6 10             	movzbl (%eax),%edx
  801c90:	84 d2                	test   %dl,%dl
  801c92:	74 09                	je     801c9d <strchr+0x1a>
		if (*s == c)
  801c94:	38 ca                	cmp    %cl,%dl
  801c96:	74 0a                	je     801ca2 <strchr+0x1f>
	for (; *s; s++)
  801c98:	83 c0 01             	add    $0x1,%eax
  801c9b:	eb f0                	jmp    801c8d <strchr+0xa>
			return (char *) s;
	return 0;
  801c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    

00801ca4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cae:	eb 03                	jmp    801cb3 <strfind+0xf>
  801cb0:	83 c0 01             	add    $0x1,%eax
  801cb3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cb6:	38 ca                	cmp    %cl,%dl
  801cb8:	74 04                	je     801cbe <strfind+0x1a>
  801cba:	84 d2                	test   %dl,%dl
  801cbc:	75 f2                	jne    801cb0 <strfind+0xc>
			break;
	return (char *) s;
}
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    

00801cc0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	57                   	push   %edi
  801cc4:	56                   	push   %esi
  801cc5:	53                   	push   %ebx
  801cc6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ccc:	85 c9                	test   %ecx,%ecx
  801cce:	74 13                	je     801ce3 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cd0:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801cd6:	75 05                	jne    801cdd <memset+0x1d>
  801cd8:	f6 c1 03             	test   $0x3,%cl
  801cdb:	74 0d                	je     801cea <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce0:	fc                   	cld    
  801ce1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ce3:	89 f8                	mov    %edi,%eax
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
		c &= 0xFF;
  801cea:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cee:	89 d3                	mov    %edx,%ebx
  801cf0:	c1 e3 08             	shl    $0x8,%ebx
  801cf3:	89 d0                	mov    %edx,%eax
  801cf5:	c1 e0 18             	shl    $0x18,%eax
  801cf8:	89 d6                	mov    %edx,%esi
  801cfa:	c1 e6 10             	shl    $0x10,%esi
  801cfd:	09 f0                	or     %esi,%eax
  801cff:	09 c2                	or     %eax,%edx
  801d01:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d03:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d06:	89 d0                	mov    %edx,%eax
  801d08:	fc                   	cld    
  801d09:	f3 ab                	rep stos %eax,%es:(%edi)
  801d0b:	eb d6                	jmp    801ce3 <memset+0x23>

00801d0d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	57                   	push   %edi
  801d11:	56                   	push   %esi
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d18:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d1b:	39 c6                	cmp    %eax,%esi
  801d1d:	73 35                	jae    801d54 <memmove+0x47>
  801d1f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d22:	39 c2                	cmp    %eax,%edx
  801d24:	76 2e                	jbe    801d54 <memmove+0x47>
		s += n;
		d += n;
  801d26:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d29:	89 d6                	mov    %edx,%esi
  801d2b:	09 fe                	or     %edi,%esi
  801d2d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d33:	74 0c                	je     801d41 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d35:	83 ef 01             	sub    $0x1,%edi
  801d38:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d3b:	fd                   	std    
  801d3c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d3e:	fc                   	cld    
  801d3f:	eb 21                	jmp    801d62 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d41:	f6 c1 03             	test   $0x3,%cl
  801d44:	75 ef                	jne    801d35 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d46:	83 ef 04             	sub    $0x4,%edi
  801d49:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d4c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d4f:	fd                   	std    
  801d50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d52:	eb ea                	jmp    801d3e <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d54:	89 f2                	mov    %esi,%edx
  801d56:	09 c2                	or     %eax,%edx
  801d58:	f6 c2 03             	test   $0x3,%dl
  801d5b:	74 09                	je     801d66 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d5d:	89 c7                	mov    %eax,%edi
  801d5f:	fc                   	cld    
  801d60:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d62:	5e                   	pop    %esi
  801d63:	5f                   	pop    %edi
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d66:	f6 c1 03             	test   $0x3,%cl
  801d69:	75 f2                	jne    801d5d <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d6b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d6e:	89 c7                	mov    %eax,%edi
  801d70:	fc                   	cld    
  801d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d73:	eb ed                	jmp    801d62 <memmove+0x55>

00801d75 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801d78:	ff 75 10             	pushl  0x10(%ebp)
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	e8 87 ff ff ff       	call   801d0d <memmove>
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	56                   	push   %esi
  801d8c:	53                   	push   %ebx
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d93:	89 c6                	mov    %eax,%esi
  801d95:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d98:	39 f0                	cmp    %esi,%eax
  801d9a:	74 1c                	je     801db8 <memcmp+0x30>
		if (*s1 != *s2)
  801d9c:	0f b6 08             	movzbl (%eax),%ecx
  801d9f:	0f b6 1a             	movzbl (%edx),%ebx
  801da2:	38 d9                	cmp    %bl,%cl
  801da4:	75 08                	jne    801dae <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801da6:	83 c0 01             	add    $0x1,%eax
  801da9:	83 c2 01             	add    $0x1,%edx
  801dac:	eb ea                	jmp    801d98 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dae:	0f b6 c1             	movzbl %cl,%eax
  801db1:	0f b6 db             	movzbl %bl,%ebx
  801db4:	29 d8                	sub    %ebx,%eax
  801db6:	eb 05                	jmp    801dbd <memcmp+0x35>
	}

	return 0;
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbd:	5b                   	pop    %ebx
  801dbe:	5e                   	pop    %esi
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    

00801dc1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dca:	89 c2                	mov    %eax,%edx
  801dcc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dcf:	39 d0                	cmp    %edx,%eax
  801dd1:	73 09                	jae    801ddc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd3:	38 08                	cmp    %cl,(%eax)
  801dd5:	74 05                	je     801ddc <memfind+0x1b>
	for (; s < ends; s++)
  801dd7:	83 c0 01             	add    $0x1,%eax
  801dda:	eb f3                	jmp    801dcf <memfind+0xe>
			break;
	return (void *) s;
}
  801ddc:	5d                   	pop    %ebp
  801ddd:	c3                   	ret    

00801dde <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	57                   	push   %edi
  801de2:	56                   	push   %esi
  801de3:	53                   	push   %ebx
  801de4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dea:	eb 03                	jmp    801def <strtol+0x11>
		s++;
  801dec:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801def:	0f b6 01             	movzbl (%ecx),%eax
  801df2:	3c 20                	cmp    $0x20,%al
  801df4:	74 f6                	je     801dec <strtol+0xe>
  801df6:	3c 09                	cmp    $0x9,%al
  801df8:	74 f2                	je     801dec <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801dfa:	3c 2b                	cmp    $0x2b,%al
  801dfc:	74 2e                	je     801e2c <strtol+0x4e>
	int neg = 0;
  801dfe:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e03:	3c 2d                	cmp    $0x2d,%al
  801e05:	74 2f                	je     801e36 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e07:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e0d:	75 05                	jne    801e14 <strtol+0x36>
  801e0f:	80 39 30             	cmpb   $0x30,(%ecx)
  801e12:	74 2c                	je     801e40 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e14:	85 db                	test   %ebx,%ebx
  801e16:	75 0a                	jne    801e22 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e18:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e1d:	80 39 30             	cmpb   $0x30,(%ecx)
  801e20:	74 28                	je     801e4a <strtol+0x6c>
		base = 10;
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
  801e27:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e2a:	eb 50                	jmp    801e7c <strtol+0x9e>
		s++;
  801e2c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e34:	eb d1                	jmp    801e07 <strtol+0x29>
		s++, neg = 1;
  801e36:	83 c1 01             	add    $0x1,%ecx
  801e39:	bf 01 00 00 00       	mov    $0x1,%edi
  801e3e:	eb c7                	jmp    801e07 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e40:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e44:	74 0e                	je     801e54 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e46:	85 db                	test   %ebx,%ebx
  801e48:	75 d8                	jne    801e22 <strtol+0x44>
		s++, base = 8;
  801e4a:	83 c1 01             	add    $0x1,%ecx
  801e4d:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e52:	eb ce                	jmp    801e22 <strtol+0x44>
		s += 2, base = 16;
  801e54:	83 c1 02             	add    $0x2,%ecx
  801e57:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e5c:	eb c4                	jmp    801e22 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e5e:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e61:	89 f3                	mov    %esi,%ebx
  801e63:	80 fb 19             	cmp    $0x19,%bl
  801e66:	77 29                	ja     801e91 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e68:	0f be d2             	movsbl %dl,%edx
  801e6b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e6e:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e71:	7d 30                	jge    801ea3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e73:	83 c1 01             	add    $0x1,%ecx
  801e76:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e7a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e7c:	0f b6 11             	movzbl (%ecx),%edx
  801e7f:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e82:	89 f3                	mov    %esi,%ebx
  801e84:	80 fb 09             	cmp    $0x9,%bl
  801e87:	77 d5                	ja     801e5e <strtol+0x80>
			dig = *s - '0';
  801e89:	0f be d2             	movsbl %dl,%edx
  801e8c:	83 ea 30             	sub    $0x30,%edx
  801e8f:	eb dd                	jmp    801e6e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801e91:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e94:	89 f3                	mov    %esi,%ebx
  801e96:	80 fb 19             	cmp    $0x19,%bl
  801e99:	77 08                	ja     801ea3 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801e9b:	0f be d2             	movsbl %dl,%edx
  801e9e:	83 ea 37             	sub    $0x37,%edx
  801ea1:	eb cb                	jmp    801e6e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea7:	74 05                	je     801eae <strtol+0xd0>
		*endptr = (char *) s;
  801ea9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eac:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eae:	89 c2                	mov    %eax,%edx
  801eb0:	f7 da                	neg    %edx
  801eb2:	85 ff                	test   %edi,%edi
  801eb4:	0f 45 c2             	cmovne %edx,%eax
}
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5f                   	pop    %edi
  801eba:	5d                   	pop    %ebp
  801ebb:	c3                   	ret    

00801ebc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	56                   	push   %esi
  801ec0:	53                   	push   %ebx
  801ec1:	8b 75 08             	mov    0x8(%ebp),%esi
  801ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801eca:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ecc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ed1:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ed4:	83 ec 0c             	sub    $0xc,%esp
  801ed7:	50                   	push   %eax
  801ed8:	e8 28 e4 ff ff       	call   800305 <sys_ipc_recv>
	if (from_env_store)
  801edd:	83 c4 10             	add    $0x10,%esp
  801ee0:	85 f6                	test   %esi,%esi
  801ee2:	74 14                	je     801ef8 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	78 09                	js     801ef6 <ipc_recv+0x3a>
  801eed:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ef3:	8b 52 74             	mov    0x74(%edx),%edx
  801ef6:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801ef8:	85 db                	test   %ebx,%ebx
  801efa:	74 14                	je     801f10 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801efc:	ba 00 00 00 00       	mov    $0x0,%edx
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 09                	js     801f0e <ipc_recv+0x52>
  801f05:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f0b:	8b 52 78             	mov    0x78(%edx),%edx
  801f0e:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f10:	85 c0                	test   %eax,%eax
  801f12:	78 08                	js     801f1c <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f14:	a1 08 40 80 00       	mov    0x804008,%eax
  801f19:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	57                   	push   %edi
  801f27:	56                   	push   %esi
  801f28:	53                   	push   %ebx
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f35:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f37:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f3c:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f3f:	ff 75 14             	pushl  0x14(%ebp)
  801f42:	53                   	push   %ebx
  801f43:	56                   	push   %esi
  801f44:	57                   	push   %edi
  801f45:	e8 98 e3 ff ff       	call   8002e2 <sys_ipc_try_send>
		if (ret == 0)
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	74 1e                	je     801f6f <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f51:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f54:	75 07                	jne    801f5d <ipc_send+0x3a>
			sys_yield();
  801f56:	e8 db e1 ff ff       	call   800136 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f5b:	eb e2                	jmp    801f3f <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f5d:	50                   	push   %eax
  801f5e:	68 c0 26 80 00       	push   $0x8026c0
  801f63:	6a 3d                	push   $0x3d
  801f65:	68 d4 26 80 00       	push   $0x8026d4
  801f6a:	e8 16 f5 ff ff       	call   801485 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f72:	5b                   	pop    %ebx
  801f73:	5e                   	pop    %esi
  801f74:	5f                   	pop    %edi
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    

00801f77 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f82:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f85:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f8b:	8b 52 50             	mov    0x50(%edx),%edx
  801f8e:	39 ca                	cmp    %ecx,%edx
  801f90:	74 11                	je     801fa3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801f92:	83 c0 01             	add    $0x1,%eax
  801f95:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f9a:	75 e6                	jne    801f82 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	eb 0b                	jmp    801fae <ipc_find_env+0x37>
			return envs[i].env_id;
  801fa3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fa6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fab:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    

00801fb0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fb6:	89 d0                	mov    %edx,%eax
  801fb8:	c1 e8 16             	shr    $0x16,%eax
  801fbb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fc7:	f6 c1 01             	test   $0x1,%cl
  801fca:	74 1d                	je     801fe9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fcc:	c1 ea 0c             	shr    $0xc,%edx
  801fcf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fd6:	f6 c2 01             	test   $0x1,%dl
  801fd9:	74 0e                	je     801fe9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fdb:	c1 ea 0c             	shr    $0xc,%edx
  801fde:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fe5:	ef 
  801fe6:	0f b7 c0             	movzwl %ax,%eax
}
  801fe9:	5d                   	pop    %ebp
  801fea:	c3                   	ret    
  801feb:	66 90                	xchg   %ax,%ax
  801fed:	66 90                	xchg   %ax,%ax
  801fef:	90                   	nop

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

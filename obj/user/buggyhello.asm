
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 65 00 00 00       	call   8000a7 <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800052:	e8 ce 00 00 00       	call   800125 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 db                	test   %ebx,%ebx
  80006b:	7e 07                	jle    800074 <libmain+0x2d>
		binaryname = argv[0];
  80006d:	8b 06                	mov    (%esi),%eax
  80006f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800074:	83 ec 08             	sub    $0x8,%esp
  800077:	56                   	push   %esi
  800078:	53                   	push   %ebx
  800079:	e8 b5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007e:	e8 0a 00 00 00       	call   80008d <exit>
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800089:	5b                   	pop    %ebx
  80008a:	5e                   	pop    %esi
  80008b:	5d                   	pop    %ebp
  80008c:	c3                   	ret    

0080008d <exit>:

#include <inc/lib.h>

void exit(void)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800093:	e8 b1 04 00 00       	call   800549 <close_all>
	sys_env_destroy(0);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	6a 00                	push   $0x0
  80009d:	e8 42 00 00 00       	call   8000e4 <sys_env_destroy>
}
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b8:	89 c3                	mov    %eax,%ebx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 c6                	mov    %eax,%esi
  8000be:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5f                   	pop    %edi
  8000c3:	5d                   	pop    %ebp
  8000c4:	c3                   	ret    

008000c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d5:	89 d1                	mov    %edx,%ecx
  8000d7:	89 d3                	mov    %edx,%ebx
  8000d9:	89 d7                	mov    %edx,%edi
  8000db:	89 d6                	mov    %edx,%esi
  8000dd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fa:	89 cb                	mov    %ecx,%ebx
  8000fc:	89 cf                	mov    %ecx,%edi
  8000fe:	89 ce                	mov    %ecx,%esi
  800100:	cd 30                	int    $0x30
	if(check && ret > 0)
  800102:	85 c0                	test   %eax,%eax
  800104:	7f 08                	jg     80010e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800109:	5b                   	pop    %ebx
  80010a:	5e                   	pop    %esi
  80010b:	5f                   	pop    %edi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	6a 03                	push   $0x3
  800114:	68 4a 22 80 00       	push   $0x80224a
  800119:	6a 23                	push   $0x23
  80011b:	68 67 22 80 00       	push   $0x802267
  800120:	e8 6e 13 00 00       	call   801493 <_panic>

00800125 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	57                   	push   %edi
  800129:	56                   	push   %esi
  80012a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012b:	ba 00 00 00 00       	mov    $0x0,%edx
  800130:	b8 02 00 00 00       	mov    $0x2,%eax
  800135:	89 d1                	mov    %edx,%ecx
  800137:	89 d3                	mov    %edx,%ebx
  800139:	89 d7                	mov    %edx,%edi
  80013b:	89 d6                	mov    %edx,%esi
  80013d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5f                   	pop    %edi
  800142:	5d                   	pop    %ebp
  800143:	c3                   	ret    

00800144 <sys_yield>:

void
sys_yield(void)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	57                   	push   %edi
  800148:	56                   	push   %esi
  800149:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014a:	ba 00 00 00 00       	mov    $0x0,%edx
  80014f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800154:	89 d1                	mov    %edx,%ecx
  800156:	89 d3                	mov    %edx,%ebx
  800158:	89 d7                	mov    %edx,%edi
  80015a:	89 d6                	mov    %edx,%esi
  80015c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80015e:	5b                   	pop    %ebx
  80015f:	5e                   	pop    %esi
  800160:	5f                   	pop    %edi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	57                   	push   %edi
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	8b 55 08             	mov    0x8(%ebp),%edx
  800174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800177:	b8 04 00 00 00       	mov    $0x4,%eax
  80017c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017f:	89 f7                	mov    %esi,%edi
  800181:	cd 30                	int    $0x30
	if(check && ret > 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	7f 08                	jg     80018f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018a:	5b                   	pop    %ebx
  80018b:	5e                   	pop    %esi
  80018c:	5f                   	pop    %edi
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	50                   	push   %eax
  800193:	6a 04                	push   $0x4
  800195:	68 4a 22 80 00       	push   $0x80224a
  80019a:	6a 23                	push   $0x23
  80019c:	68 67 22 80 00       	push   $0x802267
  8001a1:	e8 ed 12 00 00       	call   801493 <_panic>

008001a6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	57                   	push   %edi
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001af:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	7f 08                	jg     8001d1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cc:	5b                   	pop    %ebx
  8001cd:	5e                   	pop    %esi
  8001ce:	5f                   	pop    %edi
  8001cf:	5d                   	pop    %ebp
  8001d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	50                   	push   %eax
  8001d5:	6a 05                	push   $0x5
  8001d7:	68 4a 22 80 00       	push   $0x80224a
  8001dc:	6a 23                	push   $0x23
  8001de:	68 67 22 80 00       	push   $0x802267
  8001e3:	e8 ab 12 00 00       	call   801493 <_panic>

008001e8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	57                   	push   %edi
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
  8001ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fc:	b8 06 00 00 00       	mov    $0x6,%eax
  800201:	89 df                	mov    %ebx,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	cd 30                	int    $0x30
	if(check && ret > 0)
  800207:	85 c0                	test   %eax,%eax
  800209:	7f 08                	jg     800213 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5f                   	pop    %edi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	6a 06                	push   $0x6
  800219:	68 4a 22 80 00       	push   $0x80224a
  80021e:	6a 23                	push   $0x23
  800220:	68 67 22 80 00       	push   $0x802267
  800225:	e8 69 12 00 00       	call   801493 <_panic>

0080022a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	57                   	push   %edi
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800233:	bb 00 00 00 00       	mov    $0x0,%ebx
  800238:	8b 55 08             	mov    0x8(%ebp),%edx
  80023b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023e:	b8 08 00 00 00       	mov    $0x8,%eax
  800243:	89 df                	mov    %ebx,%edi
  800245:	89 de                	mov    %ebx,%esi
  800247:	cd 30                	int    $0x30
	if(check && ret > 0)
  800249:	85 c0                	test   %eax,%eax
  80024b:	7f 08                	jg     800255 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800250:	5b                   	pop    %ebx
  800251:	5e                   	pop    %esi
  800252:	5f                   	pop    %edi
  800253:	5d                   	pop    %ebp
  800254:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	50                   	push   %eax
  800259:	6a 08                	push   $0x8
  80025b:	68 4a 22 80 00       	push   $0x80224a
  800260:	6a 23                	push   $0x23
  800262:	68 67 22 80 00       	push   $0x802267
  800267:	e8 27 12 00 00       	call   801493 <_panic>

0080026c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	57                   	push   %edi
  800270:	56                   	push   %esi
  800271:	53                   	push   %ebx
  800272:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800275:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027a:	8b 55 08             	mov    0x8(%ebp),%edx
  80027d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800280:	b8 09 00 00 00       	mov    $0x9,%eax
  800285:	89 df                	mov    %ebx,%edi
  800287:	89 de                	mov    %ebx,%esi
  800289:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028b:	85 c0                	test   %eax,%eax
  80028d:	7f 08                	jg     800297 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800292:	5b                   	pop    %ebx
  800293:	5e                   	pop    %esi
  800294:	5f                   	pop    %edi
  800295:	5d                   	pop    %ebp
  800296:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	50                   	push   %eax
  80029b:	6a 09                	push   $0x9
  80029d:	68 4a 22 80 00       	push   $0x80224a
  8002a2:	6a 23                	push   $0x23
  8002a4:	68 67 22 80 00       	push   $0x802267
  8002a9:	e8 e5 11 00 00       	call   801493 <_panic>

008002ae <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	57                   	push   %edi
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c7:	89 df                	mov    %ebx,%edi
  8002c9:	89 de                	mov    %ebx,%esi
  8002cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cd:	85 c0                	test   %eax,%eax
  8002cf:	7f 08                	jg     8002d9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	6a 0a                	push   $0xa
  8002df:	68 4a 22 80 00       	push   $0x80224a
  8002e4:	6a 23                	push   $0x23
  8002e6:	68 67 22 80 00       	push   $0x802267
  8002eb:	e8 a3 11 00 00       	call   801493 <_panic>

008002f0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800301:	be 00 00 00 00       	mov    $0x0,%esi
  800306:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800309:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	b8 0d 00 00 00       	mov    $0xd,%eax
  800329:	89 cb                	mov    %ecx,%ebx
  80032b:	89 cf                	mov    %ecx,%edi
  80032d:	89 ce                	mov    %ecx,%esi
  80032f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800331:	85 c0                	test   %eax,%eax
  800333:	7f 08                	jg     80033d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800335:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5f                   	pop    %edi
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	50                   	push   %eax
  800341:	6a 0d                	push   $0xd
  800343:	68 4a 22 80 00       	push   $0x80224a
  800348:	6a 23                	push   $0x23
  80034a:	68 67 22 80 00       	push   $0x802267
  80034f:	e8 3f 11 00 00       	call   801493 <_panic>

00800354 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035a:	ba 00 00 00 00       	mov    $0x0,%edx
  80035f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800364:	89 d1                	mov    %edx,%ecx
  800366:	89 d3                	mov    %edx,%ebx
  800368:	89 d7                	mov    %edx,%edi
  80036a:	89 d6                	mov    %edx,%esi
  80036c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80036e:	5b                   	pop    %ebx
  80036f:	5e                   	pop    %esi
  800370:	5f                   	pop    %edi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800376:	8b 45 08             	mov    0x8(%ebp),%eax
  800379:	05 00 00 00 30       	add    $0x30000000,%eax
  80037e:	c1 e8 0c             	shr    $0xc,%eax
}
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80038e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800393:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a5:	89 c2                	mov    %eax,%edx
  8003a7:	c1 ea 16             	shr    $0x16,%edx
  8003aa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003b1:	f6 c2 01             	test   $0x1,%dl
  8003b4:	74 2a                	je     8003e0 <fd_alloc+0x46>
  8003b6:	89 c2                	mov    %eax,%edx
  8003b8:	c1 ea 0c             	shr    $0xc,%edx
  8003bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c2:	f6 c2 01             	test   $0x1,%dl
  8003c5:	74 19                	je     8003e0 <fd_alloc+0x46>
  8003c7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003cc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003d1:	75 d2                	jne    8003a5 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003d3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003d9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003de:	eb 07                	jmp    8003e7 <fd_alloc+0x4d>
			*fd_store = fd;
  8003e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003ef:	83 f8 1f             	cmp    $0x1f,%eax
  8003f2:	77 36                	ja     80042a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003f4:	c1 e0 0c             	shl    $0xc,%eax
  8003f7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003fc:	89 c2                	mov    %eax,%edx
  8003fe:	c1 ea 16             	shr    $0x16,%edx
  800401:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800408:	f6 c2 01             	test   $0x1,%dl
  80040b:	74 24                	je     800431 <fd_lookup+0x48>
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	c1 ea 0c             	shr    $0xc,%edx
  800412:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800419:	f6 c2 01             	test   $0x1,%dl
  80041c:	74 1a                	je     800438 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80041e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800421:	89 02                	mov    %eax,(%edx)
	return 0;
  800423:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    
		return -E_INVAL;
  80042a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042f:	eb f7                	jmp    800428 <fd_lookup+0x3f>
		return -E_INVAL;
  800431:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800436:	eb f0                	jmp    800428 <fd_lookup+0x3f>
  800438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80043d:	eb e9                	jmp    800428 <fd_lookup+0x3f>

0080043f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800448:	ba f4 22 80 00       	mov    $0x8022f4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80044d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800452:	39 08                	cmp    %ecx,(%eax)
  800454:	74 33                	je     800489 <dev_lookup+0x4a>
  800456:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800459:	8b 02                	mov    (%edx),%eax
  80045b:	85 c0                	test   %eax,%eax
  80045d:	75 f3                	jne    800452 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80045f:	a1 08 40 80 00       	mov    0x804008,%eax
  800464:	8b 40 48             	mov    0x48(%eax),%eax
  800467:	83 ec 04             	sub    $0x4,%esp
  80046a:	51                   	push   %ecx
  80046b:	50                   	push   %eax
  80046c:	68 78 22 80 00       	push   $0x802278
  800471:	e8 f8 10 00 00       	call   80156e <cprintf>
	*dev = 0;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800487:	c9                   	leave  
  800488:	c3                   	ret    
			*dev = devtab[i];
  800489:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80048e:	b8 00 00 00 00       	mov    $0x0,%eax
  800493:	eb f2                	jmp    800487 <dev_lookup+0x48>

00800495 <fd_close>:
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	57                   	push   %edi
  800499:	56                   	push   %esi
  80049a:	53                   	push   %ebx
  80049b:	83 ec 1c             	sub    $0x1c,%esp
  80049e:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004a8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004ae:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b1:	50                   	push   %eax
  8004b2:	e8 32 ff ff ff       	call   8003e9 <fd_lookup>
  8004b7:	89 c3                	mov    %eax,%ebx
  8004b9:	83 c4 08             	add    $0x8,%esp
  8004bc:	85 c0                	test   %eax,%eax
  8004be:	78 05                	js     8004c5 <fd_close+0x30>
	    || fd != fd2)
  8004c0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004c3:	74 16                	je     8004db <fd_close+0x46>
		return (must_exist ? r : 0);
  8004c5:	89 f8                	mov    %edi,%eax
  8004c7:	84 c0                	test   %al,%al
  8004c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ce:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d1:	89 d8                	mov    %ebx,%eax
  8004d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d6:	5b                   	pop    %ebx
  8004d7:	5e                   	pop    %esi
  8004d8:	5f                   	pop    %edi
  8004d9:	5d                   	pop    %ebp
  8004da:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	ff 36                	pushl  (%esi)
  8004e4:	e8 56 ff ff ff       	call   80043f <dev_lookup>
  8004e9:	89 c3                	mov    %eax,%ebx
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	78 15                	js     800507 <fd_close+0x72>
		if (dev->dev_close)
  8004f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f5:	8b 40 10             	mov    0x10(%eax),%eax
  8004f8:	85 c0                	test   %eax,%eax
  8004fa:	74 1b                	je     800517 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004fc:	83 ec 0c             	sub    $0xc,%esp
  8004ff:	56                   	push   %esi
  800500:	ff d0                	call   *%eax
  800502:	89 c3                	mov    %eax,%ebx
  800504:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	56                   	push   %esi
  80050b:	6a 00                	push   $0x0
  80050d:	e8 d6 fc ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	eb ba                	jmp    8004d1 <fd_close+0x3c>
			r = 0;
  800517:	bb 00 00 00 00       	mov    $0x0,%ebx
  80051c:	eb e9                	jmp    800507 <fd_close+0x72>

0080051e <close>:

int
close(int fdnum)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800527:	50                   	push   %eax
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	e8 b9 fe ff ff       	call   8003e9 <fd_lookup>
  800530:	83 c4 08             	add    $0x8,%esp
  800533:	85 c0                	test   %eax,%eax
  800535:	78 10                	js     800547 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	6a 01                	push   $0x1
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	e8 51 ff ff ff       	call   800495 <fd_close>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <close_all>:

void
close_all(void)
{
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	53                   	push   %ebx
  80054d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800550:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800555:	83 ec 0c             	sub    $0xc,%esp
  800558:	53                   	push   %ebx
  800559:	e8 c0 ff ff ff       	call   80051e <close>
	for (i = 0; i < MAXFD; i++)
  80055e:	83 c3 01             	add    $0x1,%ebx
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	83 fb 20             	cmp    $0x20,%ebx
  800567:	75 ec                	jne    800555 <close_all+0xc>
}
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	57                   	push   %edi
  800572:	56                   	push   %esi
  800573:	53                   	push   %ebx
  800574:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800577:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	ff 75 08             	pushl  0x8(%ebp)
  80057e:	e8 66 fe ff ff       	call   8003e9 <fd_lookup>
  800583:	89 c3                	mov    %eax,%ebx
  800585:	83 c4 08             	add    $0x8,%esp
  800588:	85 c0                	test   %eax,%eax
  80058a:	0f 88 81 00 00 00    	js     800611 <dup+0xa3>
		return r;
	close(newfdnum);
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	ff 75 0c             	pushl  0xc(%ebp)
  800596:	e8 83 ff ff ff       	call   80051e <close>

	newfd = INDEX2FD(newfdnum);
  80059b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80059e:	c1 e6 0c             	shl    $0xc,%esi
  8005a1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005a7:	83 c4 04             	add    $0x4,%esp
  8005aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005ad:	e8 d1 fd ff ff       	call   800383 <fd2data>
  8005b2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005b4:	89 34 24             	mov    %esi,(%esp)
  8005b7:	e8 c7 fd ff ff       	call   800383 <fd2data>
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c1:	89 d8                	mov    %ebx,%eax
  8005c3:	c1 e8 16             	shr    $0x16,%eax
  8005c6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005cd:	a8 01                	test   $0x1,%al
  8005cf:	74 11                	je     8005e2 <dup+0x74>
  8005d1:	89 d8                	mov    %ebx,%eax
  8005d3:	c1 e8 0c             	shr    $0xc,%eax
  8005d6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005dd:	f6 c2 01             	test   $0x1,%dl
  8005e0:	75 39                	jne    80061b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e5:	89 d0                	mov    %edx,%eax
  8005e7:	c1 e8 0c             	shr    $0xc,%eax
  8005ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f1:	83 ec 0c             	sub    $0xc,%esp
  8005f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8005f9:	50                   	push   %eax
  8005fa:	56                   	push   %esi
  8005fb:	6a 00                	push   $0x0
  8005fd:	52                   	push   %edx
  8005fe:	6a 00                	push   $0x0
  800600:	e8 a1 fb ff ff       	call   8001a6 <sys_page_map>
  800605:	89 c3                	mov    %eax,%ebx
  800607:	83 c4 20             	add    $0x20,%esp
  80060a:	85 c0                	test   %eax,%eax
  80060c:	78 31                	js     80063f <dup+0xd1>
		goto err;

	return newfdnum;
  80060e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800611:	89 d8                	mov    %ebx,%eax
  800613:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800616:	5b                   	pop    %ebx
  800617:	5e                   	pop    %esi
  800618:	5f                   	pop    %edi
  800619:	5d                   	pop    %ebp
  80061a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80061b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	25 07 0e 00 00       	and    $0xe07,%eax
  80062a:	50                   	push   %eax
  80062b:	57                   	push   %edi
  80062c:	6a 00                	push   $0x0
  80062e:	53                   	push   %ebx
  80062f:	6a 00                	push   $0x0
  800631:	e8 70 fb ff ff       	call   8001a6 <sys_page_map>
  800636:	89 c3                	mov    %eax,%ebx
  800638:	83 c4 20             	add    $0x20,%esp
  80063b:	85 c0                	test   %eax,%eax
  80063d:	79 a3                	jns    8005e2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	56                   	push   %esi
  800643:	6a 00                	push   $0x0
  800645:	e8 9e fb ff ff       	call   8001e8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80064a:	83 c4 08             	add    $0x8,%esp
  80064d:	57                   	push   %edi
  80064e:	6a 00                	push   $0x0
  800650:	e8 93 fb ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb b7                	jmp    800611 <dup+0xa3>

0080065a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80065a:	55                   	push   %ebp
  80065b:	89 e5                	mov    %esp,%ebp
  80065d:	53                   	push   %ebx
  80065e:	83 ec 14             	sub    $0x14,%esp
  800661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800664:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800667:	50                   	push   %eax
  800668:	53                   	push   %ebx
  800669:	e8 7b fd ff ff       	call   8003e9 <fd_lookup>
  80066e:	83 c4 08             	add    $0x8,%esp
  800671:	85 c0                	test   %eax,%eax
  800673:	78 3f                	js     8006b4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80067b:	50                   	push   %eax
  80067c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067f:	ff 30                	pushl  (%eax)
  800681:	e8 b9 fd ff ff       	call   80043f <dev_lookup>
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	85 c0                	test   %eax,%eax
  80068b:	78 27                	js     8006b4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80068d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800690:	8b 42 08             	mov    0x8(%edx),%eax
  800693:	83 e0 03             	and    $0x3,%eax
  800696:	83 f8 01             	cmp    $0x1,%eax
  800699:	74 1e                	je     8006b9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80069b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069e:	8b 40 08             	mov    0x8(%eax),%eax
  8006a1:	85 c0                	test   %eax,%eax
  8006a3:	74 35                	je     8006da <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006a5:	83 ec 04             	sub    $0x4,%esp
  8006a8:	ff 75 10             	pushl  0x10(%ebp)
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	52                   	push   %edx
  8006af:	ff d0                	call   *%eax
  8006b1:	83 c4 10             	add    $0x10,%esp
}
  8006b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b7:	c9                   	leave  
  8006b8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8006be:	8b 40 48             	mov    0x48(%eax),%eax
  8006c1:	83 ec 04             	sub    $0x4,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	50                   	push   %eax
  8006c6:	68 b9 22 80 00       	push   $0x8022b9
  8006cb:	e8 9e 0e 00 00       	call   80156e <cprintf>
		return -E_INVAL;
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d8:	eb da                	jmp    8006b4 <read+0x5a>
		return -E_NOT_SUPP;
  8006da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006df:	eb d3                	jmp    8006b4 <read+0x5a>

008006e1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	57                   	push   %edi
  8006e5:	56                   	push   %esi
  8006e6:	53                   	push   %ebx
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006ed:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f5:	39 f3                	cmp    %esi,%ebx
  8006f7:	73 25                	jae    80071e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f9:	83 ec 04             	sub    $0x4,%esp
  8006fc:	89 f0                	mov    %esi,%eax
  8006fe:	29 d8                	sub    %ebx,%eax
  800700:	50                   	push   %eax
  800701:	89 d8                	mov    %ebx,%eax
  800703:	03 45 0c             	add    0xc(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	57                   	push   %edi
  800708:	e8 4d ff ff ff       	call   80065a <read>
		if (m < 0)
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	85 c0                	test   %eax,%eax
  800712:	78 08                	js     80071c <readn+0x3b>
			return m;
		if (m == 0)
  800714:	85 c0                	test   %eax,%eax
  800716:	74 06                	je     80071e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800718:	01 c3                	add    %eax,%ebx
  80071a:	eb d9                	jmp    8006f5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80071c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80071e:	89 d8                	mov    %ebx,%eax
  800720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800723:	5b                   	pop    %ebx
  800724:	5e                   	pop    %esi
  800725:	5f                   	pop    %edi
  800726:	5d                   	pop    %ebp
  800727:	c3                   	ret    

00800728 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	53                   	push   %ebx
  80072c:	83 ec 14             	sub    $0x14,%esp
  80072f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800732:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800735:	50                   	push   %eax
  800736:	53                   	push   %ebx
  800737:	e8 ad fc ff ff       	call   8003e9 <fd_lookup>
  80073c:	83 c4 08             	add    $0x8,%esp
  80073f:	85 c0                	test   %eax,%eax
  800741:	78 3a                	js     80077d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074d:	ff 30                	pushl  (%eax)
  80074f:	e8 eb fc ff ff       	call   80043f <dev_lookup>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	85 c0                	test   %eax,%eax
  800759:	78 22                	js     80077d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800762:	74 1e                	je     800782 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800767:	8b 52 0c             	mov    0xc(%edx),%edx
  80076a:	85 d2                	test   %edx,%edx
  80076c:	74 35                	je     8007a3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80076e:	83 ec 04             	sub    $0x4,%esp
  800771:	ff 75 10             	pushl  0x10(%ebp)
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	ff d2                	call   *%edx
  80077a:	83 c4 10             	add    $0x10,%esp
}
  80077d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800780:	c9                   	leave  
  800781:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800782:	a1 08 40 80 00       	mov    0x804008,%eax
  800787:	8b 40 48             	mov    0x48(%eax),%eax
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	53                   	push   %ebx
  80078e:	50                   	push   %eax
  80078f:	68 d5 22 80 00       	push   $0x8022d5
  800794:	e8 d5 0d 00 00       	call   80156e <cprintf>
		return -E_INVAL;
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a1:	eb da                	jmp    80077d <write+0x55>
		return -E_NOT_SUPP;
  8007a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007a8:	eb d3                	jmp    80077d <write+0x55>

008007aa <seek>:

int
seek(int fdnum, off_t offset)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007b3:	50                   	push   %eax
  8007b4:	ff 75 08             	pushl  0x8(%ebp)
  8007b7:	e8 2d fc ff ff       	call   8003e9 <fd_lookup>
  8007bc:	83 c4 08             	add    $0x8,%esp
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	78 0e                	js     8007d1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007c9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	53                   	push   %ebx
  8007d7:	83 ec 14             	sub    $0x14,%esp
  8007da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e0:	50                   	push   %eax
  8007e1:	53                   	push   %ebx
  8007e2:	e8 02 fc ff ff       	call   8003e9 <fd_lookup>
  8007e7:	83 c4 08             	add    $0x8,%esp
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	78 37                	js     800825 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f8:	ff 30                	pushl  (%eax)
  8007fa:	e8 40 fc ff ff       	call   80043f <dev_lookup>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	85 c0                	test   %eax,%eax
  800804:	78 1f                	js     800825 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800809:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80080d:	74 1b                	je     80082a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80080f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800812:	8b 52 18             	mov    0x18(%edx),%edx
  800815:	85 d2                	test   %edx,%edx
  800817:	74 32                	je     80084b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	50                   	push   %eax
  800820:	ff d2                	call   *%edx
  800822:	83 c4 10             	add    $0x10,%esp
}
  800825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800828:	c9                   	leave  
  800829:	c3                   	ret    
			thisenv->env_id, fdnum);
  80082a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80082f:	8b 40 48             	mov    0x48(%eax),%eax
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	53                   	push   %ebx
  800836:	50                   	push   %eax
  800837:	68 98 22 80 00       	push   $0x802298
  80083c:	e8 2d 0d 00 00       	call   80156e <cprintf>
		return -E_INVAL;
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800849:	eb da                	jmp    800825 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80084b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800850:	eb d3                	jmp    800825 <ftruncate+0x52>

00800852 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	83 ec 14             	sub    $0x14,%esp
  800859:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085f:	50                   	push   %eax
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 81 fb ff ff       	call   8003e9 <fd_lookup>
  800868:	83 c4 08             	add    $0x8,%esp
  80086b:	85 c0                	test   %eax,%eax
  80086d:	78 4b                	js     8008ba <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800875:	50                   	push   %eax
  800876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800879:	ff 30                	pushl  (%eax)
  80087b:	e8 bf fb ff ff       	call   80043f <dev_lookup>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	85 c0                	test   %eax,%eax
  800885:	78 33                	js     8008ba <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80088e:	74 2f                	je     8008bf <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800890:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800893:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80089a:	00 00 00 
	stat->st_isdir = 0;
  80089d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008a4:	00 00 00 
	stat->st_dev = dev;
  8008a7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b4:	ff 50 14             	call   *0x14(%eax)
  8008b7:	83 c4 10             	add    $0x10,%esp
}
  8008ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    
		return -E_NOT_SUPP;
  8008bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c4:	eb f4                	jmp    8008ba <fstat+0x68>

008008c6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	6a 00                	push   $0x0
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 e7 01 00 00       	call   800abf <open>
  8008d8:	89 c3                	mov    %eax,%ebx
  8008da:	83 c4 10             	add    $0x10,%esp
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	78 1b                	js     8008fc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	50                   	push   %eax
  8008e8:	e8 65 ff ff ff       	call   800852 <fstat>
  8008ed:	89 c6                	mov    %eax,%esi
	close(fd);
  8008ef:	89 1c 24             	mov    %ebx,(%esp)
  8008f2:	e8 27 fc ff ff       	call   80051e <close>
	return r;
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	89 f3                	mov    %esi,%ebx
}
  8008fc:	89 d8                	mov    %ebx,%eax
  8008fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	56                   	push   %esi
  800909:	53                   	push   %ebx
  80090a:	89 c6                	mov    %eax,%esi
  80090c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80090e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800915:	74 27                	je     80093e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800917:	6a 07                	push   $0x7
  800919:	68 00 50 80 00       	push   $0x805000
  80091e:	56                   	push   %esi
  80091f:	ff 35 00 40 80 00    	pushl  0x804000
  800925:	e8 07 16 00 00       	call   801f31 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80092a:	83 c4 0c             	add    $0xc,%esp
  80092d:	6a 00                	push   $0x0
  80092f:	53                   	push   %ebx
  800930:	6a 00                	push   $0x0
  800932:	e8 93 15 00 00       	call   801eca <ipc_recv>
}
  800937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093a:	5b                   	pop    %ebx
  80093b:	5e                   	pop    %esi
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80093e:	83 ec 0c             	sub    $0xc,%esp
  800941:	6a 01                	push   $0x1
  800943:	e8 3d 16 00 00       	call   801f85 <ipc_find_env>
  800948:	a3 00 40 80 00       	mov    %eax,0x804000
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb c5                	jmp    800917 <fsipc+0x12>

00800952 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 40 0c             	mov    0xc(%eax),%eax
  80095e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
  800966:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80096b:	ba 00 00 00 00       	mov    $0x0,%edx
  800970:	b8 02 00 00 00       	mov    $0x2,%eax
  800975:	e8 8b ff ff ff       	call   800905 <fsipc>
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <devfile_flush>:
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 40 0c             	mov    0xc(%eax),%eax
  800988:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80098d:	ba 00 00 00 00       	mov    $0x0,%edx
  800992:	b8 06 00 00 00       	mov    $0x6,%eax
  800997:	e8 69 ff ff ff       	call   800905 <fsipc>
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <devfile_stat>:
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ae:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8009bd:	e8 43 ff ff ff       	call   800905 <fsipc>
  8009c2:	85 c0                	test   %eax,%eax
  8009c4:	78 2c                	js     8009f2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	68 00 50 80 00       	push   $0x805000
  8009ce:	53                   	push   %ebx
  8009cf:	e8 b9 11 00 00       	call   801b8d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009d4:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009df:	a1 84 50 80 00       	mov    0x805084,%eax
  8009e4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <devfile_write>:
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 0c             	sub    $0xc,%esp
  8009fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800a00:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a05:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a0a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a10:	8b 52 0c             	mov    0xc(%edx),%edx
  800a13:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a19:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a1e:	50                   	push   %eax
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	68 08 50 80 00       	push   $0x805008
  800a27:	e8 ef 12 00 00       	call   801d1b <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a31:	b8 04 00 00 00       	mov    $0x4,%eax
  800a36:	e8 ca fe ff ff       	call   800905 <fsipc>
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <devfile_read>:
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 40 0c             	mov    0xc(%eax),%eax
  800a4b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a50:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a56:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800a60:	e8 a0 fe ff ff       	call   800905 <fsipc>
  800a65:	89 c3                	mov    %eax,%ebx
  800a67:	85 c0                	test   %eax,%eax
  800a69:	78 1f                	js     800a8a <devfile_read+0x4d>
	assert(r <= n);
  800a6b:	39 f0                	cmp    %esi,%eax
  800a6d:	77 24                	ja     800a93 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a6f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a74:	7f 33                	jg     800aa9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a76:	83 ec 04             	sub    $0x4,%esp
  800a79:	50                   	push   %eax
  800a7a:	68 00 50 80 00       	push   $0x805000
  800a7f:	ff 75 0c             	pushl  0xc(%ebp)
  800a82:	e8 94 12 00 00       	call   801d1b <memmove>
	return r;
  800a87:	83 c4 10             	add    $0x10,%esp
}
  800a8a:	89 d8                	mov    %ebx,%eax
  800a8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    
	assert(r <= n);
  800a93:	68 08 23 80 00       	push   $0x802308
  800a98:	68 0f 23 80 00       	push   $0x80230f
  800a9d:	6a 7b                	push   $0x7b
  800a9f:	68 24 23 80 00       	push   $0x802324
  800aa4:	e8 ea 09 00 00       	call   801493 <_panic>
	assert(r <= PGSIZE);
  800aa9:	68 2f 23 80 00       	push   $0x80232f
  800aae:	68 0f 23 80 00       	push   $0x80230f
  800ab3:	6a 7c                	push   $0x7c
  800ab5:	68 24 23 80 00       	push   $0x802324
  800aba:	e8 d4 09 00 00       	call   801493 <_panic>

00800abf <open>:
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	83 ec 1c             	sub    $0x1c,%esp
  800ac7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800aca:	56                   	push   %esi
  800acb:	e8 86 10 00 00       	call   801b56 <strlen>
  800ad0:	83 c4 10             	add    $0x10,%esp
  800ad3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ad8:	7f 6c                	jg     800b46 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ada:	83 ec 0c             	sub    $0xc,%esp
  800add:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ae0:	50                   	push   %eax
  800ae1:	e8 b4 f8 ff ff       	call   80039a <fd_alloc>
  800ae6:	89 c3                	mov    %eax,%ebx
  800ae8:	83 c4 10             	add    $0x10,%esp
  800aeb:	85 c0                	test   %eax,%eax
  800aed:	78 3c                	js     800b2b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	56                   	push   %esi
  800af3:	68 00 50 80 00       	push   $0x805000
  800af8:	e8 90 10 00 00       	call   801b8d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b08:	b8 01 00 00 00       	mov    $0x1,%eax
  800b0d:	e8 f3 fd ff ff       	call   800905 <fsipc>
  800b12:	89 c3                	mov    %eax,%ebx
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	85 c0                	test   %eax,%eax
  800b19:	78 19                	js     800b34 <open+0x75>
	return fd2num(fd);
  800b1b:	83 ec 0c             	sub    $0xc,%esp
  800b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b21:	e8 4d f8 ff ff       	call   800373 <fd2num>
  800b26:	89 c3                	mov    %eax,%ebx
  800b28:	83 c4 10             	add    $0x10,%esp
}
  800b2b:	89 d8                	mov    %ebx,%eax
  800b2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    
		fd_close(fd, 0);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	6a 00                	push   $0x0
  800b39:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3c:	e8 54 f9 ff ff       	call   800495 <fd_close>
		return r;
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	eb e5                	jmp    800b2b <open+0x6c>
		return -E_BAD_PATH;
  800b46:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b4b:	eb de                	jmp    800b2b <open+0x6c>

00800b4d <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	b8 08 00 00 00       	mov    $0x8,%eax
  800b5d:	e8 a3 fd ff ff       	call   800905 <fsipc>
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b6a:	68 3b 23 80 00       	push   $0x80233b
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	e8 16 10 00 00       	call   801b8d <strcpy>
	return 0;
}
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <devsock_close>:
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	53                   	push   %ebx
  800b82:	83 ec 10             	sub    $0x10,%esp
  800b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800b88:	53                   	push   %ebx
  800b89:	e8 30 14 00 00       	call   801fbe <pageref>
  800b8e:	83 c4 10             	add    $0x10,%esp
		return 0;
  800b91:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800b96:	83 f8 01             	cmp    $0x1,%eax
  800b99:	74 07                	je     800ba2 <devsock_close+0x24>
}
  800b9b:	89 d0                	mov    %edx,%eax
  800b9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	ff 73 0c             	pushl  0xc(%ebx)
  800ba8:	e8 b7 02 00 00       	call   800e64 <nsipc_close>
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	eb e7                	jmp    800b9b <devsock_close+0x1d>

00800bb4 <devsock_write>:
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bba:	6a 00                	push   $0x0
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff 70 0c             	pushl  0xc(%eax)
  800bc8:	e8 74 03 00 00       	call   800f41 <nsipc_send>
}
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <devsock_read>:
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bd5:	6a 00                	push   $0x0
  800bd7:	ff 75 10             	pushl  0x10(%ebp)
  800bda:	ff 75 0c             	pushl  0xc(%ebp)
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	ff 70 0c             	pushl  0xc(%eax)
  800be3:	e8 ed 02 00 00       	call   800ed5 <nsipc_recv>
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <fd2sockid>:
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800bf0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800bf3:	52                   	push   %edx
  800bf4:	50                   	push   %eax
  800bf5:	e8 ef f7 ff ff       	call   8003e9 <fd_lookup>
  800bfa:	83 c4 10             	add    $0x10,%esp
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	78 10                	js     800c11 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c04:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800c0a:	39 08                	cmp    %ecx,(%eax)
  800c0c:	75 05                	jne    800c13 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c0e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    
		return -E_NOT_SUPP;
  800c13:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c18:	eb f7                	jmp    800c11 <fd2sockid+0x27>

00800c1a <alloc_sockfd>:
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 1c             	sub    $0x1c,%esp
  800c22:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c27:	50                   	push   %eax
  800c28:	e8 6d f7 ff ff       	call   80039a <fd_alloc>
  800c2d:	89 c3                	mov    %eax,%ebx
  800c2f:	83 c4 10             	add    $0x10,%esp
  800c32:	85 c0                	test   %eax,%eax
  800c34:	78 43                	js     800c79 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c36:	83 ec 04             	sub    $0x4,%esp
  800c39:	68 07 04 00 00       	push   $0x407
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	6a 00                	push   $0x0
  800c43:	e8 1b f5 ff ff       	call   800163 <sys_page_alloc>
  800c48:	89 c3                	mov    %eax,%ebx
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	85 c0                	test   %eax,%eax
  800c4f:	78 28                	js     800c79 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c54:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c5a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c5f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c66:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	50                   	push   %eax
  800c6d:	e8 01 f7 ff ff       	call   800373 <fd2num>
  800c72:	89 c3                	mov    %eax,%ebx
  800c74:	83 c4 10             	add    $0x10,%esp
  800c77:	eb 0c                	jmp    800c85 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c79:	83 ec 0c             	sub    $0xc,%esp
  800c7c:	56                   	push   %esi
  800c7d:	e8 e2 01 00 00       	call   800e64 <nsipc_close>
		return r;
  800c82:	83 c4 10             	add    $0x10,%esp
}
  800c85:	89 d8                	mov    %ebx,%eax
  800c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <accept>:
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	e8 4e ff ff ff       	call   800bea <fd2sockid>
  800c9c:	85 c0                	test   %eax,%eax
  800c9e:	78 1b                	js     800cbb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800ca0:	83 ec 04             	sub    $0x4,%esp
  800ca3:	ff 75 10             	pushl  0x10(%ebp)
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	50                   	push   %eax
  800caa:	e8 0e 01 00 00       	call   800dbd <nsipc_accept>
  800caf:	83 c4 10             	add    $0x10,%esp
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	78 05                	js     800cbb <accept+0x2d>
	return alloc_sockfd(r);
  800cb6:	e8 5f ff ff ff       	call   800c1a <alloc_sockfd>
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <bind>:
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	e8 1f ff ff ff       	call   800bea <fd2sockid>
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	78 12                	js     800ce1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800ccf:	83 ec 04             	sub    $0x4,%esp
  800cd2:	ff 75 10             	pushl  0x10(%ebp)
  800cd5:	ff 75 0c             	pushl  0xc(%ebp)
  800cd8:	50                   	push   %eax
  800cd9:	e8 2f 01 00 00       	call   800e0d <nsipc_bind>
  800cde:	83 c4 10             	add    $0x10,%esp
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <shutdown>:
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	e8 f9 fe ff ff       	call   800bea <fd2sockid>
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	78 0f                	js     800d04 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	e8 41 01 00 00       	call   800e42 <nsipc_shutdown>
  800d01:	83 c4 10             	add    $0x10,%esp
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <connect>:
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	e8 d6 fe ff ff       	call   800bea <fd2sockid>
  800d14:	85 c0                	test   %eax,%eax
  800d16:	78 12                	js     800d2a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d18:	83 ec 04             	sub    $0x4,%esp
  800d1b:	ff 75 10             	pushl  0x10(%ebp)
  800d1e:	ff 75 0c             	pushl  0xc(%ebp)
  800d21:	50                   	push   %eax
  800d22:	e8 57 01 00 00       	call   800e7e <nsipc_connect>
  800d27:	83 c4 10             	add    $0x10,%esp
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <listen>:
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	e8 b0 fe ff ff       	call   800bea <fd2sockid>
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	78 0f                	js     800d4d <listen+0x21>
	return nsipc_listen(r, backlog);
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	e8 69 01 00 00       	call   800eb3 <nsipc_listen>
  800d4a:	83 c4 10             	add    $0x10,%esp
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <socket>:

int
socket(int domain, int type, int protocol)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d55:	ff 75 10             	pushl  0x10(%ebp)
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	ff 75 08             	pushl  0x8(%ebp)
  800d5e:	e8 3c 02 00 00       	call   800f9f <nsipc_socket>
  800d63:	83 c4 10             	add    $0x10,%esp
  800d66:	85 c0                	test   %eax,%eax
  800d68:	78 05                	js     800d6f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d6a:	e8 ab fe ff ff       	call   800c1a <alloc_sockfd>
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	53                   	push   %ebx
  800d75:	83 ec 04             	sub    $0x4,%esp
  800d78:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d7a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d81:	74 26                	je     800da9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800d83:	6a 07                	push   $0x7
  800d85:	68 00 60 80 00       	push   $0x806000
  800d8a:	53                   	push   %ebx
  800d8b:	ff 35 04 40 80 00    	pushl  0x804004
  800d91:	e8 9b 11 00 00       	call   801f31 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800d96:	83 c4 0c             	add    $0xc,%esp
  800d99:	6a 00                	push   $0x0
  800d9b:	6a 00                	push   $0x0
  800d9d:	6a 00                	push   $0x0
  800d9f:	e8 26 11 00 00       	call   801eca <ipc_recv>
}
  800da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	6a 02                	push   $0x2
  800dae:	e8 d2 11 00 00       	call   801f85 <ipc_find_env>
  800db3:	a3 04 40 80 00       	mov    %eax,0x804004
  800db8:	83 c4 10             	add    $0x10,%esp
  800dbb:	eb c6                	jmp    800d83 <nsipc+0x12>

00800dbd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800dcd:	8b 06                	mov    (%esi),%eax
  800dcf:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800dd4:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd9:	e8 93 ff ff ff       	call   800d71 <nsipc>
  800dde:	89 c3                	mov    %eax,%ebx
  800de0:	85 c0                	test   %eax,%eax
  800de2:	78 20                	js     800e04 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	ff 35 10 60 80 00    	pushl  0x806010
  800ded:	68 00 60 80 00       	push   $0x806000
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	e8 21 0f 00 00       	call   801d1b <memmove>
		*addrlen = ret->ret_addrlen;
  800dfa:	a1 10 60 80 00       	mov    0x806010,%eax
  800dff:	89 06                	mov    %eax,(%esi)
  800e01:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800e04:	89 d8                	mov    %ebx,%eax
  800e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	53                   	push   %ebx
  800e11:	83 ec 08             	sub    $0x8,%esp
  800e14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e1f:	53                   	push   %ebx
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	68 04 60 80 00       	push   $0x806004
  800e28:	e8 ee 0e 00 00       	call   801d1b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e2d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e33:	b8 02 00 00 00       	mov    $0x2,%eax
  800e38:	e8 34 ff ff ff       	call   800d71 <nsipc>
}
  800e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e58:	b8 03 00 00 00       	mov    $0x3,%eax
  800e5d:	e8 0f ff ff ff       	call   800d71 <nsipc>
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <nsipc_close>:

int
nsipc_close(int s)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e72:	b8 04 00 00 00       	mov    $0x4,%eax
  800e77:	e8 f5 fe ff ff       	call   800d71 <nsipc>
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	53                   	push   %ebx
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800e90:	53                   	push   %ebx
  800e91:	ff 75 0c             	pushl  0xc(%ebp)
  800e94:	68 04 60 80 00       	push   $0x806004
  800e99:	e8 7d 0e 00 00       	call   801d1b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800e9e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800ea4:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea9:	e8 c3 fe ff ff       	call   800d71 <nsipc>
}
  800eae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb1:	c9                   	leave  
  800eb2:	c3                   	ret    

00800eb3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ec9:	b8 06 00 00 00       	mov    $0x6,%eax
  800ece:	e8 9e fe ff ff       	call   800d71 <nsipc>
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	56                   	push   %esi
  800ed9:	53                   	push   %ebx
  800eda:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800ee5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  800eee:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800ef3:	b8 07 00 00 00       	mov    $0x7,%eax
  800ef8:	e8 74 fe ff ff       	call   800d71 <nsipc>
  800efd:	89 c3                	mov    %eax,%ebx
  800eff:	85 c0                	test   %eax,%eax
  800f01:	78 1f                	js     800f22 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800f03:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800f08:	7f 21                	jg     800f2b <nsipc_recv+0x56>
  800f0a:	39 c6                	cmp    %eax,%esi
  800f0c:	7c 1d                	jl     800f2b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f0e:	83 ec 04             	sub    $0x4,%esp
  800f11:	50                   	push   %eax
  800f12:	68 00 60 80 00       	push   $0x806000
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	e8 fc 0d 00 00       	call   801d1b <memmove>
  800f1f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f22:	89 d8                	mov    %ebx,%eax
  800f24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f2b:	68 47 23 80 00       	push   $0x802347
  800f30:	68 0f 23 80 00       	push   $0x80230f
  800f35:	6a 62                	push   $0x62
  800f37:	68 5c 23 80 00       	push   $0x80235c
  800f3c:	e8 52 05 00 00       	call   801493 <_panic>

00800f41 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	53                   	push   %ebx
  800f45:	83 ec 04             	sub    $0x4,%esp
  800f48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f53:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f59:	7f 2e                	jg     800f89 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f5b:	83 ec 04             	sub    $0x4,%esp
  800f5e:	53                   	push   %ebx
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	68 0c 60 80 00       	push   $0x80600c
  800f67:	e8 af 0d 00 00       	call   801d1b <memmove>
	nsipcbuf.send.req_size = size;
  800f6c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f72:	8b 45 14             	mov    0x14(%ebp),%eax
  800f75:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f7a:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7f:	e8 ed fd ff ff       	call   800d71 <nsipc>
}
  800f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    
	assert(size < 1600);
  800f89:	68 68 23 80 00       	push   $0x802368
  800f8e:	68 0f 23 80 00       	push   $0x80230f
  800f93:	6a 6d                	push   $0x6d
  800f95:	68 5c 23 80 00       	push   $0x80235c
  800f9a:	e8 f4 04 00 00       	call   801493 <_panic>

00800f9f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800fbd:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc2:	e8 aa fd ff ff       	call   800d71 <nsipc>
}
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    

00800fc9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
  800fce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	ff 75 08             	pushl  0x8(%ebp)
  800fd7:	e8 a7 f3 ff ff       	call   800383 <fd2data>
  800fdc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fde:	83 c4 08             	add    $0x8,%esp
  800fe1:	68 74 23 80 00       	push   $0x802374
  800fe6:	53                   	push   %ebx
  800fe7:	e8 a1 0b 00 00       	call   801b8d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fec:	8b 46 04             	mov    0x4(%esi),%eax
  800fef:	2b 06                	sub    (%esi),%eax
  800ff1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ff7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ffe:	00 00 00 
	stat->st_dev = &devpipe;
  801001:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801008:	30 80 00 
	return 0;
}
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
  801010:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	53                   	push   %ebx
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801021:	53                   	push   %ebx
  801022:	6a 00                	push   $0x0
  801024:	e8 bf f1 ff ff       	call   8001e8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801029:	89 1c 24             	mov    %ebx,(%esp)
  80102c:	e8 52 f3 ff ff       	call   800383 <fd2data>
  801031:	83 c4 08             	add    $0x8,%esp
  801034:	50                   	push   %eax
  801035:	6a 00                	push   $0x0
  801037:	e8 ac f1 ff ff       	call   8001e8 <sys_page_unmap>
}
  80103c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <_pipeisclosed>:
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 1c             	sub    $0x1c,%esp
  80104a:	89 c7                	mov    %eax,%edi
  80104c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80104e:	a1 08 40 80 00       	mov    0x804008,%eax
  801053:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	57                   	push   %edi
  80105a:	e8 5f 0f 00 00       	call   801fbe <pageref>
  80105f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801062:	89 34 24             	mov    %esi,(%esp)
  801065:	e8 54 0f 00 00       	call   801fbe <pageref>
		nn = thisenv->env_runs;
  80106a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801070:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	39 cb                	cmp    %ecx,%ebx
  801078:	74 1b                	je     801095 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80107a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80107d:	75 cf                	jne    80104e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80107f:	8b 42 58             	mov    0x58(%edx),%eax
  801082:	6a 01                	push   $0x1
  801084:	50                   	push   %eax
  801085:	53                   	push   %ebx
  801086:	68 7b 23 80 00       	push   $0x80237b
  80108b:	e8 de 04 00 00       	call   80156e <cprintf>
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	eb b9                	jmp    80104e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801095:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801098:	0f 94 c0             	sete   %al
  80109b:	0f b6 c0             	movzbl %al,%eax
}
  80109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <devpipe_write>:
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 28             	sub    $0x28,%esp
  8010af:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010b2:	56                   	push   %esi
  8010b3:	e8 cb f2 ff ff       	call   800383 <fd2data>
  8010b8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010c5:	74 4f                	je     801116 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010c7:	8b 43 04             	mov    0x4(%ebx),%eax
  8010ca:	8b 0b                	mov    (%ebx),%ecx
  8010cc:	8d 51 20             	lea    0x20(%ecx),%edx
  8010cf:	39 d0                	cmp    %edx,%eax
  8010d1:	72 14                	jb     8010e7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010d3:	89 da                	mov    %ebx,%edx
  8010d5:	89 f0                	mov    %esi,%eax
  8010d7:	e8 65 ff ff ff       	call   801041 <_pipeisclosed>
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 3a                	jne    80111a <devpipe_write+0x74>
			sys_yield();
  8010e0:	e8 5f f0 ff ff       	call   800144 <sys_yield>
  8010e5:	eb e0                	jmp    8010c7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010ee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	c1 fa 1f             	sar    $0x1f,%edx
  8010f6:	89 d1                	mov    %edx,%ecx
  8010f8:	c1 e9 1b             	shr    $0x1b,%ecx
  8010fb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010fe:	83 e2 1f             	and    $0x1f,%edx
  801101:	29 ca                	sub    %ecx,%edx
  801103:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801107:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80110b:	83 c0 01             	add    $0x1,%eax
  80110e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801111:	83 c7 01             	add    $0x1,%edi
  801114:	eb ac                	jmp    8010c2 <devpipe_write+0x1c>
	return i;
  801116:	89 f8                	mov    %edi,%eax
  801118:	eb 05                	jmp    80111f <devpipe_write+0x79>
				return 0;
  80111a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <devpipe_read>:
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	57                   	push   %edi
  80112b:	56                   	push   %esi
  80112c:	53                   	push   %ebx
  80112d:	83 ec 18             	sub    $0x18,%esp
  801130:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801133:	57                   	push   %edi
  801134:	e8 4a f2 ff ff       	call   800383 <fd2data>
  801139:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	be 00 00 00 00       	mov    $0x0,%esi
  801143:	3b 75 10             	cmp    0x10(%ebp),%esi
  801146:	74 47                	je     80118f <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801148:	8b 03                	mov    (%ebx),%eax
  80114a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80114d:	75 22                	jne    801171 <devpipe_read+0x4a>
			if (i > 0)
  80114f:	85 f6                	test   %esi,%esi
  801151:	75 14                	jne    801167 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801153:	89 da                	mov    %ebx,%edx
  801155:	89 f8                	mov    %edi,%eax
  801157:	e8 e5 fe ff ff       	call   801041 <_pipeisclosed>
  80115c:	85 c0                	test   %eax,%eax
  80115e:	75 33                	jne    801193 <devpipe_read+0x6c>
			sys_yield();
  801160:	e8 df ef ff ff       	call   800144 <sys_yield>
  801165:	eb e1                	jmp    801148 <devpipe_read+0x21>
				return i;
  801167:	89 f0                	mov    %esi,%eax
}
  801169:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801171:	99                   	cltd   
  801172:	c1 ea 1b             	shr    $0x1b,%edx
  801175:	01 d0                	add    %edx,%eax
  801177:	83 e0 1f             	and    $0x1f,%eax
  80117a:	29 d0                	sub    %edx,%eax
  80117c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801181:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801184:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801187:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80118a:	83 c6 01             	add    $0x1,%esi
  80118d:	eb b4                	jmp    801143 <devpipe_read+0x1c>
	return i;
  80118f:	89 f0                	mov    %esi,%eax
  801191:	eb d6                	jmp    801169 <devpipe_read+0x42>
				return 0;
  801193:	b8 00 00 00 00       	mov    $0x0,%eax
  801198:	eb cf                	jmp    801169 <devpipe_read+0x42>

0080119a <pipe>:
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	56                   	push   %esi
  80119e:	53                   	push   %ebx
  80119f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	e8 ef f1 ff ff       	call   80039a <fd_alloc>
  8011ab:	89 c3                	mov    %eax,%ebx
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 5b                	js     80120f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	68 07 04 00 00       	push   $0x407
  8011bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bf:	6a 00                	push   $0x0
  8011c1:	e8 9d ef ff ff       	call   800163 <sys_page_alloc>
  8011c6:	89 c3                	mov    %eax,%ebx
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	78 40                	js     80120f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011cf:	83 ec 0c             	sub    $0xc,%esp
  8011d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d5:	50                   	push   %eax
  8011d6:	e8 bf f1 ff ff       	call   80039a <fd_alloc>
  8011db:	89 c3                	mov    %eax,%ebx
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	78 1b                	js     8011ff <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	68 07 04 00 00       	push   $0x407
  8011ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ef:	6a 00                	push   $0x0
  8011f1:	e8 6d ef ff ff       	call   800163 <sys_page_alloc>
  8011f6:	89 c3                	mov    %eax,%ebx
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	79 19                	jns    801218 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	ff 75 f4             	pushl  -0xc(%ebp)
  801205:	6a 00                	push   $0x0
  801207:	e8 dc ef ff ff       	call   8001e8 <sys_page_unmap>
  80120c:	83 c4 10             	add    $0x10,%esp
}
  80120f:	89 d8                	mov    %ebx,%eax
  801211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801214:	5b                   	pop    %ebx
  801215:	5e                   	pop    %esi
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    
	va = fd2data(fd0);
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	ff 75 f4             	pushl  -0xc(%ebp)
  80121e:	e8 60 f1 ff ff       	call   800383 <fd2data>
  801223:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801225:	83 c4 0c             	add    $0xc,%esp
  801228:	68 07 04 00 00       	push   $0x407
  80122d:	50                   	push   %eax
  80122e:	6a 00                	push   $0x0
  801230:	e8 2e ef ff ff       	call   800163 <sys_page_alloc>
  801235:	89 c3                	mov    %eax,%ebx
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	0f 88 8c 00 00 00    	js     8012ce <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801242:	83 ec 0c             	sub    $0xc,%esp
  801245:	ff 75 f0             	pushl  -0x10(%ebp)
  801248:	e8 36 f1 ff ff       	call   800383 <fd2data>
  80124d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801254:	50                   	push   %eax
  801255:	6a 00                	push   $0x0
  801257:	56                   	push   %esi
  801258:	6a 00                	push   $0x0
  80125a:	e8 47 ef ff ff       	call   8001a6 <sys_page_map>
  80125f:	89 c3                	mov    %eax,%ebx
  801261:	83 c4 20             	add    $0x20,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	78 58                	js     8012c0 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801271:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801276:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801280:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801286:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	ff 75 f4             	pushl  -0xc(%ebp)
  801298:	e8 d6 f0 ff ff       	call   800373 <fd2num>
  80129d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8012a2:	83 c4 04             	add    $0x4,%esp
  8012a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8012a8:	e8 c6 f0 ff ff       	call   800373 <fd2num>
  8012ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012bb:	e9 4f ff ff ff       	jmp    80120f <pipe+0x75>
	sys_page_unmap(0, va);
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	56                   	push   %esi
  8012c4:	6a 00                	push   $0x0
  8012c6:	e8 1d ef ff ff       	call   8001e8 <sys_page_unmap>
  8012cb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012ce:	83 ec 08             	sub    $0x8,%esp
  8012d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8012d4:	6a 00                	push   $0x0
  8012d6:	e8 0d ef ff ff       	call   8001e8 <sys_page_unmap>
  8012db:	83 c4 10             	add    $0x10,%esp
  8012de:	e9 1c ff ff ff       	jmp    8011ff <pipe+0x65>

008012e3 <pipeisclosed>:
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ec:	50                   	push   %eax
  8012ed:	ff 75 08             	pushl  0x8(%ebp)
  8012f0:	e8 f4 f0 ff ff       	call   8003e9 <fd_lookup>
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 18                	js     801314 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801302:	e8 7c f0 ff ff       	call   800383 <fd2data>
	return _pipeisclosed(fd, p);
  801307:	89 c2                	mov    %eax,%edx
  801309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130c:	e8 30 fd ff ff       	call   801041 <_pipeisclosed>
  801311:	83 c4 10             	add    $0x10,%esp
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801319:	b8 00 00 00 00       	mov    $0x0,%eax
  80131e:	5d                   	pop    %ebp
  80131f:	c3                   	ret    

00801320 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801326:	68 93 23 80 00       	push   $0x802393
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 5a 08 00 00       	call   801b8d <strcpy>
	return 0;
}
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <devcons_write>:
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	57                   	push   %edi
  80133e:	56                   	push   %esi
  80133f:	53                   	push   %ebx
  801340:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801346:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80134b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801351:	eb 2f                	jmp    801382 <devcons_write+0x48>
		m = n - tot;
  801353:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801356:	29 f3                	sub    %esi,%ebx
  801358:	83 fb 7f             	cmp    $0x7f,%ebx
  80135b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801360:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	53                   	push   %ebx
  801367:	89 f0                	mov    %esi,%eax
  801369:	03 45 0c             	add    0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	57                   	push   %edi
  80136e:	e8 a8 09 00 00       	call   801d1b <memmove>
		sys_cputs(buf, m);
  801373:	83 c4 08             	add    $0x8,%esp
  801376:	53                   	push   %ebx
  801377:	57                   	push   %edi
  801378:	e8 2a ed ff ff       	call   8000a7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80137d:	01 de                	add    %ebx,%esi
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	3b 75 10             	cmp    0x10(%ebp),%esi
  801385:	72 cc                	jb     801353 <devcons_write+0x19>
}
  801387:	89 f0                	mov    %esi,%eax
  801389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5f                   	pop    %edi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    

00801391 <devcons_read>:
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80139c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a0:	75 07                	jne    8013a9 <devcons_read+0x18>
}
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    
		sys_yield();
  8013a4:	e8 9b ed ff ff       	call   800144 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013a9:	e8 17 ed ff ff       	call   8000c5 <sys_cgetc>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	74 f2                	je     8013a4 <devcons_read+0x13>
	if (c < 0)
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 ec                	js     8013a2 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013b6:	83 f8 04             	cmp    $0x4,%eax
  8013b9:	74 0c                	je     8013c7 <devcons_read+0x36>
	*(char*)vbuf = c;
  8013bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013be:	88 02                	mov    %al,(%edx)
	return 1;
  8013c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8013c5:	eb db                	jmp    8013a2 <devcons_read+0x11>
		return 0;
  8013c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cc:	eb d4                	jmp    8013a2 <devcons_read+0x11>

008013ce <cputchar>:
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013da:	6a 01                	push   $0x1
  8013dc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013df:	50                   	push   %eax
  8013e0:	e8 c2 ec ff ff       	call   8000a7 <sys_cputs>
}
  8013e5:	83 c4 10             	add    $0x10,%esp
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <getchar>:
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013f0:	6a 01                	push   $0x1
  8013f2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013f5:	50                   	push   %eax
  8013f6:	6a 00                	push   $0x0
  8013f8:	e8 5d f2 ff ff       	call   80065a <read>
	if (r < 0)
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 08                	js     80140c <getchar+0x22>
	if (r < 1)
  801404:	85 c0                	test   %eax,%eax
  801406:	7e 06                	jle    80140e <getchar+0x24>
	return c;
  801408:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    
		return -E_EOF;
  80140e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801413:	eb f7                	jmp    80140c <getchar+0x22>

00801415 <iscons>:
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80141b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141e:	50                   	push   %eax
  80141f:	ff 75 08             	pushl  0x8(%ebp)
  801422:	e8 c2 ef ff ff       	call   8003e9 <fd_lookup>
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 11                	js     80143f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80142e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801431:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801437:	39 10                	cmp    %edx,(%eax)
  801439:	0f 94 c0             	sete   %al
  80143c:	0f b6 c0             	movzbl %al,%eax
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <opencons>:
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801447:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144a:	50                   	push   %eax
  80144b:	e8 4a ef ff ff       	call   80039a <fd_alloc>
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	78 3a                	js     801491 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	68 07 04 00 00       	push   $0x407
  80145f:	ff 75 f4             	pushl  -0xc(%ebp)
  801462:	6a 00                	push   $0x0
  801464:	e8 fa ec ff ff       	call   800163 <sys_page_alloc>
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 21                	js     801491 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801473:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801479:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	50                   	push   %eax
  801489:	e8 e5 ee ff ff       	call   800373 <fd2num>
  80148e:	83 c4 10             	add    $0x10,%esp
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	56                   	push   %esi
  801497:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801498:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80149b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014a1:	e8 7f ec ff ff       	call   800125 <sys_getenvid>
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	ff 75 08             	pushl  0x8(%ebp)
  8014af:	56                   	push   %esi
  8014b0:	50                   	push   %eax
  8014b1:	68 a0 23 80 00       	push   $0x8023a0
  8014b6:	e8 b3 00 00 00       	call   80156e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014bb:	83 c4 18             	add    $0x18,%esp
  8014be:	53                   	push   %ebx
  8014bf:	ff 75 10             	pushl  0x10(%ebp)
  8014c2:	e8 56 00 00 00       	call   80151d <vcprintf>
	cprintf("\n");
  8014c7:	c7 04 24 8c 23 80 00 	movl   $0x80238c,(%esp)
  8014ce:	e8 9b 00 00 00       	call   80156e <cprintf>
  8014d3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014d6:	cc                   	int3   
  8014d7:	eb fd                	jmp    8014d6 <_panic+0x43>

008014d9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	53                   	push   %ebx
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014e3:	8b 13                	mov    (%ebx),%edx
  8014e5:	8d 42 01             	lea    0x1(%edx),%eax
  8014e8:	89 03                	mov    %eax,(%ebx)
  8014ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ed:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014f1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014f6:	74 09                	je     801501 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014f8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801501:	83 ec 08             	sub    $0x8,%esp
  801504:	68 ff 00 00 00       	push   $0xff
  801509:	8d 43 08             	lea    0x8(%ebx),%eax
  80150c:	50                   	push   %eax
  80150d:	e8 95 eb ff ff       	call   8000a7 <sys_cputs>
		b->idx = 0;
  801512:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	eb db                	jmp    8014f8 <putch+0x1f>

0080151d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801526:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80152d:	00 00 00 
	b.cnt = 0;
  801530:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801537:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80153a:	ff 75 0c             	pushl  0xc(%ebp)
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	68 d9 14 80 00       	push   $0x8014d9
  80154c:	e8 1a 01 00 00       	call   80166b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801551:	83 c4 08             	add    $0x8,%esp
  801554:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80155a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801560:	50                   	push   %eax
  801561:	e8 41 eb ff ff       	call   8000a7 <sys_cputs>

	return b.cnt;
}
  801566:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801574:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801577:	50                   	push   %eax
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 9d ff ff ff       	call   80151d <vcprintf>
	va_end(ap);

	return cnt;
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	57                   	push   %edi
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	83 ec 1c             	sub    $0x1c,%esp
  80158b:	89 c7                	mov    %eax,%edi
  80158d:	89 d6                	mov    %edx,%esi
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8b 55 0c             	mov    0xc(%ebp),%edx
  801595:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801598:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80159b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015a6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015a9:	39 d3                	cmp    %edx,%ebx
  8015ab:	72 05                	jb     8015b2 <printnum+0x30>
  8015ad:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015b0:	77 7a                	ja     80162c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015b2:	83 ec 0c             	sub    $0xc,%esp
  8015b5:	ff 75 18             	pushl  0x18(%ebp)
  8015b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015be:	53                   	push   %ebx
  8015bf:	ff 75 10             	pushl  0x10(%ebp)
  8015c2:	83 ec 08             	sub    $0x8,%esp
  8015c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8015cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8015ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8015d1:	e8 2a 0a 00 00       	call   802000 <__udivdi3>
  8015d6:	83 c4 18             	add    $0x18,%esp
  8015d9:	52                   	push   %edx
  8015da:	50                   	push   %eax
  8015db:	89 f2                	mov    %esi,%edx
  8015dd:	89 f8                	mov    %edi,%eax
  8015df:	e8 9e ff ff ff       	call   801582 <printnum>
  8015e4:	83 c4 20             	add    $0x20,%esp
  8015e7:	eb 13                	jmp    8015fc <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	56                   	push   %esi
  8015ed:	ff 75 18             	pushl  0x18(%ebp)
  8015f0:	ff d7                	call   *%edi
  8015f2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015f5:	83 eb 01             	sub    $0x1,%ebx
  8015f8:	85 db                	test   %ebx,%ebx
  8015fa:	7f ed                	jg     8015e9 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	56                   	push   %esi
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	ff 75 e4             	pushl  -0x1c(%ebp)
  801606:	ff 75 e0             	pushl  -0x20(%ebp)
  801609:	ff 75 dc             	pushl  -0x24(%ebp)
  80160c:	ff 75 d8             	pushl  -0x28(%ebp)
  80160f:	e8 0c 0b 00 00       	call   802120 <__umoddi3>
  801614:	83 c4 14             	add    $0x14,%esp
  801617:	0f be 80 c3 23 80 00 	movsbl 0x8023c3(%eax),%eax
  80161e:	50                   	push   %eax
  80161f:	ff d7                	call   *%edi
}
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801627:	5b                   	pop    %ebx
  801628:	5e                   	pop    %esi
  801629:	5f                   	pop    %edi
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    
  80162c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162f:	eb c4                	jmp    8015f5 <printnum+0x73>

00801631 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801637:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80163b:	8b 10                	mov    (%eax),%edx
  80163d:	3b 50 04             	cmp    0x4(%eax),%edx
  801640:	73 0a                	jae    80164c <sprintputch+0x1b>
		*b->buf++ = ch;
  801642:	8d 4a 01             	lea    0x1(%edx),%ecx
  801645:	89 08                	mov    %ecx,(%eax)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	88 02                	mov    %al,(%edx)
}
  80164c:	5d                   	pop    %ebp
  80164d:	c3                   	ret    

0080164e <printfmt>:
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801654:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801657:	50                   	push   %eax
  801658:	ff 75 10             	pushl  0x10(%ebp)
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	e8 05 00 00 00       	call   80166b <vprintfmt>
}
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <vprintfmt>:
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	57                   	push   %edi
  80166f:	56                   	push   %esi
  801670:	53                   	push   %ebx
  801671:	83 ec 2c             	sub    $0x2c,%esp
  801674:	8b 75 08             	mov    0x8(%ebp),%esi
  801677:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80167a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80167d:	e9 c1 03 00 00       	jmp    801a43 <vprintfmt+0x3d8>
		padc = ' ';
  801682:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801686:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80168d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801694:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80169b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016a0:	8d 47 01             	lea    0x1(%edi),%eax
  8016a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016a6:	0f b6 17             	movzbl (%edi),%edx
  8016a9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016ac:	3c 55                	cmp    $0x55,%al
  8016ae:	0f 87 12 04 00 00    	ja     801ac6 <vprintfmt+0x45b>
  8016b4:	0f b6 c0             	movzbl %al,%eax
  8016b7:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  8016be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016c1:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016c5:	eb d9                	jmp    8016a0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016ca:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016ce:	eb d0                	jmp    8016a0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016d0:	0f b6 d2             	movzbl %dl,%edx
  8016d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016de:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016e1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016e5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016e8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016eb:	83 f9 09             	cmp    $0x9,%ecx
  8016ee:	77 55                	ja     801745 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016f0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016f3:	eb e9                	jmp    8016de <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f8:	8b 00                	mov    (%eax),%eax
  8016fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8016fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801700:	8d 40 04             	lea    0x4(%eax),%eax
  801703:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801706:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801709:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80170d:	79 91                	jns    8016a0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80170f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801712:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801715:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80171c:	eb 82                	jmp    8016a0 <vprintfmt+0x35>
  80171e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801721:	85 c0                	test   %eax,%eax
  801723:	ba 00 00 00 00       	mov    $0x0,%edx
  801728:	0f 49 d0             	cmovns %eax,%edx
  80172b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80172e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801731:	e9 6a ff ff ff       	jmp    8016a0 <vprintfmt+0x35>
  801736:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801739:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801740:	e9 5b ff ff ff       	jmp    8016a0 <vprintfmt+0x35>
  801745:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801748:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80174b:	eb bc                	jmp    801709 <vprintfmt+0x9e>
			lflag++;
  80174d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801750:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801753:	e9 48 ff ff ff       	jmp    8016a0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801758:	8b 45 14             	mov    0x14(%ebp),%eax
  80175b:	8d 78 04             	lea    0x4(%eax),%edi
  80175e:	83 ec 08             	sub    $0x8,%esp
  801761:	53                   	push   %ebx
  801762:	ff 30                	pushl  (%eax)
  801764:	ff d6                	call   *%esi
			break;
  801766:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801769:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80176c:	e9 cf 02 00 00       	jmp    801a40 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8d 78 04             	lea    0x4(%eax),%edi
  801777:	8b 00                	mov    (%eax),%eax
  801779:	99                   	cltd   
  80177a:	31 d0                	xor    %edx,%eax
  80177c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80177e:	83 f8 0f             	cmp    $0xf,%eax
  801781:	7f 23                	jg     8017a6 <vprintfmt+0x13b>
  801783:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  80178a:	85 d2                	test   %edx,%edx
  80178c:	74 18                	je     8017a6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80178e:	52                   	push   %edx
  80178f:	68 21 23 80 00       	push   $0x802321
  801794:	53                   	push   %ebx
  801795:	56                   	push   %esi
  801796:	e8 b3 fe ff ff       	call   80164e <printfmt>
  80179b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80179e:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017a1:	e9 9a 02 00 00       	jmp    801a40 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8017a6:	50                   	push   %eax
  8017a7:	68 db 23 80 00       	push   $0x8023db
  8017ac:	53                   	push   %ebx
  8017ad:	56                   	push   %esi
  8017ae:	e8 9b fe ff ff       	call   80164e <printfmt>
  8017b3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017b6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017b9:	e9 82 02 00 00       	jmp    801a40 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017be:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c1:	83 c0 04             	add    $0x4,%eax
  8017c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ca:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017cc:	85 ff                	test   %edi,%edi
  8017ce:	b8 d4 23 80 00       	mov    $0x8023d4,%eax
  8017d3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017da:	0f 8e bd 00 00 00    	jle    80189d <vprintfmt+0x232>
  8017e0:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017e4:	75 0e                	jne    8017f4 <vprintfmt+0x189>
  8017e6:	89 75 08             	mov    %esi,0x8(%ebp)
  8017e9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017ec:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017ef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017f2:	eb 6d                	jmp    801861 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	ff 75 d0             	pushl  -0x30(%ebp)
  8017fa:	57                   	push   %edi
  8017fb:	e8 6e 03 00 00       	call   801b6e <strnlen>
  801800:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801803:	29 c1                	sub    %eax,%ecx
  801805:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801808:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80180b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80180f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801812:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801815:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801817:	eb 0f                	jmp    801828 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	53                   	push   %ebx
  80181d:	ff 75 e0             	pushl  -0x20(%ebp)
  801820:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801822:	83 ef 01             	sub    $0x1,%edi
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 ff                	test   %edi,%edi
  80182a:	7f ed                	jg     801819 <vprintfmt+0x1ae>
  80182c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80182f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801832:	85 c9                	test   %ecx,%ecx
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
  801839:	0f 49 c1             	cmovns %ecx,%eax
  80183c:	29 c1                	sub    %eax,%ecx
  80183e:	89 75 08             	mov    %esi,0x8(%ebp)
  801841:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801844:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801847:	89 cb                	mov    %ecx,%ebx
  801849:	eb 16                	jmp    801861 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80184b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80184f:	75 31                	jne    801882 <vprintfmt+0x217>
					putch(ch, putdat);
  801851:	83 ec 08             	sub    $0x8,%esp
  801854:	ff 75 0c             	pushl  0xc(%ebp)
  801857:	50                   	push   %eax
  801858:	ff 55 08             	call   *0x8(%ebp)
  80185b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80185e:	83 eb 01             	sub    $0x1,%ebx
  801861:	83 c7 01             	add    $0x1,%edi
  801864:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801868:	0f be c2             	movsbl %dl,%eax
  80186b:	85 c0                	test   %eax,%eax
  80186d:	74 59                	je     8018c8 <vprintfmt+0x25d>
  80186f:	85 f6                	test   %esi,%esi
  801871:	78 d8                	js     80184b <vprintfmt+0x1e0>
  801873:	83 ee 01             	sub    $0x1,%esi
  801876:	79 d3                	jns    80184b <vprintfmt+0x1e0>
  801878:	89 df                	mov    %ebx,%edi
  80187a:	8b 75 08             	mov    0x8(%ebp),%esi
  80187d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801880:	eb 37                	jmp    8018b9 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801882:	0f be d2             	movsbl %dl,%edx
  801885:	83 ea 20             	sub    $0x20,%edx
  801888:	83 fa 5e             	cmp    $0x5e,%edx
  80188b:	76 c4                	jbe    801851 <vprintfmt+0x1e6>
					putch('?', putdat);
  80188d:	83 ec 08             	sub    $0x8,%esp
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	6a 3f                	push   $0x3f
  801895:	ff 55 08             	call   *0x8(%ebp)
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	eb c1                	jmp    80185e <vprintfmt+0x1f3>
  80189d:	89 75 08             	mov    %esi,0x8(%ebp)
  8018a0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018a3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8018a6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018a9:	eb b6                	jmp    801861 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	53                   	push   %ebx
  8018af:	6a 20                	push   $0x20
  8018b1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018b3:	83 ef 01             	sub    $0x1,%edi
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	85 ff                	test   %edi,%edi
  8018bb:	7f ee                	jg     8018ab <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8018c3:	e9 78 01 00 00       	jmp    801a40 <vprintfmt+0x3d5>
  8018c8:	89 df                	mov    %ebx,%edi
  8018ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8018cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018d0:	eb e7                	jmp    8018b9 <vprintfmt+0x24e>
	if (lflag >= 2)
  8018d2:	83 f9 01             	cmp    $0x1,%ecx
  8018d5:	7e 3f                	jle    801916 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018da:	8b 50 04             	mov    0x4(%eax),%edx
  8018dd:	8b 00                	mov    (%eax),%eax
  8018df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e8:	8d 40 08             	lea    0x8(%eax),%eax
  8018eb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018f2:	79 5c                	jns    801950 <vprintfmt+0x2e5>
				putch('-', putdat);
  8018f4:	83 ec 08             	sub    $0x8,%esp
  8018f7:	53                   	push   %ebx
  8018f8:	6a 2d                	push   $0x2d
  8018fa:	ff d6                	call   *%esi
				num = -(long long) num;
  8018fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018ff:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801902:	f7 da                	neg    %edx
  801904:	83 d1 00             	adc    $0x0,%ecx
  801907:	f7 d9                	neg    %ecx
  801909:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80190c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801911:	e9 10 01 00 00       	jmp    801a26 <vprintfmt+0x3bb>
	else if (lflag)
  801916:	85 c9                	test   %ecx,%ecx
  801918:	75 1b                	jne    801935 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80191a:	8b 45 14             	mov    0x14(%ebp),%eax
  80191d:	8b 00                	mov    (%eax),%eax
  80191f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801922:	89 c1                	mov    %eax,%ecx
  801924:	c1 f9 1f             	sar    $0x1f,%ecx
  801927:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80192a:	8b 45 14             	mov    0x14(%ebp),%eax
  80192d:	8d 40 04             	lea    0x4(%eax),%eax
  801930:	89 45 14             	mov    %eax,0x14(%ebp)
  801933:	eb b9                	jmp    8018ee <vprintfmt+0x283>
		return va_arg(*ap, long);
  801935:	8b 45 14             	mov    0x14(%ebp),%eax
  801938:	8b 00                	mov    (%eax),%eax
  80193a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80193d:	89 c1                	mov    %eax,%ecx
  80193f:	c1 f9 1f             	sar    $0x1f,%ecx
  801942:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801945:	8b 45 14             	mov    0x14(%ebp),%eax
  801948:	8d 40 04             	lea    0x4(%eax),%eax
  80194b:	89 45 14             	mov    %eax,0x14(%ebp)
  80194e:	eb 9e                	jmp    8018ee <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801950:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801953:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801956:	b8 0a 00 00 00       	mov    $0xa,%eax
  80195b:	e9 c6 00 00 00       	jmp    801a26 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801960:	83 f9 01             	cmp    $0x1,%ecx
  801963:	7e 18                	jle    80197d <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801965:	8b 45 14             	mov    0x14(%ebp),%eax
  801968:	8b 10                	mov    (%eax),%edx
  80196a:	8b 48 04             	mov    0x4(%eax),%ecx
  80196d:	8d 40 08             	lea    0x8(%eax),%eax
  801970:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801973:	b8 0a 00 00 00       	mov    $0xa,%eax
  801978:	e9 a9 00 00 00       	jmp    801a26 <vprintfmt+0x3bb>
	else if (lflag)
  80197d:	85 c9                	test   %ecx,%ecx
  80197f:	75 1a                	jne    80199b <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  801981:	8b 45 14             	mov    0x14(%ebp),%eax
  801984:	8b 10                	mov    (%eax),%edx
  801986:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198b:	8d 40 04             	lea    0x4(%eax),%eax
  80198e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801991:	b8 0a 00 00 00       	mov    $0xa,%eax
  801996:	e9 8b 00 00 00       	jmp    801a26 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80199b:	8b 45 14             	mov    0x14(%ebp),%eax
  80199e:	8b 10                	mov    (%eax),%edx
  8019a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a5:	8d 40 04             	lea    0x4(%eax),%eax
  8019a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b0:	eb 74                	jmp    801a26 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019b2:	83 f9 01             	cmp    $0x1,%ecx
  8019b5:	7e 15                	jle    8019cc <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 10                	mov    (%eax),%edx
  8019bc:	8b 48 04             	mov    0x4(%eax),%ecx
  8019bf:	8d 40 08             	lea    0x8(%eax),%eax
  8019c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ca:	eb 5a                	jmp    801a26 <vprintfmt+0x3bb>
	else if (lflag)
  8019cc:	85 c9                	test   %ecx,%ecx
  8019ce:	75 17                	jne    8019e7 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d3:	8b 10                	mov    (%eax),%edx
  8019d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019da:	8d 40 04             	lea    0x4(%eax),%eax
  8019dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e5:	eb 3f                	jmp    801a26 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ea:	8b 10                	mov    (%eax),%edx
  8019ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f1:	8d 40 04             	lea    0x4(%eax),%eax
  8019f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8019fc:	eb 28                	jmp    801a26 <vprintfmt+0x3bb>
			putch('0', putdat);
  8019fe:	83 ec 08             	sub    $0x8,%esp
  801a01:	53                   	push   %ebx
  801a02:	6a 30                	push   $0x30
  801a04:	ff d6                	call   *%esi
			putch('x', putdat);
  801a06:	83 c4 08             	add    $0x8,%esp
  801a09:	53                   	push   %ebx
  801a0a:	6a 78                	push   $0x78
  801a0c:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a11:	8b 10                	mov    (%eax),%edx
  801a13:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a18:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a1b:	8d 40 04             	lea    0x4(%eax),%eax
  801a1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a21:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a26:	83 ec 0c             	sub    $0xc,%esp
  801a29:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a2d:	57                   	push   %edi
  801a2e:	ff 75 e0             	pushl  -0x20(%ebp)
  801a31:	50                   	push   %eax
  801a32:	51                   	push   %ecx
  801a33:	52                   	push   %edx
  801a34:	89 da                	mov    %ebx,%edx
  801a36:	89 f0                	mov    %esi,%eax
  801a38:	e8 45 fb ff ff       	call   801582 <printnum>
			break;
  801a3d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a43:	83 c7 01             	add    $0x1,%edi
  801a46:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a4a:	83 f8 25             	cmp    $0x25,%eax
  801a4d:	0f 84 2f fc ff ff    	je     801682 <vprintfmt+0x17>
			if (ch == '\0')
  801a53:	85 c0                	test   %eax,%eax
  801a55:	0f 84 8b 00 00 00    	je     801ae6 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	53                   	push   %ebx
  801a5f:	50                   	push   %eax
  801a60:	ff d6                	call   *%esi
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	eb dc                	jmp    801a43 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a67:	83 f9 01             	cmp    $0x1,%ecx
  801a6a:	7e 15                	jle    801a81 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6f:	8b 10                	mov    (%eax),%edx
  801a71:	8b 48 04             	mov    0x4(%eax),%ecx
  801a74:	8d 40 08             	lea    0x8(%eax),%eax
  801a77:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a7a:	b8 10 00 00 00       	mov    $0x10,%eax
  801a7f:	eb a5                	jmp    801a26 <vprintfmt+0x3bb>
	else if (lflag)
  801a81:	85 c9                	test   %ecx,%ecx
  801a83:	75 17                	jne    801a9c <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a85:	8b 45 14             	mov    0x14(%ebp),%eax
  801a88:	8b 10                	mov    (%eax),%edx
  801a8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8f:	8d 40 04             	lea    0x4(%eax),%eax
  801a92:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a95:	b8 10 00 00 00       	mov    $0x10,%eax
  801a9a:	eb 8a                	jmp    801a26 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9f:	8b 10                	mov    (%eax),%edx
  801aa1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa6:	8d 40 04             	lea    0x4(%eax),%eax
  801aa9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aac:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab1:	e9 70 ff ff ff       	jmp    801a26 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	53                   	push   %ebx
  801aba:	6a 25                	push   $0x25
  801abc:	ff d6                	call   *%esi
			break;
  801abe:	83 c4 10             	add    $0x10,%esp
  801ac1:	e9 7a ff ff ff       	jmp    801a40 <vprintfmt+0x3d5>
			putch('%', putdat);
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	53                   	push   %ebx
  801aca:	6a 25                	push   $0x25
  801acc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	89 f8                	mov    %edi,%eax
  801ad3:	eb 03                	jmp    801ad8 <vprintfmt+0x46d>
  801ad5:	83 e8 01             	sub    $0x1,%eax
  801ad8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801adc:	75 f7                	jne    801ad5 <vprintfmt+0x46a>
  801ade:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ae1:	e9 5a ff ff ff       	jmp    801a40 <vprintfmt+0x3d5>
}
  801ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5e                   	pop    %esi
  801aeb:	5f                   	pop    %edi
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    

00801aee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 18             	sub    $0x18,%esp
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801afa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801afd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b01:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	74 26                	je     801b35 <vsnprintf+0x47>
  801b0f:	85 d2                	test   %edx,%edx
  801b11:	7e 22                	jle    801b35 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b13:	ff 75 14             	pushl  0x14(%ebp)
  801b16:	ff 75 10             	pushl  0x10(%ebp)
  801b19:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b1c:	50                   	push   %eax
  801b1d:	68 31 16 80 00       	push   $0x801631
  801b22:	e8 44 fb ff ff       	call   80166b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	83 c4 10             	add    $0x10,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    
		return -E_INVAL;
  801b35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3a:	eb f7                	jmp    801b33 <vsnprintf+0x45>

00801b3c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b42:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b45:	50                   	push   %eax
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	e8 9a ff ff ff       	call   801aee <vsnprintf>
	va_end(ap);

	return rc;
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b61:	eb 03                	jmp    801b66 <strlen+0x10>
		n++;
  801b63:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b66:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b6a:	75 f7                	jne    801b63 <strlen+0xd>
	return n;
}
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    

00801b6e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b74:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 03                	jmp    801b81 <strnlen+0x13>
		n++;
  801b7e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b81:	39 d0                	cmp    %edx,%eax
  801b83:	74 06                	je     801b8b <strnlen+0x1d>
  801b85:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801b89:	75 f3                	jne    801b7e <strnlen+0x10>
	return n;
}
  801b8b:	5d                   	pop    %ebp
  801b8c:	c3                   	ret    

00801b8d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	53                   	push   %ebx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b97:	89 c2                	mov    %eax,%edx
  801b99:	83 c1 01             	add    $0x1,%ecx
  801b9c:	83 c2 01             	add    $0x1,%edx
  801b9f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801ba3:	88 5a ff             	mov    %bl,-0x1(%edx)
  801ba6:	84 db                	test   %bl,%bl
  801ba8:	75 ef                	jne    801b99 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801baa:	5b                   	pop    %ebx
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    

00801bad <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	53                   	push   %ebx
  801bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bb4:	53                   	push   %ebx
  801bb5:	e8 9c ff ff ff       	call   801b56 <strlen>
  801bba:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	01 d8                	add    %ebx,%eax
  801bc2:	50                   	push   %eax
  801bc3:	e8 c5 ff ff ff       	call   801b8d <strcpy>
	return dst;
}
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	8b 75 08             	mov    0x8(%ebp),%esi
  801bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bda:	89 f3                	mov    %esi,%ebx
  801bdc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bdf:	89 f2                	mov    %esi,%edx
  801be1:	eb 0f                	jmp    801bf2 <strncpy+0x23>
		*dst++ = *src;
  801be3:	83 c2 01             	add    $0x1,%edx
  801be6:	0f b6 01             	movzbl (%ecx),%eax
  801be9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bec:	80 39 01             	cmpb   $0x1,(%ecx)
  801bef:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801bf2:	39 da                	cmp    %ebx,%edx
  801bf4:	75 ed                	jne    801be3 <strncpy+0x14>
	}
	return ret;
}
  801bf6:	89 f0                	mov    %esi,%eax
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    

00801bfc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	56                   	push   %esi
  801c00:	53                   	push   %ebx
  801c01:	8b 75 08             	mov    0x8(%ebp),%esi
  801c04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0a:	89 f0                	mov    %esi,%eax
  801c0c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c10:	85 c9                	test   %ecx,%ecx
  801c12:	75 0b                	jne    801c1f <strlcpy+0x23>
  801c14:	eb 17                	jmp    801c2d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c16:	83 c2 01             	add    $0x1,%edx
  801c19:	83 c0 01             	add    $0x1,%eax
  801c1c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c1f:	39 d8                	cmp    %ebx,%eax
  801c21:	74 07                	je     801c2a <strlcpy+0x2e>
  801c23:	0f b6 0a             	movzbl (%edx),%ecx
  801c26:	84 c9                	test   %cl,%cl
  801c28:	75 ec                	jne    801c16 <strlcpy+0x1a>
		*dst = '\0';
  801c2a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c2d:	29 f0                	sub    %esi,%eax
}
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5d                   	pop    %ebp
  801c32:	c3                   	ret    

00801c33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c39:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c3c:	eb 06                	jmp    801c44 <strcmp+0x11>
		p++, q++;
  801c3e:	83 c1 01             	add    $0x1,%ecx
  801c41:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c44:	0f b6 01             	movzbl (%ecx),%eax
  801c47:	84 c0                	test   %al,%al
  801c49:	74 04                	je     801c4f <strcmp+0x1c>
  801c4b:	3a 02                	cmp    (%edx),%al
  801c4d:	74 ef                	je     801c3e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c4f:	0f b6 c0             	movzbl %al,%eax
  801c52:	0f b6 12             	movzbl (%edx),%edx
  801c55:	29 d0                	sub    %edx,%eax
}
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	53                   	push   %ebx
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c68:	eb 06                	jmp    801c70 <strncmp+0x17>
		n--, p++, q++;
  801c6a:	83 c0 01             	add    $0x1,%eax
  801c6d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c70:	39 d8                	cmp    %ebx,%eax
  801c72:	74 16                	je     801c8a <strncmp+0x31>
  801c74:	0f b6 08             	movzbl (%eax),%ecx
  801c77:	84 c9                	test   %cl,%cl
  801c79:	74 04                	je     801c7f <strncmp+0x26>
  801c7b:	3a 0a                	cmp    (%edx),%cl
  801c7d:	74 eb                	je     801c6a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c7f:	0f b6 00             	movzbl (%eax),%eax
  801c82:	0f b6 12             	movzbl (%edx),%edx
  801c85:	29 d0                	sub    %edx,%eax
}
  801c87:	5b                   	pop    %ebx
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
		return 0;
  801c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8f:	eb f6                	jmp    801c87 <strncmp+0x2e>

00801c91 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c9b:	0f b6 10             	movzbl (%eax),%edx
  801c9e:	84 d2                	test   %dl,%dl
  801ca0:	74 09                	je     801cab <strchr+0x1a>
		if (*s == c)
  801ca2:	38 ca                	cmp    %cl,%dl
  801ca4:	74 0a                	je     801cb0 <strchr+0x1f>
	for (; *s; s++)
  801ca6:	83 c0 01             	add    $0x1,%eax
  801ca9:	eb f0                	jmp    801c9b <strchr+0xa>
			return (char *) s;
	return 0;
  801cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    

00801cb2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cbc:	eb 03                	jmp    801cc1 <strfind+0xf>
  801cbe:	83 c0 01             	add    $0x1,%eax
  801cc1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cc4:	38 ca                	cmp    %cl,%dl
  801cc6:	74 04                	je     801ccc <strfind+0x1a>
  801cc8:	84 d2                	test   %dl,%dl
  801cca:	75 f2                	jne    801cbe <strfind+0xc>
			break;
	return (char *) s;
}
  801ccc:	5d                   	pop    %ebp
  801ccd:	c3                   	ret    

00801cce <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	57                   	push   %edi
  801cd2:	56                   	push   %esi
  801cd3:	53                   	push   %ebx
  801cd4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cda:	85 c9                	test   %ecx,%ecx
  801cdc:	74 13                	je     801cf1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cde:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801ce4:	75 05                	jne    801ceb <memset+0x1d>
  801ce6:	f6 c1 03             	test   $0x3,%cl
  801ce9:	74 0d                	je     801cf8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cee:	fc                   	cld    
  801cef:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801cf1:	89 f8                	mov    %edi,%eax
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
		c &= 0xFF;
  801cf8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cfc:	89 d3                	mov    %edx,%ebx
  801cfe:	c1 e3 08             	shl    $0x8,%ebx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	c1 e0 18             	shl    $0x18,%eax
  801d06:	89 d6                	mov    %edx,%esi
  801d08:	c1 e6 10             	shl    $0x10,%esi
  801d0b:	09 f0                	or     %esi,%eax
  801d0d:	09 c2                	or     %eax,%edx
  801d0f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d11:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d14:	89 d0                	mov    %edx,%eax
  801d16:	fc                   	cld    
  801d17:	f3 ab                	rep stos %eax,%es:(%edi)
  801d19:	eb d6                	jmp    801cf1 <memset+0x23>

00801d1b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	57                   	push   %edi
  801d1f:	56                   	push   %esi
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d29:	39 c6                	cmp    %eax,%esi
  801d2b:	73 35                	jae    801d62 <memmove+0x47>
  801d2d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d30:	39 c2                	cmp    %eax,%edx
  801d32:	76 2e                	jbe    801d62 <memmove+0x47>
		s += n;
		d += n;
  801d34:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d37:	89 d6                	mov    %edx,%esi
  801d39:	09 fe                	or     %edi,%esi
  801d3b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d41:	74 0c                	je     801d4f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d43:	83 ef 01             	sub    $0x1,%edi
  801d46:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d49:	fd                   	std    
  801d4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d4c:	fc                   	cld    
  801d4d:	eb 21                	jmp    801d70 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d4f:	f6 c1 03             	test   $0x3,%cl
  801d52:	75 ef                	jne    801d43 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d54:	83 ef 04             	sub    $0x4,%edi
  801d57:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d5d:	fd                   	std    
  801d5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d60:	eb ea                	jmp    801d4c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d62:	89 f2                	mov    %esi,%edx
  801d64:	09 c2                	or     %eax,%edx
  801d66:	f6 c2 03             	test   $0x3,%dl
  801d69:	74 09                	je     801d74 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d6b:	89 c7                	mov    %eax,%edi
  801d6d:	fc                   	cld    
  801d6e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d70:	5e                   	pop    %esi
  801d71:	5f                   	pop    %edi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d74:	f6 c1 03             	test   $0x3,%cl
  801d77:	75 f2                	jne    801d6b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d7c:	89 c7                	mov    %eax,%edi
  801d7e:	fc                   	cld    
  801d7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d81:	eb ed                	jmp    801d70 <memmove+0x55>

00801d83 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801d86:	ff 75 10             	pushl  0x10(%ebp)
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	ff 75 08             	pushl  0x8(%ebp)
  801d8f:	e8 87 ff ff ff       	call   801d1b <memmove>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	56                   	push   %esi
  801d9a:	53                   	push   %ebx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da1:	89 c6                	mov    %eax,%esi
  801da3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801da6:	39 f0                	cmp    %esi,%eax
  801da8:	74 1c                	je     801dc6 <memcmp+0x30>
		if (*s1 != *s2)
  801daa:	0f b6 08             	movzbl (%eax),%ecx
  801dad:	0f b6 1a             	movzbl (%edx),%ebx
  801db0:	38 d9                	cmp    %bl,%cl
  801db2:	75 08                	jne    801dbc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801db4:	83 c0 01             	add    $0x1,%eax
  801db7:	83 c2 01             	add    $0x1,%edx
  801dba:	eb ea                	jmp    801da6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801dbc:	0f b6 c1             	movzbl %cl,%eax
  801dbf:	0f b6 db             	movzbl %bl,%ebx
  801dc2:	29 d8                	sub    %ebx,%eax
  801dc4:	eb 05                	jmp    801dcb <memcmp+0x35>
	}

	return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    

00801dcf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dd8:	89 c2                	mov    %eax,%edx
  801dda:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801ddd:	39 d0                	cmp    %edx,%eax
  801ddf:	73 09                	jae    801dea <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801de1:	38 08                	cmp    %cl,(%eax)
  801de3:	74 05                	je     801dea <memfind+0x1b>
	for (; s < ends; s++)
  801de5:	83 c0 01             	add    $0x1,%eax
  801de8:	eb f3                	jmp    801ddd <memfind+0xe>
			break;
	return (void *) s;
}
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	57                   	push   %edi
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801df8:	eb 03                	jmp    801dfd <strtol+0x11>
		s++;
  801dfa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801dfd:	0f b6 01             	movzbl (%ecx),%eax
  801e00:	3c 20                	cmp    $0x20,%al
  801e02:	74 f6                	je     801dfa <strtol+0xe>
  801e04:	3c 09                	cmp    $0x9,%al
  801e06:	74 f2                	je     801dfa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e08:	3c 2b                	cmp    $0x2b,%al
  801e0a:	74 2e                	je     801e3a <strtol+0x4e>
	int neg = 0;
  801e0c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e11:	3c 2d                	cmp    $0x2d,%al
  801e13:	74 2f                	je     801e44 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e15:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e1b:	75 05                	jne    801e22 <strtol+0x36>
  801e1d:	80 39 30             	cmpb   $0x30,(%ecx)
  801e20:	74 2c                	je     801e4e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e22:	85 db                	test   %ebx,%ebx
  801e24:	75 0a                	jne    801e30 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e26:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e2b:	80 39 30             	cmpb   $0x30,(%ecx)
  801e2e:	74 28                	je     801e58 <strtol+0x6c>
		base = 10;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
  801e35:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e38:	eb 50                	jmp    801e8a <strtol+0x9e>
		s++;
  801e3a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e3d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e42:	eb d1                	jmp    801e15 <strtol+0x29>
		s++, neg = 1;
  801e44:	83 c1 01             	add    $0x1,%ecx
  801e47:	bf 01 00 00 00       	mov    $0x1,%edi
  801e4c:	eb c7                	jmp    801e15 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e4e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e52:	74 0e                	je     801e62 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e54:	85 db                	test   %ebx,%ebx
  801e56:	75 d8                	jne    801e30 <strtol+0x44>
		s++, base = 8;
  801e58:	83 c1 01             	add    $0x1,%ecx
  801e5b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e60:	eb ce                	jmp    801e30 <strtol+0x44>
		s += 2, base = 16;
  801e62:	83 c1 02             	add    $0x2,%ecx
  801e65:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e6a:	eb c4                	jmp    801e30 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e6f:	89 f3                	mov    %esi,%ebx
  801e71:	80 fb 19             	cmp    $0x19,%bl
  801e74:	77 29                	ja     801e9f <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e76:	0f be d2             	movsbl %dl,%edx
  801e79:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e7c:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e7f:	7d 30                	jge    801eb1 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e81:	83 c1 01             	add    $0x1,%ecx
  801e84:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e88:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e8a:	0f b6 11             	movzbl (%ecx),%edx
  801e8d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e90:	89 f3                	mov    %esi,%ebx
  801e92:	80 fb 09             	cmp    $0x9,%bl
  801e95:	77 d5                	ja     801e6c <strtol+0x80>
			dig = *s - '0';
  801e97:	0f be d2             	movsbl %dl,%edx
  801e9a:	83 ea 30             	sub    $0x30,%edx
  801e9d:	eb dd                	jmp    801e7c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801e9f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ea2:	89 f3                	mov    %esi,%ebx
  801ea4:	80 fb 19             	cmp    $0x19,%bl
  801ea7:	77 08                	ja     801eb1 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801ea9:	0f be d2             	movsbl %dl,%edx
  801eac:	83 ea 37             	sub    $0x37,%edx
  801eaf:	eb cb                	jmp    801e7c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb5:	74 05                	je     801ebc <strtol+0xd0>
		*endptr = (char *) s;
  801eb7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eba:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ebc:	89 c2                	mov    %eax,%edx
  801ebe:	f7 da                	neg    %edx
  801ec0:	85 ff                	test   %edi,%edi
  801ec2:	0f 45 c2             	cmovne %edx,%eax
}
  801ec5:	5b                   	pop    %ebx
  801ec6:	5e                   	pop    %esi
  801ec7:	5f                   	pop    %edi
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    

00801eca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	56                   	push   %esi
  801ece:	53                   	push   %ebx
  801ecf:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801ed8:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801eda:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801edf:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	50                   	push   %eax
  801ee6:	e8 28 e4 ff ff       	call   800313 <sys_ipc_recv>
	if (from_env_store)
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	85 f6                	test   %esi,%esi
  801ef0:	74 14                	je     801f06 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	78 09                	js     801f04 <ipc_recv+0x3a>
  801efb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f01:	8b 52 74             	mov    0x74(%edx),%edx
  801f04:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f06:	85 db                	test   %ebx,%ebx
  801f08:	74 14                	je     801f1e <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 09                	js     801f1c <ipc_recv+0x52>
  801f13:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f19:	8b 52 78             	mov    0x78(%edx),%edx
  801f1c:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 08                	js     801f2a <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f22:	a1 08 40 80 00       	mov    0x804008,%eax
  801f27:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	57                   	push   %edi
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f3d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f43:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f45:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f4a:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f4d:	ff 75 14             	pushl  0x14(%ebp)
  801f50:	53                   	push   %ebx
  801f51:	56                   	push   %esi
  801f52:	57                   	push   %edi
  801f53:	e8 98 e3 ff ff       	call   8002f0 <sys_ipc_try_send>
		if (ret == 0)
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	74 1e                	je     801f7d <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f5f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f62:	75 07                	jne    801f6b <ipc_send+0x3a>
			sys_yield();
  801f64:	e8 db e1 ff ff       	call   800144 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f69:	eb e2                	jmp    801f4d <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f6b:	50                   	push   %eax
  801f6c:	68 c0 26 80 00       	push   $0x8026c0
  801f71:	6a 3d                	push   $0x3d
  801f73:	68 d4 26 80 00       	push   $0x8026d4
  801f78:	e8 16 f5 ff ff       	call   801493 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f90:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f93:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f99:	8b 52 50             	mov    0x50(%edx),%edx
  801f9c:	39 ca                	cmp    %ecx,%edx
  801f9e:	74 11                	je     801fb1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fa0:	83 c0 01             	add    $0x1,%eax
  801fa3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fa8:	75 e6                	jne    801f90 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	eb 0b                	jmp    801fbc <ipc_find_env+0x37>
			return envs[i].env_id;
  801fb1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fb4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fb9:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    

00801fbe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fc4:	89 d0                	mov    %edx,%eax
  801fc6:	c1 e8 16             	shr    $0x16,%eax
  801fc9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fd5:	f6 c1 01             	test   $0x1,%cl
  801fd8:	74 1d                	je     801ff7 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fda:	c1 ea 0c             	shr    $0xc,%edx
  801fdd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fe4:	f6 c2 01             	test   $0x1,%dl
  801fe7:	74 0e                	je     801ff7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fe9:	c1 ea 0c             	shr    $0xc,%edx
  801fec:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ff3:	ef 
  801ff4:	0f b7 c0             	movzwl %ax,%eax
}
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    
  801ff9:	66 90                	xchg   %ax,%ax
  801ffb:	66 90                	xchg   %ax,%ax
  801ffd:	66 90                	xchg   %ax,%ax
  801fff:	90                   	nop

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

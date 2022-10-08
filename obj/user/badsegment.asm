
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 ce 00 00 00       	call   80011c <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x2d>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008a:	e8 b1 04 00 00       	call   800540 <close_all>
	sys_env_destroy(0);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	6a 00                	push   $0x0
  800094:	e8 42 00 00 00       	call   8000db <sys_env_destroy>
}
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	57                   	push   %edi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	89 c7                	mov    %eax,%edi
  8000b3:	89 c6                	mov    %eax,%esi
  8000b5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    

008000bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	57                   	push   %edi
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	89 d3                	mov    %edx,%ebx
  8000d0:	89 d7                	mov    %edx,%edi
  8000d2:	89 d6                	mov    %edx,%esi
  8000d4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f1:	89 cb                	mov    %ecx,%ebx
  8000f3:	89 cf                	mov    %ecx,%edi
  8000f5:	89 ce                	mov    %ecx,%esi
  8000f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	7f 08                	jg     800105 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5f                   	pop    %edi
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	50                   	push   %eax
  800109:	6a 03                	push   $0x3
  80010b:	68 4a 22 80 00       	push   $0x80224a
  800110:	6a 23                	push   $0x23
  800112:	68 67 22 80 00       	push   $0x802267
  800117:	e8 6e 13 00 00       	call   80148a <_panic>

0080011c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	57                   	push   %edi
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
	asm volatile("int %1\n"
  800122:	ba 00 00 00 00       	mov    $0x0,%edx
  800127:	b8 02 00 00 00       	mov    $0x2,%eax
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	89 d3                	mov    %edx,%ebx
  800130:	89 d7                	mov    %edx,%edi
  800132:	89 d6                	mov    %edx,%esi
  800134:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5f                   	pop    %edi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <sys_yield>:

void
sys_yield(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	asm volatile("int %1\n"
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
  800160:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800163:	be 00 00 00 00       	mov    $0x0,%esi
  800168:	8b 55 08             	mov    0x8(%ebp),%edx
  80016b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016e:	b8 04 00 00 00       	mov    $0x4,%eax
  800173:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800176:	89 f7                	mov    %esi,%edi
  800178:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7f 08                	jg     800186 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	6a 04                	push   $0x4
  80018c:	68 4a 22 80 00       	push   $0x80224a
  800191:	6a 23                	push   $0x23
  800193:	68 67 22 80 00       	push   $0x802267
  800198:	e8 ed 12 00 00       	call   80148a <_panic>

0080019d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	57                   	push   %edi
  8001a1:	56                   	push   %esi
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001bc:	85 c0                	test   %eax,%eax
  8001be:	7f 08                	jg     8001c8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5f                   	pop    %edi
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	50                   	push   %eax
  8001cc:	6a 05                	push   $0x5
  8001ce:	68 4a 22 80 00       	push   $0x80224a
  8001d3:	6a 23                	push   $0x23
  8001d5:	68 67 22 80 00       	push   $0x802267
  8001da:	e8 ab 12 00 00       	call   80148a <_panic>

008001df <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	57                   	push   %edi
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f8:	89 df                	mov    %ebx,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fe:	85 c0                	test   %eax,%eax
  800200:	7f 08                	jg     80020a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800202:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800205:	5b                   	pop    %ebx
  800206:	5e                   	pop    %esi
  800207:	5f                   	pop    %edi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	50                   	push   %eax
  80020e:	6a 06                	push   $0x6
  800210:	68 4a 22 80 00       	push   $0x80224a
  800215:	6a 23                	push   $0x23
  800217:	68 67 22 80 00       	push   $0x802267
  80021c:	e8 69 12 00 00       	call   80148a <_panic>

00800221 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022f:	8b 55 08             	mov    0x8(%ebp),%edx
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	b8 08 00 00 00       	mov    $0x8,%eax
  80023a:	89 df                	mov    %ebx,%edi
  80023c:	89 de                	mov    %ebx,%esi
  80023e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800240:	85 c0                	test   %eax,%eax
  800242:	7f 08                	jg     80024c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	6a 08                	push   $0x8
  800252:	68 4a 22 80 00       	push   $0x80224a
  800257:	6a 23                	push   $0x23
  800259:	68 67 22 80 00       	push   $0x802267
  80025e:	e8 27 12 00 00       	call   80148a <_panic>

00800263 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800271:	8b 55 08             	mov    0x8(%ebp),%edx
  800274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800277:	b8 09 00 00 00       	mov    $0x9,%eax
  80027c:	89 df                	mov    %ebx,%edi
  80027e:	89 de                	mov    %ebx,%esi
  800280:	cd 30                	int    $0x30
	if(check && ret > 0)
  800282:	85 c0                	test   %eax,%eax
  800284:	7f 08                	jg     80028e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	6a 09                	push   $0x9
  800294:	68 4a 22 80 00       	push   $0x80224a
  800299:	6a 23                	push   $0x23
  80029b:	68 67 22 80 00       	push   $0x802267
  8002a0:	e8 e5 11 00 00       	call   80148a <_panic>

008002a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002be:	89 df                	mov    %ebx,%edi
  8002c0:	89 de                	mov    %ebx,%esi
  8002c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	7f 08                	jg     8002d0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	50                   	push   %eax
  8002d4:	6a 0a                	push   $0xa
  8002d6:	68 4a 22 80 00       	push   $0x80224a
  8002db:	6a 23                	push   $0x23
  8002dd:	68 67 22 80 00       	push   $0x802267
  8002e2:	e8 a3 11 00 00       	call   80148a <_panic>

008002e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f8:	be 00 00 00 00       	mov    $0x0,%esi
  8002fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800300:	8b 7d 14             	mov    0x14(%ebp),%edi
  800303:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800305:	5b                   	pop    %ebx
  800306:	5e                   	pop    %esi
  800307:	5f                   	pop    %edi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	57                   	push   %edi
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800313:	b9 00 00 00 00       	mov    $0x0,%ecx
  800318:	8b 55 08             	mov    0x8(%ebp),%edx
  80031b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800320:	89 cb                	mov    %ecx,%ebx
  800322:	89 cf                	mov    %ecx,%edi
  800324:	89 ce                	mov    %ecx,%esi
  800326:	cd 30                	int    $0x30
	if(check && ret > 0)
  800328:	85 c0                	test   %eax,%eax
  80032a:	7f 08                	jg     800334 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	50                   	push   %eax
  800338:	6a 0d                	push   $0xd
  80033a:	68 4a 22 80 00       	push   $0x80224a
  80033f:	6a 23                	push   $0x23
  800341:	68 67 22 80 00       	push   $0x802267
  800346:	e8 3f 11 00 00       	call   80148a <_panic>

0080034b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	57                   	push   %edi
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
	asm volatile("int %1\n"
  800351:	ba 00 00 00 00       	mov    $0x0,%edx
  800356:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035b:	89 d1                	mov    %edx,%ecx
  80035d:	89 d3                	mov    %edx,%ebx
  80035f:	89 d7                	mov    %edx,%edi
  800361:	89 d6                	mov    %edx,%esi
  800363:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800365:	5b                   	pop    %ebx
  800366:	5e                   	pop    %esi
  800367:	5f                   	pop    %edi
  800368:	5d                   	pop    %ebp
  800369:	c3                   	ret    

0080036a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	05 00 00 00 30       	add    $0x30000000,%eax
  800375:	c1 e8 0c             	shr    $0xc,%eax
}
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800397:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80039c:	89 c2                	mov    %eax,%edx
  80039e:	c1 ea 16             	shr    $0x16,%edx
  8003a1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a8:	f6 c2 01             	test   $0x1,%dl
  8003ab:	74 2a                	je     8003d7 <fd_alloc+0x46>
  8003ad:	89 c2                	mov    %eax,%edx
  8003af:	c1 ea 0c             	shr    $0xc,%edx
  8003b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b9:	f6 c2 01             	test   $0x1,%dl
  8003bc:	74 19                	je     8003d7 <fd_alloc+0x46>
  8003be:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003c3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c8:	75 d2                	jne    80039c <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003ca:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003d0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d5:	eb 07                	jmp    8003de <fd_alloc+0x4d>
			*fd_store = fd;
  8003d7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003de:	5d                   	pop    %ebp
  8003df:	c3                   	ret    

008003e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e6:	83 f8 1f             	cmp    $0x1f,%eax
  8003e9:	77 36                	ja     800421 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003eb:	c1 e0 0c             	shl    $0xc,%eax
  8003ee:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003f3:	89 c2                	mov    %eax,%edx
  8003f5:	c1 ea 16             	shr    $0x16,%edx
  8003f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ff:	f6 c2 01             	test   $0x1,%dl
  800402:	74 24                	je     800428 <fd_lookup+0x48>
  800404:	89 c2                	mov    %eax,%edx
  800406:	c1 ea 0c             	shr    $0xc,%edx
  800409:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800410:	f6 c2 01             	test   $0x1,%dl
  800413:	74 1a                	je     80042f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800415:	8b 55 0c             	mov    0xc(%ebp),%edx
  800418:	89 02                	mov    %eax,(%edx)
	return 0;
  80041a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041f:	5d                   	pop    %ebp
  800420:	c3                   	ret    
		return -E_INVAL;
  800421:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800426:	eb f7                	jmp    80041f <fd_lookup+0x3f>
		return -E_INVAL;
  800428:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042d:	eb f0                	jmp    80041f <fd_lookup+0x3f>
  80042f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800434:	eb e9                	jmp    80041f <fd_lookup+0x3f>

00800436 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043f:	ba f4 22 80 00       	mov    $0x8022f4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800444:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800449:	39 08                	cmp    %ecx,(%eax)
  80044b:	74 33                	je     800480 <dev_lookup+0x4a>
  80044d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800450:	8b 02                	mov    (%edx),%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	75 f3                	jne    800449 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800456:	a1 08 40 80 00       	mov    0x804008,%eax
  80045b:	8b 40 48             	mov    0x48(%eax),%eax
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	51                   	push   %ecx
  800462:	50                   	push   %eax
  800463:	68 78 22 80 00       	push   $0x802278
  800468:	e8 f8 10 00 00       	call   801565 <cprintf>
	*dev = 0;
  80046d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    
			*dev = devtab[i];
  800480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800483:	89 01                	mov    %eax,(%ecx)
			return 0;
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	eb f2                	jmp    80047e <dev_lookup+0x48>

0080048c <fd_close>:
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	57                   	push   %edi
  800490:	56                   	push   %esi
  800491:	53                   	push   %ebx
  800492:	83 ec 1c             	sub    $0x1c,%esp
  800495:	8b 75 08             	mov    0x8(%ebp),%esi
  800498:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80049b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80049e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80049f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a8:	50                   	push   %eax
  8004a9:	e8 32 ff ff ff       	call   8003e0 <fd_lookup>
  8004ae:	89 c3                	mov    %eax,%ebx
  8004b0:	83 c4 08             	add    $0x8,%esp
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	78 05                	js     8004bc <fd_close+0x30>
	    || fd != fd2)
  8004b7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004ba:	74 16                	je     8004d2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004bc:	89 f8                	mov    %edi,%eax
  8004be:	84 c0                	test   %al,%al
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	0f 44 d8             	cmove  %eax,%ebx
}
  8004c8:	89 d8                	mov    %ebx,%eax
  8004ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004cd:	5b                   	pop    %ebx
  8004ce:	5e                   	pop    %esi
  8004cf:	5f                   	pop    %edi
  8004d0:	5d                   	pop    %ebp
  8004d1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004d8:	50                   	push   %eax
  8004d9:	ff 36                	pushl  (%esi)
  8004db:	e8 56 ff ff ff       	call   800436 <dev_lookup>
  8004e0:	89 c3                	mov    %eax,%ebx
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	78 15                	js     8004fe <fd_close+0x72>
		if (dev->dev_close)
  8004e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ec:	8b 40 10             	mov    0x10(%eax),%eax
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	74 1b                	je     80050e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	56                   	push   %esi
  8004f7:	ff d0                	call   *%eax
  8004f9:	89 c3                	mov    %eax,%ebx
  8004fb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	56                   	push   %esi
  800502:	6a 00                	push   $0x0
  800504:	e8 d6 fc ff ff       	call   8001df <sys_page_unmap>
	return r;
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	eb ba                	jmp    8004c8 <fd_close+0x3c>
			r = 0;
  80050e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800513:	eb e9                	jmp    8004fe <fd_close+0x72>

00800515 <close>:

int
close(int fdnum)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80051b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80051e:	50                   	push   %eax
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 b9 fe ff ff       	call   8003e0 <fd_lookup>
  800527:	83 c4 08             	add    $0x8,%esp
  80052a:	85 c0                	test   %eax,%eax
  80052c:	78 10                	js     80053e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	6a 01                	push   $0x1
  800533:	ff 75 f4             	pushl  -0xc(%ebp)
  800536:	e8 51 ff ff ff       	call   80048c <fd_close>
  80053b:	83 c4 10             	add    $0x10,%esp
}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <close_all>:

void
close_all(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	53                   	push   %ebx
  800544:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800547:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	53                   	push   %ebx
  800550:	e8 c0 ff ff ff       	call   800515 <close>
	for (i = 0; i < MAXFD; i++)
  800555:	83 c3 01             	add    $0x1,%ebx
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	83 fb 20             	cmp    $0x20,%ebx
  80055e:	75 ec                	jne    80054c <close_all+0xc>
}
  800560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	57                   	push   %edi
  800569:	56                   	push   %esi
  80056a:	53                   	push   %ebx
  80056b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80056e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	ff 75 08             	pushl  0x8(%ebp)
  800575:	e8 66 fe ff ff       	call   8003e0 <fd_lookup>
  80057a:	89 c3                	mov    %eax,%ebx
  80057c:	83 c4 08             	add    $0x8,%esp
  80057f:	85 c0                	test   %eax,%eax
  800581:	0f 88 81 00 00 00    	js     800608 <dup+0xa3>
		return r;
	close(newfdnum);
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	ff 75 0c             	pushl  0xc(%ebp)
  80058d:	e8 83 ff ff ff       	call   800515 <close>

	newfd = INDEX2FD(newfdnum);
  800592:	8b 75 0c             	mov    0xc(%ebp),%esi
  800595:	c1 e6 0c             	shl    $0xc,%esi
  800598:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80059e:	83 c4 04             	add    $0x4,%esp
  8005a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a4:	e8 d1 fd ff ff       	call   80037a <fd2data>
  8005a9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005ab:	89 34 24             	mov    %esi,(%esp)
  8005ae:	e8 c7 fd ff ff       	call   80037a <fd2data>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005b8:	89 d8                	mov    %ebx,%eax
  8005ba:	c1 e8 16             	shr    $0x16,%eax
  8005bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c4:	a8 01                	test   $0x1,%al
  8005c6:	74 11                	je     8005d9 <dup+0x74>
  8005c8:	89 d8                	mov    %ebx,%eax
  8005ca:	c1 e8 0c             	shr    $0xc,%eax
  8005cd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d4:	f6 c2 01             	test   $0x1,%dl
  8005d7:	75 39                	jne    800612 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005dc:	89 d0                	mov    %edx,%eax
  8005de:	c1 e8 0c             	shr    $0xc,%eax
  8005e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e8:	83 ec 0c             	sub    $0xc,%esp
  8005eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8005f0:	50                   	push   %eax
  8005f1:	56                   	push   %esi
  8005f2:	6a 00                	push   $0x0
  8005f4:	52                   	push   %edx
  8005f5:	6a 00                	push   $0x0
  8005f7:	e8 a1 fb ff ff       	call   80019d <sys_page_map>
  8005fc:	89 c3                	mov    %eax,%ebx
  8005fe:	83 c4 20             	add    $0x20,%esp
  800601:	85 c0                	test   %eax,%eax
  800603:	78 31                	js     800636 <dup+0xd1>
		goto err;

	return newfdnum;
  800605:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800608:	89 d8                	mov    %ebx,%eax
  80060a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80060d:	5b                   	pop    %ebx
  80060e:	5e                   	pop    %esi
  80060f:	5f                   	pop    %edi
  800610:	5d                   	pop    %ebp
  800611:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800612:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	25 07 0e 00 00       	and    $0xe07,%eax
  800621:	50                   	push   %eax
  800622:	57                   	push   %edi
  800623:	6a 00                	push   $0x0
  800625:	53                   	push   %ebx
  800626:	6a 00                	push   $0x0
  800628:	e8 70 fb ff ff       	call   80019d <sys_page_map>
  80062d:	89 c3                	mov    %eax,%ebx
  80062f:	83 c4 20             	add    $0x20,%esp
  800632:	85 c0                	test   %eax,%eax
  800634:	79 a3                	jns    8005d9 <dup+0x74>
	sys_page_unmap(0, newfd);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	56                   	push   %esi
  80063a:	6a 00                	push   $0x0
  80063c:	e8 9e fb ff ff       	call   8001df <sys_page_unmap>
	sys_page_unmap(0, nva);
  800641:	83 c4 08             	add    $0x8,%esp
  800644:	57                   	push   %edi
  800645:	6a 00                	push   $0x0
  800647:	e8 93 fb ff ff       	call   8001df <sys_page_unmap>
	return r;
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	eb b7                	jmp    800608 <dup+0xa3>

00800651 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	53                   	push   %ebx
  800655:	83 ec 14             	sub    $0x14,%esp
  800658:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80065b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80065e:	50                   	push   %eax
  80065f:	53                   	push   %ebx
  800660:	e8 7b fd ff ff       	call   8003e0 <fd_lookup>
  800665:	83 c4 08             	add    $0x8,%esp
  800668:	85 c0                	test   %eax,%eax
  80066a:	78 3f                	js     8006ab <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800672:	50                   	push   %eax
  800673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800676:	ff 30                	pushl  (%eax)
  800678:	e8 b9 fd ff ff       	call   800436 <dev_lookup>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	85 c0                	test   %eax,%eax
  800682:	78 27                	js     8006ab <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800684:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800687:	8b 42 08             	mov    0x8(%edx),%eax
  80068a:	83 e0 03             	and    $0x3,%eax
  80068d:	83 f8 01             	cmp    $0x1,%eax
  800690:	74 1e                	je     8006b0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800695:	8b 40 08             	mov    0x8(%eax),%eax
  800698:	85 c0                	test   %eax,%eax
  80069a:	74 35                	je     8006d1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80069c:	83 ec 04             	sub    $0x4,%esp
  80069f:	ff 75 10             	pushl  0x10(%ebp)
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	52                   	push   %edx
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b5:	8b 40 48             	mov    0x48(%eax),%eax
  8006b8:	83 ec 04             	sub    $0x4,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	50                   	push   %eax
  8006bd:	68 b9 22 80 00       	push   $0x8022b9
  8006c2:	e8 9e 0e 00 00       	call   801565 <cprintf>
		return -E_INVAL;
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cf:	eb da                	jmp    8006ab <read+0x5a>
		return -E_NOT_SUPP;
  8006d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d6:	eb d3                	jmp    8006ab <read+0x5a>

008006d8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	57                   	push   %edi
  8006dc:	56                   	push   %esi
  8006dd:	53                   	push   %ebx
  8006de:	83 ec 0c             	sub    $0xc,%esp
  8006e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ec:	39 f3                	cmp    %esi,%ebx
  8006ee:	73 25                	jae    800715 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f0:	83 ec 04             	sub    $0x4,%esp
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	29 d8                	sub    %ebx,%eax
  8006f7:	50                   	push   %eax
  8006f8:	89 d8                	mov    %ebx,%eax
  8006fa:	03 45 0c             	add    0xc(%ebp),%eax
  8006fd:	50                   	push   %eax
  8006fe:	57                   	push   %edi
  8006ff:	e8 4d ff ff ff       	call   800651 <read>
		if (m < 0)
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	85 c0                	test   %eax,%eax
  800709:	78 08                	js     800713 <readn+0x3b>
			return m;
		if (m == 0)
  80070b:	85 c0                	test   %eax,%eax
  80070d:	74 06                	je     800715 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80070f:	01 c3                	add    %eax,%ebx
  800711:	eb d9                	jmp    8006ec <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800713:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800715:	89 d8                	mov    %ebx,%eax
  800717:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	53                   	push   %ebx
  800723:	83 ec 14             	sub    $0x14,%esp
  800726:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800729:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80072c:	50                   	push   %eax
  80072d:	53                   	push   %ebx
  80072e:	e8 ad fc ff ff       	call   8003e0 <fd_lookup>
  800733:	83 c4 08             	add    $0x8,%esp
  800736:	85 c0                	test   %eax,%eax
  800738:	78 3a                	js     800774 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800744:	ff 30                	pushl  (%eax)
  800746:	e8 eb fc ff ff       	call   800436 <dev_lookup>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 c0                	test   %eax,%eax
  800750:	78 22                	js     800774 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800755:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800759:	74 1e                	je     800779 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80075b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075e:	8b 52 0c             	mov    0xc(%edx),%edx
  800761:	85 d2                	test   %edx,%edx
  800763:	74 35                	je     80079a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	ff 75 10             	pushl  0x10(%ebp)
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	ff d2                	call   *%edx
  800771:	83 c4 10             	add    $0x10,%esp
}
  800774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800777:	c9                   	leave  
  800778:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800779:	a1 08 40 80 00       	mov    0x804008,%eax
  80077e:	8b 40 48             	mov    0x48(%eax),%eax
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	53                   	push   %ebx
  800785:	50                   	push   %eax
  800786:	68 d5 22 80 00       	push   $0x8022d5
  80078b:	e8 d5 0d 00 00       	call   801565 <cprintf>
		return -E_INVAL;
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800798:	eb da                	jmp    800774 <write+0x55>
		return -E_NOT_SUPP;
  80079a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079f:	eb d3                	jmp    800774 <write+0x55>

008007a1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a7:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 2d fc ff ff       	call   8003e0 <fd_lookup>
  8007b3:	83 c4 08             	add    $0x8,%esp
  8007b6:	85 c0                	test   %eax,%eax
  8007b8:	78 0e                	js     8007c8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007c0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	53                   	push   %ebx
  8007ce:	83 ec 14             	sub    $0x14,%esp
  8007d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d7:	50                   	push   %eax
  8007d8:	53                   	push   %ebx
  8007d9:	e8 02 fc ff ff       	call   8003e0 <fd_lookup>
  8007de:	83 c4 08             	add    $0x8,%esp
  8007e1:	85 c0                	test   %eax,%eax
  8007e3:	78 37                	js     80081c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007eb:	50                   	push   %eax
  8007ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ef:	ff 30                	pushl  (%eax)
  8007f1:	e8 40 fc ff ff       	call   800436 <dev_lookup>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	85 c0                	test   %eax,%eax
  8007fb:	78 1f                	js     80081c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800800:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800804:	74 1b                	je     800821 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800809:	8b 52 18             	mov    0x18(%edx),%edx
  80080c:	85 d2                	test   %edx,%edx
  80080e:	74 32                	je     800842 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	50                   	push   %eax
  800817:	ff d2                	call   *%edx
  800819:	83 c4 10             	add    $0x10,%esp
}
  80081c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081f:	c9                   	leave  
  800820:	c3                   	ret    
			thisenv->env_id, fdnum);
  800821:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800826:	8b 40 48             	mov    0x48(%eax),%eax
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	53                   	push   %ebx
  80082d:	50                   	push   %eax
  80082e:	68 98 22 80 00       	push   $0x802298
  800833:	e8 2d 0d 00 00       	call   801565 <cprintf>
		return -E_INVAL;
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800840:	eb da                	jmp    80081c <ftruncate+0x52>
		return -E_NOT_SUPP;
  800842:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800847:	eb d3                	jmp    80081c <ftruncate+0x52>

00800849 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	53                   	push   %ebx
  80084d:	83 ec 14             	sub    $0x14,%esp
  800850:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800853:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800856:	50                   	push   %eax
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	e8 81 fb ff ff       	call   8003e0 <fd_lookup>
  80085f:	83 c4 08             	add    $0x8,%esp
  800862:	85 c0                	test   %eax,%eax
  800864:	78 4b                	js     8008b1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	ff 30                	pushl  (%eax)
  800872:	e8 bf fb ff ff       	call   800436 <dev_lookup>
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	85 c0                	test   %eax,%eax
  80087c:	78 33                	js     8008b1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80087e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800881:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800885:	74 2f                	je     8008b6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800887:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80088a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800891:	00 00 00 
	stat->st_isdir = 0;
  800894:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80089b:	00 00 00 
	stat->st_dev = dev;
  80089e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ab:	ff 50 14             	call   *0x14(%eax)
  8008ae:	83 c4 10             	add    $0x10,%esp
}
  8008b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008bb:	eb f4                	jmp    8008b1 <fstat+0x68>

008008bd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	6a 00                	push   $0x0
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 e7 01 00 00       	call   800ab6 <open>
  8008cf:	89 c3                	mov    %eax,%ebx
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	85 c0                	test   %eax,%eax
  8008d6:	78 1b                	js     8008f3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	e8 65 ff ff ff       	call   800849 <fstat>
  8008e4:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e6:	89 1c 24             	mov    %ebx,(%esp)
  8008e9:	e8 27 fc ff ff       	call   800515 <close>
	return r;
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 f3                	mov    %esi,%ebx
}
  8008f3:	89 d8                	mov    %ebx,%eax
  8008f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f8:	5b                   	pop    %ebx
  8008f9:	5e                   	pop    %esi
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	56                   	push   %esi
  800900:	53                   	push   %ebx
  800901:	89 c6                	mov    %eax,%esi
  800903:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800905:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80090c:	74 27                	je     800935 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80090e:	6a 07                	push   $0x7
  800910:	68 00 50 80 00       	push   $0x805000
  800915:	56                   	push   %esi
  800916:	ff 35 00 40 80 00    	pushl  0x804000
  80091c:	e8 07 16 00 00       	call   801f28 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800921:	83 c4 0c             	add    $0xc,%esp
  800924:	6a 00                	push   $0x0
  800926:	53                   	push   %ebx
  800927:	6a 00                	push   $0x0
  800929:	e8 93 15 00 00       	call   801ec1 <ipc_recv>
}
  80092e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800931:	5b                   	pop    %ebx
  800932:	5e                   	pop    %esi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800935:	83 ec 0c             	sub    $0xc,%esp
  800938:	6a 01                	push   $0x1
  80093a:	e8 3d 16 00 00       	call   801f7c <ipc_find_env>
  80093f:	a3 00 40 80 00       	mov    %eax,0x804000
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb c5                	jmp    80090e <fsipc+0x12>

00800949 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 40 0c             	mov    0xc(%eax),%eax
  800955:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800962:	ba 00 00 00 00       	mov    $0x0,%edx
  800967:	b8 02 00 00 00       	mov    $0x2,%eax
  80096c:	e8 8b ff ff ff       	call   8008fc <fsipc>
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <devfile_flush>:
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 40 0c             	mov    0xc(%eax),%eax
  80097f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	b8 06 00 00 00       	mov    $0x6,%eax
  80098e:	e8 69 ff ff ff       	call   8008fc <fsipc>
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <devfile_stat>:
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	53                   	push   %ebx
  800999:	83 ec 04             	sub    $0x4,%esp
  80099c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009af:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b4:	e8 43 ff ff ff       	call   8008fc <fsipc>
  8009b9:	85 c0                	test   %eax,%eax
  8009bb:	78 2c                	js     8009e9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	68 00 50 80 00       	push   $0x805000
  8009c5:	53                   	push   %ebx
  8009c6:	e8 b9 11 00 00       	call   801b84 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009cb:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d6:	a1 84 50 80 00       	mov    0x805084,%eax
  8009db:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <devfile_write>:
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f7:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009fc:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a01:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a04:	8b 55 08             	mov    0x8(%ebp),%edx
  800a07:	8b 52 0c             	mov    0xc(%edx),%edx
  800a0a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800a10:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a15:	50                   	push   %eax
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	68 08 50 80 00       	push   $0x805008
  800a1e:	e8 ef 12 00 00       	call   801d12 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  800a23:	ba 00 00 00 00       	mov    $0x0,%edx
  800a28:	b8 04 00 00 00       	mov    $0x4,%eax
  800a2d:	e8 ca fe ff ff       	call   8008fc <fsipc>
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <devfile_read>:
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	56                   	push   %esi
  800a38:	53                   	push   %ebx
  800a39:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a42:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a47:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	b8 03 00 00 00       	mov    $0x3,%eax
  800a57:	e8 a0 fe ff ff       	call   8008fc <fsipc>
  800a5c:	89 c3                	mov    %eax,%ebx
  800a5e:	85 c0                	test   %eax,%eax
  800a60:	78 1f                	js     800a81 <devfile_read+0x4d>
	assert(r <= n);
  800a62:	39 f0                	cmp    %esi,%eax
  800a64:	77 24                	ja     800a8a <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a66:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a6b:	7f 33                	jg     800aa0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a6d:	83 ec 04             	sub    $0x4,%esp
  800a70:	50                   	push   %eax
  800a71:	68 00 50 80 00       	push   $0x805000
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	e8 94 12 00 00       	call   801d12 <memmove>
	return r;
  800a7e:	83 c4 10             	add    $0x10,%esp
}
  800a81:	89 d8                	mov    %ebx,%eax
  800a83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a86:	5b                   	pop    %ebx
  800a87:	5e                   	pop    %esi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    
	assert(r <= n);
  800a8a:	68 08 23 80 00       	push   $0x802308
  800a8f:	68 0f 23 80 00       	push   $0x80230f
  800a94:	6a 7b                	push   $0x7b
  800a96:	68 24 23 80 00       	push   $0x802324
  800a9b:	e8 ea 09 00 00       	call   80148a <_panic>
	assert(r <= PGSIZE);
  800aa0:	68 2f 23 80 00       	push   $0x80232f
  800aa5:	68 0f 23 80 00       	push   $0x80230f
  800aaa:	6a 7c                	push   $0x7c
  800aac:	68 24 23 80 00       	push   $0x802324
  800ab1:	e8 d4 09 00 00       	call   80148a <_panic>

00800ab6 <open>:
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	56                   	push   %esi
  800aba:	53                   	push   %ebx
  800abb:	83 ec 1c             	sub    $0x1c,%esp
  800abe:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ac1:	56                   	push   %esi
  800ac2:	e8 86 10 00 00       	call   801b4d <strlen>
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800acf:	7f 6c                	jg     800b3d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ad7:	50                   	push   %eax
  800ad8:	e8 b4 f8 ff ff       	call   800391 <fd_alloc>
  800add:	89 c3                	mov    %eax,%ebx
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	85 c0                	test   %eax,%eax
  800ae4:	78 3c                	js     800b22 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	56                   	push   %esi
  800aea:	68 00 50 80 00       	push   $0x805000
  800aef:	e8 90 10 00 00       	call   801b84 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  800afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aff:	b8 01 00 00 00       	mov    $0x1,%eax
  800b04:	e8 f3 fd ff ff       	call   8008fc <fsipc>
  800b09:	89 c3                	mov    %eax,%ebx
  800b0b:	83 c4 10             	add    $0x10,%esp
  800b0e:	85 c0                	test   %eax,%eax
  800b10:	78 19                	js     800b2b <open+0x75>
	return fd2num(fd);
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	e8 4d f8 ff ff       	call   80036a <fd2num>
  800b1d:	89 c3                	mov    %eax,%ebx
  800b1f:	83 c4 10             	add    $0x10,%esp
}
  800b22:	89 d8                	mov    %ebx,%eax
  800b24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b27:	5b                   	pop    %ebx
  800b28:	5e                   	pop    %esi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    
		fd_close(fd, 0);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	6a 00                	push   $0x0
  800b30:	ff 75 f4             	pushl  -0xc(%ebp)
  800b33:	e8 54 f9 ff ff       	call   80048c <fd_close>
		return r;
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	eb e5                	jmp    800b22 <open+0x6c>
		return -E_BAD_PATH;
  800b3d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b42:	eb de                	jmp    800b22 <open+0x6c>

00800b44 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4f:	b8 08 00 00 00       	mov    $0x8,%eax
  800b54:	e8 a3 fd ff ff       	call   8008fc <fsipc>
}
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800b61:	68 3b 23 80 00       	push   $0x80233b
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	e8 16 10 00 00       	call   801b84 <strcpy>
	return 0;
}
  800b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <devsock_close>:
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	53                   	push   %ebx
  800b79:	83 ec 10             	sub    $0x10,%esp
  800b7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800b7f:	53                   	push   %ebx
  800b80:	e8 30 14 00 00       	call   801fb5 <pageref>
  800b85:	83 c4 10             	add    $0x10,%esp
		return 0;
  800b88:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800b8d:	83 f8 01             	cmp    $0x1,%eax
  800b90:	74 07                	je     800b99 <devsock_close+0x24>
}
  800b92:	89 d0                	mov    %edx,%eax
  800b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	ff 73 0c             	pushl  0xc(%ebx)
  800b9f:	e8 b7 02 00 00       	call   800e5b <nsipc_close>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	eb e7                	jmp    800b92 <devsock_close+0x1d>

00800bab <devsock_write>:
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800bb1:	6a 00                	push   $0x0
  800bb3:	ff 75 10             	pushl  0x10(%ebp)
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	ff 70 0c             	pushl  0xc(%eax)
  800bbf:	e8 74 03 00 00       	call   800f38 <nsipc_send>
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <devsock_read>:
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800bcc:	6a 00                	push   $0x0
  800bce:	ff 75 10             	pushl  0x10(%ebp)
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	ff 70 0c             	pushl  0xc(%eax)
  800bda:	e8 ed 02 00 00       	call   800ecc <nsipc_recv>
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <fd2sockid>:
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800be7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	e8 ef f7 ff ff       	call   8003e0 <fd_lookup>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	85 c0                	test   %eax,%eax
  800bf6:	78 10                	js     800c08 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bfb:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800c01:	39 08                	cmp    %ecx,(%eax)
  800c03:	75 05                	jne    800c0a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800c05:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    
		return -E_NOT_SUPP;
  800c0a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c0f:	eb f7                	jmp    800c08 <fd2sockid+0x27>

00800c11 <alloc_sockfd>:
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
  800c16:	83 ec 1c             	sub    $0x1c,%esp
  800c19:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800c1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c1e:	50                   	push   %eax
  800c1f:	e8 6d f7 ff ff       	call   800391 <fd_alloc>
  800c24:	89 c3                	mov    %eax,%ebx
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	78 43                	js     800c70 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800c2d:	83 ec 04             	sub    $0x4,%esp
  800c30:	68 07 04 00 00       	push   $0x407
  800c35:	ff 75 f4             	pushl  -0xc(%ebp)
  800c38:	6a 00                	push   $0x0
  800c3a:	e8 1b f5 ff ff       	call   80015a <sys_page_alloc>
  800c3f:	89 c3                	mov    %eax,%ebx
  800c41:	83 c4 10             	add    $0x10,%esp
  800c44:	85 c0                	test   %eax,%eax
  800c46:	78 28                	js     800c70 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c4b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800c51:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c56:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800c5d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800c60:	83 ec 0c             	sub    $0xc,%esp
  800c63:	50                   	push   %eax
  800c64:	e8 01 f7 ff ff       	call   80036a <fd2num>
  800c69:	89 c3                	mov    %eax,%ebx
  800c6b:	83 c4 10             	add    $0x10,%esp
  800c6e:	eb 0c                	jmp    800c7c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	56                   	push   %esi
  800c74:	e8 e2 01 00 00       	call   800e5b <nsipc_close>
		return r;
  800c79:	83 c4 10             	add    $0x10,%esp
}
  800c7c:	89 d8                	mov    %ebx,%eax
  800c7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <accept>:
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	e8 4e ff ff ff       	call   800be1 <fd2sockid>
  800c93:	85 c0                	test   %eax,%eax
  800c95:	78 1b                	js     800cb2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800c97:	83 ec 04             	sub    $0x4,%esp
  800c9a:	ff 75 10             	pushl  0x10(%ebp)
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	50                   	push   %eax
  800ca1:	e8 0e 01 00 00       	call   800db4 <nsipc_accept>
  800ca6:	83 c4 10             	add    $0x10,%esp
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	78 05                	js     800cb2 <accept+0x2d>
	return alloc_sockfd(r);
  800cad:	e8 5f ff ff ff       	call   800c11 <alloc_sockfd>
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <bind>:
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	e8 1f ff ff ff       	call   800be1 <fd2sockid>
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	78 12                	js     800cd8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  800cc6:	83 ec 04             	sub    $0x4,%esp
  800cc9:	ff 75 10             	pushl  0x10(%ebp)
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	50                   	push   %eax
  800cd0:	e8 2f 01 00 00       	call   800e04 <nsipc_bind>
  800cd5:	83 c4 10             	add    $0x10,%esp
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    

00800cda <shutdown>:
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	e8 f9 fe ff ff       	call   800be1 <fd2sockid>
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	78 0f                	js     800cfb <shutdown+0x21>
	return nsipc_shutdown(r, how);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	50                   	push   %eax
  800cf3:	e8 41 01 00 00       	call   800e39 <nsipc_shutdown>
  800cf8:	83 c4 10             	add    $0x10,%esp
}
  800cfb:	c9                   	leave  
  800cfc:	c3                   	ret    

00800cfd <connect>:
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	e8 d6 fe ff ff       	call   800be1 <fd2sockid>
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	78 12                	js     800d21 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  800d0f:	83 ec 04             	sub    $0x4,%esp
  800d12:	ff 75 10             	pushl  0x10(%ebp)
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	50                   	push   %eax
  800d19:	e8 57 01 00 00       	call   800e75 <nsipc_connect>
  800d1e:	83 c4 10             	add    $0x10,%esp
}
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <listen>:
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	e8 b0 fe ff ff       	call   800be1 <fd2sockid>
  800d31:	85 c0                	test   %eax,%eax
  800d33:	78 0f                	js     800d44 <listen+0x21>
	return nsipc_listen(r, backlog);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	50                   	push   %eax
  800d3c:	e8 69 01 00 00       	call   800eaa <nsipc_listen>
  800d41:	83 c4 10             	add    $0x10,%esp
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <socket>:

int
socket(int domain, int type, int protocol)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800d4c:	ff 75 10             	pushl  0x10(%ebp)
  800d4f:	ff 75 0c             	pushl  0xc(%ebp)
  800d52:	ff 75 08             	pushl  0x8(%ebp)
  800d55:	e8 3c 02 00 00       	call   800f96 <nsipc_socket>
  800d5a:	83 c4 10             	add    $0x10,%esp
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	78 05                	js     800d66 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  800d61:	e8 ab fe ff ff       	call   800c11 <alloc_sockfd>
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	53                   	push   %ebx
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800d71:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800d78:	74 26                	je     800da0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800d7a:	6a 07                	push   $0x7
  800d7c:	68 00 60 80 00       	push   $0x806000
  800d81:	53                   	push   %ebx
  800d82:	ff 35 04 40 80 00    	pushl  0x804004
  800d88:	e8 9b 11 00 00       	call   801f28 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800d8d:	83 c4 0c             	add    $0xc,%esp
  800d90:	6a 00                	push   $0x0
  800d92:	6a 00                	push   $0x0
  800d94:	6a 00                	push   $0x0
  800d96:	e8 26 11 00 00       	call   801ec1 <ipc_recv>
}
  800d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	6a 02                	push   $0x2
  800da5:	e8 d2 11 00 00       	call   801f7c <ipc_find_env>
  800daa:	a3 04 40 80 00       	mov    %eax,0x804004
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	eb c6                	jmp    800d7a <nsipc+0x12>

00800db4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800dc4:	8b 06                	mov    (%esi),%eax
  800dc6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800dcb:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd0:	e8 93 ff ff ff       	call   800d68 <nsipc>
  800dd5:	89 c3                	mov    %eax,%ebx
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	78 20                	js     800dfb <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800ddb:	83 ec 04             	sub    $0x4,%esp
  800dde:	ff 35 10 60 80 00    	pushl  0x806010
  800de4:	68 00 60 80 00       	push   $0x806000
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	e8 21 0f 00 00       	call   801d12 <memmove>
		*addrlen = ret->ret_addrlen;
  800df1:	a1 10 60 80 00       	mov    0x806010,%eax
  800df6:	89 06                	mov    %eax,(%esi)
  800df8:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  800dfb:	89 d8                	mov    %ebx,%eax
  800dfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	53                   	push   %ebx
  800e08:	83 ec 08             	sub    $0x8,%esp
  800e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800e16:	53                   	push   %ebx
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	68 04 60 80 00       	push   $0x806004
  800e1f:	e8 ee 0e 00 00       	call   801d12 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800e24:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800e2a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e2f:	e8 34 ff ff ff       	call   800d68 <nsipc>
}
  800e34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800e4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e54:	e8 0f ff ff ff       	call   800d68 <nsipc>
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <nsipc_close>:

int
nsipc_close(int s)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800e69:	b8 04 00 00 00       	mov    $0x4,%eax
  800e6e:	e8 f5 fe ff ff       	call   800d68 <nsipc>
}
  800e73:	c9                   	leave  
  800e74:	c3                   	ret    

00800e75 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	53                   	push   %ebx
  800e79:	83 ec 08             	sub    $0x8,%esp
  800e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800e87:	53                   	push   %ebx
  800e88:	ff 75 0c             	pushl  0xc(%ebp)
  800e8b:	68 04 60 80 00       	push   $0x806004
  800e90:	e8 7d 0e 00 00       	call   801d12 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800e95:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800e9b:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea0:	e8 c3 fe ff ff       	call   800d68 <nsipc>
}
  800ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800ec0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec5:	e8 9e fe ff ff       	call   800d68 <nsipc>
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800edc:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee5:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800eea:	b8 07 00 00 00       	mov    $0x7,%eax
  800eef:	e8 74 fe ff ff       	call   800d68 <nsipc>
  800ef4:	89 c3                	mov    %eax,%ebx
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	78 1f                	js     800f19 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  800efa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  800eff:	7f 21                	jg     800f22 <nsipc_recv+0x56>
  800f01:	39 c6                	cmp    %eax,%esi
  800f03:	7c 1d                	jl     800f22 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800f05:	83 ec 04             	sub    $0x4,%esp
  800f08:	50                   	push   %eax
  800f09:	68 00 60 80 00       	push   $0x806000
  800f0e:	ff 75 0c             	pushl  0xc(%ebp)
  800f11:	e8 fc 0d 00 00       	call   801d12 <memmove>
  800f16:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800f19:	89 d8                	mov    %ebx,%eax
  800f1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
		assert(r < 1600 && r <= len);
  800f22:	68 47 23 80 00       	push   $0x802347
  800f27:	68 0f 23 80 00       	push   $0x80230f
  800f2c:	6a 62                	push   $0x62
  800f2e:	68 5c 23 80 00       	push   $0x80235c
  800f33:	e8 52 05 00 00       	call   80148a <_panic>

00800f38 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	53                   	push   %ebx
  800f3c:	83 ec 04             	sub    $0x4,%esp
  800f3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  800f4a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  800f50:	7f 2e                	jg     800f80 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  800f52:	83 ec 04             	sub    $0x4,%esp
  800f55:	53                   	push   %ebx
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	68 0c 60 80 00       	push   $0x80600c
  800f5e:	e8 af 0d 00 00       	call   801d12 <memmove>
	nsipcbuf.send.req_size = size;
  800f63:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  800f69:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  800f71:	b8 08 00 00 00       	mov    $0x8,%eax
  800f76:	e8 ed fd ff ff       	call   800d68 <nsipc>
}
  800f7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    
	assert(size < 1600);
  800f80:	68 68 23 80 00       	push   $0x802368
  800f85:	68 0f 23 80 00       	push   $0x80230f
  800f8a:	6a 6d                	push   $0x6d
  800f8c:	68 5c 23 80 00       	push   $0x80235c
  800f91:	e8 f4 04 00 00       	call   80148a <_panic>

00800f96 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
  800faf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  800fb4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fb9:	e8 aa fd ff ff       	call   800d68 <nsipc>
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fc8:	83 ec 0c             	sub    $0xc,%esp
  800fcb:	ff 75 08             	pushl  0x8(%ebp)
  800fce:	e8 a7 f3 ff ff       	call   80037a <fd2data>
  800fd3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fd5:	83 c4 08             	add    $0x8,%esp
  800fd8:	68 74 23 80 00       	push   $0x802374
  800fdd:	53                   	push   %ebx
  800fde:	e8 a1 0b 00 00       	call   801b84 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fe3:	8b 46 04             	mov    0x4(%esi),%eax
  800fe6:	2b 06                	sub    (%esi),%eax
  800fe8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ff5:	00 00 00 
	stat->st_dev = &devpipe;
  800ff8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  800fff:	30 80 00 
	return 0;
}
  801002:	b8 00 00 00 00       	mov    $0x0,%eax
  801007:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	53                   	push   %ebx
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801018:	53                   	push   %ebx
  801019:	6a 00                	push   $0x0
  80101b:	e8 bf f1 ff ff       	call   8001df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801020:	89 1c 24             	mov    %ebx,(%esp)
  801023:	e8 52 f3 ff ff       	call   80037a <fd2data>
  801028:	83 c4 08             	add    $0x8,%esp
  80102b:	50                   	push   %eax
  80102c:	6a 00                	push   $0x0
  80102e:	e8 ac f1 ff ff       	call   8001df <sys_page_unmap>
}
  801033:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <_pipeisclosed>:
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	83 ec 1c             	sub    $0x1c,%esp
  801041:	89 c7                	mov    %eax,%edi
  801043:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801045:	a1 08 40 80 00       	mov    0x804008,%eax
  80104a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	57                   	push   %edi
  801051:	e8 5f 0f 00 00       	call   801fb5 <pageref>
  801056:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801059:	89 34 24             	mov    %esi,(%esp)
  80105c:	e8 54 0f 00 00       	call   801fb5 <pageref>
		nn = thisenv->env_runs;
  801061:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801067:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80106a:	83 c4 10             	add    $0x10,%esp
  80106d:	39 cb                	cmp    %ecx,%ebx
  80106f:	74 1b                	je     80108c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801071:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801074:	75 cf                	jne    801045 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801076:	8b 42 58             	mov    0x58(%edx),%eax
  801079:	6a 01                	push   $0x1
  80107b:	50                   	push   %eax
  80107c:	53                   	push   %ebx
  80107d:	68 7b 23 80 00       	push   $0x80237b
  801082:	e8 de 04 00 00       	call   801565 <cprintf>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	eb b9                	jmp    801045 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80108c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80108f:	0f 94 c0             	sete   %al
  801092:	0f b6 c0             	movzbl %al,%eax
}
  801095:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <devpipe_write>:
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 28             	sub    $0x28,%esp
  8010a6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010a9:	56                   	push   %esi
  8010aa:	e8 cb f2 ff ff       	call   80037a <fd2data>
  8010af:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8010b9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010bc:	74 4f                	je     80110d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010be:	8b 43 04             	mov    0x4(%ebx),%eax
  8010c1:	8b 0b                	mov    (%ebx),%ecx
  8010c3:	8d 51 20             	lea    0x20(%ecx),%edx
  8010c6:	39 d0                	cmp    %edx,%eax
  8010c8:	72 14                	jb     8010de <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010ca:	89 da                	mov    %ebx,%edx
  8010cc:	89 f0                	mov    %esi,%eax
  8010ce:	e8 65 ff ff ff       	call   801038 <_pipeisclosed>
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	75 3a                	jne    801111 <devpipe_write+0x74>
			sys_yield();
  8010d7:	e8 5f f0 ff ff       	call   80013b <sys_yield>
  8010dc:	eb e0                	jmp    8010be <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010e5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010e8:	89 c2                	mov    %eax,%edx
  8010ea:	c1 fa 1f             	sar    $0x1f,%edx
  8010ed:	89 d1                	mov    %edx,%ecx
  8010ef:	c1 e9 1b             	shr    $0x1b,%ecx
  8010f2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010f5:	83 e2 1f             	and    $0x1f,%edx
  8010f8:	29 ca                	sub    %ecx,%edx
  8010fa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010fe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801102:	83 c0 01             	add    $0x1,%eax
  801105:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801108:	83 c7 01             	add    $0x1,%edi
  80110b:	eb ac                	jmp    8010b9 <devpipe_write+0x1c>
	return i;
  80110d:	89 f8                	mov    %edi,%eax
  80110f:	eb 05                	jmp    801116 <devpipe_write+0x79>
				return 0;
  801111:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801119:	5b                   	pop    %ebx
  80111a:	5e                   	pop    %esi
  80111b:	5f                   	pop    %edi
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <devpipe_read>:
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 18             	sub    $0x18,%esp
  801127:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80112a:	57                   	push   %edi
  80112b:	e8 4a f2 ff ff       	call   80037a <fd2data>
  801130:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801132:	83 c4 10             	add    $0x10,%esp
  801135:	be 00 00 00 00       	mov    $0x0,%esi
  80113a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80113d:	74 47                	je     801186 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80113f:	8b 03                	mov    (%ebx),%eax
  801141:	3b 43 04             	cmp    0x4(%ebx),%eax
  801144:	75 22                	jne    801168 <devpipe_read+0x4a>
			if (i > 0)
  801146:	85 f6                	test   %esi,%esi
  801148:	75 14                	jne    80115e <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80114a:	89 da                	mov    %ebx,%edx
  80114c:	89 f8                	mov    %edi,%eax
  80114e:	e8 e5 fe ff ff       	call   801038 <_pipeisclosed>
  801153:	85 c0                	test   %eax,%eax
  801155:	75 33                	jne    80118a <devpipe_read+0x6c>
			sys_yield();
  801157:	e8 df ef ff ff       	call   80013b <sys_yield>
  80115c:	eb e1                	jmp    80113f <devpipe_read+0x21>
				return i;
  80115e:	89 f0                	mov    %esi,%eax
}
  801160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801168:	99                   	cltd   
  801169:	c1 ea 1b             	shr    $0x1b,%edx
  80116c:	01 d0                	add    %edx,%eax
  80116e:	83 e0 1f             	and    $0x1f,%eax
  801171:	29 d0                	sub    %edx,%eax
  801173:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801178:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80117e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801181:	83 c6 01             	add    $0x1,%esi
  801184:	eb b4                	jmp    80113a <devpipe_read+0x1c>
	return i;
  801186:	89 f0                	mov    %esi,%eax
  801188:	eb d6                	jmp    801160 <devpipe_read+0x42>
				return 0;
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
  80118f:	eb cf                	jmp    801160 <devpipe_read+0x42>

00801191 <pipe>:
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	56                   	push   %esi
  801195:	53                   	push   %ebx
  801196:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801199:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80119c:	50                   	push   %eax
  80119d:	e8 ef f1 ff ff       	call   800391 <fd_alloc>
  8011a2:	89 c3                	mov    %eax,%ebx
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	78 5b                	js     801206 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011ab:	83 ec 04             	sub    $0x4,%esp
  8011ae:	68 07 04 00 00       	push   $0x407
  8011b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b6:	6a 00                	push   $0x0
  8011b8:	e8 9d ef ff ff       	call   80015a <sys_page_alloc>
  8011bd:	89 c3                	mov    %eax,%ebx
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	78 40                	js     801206 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011cc:	50                   	push   %eax
  8011cd:	e8 bf f1 ff ff       	call   800391 <fd_alloc>
  8011d2:	89 c3                	mov    %eax,%ebx
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	78 1b                	js     8011f6 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011db:	83 ec 04             	sub    $0x4,%esp
  8011de:	68 07 04 00 00       	push   $0x407
  8011e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8011e6:	6a 00                	push   $0x0
  8011e8:	e8 6d ef ff ff       	call   80015a <sys_page_alloc>
  8011ed:	89 c3                	mov    %eax,%ebx
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	79 19                	jns    80120f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8011f6:	83 ec 08             	sub    $0x8,%esp
  8011f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 dc ef ff ff       	call   8001df <sys_page_unmap>
  801203:	83 c4 10             	add    $0x10,%esp
}
  801206:	89 d8                	mov    %ebx,%eax
  801208:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80120b:	5b                   	pop    %ebx
  80120c:	5e                   	pop    %esi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
	va = fd2data(fd0);
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	ff 75 f4             	pushl  -0xc(%ebp)
  801215:	e8 60 f1 ff ff       	call   80037a <fd2data>
  80121a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80121c:	83 c4 0c             	add    $0xc,%esp
  80121f:	68 07 04 00 00       	push   $0x407
  801224:	50                   	push   %eax
  801225:	6a 00                	push   $0x0
  801227:	e8 2e ef ff ff       	call   80015a <sys_page_alloc>
  80122c:	89 c3                	mov    %eax,%ebx
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	0f 88 8c 00 00 00    	js     8012c5 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	ff 75 f0             	pushl  -0x10(%ebp)
  80123f:	e8 36 f1 ff ff       	call   80037a <fd2data>
  801244:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80124b:	50                   	push   %eax
  80124c:	6a 00                	push   $0x0
  80124e:	56                   	push   %esi
  80124f:	6a 00                	push   $0x0
  801251:	e8 47 ef ff ff       	call   80019d <sys_page_map>
  801256:	89 c3                	mov    %eax,%ebx
  801258:	83 c4 20             	add    $0x20,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 58                	js     8012b7 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80125f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801262:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801268:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80126a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801277:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80127d:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80127f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801282:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	ff 75 f4             	pushl  -0xc(%ebp)
  80128f:	e8 d6 f0 ff ff       	call   80036a <fd2num>
  801294:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801297:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801299:	83 c4 04             	add    $0x4,%esp
  80129c:	ff 75 f0             	pushl  -0x10(%ebp)
  80129f:	e8 c6 f0 ff ff       	call   80036a <fd2num>
  8012a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b2:	e9 4f ff ff ff       	jmp    801206 <pipe+0x75>
	sys_page_unmap(0, va);
  8012b7:	83 ec 08             	sub    $0x8,%esp
  8012ba:	56                   	push   %esi
  8012bb:	6a 00                	push   $0x0
  8012bd:	e8 1d ef ff ff       	call   8001df <sys_page_unmap>
  8012c2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012c5:	83 ec 08             	sub    $0x8,%esp
  8012c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012cb:	6a 00                	push   $0x0
  8012cd:	e8 0d ef ff ff       	call   8001df <sys_page_unmap>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	e9 1c ff ff ff       	jmp    8011f6 <pipe+0x65>

008012da <pipeisclosed>:
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e3:	50                   	push   %eax
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	e8 f4 f0 ff ff       	call   8003e0 <fd_lookup>
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	78 18                	js     80130b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012f3:	83 ec 0c             	sub    $0xc,%esp
  8012f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f9:	e8 7c f0 ff ff       	call   80037a <fd2data>
	return _pipeisclosed(fd, p);
  8012fe:	89 c2                	mov    %eax,%edx
  801300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801303:	e8 30 fd ff ff       	call   801038 <_pipeisclosed>
  801308:	83 c4 10             	add    $0x10,%esp
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80131d:	68 93 23 80 00       	push   $0x802393
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	e8 5a 08 00 00       	call   801b84 <strcpy>
	return 0;
}
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <devcons_write>:
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	57                   	push   %edi
  801335:	56                   	push   %esi
  801336:	53                   	push   %ebx
  801337:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80133d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801342:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801348:	eb 2f                	jmp    801379 <devcons_write+0x48>
		m = n - tot;
  80134a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80134d:	29 f3                	sub    %esi,%ebx
  80134f:	83 fb 7f             	cmp    $0x7f,%ebx
  801352:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801357:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80135a:	83 ec 04             	sub    $0x4,%esp
  80135d:	53                   	push   %ebx
  80135e:	89 f0                	mov    %esi,%eax
  801360:	03 45 0c             	add    0xc(%ebp),%eax
  801363:	50                   	push   %eax
  801364:	57                   	push   %edi
  801365:	e8 a8 09 00 00       	call   801d12 <memmove>
		sys_cputs(buf, m);
  80136a:	83 c4 08             	add    $0x8,%esp
  80136d:	53                   	push   %ebx
  80136e:	57                   	push   %edi
  80136f:	e8 2a ed ff ff       	call   80009e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801374:	01 de                	add    %ebx,%esi
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	3b 75 10             	cmp    0x10(%ebp),%esi
  80137c:	72 cc                	jb     80134a <devcons_write+0x19>
}
  80137e:	89 f0                	mov    %esi,%eax
  801380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801383:	5b                   	pop    %ebx
  801384:	5e                   	pop    %esi
  801385:	5f                   	pop    %edi
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    

00801388 <devcons_read>:
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 08             	sub    $0x8,%esp
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801397:	75 07                	jne    8013a0 <devcons_read+0x18>
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    
		sys_yield();
  80139b:	e8 9b ed ff ff       	call   80013b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8013a0:	e8 17 ed ff ff       	call   8000bc <sys_cgetc>
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	74 f2                	je     80139b <devcons_read+0x13>
	if (c < 0)
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 ec                	js     801399 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8013ad:	83 f8 04             	cmp    $0x4,%eax
  8013b0:	74 0c                	je     8013be <devcons_read+0x36>
	*(char*)vbuf = c;
  8013b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b5:	88 02                	mov    %al,(%edx)
	return 1;
  8013b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8013bc:	eb db                	jmp    801399 <devcons_read+0x11>
		return 0;
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c3:	eb d4                	jmp    801399 <devcons_read+0x11>

008013c5 <cputchar>:
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013d1:	6a 01                	push   $0x1
  8013d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013d6:	50                   	push   %eax
  8013d7:	e8 c2 ec ff ff       	call   80009e <sys_cputs>
}
  8013dc:	83 c4 10             	add    $0x10,%esp
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <getchar>:
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013e7:	6a 01                	push   $0x1
  8013e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	6a 00                	push   $0x0
  8013ef:	e8 5d f2 ff ff       	call   800651 <read>
	if (r < 0)
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 08                	js     801403 <getchar+0x22>
	if (r < 1)
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	7e 06                	jle    801405 <getchar+0x24>
	return c;
  8013ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    
		return -E_EOF;
  801405:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80140a:	eb f7                	jmp    801403 <getchar+0x22>

0080140c <iscons>:
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801412:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	e8 c2 ef ff ff       	call   8003e0 <fd_lookup>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 11                	js     801436 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801428:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80142e:	39 10                	cmp    %edx,(%eax)
  801430:	0f 94 c0             	sete   %al
  801433:	0f b6 c0             	movzbl %al,%eax
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <opencons>:
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80143e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	e8 4a ef ff ff       	call   800391 <fd_alloc>
  801447:	83 c4 10             	add    $0x10,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	78 3a                	js     801488 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	68 07 04 00 00       	push   $0x407
  801456:	ff 75 f4             	pushl  -0xc(%ebp)
  801459:	6a 00                	push   $0x0
  80145b:	e8 fa ec ff ff       	call   80015a <sys_page_alloc>
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	78 21                	js     801488 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801470:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801475:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80147c:	83 ec 0c             	sub    $0xc,%esp
  80147f:	50                   	push   %eax
  801480:	e8 e5 ee ff ff       	call   80036a <fd2num>
  801485:	83 c4 10             	add    $0x10,%esp
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	56                   	push   %esi
  80148e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80148f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801492:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801498:	e8 7f ec ff ff       	call   80011c <sys_getenvid>
  80149d:	83 ec 0c             	sub    $0xc,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	56                   	push   %esi
  8014a7:	50                   	push   %eax
  8014a8:	68 a0 23 80 00       	push   $0x8023a0
  8014ad:	e8 b3 00 00 00       	call   801565 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014b2:	83 c4 18             	add    $0x18,%esp
  8014b5:	53                   	push   %ebx
  8014b6:	ff 75 10             	pushl  0x10(%ebp)
  8014b9:	e8 56 00 00 00       	call   801514 <vcprintf>
	cprintf("\n");
  8014be:	c7 04 24 8c 23 80 00 	movl   $0x80238c,(%esp)
  8014c5:	e8 9b 00 00 00       	call   801565 <cprintf>
  8014ca:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014cd:	cc                   	int3   
  8014ce:	eb fd                	jmp    8014cd <_panic+0x43>

008014d0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014da:	8b 13                	mov    (%ebx),%edx
  8014dc:	8d 42 01             	lea    0x1(%edx),%eax
  8014df:	89 03                	mov    %eax,(%ebx)
  8014e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014ed:	74 09                	je     8014f8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014ef:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	68 ff 00 00 00       	push   $0xff
  801500:	8d 43 08             	lea    0x8(%ebx),%eax
  801503:	50                   	push   %eax
  801504:	e8 95 eb ff ff       	call   80009e <sys_cputs>
		b->idx = 0;
  801509:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	eb db                	jmp    8014ef <putch+0x1f>

00801514 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80151d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801524:	00 00 00 
	b.cnt = 0;
  801527:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80152e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801531:	ff 75 0c             	pushl  0xc(%ebp)
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	68 d0 14 80 00       	push   $0x8014d0
  801543:	e8 1a 01 00 00       	call   801662 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801548:	83 c4 08             	add    $0x8,%esp
  80154b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801551:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801557:	50                   	push   %eax
  801558:	e8 41 eb ff ff       	call   80009e <sys_cputs>

	return b.cnt;
}
  80155d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80156e:	50                   	push   %eax
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	e8 9d ff ff ff       	call   801514 <vcprintf>
	va_end(ap);

	return cnt;
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	57                   	push   %edi
  80157d:	56                   	push   %esi
  80157e:	53                   	push   %ebx
  80157f:	83 ec 1c             	sub    $0x1c,%esp
  801582:	89 c7                	mov    %eax,%edi
  801584:	89 d6                	mov    %edx,%esi
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80158f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801592:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801595:	bb 00 00 00 00       	mov    $0x0,%ebx
  80159a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80159d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015a0:	39 d3                	cmp    %edx,%ebx
  8015a2:	72 05                	jb     8015a9 <printnum+0x30>
  8015a4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8015a7:	77 7a                	ja     801623 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015a9:	83 ec 0c             	sub    $0xc,%esp
  8015ac:	ff 75 18             	pushl  0x18(%ebp)
  8015af:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015b5:	53                   	push   %ebx
  8015b6:	ff 75 10             	pushl  0x10(%ebp)
  8015b9:	83 ec 08             	sub    $0x8,%esp
  8015bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8015c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8015c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8015c8:	e8 23 0a 00 00       	call   801ff0 <__udivdi3>
  8015cd:	83 c4 18             	add    $0x18,%esp
  8015d0:	52                   	push   %edx
  8015d1:	50                   	push   %eax
  8015d2:	89 f2                	mov    %esi,%edx
  8015d4:	89 f8                	mov    %edi,%eax
  8015d6:	e8 9e ff ff ff       	call   801579 <printnum>
  8015db:	83 c4 20             	add    $0x20,%esp
  8015de:	eb 13                	jmp    8015f3 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	56                   	push   %esi
  8015e4:	ff 75 18             	pushl  0x18(%ebp)
  8015e7:	ff d7                	call   *%edi
  8015e9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015ec:	83 eb 01             	sub    $0x1,%ebx
  8015ef:	85 db                	test   %ebx,%ebx
  8015f1:	7f ed                	jg     8015e0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	56                   	push   %esi
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015fd:	ff 75 e0             	pushl  -0x20(%ebp)
  801600:	ff 75 dc             	pushl  -0x24(%ebp)
  801603:	ff 75 d8             	pushl  -0x28(%ebp)
  801606:	e8 05 0b 00 00       	call   802110 <__umoddi3>
  80160b:	83 c4 14             	add    $0x14,%esp
  80160e:	0f be 80 c3 23 80 00 	movsbl 0x8023c3(%eax),%eax
  801615:	50                   	push   %eax
  801616:	ff d7                	call   *%edi
}
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161e:	5b                   	pop    %ebx
  80161f:	5e                   	pop    %esi
  801620:	5f                   	pop    %edi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    
  801623:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801626:	eb c4                	jmp    8015ec <printnum+0x73>

00801628 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80162e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801632:	8b 10                	mov    (%eax),%edx
  801634:	3b 50 04             	cmp    0x4(%eax),%edx
  801637:	73 0a                	jae    801643 <sprintputch+0x1b>
		*b->buf++ = ch;
  801639:	8d 4a 01             	lea    0x1(%edx),%ecx
  80163c:	89 08                	mov    %ecx,(%eax)
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	88 02                	mov    %al,(%edx)
}
  801643:	5d                   	pop    %ebp
  801644:	c3                   	ret    

00801645 <printfmt>:
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80164b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80164e:	50                   	push   %eax
  80164f:	ff 75 10             	pushl  0x10(%ebp)
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	ff 75 08             	pushl  0x8(%ebp)
  801658:	e8 05 00 00 00       	call   801662 <vprintfmt>
}
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <vprintfmt>:
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	57                   	push   %edi
  801666:	56                   	push   %esi
  801667:	53                   	push   %ebx
  801668:	83 ec 2c             	sub    $0x2c,%esp
  80166b:	8b 75 08             	mov    0x8(%ebp),%esi
  80166e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801671:	8b 7d 10             	mov    0x10(%ebp),%edi
  801674:	e9 c1 03 00 00       	jmp    801a3a <vprintfmt+0x3d8>
		padc = ' ';
  801679:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80167d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801684:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80168b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801692:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801697:	8d 47 01             	lea    0x1(%edi),%eax
  80169a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80169d:	0f b6 17             	movzbl (%edi),%edx
  8016a0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8016a3:	3c 55                	cmp    $0x55,%al
  8016a5:	0f 87 12 04 00 00    	ja     801abd <vprintfmt+0x45b>
  8016ab:	0f b6 c0             	movzbl %al,%eax
  8016ae:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  8016b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8016b8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8016bc:	eb d9                	jmp    801697 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8016c1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016c5:	eb d0                	jmp    801697 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8016c7:	0f b6 d2             	movzbl %dl,%edx
  8016ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016d5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016d8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016dc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016df:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016e2:	83 f9 09             	cmp    $0x9,%ecx
  8016e5:	77 55                	ja     80173c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016e7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016ea:	eb e9                	jmp    8016d5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ef:	8b 00                	mov    (%eax),%eax
  8016f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8d 40 04             	lea    0x4(%eax),%eax
  8016fa:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801700:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801704:	79 91                	jns    801697 <vprintfmt+0x35>
				width = precision, precision = -1;
  801706:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801709:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80170c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801713:	eb 82                	jmp    801697 <vprintfmt+0x35>
  801715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	0f 49 d0             	cmovns %eax,%edx
  801722:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801725:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801728:	e9 6a ff ff ff       	jmp    801697 <vprintfmt+0x35>
  80172d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801730:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801737:	e9 5b ff ff ff       	jmp    801697 <vprintfmt+0x35>
  80173c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80173f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801742:	eb bc                	jmp    801700 <vprintfmt+0x9e>
			lflag++;
  801744:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801747:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80174a:	e9 48 ff ff ff       	jmp    801697 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80174f:	8b 45 14             	mov    0x14(%ebp),%eax
  801752:	8d 78 04             	lea    0x4(%eax),%edi
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	53                   	push   %ebx
  801759:	ff 30                	pushl  (%eax)
  80175b:	ff d6                	call   *%esi
			break;
  80175d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801760:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801763:	e9 cf 02 00 00       	jmp    801a37 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801768:	8b 45 14             	mov    0x14(%ebp),%eax
  80176b:	8d 78 04             	lea    0x4(%eax),%edi
  80176e:	8b 00                	mov    (%eax),%eax
  801770:	99                   	cltd   
  801771:	31 d0                	xor    %edx,%eax
  801773:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801775:	83 f8 0f             	cmp    $0xf,%eax
  801778:	7f 23                	jg     80179d <vprintfmt+0x13b>
  80177a:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  801781:	85 d2                	test   %edx,%edx
  801783:	74 18                	je     80179d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801785:	52                   	push   %edx
  801786:	68 21 23 80 00       	push   $0x802321
  80178b:	53                   	push   %ebx
  80178c:	56                   	push   %esi
  80178d:	e8 b3 fe ff ff       	call   801645 <printfmt>
  801792:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801795:	89 7d 14             	mov    %edi,0x14(%ebp)
  801798:	e9 9a 02 00 00       	jmp    801a37 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80179d:	50                   	push   %eax
  80179e:	68 db 23 80 00       	push   $0x8023db
  8017a3:	53                   	push   %ebx
  8017a4:	56                   	push   %esi
  8017a5:	e8 9b fe ff ff       	call   801645 <printfmt>
  8017aa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017ad:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8017b0:	e9 82 02 00 00       	jmp    801a37 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8017b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b8:	83 c0 04             	add    $0x4,%eax
  8017bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017be:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017c3:	85 ff                	test   %edi,%edi
  8017c5:	b8 d4 23 80 00       	mov    $0x8023d4,%eax
  8017ca:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017d1:	0f 8e bd 00 00 00    	jle    801894 <vprintfmt+0x232>
  8017d7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017db:	75 0e                	jne    8017eb <vprintfmt+0x189>
  8017dd:	89 75 08             	mov    %esi,0x8(%ebp)
  8017e0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017e3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017e6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017e9:	eb 6d                	jmp    801858 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	ff 75 d0             	pushl  -0x30(%ebp)
  8017f1:	57                   	push   %edi
  8017f2:	e8 6e 03 00 00       	call   801b65 <strnlen>
  8017f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017fa:	29 c1                	sub    %eax,%ecx
  8017fc:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8017ff:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801802:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801806:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801809:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80180c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80180e:	eb 0f                	jmp    80181f <vprintfmt+0x1bd>
					putch(padc, putdat);
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	53                   	push   %ebx
  801814:	ff 75 e0             	pushl  -0x20(%ebp)
  801817:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801819:	83 ef 01             	sub    $0x1,%edi
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	85 ff                	test   %edi,%edi
  801821:	7f ed                	jg     801810 <vprintfmt+0x1ae>
  801823:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801826:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801829:	85 c9                	test   %ecx,%ecx
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
  801830:	0f 49 c1             	cmovns %ecx,%eax
  801833:	29 c1                	sub    %eax,%ecx
  801835:	89 75 08             	mov    %esi,0x8(%ebp)
  801838:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80183b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80183e:	89 cb                	mov    %ecx,%ebx
  801840:	eb 16                	jmp    801858 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801842:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801846:	75 31                	jne    801879 <vprintfmt+0x217>
					putch(ch, putdat);
  801848:	83 ec 08             	sub    $0x8,%esp
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	50                   	push   %eax
  80184f:	ff 55 08             	call   *0x8(%ebp)
  801852:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801855:	83 eb 01             	sub    $0x1,%ebx
  801858:	83 c7 01             	add    $0x1,%edi
  80185b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80185f:	0f be c2             	movsbl %dl,%eax
  801862:	85 c0                	test   %eax,%eax
  801864:	74 59                	je     8018bf <vprintfmt+0x25d>
  801866:	85 f6                	test   %esi,%esi
  801868:	78 d8                	js     801842 <vprintfmt+0x1e0>
  80186a:	83 ee 01             	sub    $0x1,%esi
  80186d:	79 d3                	jns    801842 <vprintfmt+0x1e0>
  80186f:	89 df                	mov    %ebx,%edi
  801871:	8b 75 08             	mov    0x8(%ebp),%esi
  801874:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801877:	eb 37                	jmp    8018b0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801879:	0f be d2             	movsbl %dl,%edx
  80187c:	83 ea 20             	sub    $0x20,%edx
  80187f:	83 fa 5e             	cmp    $0x5e,%edx
  801882:	76 c4                	jbe    801848 <vprintfmt+0x1e6>
					putch('?', putdat);
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	6a 3f                	push   $0x3f
  80188c:	ff 55 08             	call   *0x8(%ebp)
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	eb c1                	jmp    801855 <vprintfmt+0x1f3>
  801894:	89 75 08             	mov    %esi,0x8(%ebp)
  801897:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80189a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80189d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8018a0:	eb b6                	jmp    801858 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8018a2:	83 ec 08             	sub    $0x8,%esp
  8018a5:	53                   	push   %ebx
  8018a6:	6a 20                	push   $0x20
  8018a8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018aa:	83 ef 01             	sub    $0x1,%edi
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	85 ff                	test   %edi,%edi
  8018b2:	7f ee                	jg     8018a2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8018b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8018ba:	e9 78 01 00 00       	jmp    801a37 <vprintfmt+0x3d5>
  8018bf:	89 df                	mov    %ebx,%edi
  8018c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018c7:	eb e7                	jmp    8018b0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8018c9:	83 f9 01             	cmp    $0x1,%ecx
  8018cc:	7e 3f                	jle    80190d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d1:	8b 50 04             	mov    0x4(%eax),%edx
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018df:	8d 40 08             	lea    0x8(%eax),%eax
  8018e2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018e9:	79 5c                	jns    801947 <vprintfmt+0x2e5>
				putch('-', putdat);
  8018eb:	83 ec 08             	sub    $0x8,%esp
  8018ee:	53                   	push   %ebx
  8018ef:	6a 2d                	push   $0x2d
  8018f1:	ff d6                	call   *%esi
				num = -(long long) num;
  8018f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018f6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8018f9:	f7 da                	neg    %edx
  8018fb:	83 d1 00             	adc    $0x0,%ecx
  8018fe:	f7 d9                	neg    %ecx
  801900:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801903:	b8 0a 00 00 00       	mov    $0xa,%eax
  801908:	e9 10 01 00 00       	jmp    801a1d <vprintfmt+0x3bb>
	else if (lflag)
  80190d:	85 c9                	test   %ecx,%ecx
  80190f:	75 1b                	jne    80192c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801911:	8b 45 14             	mov    0x14(%ebp),%eax
  801914:	8b 00                	mov    (%eax),%eax
  801916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801919:	89 c1                	mov    %eax,%ecx
  80191b:	c1 f9 1f             	sar    $0x1f,%ecx
  80191e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801921:	8b 45 14             	mov    0x14(%ebp),%eax
  801924:	8d 40 04             	lea    0x4(%eax),%eax
  801927:	89 45 14             	mov    %eax,0x14(%ebp)
  80192a:	eb b9                	jmp    8018e5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801934:	89 c1                	mov    %eax,%ecx
  801936:	c1 f9 1f             	sar    $0x1f,%ecx
  801939:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80193c:	8b 45 14             	mov    0x14(%ebp),%eax
  80193f:	8d 40 04             	lea    0x4(%eax),%eax
  801942:	89 45 14             	mov    %eax,0x14(%ebp)
  801945:	eb 9e                	jmp    8018e5 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801947:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80194a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80194d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801952:	e9 c6 00 00 00       	jmp    801a1d <vprintfmt+0x3bb>
	if (lflag >= 2)
  801957:	83 f9 01             	cmp    $0x1,%ecx
  80195a:	7e 18                	jle    801974 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 10                	mov    (%eax),%edx
  801961:	8b 48 04             	mov    0x4(%eax),%ecx
  801964:	8d 40 08             	lea    0x8(%eax),%eax
  801967:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80196a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80196f:	e9 a9 00 00 00       	jmp    801a1d <vprintfmt+0x3bb>
	else if (lflag)
  801974:	85 c9                	test   %ecx,%ecx
  801976:	75 1a                	jne    801992 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  801978:	8b 45 14             	mov    0x14(%ebp),%eax
  80197b:	8b 10                	mov    (%eax),%edx
  80197d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801982:	8d 40 04             	lea    0x4(%eax),%eax
  801985:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801988:	b8 0a 00 00 00       	mov    $0xa,%eax
  80198d:	e9 8b 00 00 00       	jmp    801a1d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801992:	8b 45 14             	mov    0x14(%ebp),%eax
  801995:	8b 10                	mov    (%eax),%edx
  801997:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199c:	8d 40 04             	lea    0x4(%eax),%eax
  80199f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a7:	eb 74                	jmp    801a1d <vprintfmt+0x3bb>
	if (lflag >= 2)
  8019a9:	83 f9 01             	cmp    $0x1,%ecx
  8019ac:	7e 15                	jle    8019c3 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8019ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b1:	8b 10                	mov    (%eax),%edx
  8019b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8019b6:	8d 40 08             	lea    0x8(%eax),%eax
  8019b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8019c1:	eb 5a                	jmp    801a1d <vprintfmt+0x3bb>
	else if (lflag)
  8019c3:	85 c9                	test   %ecx,%ecx
  8019c5:	75 17                	jne    8019de <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8019c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ca:	8b 10                	mov    (%eax),%edx
  8019cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d1:	8d 40 04             	lea    0x4(%eax),%eax
  8019d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8019dc:	eb 3f                	jmp    801a1d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019de:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e1:	8b 10                	mov    (%eax),%edx
  8019e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e8:	8d 40 04             	lea    0x4(%eax),%eax
  8019eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f3:	eb 28                	jmp    801a1d <vprintfmt+0x3bb>
			putch('0', putdat);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	53                   	push   %ebx
  8019f9:	6a 30                	push   $0x30
  8019fb:	ff d6                	call   *%esi
			putch('x', putdat);
  8019fd:	83 c4 08             	add    $0x8,%esp
  801a00:	53                   	push   %ebx
  801a01:	6a 78                	push   $0x78
  801a03:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a05:	8b 45 14             	mov    0x14(%ebp),%eax
  801a08:	8b 10                	mov    (%eax),%edx
  801a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a0f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a12:	8d 40 04             	lea    0x4(%eax),%eax
  801a15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a18:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801a24:	57                   	push   %edi
  801a25:	ff 75 e0             	pushl  -0x20(%ebp)
  801a28:	50                   	push   %eax
  801a29:	51                   	push   %ecx
  801a2a:	52                   	push   %edx
  801a2b:	89 da                	mov    %ebx,%edx
  801a2d:	89 f0                	mov    %esi,%eax
  801a2f:	e8 45 fb ff ff       	call   801579 <printnum>
			break;
  801a34:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a3a:	83 c7 01             	add    $0x1,%edi
  801a3d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a41:	83 f8 25             	cmp    $0x25,%eax
  801a44:	0f 84 2f fc ff ff    	je     801679 <vprintfmt+0x17>
			if (ch == '\0')
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	0f 84 8b 00 00 00    	je     801add <vprintfmt+0x47b>
			putch(ch, putdat);
  801a52:	83 ec 08             	sub    $0x8,%esp
  801a55:	53                   	push   %ebx
  801a56:	50                   	push   %eax
  801a57:	ff d6                	call   *%esi
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	eb dc                	jmp    801a3a <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a5e:	83 f9 01             	cmp    $0x1,%ecx
  801a61:	7e 15                	jle    801a78 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a63:	8b 45 14             	mov    0x14(%ebp),%eax
  801a66:	8b 10                	mov    (%eax),%edx
  801a68:	8b 48 04             	mov    0x4(%eax),%ecx
  801a6b:	8d 40 08             	lea    0x8(%eax),%eax
  801a6e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a71:	b8 10 00 00 00       	mov    $0x10,%eax
  801a76:	eb a5                	jmp    801a1d <vprintfmt+0x3bb>
	else if (lflag)
  801a78:	85 c9                	test   %ecx,%ecx
  801a7a:	75 17                	jne    801a93 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7f:	8b 10                	mov    (%eax),%edx
  801a81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a86:	8d 40 04             	lea    0x4(%eax),%eax
  801a89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a8c:	b8 10 00 00 00       	mov    $0x10,%eax
  801a91:	eb 8a                	jmp    801a1d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	8b 10                	mov    (%eax),%edx
  801a98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9d:	8d 40 04             	lea    0x4(%eax),%eax
  801aa0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa3:	b8 10 00 00 00       	mov    $0x10,%eax
  801aa8:	e9 70 ff ff ff       	jmp    801a1d <vprintfmt+0x3bb>
			putch(ch, putdat);
  801aad:	83 ec 08             	sub    $0x8,%esp
  801ab0:	53                   	push   %ebx
  801ab1:	6a 25                	push   $0x25
  801ab3:	ff d6                	call   *%esi
			break;
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	e9 7a ff ff ff       	jmp    801a37 <vprintfmt+0x3d5>
			putch('%', putdat);
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	53                   	push   %ebx
  801ac1:	6a 25                	push   $0x25
  801ac3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	89 f8                	mov    %edi,%eax
  801aca:	eb 03                	jmp    801acf <vprintfmt+0x46d>
  801acc:	83 e8 01             	sub    $0x1,%eax
  801acf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ad3:	75 f7                	jne    801acc <vprintfmt+0x46a>
  801ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ad8:	e9 5a ff ff ff       	jmp    801a37 <vprintfmt+0x3d5>
}
  801add:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5f                   	pop    %edi
  801ae3:	5d                   	pop    %ebp
  801ae4:	c3                   	ret    

00801ae5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 18             	sub    $0x18,%esp
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801af1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801af4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801af8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801afb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b02:	85 c0                	test   %eax,%eax
  801b04:	74 26                	je     801b2c <vsnprintf+0x47>
  801b06:	85 d2                	test   %edx,%edx
  801b08:	7e 22                	jle    801b2c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b0a:	ff 75 14             	pushl  0x14(%ebp)
  801b0d:	ff 75 10             	pushl  0x10(%ebp)
  801b10:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b13:	50                   	push   %eax
  801b14:	68 28 16 80 00       	push   $0x801628
  801b19:	e8 44 fb ff ff       	call   801662 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b21:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b27:	83 c4 10             	add    $0x10,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    
		return -E_INVAL;
  801b2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b31:	eb f7                	jmp    801b2a <vsnprintf+0x45>

00801b33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b39:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b3c:	50                   	push   %eax
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	e8 9a ff ff ff       	call   801ae5 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b53:	b8 00 00 00 00       	mov    $0x0,%eax
  801b58:	eb 03                	jmp    801b5d <strlen+0x10>
		n++;
  801b5a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801b5d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b61:	75 f7                	jne    801b5a <strlen+0xd>
	return n;
}
  801b63:	5d                   	pop    %ebp
  801b64:	c3                   	ret    

00801b65 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b73:	eb 03                	jmp    801b78 <strnlen+0x13>
		n++;
  801b75:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b78:	39 d0                	cmp    %edx,%eax
  801b7a:	74 06                	je     801b82 <strnlen+0x1d>
  801b7c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801b80:	75 f3                	jne    801b75 <strnlen+0x10>
	return n;
}
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    

00801b84 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b8e:	89 c2                	mov    %eax,%edx
  801b90:	83 c1 01             	add    $0x1,%ecx
  801b93:	83 c2 01             	add    $0x1,%edx
  801b96:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801b9a:	88 5a ff             	mov    %bl,-0x1(%edx)
  801b9d:	84 db                	test   %bl,%bl
  801b9f:	75 ef                	jne    801b90 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801ba1:	5b                   	pop    %ebx
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bab:	53                   	push   %ebx
  801bac:	e8 9c ff ff ff       	call   801b4d <strlen>
  801bb1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	01 d8                	add    %ebx,%eax
  801bb9:	50                   	push   %eax
  801bba:	e8 c5 ff ff ff       	call   801b84 <strcpy>
	return dst;
}
  801bbf:	89 d8                	mov    %ebx,%eax
  801bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	56                   	push   %esi
  801bca:	53                   	push   %ebx
  801bcb:	8b 75 08             	mov    0x8(%ebp),%esi
  801bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bd1:	89 f3                	mov    %esi,%ebx
  801bd3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bd6:	89 f2                	mov    %esi,%edx
  801bd8:	eb 0f                	jmp    801be9 <strncpy+0x23>
		*dst++ = *src;
  801bda:	83 c2 01             	add    $0x1,%edx
  801bdd:	0f b6 01             	movzbl (%ecx),%eax
  801be0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801be3:	80 39 01             	cmpb   $0x1,(%ecx)
  801be6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801be9:	39 da                	cmp    %ebx,%edx
  801beb:	75 ed                	jne    801bda <strncpy+0x14>
	}
	return ret;
}
  801bed:	89 f0                	mov    %esi,%eax
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	8b 75 08             	mov    0x8(%ebp),%esi
  801bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c01:	89 f0                	mov    %esi,%eax
  801c03:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c07:	85 c9                	test   %ecx,%ecx
  801c09:	75 0b                	jne    801c16 <strlcpy+0x23>
  801c0b:	eb 17                	jmp    801c24 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801c0d:	83 c2 01             	add    $0x1,%edx
  801c10:	83 c0 01             	add    $0x1,%eax
  801c13:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801c16:	39 d8                	cmp    %ebx,%eax
  801c18:	74 07                	je     801c21 <strlcpy+0x2e>
  801c1a:	0f b6 0a             	movzbl (%edx),%ecx
  801c1d:	84 c9                	test   %cl,%cl
  801c1f:	75 ec                	jne    801c0d <strlcpy+0x1a>
		*dst = '\0';
  801c21:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c24:	29 f0                	sub    %esi,%eax
}
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5d                   	pop    %ebp
  801c29:	c3                   	ret    

00801c2a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c30:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c33:	eb 06                	jmp    801c3b <strcmp+0x11>
		p++, q++;
  801c35:	83 c1 01             	add    $0x1,%ecx
  801c38:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801c3b:	0f b6 01             	movzbl (%ecx),%eax
  801c3e:	84 c0                	test   %al,%al
  801c40:	74 04                	je     801c46 <strcmp+0x1c>
  801c42:	3a 02                	cmp    (%edx),%al
  801c44:	74 ef                	je     801c35 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c46:	0f b6 c0             	movzbl %al,%eax
  801c49:	0f b6 12             	movzbl (%edx),%edx
  801c4c:	29 d0                	sub    %edx,%eax
}
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    

00801c50 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5a:	89 c3                	mov    %eax,%ebx
  801c5c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c5f:	eb 06                	jmp    801c67 <strncmp+0x17>
		n--, p++, q++;
  801c61:	83 c0 01             	add    $0x1,%eax
  801c64:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c67:	39 d8                	cmp    %ebx,%eax
  801c69:	74 16                	je     801c81 <strncmp+0x31>
  801c6b:	0f b6 08             	movzbl (%eax),%ecx
  801c6e:	84 c9                	test   %cl,%cl
  801c70:	74 04                	je     801c76 <strncmp+0x26>
  801c72:	3a 0a                	cmp    (%edx),%cl
  801c74:	74 eb                	je     801c61 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c76:	0f b6 00             	movzbl (%eax),%eax
  801c79:	0f b6 12             	movzbl (%edx),%edx
  801c7c:	29 d0                	sub    %edx,%eax
}
  801c7e:	5b                   	pop    %ebx
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    
		return 0;
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	eb f6                	jmp    801c7e <strncmp+0x2e>

00801c88 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c92:	0f b6 10             	movzbl (%eax),%edx
  801c95:	84 d2                	test   %dl,%dl
  801c97:	74 09                	je     801ca2 <strchr+0x1a>
		if (*s == c)
  801c99:	38 ca                	cmp    %cl,%dl
  801c9b:	74 0a                	je     801ca7 <strchr+0x1f>
	for (; *s; s++)
  801c9d:	83 c0 01             	add    $0x1,%eax
  801ca0:	eb f0                	jmp    801c92 <strchr+0xa>
			return (char *) s;
	return 0;
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    

00801ca9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cb3:	eb 03                	jmp    801cb8 <strfind+0xf>
  801cb5:	83 c0 01             	add    $0x1,%eax
  801cb8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cbb:	38 ca                	cmp    %cl,%dl
  801cbd:	74 04                	je     801cc3 <strfind+0x1a>
  801cbf:	84 d2                	test   %dl,%dl
  801cc1:	75 f2                	jne    801cb5 <strfind+0xc>
			break;
	return (char *) s;
}
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    

00801cc5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	57                   	push   %edi
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
  801ccb:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cd1:	85 c9                	test   %ecx,%ecx
  801cd3:	74 13                	je     801ce8 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cd5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801cdb:	75 05                	jne    801ce2 <memset+0x1d>
  801cdd:	f6 c1 03             	test   $0x3,%cl
  801ce0:	74 0d                	je     801cef <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce5:	fc                   	cld    
  801ce6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ce8:	89 f8                	mov    %edi,%eax
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    
		c &= 0xFF;
  801cef:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cf3:	89 d3                	mov    %edx,%ebx
  801cf5:	c1 e3 08             	shl    $0x8,%ebx
  801cf8:	89 d0                	mov    %edx,%eax
  801cfa:	c1 e0 18             	shl    $0x18,%eax
  801cfd:	89 d6                	mov    %edx,%esi
  801cff:	c1 e6 10             	shl    $0x10,%esi
  801d02:	09 f0                	or     %esi,%eax
  801d04:	09 c2                	or     %eax,%edx
  801d06:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801d08:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	fc                   	cld    
  801d0e:	f3 ab                	rep stos %eax,%es:(%edi)
  801d10:	eb d6                	jmp    801ce8 <memset+0x23>

00801d12 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d20:	39 c6                	cmp    %eax,%esi
  801d22:	73 35                	jae    801d59 <memmove+0x47>
  801d24:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d27:	39 c2                	cmp    %eax,%edx
  801d29:	76 2e                	jbe    801d59 <memmove+0x47>
		s += n;
		d += n;
  801d2b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d2e:	89 d6                	mov    %edx,%esi
  801d30:	09 fe                	or     %edi,%esi
  801d32:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d38:	74 0c                	je     801d46 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d3a:	83 ef 01             	sub    $0x1,%edi
  801d3d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d40:	fd                   	std    
  801d41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d43:	fc                   	cld    
  801d44:	eb 21                	jmp    801d67 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d46:	f6 c1 03             	test   $0x3,%cl
  801d49:	75 ef                	jne    801d3a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d4b:	83 ef 04             	sub    $0x4,%edi
  801d4e:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d51:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d54:	fd                   	std    
  801d55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d57:	eb ea                	jmp    801d43 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d59:	89 f2                	mov    %esi,%edx
  801d5b:	09 c2                	or     %eax,%edx
  801d5d:	f6 c2 03             	test   $0x3,%dl
  801d60:	74 09                	je     801d6b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d62:	89 c7                	mov    %eax,%edi
  801d64:	fc                   	cld    
  801d65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d6b:	f6 c1 03             	test   $0x3,%cl
  801d6e:	75 f2                	jne    801d62 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d70:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d73:	89 c7                	mov    %eax,%edi
  801d75:	fc                   	cld    
  801d76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d78:	eb ed                	jmp    801d67 <memmove+0x55>

00801d7a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801d7d:	ff 75 10             	pushl  0x10(%ebp)
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	e8 87 ff ff ff       	call   801d12 <memmove>
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	56                   	push   %esi
  801d91:	53                   	push   %ebx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	89 c6                	mov    %eax,%esi
  801d9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d9d:	39 f0                	cmp    %esi,%eax
  801d9f:	74 1c                	je     801dbd <memcmp+0x30>
		if (*s1 != *s2)
  801da1:	0f b6 08             	movzbl (%eax),%ecx
  801da4:	0f b6 1a             	movzbl (%edx),%ebx
  801da7:	38 d9                	cmp    %bl,%cl
  801da9:	75 08                	jne    801db3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801dab:	83 c0 01             	add    $0x1,%eax
  801dae:	83 c2 01             	add    $0x1,%edx
  801db1:	eb ea                	jmp    801d9d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801db3:	0f b6 c1             	movzbl %cl,%eax
  801db6:	0f b6 db             	movzbl %bl,%ebx
  801db9:	29 d8                	sub    %ebx,%eax
  801dbb:	eb 05                	jmp    801dc2 <memcmp+0x35>
	}

	return 0;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc2:	5b                   	pop    %ebx
  801dc3:	5e                   	pop    %esi
  801dc4:	5d                   	pop    %ebp
  801dc5:	c3                   	ret    

00801dc6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dcf:	89 c2                	mov    %eax,%edx
  801dd1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dd4:	39 d0                	cmp    %edx,%eax
  801dd6:	73 09                	jae    801de1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd8:	38 08                	cmp    %cl,(%eax)
  801dda:	74 05                	je     801de1 <memfind+0x1b>
	for (; s < ends; s++)
  801ddc:	83 c0 01             	add    $0x1,%eax
  801ddf:	eb f3                	jmp    801dd4 <memfind+0xe>
			break;
	return (void *) s;
}
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	57                   	push   %edi
  801de7:	56                   	push   %esi
  801de8:	53                   	push   %ebx
  801de9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801def:	eb 03                	jmp    801df4 <strtol+0x11>
		s++;
  801df1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801df4:	0f b6 01             	movzbl (%ecx),%eax
  801df7:	3c 20                	cmp    $0x20,%al
  801df9:	74 f6                	je     801df1 <strtol+0xe>
  801dfb:	3c 09                	cmp    $0x9,%al
  801dfd:	74 f2                	je     801df1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801dff:	3c 2b                	cmp    $0x2b,%al
  801e01:	74 2e                	je     801e31 <strtol+0x4e>
	int neg = 0;
  801e03:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e08:	3c 2d                	cmp    $0x2d,%al
  801e0a:	74 2f                	je     801e3b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e0c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e12:	75 05                	jne    801e19 <strtol+0x36>
  801e14:	80 39 30             	cmpb   $0x30,(%ecx)
  801e17:	74 2c                	je     801e45 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801e19:	85 db                	test   %ebx,%ebx
  801e1b:	75 0a                	jne    801e27 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e1d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801e22:	80 39 30             	cmpb   $0x30,(%ecx)
  801e25:	74 28                	je     801e4f <strtol+0x6c>
		base = 10;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e2f:	eb 50                	jmp    801e81 <strtol+0x9e>
		s++;
  801e31:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e34:	bf 00 00 00 00       	mov    $0x0,%edi
  801e39:	eb d1                	jmp    801e0c <strtol+0x29>
		s++, neg = 1;
  801e3b:	83 c1 01             	add    $0x1,%ecx
  801e3e:	bf 01 00 00 00       	mov    $0x1,%edi
  801e43:	eb c7                	jmp    801e0c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e45:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e49:	74 0e                	je     801e59 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801e4b:	85 db                	test   %ebx,%ebx
  801e4d:	75 d8                	jne    801e27 <strtol+0x44>
		s++, base = 8;
  801e4f:	83 c1 01             	add    $0x1,%ecx
  801e52:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e57:	eb ce                	jmp    801e27 <strtol+0x44>
		s += 2, base = 16;
  801e59:	83 c1 02             	add    $0x2,%ecx
  801e5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e61:	eb c4                	jmp    801e27 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e63:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e66:	89 f3                	mov    %esi,%ebx
  801e68:	80 fb 19             	cmp    $0x19,%bl
  801e6b:	77 29                	ja     801e96 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801e6d:	0f be d2             	movsbl %dl,%edx
  801e70:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e73:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e76:	7d 30                	jge    801ea8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801e78:	83 c1 01             	add    $0x1,%ecx
  801e7b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e7f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e81:	0f b6 11             	movzbl (%ecx),%edx
  801e84:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e87:	89 f3                	mov    %esi,%ebx
  801e89:	80 fb 09             	cmp    $0x9,%bl
  801e8c:	77 d5                	ja     801e63 <strtol+0x80>
			dig = *s - '0';
  801e8e:	0f be d2             	movsbl %dl,%edx
  801e91:	83 ea 30             	sub    $0x30,%edx
  801e94:	eb dd                	jmp    801e73 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801e96:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e99:	89 f3                	mov    %esi,%ebx
  801e9b:	80 fb 19             	cmp    $0x19,%bl
  801e9e:	77 08                	ja     801ea8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801ea0:	0f be d2             	movsbl %dl,%edx
  801ea3:	83 ea 37             	sub    $0x37,%edx
  801ea6:	eb cb                	jmp    801e73 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ea8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eac:	74 05                	je     801eb3 <strtol+0xd0>
		*endptr = (char *) s;
  801eae:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eb1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eb3:	89 c2                	mov    %eax,%edx
  801eb5:	f7 da                	neg    %edx
  801eb7:	85 ff                	test   %edi,%edi
  801eb9:	0f 45 c2             	cmovne %edx,%eax
}
  801ebc:	5b                   	pop    %ebx
  801ebd:	5e                   	pop    %esi
  801ebe:	5f                   	pop    %edi
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	56                   	push   %esi
  801ec5:	53                   	push   %ebx
  801ec6:	8b 75 08             	mov    0x8(%ebp),%esi
  801ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801ecf:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ed1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ed6:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ed9:	83 ec 0c             	sub    $0xc,%esp
  801edc:	50                   	push   %eax
  801edd:	e8 28 e4 ff ff       	call   80030a <sys_ipc_recv>
	if (from_env_store)
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	85 f6                	test   %esi,%esi
  801ee7:	74 14                	je     801efd <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801ee9:	ba 00 00 00 00       	mov    $0x0,%edx
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	78 09                	js     801efb <ipc_recv+0x3a>
  801ef2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ef8:	8b 52 74             	mov    0x74(%edx),%edx
  801efb:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801efd:	85 db                	test   %ebx,%ebx
  801eff:	74 14                	je     801f15 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f01:	ba 00 00 00 00       	mov    $0x0,%edx
  801f06:	85 c0                	test   %eax,%eax
  801f08:	78 09                	js     801f13 <ipc_recv+0x52>
  801f0a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f10:	8b 52 78             	mov    0x78(%edx),%edx
  801f13:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 08                	js     801f21 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f19:	a1 08 40 80 00       	mov    0x804008,%eax
  801f1e:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    

00801f28 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	57                   	push   %edi
  801f2c:	56                   	push   %esi
  801f2d:	53                   	push   %ebx
  801f2e:	83 ec 0c             	sub    $0xc,%esp
  801f31:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f34:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f3a:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f3c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f41:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f44:	ff 75 14             	pushl  0x14(%ebp)
  801f47:	53                   	push   %ebx
  801f48:	56                   	push   %esi
  801f49:	57                   	push   %edi
  801f4a:	e8 98 e3 ff ff       	call   8002e7 <sys_ipc_try_send>
		if (ret == 0)
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	85 c0                	test   %eax,%eax
  801f54:	74 1e                	je     801f74 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f56:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f59:	75 07                	jne    801f62 <ipc_send+0x3a>
			sys_yield();
  801f5b:	e8 db e1 ff ff       	call   80013b <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f60:	eb e2                	jmp    801f44 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f62:	50                   	push   %eax
  801f63:	68 c0 26 80 00       	push   $0x8026c0
  801f68:	6a 3d                	push   $0x3d
  801f6a:	68 d4 26 80 00       	push   $0x8026d4
  801f6f:	e8 16 f5 ff ff       	call   80148a <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5f                   	pop    %edi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    

00801f7c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f87:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f8a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f90:	8b 52 50             	mov    0x50(%edx),%edx
  801f93:	39 ca                	cmp    %ecx,%edx
  801f95:	74 11                	je     801fa8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801f97:	83 c0 01             	add    $0x1,%eax
  801f9a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f9f:	75 e6                	jne    801f87 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	eb 0b                	jmp    801fb3 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fa8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fb0:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fb3:	5d                   	pop    %ebp
  801fb4:	c3                   	ret    

00801fb5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fbb:	89 d0                	mov    %edx,%eax
  801fbd:	c1 e8 16             	shr    $0x16,%eax
  801fc0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fcc:	f6 c1 01             	test   $0x1,%cl
  801fcf:	74 1d                	je     801fee <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fd1:	c1 ea 0c             	shr    $0xc,%edx
  801fd4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fdb:	f6 c2 01             	test   $0x1,%dl
  801fde:	74 0e                	je     801fee <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fe0:	c1 ea 0c             	shr    $0xc,%edx
  801fe3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fea:	ef 
  801feb:	0f b7 c0             	movzwl %ax,%eax
}
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    

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

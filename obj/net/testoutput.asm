
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 a4 01 00 00       	call   8001d5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	envid_t ns_envid = sys_getenvid();
  800038:	e8 ad 0c 00 00       	call   800cea <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80003f:	c7 05 00 30 80 00 00 	movl   $0x802700,0x803000
  800046:	27 80 00 

	output_envid = fork();
  800049:	e8 c3 0f 00 00       	call   801011 <fork>
  80004e:	a3 00 40 80 00       	mov    %eax,0x804000
	if (output_envid < 0)
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 95 00 00 00    	js     8000f0 <umain+0xbd>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80005b:	bb 00 00 00 00       	mov    $0x0,%ebx
	else if (output_envid == 0) {
  800060:	85 c0                	test   %eax,%eax
  800062:	0f 84 9c 00 00 00    	je     800104 <umain+0xd1>
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 07                	push   $0x7
  80006d:	68 00 b0 fe 0f       	push   $0xffeb000
  800072:	6a 00                	push   $0x0
  800074:	e8 af 0c 00 00       	call   800d28 <sys_page_alloc>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 88 8e 00 00 00    	js     800112 <umain+0xdf>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800084:	53                   	push   %ebx
  800085:	68 3d 27 80 00       	push   $0x80273d
  80008a:	68 fc 0f 00 00       	push   $0xffc
  80008f:	68 04 b0 fe 0f       	push   $0xffeb004
  800094:	e8 45 08 00 00       	call   8008de <snprintf>
  800099:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  80009e:	83 c4 08             	add    $0x8,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	68 49 27 80 00       	push   $0x802749
  8000a7:	e8 64 02 00 00       	call   800310 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000ac:	6a 07                	push   $0x7
  8000ae:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b3:	6a 0b                	push   $0xb
  8000b5:	ff 35 00 40 80 00    	pushl  0x804000
  8000bb:	e8 7d 11 00 00       	call   80123d <ipc_send>
		sys_page_unmap(0, pkt);
  8000c0:	83 c4 18             	add    $0x18,%esp
  8000c3:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c8:	6a 00                	push   $0x0
  8000ca:	e8 de 0c 00 00       	call   800dad <sys_page_unmap>
	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000cf:	83 c3 01             	add    $0x1,%ebx
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	83 fb 0a             	cmp    $0xa,%ebx
  8000d8:	75 8e                	jne    800068 <umain+0x35>
  8000da:	bb 14 00 00 00       	mov    $0x14,%ebx
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  8000df:	e8 25 0c 00 00       	call   800d09 <sys_yield>
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  8000e4:	83 eb 01             	sub    $0x1,%ebx
  8000e7:	75 f6                	jne    8000df <umain+0xac>
}
  8000e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5d                   	pop    %ebp
  8000ef:	c3                   	ret    
		panic("error forking");
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	68 0b 27 80 00       	push   $0x80270b
  8000f8:	6a 16                	push   $0x16
  8000fa:	68 19 27 80 00       	push   $0x802719
  8000ff:	e8 31 01 00 00       	call   800235 <_panic>
		output(ns_envid);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	56                   	push   %esi
  800108:	e8 b9 00 00 00       	call   8001c6 <output>
		return;
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb d7                	jmp    8000e9 <umain+0xb6>
			panic("sys_page_alloc: %e", r);
  800112:	50                   	push   %eax
  800113:	68 2a 27 80 00       	push   $0x80272a
  800118:	6a 1e                	push   $0x1e
  80011a:	68 19 27 80 00       	push   $0x802719
  80011f:	e8 11 01 00 00       	call   800235 <_panic>

00800124 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	57                   	push   %edi
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	83 ec 1c             	sub    $0x1c,%esp
  80012d:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  800130:	e8 e4 0d 00 00       	call   800f19 <sys_time_msec>
  800135:	03 45 0c             	add    0xc(%ebp),%eax
  800138:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  80013a:	c7 05 00 30 80 00 61 	movl   $0x802761,0x803000
  800141:	27 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800144:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800147:	eb 33                	jmp    80017c <timer+0x58>
		if (r < 0)
  800149:	85 c0                	test   %eax,%eax
  80014b:	78 45                	js     800192 <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  80014d:	6a 00                	push   $0x0
  80014f:	6a 00                	push   $0x0
  800151:	6a 0c                	push   $0xc
  800153:	56                   	push   %esi
  800154:	e8 e4 10 00 00       	call   80123d <ipc_send>
  800159:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	6a 00                	push   $0x0
  800161:	6a 00                	push   $0x0
  800163:	57                   	push   %edi
  800164:	e8 6d 10 00 00       	call   8011d6 <ipc_recv>
  800169:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	39 f0                	cmp    %esi,%eax
  800173:	75 2f                	jne    8001a4 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800175:	e8 9f 0d 00 00       	call   800f19 <sys_time_msec>
  80017a:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80017c:	e8 98 0d 00 00       	call   800f19 <sys_time_msec>
  800181:	89 c2                	mov    %eax,%edx
  800183:	85 c0                	test   %eax,%eax
  800185:	78 c2                	js     800149 <timer+0x25>
  800187:	39 d8                	cmp    %ebx,%eax
  800189:	73 be                	jae    800149 <timer+0x25>
			sys_yield();
  80018b:	e8 79 0b 00 00       	call   800d09 <sys_yield>
  800190:	eb ea                	jmp    80017c <timer+0x58>
			panic("sys_time_msec: %e", r);
  800192:	52                   	push   %edx
  800193:	68 6a 27 80 00       	push   $0x80276a
  800198:	6a 0f                	push   $0xf
  80019a:	68 7c 27 80 00       	push   $0x80277c
  80019f:	e8 91 00 00 00       	call   800235 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	50                   	push   %eax
  8001a8:	68 88 27 80 00       	push   $0x802788
  8001ad:	e8 5e 01 00 00       	call   800310 <cprintf>
				continue;
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	eb a5                	jmp    80015c <timer+0x38>

008001b7 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_input";
  8001ba:	c7 05 00 30 80 00 c3 	movl   $0x8027c3,0x803000
  8001c1:	27 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    

008001c6 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_output";
  8001c9:	c7 05 00 30 80 00 cc 	movl   $0x8027cc,0x803000
  8001d0:	27 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001dd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001e0:	e8 05 0b 00 00       	call   800cea <sys_getenvid>
  8001e5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f2:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f7:	85 db                	test   %ebx,%ebx
  8001f9:	7e 07                	jle    800202 <libmain+0x2d>
		binaryname = argv[0];
  8001fb:	8b 06                	mov    (%esi),%eax
  8001fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	e8 27 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80020c:	e8 0a 00 00 00       	call   80021b <exit>
}
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800217:	5b                   	pop    %ebx
  800218:	5e                   	pop    %esi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    

0080021b <exit>:

#include <inc/lib.h>

void exit(void)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800221:	e8 7a 12 00 00       	call   8014a0 <close_all>
	sys_env_destroy(0);
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	6a 00                	push   $0x0
  80022b:	e8 79 0a 00 00       	call   800ca9 <sys_env_destroy>
}
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	56                   	push   %esi
  800239:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80023a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800243:	e8 a2 0a 00 00       	call   800cea <sys_getenvid>
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 0c             	pushl  0xc(%ebp)
  80024e:	ff 75 08             	pushl  0x8(%ebp)
  800251:	56                   	push   %esi
  800252:	50                   	push   %eax
  800253:	68 e0 27 80 00       	push   $0x8027e0
  800258:	e8 b3 00 00 00       	call   800310 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025d:	83 c4 18             	add    $0x18,%esp
  800260:	53                   	push   %ebx
  800261:	ff 75 10             	pushl  0x10(%ebp)
  800264:	e8 56 00 00 00       	call   8002bf <vcprintf>
	cprintf("\n");
  800269:	c7 04 24 5f 27 80 00 	movl   $0x80275f,(%esp)
  800270:	e8 9b 00 00 00       	call   800310 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800278:	cc                   	int3   
  800279:	eb fd                	jmp    800278 <_panic+0x43>

0080027b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	53                   	push   %ebx
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800285:	8b 13                	mov    (%ebx),%edx
  800287:	8d 42 01             	lea    0x1(%edx),%eax
  80028a:	89 03                	mov    %eax,(%ebx)
  80028c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800293:	3d ff 00 00 00       	cmp    $0xff,%eax
  800298:	74 09                	je     8002a3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80029a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	68 ff 00 00 00       	push   $0xff
  8002ab:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ae:	50                   	push   %eax
  8002af:	e8 b8 09 00 00       	call   800c6c <sys_cputs>
		b->idx = 0;
  8002b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	eb db                	jmp    80029a <putch+0x1f>

008002bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cf:	00 00 00 
	b.cnt = 0;
  8002d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002dc:	ff 75 0c             	pushl  0xc(%ebp)
  8002df:	ff 75 08             	pushl  0x8(%ebp)
  8002e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e8:	50                   	push   %eax
  8002e9:	68 7b 02 80 00       	push   $0x80027b
  8002ee:	e8 1a 01 00 00       	call   80040d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f3:	83 c4 08             	add    $0x8,%esp
  8002f6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002fc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	e8 64 09 00 00       	call   800c6c <sys_cputs>

	return b.cnt;
}
  800308:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800316:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800319:	50                   	push   %eax
  80031a:	ff 75 08             	pushl  0x8(%ebp)
  80031d:	e8 9d ff ff ff       	call   8002bf <vcprintf>
	va_end(ap);

	return cnt;
}
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	57                   	push   %edi
  800328:	56                   	push   %esi
  800329:	53                   	push   %ebx
  80032a:	83 ec 1c             	sub    $0x1c,%esp
  80032d:	89 c7                	mov    %eax,%edi
  80032f:	89 d6                	mov    %edx,%esi
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	8b 55 0c             	mov    0xc(%ebp),%edx
  800337:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800340:	bb 00 00 00 00       	mov    $0x0,%ebx
  800345:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800348:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80034b:	39 d3                	cmp    %edx,%ebx
  80034d:	72 05                	jb     800354 <printnum+0x30>
  80034f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800352:	77 7a                	ja     8003ce <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 18             	pushl  0x18(%ebp)
  80035a:	8b 45 14             	mov    0x14(%ebp),%eax
  80035d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800360:	53                   	push   %ebx
  800361:	ff 75 10             	pushl  0x10(%ebp)
  800364:	83 ec 08             	sub    $0x8,%esp
  800367:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036a:	ff 75 e0             	pushl  -0x20(%ebp)
  80036d:	ff 75 dc             	pushl  -0x24(%ebp)
  800370:	ff 75 d8             	pushl  -0x28(%ebp)
  800373:	e8 38 21 00 00       	call   8024b0 <__udivdi3>
  800378:	83 c4 18             	add    $0x18,%esp
  80037b:	52                   	push   %edx
  80037c:	50                   	push   %eax
  80037d:	89 f2                	mov    %esi,%edx
  80037f:	89 f8                	mov    %edi,%eax
  800381:	e8 9e ff ff ff       	call   800324 <printnum>
  800386:	83 c4 20             	add    $0x20,%esp
  800389:	eb 13                	jmp    80039e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	56                   	push   %esi
  80038f:	ff 75 18             	pushl  0x18(%ebp)
  800392:	ff d7                	call   *%edi
  800394:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800397:	83 eb 01             	sub    $0x1,%ebx
  80039a:	85 db                	test   %ebx,%ebx
  80039c:	7f ed                	jg     80038b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	56                   	push   %esi
  8003a2:	83 ec 04             	sub    $0x4,%esp
  8003a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b1:	e8 1a 22 00 00       	call   8025d0 <__umoddi3>
  8003b6:	83 c4 14             	add    $0x14,%esp
  8003b9:	0f be 80 03 28 80 00 	movsbl 0x802803(%eax),%eax
  8003c0:	50                   	push   %eax
  8003c1:	ff d7                	call   *%edi
}
  8003c3:	83 c4 10             	add    $0x10,%esp
  8003c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c9:	5b                   	pop    %ebx
  8003ca:	5e                   	pop    %esi
  8003cb:	5f                   	pop    %edi
  8003cc:	5d                   	pop    %ebp
  8003cd:	c3                   	ret    
  8003ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003d1:	eb c4                	jmp    800397 <printnum+0x73>

008003d3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003dd:	8b 10                	mov    (%eax),%edx
  8003df:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e2:	73 0a                	jae    8003ee <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e7:	89 08                	mov    %ecx,(%eax)
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	88 02                	mov    %al,(%edx)
}
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <printfmt>:
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f9:	50                   	push   %eax
  8003fa:	ff 75 10             	pushl  0x10(%ebp)
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 05 00 00 00       	call   80040d <vprintfmt>
}
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <vprintfmt>:
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	57                   	push   %edi
  800411:	56                   	push   %esi
  800412:	53                   	push   %ebx
  800413:	83 ec 2c             	sub    $0x2c,%esp
  800416:	8b 75 08             	mov    0x8(%ebp),%esi
  800419:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041f:	e9 c1 03 00 00       	jmp    8007e5 <vprintfmt+0x3d8>
		padc = ' ';
  800424:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800428:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800436:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8d 47 01             	lea    0x1(%edi),%eax
  800445:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800448:	0f b6 17             	movzbl (%edi),%edx
  80044b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044e:	3c 55                	cmp    $0x55,%al
  800450:	0f 87 12 04 00 00    	ja     800868 <vprintfmt+0x45b>
  800456:	0f b6 c0             	movzbl %al,%eax
  800459:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800463:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800467:	eb d9                	jmp    800442 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80046c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800470:	eb d0                	jmp    800442 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800472:	0f b6 d2             	movzbl %dl,%edx
  800475:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800480:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800483:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800487:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80048a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048d:	83 f9 09             	cmp    $0x9,%ecx
  800490:	77 55                	ja     8004e7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800492:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800495:	eb e9                	jmp    800480 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	8d 40 04             	lea    0x4(%eax),%eax
  8004a5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004af:	79 91                	jns    800442 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004be:	eb 82                	jmp    800442 <vprintfmt+0x35>
  8004c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ca:	0f 49 d0             	cmovns %eax,%edx
  8004cd:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d3:	e9 6a ff ff ff       	jmp    800442 <vprintfmt+0x35>
  8004d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004db:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e2:	e9 5b ff ff ff       	jmp    800442 <vprintfmt+0x35>
  8004e7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ed:	eb bc                	jmp    8004ab <vprintfmt+0x9e>
			lflag++;
  8004ef:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f5:	e9 48 ff ff ff       	jmp    800442 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	8d 78 04             	lea    0x4(%eax),%edi
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	ff 30                	pushl  (%eax)
  800506:	ff d6                	call   *%esi
			break;
  800508:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050e:	e9 cf 02 00 00       	jmp    8007e2 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8d 78 04             	lea    0x4(%eax),%edi
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	99                   	cltd   
  80051c:	31 d0                	xor    %edx,%eax
  80051e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800520:	83 f8 0f             	cmp    $0xf,%eax
  800523:	7f 23                	jg     800548 <vprintfmt+0x13b>
  800525:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  80052c:	85 d2                	test   %edx,%edx
  80052e:	74 18                	je     800548 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800530:	52                   	push   %edx
  800531:	68 e1 2c 80 00       	push   $0x802ce1
  800536:	53                   	push   %ebx
  800537:	56                   	push   %esi
  800538:	e8 b3 fe ff ff       	call   8003f0 <printfmt>
  80053d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800540:	89 7d 14             	mov    %edi,0x14(%ebp)
  800543:	e9 9a 02 00 00       	jmp    8007e2 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800548:	50                   	push   %eax
  800549:	68 1b 28 80 00       	push   $0x80281b
  80054e:	53                   	push   %ebx
  80054f:	56                   	push   %esi
  800550:	e8 9b fe ff ff       	call   8003f0 <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800558:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80055b:	e9 82 02 00 00       	jmp    8007e2 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	83 c0 04             	add    $0x4,%eax
  800566:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056e:	85 ff                	test   %edi,%edi
  800570:	b8 14 28 80 00       	mov    $0x802814,%eax
  800575:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800578:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057c:	0f 8e bd 00 00 00    	jle    80063f <vprintfmt+0x232>
  800582:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800586:	75 0e                	jne    800596 <vprintfmt+0x189>
  800588:	89 75 08             	mov    %esi,0x8(%ebp)
  80058b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800591:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800594:	eb 6d                	jmp    800603 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 d0             	pushl  -0x30(%ebp)
  80059c:	57                   	push   %edi
  80059d:	e8 6e 03 00 00       	call   800910 <strnlen>
  8005a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a5:	29 c1                	sub    %eax,%ecx
  8005a7:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005aa:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005ad:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b7:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b9:	eb 0f                	jmp    8005ca <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c4:	83 ef 01             	sub    $0x1,%edi
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	85 ff                	test   %edi,%edi
  8005cc:	7f ed                	jg     8005bb <vprintfmt+0x1ae>
  8005ce:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005d1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d4:	85 c9                	test   %ecx,%ecx
  8005d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005db:	0f 49 c1             	cmovns %ecx,%eax
  8005de:	29 c1                	sub    %eax,%ecx
  8005e0:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e9:	89 cb                	mov    %ecx,%ebx
  8005eb:	eb 16                	jmp    800603 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f1:	75 31                	jne    800624 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	ff 55 08             	call   *0x8(%ebp)
  8005fd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800600:	83 eb 01             	sub    $0x1,%ebx
  800603:	83 c7 01             	add    $0x1,%edi
  800606:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80060a:	0f be c2             	movsbl %dl,%eax
  80060d:	85 c0                	test   %eax,%eax
  80060f:	74 59                	je     80066a <vprintfmt+0x25d>
  800611:	85 f6                	test   %esi,%esi
  800613:	78 d8                	js     8005ed <vprintfmt+0x1e0>
  800615:	83 ee 01             	sub    $0x1,%esi
  800618:	79 d3                	jns    8005ed <vprintfmt+0x1e0>
  80061a:	89 df                	mov    %ebx,%edi
  80061c:	8b 75 08             	mov    0x8(%ebp),%esi
  80061f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800622:	eb 37                	jmp    80065b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800624:	0f be d2             	movsbl %dl,%edx
  800627:	83 ea 20             	sub    $0x20,%edx
  80062a:	83 fa 5e             	cmp    $0x5e,%edx
  80062d:	76 c4                	jbe    8005f3 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	ff 75 0c             	pushl  0xc(%ebp)
  800635:	6a 3f                	push   $0x3f
  800637:	ff 55 08             	call   *0x8(%ebp)
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	eb c1                	jmp    800600 <vprintfmt+0x1f3>
  80063f:	89 75 08             	mov    %esi,0x8(%ebp)
  800642:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800645:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800648:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80064b:	eb b6                	jmp    800603 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	53                   	push   %ebx
  800651:	6a 20                	push   $0x20
  800653:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800655:	83 ef 01             	sub    $0x1,%edi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	85 ff                	test   %edi,%edi
  80065d:	7f ee                	jg     80064d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	e9 78 01 00 00       	jmp    8007e2 <vprintfmt+0x3d5>
  80066a:	89 df                	mov    %ebx,%edi
  80066c:	8b 75 08             	mov    0x8(%ebp),%esi
  80066f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800672:	eb e7                	jmp    80065b <vprintfmt+0x24e>
	if (lflag >= 2)
  800674:	83 f9 01             	cmp    $0x1,%ecx
  800677:	7e 3f                	jle    8006b8 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 50 04             	mov    0x4(%eax),%edx
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 08             	lea    0x8(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800690:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800694:	79 5c                	jns    8006f2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 2d                	push   $0x2d
  80069c:	ff d6                	call   *%esi
				num = -(long long) num;
  80069e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a4:	f7 da                	neg    %edx
  8006a6:	83 d1 00             	adc    $0x0,%ecx
  8006a9:	f7 d9                	neg    %ecx
  8006ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b3:	e9 10 01 00 00       	jmp    8007c8 <vprintfmt+0x3bb>
	else if (lflag)
  8006b8:	85 c9                	test   %ecx,%ecx
  8006ba:	75 1b                	jne    8006d7 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 c1                	mov    %eax,%ecx
  8006c6:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d5:	eb b9                	jmp    800690 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 c1                	mov    %eax,%ecx
  8006e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f0:	eb 9e                	jmp    800690 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fd:	e9 c6 00 00 00       	jmp    8007c8 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800702:	83 f9 01             	cmp    $0x1,%ecx
  800705:	7e 18                	jle    80071f <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	8b 48 04             	mov    0x4(%eax),%ecx
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800715:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071a:	e9 a9 00 00 00       	jmp    8007c8 <vprintfmt+0x3bb>
	else if (lflag)
  80071f:	85 c9                	test   %ecx,%ecx
  800721:	75 1a                	jne    80073d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 10                	mov    (%eax),%edx
  800728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072d:	8d 40 04             	lea    0x4(%eax),%eax
  800730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800733:	b8 0a 00 00 00       	mov    $0xa,%eax
  800738:	e9 8b 00 00 00       	jmp    8007c8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	b9 00 00 00 00       	mov    $0x0,%ecx
  800747:	8d 40 04             	lea    0x4(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800752:	eb 74                	jmp    8007c8 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800754:	83 f9 01             	cmp    $0x1,%ecx
  800757:	7e 15                	jle    80076e <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 10                	mov    (%eax),%edx
  80075e:	8b 48 04             	mov    0x4(%eax),%ecx
  800761:	8d 40 08             	lea    0x8(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800767:	b8 08 00 00 00       	mov    $0x8,%eax
  80076c:	eb 5a                	jmp    8007c8 <vprintfmt+0x3bb>
	else if (lflag)
  80076e:	85 c9                	test   %ecx,%ecx
  800770:	75 17                	jne    800789 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 10                	mov    (%eax),%edx
  800777:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077c:	8d 40 04             	lea    0x4(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800782:	b8 08 00 00 00       	mov    $0x8,%eax
  800787:	eb 3f                	jmp    8007c8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 10                	mov    (%eax),%edx
  80078e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800799:	b8 08 00 00 00       	mov    $0x8,%eax
  80079e:	eb 28                	jmp    8007c8 <vprintfmt+0x3bb>
			putch('0', putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	53                   	push   %ebx
  8007a4:	6a 30                	push   $0x30
  8007a6:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a8:	83 c4 08             	add    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	6a 78                	push   $0x78
  8007ae:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 10                	mov    (%eax),%edx
  8007b5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007ba:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007c8:	83 ec 0c             	sub    $0xc,%esp
  8007cb:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007cf:	57                   	push   %edi
  8007d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d3:	50                   	push   %eax
  8007d4:	51                   	push   %ecx
  8007d5:	52                   	push   %edx
  8007d6:	89 da                	mov    %ebx,%edx
  8007d8:	89 f0                	mov    %esi,%eax
  8007da:	e8 45 fb ff ff       	call   800324 <printnum>
			break;
  8007df:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e5:	83 c7 01             	add    $0x1,%edi
  8007e8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ec:	83 f8 25             	cmp    $0x25,%eax
  8007ef:	0f 84 2f fc ff ff    	je     800424 <vprintfmt+0x17>
			if (ch == '\0')
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	0f 84 8b 00 00 00    	je     800888 <vprintfmt+0x47b>
			putch(ch, putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	50                   	push   %eax
  800802:	ff d6                	call   *%esi
  800804:	83 c4 10             	add    $0x10,%esp
  800807:	eb dc                	jmp    8007e5 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800809:	83 f9 01             	cmp    $0x1,%ecx
  80080c:	7e 15                	jle    800823 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8b 10                	mov    (%eax),%edx
  800813:	8b 48 04             	mov    0x4(%eax),%ecx
  800816:	8d 40 08             	lea    0x8(%eax),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081c:	b8 10 00 00 00       	mov    $0x10,%eax
  800821:	eb a5                	jmp    8007c8 <vprintfmt+0x3bb>
	else if (lflag)
  800823:	85 c9                	test   %ecx,%ecx
  800825:	75 17                	jne    80083e <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8b 10                	mov    (%eax),%edx
  80082c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800831:	8d 40 04             	lea    0x4(%eax),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800837:	b8 10 00 00 00       	mov    $0x10,%eax
  80083c:	eb 8a                	jmp    8007c8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8b 10                	mov    (%eax),%edx
  800843:	b9 00 00 00 00       	mov    $0x0,%ecx
  800848:	8d 40 04             	lea    0x4(%eax),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084e:	b8 10 00 00 00       	mov    $0x10,%eax
  800853:	e9 70 ff ff ff       	jmp    8007c8 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	53                   	push   %ebx
  80085c:	6a 25                	push   $0x25
  80085e:	ff d6                	call   *%esi
			break;
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	e9 7a ff ff ff       	jmp    8007e2 <vprintfmt+0x3d5>
			putch('%', putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	53                   	push   %ebx
  80086c:	6a 25                	push   $0x25
  80086e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	89 f8                	mov    %edi,%eax
  800875:	eb 03                	jmp    80087a <vprintfmt+0x46d>
  800877:	83 e8 01             	sub    $0x1,%eax
  80087a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80087e:	75 f7                	jne    800877 <vprintfmt+0x46a>
  800880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800883:	e9 5a ff ff ff       	jmp    8007e2 <vprintfmt+0x3d5>
}
  800888:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088b:	5b                   	pop    %ebx
  80088c:	5e                   	pop    %esi
  80088d:	5f                   	pop    %edi
  80088e:	5d                   	pop    %ebp
  80088f:	c3                   	ret    

00800890 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80089c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80089f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ad:	85 c0                	test   %eax,%eax
  8008af:	74 26                	je     8008d7 <vsnprintf+0x47>
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	7e 22                	jle    8008d7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b5:	ff 75 14             	pushl  0x14(%ebp)
  8008b8:	ff 75 10             	pushl  0x10(%ebp)
  8008bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008be:	50                   	push   %eax
  8008bf:	68 d3 03 80 00       	push   $0x8003d3
  8008c4:	e8 44 fb ff ff       	call   80040d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
}
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    
		return -E_INVAL;
  8008d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008dc:	eb f7                	jmp    8008d5 <vsnprintf+0x45>

008008de <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e7:	50                   	push   %eax
  8008e8:	ff 75 10             	pushl  0x10(%ebp)
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 9a ff ff ff       	call   800890 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	eb 03                	jmp    800908 <strlen+0x10>
		n++;
  800905:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800908:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090c:	75 f7                	jne    800905 <strlen+0xd>
	return n;
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800919:	b8 00 00 00 00       	mov    $0x0,%eax
  80091e:	eb 03                	jmp    800923 <strnlen+0x13>
		n++;
  800920:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800923:	39 d0                	cmp    %edx,%eax
  800925:	74 06                	je     80092d <strnlen+0x1d>
  800927:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80092b:	75 f3                	jne    800920 <strnlen+0x10>
	return n;
}
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	53                   	push   %ebx
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800939:	89 c2                	mov    %eax,%edx
  80093b:	83 c1 01             	add    $0x1,%ecx
  80093e:	83 c2 01             	add    $0x1,%edx
  800941:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800945:	88 5a ff             	mov    %bl,-0x1(%edx)
  800948:	84 db                	test   %bl,%bl
  80094a:	75 ef                	jne    80093b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80094c:	5b                   	pop    %ebx
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800956:	53                   	push   %ebx
  800957:	e8 9c ff ff ff       	call   8008f8 <strlen>
  80095c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	01 d8                	add    %ebx,%eax
  800964:	50                   	push   %eax
  800965:	e8 c5 ff ff ff       	call   80092f <strcpy>
	return dst;
}
  80096a:	89 d8                	mov    %ebx,%eax
  80096c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	56                   	push   %esi
  800975:	53                   	push   %ebx
  800976:	8b 75 08             	mov    0x8(%ebp),%esi
  800979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097c:	89 f3                	mov    %esi,%ebx
  80097e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800981:	89 f2                	mov    %esi,%edx
  800983:	eb 0f                	jmp    800994 <strncpy+0x23>
		*dst++ = *src;
  800985:	83 c2 01             	add    $0x1,%edx
  800988:	0f b6 01             	movzbl (%ecx),%eax
  80098b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098e:	80 39 01             	cmpb   $0x1,(%ecx)
  800991:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800994:	39 da                	cmp    %ebx,%edx
  800996:	75 ed                	jne    800985 <strncpy+0x14>
	}
	return ret;
}
  800998:	89 f0                	mov    %esi,%eax
  80099a:	5b                   	pop    %ebx
  80099b:	5e                   	pop    %esi
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	56                   	push   %esi
  8009a2:	53                   	push   %ebx
  8009a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009ac:	89 f0                	mov    %esi,%eax
  8009ae:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b2:	85 c9                	test   %ecx,%ecx
  8009b4:	75 0b                	jne    8009c1 <strlcpy+0x23>
  8009b6:	eb 17                	jmp    8009cf <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009c1:	39 d8                	cmp    %ebx,%eax
  8009c3:	74 07                	je     8009cc <strlcpy+0x2e>
  8009c5:	0f b6 0a             	movzbl (%edx),%ecx
  8009c8:	84 c9                	test   %cl,%cl
  8009ca:	75 ec                	jne    8009b8 <strlcpy+0x1a>
		*dst = '\0';
  8009cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009cf:	29 f0                	sub    %esi,%eax
}
  8009d1:	5b                   	pop    %ebx
  8009d2:	5e                   	pop    %esi
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009db:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009de:	eb 06                	jmp    8009e6 <strcmp+0x11>
		p++, q++;
  8009e0:	83 c1 01             	add    $0x1,%ecx
  8009e3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009e6:	0f b6 01             	movzbl (%ecx),%eax
  8009e9:	84 c0                	test   %al,%al
  8009eb:	74 04                	je     8009f1 <strcmp+0x1c>
  8009ed:	3a 02                	cmp    (%edx),%al
  8009ef:	74 ef                	je     8009e0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f1:	0f b6 c0             	movzbl %al,%eax
  8009f4:	0f b6 12             	movzbl (%edx),%edx
  8009f7:	29 d0                	sub    %edx,%eax
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a05:	89 c3                	mov    %eax,%ebx
  800a07:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a0a:	eb 06                	jmp    800a12 <strncmp+0x17>
		n--, p++, q++;
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a12:	39 d8                	cmp    %ebx,%eax
  800a14:	74 16                	je     800a2c <strncmp+0x31>
  800a16:	0f b6 08             	movzbl (%eax),%ecx
  800a19:	84 c9                	test   %cl,%cl
  800a1b:	74 04                	je     800a21 <strncmp+0x26>
  800a1d:	3a 0a                	cmp    (%edx),%cl
  800a1f:	74 eb                	je     800a0c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a21:	0f b6 00             	movzbl (%eax),%eax
  800a24:	0f b6 12             	movzbl (%edx),%edx
  800a27:	29 d0                	sub    %edx,%eax
}
  800a29:	5b                   	pop    %ebx
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    
		return 0;
  800a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a31:	eb f6                	jmp    800a29 <strncmp+0x2e>

00800a33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3d:	0f b6 10             	movzbl (%eax),%edx
  800a40:	84 d2                	test   %dl,%dl
  800a42:	74 09                	je     800a4d <strchr+0x1a>
		if (*s == c)
  800a44:	38 ca                	cmp    %cl,%dl
  800a46:	74 0a                	je     800a52 <strchr+0x1f>
	for (; *s; s++)
  800a48:	83 c0 01             	add    $0x1,%eax
  800a4b:	eb f0                	jmp    800a3d <strchr+0xa>
			return (char *) s;
	return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5e:	eb 03                	jmp    800a63 <strfind+0xf>
  800a60:	83 c0 01             	add    $0x1,%eax
  800a63:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a66:	38 ca                	cmp    %cl,%dl
  800a68:	74 04                	je     800a6e <strfind+0x1a>
  800a6a:	84 d2                	test   %dl,%dl
  800a6c:	75 f2                	jne    800a60 <strfind+0xc>
			break;
	return (char *) s;
}
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	57                   	push   %edi
  800a74:	56                   	push   %esi
  800a75:	53                   	push   %ebx
  800a76:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a79:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a7c:	85 c9                	test   %ecx,%ecx
  800a7e:	74 13                	je     800a93 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a80:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a86:	75 05                	jne    800a8d <memset+0x1d>
  800a88:	f6 c1 03             	test   $0x3,%cl
  800a8b:	74 0d                	je     800a9a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a90:	fc                   	cld    
  800a91:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a93:	89 f8                	mov    %edi,%eax
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5f                   	pop    %edi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    
		c &= 0xFF;
  800a9a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9e:	89 d3                	mov    %edx,%ebx
  800aa0:	c1 e3 08             	shl    $0x8,%ebx
  800aa3:	89 d0                	mov    %edx,%eax
  800aa5:	c1 e0 18             	shl    $0x18,%eax
  800aa8:	89 d6                	mov    %edx,%esi
  800aaa:	c1 e6 10             	shl    $0x10,%esi
  800aad:	09 f0                	or     %esi,%eax
  800aaf:	09 c2                	or     %eax,%edx
  800ab1:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ab3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	fc                   	cld    
  800ab9:	f3 ab                	rep stos %eax,%es:(%edi)
  800abb:	eb d6                	jmp    800a93 <memset+0x23>

00800abd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	57                   	push   %edi
  800ac1:	56                   	push   %esi
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800acb:	39 c6                	cmp    %eax,%esi
  800acd:	73 35                	jae    800b04 <memmove+0x47>
  800acf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad2:	39 c2                	cmp    %eax,%edx
  800ad4:	76 2e                	jbe    800b04 <memmove+0x47>
		s += n;
		d += n;
  800ad6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad9:	89 d6                	mov    %edx,%esi
  800adb:	09 fe                	or     %edi,%esi
  800add:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae3:	74 0c                	je     800af1 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae5:	83 ef 01             	sub    $0x1,%edi
  800ae8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aeb:	fd                   	std    
  800aec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aee:	fc                   	cld    
  800aef:	eb 21                	jmp    800b12 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af1:	f6 c1 03             	test   $0x3,%cl
  800af4:	75 ef                	jne    800ae5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af6:	83 ef 04             	sub    $0x4,%edi
  800af9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800afc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aff:	fd                   	std    
  800b00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b02:	eb ea                	jmp    800aee <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b04:	89 f2                	mov    %esi,%edx
  800b06:	09 c2                	or     %eax,%edx
  800b08:	f6 c2 03             	test   $0x3,%dl
  800b0b:	74 09                	je     800b16 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b0d:	89 c7                	mov    %eax,%edi
  800b0f:	fc                   	cld    
  800b10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b16:	f6 c1 03             	test   $0x3,%cl
  800b19:	75 f2                	jne    800b0d <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1e:	89 c7                	mov    %eax,%edi
  800b20:	fc                   	cld    
  800b21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b23:	eb ed                	jmp    800b12 <memmove+0x55>

00800b25 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b28:	ff 75 10             	pushl  0x10(%ebp)
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	ff 75 08             	pushl  0x8(%ebp)
  800b31:	e8 87 ff ff ff       	call   800abd <memmove>
}
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b43:	89 c6                	mov    %eax,%esi
  800b45:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b48:	39 f0                	cmp    %esi,%eax
  800b4a:	74 1c                	je     800b68 <memcmp+0x30>
		if (*s1 != *s2)
  800b4c:	0f b6 08             	movzbl (%eax),%ecx
  800b4f:	0f b6 1a             	movzbl (%edx),%ebx
  800b52:	38 d9                	cmp    %bl,%cl
  800b54:	75 08                	jne    800b5e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b56:	83 c0 01             	add    $0x1,%eax
  800b59:	83 c2 01             	add    $0x1,%edx
  800b5c:	eb ea                	jmp    800b48 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b5e:	0f b6 c1             	movzbl %cl,%eax
  800b61:	0f b6 db             	movzbl %bl,%ebx
  800b64:	29 d8                	sub    %ebx,%eax
  800b66:	eb 05                	jmp    800b6d <memcmp+0x35>
	}

	return 0;
  800b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7f:	39 d0                	cmp    %edx,%eax
  800b81:	73 09                	jae    800b8c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b83:	38 08                	cmp    %cl,(%eax)
  800b85:	74 05                	je     800b8c <memfind+0x1b>
	for (; s < ends; s++)
  800b87:	83 c0 01             	add    $0x1,%eax
  800b8a:	eb f3                	jmp    800b7f <memfind+0xe>
			break;
	return (void *) s;
}
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9a:	eb 03                	jmp    800b9f <strtol+0x11>
		s++;
  800b9c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b9f:	0f b6 01             	movzbl (%ecx),%eax
  800ba2:	3c 20                	cmp    $0x20,%al
  800ba4:	74 f6                	je     800b9c <strtol+0xe>
  800ba6:	3c 09                	cmp    $0x9,%al
  800ba8:	74 f2                	je     800b9c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800baa:	3c 2b                	cmp    $0x2b,%al
  800bac:	74 2e                	je     800bdc <strtol+0x4e>
	int neg = 0;
  800bae:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb3:	3c 2d                	cmp    $0x2d,%al
  800bb5:	74 2f                	je     800be6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbd:	75 05                	jne    800bc4 <strtol+0x36>
  800bbf:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc2:	74 2c                	je     800bf0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc4:	85 db                	test   %ebx,%ebx
  800bc6:	75 0a                	jne    800bd2 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc8:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bcd:	80 39 30             	cmpb   $0x30,(%ecx)
  800bd0:	74 28                	je     800bfa <strtol+0x6c>
		base = 10;
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bda:	eb 50                	jmp    800c2c <strtol+0x9e>
		s++;
  800bdc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800be4:	eb d1                	jmp    800bb7 <strtol+0x29>
		s++, neg = 1;
  800be6:	83 c1 01             	add    $0x1,%ecx
  800be9:	bf 01 00 00 00       	mov    $0x1,%edi
  800bee:	eb c7                	jmp    800bb7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf4:	74 0e                	je     800c04 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf6:	85 db                	test   %ebx,%ebx
  800bf8:	75 d8                	jne    800bd2 <strtol+0x44>
		s++, base = 8;
  800bfa:	83 c1 01             	add    $0x1,%ecx
  800bfd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c02:	eb ce                	jmp    800bd2 <strtol+0x44>
		s += 2, base = 16;
  800c04:	83 c1 02             	add    $0x2,%ecx
  800c07:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0c:	eb c4                	jmp    800bd2 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c11:	89 f3                	mov    %esi,%ebx
  800c13:	80 fb 19             	cmp    $0x19,%bl
  800c16:	77 29                	ja     800c41 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c18:	0f be d2             	movsbl %dl,%edx
  800c1b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c21:	7d 30                	jge    800c53 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c23:	83 c1 01             	add    $0x1,%ecx
  800c26:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2c:	0f b6 11             	movzbl (%ecx),%edx
  800c2f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c32:	89 f3                	mov    %esi,%ebx
  800c34:	80 fb 09             	cmp    $0x9,%bl
  800c37:	77 d5                	ja     800c0e <strtol+0x80>
			dig = *s - '0';
  800c39:	0f be d2             	movsbl %dl,%edx
  800c3c:	83 ea 30             	sub    $0x30,%edx
  800c3f:	eb dd                	jmp    800c1e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c41:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c44:	89 f3                	mov    %esi,%ebx
  800c46:	80 fb 19             	cmp    $0x19,%bl
  800c49:	77 08                	ja     800c53 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c4b:	0f be d2             	movsbl %dl,%edx
  800c4e:	83 ea 37             	sub    $0x37,%edx
  800c51:	eb cb                	jmp    800c1e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c57:	74 05                	je     800c5e <strtol+0xd0>
		*endptr = (char *) s;
  800c59:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5e:	89 c2                	mov    %eax,%edx
  800c60:	f7 da                	neg    %edx
  800c62:	85 ff                	test   %edi,%edi
  800c64:	0f 45 c2             	cmovne %edx,%eax
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7d:	89 c3                	mov    %eax,%ebx
  800c7f:	89 c7                	mov    %eax,%edi
  800c81:	89 c6                	mov    %eax,%esi
  800c83:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbf:	89 cb                	mov    %ecx,%ebx
  800cc1:	89 cf                	mov    %ecx,%edi
  800cc3:	89 ce                	mov    %ecx,%esi
  800cc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7f 08                	jg     800cd3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	50                   	push   %eax
  800cd7:	6a 03                	push   $0x3
  800cd9:	68 ff 2a 80 00       	push   $0x802aff
  800cde:	6a 23                	push   $0x23
  800ce0:	68 1c 2b 80 00       	push   $0x802b1c
  800ce5:	e8 4b f5 ff ff       	call   800235 <_panic>

00800cea <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf5:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfa:	89 d1                	mov    %edx,%ecx
  800cfc:	89 d3                	mov    %edx,%ebx
  800cfe:	89 d7                	mov    %edx,%edi
  800d00:	89 d6                	mov    %edx,%esi
  800d02:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <sys_yield>:

void
sys_yield(void)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d14:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d19:	89 d1                	mov    %edx,%ecx
  800d1b:	89 d3                	mov    %edx,%ebx
  800d1d:	89 d7                	mov    %edx,%edi
  800d1f:	89 d6                	mov    %edx,%esi
  800d21:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	be 00 00 00 00       	mov    $0x0,%esi
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d44:	89 f7                	mov    %esi,%edi
  800d46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7f 08                	jg     800d54 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	50                   	push   %eax
  800d58:	6a 04                	push   $0x4
  800d5a:	68 ff 2a 80 00       	push   $0x802aff
  800d5f:	6a 23                	push   $0x23
  800d61:	68 1c 2b 80 00       	push   $0x802b1c
  800d66:	e8 ca f4 ff ff       	call   800235 <_panic>

00800d6b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d82:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d85:	8b 75 18             	mov    0x18(%ebp),%esi
  800d88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7f 08                	jg     800d96 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	50                   	push   %eax
  800d9a:	6a 05                	push   $0x5
  800d9c:	68 ff 2a 80 00       	push   $0x802aff
  800da1:	6a 23                	push   $0x23
  800da3:	68 1c 2b 80 00       	push   $0x802b1c
  800da8:	e8 88 f4 ff ff       	call   800235 <_panic>

00800dad <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc1:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7f 08                	jg     800dd8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	6a 06                	push   $0x6
  800dde:	68 ff 2a 80 00       	push   $0x802aff
  800de3:	6a 23                	push   $0x23
  800de5:	68 1c 2b 80 00       	push   $0x802b1c
  800dea:	e8 46 f4 ff ff       	call   800235 <_panic>

00800def <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	b8 08 00 00 00       	mov    $0x8,%eax
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 08                	push   $0x8
  800e20:	68 ff 2a 80 00       	push   $0x802aff
  800e25:	6a 23                	push   $0x23
  800e27:	68 1c 2b 80 00       	push   $0x802b1c
  800e2c:	e8 04 f4 ff ff       	call   800235 <_panic>

00800e31 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	89 de                	mov    %ebx,%esi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 09                	push   $0x9
  800e62:	68 ff 2a 80 00       	push   $0x802aff
  800e67:	6a 23                	push   $0x23
  800e69:	68 1c 2b 80 00       	push   $0x802b1c
  800e6e:	e8 c2 f3 ff ff       	call   800235 <_panic>

00800e73 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8c:	89 df                	mov    %ebx,%edi
  800e8e:	89 de                	mov    %ebx,%esi
  800e90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7f 08                	jg     800e9e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	50                   	push   %eax
  800ea2:	6a 0a                	push   $0xa
  800ea4:	68 ff 2a 80 00       	push   $0x802aff
  800ea9:	6a 23                	push   $0x23
  800eab:	68 1c 2b 80 00       	push   $0x802b1c
  800eb0:	e8 80 f3 ff ff       	call   800235 <_panic>

00800eb5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec6:	be 00 00 00 00       	mov    $0x0,%esi
  800ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ece:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eee:	89 cb                	mov    %ecx,%ebx
  800ef0:	89 cf                	mov    %ecx,%edi
  800ef2:	89 ce                	mov    %ecx,%esi
  800ef4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	7f 08                	jg     800f02 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f02:	83 ec 0c             	sub    $0xc,%esp
  800f05:	50                   	push   %eax
  800f06:	6a 0d                	push   $0xd
  800f08:	68 ff 2a 80 00       	push   $0x802aff
  800f0d:	6a 23                	push   $0x23
  800f0f:	68 1c 2b 80 00       	push   $0x802b1c
  800f14:	e8 1c f3 ff ff       	call   800235 <_panic>

00800f19 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f24:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f29:	89 d1                	mov    %edx,%ecx
  800f2b:	89 d3                	mov    %edx,%ebx
  800f2d:	89 d7                	mov    %edx,%edi
  800f2f:	89 d6                	mov    %edx,%esi
  800f31:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800f40:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f42:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f46:	74 7f                	je     800fc7 <pgfault+0x8f>
  800f48:	89 d8                	mov    %ebx,%eax
  800f4a:	c1 e8 0c             	shr    $0xc,%eax
  800f4d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f54:	f6 c4 08             	test   $0x8,%ah
  800f57:	74 6e                	je     800fc7 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800f59:	e8 8c fd ff ff       	call   800cea <sys_getenvid>
  800f5e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	6a 07                	push   $0x7
  800f65:	68 00 f0 7f 00       	push   $0x7ff000
  800f6a:	50                   	push   %eax
  800f6b:	e8 b8 fd ff ff       	call   800d28 <sys_page_alloc>
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	85 c0                	test   %eax,%eax
  800f75:	78 64                	js     800fdb <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800f77:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800f7d:	83 ec 04             	sub    $0x4,%esp
  800f80:	68 00 10 00 00       	push   $0x1000
  800f85:	53                   	push   %ebx
  800f86:	68 00 f0 7f 00       	push   $0x7ff000
  800f8b:	e8 2d fb ff ff       	call   800abd <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800f90:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f97:	53                   	push   %ebx
  800f98:	56                   	push   %esi
  800f99:	68 00 f0 7f 00       	push   $0x7ff000
  800f9e:	56                   	push   %esi
  800f9f:	e8 c7 fd ff ff       	call   800d6b <sys_page_map>
  800fa4:	83 c4 20             	add    $0x20,%esp
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	78 42                	js     800fed <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	68 00 f0 7f 00       	push   $0x7ff000
  800fb3:	56                   	push   %esi
  800fb4:	e8 f4 fd ff ff       	call   800dad <sys_page_unmap>
  800fb9:	83 c4 10             	add    $0x10,%esp
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	78 3f                	js     800fff <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fc3:	5b                   	pop    %ebx
  800fc4:	5e                   	pop    %esi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800fc7:	83 ec 04             	sub    $0x4,%esp
  800fca:	68 2c 2b 80 00       	push   $0x802b2c
  800fcf:	6a 1d                	push   $0x1d
  800fd1:	68 bb 2b 80 00       	push   $0x802bbb
  800fd6:	e8 5a f2 ff ff       	call   800235 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800fdb:	50                   	push   %eax
  800fdc:	68 54 2b 80 00       	push   $0x802b54
  800fe1:	6a 28                	push   $0x28
  800fe3:	68 bb 2b 80 00       	push   $0x802bbb
  800fe8:	e8 48 f2 ff ff       	call   800235 <_panic>
		panic("pgfault:page map failed: %e", r);
  800fed:	50                   	push   %eax
  800fee:	68 c6 2b 80 00       	push   $0x802bc6
  800ff3:	6a 2c                	push   $0x2c
  800ff5:	68 bb 2b 80 00       	push   $0x802bbb
  800ffa:	e8 36 f2 ff ff       	call   800235 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800fff:	50                   	push   %eax
  801000:	68 78 2b 80 00       	push   $0x802b78
  801005:	6a 2e                	push   $0x2e
  801007:	68 bb 2b 80 00       	push   $0x802bbb
  80100c:	e8 24 f2 ff ff       	call   800235 <_panic>

00801011 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
  801017:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  80101a:	68 38 0f 80 00       	push   $0x800f38
  80101f:	e8 c6 13 00 00       	call   8023ea <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801024:	b8 07 00 00 00       	mov    $0x7,%eax
  801029:	cd 30                	int    $0x30
  80102b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	85 c0                	test   %eax,%eax
  801033:	78 2f                	js     801064 <fork+0x53>
  801035:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801037:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  80103c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801040:	75 6e                	jne    8010b0 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801042:	e8 a3 fc ff ff       	call   800cea <sys_getenvid>
  801047:	25 ff 03 00 00       	and    $0x3ff,%eax
  80104c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80104f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801054:	a3 0c 40 80 00       	mov    %eax,0x80400c
		return 0;
  801059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  80105c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  801064:	50                   	push   %eax
  801065:	68 98 2b 80 00       	push   $0x802b98
  80106a:	6a 6e                	push   $0x6e
  80106c:	68 bb 2b 80 00       	push   $0x802bbb
  801071:	e8 bf f1 ff ff       	call   800235 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801076:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80107d:	83 ec 0c             	sub    $0xc,%esp
  801080:	25 07 0e 00 00       	and    $0xe07,%eax
  801085:	50                   	push   %eax
  801086:	56                   	push   %esi
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	6a 00                	push   $0x0
  80108b:	e8 db fc ff ff       	call   800d6b <sys_page_map>
  801090:	83 c4 20             	add    $0x20,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	ba 00 00 00 00       	mov    $0x0,%edx
  80109a:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  80109d:	85 c0                	test   %eax,%eax
  80109f:	78 bb                	js     80105c <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8010a1:	83 c3 01             	add    $0x1,%ebx
  8010a4:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8010aa:	0f 84 a6 00 00 00    	je     801156 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8010b0:	89 d8                	mov    %ebx,%eax
  8010b2:	c1 e8 0a             	shr    $0xa,%eax
  8010b5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010bc:	a8 01                	test   $0x1,%al
  8010be:	74 e1                	je     8010a1 <fork+0x90>
  8010c0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010c7:	a8 01                	test   $0x1,%al
  8010c9:	74 d6                	je     8010a1 <fork+0x90>
  8010cb:	89 de                	mov    %ebx,%esi
  8010cd:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  8010d0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010d7:	f6 c4 04             	test   $0x4,%ah
  8010da:	75 9a                	jne    801076 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  8010dc:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010e3:	a8 02                	test   $0x2,%al
  8010e5:	75 0c                	jne    8010f3 <fork+0xe2>
  8010e7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010ee:	f6 c4 08             	test   $0x8,%ah
  8010f1:	74 42                	je     801135 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8010f3:	83 ec 0c             	sub    $0xc,%esp
  8010f6:	68 05 08 00 00       	push   $0x805
  8010fb:	56                   	push   %esi
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	6a 00                	push   $0x0
  801100:	e8 66 fc ff ff       	call   800d6b <sys_page_map>
  801105:	83 c4 20             	add    $0x20,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	0f 88 4c ff ff ff    	js     80105c <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801110:	83 ec 0c             	sub    $0xc,%esp
  801113:	68 05 08 00 00       	push   $0x805
  801118:	56                   	push   %esi
  801119:	6a 00                	push   $0x0
  80111b:	56                   	push   %esi
  80111c:	6a 00                	push   $0x0
  80111e:	e8 48 fc ff ff       	call   800d6b <sys_page_map>
  801123:	83 c4 20             	add    $0x20,%esp
  801126:	85 c0                	test   %eax,%eax
  801128:	b9 00 00 00 00       	mov    $0x0,%ecx
  80112d:	0f 4f c1             	cmovg  %ecx,%eax
  801130:	e9 68 ff ff ff       	jmp    80109d <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	6a 05                	push   $0x5
  80113a:	56                   	push   %esi
  80113b:	57                   	push   %edi
  80113c:	56                   	push   %esi
  80113d:	6a 00                	push   $0x0
  80113f:	e8 27 fc ff ff       	call   800d6b <sys_page_map>
  801144:	83 c4 20             	add    $0x20,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	b9 00 00 00 00       	mov    $0x0,%ecx
  80114e:	0f 4f c1             	cmovg  %ecx,%eax
  801151:	e9 47 ff ff ff       	jmp    80109d <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801156:	83 ec 04             	sub    $0x4,%esp
  801159:	6a 07                	push   $0x7
  80115b:	68 00 f0 bf ee       	push   $0xeebff000
  801160:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801163:	57                   	push   %edi
  801164:	e8 bf fb ff ff       	call   800d28 <sys_page_alloc>
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	0f 88 e8 fe ff ff    	js     80105c <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	68 4f 24 80 00       	push   $0x80244f
  80117c:	57                   	push   %edi
  80117d:	e8 f1 fc ff ff       	call   800e73 <sys_env_set_pgfault_upcall>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	0f 88 cf fe ff ff    	js     80105c <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	6a 02                	push   $0x2
  801192:	57                   	push   %edi
  801193:	e8 57 fc ff ff       	call   800def <sys_env_set_status>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 08                	js     8011a7 <fork+0x196>
	return eid;
  80119f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a2:	e9 b5 fe ff ff       	jmp    80105c <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  8011a7:	50                   	push   %eax
  8011a8:	68 e2 2b 80 00       	push   $0x802be2
  8011ad:	68 87 00 00 00       	push   $0x87
  8011b2:	68 bb 2b 80 00       	push   $0x802bbb
  8011b7:	e8 79 f0 ff ff       	call   800235 <_panic>

008011bc <sfork>:

// Challenge!
int sfork(void)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011c2:	68 00 2c 80 00       	push   $0x802c00
  8011c7:	68 8f 00 00 00       	push   $0x8f
  8011cc:	68 bb 2b 80 00       	push   $0x802bbb
  8011d1:	e8 5f f0 ff ff       	call   800235 <_panic>

008011d6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	8b 75 08             	mov    0x8(%ebp),%esi
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8011e4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8011e6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8011eb:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	50                   	push   %eax
  8011f2:	e8 e1 fc ff ff       	call   800ed8 <sys_ipc_recv>
	if (from_env_store)
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	85 f6                	test   %esi,%esi
  8011fc:	74 14                	je     801212 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8011fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801203:	85 c0                	test   %eax,%eax
  801205:	78 09                	js     801210 <ipc_recv+0x3a>
  801207:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80120d:	8b 52 74             	mov    0x74(%edx),%edx
  801210:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801212:	85 db                	test   %ebx,%ebx
  801214:	74 14                	je     80122a <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801216:	ba 00 00 00 00       	mov    $0x0,%edx
  80121b:	85 c0                	test   %eax,%eax
  80121d:	78 09                	js     801228 <ipc_recv+0x52>
  80121f:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801225:	8b 52 78             	mov    0x78(%edx),%edx
  801228:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 08                	js     801236 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  80122e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801233:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801236:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	57                   	push   %edi
  801241:	56                   	push   %esi
  801242:	53                   	push   %ebx
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	8b 7d 08             	mov    0x8(%ebp),%edi
  801249:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80124f:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801251:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801256:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801259:	ff 75 14             	pushl  0x14(%ebp)
  80125c:	53                   	push   %ebx
  80125d:	56                   	push   %esi
  80125e:	57                   	push   %edi
  80125f:	e8 51 fc ff ff       	call   800eb5 <sys_ipc_try_send>
		if (ret == 0)
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	74 1e                	je     801289 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80126b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80126e:	75 07                	jne    801277 <ipc_send+0x3a>
			sys_yield();
  801270:	e8 94 fa ff ff       	call   800d09 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801275:	eb e2                	jmp    801259 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801277:	50                   	push   %eax
  801278:	68 16 2c 80 00       	push   $0x802c16
  80127d:	6a 3d                	push   $0x3d
  80127f:	68 2a 2c 80 00       	push   $0x802c2a
  801284:	e8 ac ef ff ff       	call   800235 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801289:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5f                   	pop    %edi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80129c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80129f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012a5:	8b 52 50             	mov    0x50(%edx),%edx
  8012a8:	39 ca                	cmp    %ecx,%edx
  8012aa:	74 11                	je     8012bd <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8012ac:	83 c0 01             	add    $0x1,%eax
  8012af:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012b4:	75 e6                	jne    80129c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8012b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bb:	eb 0b                	jmp    8012c8 <ipc_find_env+0x37>
			return envs[i].env_id;
  8012bd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    

008012ca <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	05 00 00 00 30       	add    $0x30000000,%eax
  8012d5:	c1 e8 0c             	shr    $0xc,%eax
}
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ea:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	c1 ea 16             	shr    $0x16,%edx
  801301:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801308:	f6 c2 01             	test   $0x1,%dl
  80130b:	74 2a                	je     801337 <fd_alloc+0x46>
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	c1 ea 0c             	shr    $0xc,%edx
  801312:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801319:	f6 c2 01             	test   $0x1,%dl
  80131c:	74 19                	je     801337 <fd_alloc+0x46>
  80131e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801323:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801328:	75 d2                	jne    8012fc <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80132a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801330:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801335:	eb 07                	jmp    80133e <fd_alloc+0x4d>
			*fd_store = fd;
  801337:	89 01                	mov    %eax,(%ecx)
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133e:	5d                   	pop    %ebp
  80133f:	c3                   	ret    

00801340 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801346:	83 f8 1f             	cmp    $0x1f,%eax
  801349:	77 36                	ja     801381 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80134b:	c1 e0 0c             	shl    $0xc,%eax
  80134e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801353:	89 c2                	mov    %eax,%edx
  801355:	c1 ea 16             	shr    $0x16,%edx
  801358:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80135f:	f6 c2 01             	test   $0x1,%dl
  801362:	74 24                	je     801388 <fd_lookup+0x48>
  801364:	89 c2                	mov    %eax,%edx
  801366:	c1 ea 0c             	shr    $0xc,%edx
  801369:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801370:	f6 c2 01             	test   $0x1,%dl
  801373:	74 1a                	je     80138f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801375:	8b 55 0c             	mov    0xc(%ebp),%edx
  801378:	89 02                	mov    %eax,(%edx)
	return 0;
  80137a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    
		return -E_INVAL;
  801381:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801386:	eb f7                	jmp    80137f <fd_lookup+0x3f>
		return -E_INVAL;
  801388:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138d:	eb f0                	jmp    80137f <fd_lookup+0x3f>
  80138f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801394:	eb e9                	jmp    80137f <fd_lookup+0x3f>

00801396 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 08             	sub    $0x8,%esp
  80139c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139f:	ba b4 2c 80 00       	mov    $0x802cb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013a4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013a9:	39 08                	cmp    %ecx,(%eax)
  8013ab:	74 33                	je     8013e0 <dev_lookup+0x4a>
  8013ad:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013b0:	8b 02                	mov    (%edx),%eax
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	75 f3                	jne    8013a9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013b6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013bb:	8b 40 48             	mov    0x48(%eax),%eax
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	51                   	push   %ecx
  8013c2:	50                   	push   %eax
  8013c3:	68 34 2c 80 00       	push   $0x802c34
  8013c8:	e8 43 ef ff ff       	call   800310 <cprintf>
	*dev = 0;
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    
			*dev = devtab[i];
  8013e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ea:	eb f2                	jmp    8013de <dev_lookup+0x48>

008013ec <fd_close>:
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	57                   	push   %edi
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 1c             	sub    $0x1c,%esp
  8013f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8013f8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013fe:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ff:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801405:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801408:	50                   	push   %eax
  801409:	e8 32 ff ff ff       	call   801340 <fd_lookup>
  80140e:	89 c3                	mov    %eax,%ebx
  801410:	83 c4 08             	add    $0x8,%esp
  801413:	85 c0                	test   %eax,%eax
  801415:	78 05                	js     80141c <fd_close+0x30>
	    || fd != fd2)
  801417:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80141a:	74 16                	je     801432 <fd_close+0x46>
		return (must_exist ? r : 0);
  80141c:	89 f8                	mov    %edi,%eax
  80141e:	84 c0                	test   %al,%al
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
  801425:	0f 44 d8             	cmove  %eax,%ebx
}
  801428:	89 d8                	mov    %ebx,%eax
  80142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142d:	5b                   	pop    %ebx
  80142e:	5e                   	pop    %esi
  80142f:	5f                   	pop    %edi
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801432:	83 ec 08             	sub    $0x8,%esp
  801435:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801438:	50                   	push   %eax
  801439:	ff 36                	pushl  (%esi)
  80143b:	e8 56 ff ff ff       	call   801396 <dev_lookup>
  801440:	89 c3                	mov    %eax,%ebx
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 15                	js     80145e <fd_close+0x72>
		if (dev->dev_close)
  801449:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144c:	8b 40 10             	mov    0x10(%eax),%eax
  80144f:	85 c0                	test   %eax,%eax
  801451:	74 1b                	je     80146e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	56                   	push   %esi
  801457:	ff d0                	call   *%eax
  801459:	89 c3                	mov    %eax,%ebx
  80145b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80145e:	83 ec 08             	sub    $0x8,%esp
  801461:	56                   	push   %esi
  801462:	6a 00                	push   $0x0
  801464:	e8 44 f9 ff ff       	call   800dad <sys_page_unmap>
	return r;
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	eb ba                	jmp    801428 <fd_close+0x3c>
			r = 0;
  80146e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801473:	eb e9                	jmp    80145e <fd_close+0x72>

00801475 <close>:

int
close(int fdnum)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147e:	50                   	push   %eax
  80147f:	ff 75 08             	pushl  0x8(%ebp)
  801482:	e8 b9 fe ff ff       	call   801340 <fd_lookup>
  801487:	83 c4 08             	add    $0x8,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 10                	js     80149e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80148e:	83 ec 08             	sub    $0x8,%esp
  801491:	6a 01                	push   $0x1
  801493:	ff 75 f4             	pushl  -0xc(%ebp)
  801496:	e8 51 ff ff ff       	call   8013ec <fd_close>
  80149b:	83 c4 10             	add    $0x10,%esp
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <close_all>:

void
close_all(void)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014ac:	83 ec 0c             	sub    $0xc,%esp
  8014af:	53                   	push   %ebx
  8014b0:	e8 c0 ff ff ff       	call   801475 <close>
	for (i = 0; i < MAXFD; i++)
  8014b5:	83 c3 01             	add    $0x1,%ebx
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	83 fb 20             	cmp    $0x20,%ebx
  8014be:	75 ec                	jne    8014ac <close_all+0xc>
}
  8014c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	57                   	push   %edi
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014d1:	50                   	push   %eax
  8014d2:	ff 75 08             	pushl  0x8(%ebp)
  8014d5:	e8 66 fe ff ff       	call   801340 <fd_lookup>
  8014da:	89 c3                	mov    %eax,%ebx
  8014dc:	83 c4 08             	add    $0x8,%esp
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	0f 88 81 00 00 00    	js     801568 <dup+0xa3>
		return r;
	close(newfdnum);
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	e8 83 ff ff ff       	call   801475 <close>

	newfd = INDEX2FD(newfdnum);
  8014f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014f5:	c1 e6 0c             	shl    $0xc,%esi
  8014f8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014fe:	83 c4 04             	add    $0x4,%esp
  801501:	ff 75 e4             	pushl  -0x1c(%ebp)
  801504:	e8 d1 fd ff ff       	call   8012da <fd2data>
  801509:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80150b:	89 34 24             	mov    %esi,(%esp)
  80150e:	e8 c7 fd ff ff       	call   8012da <fd2data>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801518:	89 d8                	mov    %ebx,%eax
  80151a:	c1 e8 16             	shr    $0x16,%eax
  80151d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801524:	a8 01                	test   $0x1,%al
  801526:	74 11                	je     801539 <dup+0x74>
  801528:	89 d8                	mov    %ebx,%eax
  80152a:	c1 e8 0c             	shr    $0xc,%eax
  80152d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801534:	f6 c2 01             	test   $0x1,%dl
  801537:	75 39                	jne    801572 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801539:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80153c:	89 d0                	mov    %edx,%eax
  80153e:	c1 e8 0c             	shr    $0xc,%eax
  801541:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801548:	83 ec 0c             	sub    $0xc,%esp
  80154b:	25 07 0e 00 00       	and    $0xe07,%eax
  801550:	50                   	push   %eax
  801551:	56                   	push   %esi
  801552:	6a 00                	push   $0x0
  801554:	52                   	push   %edx
  801555:	6a 00                	push   $0x0
  801557:	e8 0f f8 ff ff       	call   800d6b <sys_page_map>
  80155c:	89 c3                	mov    %eax,%ebx
  80155e:	83 c4 20             	add    $0x20,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	78 31                	js     801596 <dup+0xd1>
		goto err;

	return newfdnum;
  801565:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801568:	89 d8                	mov    %ebx,%eax
  80156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5f                   	pop    %edi
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801572:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801579:	83 ec 0c             	sub    $0xc,%esp
  80157c:	25 07 0e 00 00       	and    $0xe07,%eax
  801581:	50                   	push   %eax
  801582:	57                   	push   %edi
  801583:	6a 00                	push   $0x0
  801585:	53                   	push   %ebx
  801586:	6a 00                	push   $0x0
  801588:	e8 de f7 ff ff       	call   800d6b <sys_page_map>
  80158d:	89 c3                	mov    %eax,%ebx
  80158f:	83 c4 20             	add    $0x20,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	79 a3                	jns    801539 <dup+0x74>
	sys_page_unmap(0, newfd);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	56                   	push   %esi
  80159a:	6a 00                	push   $0x0
  80159c:	e8 0c f8 ff ff       	call   800dad <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015a1:	83 c4 08             	add    $0x8,%esp
  8015a4:	57                   	push   %edi
  8015a5:	6a 00                	push   $0x0
  8015a7:	e8 01 f8 ff ff       	call   800dad <sys_page_unmap>
	return r;
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	eb b7                	jmp    801568 <dup+0xa3>

008015b1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	53                   	push   %ebx
  8015b5:	83 ec 14             	sub    $0x14,%esp
  8015b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015be:	50                   	push   %eax
  8015bf:	53                   	push   %ebx
  8015c0:	e8 7b fd ff ff       	call   801340 <fd_lookup>
  8015c5:	83 c4 08             	add    $0x8,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 3f                	js     80160b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d2:	50                   	push   %eax
  8015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d6:	ff 30                	pushl  (%eax)
  8015d8:	e8 b9 fd ff ff       	call   801396 <dev_lookup>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 27                	js     80160b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e7:	8b 42 08             	mov    0x8(%edx),%eax
  8015ea:	83 e0 03             	and    $0x3,%eax
  8015ed:	83 f8 01             	cmp    $0x1,%eax
  8015f0:	74 1e                	je     801610 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	8b 40 08             	mov    0x8(%eax),%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 35                	je     801631 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	ff 75 10             	pushl  0x10(%ebp)
  801602:	ff 75 0c             	pushl  0xc(%ebp)
  801605:	52                   	push   %edx
  801606:	ff d0                	call   *%eax
  801608:	83 c4 10             	add    $0x10,%esp
}
  80160b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801610:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801615:	8b 40 48             	mov    0x48(%eax),%eax
  801618:	83 ec 04             	sub    $0x4,%esp
  80161b:	53                   	push   %ebx
  80161c:	50                   	push   %eax
  80161d:	68 78 2c 80 00       	push   $0x802c78
  801622:	e8 e9 ec ff ff       	call   800310 <cprintf>
		return -E_INVAL;
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162f:	eb da                	jmp    80160b <read+0x5a>
		return -E_NOT_SUPP;
  801631:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801636:	eb d3                	jmp    80160b <read+0x5a>

00801638 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	57                   	push   %edi
  80163c:	56                   	push   %esi
  80163d:	53                   	push   %ebx
  80163e:	83 ec 0c             	sub    $0xc,%esp
  801641:	8b 7d 08             	mov    0x8(%ebp),%edi
  801644:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801647:	bb 00 00 00 00       	mov    $0x0,%ebx
  80164c:	39 f3                	cmp    %esi,%ebx
  80164e:	73 25                	jae    801675 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	89 f0                	mov    %esi,%eax
  801655:	29 d8                	sub    %ebx,%eax
  801657:	50                   	push   %eax
  801658:	89 d8                	mov    %ebx,%eax
  80165a:	03 45 0c             	add    0xc(%ebp),%eax
  80165d:	50                   	push   %eax
  80165e:	57                   	push   %edi
  80165f:	e8 4d ff ff ff       	call   8015b1 <read>
		if (m < 0)
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	85 c0                	test   %eax,%eax
  801669:	78 08                	js     801673 <readn+0x3b>
			return m;
		if (m == 0)
  80166b:	85 c0                	test   %eax,%eax
  80166d:	74 06                	je     801675 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80166f:	01 c3                	add    %eax,%ebx
  801671:	eb d9                	jmp    80164c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801673:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801675:	89 d8                	mov    %ebx,%eax
  801677:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167a:	5b                   	pop    %ebx
  80167b:	5e                   	pop    %esi
  80167c:	5f                   	pop    %edi
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    

0080167f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	53                   	push   %ebx
  801683:	83 ec 14             	sub    $0x14,%esp
  801686:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801689:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168c:	50                   	push   %eax
  80168d:	53                   	push   %ebx
  80168e:	e8 ad fc ff ff       	call   801340 <fd_lookup>
  801693:	83 c4 08             	add    $0x8,%esp
  801696:	85 c0                	test   %eax,%eax
  801698:	78 3a                	js     8016d4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169a:	83 ec 08             	sub    $0x8,%esp
  80169d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a0:	50                   	push   %eax
  8016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a4:	ff 30                	pushl  (%eax)
  8016a6:	e8 eb fc ff ff       	call   801396 <dev_lookup>
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 22                	js     8016d4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b9:	74 1e                	je     8016d9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016be:	8b 52 0c             	mov    0xc(%edx),%edx
  8016c1:	85 d2                	test   %edx,%edx
  8016c3:	74 35                	je     8016fa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c5:	83 ec 04             	sub    $0x4,%esp
  8016c8:	ff 75 10             	pushl  0x10(%ebp)
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	50                   	push   %eax
  8016cf:	ff d2                	call   *%edx
  8016d1:	83 c4 10             	add    $0x10,%esp
}
  8016d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016d9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8016de:	8b 40 48             	mov    0x48(%eax),%eax
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	53                   	push   %ebx
  8016e5:	50                   	push   %eax
  8016e6:	68 94 2c 80 00       	push   $0x802c94
  8016eb:	e8 20 ec ff ff       	call   800310 <cprintf>
		return -E_INVAL;
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f8:	eb da                	jmp    8016d4 <write+0x55>
		return -E_NOT_SUPP;
  8016fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ff:	eb d3                	jmp    8016d4 <write+0x55>

00801701 <seek>:

int
seek(int fdnum, off_t offset)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801707:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	e8 2d fc ff ff       	call   801340 <fd_lookup>
  801713:	83 c4 08             	add    $0x8,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 0e                	js     801728 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801720:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
  80172e:	83 ec 14             	sub    $0x14,%esp
  801731:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801734:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801737:	50                   	push   %eax
  801738:	53                   	push   %ebx
  801739:	e8 02 fc ff ff       	call   801340 <fd_lookup>
  80173e:	83 c4 08             	add    $0x8,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	78 37                	js     80177c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801745:	83 ec 08             	sub    $0x8,%esp
  801748:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174b:	50                   	push   %eax
  80174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174f:	ff 30                	pushl  (%eax)
  801751:	e8 40 fc ff ff       	call   801396 <dev_lookup>
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 1f                	js     80177c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801764:	74 1b                	je     801781 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801769:	8b 52 18             	mov    0x18(%edx),%edx
  80176c:	85 d2                	test   %edx,%edx
  80176e:	74 32                	je     8017a2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	50                   	push   %eax
  801777:	ff d2                	call   *%edx
  801779:	83 c4 10             	add    $0x10,%esp
}
  80177c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177f:	c9                   	leave  
  801780:	c3                   	ret    
			thisenv->env_id, fdnum);
  801781:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801786:	8b 40 48             	mov    0x48(%eax),%eax
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	53                   	push   %ebx
  80178d:	50                   	push   %eax
  80178e:	68 54 2c 80 00       	push   $0x802c54
  801793:	e8 78 eb ff ff       	call   800310 <cprintf>
		return -E_INVAL;
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a0:	eb da                	jmp    80177c <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a7:	eb d3                	jmp    80177c <ftruncate+0x52>

008017a9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 14             	sub    $0x14,%esp
  8017b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b6:	50                   	push   %eax
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	e8 81 fb ff ff       	call   801340 <fd_lookup>
  8017bf:	83 c4 08             	add    $0x8,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	78 4b                	js     801811 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c6:	83 ec 08             	sub    $0x8,%esp
  8017c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cc:	50                   	push   %eax
  8017cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d0:	ff 30                	pushl  (%eax)
  8017d2:	e8 bf fb ff ff       	call   801396 <dev_lookup>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 33                	js     801811 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017e5:	74 2f                	je     801816 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017e7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017ea:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017f1:	00 00 00 
	stat->st_isdir = 0;
  8017f4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017fb:	00 00 00 
	stat->st_dev = dev;
  8017fe:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801804:	83 ec 08             	sub    $0x8,%esp
  801807:	53                   	push   %ebx
  801808:	ff 75 f0             	pushl  -0x10(%ebp)
  80180b:	ff 50 14             	call   *0x14(%eax)
  80180e:	83 c4 10             	add    $0x10,%esp
}
  801811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801814:	c9                   	leave  
  801815:	c3                   	ret    
		return -E_NOT_SUPP;
  801816:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80181b:	eb f4                	jmp    801811 <fstat+0x68>

0080181d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	6a 00                	push   $0x0
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	e8 e7 01 00 00       	call   801a16 <open>
  80182f:	89 c3                	mov    %eax,%ebx
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	85 c0                	test   %eax,%eax
  801836:	78 1b                	js     801853 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	50                   	push   %eax
  80183f:	e8 65 ff ff ff       	call   8017a9 <fstat>
  801844:	89 c6                	mov    %eax,%esi
	close(fd);
  801846:	89 1c 24             	mov    %ebx,(%esp)
  801849:	e8 27 fc ff ff       	call   801475 <close>
	return r;
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	89 f3                	mov    %esi,%ebx
}
  801853:	89 d8                	mov    %ebx,%eax
  801855:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801858:	5b                   	pop    %ebx
  801859:	5e                   	pop    %esi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	56                   	push   %esi
  801860:	53                   	push   %ebx
  801861:	89 c6                	mov    %eax,%esi
  801863:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801865:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80186c:	74 27                	je     801895 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80186e:	6a 07                	push   $0x7
  801870:	68 00 50 80 00       	push   $0x805000
  801875:	56                   	push   %esi
  801876:	ff 35 04 40 80 00    	pushl  0x804004
  80187c:	e8 bc f9 ff ff       	call   80123d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801881:	83 c4 0c             	add    $0xc,%esp
  801884:	6a 00                	push   $0x0
  801886:	53                   	push   %ebx
  801887:	6a 00                	push   $0x0
  801889:	e8 48 f9 ff ff       	call   8011d6 <ipc_recv>
}
  80188e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	6a 01                	push   $0x1
  80189a:	e8 f2 f9 ff ff       	call   801291 <ipc_find_env>
  80189f:	a3 04 40 80 00       	mov    %eax,0x804004
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	eb c5                	jmp    80186e <fsipc+0x12>

008018a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8018cc:	e8 8b ff ff ff       	call   80185c <fsipc>
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <devfile_flush>:
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018df:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8018ee:	e8 69 ff ff ff       	call   80185c <fsipc>
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <devfile_stat>:
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	8b 40 0c             	mov    0xc(%eax),%eax
  801905:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80190a:	ba 00 00 00 00       	mov    $0x0,%edx
  80190f:	b8 05 00 00 00       	mov    $0x5,%eax
  801914:	e8 43 ff ff ff       	call   80185c <fsipc>
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 2c                	js     801949 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	68 00 50 80 00       	push   $0x805000
  801925:	53                   	push   %ebx
  801926:	e8 04 f0 ff ff       	call   80092f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80192b:	a1 80 50 80 00       	mov    0x805080,%eax
  801930:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801936:	a1 84 50 80 00       	mov    0x805084,%eax
  80193b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <devfile_write>:
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	8b 45 10             	mov    0x10(%ebp),%eax
  801957:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80195c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801961:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801964:	8b 55 08             	mov    0x8(%ebp),%edx
  801967:	8b 52 0c             	mov    0xc(%edx),%edx
  80196a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801970:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801975:	50                   	push   %eax
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	68 08 50 80 00       	push   $0x805008
  80197e:	e8 3a f1 ff ff       	call   800abd <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801983:	ba 00 00 00 00       	mov    $0x0,%edx
  801988:	b8 04 00 00 00       	mov    $0x4,%eax
  80198d:	e8 ca fe ff ff       	call   80185c <fsipc>
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <devfile_read>:
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
  801999:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019a7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8019b7:	e8 a0 fe ff ff       	call   80185c <fsipc>
  8019bc:	89 c3                	mov    %eax,%ebx
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 1f                	js     8019e1 <devfile_read+0x4d>
	assert(r <= n);
  8019c2:	39 f0                	cmp    %esi,%eax
  8019c4:	77 24                	ja     8019ea <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019c6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019cb:	7f 33                	jg     801a00 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	50                   	push   %eax
  8019d1:	68 00 50 80 00       	push   $0x805000
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	e8 df f0 ff ff       	call   800abd <memmove>
	return r;
  8019de:	83 c4 10             	add    $0x10,%esp
}
  8019e1:	89 d8                	mov    %ebx,%eax
  8019e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e6:	5b                   	pop    %ebx
  8019e7:	5e                   	pop    %esi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    
	assert(r <= n);
  8019ea:	68 c8 2c 80 00       	push   $0x802cc8
  8019ef:	68 cf 2c 80 00       	push   $0x802ccf
  8019f4:	6a 7b                	push   $0x7b
  8019f6:	68 e4 2c 80 00       	push   $0x802ce4
  8019fb:	e8 35 e8 ff ff       	call   800235 <_panic>
	assert(r <= PGSIZE);
  801a00:	68 ef 2c 80 00       	push   $0x802cef
  801a05:	68 cf 2c 80 00       	push   $0x802ccf
  801a0a:	6a 7c                	push   $0x7c
  801a0c:	68 e4 2c 80 00       	push   $0x802ce4
  801a11:	e8 1f e8 ff ff       	call   800235 <_panic>

00801a16 <open>:
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	56                   	push   %esi
  801a1a:	53                   	push   %ebx
  801a1b:	83 ec 1c             	sub    $0x1c,%esp
  801a1e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a21:	56                   	push   %esi
  801a22:	e8 d1 ee ff ff       	call   8008f8 <strlen>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a2f:	7f 6c                	jg     801a9d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a31:	83 ec 0c             	sub    $0xc,%esp
  801a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a37:	50                   	push   %eax
  801a38:	e8 b4 f8 ff ff       	call   8012f1 <fd_alloc>
  801a3d:	89 c3                	mov    %eax,%ebx
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 3c                	js     801a82 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	56                   	push   %esi
  801a4a:	68 00 50 80 00       	push   $0x805000
  801a4f:	e8 db ee ff ff       	call   80092f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a57:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a64:	e8 f3 fd ff ff       	call   80185c <fsipc>
  801a69:	89 c3                	mov    %eax,%ebx
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 19                	js     801a8b <open+0x75>
	return fd2num(fd);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	ff 75 f4             	pushl  -0xc(%ebp)
  801a78:	e8 4d f8 ff ff       	call   8012ca <fd2num>
  801a7d:	89 c3                	mov    %eax,%ebx
  801a7f:	83 c4 10             	add    $0x10,%esp
}
  801a82:	89 d8                	mov    %ebx,%eax
  801a84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a87:	5b                   	pop    %ebx
  801a88:	5e                   	pop    %esi
  801a89:	5d                   	pop    %ebp
  801a8a:	c3                   	ret    
		fd_close(fd, 0);
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 f4             	pushl  -0xc(%ebp)
  801a93:	e8 54 f9 ff ff       	call   8013ec <fd_close>
		return r;
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	eb e5                	jmp    801a82 <open+0x6c>
		return -E_BAD_PATH;
  801a9d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aa2:	eb de                	jmp    801a82 <open+0x6c>

00801aa4 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaf:	b8 08 00 00 00       	mov    $0x8,%eax
  801ab4:	e8 a3 fd ff ff       	call   80185c <fsipc>
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ac1:	68 fb 2c 80 00       	push   $0x802cfb
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	e8 61 ee ff ff       	call   80092f <strcpy>
	return 0;
}
  801ace:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <devsock_close>:
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 10             	sub    $0x10,%esp
  801adc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801adf:	53                   	push   %ebx
  801ae0:	e8 90 09 00 00       	call   802475 <pageref>
  801ae5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ae8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801aed:	83 f8 01             	cmp    $0x1,%eax
  801af0:	74 07                	je     801af9 <devsock_close+0x24>
}
  801af2:	89 d0                	mov    %edx,%eax
  801af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801af9:	83 ec 0c             	sub    $0xc,%esp
  801afc:	ff 73 0c             	pushl  0xc(%ebx)
  801aff:	e8 b7 02 00 00       	call   801dbb <nsipc_close>
  801b04:	89 c2                	mov    %eax,%edx
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	eb e7                	jmp    801af2 <devsock_close+0x1d>

00801b0b <devsock_write>:
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	ff 75 10             	pushl  0x10(%ebp)
  801b16:	ff 75 0c             	pushl  0xc(%ebp)
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	ff 70 0c             	pushl  0xc(%eax)
  801b1f:	e8 74 03 00 00       	call   801e98 <nsipc_send>
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <devsock_read>:
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	ff 75 10             	pushl  0x10(%ebp)
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	ff 70 0c             	pushl  0xc(%eax)
  801b3a:	e8 ed 02 00 00       	call   801e2c <nsipc_recv>
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <fd2sockid>:
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b47:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	e8 ef f7 ff ff       	call   801340 <fd_lookup>
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	85 c0                	test   %eax,%eax
  801b56:	78 10                	js     801b68 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5b:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b61:	39 08                	cmp    %ecx,(%eax)
  801b63:	75 05                	jne    801b6a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b65:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    
		return -E_NOT_SUPP;
  801b6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6f:	eb f7                	jmp    801b68 <fd2sockid+0x27>

00801b71 <alloc_sockfd>:
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	83 ec 1c             	sub    $0x1c,%esp
  801b79:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7e:	50                   	push   %eax
  801b7f:	e8 6d f7 ff ff       	call   8012f1 <fd_alloc>
  801b84:	89 c3                	mov    %eax,%ebx
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 43                	js     801bd0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	68 07 04 00 00       	push   $0x407
  801b95:	ff 75 f4             	pushl  -0xc(%ebp)
  801b98:	6a 00                	push   $0x0
  801b9a:	e8 89 f1 ff ff       	call   800d28 <sys_page_alloc>
  801b9f:	89 c3                	mov    %eax,%ebx
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 28                	js     801bd0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bab:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bb1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bbd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	50                   	push   %eax
  801bc4:	e8 01 f7 ff ff       	call   8012ca <fd2num>
  801bc9:	89 c3                	mov    %eax,%ebx
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	eb 0c                	jmp    801bdc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bd0:	83 ec 0c             	sub    $0xc,%esp
  801bd3:	56                   	push   %esi
  801bd4:	e8 e2 01 00 00       	call   801dbb <nsipc_close>
		return r;
  801bd9:	83 c4 10             	add    $0x10,%esp
}
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <accept>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	e8 4e ff ff ff       	call   801b41 <fd2sockid>
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 1b                	js     801c12 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	ff 75 10             	pushl  0x10(%ebp)
  801bfd:	ff 75 0c             	pushl  0xc(%ebp)
  801c00:	50                   	push   %eax
  801c01:	e8 0e 01 00 00       	call   801d14 <nsipc_accept>
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 05                	js     801c12 <accept+0x2d>
	return alloc_sockfd(r);
  801c0d:	e8 5f ff ff ff       	call   801b71 <alloc_sockfd>
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <bind>:
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	e8 1f ff ff ff       	call   801b41 <fd2sockid>
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 12                	js     801c38 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	50                   	push   %eax
  801c30:	e8 2f 01 00 00       	call   801d64 <nsipc_bind>
  801c35:	83 c4 10             	add    $0x10,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <shutdown>:
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	e8 f9 fe ff ff       	call   801b41 <fd2sockid>
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	78 0f                	js     801c5b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c4c:	83 ec 08             	sub    $0x8,%esp
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	50                   	push   %eax
  801c53:	e8 41 01 00 00       	call   801d99 <nsipc_shutdown>
  801c58:	83 c4 10             	add    $0x10,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <connect>:
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	e8 d6 fe ff ff       	call   801b41 <fd2sockid>
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 12                	js     801c81 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	ff 75 10             	pushl  0x10(%ebp)
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	50                   	push   %eax
  801c79:	e8 57 01 00 00       	call   801dd5 <nsipc_connect>
  801c7e:	83 c4 10             	add    $0x10,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <listen>:
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	e8 b0 fe ff ff       	call   801b41 <fd2sockid>
  801c91:	85 c0                	test   %eax,%eax
  801c93:	78 0f                	js     801ca4 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	50                   	push   %eax
  801c9c:	e8 69 01 00 00       	call   801e0a <nsipc_listen>
  801ca1:	83 c4 10             	add    $0x10,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cac:	ff 75 10             	pushl  0x10(%ebp)
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	ff 75 08             	pushl  0x8(%ebp)
  801cb5:	e8 3c 02 00 00       	call   801ef6 <nsipc_socket>
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	78 05                	js     801cc6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cc1:	e8 ab fe ff ff       	call   801b71 <alloc_sockfd>
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	53                   	push   %ebx
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cd1:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801cd8:	74 26                	je     801d00 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cda:	6a 07                	push   $0x7
  801cdc:	68 00 60 80 00       	push   $0x806000
  801ce1:	53                   	push   %ebx
  801ce2:	ff 35 08 40 80 00    	pushl  0x804008
  801ce8:	e8 50 f5 ff ff       	call   80123d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ced:	83 c4 0c             	add    $0xc,%esp
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	e8 db f4 ff ff       	call   8011d6 <ipc_recv>
}
  801cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	6a 02                	push   $0x2
  801d05:	e8 87 f5 ff ff       	call   801291 <ipc_find_env>
  801d0a:	a3 08 40 80 00       	mov    %eax,0x804008
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	eb c6                	jmp    801cda <nsipc+0x12>

00801d14 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	56                   	push   %esi
  801d18:	53                   	push   %ebx
  801d19:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d24:	8b 06                	mov    (%esi),%eax
  801d26:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d30:	e8 93 ff ff ff       	call   801cc8 <nsipc>
  801d35:	89 c3                	mov    %eax,%ebx
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 20                	js     801d5b <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d3b:	83 ec 04             	sub    $0x4,%esp
  801d3e:	ff 35 10 60 80 00    	pushl  0x806010
  801d44:	68 00 60 80 00       	push   $0x806000
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	e8 6c ed ff ff       	call   800abd <memmove>
		*addrlen = ret->ret_addrlen;
  801d51:	a1 10 60 80 00       	mov    0x806010,%eax
  801d56:	89 06                	mov    %eax,(%esi)
  801d58:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801d5b:	89 d8                	mov    %ebx,%eax
  801d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    

00801d64 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	53                   	push   %ebx
  801d68:	83 ec 08             	sub    $0x8,%esp
  801d6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d76:	53                   	push   %ebx
  801d77:	ff 75 0c             	pushl  0xc(%ebp)
  801d7a:	68 04 60 80 00       	push   $0x806004
  801d7f:	e8 39 ed ff ff       	call   800abd <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d84:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d8a:	b8 02 00 00 00       	mov    $0x2,%eax
  801d8f:	e8 34 ff ff ff       	call   801cc8 <nsipc>
}
  801d94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801daf:	b8 03 00 00 00       	mov    $0x3,%eax
  801db4:	e8 0f ff ff ff       	call   801cc8 <nsipc>
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <nsipc_close>:

int
nsipc_close(int s)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dc9:	b8 04 00 00 00       	mov    $0x4,%eax
  801dce:	e8 f5 fe ff ff       	call   801cc8 <nsipc>
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	53                   	push   %ebx
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801de7:	53                   	push   %ebx
  801de8:	ff 75 0c             	pushl  0xc(%ebp)
  801deb:	68 04 60 80 00       	push   $0x806004
  801df0:	e8 c8 ec ff ff       	call   800abd <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801df5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dfb:	b8 05 00 00 00       	mov    $0x5,%eax
  801e00:	e8 c3 fe ff ff       	call   801cc8 <nsipc>
}
  801e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e20:	b8 06 00 00 00       	mov    $0x6,%eax
  801e25:	e8 9e fe ff ff       	call   801cc8 <nsipc>
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	56                   	push   %esi
  801e30:	53                   	push   %ebx
  801e31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e3c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e42:	8b 45 14             	mov    0x14(%ebp),%eax
  801e45:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e4a:	b8 07 00 00 00       	mov    $0x7,%eax
  801e4f:	e8 74 fe ff ff       	call   801cc8 <nsipc>
  801e54:	89 c3                	mov    %eax,%ebx
  801e56:	85 c0                	test   %eax,%eax
  801e58:	78 1f                	js     801e79 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e5a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e5f:	7f 21                	jg     801e82 <nsipc_recv+0x56>
  801e61:	39 c6                	cmp    %eax,%esi
  801e63:	7c 1d                	jl     801e82 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	50                   	push   %eax
  801e69:	68 00 60 80 00       	push   $0x806000
  801e6e:	ff 75 0c             	pushl  0xc(%ebp)
  801e71:	e8 47 ec ff ff       	call   800abd <memmove>
  801e76:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e79:	89 d8                	mov    %ebx,%eax
  801e7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7e:	5b                   	pop    %ebx
  801e7f:	5e                   	pop    %esi
  801e80:	5d                   	pop    %ebp
  801e81:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e82:	68 07 2d 80 00       	push   $0x802d07
  801e87:	68 cf 2c 80 00       	push   $0x802ccf
  801e8c:	6a 62                	push   $0x62
  801e8e:	68 1c 2d 80 00       	push   $0x802d1c
  801e93:	e8 9d e3 ff ff       	call   800235 <_panic>

00801e98 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	53                   	push   %ebx
  801e9c:	83 ec 04             	sub    $0x4,%esp
  801e9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801eaa:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801eb0:	7f 2e                	jg     801ee0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801eb2:	83 ec 04             	sub    $0x4,%esp
  801eb5:	53                   	push   %ebx
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	68 0c 60 80 00       	push   $0x80600c
  801ebe:	e8 fa eb ff ff       	call   800abd <memmove>
	nsipcbuf.send.req_size = size;
  801ec3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ed1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ed6:	e8 ed fd ff ff       	call   801cc8 <nsipc>
}
  801edb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    
	assert(size < 1600);
  801ee0:	68 28 2d 80 00       	push   $0x802d28
  801ee5:	68 cf 2c 80 00       	push   $0x802ccf
  801eea:	6a 6d                	push   $0x6d
  801eec:	68 1c 2d 80 00       	push   $0x802d1c
  801ef1:	e8 3f e3 ff ff       	call   800235 <_panic>

00801ef6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f14:	b8 09 00 00 00       	mov    $0x9,%eax
  801f19:	e8 aa fd ff ff       	call   801cc8 <nsipc>
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	56                   	push   %esi
  801f24:	53                   	push   %ebx
  801f25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	ff 75 08             	pushl  0x8(%ebp)
  801f2e:	e8 a7 f3 ff ff       	call   8012da <fd2data>
  801f33:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f35:	83 c4 08             	add    $0x8,%esp
  801f38:	68 34 2d 80 00       	push   $0x802d34
  801f3d:	53                   	push   %ebx
  801f3e:	e8 ec e9 ff ff       	call   80092f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f43:	8b 46 04             	mov    0x4(%esi),%eax
  801f46:	2b 06                	sub    (%esi),%eax
  801f48:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f4e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f55:	00 00 00 
	stat->st_dev = &devpipe;
  801f58:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f5f:	30 80 00 
	return 0;
}
  801f62:	b8 00 00 00 00       	mov    $0x0,%eax
  801f67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f6a:	5b                   	pop    %ebx
  801f6b:	5e                   	pop    %esi
  801f6c:	5d                   	pop    %ebp
  801f6d:	c3                   	ret    

00801f6e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	53                   	push   %ebx
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f78:	53                   	push   %ebx
  801f79:	6a 00                	push   $0x0
  801f7b:	e8 2d ee ff ff       	call   800dad <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f80:	89 1c 24             	mov    %ebx,(%esp)
  801f83:	e8 52 f3 ff ff       	call   8012da <fd2data>
  801f88:	83 c4 08             	add    $0x8,%esp
  801f8b:	50                   	push   %eax
  801f8c:	6a 00                	push   $0x0
  801f8e:	e8 1a ee ff ff       	call   800dad <sys_page_unmap>
}
  801f93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <_pipeisclosed>:
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	57                   	push   %edi
  801f9c:	56                   	push   %esi
  801f9d:	53                   	push   %ebx
  801f9e:	83 ec 1c             	sub    $0x1c,%esp
  801fa1:	89 c7                	mov    %eax,%edi
  801fa3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fa5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801faa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	57                   	push   %edi
  801fb1:	e8 bf 04 00 00       	call   802475 <pageref>
  801fb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fb9:	89 34 24             	mov    %esi,(%esp)
  801fbc:	e8 b4 04 00 00       	call   802475 <pageref>
		nn = thisenv->env_runs;
  801fc1:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801fc7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	39 cb                	cmp    %ecx,%ebx
  801fcf:	74 1b                	je     801fec <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fd1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fd4:	75 cf                	jne    801fa5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fd6:	8b 42 58             	mov    0x58(%edx),%eax
  801fd9:	6a 01                	push   $0x1
  801fdb:	50                   	push   %eax
  801fdc:	53                   	push   %ebx
  801fdd:	68 3b 2d 80 00       	push   $0x802d3b
  801fe2:	e8 29 e3 ff ff       	call   800310 <cprintf>
  801fe7:	83 c4 10             	add    $0x10,%esp
  801fea:	eb b9                	jmp    801fa5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fef:	0f 94 c0             	sete   %al
  801ff2:	0f b6 c0             	movzbl %al,%eax
}
  801ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff8:	5b                   	pop    %ebx
  801ff9:	5e                   	pop    %esi
  801ffa:	5f                   	pop    %edi
  801ffb:	5d                   	pop    %ebp
  801ffc:	c3                   	ret    

00801ffd <devpipe_write>:
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	57                   	push   %edi
  802001:	56                   	push   %esi
  802002:	53                   	push   %ebx
  802003:	83 ec 28             	sub    $0x28,%esp
  802006:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802009:	56                   	push   %esi
  80200a:	e8 cb f2 ff ff       	call   8012da <fd2data>
  80200f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	bf 00 00 00 00       	mov    $0x0,%edi
  802019:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80201c:	74 4f                	je     80206d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80201e:	8b 43 04             	mov    0x4(%ebx),%eax
  802021:	8b 0b                	mov    (%ebx),%ecx
  802023:	8d 51 20             	lea    0x20(%ecx),%edx
  802026:	39 d0                	cmp    %edx,%eax
  802028:	72 14                	jb     80203e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80202a:	89 da                	mov    %ebx,%edx
  80202c:	89 f0                	mov    %esi,%eax
  80202e:	e8 65 ff ff ff       	call   801f98 <_pipeisclosed>
  802033:	85 c0                	test   %eax,%eax
  802035:	75 3a                	jne    802071 <devpipe_write+0x74>
			sys_yield();
  802037:	e8 cd ec ff ff       	call   800d09 <sys_yield>
  80203c:	eb e0                	jmp    80201e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80203e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802041:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802045:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802048:	89 c2                	mov    %eax,%edx
  80204a:	c1 fa 1f             	sar    $0x1f,%edx
  80204d:	89 d1                	mov    %edx,%ecx
  80204f:	c1 e9 1b             	shr    $0x1b,%ecx
  802052:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802055:	83 e2 1f             	and    $0x1f,%edx
  802058:	29 ca                	sub    %ecx,%edx
  80205a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80205e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802062:	83 c0 01             	add    $0x1,%eax
  802065:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802068:	83 c7 01             	add    $0x1,%edi
  80206b:	eb ac                	jmp    802019 <devpipe_write+0x1c>
	return i;
  80206d:	89 f8                	mov    %edi,%eax
  80206f:	eb 05                	jmp    802076 <devpipe_write+0x79>
				return 0;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802076:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5f                   	pop    %edi
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    

0080207e <devpipe_read>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 18             	sub    $0x18,%esp
  802087:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80208a:	57                   	push   %edi
  80208b:	e8 4a f2 ff ff       	call   8012da <fd2data>
  802090:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	be 00 00 00 00       	mov    $0x0,%esi
  80209a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80209d:	74 47                	je     8020e6 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80209f:	8b 03                	mov    (%ebx),%eax
  8020a1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020a4:	75 22                	jne    8020c8 <devpipe_read+0x4a>
			if (i > 0)
  8020a6:	85 f6                	test   %esi,%esi
  8020a8:	75 14                	jne    8020be <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8020aa:	89 da                	mov    %ebx,%edx
  8020ac:	89 f8                	mov    %edi,%eax
  8020ae:	e8 e5 fe ff ff       	call   801f98 <_pipeisclosed>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	75 33                	jne    8020ea <devpipe_read+0x6c>
			sys_yield();
  8020b7:	e8 4d ec ff ff       	call   800d09 <sys_yield>
  8020bc:	eb e1                	jmp    80209f <devpipe_read+0x21>
				return i;
  8020be:	89 f0                	mov    %esi,%eax
}
  8020c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c3:	5b                   	pop    %ebx
  8020c4:	5e                   	pop    %esi
  8020c5:	5f                   	pop    %edi
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020c8:	99                   	cltd   
  8020c9:	c1 ea 1b             	shr    $0x1b,%edx
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	83 e0 1f             	and    $0x1f,%eax
  8020d1:	29 d0                	sub    %edx,%eax
  8020d3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020db:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020de:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020e1:	83 c6 01             	add    $0x1,%esi
  8020e4:	eb b4                	jmp    80209a <devpipe_read+0x1c>
	return i;
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	eb d6                	jmp    8020c0 <devpipe_read+0x42>
				return 0;
  8020ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ef:	eb cf                	jmp    8020c0 <devpipe_read+0x42>

008020f1 <pipe>:
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	56                   	push   %esi
  8020f5:	53                   	push   %ebx
  8020f6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fc:	50                   	push   %eax
  8020fd:	e8 ef f1 ff ff       	call   8012f1 <fd_alloc>
  802102:	89 c3                	mov    %eax,%ebx
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	85 c0                	test   %eax,%eax
  802109:	78 5b                	js     802166 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	68 07 04 00 00       	push   $0x407
  802113:	ff 75 f4             	pushl  -0xc(%ebp)
  802116:	6a 00                	push   $0x0
  802118:	e8 0b ec ff ff       	call   800d28 <sys_page_alloc>
  80211d:	89 c3                	mov    %eax,%ebx
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	85 c0                	test   %eax,%eax
  802124:	78 40                	js     802166 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80212c:	50                   	push   %eax
  80212d:	e8 bf f1 ff ff       	call   8012f1 <fd_alloc>
  802132:	89 c3                	mov    %eax,%ebx
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	85 c0                	test   %eax,%eax
  802139:	78 1b                	js     802156 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	68 07 04 00 00       	push   $0x407
  802143:	ff 75 f0             	pushl  -0x10(%ebp)
  802146:	6a 00                	push   $0x0
  802148:	e8 db eb ff ff       	call   800d28 <sys_page_alloc>
  80214d:	89 c3                	mov    %eax,%ebx
  80214f:	83 c4 10             	add    $0x10,%esp
  802152:	85 c0                	test   %eax,%eax
  802154:	79 19                	jns    80216f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802156:	83 ec 08             	sub    $0x8,%esp
  802159:	ff 75 f4             	pushl  -0xc(%ebp)
  80215c:	6a 00                	push   $0x0
  80215e:	e8 4a ec ff ff       	call   800dad <sys_page_unmap>
  802163:	83 c4 10             	add    $0x10,%esp
}
  802166:	89 d8                	mov    %ebx,%eax
  802168:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5e                   	pop    %esi
  80216d:	5d                   	pop    %ebp
  80216e:	c3                   	ret    
	va = fd2data(fd0);
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	ff 75 f4             	pushl  -0xc(%ebp)
  802175:	e8 60 f1 ff ff       	call   8012da <fd2data>
  80217a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80217c:	83 c4 0c             	add    $0xc,%esp
  80217f:	68 07 04 00 00       	push   $0x407
  802184:	50                   	push   %eax
  802185:	6a 00                	push   $0x0
  802187:	e8 9c eb ff ff       	call   800d28 <sys_page_alloc>
  80218c:	89 c3                	mov    %eax,%ebx
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	0f 88 8c 00 00 00    	js     802225 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802199:	83 ec 0c             	sub    $0xc,%esp
  80219c:	ff 75 f0             	pushl  -0x10(%ebp)
  80219f:	e8 36 f1 ff ff       	call   8012da <fd2data>
  8021a4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021ab:	50                   	push   %eax
  8021ac:	6a 00                	push   $0x0
  8021ae:	56                   	push   %esi
  8021af:	6a 00                	push   $0x0
  8021b1:	e8 b5 eb ff ff       	call   800d6b <sys_page_map>
  8021b6:	89 c3                	mov    %eax,%ebx
  8021b8:	83 c4 20             	add    $0x20,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 58                	js     802217 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021c8:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021dd:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ef:	e8 d6 f0 ff ff       	call   8012ca <fd2num>
  8021f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021f9:	83 c4 04             	add    $0x4,%esp
  8021fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ff:	e8 c6 f0 ff ff       	call   8012ca <fd2num>
  802204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802207:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80220a:	83 c4 10             	add    $0x10,%esp
  80220d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802212:	e9 4f ff ff ff       	jmp    802166 <pipe+0x75>
	sys_page_unmap(0, va);
  802217:	83 ec 08             	sub    $0x8,%esp
  80221a:	56                   	push   %esi
  80221b:	6a 00                	push   $0x0
  80221d:	e8 8b eb ff ff       	call   800dad <sys_page_unmap>
  802222:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802225:	83 ec 08             	sub    $0x8,%esp
  802228:	ff 75 f0             	pushl  -0x10(%ebp)
  80222b:	6a 00                	push   $0x0
  80222d:	e8 7b eb ff ff       	call   800dad <sys_page_unmap>
  802232:	83 c4 10             	add    $0x10,%esp
  802235:	e9 1c ff ff ff       	jmp    802156 <pipe+0x65>

0080223a <pipeisclosed>:
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802240:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802243:	50                   	push   %eax
  802244:	ff 75 08             	pushl  0x8(%ebp)
  802247:	e8 f4 f0 ff ff       	call   801340 <fd_lookup>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 18                	js     80226b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	ff 75 f4             	pushl  -0xc(%ebp)
  802259:	e8 7c f0 ff ff       	call   8012da <fd2data>
	return _pipeisclosed(fd, p);
  80225e:	89 c2                	mov    %eax,%edx
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	e8 30 fd ff ff       	call   801f98 <_pipeisclosed>
  802268:	83 c4 10             	add    $0x10,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    

00802277 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80227d:	68 53 2d 80 00       	push   $0x802d53
  802282:	ff 75 0c             	pushl  0xc(%ebp)
  802285:	e8 a5 e6 ff ff       	call   80092f <strcpy>
	return 0;
}
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <devcons_write>:
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	57                   	push   %edi
  802295:	56                   	push   %esi
  802296:	53                   	push   %ebx
  802297:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80229d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022a2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022a8:	eb 2f                	jmp    8022d9 <devcons_write+0x48>
		m = n - tot;
  8022aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022ad:	29 f3                	sub    %esi,%ebx
  8022af:	83 fb 7f             	cmp    $0x7f,%ebx
  8022b2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022b7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	53                   	push   %ebx
  8022be:	89 f0                	mov    %esi,%eax
  8022c0:	03 45 0c             	add    0xc(%ebp),%eax
  8022c3:	50                   	push   %eax
  8022c4:	57                   	push   %edi
  8022c5:	e8 f3 e7 ff ff       	call   800abd <memmove>
		sys_cputs(buf, m);
  8022ca:	83 c4 08             	add    $0x8,%esp
  8022cd:	53                   	push   %ebx
  8022ce:	57                   	push   %edi
  8022cf:	e8 98 e9 ff ff       	call   800c6c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022d4:	01 de                	add    %ebx,%esi
  8022d6:	83 c4 10             	add    $0x10,%esp
  8022d9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022dc:	72 cc                	jb     8022aa <devcons_write+0x19>
}
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e3:	5b                   	pop    %ebx
  8022e4:	5e                   	pop    %esi
  8022e5:	5f                   	pop    %edi
  8022e6:	5d                   	pop    %ebp
  8022e7:	c3                   	ret    

008022e8 <devcons_read>:
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f7:	75 07                	jne    802300 <devcons_read+0x18>
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    
		sys_yield();
  8022fb:	e8 09 ea ff ff       	call   800d09 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802300:	e8 85 e9 ff ff       	call   800c8a <sys_cgetc>
  802305:	85 c0                	test   %eax,%eax
  802307:	74 f2                	je     8022fb <devcons_read+0x13>
	if (c < 0)
  802309:	85 c0                	test   %eax,%eax
  80230b:	78 ec                	js     8022f9 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80230d:	83 f8 04             	cmp    $0x4,%eax
  802310:	74 0c                	je     80231e <devcons_read+0x36>
	*(char*)vbuf = c;
  802312:	8b 55 0c             	mov    0xc(%ebp),%edx
  802315:	88 02                	mov    %al,(%edx)
	return 1;
  802317:	b8 01 00 00 00       	mov    $0x1,%eax
  80231c:	eb db                	jmp    8022f9 <devcons_read+0x11>
		return 0;
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	eb d4                	jmp    8022f9 <devcons_read+0x11>

00802325 <cputchar>:
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802331:	6a 01                	push   $0x1
  802333:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802336:	50                   	push   %eax
  802337:	e8 30 e9 ff ff       	call   800c6c <sys_cputs>
}
  80233c:	83 c4 10             	add    $0x10,%esp
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <getchar>:
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802347:	6a 01                	push   $0x1
  802349:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80234c:	50                   	push   %eax
  80234d:	6a 00                	push   $0x0
  80234f:	e8 5d f2 ff ff       	call   8015b1 <read>
	if (r < 0)
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	85 c0                	test   %eax,%eax
  802359:	78 08                	js     802363 <getchar+0x22>
	if (r < 1)
  80235b:	85 c0                	test   %eax,%eax
  80235d:	7e 06                	jle    802365 <getchar+0x24>
	return c;
  80235f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    
		return -E_EOF;
  802365:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80236a:	eb f7                	jmp    802363 <getchar+0x22>

0080236c <iscons>:
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802372:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802375:	50                   	push   %eax
  802376:	ff 75 08             	pushl  0x8(%ebp)
  802379:	e8 c2 ef ff ff       	call   801340 <fd_lookup>
  80237e:	83 c4 10             	add    $0x10,%esp
  802381:	85 c0                	test   %eax,%eax
  802383:	78 11                	js     802396 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80238e:	39 10                	cmp    %edx,(%eax)
  802390:	0f 94 c0             	sete   %al
  802393:	0f b6 c0             	movzbl %al,%eax
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <opencons>:
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80239e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023a1:	50                   	push   %eax
  8023a2:	e8 4a ef ff ff       	call   8012f1 <fd_alloc>
  8023a7:	83 c4 10             	add    $0x10,%esp
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	78 3a                	js     8023e8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023ae:	83 ec 04             	sub    $0x4,%esp
  8023b1:	68 07 04 00 00       	push   $0x407
  8023b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b9:	6a 00                	push   $0x0
  8023bb:	e8 68 e9 ff ff       	call   800d28 <sys_page_alloc>
  8023c0:	83 c4 10             	add    $0x10,%esp
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	78 21                	js     8023e8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023d0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	50                   	push   %eax
  8023e0:	e8 e5 ee ff ff       	call   8012ca <fd2num>
  8023e5:	83 c4 10             	add    $0x10,%esp
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  8023f0:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8023f7:	74 0a                	je     802403 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802403:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802408:	8b 40 48             	mov    0x48(%eax),%eax
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	6a 07                	push   $0x7
  802410:	68 00 f0 bf ee       	push   $0xeebff000
  802415:	50                   	push   %eax
  802416:	e8 0d e9 ff ff       	call   800d28 <sys_page_alloc>
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 1b                	js     80243d <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802422:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802427:	8b 40 48             	mov    0x48(%eax),%eax
  80242a:	83 ec 08             	sub    $0x8,%esp
  80242d:	68 4f 24 80 00       	push   $0x80244f
  802432:	50                   	push   %eax
  802433:	e8 3b ea ff ff       	call   800e73 <sys_env_set_pgfault_upcall>
  802438:	83 c4 10             	add    $0x10,%esp
  80243b:	eb bc                	jmp    8023f9 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  80243d:	50                   	push   %eax
  80243e:	68 5f 2d 80 00       	push   $0x802d5f
  802443:	6a 22                	push   $0x22
  802445:	68 77 2d 80 00       	push   $0x802d77
  80244a:	e8 e6 dd ff ff       	call   800235 <_panic>

0080244f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80244f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802450:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802455:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802457:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  80245a:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  80245e:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  802461:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802465:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802469:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  80246b:	83 c4 08             	add    $0x8,%esp
	popal
  80246e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80246f:	83 c4 04             	add    $0x4,%esp
	popfl
  802472:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802473:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802474:	c3                   	ret    

00802475 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80247b:	89 d0                	mov    %edx,%eax
  80247d:	c1 e8 16             	shr    $0x16,%eax
  802480:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80248c:	f6 c1 01             	test   $0x1,%cl
  80248f:	74 1d                	je     8024ae <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802491:	c1 ea 0c             	shr    $0xc,%edx
  802494:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80249b:	f6 c2 01             	test   $0x1,%dl
  80249e:	74 0e                	je     8024ae <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024a0:	c1 ea 0c             	shr    $0xc,%edx
  8024a3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024aa:	ef 
  8024ab:	0f b7 c0             	movzwl %ax,%eax
}
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    

008024b0 <__udivdi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024c7:	85 d2                	test   %edx,%edx
  8024c9:	75 35                	jne    802500 <__udivdi3+0x50>
  8024cb:	39 f3                	cmp    %esi,%ebx
  8024cd:	0f 87 bd 00 00 00    	ja     802590 <__udivdi3+0xe0>
  8024d3:	85 db                	test   %ebx,%ebx
  8024d5:	89 d9                	mov    %ebx,%ecx
  8024d7:	75 0b                	jne    8024e4 <__udivdi3+0x34>
  8024d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024de:	31 d2                	xor    %edx,%edx
  8024e0:	f7 f3                	div    %ebx
  8024e2:	89 c1                	mov    %eax,%ecx
  8024e4:	31 d2                	xor    %edx,%edx
  8024e6:	89 f0                	mov    %esi,%eax
  8024e8:	f7 f1                	div    %ecx
  8024ea:	89 c6                	mov    %eax,%esi
  8024ec:	89 e8                	mov    %ebp,%eax
  8024ee:	89 f7                	mov    %esi,%edi
  8024f0:	f7 f1                	div    %ecx
  8024f2:	89 fa                	mov    %edi,%edx
  8024f4:	83 c4 1c             	add    $0x1c,%esp
  8024f7:	5b                   	pop    %ebx
  8024f8:	5e                   	pop    %esi
  8024f9:	5f                   	pop    %edi
  8024fa:	5d                   	pop    %ebp
  8024fb:	c3                   	ret    
  8024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802500:	39 f2                	cmp    %esi,%edx
  802502:	77 7c                	ja     802580 <__udivdi3+0xd0>
  802504:	0f bd fa             	bsr    %edx,%edi
  802507:	83 f7 1f             	xor    $0x1f,%edi
  80250a:	0f 84 98 00 00 00    	je     8025a8 <__udivdi3+0xf8>
  802510:	89 f9                	mov    %edi,%ecx
  802512:	b8 20 00 00 00       	mov    $0x20,%eax
  802517:	29 f8                	sub    %edi,%eax
  802519:	d3 e2                	shl    %cl,%edx
  80251b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80251f:	89 c1                	mov    %eax,%ecx
  802521:	89 da                	mov    %ebx,%edx
  802523:	d3 ea                	shr    %cl,%edx
  802525:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802529:	09 d1                	or     %edx,%ecx
  80252b:	89 f2                	mov    %esi,%edx
  80252d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802531:	89 f9                	mov    %edi,%ecx
  802533:	d3 e3                	shl    %cl,%ebx
  802535:	89 c1                	mov    %eax,%ecx
  802537:	d3 ea                	shr    %cl,%edx
  802539:	89 f9                	mov    %edi,%ecx
  80253b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80253f:	d3 e6                	shl    %cl,%esi
  802541:	89 eb                	mov    %ebp,%ebx
  802543:	89 c1                	mov    %eax,%ecx
  802545:	d3 eb                	shr    %cl,%ebx
  802547:	09 de                	or     %ebx,%esi
  802549:	89 f0                	mov    %esi,%eax
  80254b:	f7 74 24 08          	divl   0x8(%esp)
  80254f:	89 d6                	mov    %edx,%esi
  802551:	89 c3                	mov    %eax,%ebx
  802553:	f7 64 24 0c          	mull   0xc(%esp)
  802557:	39 d6                	cmp    %edx,%esi
  802559:	72 0c                	jb     802567 <__udivdi3+0xb7>
  80255b:	89 f9                	mov    %edi,%ecx
  80255d:	d3 e5                	shl    %cl,%ebp
  80255f:	39 c5                	cmp    %eax,%ebp
  802561:	73 5d                	jae    8025c0 <__udivdi3+0x110>
  802563:	39 d6                	cmp    %edx,%esi
  802565:	75 59                	jne    8025c0 <__udivdi3+0x110>
  802567:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80256a:	31 ff                	xor    %edi,%edi
  80256c:	89 fa                	mov    %edi,%edx
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d 76 00             	lea    0x0(%esi),%esi
  802579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802580:	31 ff                	xor    %edi,%edi
  802582:	31 c0                	xor    %eax,%eax
  802584:	89 fa                	mov    %edi,%edx
  802586:	83 c4 1c             	add    $0x1c,%esp
  802589:	5b                   	pop    %ebx
  80258a:	5e                   	pop    %esi
  80258b:	5f                   	pop    %edi
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    
  80258e:	66 90                	xchg   %ax,%ax
  802590:	31 ff                	xor    %edi,%edi
  802592:	89 e8                	mov    %ebp,%eax
  802594:	89 f2                	mov    %esi,%edx
  802596:	f7 f3                	div    %ebx
  802598:	89 fa                	mov    %edi,%edx
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    
  8025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025a8:	39 f2                	cmp    %esi,%edx
  8025aa:	72 06                	jb     8025b2 <__udivdi3+0x102>
  8025ac:	31 c0                	xor    %eax,%eax
  8025ae:	39 eb                	cmp    %ebp,%ebx
  8025b0:	77 d2                	ja     802584 <__udivdi3+0xd4>
  8025b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b7:	eb cb                	jmp    802584 <__udivdi3+0xd4>
  8025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025c0:	89 d8                	mov    %ebx,%eax
  8025c2:	31 ff                	xor    %edi,%edi
  8025c4:	eb be                	jmp    802584 <__udivdi3+0xd4>
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	66 90                	xchg   %ax,%ax
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <__umoddi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	53                   	push   %ebx
  8025d4:	83 ec 1c             	sub    $0x1c,%esp
  8025d7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8025db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025e7:	85 ed                	test   %ebp,%ebp
  8025e9:	89 f0                	mov    %esi,%eax
  8025eb:	89 da                	mov    %ebx,%edx
  8025ed:	75 19                	jne    802608 <__umoddi3+0x38>
  8025ef:	39 df                	cmp    %ebx,%edi
  8025f1:	0f 86 b1 00 00 00    	jbe    8026a8 <__umoddi3+0xd8>
  8025f7:	f7 f7                	div    %edi
  8025f9:	89 d0                	mov    %edx,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	83 c4 1c             	add    $0x1c,%esp
  802600:	5b                   	pop    %ebx
  802601:	5e                   	pop    %esi
  802602:	5f                   	pop    %edi
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    
  802605:	8d 76 00             	lea    0x0(%esi),%esi
  802608:	39 dd                	cmp    %ebx,%ebp
  80260a:	77 f1                	ja     8025fd <__umoddi3+0x2d>
  80260c:	0f bd cd             	bsr    %ebp,%ecx
  80260f:	83 f1 1f             	xor    $0x1f,%ecx
  802612:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802616:	0f 84 b4 00 00 00    	je     8026d0 <__umoddi3+0x100>
  80261c:	b8 20 00 00 00       	mov    $0x20,%eax
  802621:	89 c2                	mov    %eax,%edx
  802623:	8b 44 24 04          	mov    0x4(%esp),%eax
  802627:	29 c2                	sub    %eax,%edx
  802629:	89 c1                	mov    %eax,%ecx
  80262b:	89 f8                	mov    %edi,%eax
  80262d:	d3 e5                	shl    %cl,%ebp
  80262f:	89 d1                	mov    %edx,%ecx
  802631:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802635:	d3 e8                	shr    %cl,%eax
  802637:	09 c5                	or     %eax,%ebp
  802639:	8b 44 24 04          	mov    0x4(%esp),%eax
  80263d:	89 c1                	mov    %eax,%ecx
  80263f:	d3 e7                	shl    %cl,%edi
  802641:	89 d1                	mov    %edx,%ecx
  802643:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802647:	89 df                	mov    %ebx,%edi
  802649:	d3 ef                	shr    %cl,%edi
  80264b:	89 c1                	mov    %eax,%ecx
  80264d:	89 f0                	mov    %esi,%eax
  80264f:	d3 e3                	shl    %cl,%ebx
  802651:	89 d1                	mov    %edx,%ecx
  802653:	89 fa                	mov    %edi,%edx
  802655:	d3 e8                	shr    %cl,%eax
  802657:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80265c:	09 d8                	or     %ebx,%eax
  80265e:	f7 f5                	div    %ebp
  802660:	d3 e6                	shl    %cl,%esi
  802662:	89 d1                	mov    %edx,%ecx
  802664:	f7 64 24 08          	mull   0x8(%esp)
  802668:	39 d1                	cmp    %edx,%ecx
  80266a:	89 c3                	mov    %eax,%ebx
  80266c:	89 d7                	mov    %edx,%edi
  80266e:	72 06                	jb     802676 <__umoddi3+0xa6>
  802670:	75 0e                	jne    802680 <__umoddi3+0xb0>
  802672:	39 c6                	cmp    %eax,%esi
  802674:	73 0a                	jae    802680 <__umoddi3+0xb0>
  802676:	2b 44 24 08          	sub    0x8(%esp),%eax
  80267a:	19 ea                	sbb    %ebp,%edx
  80267c:	89 d7                	mov    %edx,%edi
  80267e:	89 c3                	mov    %eax,%ebx
  802680:	89 ca                	mov    %ecx,%edx
  802682:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802687:	29 de                	sub    %ebx,%esi
  802689:	19 fa                	sbb    %edi,%edx
  80268b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80268f:	89 d0                	mov    %edx,%eax
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 d9                	mov    %ebx,%ecx
  802695:	d3 ee                	shr    %cl,%esi
  802697:	d3 ea                	shr    %cl,%edx
  802699:	09 f0                	or     %esi,%eax
  80269b:	83 c4 1c             	add    $0x1c,%esp
  80269e:	5b                   	pop    %ebx
  80269f:	5e                   	pop    %esi
  8026a0:	5f                   	pop    %edi
  8026a1:	5d                   	pop    %ebp
  8026a2:	c3                   	ret    
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	85 ff                	test   %edi,%edi
  8026aa:	89 f9                	mov    %edi,%ecx
  8026ac:	75 0b                	jne    8026b9 <__umoddi3+0xe9>
  8026ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b3:	31 d2                	xor    %edx,%edx
  8026b5:	f7 f7                	div    %edi
  8026b7:	89 c1                	mov    %eax,%ecx
  8026b9:	89 d8                	mov    %ebx,%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	f7 f1                	div    %ecx
  8026bf:	89 f0                	mov    %esi,%eax
  8026c1:	f7 f1                	div    %ecx
  8026c3:	e9 31 ff ff ff       	jmp    8025f9 <__umoddi3+0x29>
  8026c8:	90                   	nop
  8026c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026d0:	39 dd                	cmp    %ebx,%ebp
  8026d2:	72 08                	jb     8026dc <__umoddi3+0x10c>
  8026d4:	39 f7                	cmp    %esi,%edi
  8026d6:	0f 87 21 ff ff ff    	ja     8025fd <__umoddi3+0x2d>
  8026dc:	89 da                	mov    %ebx,%edx
  8026de:	89 f0                	mov    %esi,%eax
  8026e0:	29 f8                	sub    %edi,%eax
  8026e2:	19 ea                	sbb    %ebp,%edx
  8026e4:	e9 14 ff ff ff       	jmp    8025fd <__umoddi3+0x2d>

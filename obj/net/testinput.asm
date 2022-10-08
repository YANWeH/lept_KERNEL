
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 0e 07 00 00       	call   80073f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 7c             	sub    $0x7c,%esp
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 13 12 00 00       	call   801254 <sys_getenvid>
  800041:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800043:	c7 05 00 40 80 00 60 	movl   $0x802c60,0x804000
  80004a:	2c 80 00 

	output_envid = fork();
  80004d:	e8 29 15 00 00       	call   80157b <fork>
  800052:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	78 18                	js     800073 <umain+0x40>
		panic("error forking");
	else if (output_envid == 0) {
  80005b:	85 c0                	test   %eax,%eax
  80005d:	75 28                	jne    800087 <umain+0x54>
		output(ns_envid);
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	53                   	push   %ebx
  800063:	e8 ea 03 00 00       	call   800452 <output>
		return;
  800068:	83 c4 10             	add    $0x10,%esp
		// we've received the ARP reply
		if (first)
			cprintf("Waiting for packets...\n");
		first = 0;
	}
}
  80006b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80006e:	5b                   	pop    %ebx
  80006f:	5e                   	pop    %esi
  800070:	5f                   	pop    %edi
  800071:	5d                   	pop    %ebp
  800072:	c3                   	ret    
		panic("error forking");
  800073:	83 ec 04             	sub    $0x4,%esp
  800076:	68 6a 2c 80 00       	push   $0x802c6a
  80007b:	6a 4d                	push   $0x4d
  80007d:	68 78 2c 80 00       	push   $0x802c78
  800082:	e8 18 07 00 00       	call   80079f <_panic>
	input_envid = fork();
  800087:	e8 ef 14 00 00       	call   80157b <fork>
  80008c:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  800091:	85 c0                	test   %eax,%eax
  800093:	0f 88 6e 01 00 00    	js     800207 <umain+0x1d4>
	else if (input_envid == 0) {
  800099:	85 c0                	test   %eax,%eax
  80009b:	0f 84 7a 01 00 00    	je     80021b <umain+0x1e8>
	cprintf("Sending ARP announcement...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 88 2c 80 00       	push   $0x802c88
  8000a9:	e8 cc 07 00 00       	call   80087a <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000ae:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  8000b2:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000b6:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000ba:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000be:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000c2:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000c6:	c7 04 24 a5 2c 80 00 	movl   $0x802ca5,(%esp)
  8000cd:	e8 3b 06 00 00       	call   80070d <inet_addr>
  8000d2:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000d5:	c7 04 24 af 2c 80 00 	movl   $0x802caf,(%esp)
  8000dc:	e8 2c 06 00 00       	call   80070d <inet_addr>
  8000e1:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000e4:	83 c4 0c             	add    $0xc,%esp
  8000e7:	6a 07                	push   $0x7
  8000e9:	68 00 b0 fe 0f       	push   $0xffeb000
  8000ee:	6a 00                	push   $0x0
  8000f0:	e8 9d 11 00 00       	call   801292 <sys_page_alloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	85 c0                	test   %eax,%eax
  8000fa:	0f 88 2c 01 00 00    	js     80022c <umain+0x1f9>
	pkt->jp_len = sizeof(*arp);
  800100:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  800107:	00 00 00 
	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80010a:	83 ec 04             	sub    $0x4,%esp
  80010d:	6a 06                	push   $0x6
  80010f:	68 ff 00 00 00       	push   $0xff
  800114:	68 04 b0 fe 0f       	push   $0xffeb004
  800119:	e8 bc 0e 00 00       	call   800fda <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80011e:	83 c4 0c             	add    $0xc,%esp
  800121:	6a 06                	push   $0x6
  800123:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800126:	53                   	push   %ebx
  800127:	68 0a b0 fe 0f       	push   $0xffeb00a
  80012c:	e8 5e 0f 00 00       	call   80108f <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800131:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  800138:	e8 ba 03 00 00       	call   8004f7 <htons>
  80013d:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  800143:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80014a:	e8 a8 03 00 00       	call   8004f7 <htons>
  80014f:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  800155:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  80015c:	e8 96 03 00 00       	call   8004f7 <htons>
  800161:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  800167:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  80016e:	e8 84 03 00 00       	call   8004f7 <htons>
  800173:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  800179:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800180:	e8 72 03 00 00       	call   8004f7 <htons>
  800185:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  80018b:	83 c4 0c             	add    $0xc,%esp
  80018e:	6a 06                	push   $0x6
  800190:	53                   	push   %ebx
  800191:	68 1a b0 fe 0f       	push   $0xffeb01a
  800196:	e8 f4 0e 00 00       	call   80108f <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  80019b:	83 c4 0c             	add    $0xc,%esp
  80019e:	6a 04                	push   $0x4
  8001a0:	8d 45 90             	lea    -0x70(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	68 20 b0 fe 0f       	push   $0xffeb020
  8001a9:	e8 e1 0e 00 00       	call   80108f <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  8001ae:	83 c4 0c             	add    $0xc,%esp
  8001b1:	6a 06                	push   $0x6
  8001b3:	6a 00                	push   $0x0
  8001b5:	68 24 b0 fe 0f       	push   $0xffeb024
  8001ba:	e8 1b 0e 00 00       	call   800fda <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  8001bf:	83 c4 0c             	add    $0xc,%esp
  8001c2:	6a 04                	push   $0x4
  8001c4:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001c7:	50                   	push   %eax
  8001c8:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001cd:	e8 bd 0e 00 00       	call   80108f <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001d2:	6a 07                	push   $0x7
  8001d4:	68 00 b0 fe 0f       	push   $0xffeb000
  8001d9:	6a 0b                	push   $0xb
  8001db:	ff 35 04 50 80 00    	pushl  0x805004
  8001e1:	e8 c1 15 00 00       	call   8017a7 <ipc_send>
	sys_page_unmap(0, pkt);
  8001e6:	83 c4 18             	add    $0x18,%esp
  8001e9:	68 00 b0 fe 0f       	push   $0xffeb000
  8001ee:	6a 00                	push   $0x0
  8001f0:	e8 22 11 00 00       	call   801317 <sys_page_unmap>
  8001f5:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001f8:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  8001ff:	00 00 00 
  800202:	e9 42 01 00 00       	jmp    800349 <umain+0x316>
		panic("error forking");
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 6a 2c 80 00       	push   $0x802c6a
  80020f:	6a 55                	push   $0x55
  800211:	68 78 2c 80 00       	push   $0x802c78
  800216:	e8 84 05 00 00       	call   80079f <_panic>
		input(ns_envid);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	53                   	push   %ebx
  80021f:	e8 1f 02 00 00       	call   800443 <input>
		return;
  800224:	83 c4 10             	add    $0x10,%esp
  800227:	e9 3f fe ff ff       	jmp    80006b <umain+0x38>
		panic("sys_page_map: %e", r);
  80022c:	50                   	push   %eax
  80022d:	68 b8 2c 80 00       	push   $0x802cb8
  800232:	6a 19                	push   $0x19
  800234:	68 78 2c 80 00       	push   $0x802c78
  800239:	e8 61 05 00 00       	call   80079f <_panic>
			panic("ipc_recv: %e", req);
  80023e:	50                   	push   %eax
  80023f:	68 c9 2c 80 00       	push   $0x802cc9
  800244:	6a 64                	push   $0x64
  800246:	68 78 2c 80 00       	push   $0x802c78
  80024b:	e8 4f 05 00 00       	call   80079f <_panic>
			panic("IPC from unexpected environment %08x", whom);
  800250:	52                   	push   %edx
  800251:	68 20 2d 80 00       	push   $0x802d20
  800256:	6a 66                	push   $0x66
  800258:	68 78 2c 80 00       	push   $0x802c78
  80025d:	e8 3d 05 00 00       	call   80079f <_panic>
			panic("Unexpected IPC %d", req);
  800262:	50                   	push   %eax
  800263:	68 d6 2c 80 00       	push   $0x802cd6
  800268:	6a 68                	push   $0x68
  80026a:	68 78 2c 80 00       	push   $0x802c78
  80026f:	e8 2b 05 00 00       	call   80079f <_panic>
			out = buf + snprintf(buf, end - buf,
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	53                   	push   %ebx
  800278:	68 e8 2c 80 00       	push   $0x802ce8
  80027d:	68 f0 2c 80 00       	push   $0x802cf0
  800282:	6a 50                	push   $0x50
  800284:	8d 45 98             	lea    -0x68(%ebp),%eax
  800287:	50                   	push   %eax
  800288:	e8 bb 0b 00 00       	call   800e48 <snprintf>
  80028d:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  800290:	8d 34 01             	lea    (%ecx,%eax,1),%esi
  800293:	83 c4 20             	add    $0x20,%esp
  800296:	eb 42                	jmp    8002da <umain+0x2a7>
			cprintf("%.*s\n", out - buf, buf);
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80029e:	50                   	push   %eax
  80029f:	89 f0                	mov    %esi,%eax
  8002a1:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  8002a4:	29 c8                	sub    %ecx,%eax
  8002a6:	50                   	push   %eax
  8002a7:	68 ff 2c 80 00       	push   $0x802cff
  8002ac:	e8 c9 05 00 00       	call   80087a <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
		if (i % 2 == 1)
  8002b4:	89 da                	mov    %ebx,%edx
  8002b6:	c1 ea 1f             	shr    $0x1f,%edx
  8002b9:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8002bc:	83 e0 01             	and    $0x1,%eax
  8002bf:	29 d0                	sub    %edx,%eax
  8002c1:	83 f8 01             	cmp    $0x1,%eax
  8002c4:	74 50                	je     800316 <umain+0x2e3>
		if (i % 16 == 7)
  8002c6:	83 ff 07             	cmp    $0x7,%edi
  8002c9:	74 53                	je     80031e <umain+0x2eb>
	for (i = 0; i < len; i++) {
  8002cb:	83 c3 01             	add    $0x1,%ebx
  8002ce:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  8002d1:	7e 53                	jle    800326 <umain+0x2f3>
		if (i % 16 == 0)
  8002d3:	89 df                	mov    %ebx,%edi
  8002d5:	f6 c3 0f             	test   $0xf,%bl
  8002d8:	74 9a                	je     800274 <umain+0x241>
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  8002da:	b8 04 b0 fe 0f       	mov    $0xffeb004,%eax
  8002df:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
  8002e3:	50                   	push   %eax
  8002e4:	68 fa 2c 80 00       	push   $0x802cfa
  8002e9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002ec:	29 f0                	sub    %esi,%eax
  8002ee:	50                   	push   %eax
  8002ef:	56                   	push   %esi
  8002f0:	e8 53 0b 00 00       	call   800e48 <snprintf>
  8002f5:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8002f7:	89 d8                	mov    %ebx,%eax
  8002f9:	c1 f8 1f             	sar    $0x1f,%eax
  8002fc:	c1 e8 1c             	shr    $0x1c,%eax
  8002ff:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  800302:	83 e7 0f             	and    $0xf,%edi
  800305:	29 c7                	sub    %eax,%edi
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	83 ff 0f             	cmp    $0xf,%edi
  80030d:	74 89                	je     800298 <umain+0x265>
  80030f:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  800312:	75 a0                	jne    8002b4 <umain+0x281>
  800314:	eb 82                	jmp    800298 <umain+0x265>
			*(out++) = ' ';
  800316:	c6 06 20             	movb   $0x20,(%esi)
  800319:	8d 76 01             	lea    0x1(%esi),%esi
  80031c:	eb a8                	jmp    8002c6 <umain+0x293>
			*(out++) = ' ';
  80031e:	c6 06 20             	movb   $0x20,(%esi)
  800321:	8d 76 01             	lea    0x1(%esi),%esi
  800324:	eb a5                	jmp    8002cb <umain+0x298>
		cprintf("\n");
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	68 1b 2d 80 00       	push   $0x802d1b
  80032e:	e8 47 05 00 00       	call   80087a <cprintf>
		if (first)
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
  80033d:	75 5f                	jne    80039e <umain+0x36b>
		first = 0;
  80033f:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  800346:	00 00 00 
		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80034f:	50                   	push   %eax
  800350:	68 00 b0 fe 0f       	push   $0xffeb000
  800355:	8d 45 90             	lea    -0x70(%ebp),%eax
  800358:	50                   	push   %eax
  800359:	e8 e2 13 00 00       	call   801740 <ipc_recv>
		if (req < 0)
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	85 c0                	test   %eax,%eax
  800363:	0f 88 d5 fe ff ff    	js     80023e <umain+0x20b>
		if (whom != input_envid)
  800369:	8b 55 90             	mov    -0x70(%ebp),%edx
  80036c:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  800372:	0f 85 d8 fe ff ff    	jne    800250 <umain+0x21d>
		if (req != NSREQ_INPUT)
  800378:	83 f8 0a             	cmp    $0xa,%eax
  80037b:	0f 85 e1 fe ff ff    	jne    800262 <umain+0x22f>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800381:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800386:	89 45 84             	mov    %eax,-0x7c(%ebp)
	char *out = NULL;
  800389:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < len; i++) {
  80038e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 15 || i == len - 1)
  800393:	83 e8 01             	sub    $0x1,%eax
  800396:	89 45 80             	mov    %eax,-0x80(%ebp)
  800399:	e9 30 ff ff ff       	jmp    8002ce <umain+0x29b>
			cprintf("Waiting for packets...\n");
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	68 05 2d 80 00       	push   $0x802d05
  8003a6:	e8 cf 04 00 00       	call   80087a <cprintf>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	eb 8f                	jmp    80033f <umain+0x30c>

008003b0 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	57                   	push   %edi
  8003b4:	56                   	push   %esi
  8003b5:	53                   	push   %ebx
  8003b6:	83 ec 1c             	sub    $0x1c,%esp
  8003b9:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  8003bc:	e8 c2 10 00 00       	call   801483 <sys_time_msec>
  8003c1:	03 45 0c             	add    0xc(%ebp),%eax
  8003c4:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003c6:	c7 05 00 40 80 00 45 	movl   $0x802d45,0x804000
  8003cd:	2d 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003d0:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8003d3:	eb 33                	jmp    800408 <timer+0x58>
		if (r < 0)
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	78 45                	js     80041e <timer+0x6e>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8003d9:	6a 00                	push   $0x0
  8003db:	6a 00                	push   $0x0
  8003dd:	6a 0c                	push   $0xc
  8003df:	56                   	push   %esi
  8003e0:	e8 c2 13 00 00       	call   8017a7 <ipc_send>
  8003e5:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	6a 00                	push   $0x0
  8003ed:	6a 00                	push   $0x0
  8003ef:	57                   	push   %edi
  8003f0:	e8 4b 13 00 00       	call   801740 <ipc_recv>
  8003f5:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8003f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	39 f0                	cmp    %esi,%eax
  8003ff:	75 2f                	jne    800430 <timer+0x80>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800401:	e8 7d 10 00 00       	call   801483 <sys_time_msec>
  800406:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800408:	e8 76 10 00 00       	call   801483 <sys_time_msec>
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	85 c0                	test   %eax,%eax
  800411:	78 c2                	js     8003d5 <timer+0x25>
  800413:	39 d8                	cmp    %ebx,%eax
  800415:	73 be                	jae    8003d5 <timer+0x25>
			sys_yield();
  800417:	e8 57 0e 00 00       	call   801273 <sys_yield>
  80041c:	eb ea                	jmp    800408 <timer+0x58>
			panic("sys_time_msec: %e", r);
  80041e:	52                   	push   %edx
  80041f:	68 4e 2d 80 00       	push   $0x802d4e
  800424:	6a 0f                	push   $0xf
  800426:	68 60 2d 80 00       	push   $0x802d60
  80042b:	e8 6f 03 00 00       	call   80079f <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	50                   	push   %eax
  800434:	68 6c 2d 80 00       	push   $0x802d6c
  800439:	e8 3c 04 00 00       	call   80087a <cprintf>
				continue;
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	eb a5                	jmp    8003e8 <timer+0x38>

00800443 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_input";
  800446:	c7 05 00 40 80 00 a7 	movl   $0x802da7,0x804000
  80044d:	2d 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  800450:	5d                   	pop    %ebp
  800451:	c3                   	ret    

00800452 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
	binaryname = "ns_output";
  800455:	c7 05 00 40 80 00 b0 	movl   $0x802db0,0x804000
  80045c:	2d 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  80045f:	5d                   	pop    %ebp
  800460:	c3                   	ret    

00800461 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	57                   	push   %edi
  800465:	56                   	push   %esi
  800466:	53                   	push   %ebx
  800467:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800470:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  800473:	c7 45 e0 08 50 80 00 	movl   $0x805008,-0x20(%ebp)
  80047a:	eb 30                	jmp    8004ac <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  80047c:	0f b6 c2             	movzbl %dl,%eax
  80047f:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  800484:	88 01                	mov    %al,(%ecx)
  800486:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  800489:	83 ea 01             	sub    $0x1,%edx
  80048c:	80 fa ff             	cmp    $0xff,%dl
  80048f:	75 eb                	jne    80047c <inet_ntoa+0x1b>
  800491:	89 f0                	mov    %esi,%eax
  800493:	0f b6 f0             	movzbl %al,%esi
  800496:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  800499:	8d 46 01             	lea    0x1(%esi),%eax
  80049c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049f:	c6 06 2e             	movb   $0x2e,(%esi)
  8004a2:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  8004a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004a8:	39 c7                	cmp    %eax,%edi
  8004aa:	74 3b                	je     8004e7 <inet_ntoa+0x86>
  rp = str;
  8004ac:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  8004b1:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  8004b4:	0f b6 da             	movzbl %dl,%ebx
  8004b7:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  8004ba:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  8004bd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004c0:	66 c1 e8 0b          	shr    $0xb,%ax
  8004c4:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  8004c6:	8d 71 01             	lea    0x1(%ecx),%esi
  8004c9:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  8004cc:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  8004cf:	01 db                	add    %ebx,%ebx
  8004d1:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  8004d3:	83 c2 30             	add    $0x30,%edx
  8004d6:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  8004da:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  8004dc:	84 c0                	test   %al,%al
  8004de:	75 d1                	jne    8004b1 <inet_ntoa+0x50>
  8004e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  8004e3:	89 f2                	mov    %esi,%edx
  8004e5:	eb a2                	jmp    800489 <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  8004e7:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  8004ea:	b8 08 50 80 00       	mov    $0x805008,%eax
  8004ef:	83 c4 14             	add    $0x14,%esp
  8004f2:	5b                   	pop    %ebx
  8004f3:	5e                   	pop    %esi
  8004f4:	5f                   	pop    %edi
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8004fa:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8004fe:	66 c1 c0 08          	rol    $0x8,%ax
}
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    

00800504 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800507:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80050b:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80050f:	5d                   	pop    %ebp
  800510:	c3                   	ret    

00800511 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800517:	89 d0                	mov    %edx,%eax
  800519:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80051c:	89 d1                	mov    %edx,%ecx
  80051e:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800521:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800523:	89 d1                	mov    %edx,%ecx
  800525:	c1 e1 08             	shl    $0x8,%ecx
  800528:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80052e:	09 c8                	or     %ecx,%eax
  800530:	c1 ea 08             	shr    $0x8,%edx
  800533:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800539:	09 d0                	or     %edx,%eax
}
  80053b:	5d                   	pop    %ebp
  80053c:	c3                   	ret    

0080053d <inet_aton>:
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	57                   	push   %edi
  800541:	56                   	push   %esi
  800542:	53                   	push   %ebx
  800543:	83 ec 1c             	sub    $0x1c,%esp
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  800549:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  80054c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80054f:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800552:	e9 a9 00 00 00       	jmp    800600 <inet_aton+0xc3>
      c = *++cp;
  800557:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80055b:	89 d1                	mov    %edx,%ecx
  80055d:	83 e1 df             	and    $0xffffffdf,%ecx
  800560:	80 f9 58             	cmp    $0x58,%cl
  800563:	74 12                	je     800577 <inet_aton+0x3a>
      c = *++cp;
  800565:	83 c0 01             	add    $0x1,%eax
  800568:	0f be d2             	movsbl %dl,%edx
        base = 8;
  80056b:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  800572:	e9 a5 00 00 00       	jmp    80061c <inet_aton+0xdf>
        c = *++cp;
  800577:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80057b:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  80057e:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  800585:	e9 92 00 00 00       	jmp    80061c <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80058a:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  80058e:	75 4a                	jne    8005da <inet_aton+0x9d>
  800590:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  800593:	89 d1                	mov    %edx,%ecx
  800595:	83 e1 df             	and    $0xffffffdf,%ecx
  800598:	83 e9 41             	sub    $0x41,%ecx
  80059b:	80 f9 05             	cmp    $0x5,%cl
  80059e:	77 3a                	ja     8005da <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8005a0:	c1 e7 04             	shl    $0x4,%edi
  8005a3:	83 c2 0a             	add    $0xa,%edx
  8005a6:	80 fb 1a             	cmp    $0x1a,%bl
  8005a9:	19 c9                	sbb    %ecx,%ecx
  8005ab:	83 e1 20             	and    $0x20,%ecx
  8005ae:	83 c1 41             	add    $0x41,%ecx
  8005b1:	29 ca                	sub    %ecx,%edx
  8005b3:	09 d7                	or     %edx,%edi
        c = *++cp;
  8005b5:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005b8:	0f be 56 01          	movsbl 0x1(%esi),%edx
  8005bc:	83 c0 01             	add    $0x1,%eax
  8005bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  8005c2:	89 d6                	mov    %edx,%esi
  8005c4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005c7:	80 f9 09             	cmp    $0x9,%cl
  8005ca:	77 be                	ja     80058a <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  8005cc:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  8005d0:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  8005d4:	0f be 50 01          	movsbl 0x1(%eax),%edx
  8005d8:	eb e2                	jmp    8005bc <inet_aton+0x7f>
    if (c == '.') {
  8005da:	83 fa 2e             	cmp    $0x2e,%edx
  8005dd:	75 44                	jne    800623 <inet_aton+0xe6>
      if (pp >= parts + 3)
  8005df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005e2:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005e5:	39 c3                	cmp    %eax,%ebx
  8005e7:	0f 84 13 01 00 00    	je     800700 <inet_aton+0x1c3>
      *pp++ = val;
  8005ed:	83 c3 04             	add    $0x4,%ebx
  8005f0:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8005f3:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  8005f6:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8005f9:	8d 46 01             	lea    0x1(%esi),%eax
  8005fc:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800600:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800603:	80 f9 09             	cmp    $0x9,%cl
  800606:	0f 87 ed 00 00 00    	ja     8006f9 <inet_aton+0x1bc>
    base = 10;
  80060c:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  800613:	83 fa 30             	cmp    $0x30,%edx
  800616:	0f 84 3b ff ff ff    	je     800557 <inet_aton+0x1a>
        base = 8;
  80061c:	bf 00 00 00 00       	mov    $0x0,%edi
  800621:	eb 9c                	jmp    8005bf <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800623:	85 d2                	test   %edx,%edx
  800625:	74 29                	je     800650 <inet_aton+0x113>
    return (0);
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80062c:	89 f3                	mov    %esi,%ebx
  80062e:	80 fb 1f             	cmp    $0x1f,%bl
  800631:	0f 86 ce 00 00 00    	jbe    800705 <inet_aton+0x1c8>
  800637:	84 d2                	test   %dl,%dl
  800639:	0f 88 c6 00 00 00    	js     800705 <inet_aton+0x1c8>
  80063f:	83 fa 20             	cmp    $0x20,%edx
  800642:	74 0c                	je     800650 <inet_aton+0x113>
  800644:	83 ea 09             	sub    $0x9,%edx
  800647:	83 fa 04             	cmp    $0x4,%edx
  80064a:	0f 87 b5 00 00 00    	ja     800705 <inet_aton+0x1c8>
  n = pp - parts + 1;
  800650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800653:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800656:	29 c6                	sub    %eax,%esi
  800658:	89 f0                	mov    %esi,%eax
  80065a:	c1 f8 02             	sar    $0x2,%eax
  80065d:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  800660:	83 f8 02             	cmp    $0x2,%eax
  800663:	74 5e                	je     8006c3 <inet_aton+0x186>
  800665:	83 f8 02             	cmp    $0x2,%eax
  800668:	7e 35                	jle    80069f <inet_aton+0x162>
  80066a:	83 f8 03             	cmp    $0x3,%eax
  80066d:	74 6b                	je     8006da <inet_aton+0x19d>
  80066f:	83 f8 04             	cmp    $0x4,%eax
  800672:	75 2f                	jne    8006a3 <inet_aton+0x166>
      return (0);
  800674:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  800679:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  80067f:	0f 87 80 00 00 00    	ja     800705 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800688:	c1 e0 18             	shl    $0x18,%eax
  80068b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80068e:	c1 e2 10             	shl    $0x10,%edx
  800691:	09 d0                	or     %edx,%eax
  800693:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800696:	c1 e2 08             	shl    $0x8,%edx
  800699:	09 d0                	or     %edx,%eax
  80069b:	09 c7                	or     %eax,%edi
    break;
  80069d:	eb 04                	jmp    8006a3 <inet_aton+0x166>
  switch (n) {
  80069f:	85 c0                	test   %eax,%eax
  8006a1:	74 62                	je     800705 <inet_aton+0x1c8>
  return (1);
  8006a3:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8006a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ac:	74 57                	je     800705 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  8006ae:	57                   	push   %edi
  8006af:	e8 5d fe ff ff       	call   800511 <htonl>
  8006b4:	83 c4 04             	add    $0x4,%esp
  8006b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006ba:	89 06                	mov    %eax,(%esi)
  return (1);
  8006bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8006c1:	eb 42                	jmp    800705 <inet_aton+0x1c8>
      return (0);
  8006c3:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  8006c8:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  8006ce:	77 35                	ja     800705 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  8006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d3:	c1 e0 18             	shl    $0x18,%eax
  8006d6:	09 c7                	or     %eax,%edi
    break;
  8006d8:	eb c9                	jmp    8006a3 <inet_aton+0x166>
      return (0);
  8006da:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  8006df:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  8006e5:	77 1e                	ja     800705 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ea:	c1 e0 18             	shl    $0x18,%eax
  8006ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006f0:	c1 e2 10             	shl    $0x10,%edx
  8006f3:	09 d0                	or     %edx,%eax
  8006f5:	09 c7                	or     %eax,%edi
    break;
  8006f7:	eb aa                	jmp    8006a3 <inet_aton+0x166>
      return (0);
  8006f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fe:	eb 05                	jmp    800705 <inet_aton+0x1c8>
        return (0);
  800700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800705:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800708:	5b                   	pop    %ebx
  800709:	5e                   	pop    %esi
  80070a:	5f                   	pop    %edi
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <inet_addr>:
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  800713:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	e8 1e fe ff ff       	call   80053d <inet_aton>
  80071f:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  800722:	85 c0                	test   %eax,%eax
  800724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800729:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  800732:	ff 75 08             	pushl  0x8(%ebp)
  800735:	e8 d7 fd ff ff       	call   800511 <htonl>
  80073a:	83 c4 04             	add    $0x4,%esp
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    

0080073f <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	56                   	push   %esi
  800743:	53                   	push   %ebx
  800744:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800747:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80074a:	e8 05 0b 00 00       	call   801254 <sys_getenvid>
  80074f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800754:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800757:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80075c:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800761:	85 db                	test   %ebx,%ebx
  800763:	7e 07                	jle    80076c <libmain+0x2d>
		binaryname = argv[0];
  800765:	8b 06                	mov    (%esi),%eax
  800767:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	56                   	push   %esi
  800770:	53                   	push   %ebx
  800771:	e8 bd f8 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800776:	e8 0a 00 00 00       	call   800785 <exit>
}
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800781:	5b                   	pop    %ebx
  800782:	5e                   	pop    %esi
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    

00800785 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80078b:	e8 7a 12 00 00       	call   801a0a <close_all>
	sys_env_destroy(0);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	6a 00                	push   $0x0
  800795:	e8 79 0a 00 00       	call   801213 <sys_env_destroy>
}
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	c9                   	leave  
  80079e:	c3                   	ret    

0080079f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	56                   	push   %esi
  8007a3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8007a4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007a7:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8007ad:	e8 a2 0a 00 00       	call   801254 <sys_getenvid>
  8007b2:	83 ec 0c             	sub    $0xc,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	ff 75 08             	pushl  0x8(%ebp)
  8007bb:	56                   	push   %esi
  8007bc:	50                   	push   %eax
  8007bd:	68 c4 2d 80 00       	push   $0x802dc4
  8007c2:	e8 b3 00 00 00       	call   80087a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8007c7:	83 c4 18             	add    $0x18,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	ff 75 10             	pushl  0x10(%ebp)
  8007ce:	e8 56 00 00 00       	call   800829 <vcprintf>
	cprintf("\n");
  8007d3:	c7 04 24 1b 2d 80 00 	movl   $0x802d1b,(%esp)
  8007da:	e8 9b 00 00 00       	call   80087a <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8007e2:	cc                   	int3   
  8007e3:	eb fd                	jmp    8007e2 <_panic+0x43>

008007e5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8007ef:	8b 13                	mov    (%ebx),%edx
  8007f1:	8d 42 01             	lea    0x1(%edx),%eax
  8007f4:	89 03                	mov    %eax,(%ebx)
  8007f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8007fd:	3d ff 00 00 00       	cmp    $0xff,%eax
  800802:	74 09                	je     80080d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800804:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	68 ff 00 00 00       	push   $0xff
  800815:	8d 43 08             	lea    0x8(%ebx),%eax
  800818:	50                   	push   %eax
  800819:	e8 b8 09 00 00       	call   8011d6 <sys_cputs>
		b->idx = 0;
  80081e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	eb db                	jmp    800804 <putch+0x1f>

00800829 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800832:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800839:	00 00 00 
	b.cnt = 0;
  80083c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800843:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 08             	pushl  0x8(%ebp)
  80084c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	68 e5 07 80 00       	push   $0x8007e5
  800858:	e8 1a 01 00 00       	call   800977 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80085d:	83 c4 08             	add    $0x8,%esp
  800860:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800866:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	e8 64 09 00 00       	call   8011d6 <sys_cputs>

	return b.cnt;
}
  800872:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800880:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800883:	50                   	push   %eax
  800884:	ff 75 08             	pushl  0x8(%ebp)
  800887:	e8 9d ff ff ff       	call   800829 <vcprintf>
	va_end(ap);

	return cnt;
}
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    

0080088e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	57                   	push   %edi
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
  800894:	83 ec 1c             	sub    $0x1c,%esp
  800897:	89 c7                	mov    %eax,%edi
  800899:	89 d6                	mov    %edx,%esi
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008af:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008b2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8008b5:	39 d3                	cmp    %edx,%ebx
  8008b7:	72 05                	jb     8008be <printnum+0x30>
  8008b9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8008bc:	77 7a                	ja     800938 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008be:	83 ec 0c             	sub    $0xc,%esp
  8008c1:	ff 75 18             	pushl  0x18(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008ca:	53                   	push   %ebx
  8008cb:	ff 75 10             	pushl  0x10(%ebp)
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8008da:	ff 75 d8             	pushl  -0x28(%ebp)
  8008dd:	e8 3e 21 00 00       	call   802a20 <__udivdi3>
  8008e2:	83 c4 18             	add    $0x18,%esp
  8008e5:	52                   	push   %edx
  8008e6:	50                   	push   %eax
  8008e7:	89 f2                	mov    %esi,%edx
  8008e9:	89 f8                	mov    %edi,%eax
  8008eb:	e8 9e ff ff ff       	call   80088e <printnum>
  8008f0:	83 c4 20             	add    $0x20,%esp
  8008f3:	eb 13                	jmp    800908 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	56                   	push   %esi
  8008f9:	ff 75 18             	pushl  0x18(%ebp)
  8008fc:	ff d7                	call   *%edi
  8008fe:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800901:	83 eb 01             	sub    $0x1,%ebx
  800904:	85 db                	test   %ebx,%ebx
  800906:	7f ed                	jg     8008f5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	56                   	push   %esi
  80090c:	83 ec 04             	sub    $0x4,%esp
  80090f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800912:	ff 75 e0             	pushl  -0x20(%ebp)
  800915:	ff 75 dc             	pushl  -0x24(%ebp)
  800918:	ff 75 d8             	pushl  -0x28(%ebp)
  80091b:	e8 20 22 00 00       	call   802b40 <__umoddi3>
  800920:	83 c4 14             	add    $0x14,%esp
  800923:	0f be 80 e7 2d 80 00 	movsbl 0x802de7(%eax),%eax
  80092a:	50                   	push   %eax
  80092b:	ff d7                	call   *%edi
}
  80092d:	83 c4 10             	add    $0x10,%esp
  800930:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5f                   	pop    %edi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    
  800938:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80093b:	eb c4                	jmp    800901 <printnum+0x73>

0080093d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800943:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800947:	8b 10                	mov    (%eax),%edx
  800949:	3b 50 04             	cmp    0x4(%eax),%edx
  80094c:	73 0a                	jae    800958 <sprintputch+0x1b>
		*b->buf++ = ch;
  80094e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800951:	89 08                	mov    %ecx,(%eax)
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	88 02                	mov    %al,(%edx)
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <printfmt>:
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800960:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800963:	50                   	push   %eax
  800964:	ff 75 10             	pushl  0x10(%ebp)
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	ff 75 08             	pushl  0x8(%ebp)
  80096d:	e8 05 00 00 00       	call   800977 <vprintfmt>
}
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <vprintfmt>:
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	57                   	push   %edi
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	83 ec 2c             	sub    $0x2c,%esp
  800980:	8b 75 08             	mov    0x8(%ebp),%esi
  800983:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800986:	8b 7d 10             	mov    0x10(%ebp),%edi
  800989:	e9 c1 03 00 00       	jmp    800d4f <vprintfmt+0x3d8>
		padc = ' ';
  80098e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800992:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800999:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8009a0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009ac:	8d 47 01             	lea    0x1(%edi),%eax
  8009af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b2:	0f b6 17             	movzbl (%edi),%edx
  8009b5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8009b8:	3c 55                	cmp    $0x55,%al
  8009ba:	0f 87 12 04 00 00    	ja     800dd2 <vprintfmt+0x45b>
  8009c0:	0f b6 c0             	movzbl %al,%eax
  8009c3:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
  8009ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8009cd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8009d1:	eb d9                	jmp    8009ac <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8009d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8009d6:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8009da:	eb d0                	jmp    8009ac <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8009dc:	0f b6 d2             	movzbl %dl,%edx
  8009df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8009ea:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8009ed:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8009f1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8009f4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8009f7:	83 f9 09             	cmp    $0x9,%ecx
  8009fa:	77 55                	ja     800a51 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8009fc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8009ff:	eb e9                	jmp    8009ea <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8b 00                	mov    (%eax),%eax
  800a06:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8d 40 04             	lea    0x4(%eax),%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a12:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a19:	79 91                	jns    8009ac <vprintfmt+0x35>
				width = precision, precision = -1;
  800a1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a21:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800a28:	eb 82                	jmp    8009ac <vprintfmt+0x35>
  800a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2d:	85 c0                	test   %eax,%eax
  800a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a34:	0f 49 d0             	cmovns %eax,%edx
  800a37:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a3a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a3d:	e9 6a ff ff ff       	jmp    8009ac <vprintfmt+0x35>
  800a42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a45:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800a4c:	e9 5b ff ff ff       	jmp    8009ac <vprintfmt+0x35>
  800a51:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a54:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a57:	eb bc                	jmp    800a15 <vprintfmt+0x9e>
			lflag++;
  800a59:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a5f:	e9 48 ff ff ff       	jmp    8009ac <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	8d 78 04             	lea    0x4(%eax),%edi
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	53                   	push   %ebx
  800a6e:	ff 30                	pushl  (%eax)
  800a70:	ff d6                	call   *%esi
			break;
  800a72:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a75:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a78:	e9 cf 02 00 00       	jmp    800d4c <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8d 78 04             	lea    0x4(%eax),%edi
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	99                   	cltd   
  800a86:	31 d0                	xor    %edx,%eax
  800a88:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a8a:	83 f8 0f             	cmp    $0xf,%eax
  800a8d:	7f 23                	jg     800ab2 <vprintfmt+0x13b>
  800a8f:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  800a96:	85 d2                	test   %edx,%edx
  800a98:	74 18                	je     800ab2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800a9a:	52                   	push   %edx
  800a9b:	68 c1 32 80 00       	push   $0x8032c1
  800aa0:	53                   	push   %ebx
  800aa1:	56                   	push   %esi
  800aa2:	e8 b3 fe ff ff       	call   80095a <printfmt>
  800aa7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800aaa:	89 7d 14             	mov    %edi,0x14(%ebp)
  800aad:	e9 9a 02 00 00       	jmp    800d4c <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800ab2:	50                   	push   %eax
  800ab3:	68 ff 2d 80 00       	push   $0x802dff
  800ab8:	53                   	push   %ebx
  800ab9:	56                   	push   %esi
  800aba:	e8 9b fe ff ff       	call   80095a <printfmt>
  800abf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ac2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800ac5:	e9 82 02 00 00       	jmp    800d4c <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800ad8:	85 ff                	test   %edi,%edi
  800ada:	b8 f8 2d 80 00       	mov    $0x802df8,%eax
  800adf:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800ae2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ae6:	0f 8e bd 00 00 00    	jle    800ba9 <vprintfmt+0x232>
  800aec:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800af0:	75 0e                	jne    800b00 <vprintfmt+0x189>
  800af2:	89 75 08             	mov    %esi,0x8(%ebp)
  800af5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800af8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800afb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800afe:	eb 6d                	jmp    800b6d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 d0             	pushl  -0x30(%ebp)
  800b06:	57                   	push   %edi
  800b07:	e8 6e 03 00 00       	call   800e7a <strnlen>
  800b0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b0f:	29 c1                	sub    %eax,%ecx
  800b11:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800b14:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800b17:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b1e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800b21:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	eb 0f                	jmp    800b34 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	53                   	push   %ebx
  800b29:	ff 75 e0             	pushl  -0x20(%ebp)
  800b2c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2e:	83 ef 01             	sub    $0x1,%edi
  800b31:	83 c4 10             	add    $0x10,%esp
  800b34:	85 ff                	test   %edi,%edi
  800b36:	7f ed                	jg     800b25 <vprintfmt+0x1ae>
  800b38:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800b3b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800b3e:	85 c9                	test   %ecx,%ecx
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	0f 49 c1             	cmovns %ecx,%eax
  800b48:	29 c1                	sub    %eax,%ecx
  800b4a:	89 75 08             	mov    %esi,0x8(%ebp)
  800b4d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800b50:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800b53:	89 cb                	mov    %ecx,%ebx
  800b55:	eb 16                	jmp    800b6d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800b57:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b5b:	75 31                	jne    800b8e <vprintfmt+0x217>
					putch(ch, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	50                   	push   %eax
  800b64:	ff 55 08             	call   *0x8(%ebp)
  800b67:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6a:	83 eb 01             	sub    $0x1,%ebx
  800b6d:	83 c7 01             	add    $0x1,%edi
  800b70:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800b74:	0f be c2             	movsbl %dl,%eax
  800b77:	85 c0                	test   %eax,%eax
  800b79:	74 59                	je     800bd4 <vprintfmt+0x25d>
  800b7b:	85 f6                	test   %esi,%esi
  800b7d:	78 d8                	js     800b57 <vprintfmt+0x1e0>
  800b7f:	83 ee 01             	sub    $0x1,%esi
  800b82:	79 d3                	jns    800b57 <vprintfmt+0x1e0>
  800b84:	89 df                	mov    %ebx,%edi
  800b86:	8b 75 08             	mov    0x8(%ebp),%esi
  800b89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b8c:	eb 37                	jmp    800bc5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8e:	0f be d2             	movsbl %dl,%edx
  800b91:	83 ea 20             	sub    $0x20,%edx
  800b94:	83 fa 5e             	cmp    $0x5e,%edx
  800b97:	76 c4                	jbe    800b5d <vprintfmt+0x1e6>
					putch('?', putdat);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	6a 3f                	push   $0x3f
  800ba1:	ff 55 08             	call   *0x8(%ebp)
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	eb c1                	jmp    800b6a <vprintfmt+0x1f3>
  800ba9:	89 75 08             	mov    %esi,0x8(%ebp)
  800bac:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800baf:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800bb2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bb5:	eb b6                	jmp    800b6d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	53                   	push   %ebx
  800bbb:	6a 20                	push   $0x20
  800bbd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800bbf:	83 ef 01             	sub    $0x1,%edi
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	85 ff                	test   %edi,%edi
  800bc7:	7f ee                	jg     800bb7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bcc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bcf:	e9 78 01 00 00       	jmp    800d4c <vprintfmt+0x3d5>
  800bd4:	89 df                	mov    %ebx,%edi
  800bd6:	8b 75 08             	mov    0x8(%ebp),%esi
  800bd9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bdc:	eb e7                	jmp    800bc5 <vprintfmt+0x24e>
	if (lflag >= 2)
  800bde:	83 f9 01             	cmp    $0x1,%ecx
  800be1:	7e 3f                	jle    800c22 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800be3:	8b 45 14             	mov    0x14(%ebp),%eax
  800be6:	8b 50 04             	mov    0x4(%eax),%edx
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf4:	8d 40 08             	lea    0x8(%eax),%eax
  800bf7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800bfa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bfe:	79 5c                	jns    800c5c <vprintfmt+0x2e5>
				putch('-', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	53                   	push   %ebx
  800c04:	6a 2d                	push   $0x2d
  800c06:	ff d6                	call   *%esi
				num = -(long long) num;
  800c08:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c0b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c0e:	f7 da                	neg    %edx
  800c10:	83 d1 00             	adc    $0x0,%ecx
  800c13:	f7 d9                	neg    %ecx
  800c15:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c18:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1d:	e9 10 01 00 00       	jmp    800d32 <vprintfmt+0x3bb>
	else if (lflag)
  800c22:	85 c9                	test   %ecx,%ecx
  800c24:	75 1b                	jne    800c41 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800c26:	8b 45 14             	mov    0x14(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2e:	89 c1                	mov    %eax,%ecx
  800c30:	c1 f9 1f             	sar    $0x1f,%ecx
  800c33:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	8d 40 04             	lea    0x4(%eax),%eax
  800c3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3f:	eb b9                	jmp    800bfa <vprintfmt+0x283>
		return va_arg(*ap, long);
  800c41:	8b 45 14             	mov    0x14(%ebp),%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c49:	89 c1                	mov    %eax,%ecx
  800c4b:	c1 f9 1f             	sar    $0x1f,%ecx
  800c4e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800c51:	8b 45 14             	mov    0x14(%ebp),%eax
  800c54:	8d 40 04             	lea    0x4(%eax),%eax
  800c57:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5a:	eb 9e                	jmp    800bfa <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800c5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c5f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800c62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c67:	e9 c6 00 00 00       	jmp    800d32 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800c6c:	83 f9 01             	cmp    $0x1,%ecx
  800c6f:	7e 18                	jle    800c89 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800c71:	8b 45 14             	mov    0x14(%ebp),%eax
  800c74:	8b 10                	mov    (%eax),%edx
  800c76:	8b 48 04             	mov    0x4(%eax),%ecx
  800c79:	8d 40 08             	lea    0x8(%eax),%eax
  800c7c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c7f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c84:	e9 a9 00 00 00       	jmp    800d32 <vprintfmt+0x3bb>
	else if (lflag)
  800c89:	85 c9                	test   %ecx,%ecx
  800c8b:	75 1a                	jne    800ca7 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	8b 10                	mov    (%eax),%edx
  800c92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c97:	8d 40 04             	lea    0x4(%eax),%eax
  800c9a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c9d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ca2:	e9 8b 00 00 00       	jmp    800d32 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	8b 10                	mov    (%eax),%edx
  800cac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb1:	8d 40 04             	lea    0x4(%eax),%eax
  800cb4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800cb7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbc:	eb 74                	jmp    800d32 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800cbe:	83 f9 01             	cmp    $0x1,%ecx
  800cc1:	7e 15                	jle    800cd8 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	8b 10                	mov    (%eax),%edx
  800cc8:	8b 48 04             	mov    0x4(%eax),%ecx
  800ccb:	8d 40 08             	lea    0x8(%eax),%eax
  800cce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cd1:	b8 08 00 00 00       	mov    $0x8,%eax
  800cd6:	eb 5a                	jmp    800d32 <vprintfmt+0x3bb>
	else if (lflag)
  800cd8:	85 c9                	test   %ecx,%ecx
  800cda:	75 17                	jne    800cf3 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	8b 10                	mov    (%eax),%edx
  800ce1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce6:	8d 40 04             	lea    0x4(%eax),%eax
  800ce9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cec:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf1:	eb 3f                	jmp    800d32 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800cf3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf6:	8b 10                	mov    (%eax),%edx
  800cf8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cfd:	8d 40 04             	lea    0x4(%eax),%eax
  800d00:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d03:	b8 08 00 00 00       	mov    $0x8,%eax
  800d08:	eb 28                	jmp    800d32 <vprintfmt+0x3bb>
			putch('0', putdat);
  800d0a:	83 ec 08             	sub    $0x8,%esp
  800d0d:	53                   	push   %ebx
  800d0e:	6a 30                	push   $0x30
  800d10:	ff d6                	call   *%esi
			putch('x', putdat);
  800d12:	83 c4 08             	add    $0x8,%esp
  800d15:	53                   	push   %ebx
  800d16:	6a 78                	push   $0x78
  800d18:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	8b 10                	mov    (%eax),%edx
  800d1f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800d24:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d27:	8d 40 04             	lea    0x4(%eax),%eax
  800d2a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d2d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d32:	83 ec 0c             	sub    $0xc,%esp
  800d35:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800d39:	57                   	push   %edi
  800d3a:	ff 75 e0             	pushl  -0x20(%ebp)
  800d3d:	50                   	push   %eax
  800d3e:	51                   	push   %ecx
  800d3f:	52                   	push   %edx
  800d40:	89 da                	mov    %ebx,%edx
  800d42:	89 f0                	mov    %esi,%eax
  800d44:	e8 45 fb ff ff       	call   80088e <printnum>
			break;
  800d49:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800d4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4f:	83 c7 01             	add    $0x1,%edi
  800d52:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d56:	83 f8 25             	cmp    $0x25,%eax
  800d59:	0f 84 2f fc ff ff    	je     80098e <vprintfmt+0x17>
			if (ch == '\0')
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	0f 84 8b 00 00 00    	je     800df2 <vprintfmt+0x47b>
			putch(ch, putdat);
  800d67:	83 ec 08             	sub    $0x8,%esp
  800d6a:	53                   	push   %ebx
  800d6b:	50                   	push   %eax
  800d6c:	ff d6                	call   *%esi
  800d6e:	83 c4 10             	add    $0x10,%esp
  800d71:	eb dc                	jmp    800d4f <vprintfmt+0x3d8>
	if (lflag >= 2)
  800d73:	83 f9 01             	cmp    $0x1,%ecx
  800d76:	7e 15                	jle    800d8d <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800d78:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7b:	8b 10                	mov    (%eax),%edx
  800d7d:	8b 48 04             	mov    0x4(%eax),%ecx
  800d80:	8d 40 08             	lea    0x8(%eax),%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d86:	b8 10 00 00 00       	mov    $0x10,%eax
  800d8b:	eb a5                	jmp    800d32 <vprintfmt+0x3bb>
	else if (lflag)
  800d8d:	85 c9                	test   %ecx,%ecx
  800d8f:	75 17                	jne    800da8 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800d91:	8b 45 14             	mov    0x14(%ebp),%eax
  800d94:	8b 10                	mov    (%eax),%edx
  800d96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d9b:	8d 40 04             	lea    0x4(%eax),%eax
  800d9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800da1:	b8 10 00 00 00       	mov    $0x10,%eax
  800da6:	eb 8a                	jmp    800d32 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800da8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dab:	8b 10                	mov    (%eax),%edx
  800dad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db2:	8d 40 04             	lea    0x4(%eax),%eax
  800db5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800db8:	b8 10 00 00 00       	mov    $0x10,%eax
  800dbd:	e9 70 ff ff ff       	jmp    800d32 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800dc2:	83 ec 08             	sub    $0x8,%esp
  800dc5:	53                   	push   %ebx
  800dc6:	6a 25                	push   $0x25
  800dc8:	ff d6                	call   *%esi
			break;
  800dca:	83 c4 10             	add    $0x10,%esp
  800dcd:	e9 7a ff ff ff       	jmp    800d4c <vprintfmt+0x3d5>
			putch('%', putdat);
  800dd2:	83 ec 08             	sub    $0x8,%esp
  800dd5:	53                   	push   %ebx
  800dd6:	6a 25                	push   $0x25
  800dd8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dda:	83 c4 10             	add    $0x10,%esp
  800ddd:	89 f8                	mov    %edi,%eax
  800ddf:	eb 03                	jmp    800de4 <vprintfmt+0x46d>
  800de1:	83 e8 01             	sub    $0x1,%eax
  800de4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800de8:	75 f7                	jne    800de1 <vprintfmt+0x46a>
  800dea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ded:	e9 5a ff ff ff       	jmp    800d4c <vprintfmt+0x3d5>
}
  800df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    

00800dfa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 18             	sub    $0x18,%esp
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e09:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e0d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	74 26                	je     800e41 <vsnprintf+0x47>
  800e1b:	85 d2                	test   %edx,%edx
  800e1d:	7e 22                	jle    800e41 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e1f:	ff 75 14             	pushl  0x14(%ebp)
  800e22:	ff 75 10             	pushl  0x10(%ebp)
  800e25:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e28:	50                   	push   %eax
  800e29:	68 3d 09 80 00       	push   $0x80093d
  800e2e:	e8 44 fb ff ff       	call   800977 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e36:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    
		return -E_INVAL;
  800e41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e46:	eb f7                	jmp    800e3f <vsnprintf+0x45>

00800e48 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e4e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e51:	50                   	push   %eax
  800e52:	ff 75 10             	pushl  0x10(%ebp)
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	ff 75 08             	pushl  0x8(%ebp)
  800e5b:	e8 9a ff ff ff       	call   800dfa <vsnprintf>
	va_end(ap);

	return rc;
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e68:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6d:	eb 03                	jmp    800e72 <strlen+0x10>
		n++;
  800e6f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800e72:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e76:	75 f7                	jne    800e6f <strlen+0xd>
	return n;
}
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e80:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
  800e88:	eb 03                	jmp    800e8d <strnlen+0x13>
		n++;
  800e8a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8d:	39 d0                	cmp    %edx,%eax
  800e8f:	74 06                	je     800e97 <strnlen+0x1d>
  800e91:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800e95:	75 f3                	jne    800e8a <strnlen+0x10>
	return n;
}
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	53                   	push   %ebx
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ea3:	89 c2                	mov    %eax,%edx
  800ea5:	83 c1 01             	add    $0x1,%ecx
  800ea8:	83 c2 01             	add    $0x1,%edx
  800eab:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800eaf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800eb2:	84 db                	test   %bl,%bl
  800eb4:	75 ef                	jne    800ea5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800eb6:	5b                   	pop    %ebx
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	53                   	push   %ebx
  800ebd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ec0:	53                   	push   %ebx
  800ec1:	e8 9c ff ff ff       	call   800e62 <strlen>
  800ec6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800ec9:	ff 75 0c             	pushl  0xc(%ebp)
  800ecc:	01 d8                	add    %ebx,%eax
  800ece:	50                   	push   %eax
  800ecf:	e8 c5 ff ff ff       	call   800e99 <strcpy>
	return dst;
}
  800ed4:	89 d8                	mov    %ebx,%eax
  800ed6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	89 f3                	mov    %esi,%ebx
  800ee8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eeb:	89 f2                	mov    %esi,%edx
  800eed:	eb 0f                	jmp    800efe <strncpy+0x23>
		*dst++ = *src;
  800eef:	83 c2 01             	add    $0x1,%edx
  800ef2:	0f b6 01             	movzbl (%ecx),%eax
  800ef5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ef8:	80 39 01             	cmpb   $0x1,(%ecx)
  800efb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800efe:	39 da                	cmp    %ebx,%edx
  800f00:	75 ed                	jne    800eef <strncpy+0x14>
	}
	return ret;
}
  800f02:	89 f0                	mov    %esi,%eax
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f16:	89 f0                	mov    %esi,%eax
  800f18:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f1c:	85 c9                	test   %ecx,%ecx
  800f1e:	75 0b                	jne    800f2b <strlcpy+0x23>
  800f20:	eb 17                	jmp    800f39 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800f22:	83 c2 01             	add    $0x1,%edx
  800f25:	83 c0 01             	add    $0x1,%eax
  800f28:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800f2b:	39 d8                	cmp    %ebx,%eax
  800f2d:	74 07                	je     800f36 <strlcpy+0x2e>
  800f2f:	0f b6 0a             	movzbl (%edx),%ecx
  800f32:	84 c9                	test   %cl,%cl
  800f34:	75 ec                	jne    800f22 <strlcpy+0x1a>
		*dst = '\0';
  800f36:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f39:	29 f0                	sub    %esi,%eax
}
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f45:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f48:	eb 06                	jmp    800f50 <strcmp+0x11>
		p++, q++;
  800f4a:	83 c1 01             	add    $0x1,%ecx
  800f4d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800f50:	0f b6 01             	movzbl (%ecx),%eax
  800f53:	84 c0                	test   %al,%al
  800f55:	74 04                	je     800f5b <strcmp+0x1c>
  800f57:	3a 02                	cmp    (%edx),%al
  800f59:	74 ef                	je     800f4a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5b:	0f b6 c0             	movzbl %al,%eax
  800f5e:	0f b6 12             	movzbl (%edx),%edx
  800f61:	29 d0                	sub    %edx,%eax
}
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	53                   	push   %ebx
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6f:	89 c3                	mov    %eax,%ebx
  800f71:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f74:	eb 06                	jmp    800f7c <strncmp+0x17>
		n--, p++, q++;
  800f76:	83 c0 01             	add    $0x1,%eax
  800f79:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f7c:	39 d8                	cmp    %ebx,%eax
  800f7e:	74 16                	je     800f96 <strncmp+0x31>
  800f80:	0f b6 08             	movzbl (%eax),%ecx
  800f83:	84 c9                	test   %cl,%cl
  800f85:	74 04                	je     800f8b <strncmp+0x26>
  800f87:	3a 0a                	cmp    (%edx),%cl
  800f89:	74 eb                	je     800f76 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f8b:	0f b6 00             	movzbl (%eax),%eax
  800f8e:	0f b6 12             	movzbl (%edx),%edx
  800f91:	29 d0                	sub    %edx,%eax
}
  800f93:	5b                   	pop    %ebx
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    
		return 0;
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9b:	eb f6                	jmp    800f93 <strncmp+0x2e>

00800f9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fa7:	0f b6 10             	movzbl (%eax),%edx
  800faa:	84 d2                	test   %dl,%dl
  800fac:	74 09                	je     800fb7 <strchr+0x1a>
		if (*s == c)
  800fae:	38 ca                	cmp    %cl,%dl
  800fb0:	74 0a                	je     800fbc <strchr+0x1f>
	for (; *s; s++)
  800fb2:	83 c0 01             	add    $0x1,%eax
  800fb5:	eb f0                	jmp    800fa7 <strchr+0xa>
			return (char *) s;
	return 0;
  800fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800fc8:	eb 03                	jmp    800fcd <strfind+0xf>
  800fca:	83 c0 01             	add    $0x1,%eax
  800fcd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800fd0:	38 ca                	cmp    %cl,%dl
  800fd2:	74 04                	je     800fd8 <strfind+0x1a>
  800fd4:	84 d2                	test   %dl,%dl
  800fd6:	75 f2                	jne    800fca <strfind+0xc>
			break;
	return (char *) s;
}
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
  800fe0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fe3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800fe6:	85 c9                	test   %ecx,%ecx
  800fe8:	74 13                	je     800ffd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800fea:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ff0:	75 05                	jne    800ff7 <memset+0x1d>
  800ff2:	f6 c1 03             	test   $0x3,%cl
  800ff5:	74 0d                	je     801004 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	fc                   	cld    
  800ffb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ffd:	89 f8                	mov    %edi,%eax
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    
		c &= 0xFF;
  801004:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801008:	89 d3                	mov    %edx,%ebx
  80100a:	c1 e3 08             	shl    $0x8,%ebx
  80100d:	89 d0                	mov    %edx,%eax
  80100f:	c1 e0 18             	shl    $0x18,%eax
  801012:	89 d6                	mov    %edx,%esi
  801014:	c1 e6 10             	shl    $0x10,%esi
  801017:	09 f0                	or     %esi,%eax
  801019:	09 c2                	or     %eax,%edx
  80101b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80101d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801020:	89 d0                	mov    %edx,%eax
  801022:	fc                   	cld    
  801023:	f3 ab                	rep stos %eax,%es:(%edi)
  801025:	eb d6                	jmp    800ffd <memset+0x23>

00801027 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801032:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801035:	39 c6                	cmp    %eax,%esi
  801037:	73 35                	jae    80106e <memmove+0x47>
  801039:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80103c:	39 c2                	cmp    %eax,%edx
  80103e:	76 2e                	jbe    80106e <memmove+0x47>
		s += n;
		d += n;
  801040:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801043:	89 d6                	mov    %edx,%esi
  801045:	09 fe                	or     %edi,%esi
  801047:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80104d:	74 0c                	je     80105b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80104f:	83 ef 01             	sub    $0x1,%edi
  801052:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801055:	fd                   	std    
  801056:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801058:	fc                   	cld    
  801059:	eb 21                	jmp    80107c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80105b:	f6 c1 03             	test   $0x3,%cl
  80105e:	75 ef                	jne    80104f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801060:	83 ef 04             	sub    $0x4,%edi
  801063:	8d 72 fc             	lea    -0x4(%edx),%esi
  801066:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801069:	fd                   	std    
  80106a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80106c:	eb ea                	jmp    801058 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80106e:	89 f2                	mov    %esi,%edx
  801070:	09 c2                	or     %eax,%edx
  801072:	f6 c2 03             	test   $0x3,%dl
  801075:	74 09                	je     801080 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801077:	89 c7                	mov    %eax,%edi
  801079:	fc                   	cld    
  80107a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80107c:	5e                   	pop    %esi
  80107d:	5f                   	pop    %edi
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801080:	f6 c1 03             	test   $0x3,%cl
  801083:	75 f2                	jne    801077 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801085:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801088:	89 c7                	mov    %eax,%edi
  80108a:	fc                   	cld    
  80108b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80108d:	eb ed                	jmp    80107c <memmove+0x55>

0080108f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801092:	ff 75 10             	pushl  0x10(%ebp)
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	ff 75 08             	pushl  0x8(%ebp)
  80109b:	e8 87 ff ff ff       	call   801027 <memmove>
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ad:	89 c6                	mov    %eax,%esi
  8010af:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8010b2:	39 f0                	cmp    %esi,%eax
  8010b4:	74 1c                	je     8010d2 <memcmp+0x30>
		if (*s1 != *s2)
  8010b6:	0f b6 08             	movzbl (%eax),%ecx
  8010b9:	0f b6 1a             	movzbl (%edx),%ebx
  8010bc:	38 d9                	cmp    %bl,%cl
  8010be:	75 08                	jne    8010c8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8010c0:	83 c0 01             	add    $0x1,%eax
  8010c3:	83 c2 01             	add    $0x1,%edx
  8010c6:	eb ea                	jmp    8010b2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8010c8:	0f b6 c1             	movzbl %cl,%eax
  8010cb:	0f b6 db             	movzbl %bl,%ebx
  8010ce:	29 d8                	sub    %ebx,%eax
  8010d0:	eb 05                	jmp    8010d7 <memcmp+0x35>
	}

	return 0;
  8010d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d7:	5b                   	pop    %ebx
  8010d8:	5e                   	pop    %esi
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010e9:	39 d0                	cmp    %edx,%eax
  8010eb:	73 09                	jae    8010f6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010ed:	38 08                	cmp    %cl,(%eax)
  8010ef:	74 05                	je     8010f6 <memfind+0x1b>
	for (; s < ends; s++)
  8010f1:	83 c0 01             	add    $0x1,%eax
  8010f4:	eb f3                	jmp    8010e9 <memfind+0xe>
			break;
	return (void *) s;
}
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	57                   	push   %edi
  8010fc:	56                   	push   %esi
  8010fd:	53                   	push   %ebx
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801104:	eb 03                	jmp    801109 <strtol+0x11>
		s++;
  801106:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801109:	0f b6 01             	movzbl (%ecx),%eax
  80110c:	3c 20                	cmp    $0x20,%al
  80110e:	74 f6                	je     801106 <strtol+0xe>
  801110:	3c 09                	cmp    $0x9,%al
  801112:	74 f2                	je     801106 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801114:	3c 2b                	cmp    $0x2b,%al
  801116:	74 2e                	je     801146 <strtol+0x4e>
	int neg = 0;
  801118:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80111d:	3c 2d                	cmp    $0x2d,%al
  80111f:	74 2f                	je     801150 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801121:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801127:	75 05                	jne    80112e <strtol+0x36>
  801129:	80 39 30             	cmpb   $0x30,(%ecx)
  80112c:	74 2c                	je     80115a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80112e:	85 db                	test   %ebx,%ebx
  801130:	75 0a                	jne    80113c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801132:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801137:	80 39 30             	cmpb   $0x30,(%ecx)
  80113a:	74 28                	je     801164 <strtol+0x6c>
		base = 10;
  80113c:	b8 00 00 00 00       	mov    $0x0,%eax
  801141:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801144:	eb 50                	jmp    801196 <strtol+0x9e>
		s++;
  801146:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801149:	bf 00 00 00 00       	mov    $0x0,%edi
  80114e:	eb d1                	jmp    801121 <strtol+0x29>
		s++, neg = 1;
  801150:	83 c1 01             	add    $0x1,%ecx
  801153:	bf 01 00 00 00       	mov    $0x1,%edi
  801158:	eb c7                	jmp    801121 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80115a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80115e:	74 0e                	je     80116e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801160:	85 db                	test   %ebx,%ebx
  801162:	75 d8                	jne    80113c <strtol+0x44>
		s++, base = 8;
  801164:	83 c1 01             	add    $0x1,%ecx
  801167:	bb 08 00 00 00       	mov    $0x8,%ebx
  80116c:	eb ce                	jmp    80113c <strtol+0x44>
		s += 2, base = 16;
  80116e:	83 c1 02             	add    $0x2,%ecx
  801171:	bb 10 00 00 00       	mov    $0x10,%ebx
  801176:	eb c4                	jmp    80113c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801178:	8d 72 9f             	lea    -0x61(%edx),%esi
  80117b:	89 f3                	mov    %esi,%ebx
  80117d:	80 fb 19             	cmp    $0x19,%bl
  801180:	77 29                	ja     8011ab <strtol+0xb3>
			dig = *s - 'a' + 10;
  801182:	0f be d2             	movsbl %dl,%edx
  801185:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801188:	3b 55 10             	cmp    0x10(%ebp),%edx
  80118b:	7d 30                	jge    8011bd <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80118d:	83 c1 01             	add    $0x1,%ecx
  801190:	0f af 45 10          	imul   0x10(%ebp),%eax
  801194:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801196:	0f b6 11             	movzbl (%ecx),%edx
  801199:	8d 72 d0             	lea    -0x30(%edx),%esi
  80119c:	89 f3                	mov    %esi,%ebx
  80119e:	80 fb 09             	cmp    $0x9,%bl
  8011a1:	77 d5                	ja     801178 <strtol+0x80>
			dig = *s - '0';
  8011a3:	0f be d2             	movsbl %dl,%edx
  8011a6:	83 ea 30             	sub    $0x30,%edx
  8011a9:	eb dd                	jmp    801188 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8011ab:	8d 72 bf             	lea    -0x41(%edx),%esi
  8011ae:	89 f3                	mov    %esi,%ebx
  8011b0:	80 fb 19             	cmp    $0x19,%bl
  8011b3:	77 08                	ja     8011bd <strtol+0xc5>
			dig = *s - 'A' + 10;
  8011b5:	0f be d2             	movsbl %dl,%edx
  8011b8:	83 ea 37             	sub    $0x37,%edx
  8011bb:	eb cb                	jmp    801188 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8011bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c1:	74 05                	je     8011c8 <strtol+0xd0>
		*endptr = (char *) s;
  8011c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011c6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8011c8:	89 c2                	mov    %eax,%edx
  8011ca:	f7 da                	neg    %edx
  8011cc:	85 ff                	test   %edi,%edi
  8011ce:	0f 45 c2             	cmovne %edx,%eax
}
  8011d1:	5b                   	pop    %ebx
  8011d2:	5e                   	pop    %esi
  8011d3:	5f                   	pop    %edi
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	57                   	push   %edi
  8011da:	56                   	push   %esi
  8011db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e7:	89 c3                	mov    %eax,%ebx
  8011e9:	89 c7                	mov    %eax,%edi
  8011eb:	89 c6                	mov    %eax,%esi
  8011ed:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011ef:	5b                   	pop    %ebx
  8011f0:	5e                   	pop    %esi
  8011f1:	5f                   	pop    %edi
  8011f2:	5d                   	pop    %ebp
  8011f3:	c3                   	ret    

008011f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	57                   	push   %edi
  8011f8:	56                   	push   %esi
  8011f9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801204:	89 d1                	mov    %edx,%ecx
  801206:	89 d3                	mov    %edx,%ebx
  801208:	89 d7                	mov    %edx,%edi
  80120a:	89 d6                	mov    %edx,%esi
  80120c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	5f                   	pop    %edi
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    

00801213 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80121c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	b8 03 00 00 00       	mov    $0x3,%eax
  801229:	89 cb                	mov    %ecx,%ebx
  80122b:	89 cf                	mov    %ecx,%edi
  80122d:	89 ce                	mov    %ecx,%esi
  80122f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801231:	85 c0                	test   %eax,%eax
  801233:	7f 08                	jg     80123d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801235:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801238:	5b                   	pop    %ebx
  801239:	5e                   	pop    %esi
  80123a:	5f                   	pop    %edi
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	50                   	push   %eax
  801241:	6a 03                	push   $0x3
  801243:	68 df 30 80 00       	push   $0x8030df
  801248:	6a 23                	push   $0x23
  80124a:	68 fc 30 80 00       	push   $0x8030fc
  80124f:	e8 4b f5 ff ff       	call   80079f <_panic>

00801254 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	57                   	push   %edi
  801258:	56                   	push   %esi
  801259:	53                   	push   %ebx
	asm volatile("int %1\n"
  80125a:	ba 00 00 00 00       	mov    $0x0,%edx
  80125f:	b8 02 00 00 00       	mov    $0x2,%eax
  801264:	89 d1                	mov    %edx,%ecx
  801266:	89 d3                	mov    %edx,%ebx
  801268:	89 d7                	mov    %edx,%edi
  80126a:	89 d6                	mov    %edx,%esi
  80126c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80126e:	5b                   	pop    %ebx
  80126f:	5e                   	pop    %esi
  801270:	5f                   	pop    %edi
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    

00801273 <sys_yield>:

void
sys_yield(void)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	57                   	push   %edi
  801277:	56                   	push   %esi
  801278:	53                   	push   %ebx
	asm volatile("int %1\n"
  801279:	ba 00 00 00 00       	mov    $0x0,%edx
  80127e:	b8 0b 00 00 00       	mov    $0xb,%eax
  801283:	89 d1                	mov    %edx,%ecx
  801285:	89 d3                	mov    %edx,%ebx
  801287:	89 d7                	mov    %edx,%edi
  801289:	89 d6                	mov    %edx,%esi
  80128b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5f                   	pop    %edi
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	57                   	push   %edi
  801296:	56                   	push   %esi
  801297:	53                   	push   %ebx
  801298:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80129b:	be 00 00 00 00       	mov    $0x0,%esi
  8012a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	b8 04 00 00 00       	mov    $0x4,%eax
  8012ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ae:	89 f7                	mov    %esi,%edi
  8012b0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	7f 08                	jg     8012be <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b9:	5b                   	pop    %ebx
  8012ba:	5e                   	pop    %esi
  8012bb:	5f                   	pop    %edi
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	50                   	push   %eax
  8012c2:	6a 04                	push   $0x4
  8012c4:	68 df 30 80 00       	push   $0x8030df
  8012c9:	6a 23                	push   $0x23
  8012cb:	68 fc 30 80 00       	push   $0x8030fc
  8012d0:	e8 ca f4 ff ff       	call   80079f <_panic>

008012d5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012de:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e4:	b8 05 00 00 00       	mov    $0x5,%eax
  8012e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ec:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	7f 08                	jg     801300 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fb:	5b                   	pop    %ebx
  8012fc:	5e                   	pop    %esi
  8012fd:	5f                   	pop    %edi
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801300:	83 ec 0c             	sub    $0xc,%esp
  801303:	50                   	push   %eax
  801304:	6a 05                	push   $0x5
  801306:	68 df 30 80 00       	push   $0x8030df
  80130b:	6a 23                	push   $0x23
  80130d:	68 fc 30 80 00       	push   $0x8030fc
  801312:	e8 88 f4 ff ff       	call   80079f <_panic>

00801317 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	57                   	push   %edi
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
  80131d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801320:	bb 00 00 00 00       	mov    $0x0,%ebx
  801325:	8b 55 08             	mov    0x8(%ebp),%edx
  801328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80132b:	b8 06 00 00 00       	mov    $0x6,%eax
  801330:	89 df                	mov    %ebx,%edi
  801332:	89 de                	mov    %ebx,%esi
  801334:	cd 30                	int    $0x30
	if(check && ret > 0)
  801336:	85 c0                	test   %eax,%eax
  801338:	7f 08                	jg     801342 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133d:	5b                   	pop    %ebx
  80133e:	5e                   	pop    %esi
  80133f:	5f                   	pop    %edi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801342:	83 ec 0c             	sub    $0xc,%esp
  801345:	50                   	push   %eax
  801346:	6a 06                	push   $0x6
  801348:	68 df 30 80 00       	push   $0x8030df
  80134d:	6a 23                	push   $0x23
  80134f:	68 fc 30 80 00       	push   $0x8030fc
  801354:	e8 46 f4 ff ff       	call   80079f <_panic>

00801359 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	57                   	push   %edi
  80135d:	56                   	push   %esi
  80135e:	53                   	push   %ebx
  80135f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801362:	bb 00 00 00 00       	mov    $0x0,%ebx
  801367:	8b 55 08             	mov    0x8(%ebp),%edx
  80136a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80136d:	b8 08 00 00 00       	mov    $0x8,%eax
  801372:	89 df                	mov    %ebx,%edi
  801374:	89 de                	mov    %ebx,%esi
  801376:	cd 30                	int    $0x30
	if(check && ret > 0)
  801378:	85 c0                	test   %eax,%eax
  80137a:	7f 08                	jg     801384 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80137c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137f:	5b                   	pop    %ebx
  801380:	5e                   	pop    %esi
  801381:	5f                   	pop    %edi
  801382:	5d                   	pop    %ebp
  801383:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801384:	83 ec 0c             	sub    $0xc,%esp
  801387:	50                   	push   %eax
  801388:	6a 08                	push   $0x8
  80138a:	68 df 30 80 00       	push   $0x8030df
  80138f:	6a 23                	push   $0x23
  801391:	68 fc 30 80 00       	push   $0x8030fc
  801396:	e8 04 f4 ff ff       	call   80079f <_panic>

0080139b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	57                   	push   %edi
  80139f:	56                   	push   %esi
  8013a0:	53                   	push   %ebx
  8013a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013af:	b8 09 00 00 00       	mov    $0x9,%eax
  8013b4:	89 df                	mov    %ebx,%edi
  8013b6:	89 de                	mov    %ebx,%esi
  8013b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	7f 08                	jg     8013c6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c6:	83 ec 0c             	sub    $0xc,%esp
  8013c9:	50                   	push   %eax
  8013ca:	6a 09                	push   $0x9
  8013cc:	68 df 30 80 00       	push   $0x8030df
  8013d1:	6a 23                	push   $0x23
  8013d3:	68 fc 30 80 00       	push   $0x8030fc
  8013d8:	e8 c2 f3 ff ff       	call   80079f <_panic>

008013dd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	57                   	push   %edi
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
  8013e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013f6:	89 df                	mov    %ebx,%edi
  8013f8:	89 de                	mov    %ebx,%esi
  8013fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	7f 08                	jg     801408 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801408:	83 ec 0c             	sub    $0xc,%esp
  80140b:	50                   	push   %eax
  80140c:	6a 0a                	push   $0xa
  80140e:	68 df 30 80 00       	push   $0x8030df
  801413:	6a 23                	push   $0x23
  801415:	68 fc 30 80 00       	push   $0x8030fc
  80141a:	e8 80 f3 ff ff       	call   80079f <_panic>

0080141f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	57                   	push   %edi
  801423:	56                   	push   %esi
  801424:	53                   	push   %ebx
	asm volatile("int %1\n"
  801425:	8b 55 08             	mov    0x8(%ebp),%edx
  801428:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801430:	be 00 00 00 00       	mov    $0x0,%esi
  801435:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801438:	8b 7d 14             	mov    0x14(%ebp),%edi
  80143b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80143d:	5b                   	pop    %ebx
  80143e:	5e                   	pop    %esi
  80143f:	5f                   	pop    %edi
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	57                   	push   %edi
  801446:	56                   	push   %esi
  801447:	53                   	push   %ebx
  801448:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80144b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801450:	8b 55 08             	mov    0x8(%ebp),%edx
  801453:	b8 0d 00 00 00       	mov    $0xd,%eax
  801458:	89 cb                	mov    %ecx,%ebx
  80145a:	89 cf                	mov    %ecx,%edi
  80145c:	89 ce                	mov    %ecx,%esi
  80145e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801460:	85 c0                	test   %eax,%eax
  801462:	7f 08                	jg     80146c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801464:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801467:	5b                   	pop    %ebx
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	50                   	push   %eax
  801470:	6a 0d                	push   $0xd
  801472:	68 df 30 80 00       	push   $0x8030df
  801477:	6a 23                	push   $0x23
  801479:	68 fc 30 80 00       	push   $0x8030fc
  80147e:	e8 1c f3 ff ff       	call   80079f <_panic>

00801483 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	57                   	push   %edi
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
	asm volatile("int %1\n"
  801489:	ba 00 00 00 00       	mov    $0x0,%edx
  80148e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801493:	89 d1                	mov    %edx,%ecx
  801495:	89 d3                	mov    %edx,%ebx
  801497:	89 d7                	mov    %edx,%edi
  801499:	89 d6                	mov    %edx,%esi
  80149b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80149d:	5b                   	pop    %ebx
  80149e:	5e                   	pop    %esi
  80149f:	5f                   	pop    %edi
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  8014aa:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  8014ac:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8014b0:	74 7f                	je     801531 <pgfault+0x8f>
  8014b2:	89 d8                	mov    %ebx,%eax
  8014b4:	c1 e8 0c             	shr    $0xc,%eax
  8014b7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014be:	f6 c4 08             	test   $0x8,%ah
  8014c1:	74 6e                	je     801531 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  8014c3:	e8 8c fd ff ff       	call   801254 <sys_getenvid>
  8014c8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	6a 07                	push   $0x7
  8014cf:	68 00 f0 7f 00       	push   $0x7ff000
  8014d4:	50                   	push   %eax
  8014d5:	e8 b8 fd ff ff       	call   801292 <sys_page_alloc>
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 64                	js     801545 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  8014e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	68 00 10 00 00       	push   $0x1000
  8014ef:	53                   	push   %ebx
  8014f0:	68 00 f0 7f 00       	push   $0x7ff000
  8014f5:	e8 2d fb ff ff       	call   801027 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  8014fa:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801501:	53                   	push   %ebx
  801502:	56                   	push   %esi
  801503:	68 00 f0 7f 00       	push   $0x7ff000
  801508:	56                   	push   %esi
  801509:	e8 c7 fd ff ff       	call   8012d5 <sys_page_map>
  80150e:	83 c4 20             	add    $0x20,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	78 42                	js     801557 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	68 00 f0 7f 00       	push   $0x7ff000
  80151d:	56                   	push   %esi
  80151e:	e8 f4 fd ff ff       	call   801317 <sys_page_unmap>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 3f                	js     801569 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  80152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5e                   	pop    %esi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	68 0c 31 80 00       	push   $0x80310c
  801539:	6a 1d                	push   $0x1d
  80153b:	68 9b 31 80 00       	push   $0x80319b
  801540:	e8 5a f2 ff ff       	call   80079f <_panic>
		panic("pgfault:page allocation failed: %e", r);
  801545:	50                   	push   %eax
  801546:	68 34 31 80 00       	push   $0x803134
  80154b:	6a 28                	push   $0x28
  80154d:	68 9b 31 80 00       	push   $0x80319b
  801552:	e8 48 f2 ff ff       	call   80079f <_panic>
		panic("pgfault:page map failed: %e", r);
  801557:	50                   	push   %eax
  801558:	68 a6 31 80 00       	push   $0x8031a6
  80155d:	6a 2c                	push   $0x2c
  80155f:	68 9b 31 80 00       	push   $0x80319b
  801564:	e8 36 f2 ff ff       	call   80079f <_panic>
		panic("pgfault: page unmap failed: %e", r);
  801569:	50                   	push   %eax
  80156a:	68 58 31 80 00       	push   $0x803158
  80156f:	6a 2e                	push   $0x2e
  801571:	68 9b 31 80 00       	push   $0x80319b
  801576:	e8 24 f2 ff ff       	call   80079f <_panic>

0080157b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	57                   	push   %edi
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
  801581:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  801584:	68 a2 14 80 00       	push   $0x8014a2
  801589:	e8 c6 13 00 00       	call   802954 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80158e:	b8 07 00 00 00       	mov    $0x7,%eax
  801593:	cd 30                	int    $0x30
  801595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 2f                	js     8015ce <fork+0x53>
  80159f:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8015a1:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  8015a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015aa:	75 6e                	jne    80161a <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015ac:	e8 a3 fc ff ff       	call   801254 <sys_getenvid>
  8015b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015be:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  8015c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  8015c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  8015ce:	50                   	push   %eax
  8015cf:	68 78 31 80 00       	push   $0x803178
  8015d4:	6a 6e                	push   $0x6e
  8015d6:	68 9b 31 80 00       	push   $0x80319b
  8015db:	e8 bf f1 ff ff       	call   80079f <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  8015e0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ef:	50                   	push   %eax
  8015f0:	56                   	push   %esi
  8015f1:	57                   	push   %edi
  8015f2:	56                   	push   %esi
  8015f3:	6a 00                	push   $0x0
  8015f5:	e8 db fc ff ff       	call   8012d5 <sys_page_map>
  8015fa:	83 c4 20             	add    $0x20,%esp
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801604:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  801607:	85 c0                	test   %eax,%eax
  801609:	78 bb                	js     8015c6 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  80160b:	83 c3 01             	add    $0x1,%ebx
  80160e:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801614:	0f 84 a6 00 00 00    	je     8016c0 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  80161a:	89 d8                	mov    %ebx,%eax
  80161c:	c1 e8 0a             	shr    $0xa,%eax
  80161f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801626:	a8 01                	test   $0x1,%al
  801628:	74 e1                	je     80160b <fork+0x90>
  80162a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801631:	a8 01                	test   $0x1,%al
  801633:	74 d6                	je     80160b <fork+0x90>
  801635:	89 de                	mov    %ebx,%esi
  801637:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  80163a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801641:	f6 c4 04             	test   $0x4,%ah
  801644:	75 9a                	jne    8015e0 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801646:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80164d:	a8 02                	test   $0x2,%al
  80164f:	75 0c                	jne    80165d <fork+0xe2>
  801651:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801658:	f6 c4 08             	test   $0x8,%ah
  80165b:	74 42                	je     80169f <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  80165d:	83 ec 0c             	sub    $0xc,%esp
  801660:	68 05 08 00 00       	push   $0x805
  801665:	56                   	push   %esi
  801666:	57                   	push   %edi
  801667:	56                   	push   %esi
  801668:	6a 00                	push   $0x0
  80166a:	e8 66 fc ff ff       	call   8012d5 <sys_page_map>
  80166f:	83 c4 20             	add    $0x20,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	0f 88 4c ff ff ff    	js     8015c6 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	68 05 08 00 00       	push   $0x805
  801682:	56                   	push   %esi
  801683:	6a 00                	push   $0x0
  801685:	56                   	push   %esi
  801686:	6a 00                	push   $0x0
  801688:	e8 48 fc ff ff       	call   8012d5 <sys_page_map>
  80168d:	83 c4 20             	add    $0x20,%esp
  801690:	85 c0                	test   %eax,%eax
  801692:	b9 00 00 00 00       	mov    $0x0,%ecx
  801697:	0f 4f c1             	cmovg  %ecx,%eax
  80169a:	e9 68 ff ff ff       	jmp    801607 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  80169f:	83 ec 0c             	sub    $0xc,%esp
  8016a2:	6a 05                	push   $0x5
  8016a4:	56                   	push   %esi
  8016a5:	57                   	push   %edi
  8016a6:	56                   	push   %esi
  8016a7:	6a 00                	push   $0x0
  8016a9:	e8 27 fc ff ff       	call   8012d5 <sys_page_map>
  8016ae:	83 c4 20             	add    $0x20,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b8:	0f 4f c1             	cmovg  %ecx,%eax
  8016bb:	e9 47 ff ff ff       	jmp    801607 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	6a 07                	push   $0x7
  8016c5:	68 00 f0 bf ee       	push   $0xeebff000
  8016ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016cd:	57                   	push   %edi
  8016ce:	e8 bf fb ff ff       	call   801292 <sys_page_alloc>
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	0f 88 e8 fe ff ff    	js     8015c6 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	68 b9 29 80 00       	push   $0x8029b9
  8016e6:	57                   	push   %edi
  8016e7:	e8 f1 fc ff ff       	call   8013dd <sys_env_set_pgfault_upcall>
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	0f 88 cf fe ff ff    	js     8015c6 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	6a 02                	push   $0x2
  8016fc:	57                   	push   %edi
  8016fd:	e8 57 fc ff ff       	call   801359 <sys_env_set_status>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	78 08                	js     801711 <fork+0x196>
	return eid;
  801709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170c:	e9 b5 fe ff ff       	jmp    8015c6 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  801711:	50                   	push   %eax
  801712:	68 c2 31 80 00       	push   $0x8031c2
  801717:	68 87 00 00 00       	push   $0x87
  80171c:	68 9b 31 80 00       	push   $0x80319b
  801721:	e8 79 f0 ff ff       	call   80079f <_panic>

00801726 <sfork>:

// Challenge!
int sfork(void)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80172c:	68 e0 31 80 00       	push   $0x8031e0
  801731:	68 8f 00 00 00       	push   $0x8f
  801736:	68 9b 31 80 00       	push   $0x80319b
  80173b:	e8 5f f0 ff ff       	call   80079f <_panic>

00801740 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	8b 75 08             	mov    0x8(%ebp),%esi
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80174e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801750:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801755:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	50                   	push   %eax
  80175c:	e8 e1 fc ff ff       	call   801442 <sys_ipc_recv>
	if (from_env_store)
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 f6                	test   %esi,%esi
  801766:	74 14                	je     80177c <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801768:	ba 00 00 00 00       	mov    $0x0,%edx
  80176d:	85 c0                	test   %eax,%eax
  80176f:	78 09                	js     80177a <ipc_recv+0x3a>
  801771:	8b 15 20 50 80 00    	mov    0x805020,%edx
  801777:	8b 52 74             	mov    0x74(%edx),%edx
  80177a:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80177c:	85 db                	test   %ebx,%ebx
  80177e:	74 14                	je     801794 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	85 c0                	test   %eax,%eax
  801787:	78 09                	js     801792 <ipc_recv+0x52>
  801789:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80178f:	8b 52 78             	mov    0x78(%edx),%edx
  801792:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801794:	85 c0                	test   %eax,%eax
  801796:	78 08                	js     8017a0 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801798:	a1 20 50 80 00       	mov    0x805020,%eax
  80179d:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8017a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	57                   	push   %edi
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8017b9:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8017bb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8017c0:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8017c3:	ff 75 14             	pushl  0x14(%ebp)
  8017c6:	53                   	push   %ebx
  8017c7:	56                   	push   %esi
  8017c8:	57                   	push   %edi
  8017c9:	e8 51 fc ff ff       	call   80141f <sys_ipc_try_send>
		if (ret == 0)
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	74 1e                	je     8017f3 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  8017d5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017d8:	75 07                	jne    8017e1 <ipc_send+0x3a>
			sys_yield();
  8017da:	e8 94 fa ff ff       	call   801273 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8017df:	eb e2                	jmp    8017c3 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  8017e1:	50                   	push   %eax
  8017e2:	68 f6 31 80 00       	push   $0x8031f6
  8017e7:	6a 3d                	push   $0x3d
  8017e9:	68 0a 32 80 00       	push   $0x80320a
  8017ee:	e8 ac ef ff ff       	call   80079f <_panic>
	}
	// panic("ipc_send not implemented");
}
  8017f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f6:	5b                   	pop    %ebx
  8017f7:	5e                   	pop    %esi
  8017f8:	5f                   	pop    %edi
  8017f9:	5d                   	pop    %ebp
  8017fa:	c3                   	ret    

008017fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801806:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801809:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80180f:	8b 52 50             	mov    0x50(%edx),%edx
  801812:	39 ca                	cmp    %ecx,%edx
  801814:	74 11                	je     801827 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801816:	83 c0 01             	add    $0x1,%eax
  801819:	3d 00 04 00 00       	cmp    $0x400,%eax
  80181e:	75 e6                	jne    801806 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
  801825:	eb 0b                	jmp    801832 <ipc_find_env+0x37>
			return envs[i].env_id;
  801827:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80182a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80182f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	05 00 00 00 30       	add    $0x30000000,%eax
  80183f:	c1 e8 0c             	shr    $0xc,%eax
}
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80184f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801854:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    

0080185b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801861:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801866:	89 c2                	mov    %eax,%edx
  801868:	c1 ea 16             	shr    $0x16,%edx
  80186b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801872:	f6 c2 01             	test   $0x1,%dl
  801875:	74 2a                	je     8018a1 <fd_alloc+0x46>
  801877:	89 c2                	mov    %eax,%edx
  801879:	c1 ea 0c             	shr    $0xc,%edx
  80187c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801883:	f6 c2 01             	test   $0x1,%dl
  801886:	74 19                	je     8018a1 <fd_alloc+0x46>
  801888:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80188d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801892:	75 d2                	jne    801866 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801894:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80189a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80189f:	eb 07                	jmp    8018a8 <fd_alloc+0x4d>
			*fd_store = fd;
  8018a1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018b0:	83 f8 1f             	cmp    $0x1f,%eax
  8018b3:	77 36                	ja     8018eb <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018b5:	c1 e0 0c             	shl    $0xc,%eax
  8018b8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018bd:	89 c2                	mov    %eax,%edx
  8018bf:	c1 ea 16             	shr    $0x16,%edx
  8018c2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018c9:	f6 c2 01             	test   $0x1,%dl
  8018cc:	74 24                	je     8018f2 <fd_lookup+0x48>
  8018ce:	89 c2                	mov    %eax,%edx
  8018d0:	c1 ea 0c             	shr    $0xc,%edx
  8018d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018da:	f6 c2 01             	test   $0x1,%dl
  8018dd:	74 1a                	je     8018f9 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	89 02                	mov    %eax,(%edx)
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    
		return -E_INVAL;
  8018eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f0:	eb f7                	jmp    8018e9 <fd_lookup+0x3f>
		return -E_INVAL;
  8018f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f7:	eb f0                	jmp    8018e9 <fd_lookup+0x3f>
  8018f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018fe:	eb e9                	jmp    8018e9 <fd_lookup+0x3f>

00801900 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801909:	ba 94 32 80 00       	mov    $0x803294,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80190e:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801913:	39 08                	cmp    %ecx,(%eax)
  801915:	74 33                	je     80194a <dev_lookup+0x4a>
  801917:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80191a:	8b 02                	mov    (%edx),%eax
  80191c:	85 c0                	test   %eax,%eax
  80191e:	75 f3                	jne    801913 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801920:	a1 20 50 80 00       	mov    0x805020,%eax
  801925:	8b 40 48             	mov    0x48(%eax),%eax
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	51                   	push   %ecx
  80192c:	50                   	push   %eax
  80192d:	68 14 32 80 00       	push   $0x803214
  801932:	e8 43 ef ff ff       	call   80087a <cprintf>
	*dev = 0;
  801937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    
			*dev = devtab[i];
  80194a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80194d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80194f:	b8 00 00 00 00       	mov    $0x0,%eax
  801954:	eb f2                	jmp    801948 <dev_lookup+0x48>

00801956 <fd_close>:
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	57                   	push   %edi
  80195a:	56                   	push   %esi
  80195b:	53                   	push   %ebx
  80195c:	83 ec 1c             	sub    $0x1c,%esp
  80195f:	8b 75 08             	mov    0x8(%ebp),%esi
  801962:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801965:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801968:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801969:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80196f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801972:	50                   	push   %eax
  801973:	e8 32 ff ff ff       	call   8018aa <fd_lookup>
  801978:	89 c3                	mov    %eax,%ebx
  80197a:	83 c4 08             	add    $0x8,%esp
  80197d:	85 c0                	test   %eax,%eax
  80197f:	78 05                	js     801986 <fd_close+0x30>
	    || fd != fd2)
  801981:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801984:	74 16                	je     80199c <fd_close+0x46>
		return (must_exist ? r : 0);
  801986:	89 f8                	mov    %edi,%eax
  801988:	84 c0                	test   %al,%al
  80198a:	b8 00 00 00 00       	mov    $0x0,%eax
  80198f:	0f 44 d8             	cmove  %eax,%ebx
}
  801992:	89 d8                	mov    %ebx,%eax
  801994:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801997:	5b                   	pop    %ebx
  801998:	5e                   	pop    %esi
  801999:	5f                   	pop    %edi
  80199a:	5d                   	pop    %ebp
  80199b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019a2:	50                   	push   %eax
  8019a3:	ff 36                	pushl  (%esi)
  8019a5:	e8 56 ff ff ff       	call   801900 <dev_lookup>
  8019aa:	89 c3                	mov    %eax,%ebx
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 15                	js     8019c8 <fd_close+0x72>
		if (dev->dev_close)
  8019b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b6:	8b 40 10             	mov    0x10(%eax),%eax
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	74 1b                	je     8019d8 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	56                   	push   %esi
  8019c1:	ff d0                	call   *%eax
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	56                   	push   %esi
  8019cc:	6a 00                	push   $0x0
  8019ce:	e8 44 f9 ff ff       	call   801317 <sys_page_unmap>
	return r;
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	eb ba                	jmp    801992 <fd_close+0x3c>
			r = 0;
  8019d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019dd:	eb e9                	jmp    8019c8 <fd_close+0x72>

008019df <close>:

int
close(int fdnum)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	e8 b9 fe ff ff       	call   8018aa <fd_lookup>
  8019f1:	83 c4 08             	add    $0x8,%esp
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 10                	js     801a08 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	6a 01                	push   $0x1
  8019fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801a00:	e8 51 ff ff ff       	call   801956 <fd_close>
  801a05:	83 c4 10             	add    $0x10,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <close_all>:

void
close_all(void)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a11:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a16:	83 ec 0c             	sub    $0xc,%esp
  801a19:	53                   	push   %ebx
  801a1a:	e8 c0 ff ff ff       	call   8019df <close>
	for (i = 0; i < MAXFD; i++)
  801a1f:	83 c3 01             	add    $0x1,%ebx
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	83 fb 20             	cmp    $0x20,%ebx
  801a28:	75 ec                	jne    801a16 <close_all+0xc>
}
  801a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	57                   	push   %edi
  801a33:	56                   	push   %esi
  801a34:	53                   	push   %ebx
  801a35:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a38:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a3b:	50                   	push   %eax
  801a3c:	ff 75 08             	pushl  0x8(%ebp)
  801a3f:	e8 66 fe ff ff       	call   8018aa <fd_lookup>
  801a44:	89 c3                	mov    %eax,%ebx
  801a46:	83 c4 08             	add    $0x8,%esp
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	0f 88 81 00 00 00    	js     801ad2 <dup+0xa3>
		return r;
	close(newfdnum);
  801a51:	83 ec 0c             	sub    $0xc,%esp
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	e8 83 ff ff ff       	call   8019df <close>

	newfd = INDEX2FD(newfdnum);
  801a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a5f:	c1 e6 0c             	shl    $0xc,%esi
  801a62:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a68:	83 c4 04             	add    $0x4,%esp
  801a6b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a6e:	e8 d1 fd ff ff       	call   801844 <fd2data>
  801a73:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a75:	89 34 24             	mov    %esi,(%esp)
  801a78:	e8 c7 fd ff ff       	call   801844 <fd2data>
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a82:	89 d8                	mov    %ebx,%eax
  801a84:	c1 e8 16             	shr    $0x16,%eax
  801a87:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a8e:	a8 01                	test   $0x1,%al
  801a90:	74 11                	je     801aa3 <dup+0x74>
  801a92:	89 d8                	mov    %ebx,%eax
  801a94:	c1 e8 0c             	shr    $0xc,%eax
  801a97:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a9e:	f6 c2 01             	test   $0x1,%dl
  801aa1:	75 39                	jne    801adc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801aa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aa6:	89 d0                	mov    %edx,%eax
  801aa8:	c1 e8 0c             	shr    $0xc,%eax
  801aab:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	25 07 0e 00 00       	and    $0xe07,%eax
  801aba:	50                   	push   %eax
  801abb:	56                   	push   %esi
  801abc:	6a 00                	push   $0x0
  801abe:	52                   	push   %edx
  801abf:	6a 00                	push   $0x0
  801ac1:	e8 0f f8 ff ff       	call   8012d5 <sys_page_map>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	83 c4 20             	add    $0x20,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 31                	js     801b00 <dup+0xd1>
		goto err;

	return newfdnum;
  801acf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801ad2:	89 d8                	mov    %ebx,%eax
  801ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801adc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	25 07 0e 00 00       	and    $0xe07,%eax
  801aeb:	50                   	push   %eax
  801aec:	57                   	push   %edi
  801aed:	6a 00                	push   $0x0
  801aef:	53                   	push   %ebx
  801af0:	6a 00                	push   $0x0
  801af2:	e8 de f7 ff ff       	call   8012d5 <sys_page_map>
  801af7:	89 c3                	mov    %eax,%ebx
  801af9:	83 c4 20             	add    $0x20,%esp
  801afc:	85 c0                	test   %eax,%eax
  801afe:	79 a3                	jns    801aa3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	56                   	push   %esi
  801b04:	6a 00                	push   $0x0
  801b06:	e8 0c f8 ff ff       	call   801317 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b0b:	83 c4 08             	add    $0x8,%esp
  801b0e:	57                   	push   %edi
  801b0f:	6a 00                	push   $0x0
  801b11:	e8 01 f8 ff ff       	call   801317 <sys_page_unmap>
	return r;
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	eb b7                	jmp    801ad2 <dup+0xa3>

00801b1b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 14             	sub    $0x14,%esp
  801b22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b25:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b28:	50                   	push   %eax
  801b29:	53                   	push   %ebx
  801b2a:	e8 7b fd ff ff       	call   8018aa <fd_lookup>
  801b2f:	83 c4 08             	add    $0x8,%esp
  801b32:	85 c0                	test   %eax,%eax
  801b34:	78 3f                	js     801b75 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b36:	83 ec 08             	sub    $0x8,%esp
  801b39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3c:	50                   	push   %eax
  801b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b40:	ff 30                	pushl  (%eax)
  801b42:	e8 b9 fd ff ff       	call   801900 <dev_lookup>
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	78 27                	js     801b75 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b51:	8b 42 08             	mov    0x8(%edx),%eax
  801b54:	83 e0 03             	and    $0x3,%eax
  801b57:	83 f8 01             	cmp    $0x1,%eax
  801b5a:	74 1e                	je     801b7a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5f:	8b 40 08             	mov    0x8(%eax),%eax
  801b62:	85 c0                	test   %eax,%eax
  801b64:	74 35                	je     801b9b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	52                   	push   %edx
  801b70:	ff d0                	call   *%eax
  801b72:	83 c4 10             	add    $0x10,%esp
}
  801b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b7a:	a1 20 50 80 00       	mov    0x805020,%eax
  801b7f:	8b 40 48             	mov    0x48(%eax),%eax
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	53                   	push   %ebx
  801b86:	50                   	push   %eax
  801b87:	68 58 32 80 00       	push   $0x803258
  801b8c:	e8 e9 ec ff ff       	call   80087a <cprintf>
		return -E_INVAL;
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b99:	eb da                	jmp    801b75 <read+0x5a>
		return -E_NOT_SUPP;
  801b9b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba0:	eb d3                	jmp    801b75 <read+0x5a>

00801ba2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	57                   	push   %edi
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bae:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bb6:	39 f3                	cmp    %esi,%ebx
  801bb8:	73 25                	jae    801bdf <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	89 f0                	mov    %esi,%eax
  801bbf:	29 d8                	sub    %ebx,%eax
  801bc1:	50                   	push   %eax
  801bc2:	89 d8                	mov    %ebx,%eax
  801bc4:	03 45 0c             	add    0xc(%ebp),%eax
  801bc7:	50                   	push   %eax
  801bc8:	57                   	push   %edi
  801bc9:	e8 4d ff ff ff       	call   801b1b <read>
		if (m < 0)
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	78 08                	js     801bdd <readn+0x3b>
			return m;
		if (m == 0)
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	74 06                	je     801bdf <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801bd9:	01 c3                	add    %eax,%ebx
  801bdb:	eb d9                	jmp    801bb6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bdd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801bdf:	89 d8                	mov    %ebx,%eax
  801be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5f                   	pop    %edi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    

00801be9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	53                   	push   %ebx
  801bed:	83 ec 14             	sub    $0x14,%esp
  801bf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bf6:	50                   	push   %eax
  801bf7:	53                   	push   %ebx
  801bf8:	e8 ad fc ff ff       	call   8018aa <fd_lookup>
  801bfd:	83 c4 08             	add    $0x8,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 3a                	js     801c3e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c04:	83 ec 08             	sub    $0x8,%esp
  801c07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0a:	50                   	push   %eax
  801c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0e:	ff 30                	pushl  (%eax)
  801c10:	e8 eb fc ff ff       	call   801900 <dev_lookup>
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 22                	js     801c3e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c23:	74 1e                	je     801c43 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c28:	8b 52 0c             	mov    0xc(%edx),%edx
  801c2b:	85 d2                	test   %edx,%edx
  801c2d:	74 35                	je     801c64 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	ff 75 10             	pushl  0x10(%ebp)
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	50                   	push   %eax
  801c39:	ff d2                	call   *%edx
  801c3b:	83 c4 10             	add    $0x10,%esp
}
  801c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c43:	a1 20 50 80 00       	mov    0x805020,%eax
  801c48:	8b 40 48             	mov    0x48(%eax),%eax
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	53                   	push   %ebx
  801c4f:	50                   	push   %eax
  801c50:	68 74 32 80 00       	push   $0x803274
  801c55:	e8 20 ec ff ff       	call   80087a <cprintf>
		return -E_INVAL;
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c62:	eb da                	jmp    801c3e <write+0x55>
		return -E_NOT_SUPP;
  801c64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c69:	eb d3                	jmp    801c3e <write+0x55>

00801c6b <seek>:

int
seek(int fdnum, off_t offset)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c71:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c74:	50                   	push   %eax
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	e8 2d fc ff ff       	call   8018aa <fd_lookup>
  801c7d:	83 c4 08             	add    $0x8,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 0e                	js     801c92 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c8a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	53                   	push   %ebx
  801c98:	83 ec 14             	sub    $0x14,%esp
  801c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ca1:	50                   	push   %eax
  801ca2:	53                   	push   %ebx
  801ca3:	e8 02 fc ff ff       	call   8018aa <fd_lookup>
  801ca8:	83 c4 08             	add    $0x8,%esp
  801cab:	85 c0                	test   %eax,%eax
  801cad:	78 37                	js     801ce6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801caf:	83 ec 08             	sub    $0x8,%esp
  801cb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb5:	50                   	push   %eax
  801cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb9:	ff 30                	pushl  (%eax)
  801cbb:	e8 40 fc ff ff       	call   801900 <dev_lookup>
  801cc0:	83 c4 10             	add    $0x10,%esp
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 1f                	js     801ce6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cce:	74 1b                	je     801ceb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801cd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd3:	8b 52 18             	mov    0x18(%edx),%edx
  801cd6:	85 d2                	test   %edx,%edx
  801cd8:	74 32                	je     801d0c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cda:	83 ec 08             	sub    $0x8,%esp
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	50                   	push   %eax
  801ce1:	ff d2                	call   *%edx
  801ce3:	83 c4 10             	add    $0x10,%esp
}
  801ce6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ceb:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cf0:	8b 40 48             	mov    0x48(%eax),%eax
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	53                   	push   %ebx
  801cf7:	50                   	push   %eax
  801cf8:	68 34 32 80 00       	push   $0x803234
  801cfd:	e8 78 eb ff ff       	call   80087a <cprintf>
		return -E_INVAL;
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d0a:	eb da                	jmp    801ce6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d0c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d11:	eb d3                	jmp    801ce6 <ftruncate+0x52>

00801d13 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
  801d17:	83 ec 14             	sub    $0x14,%esp
  801d1a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d20:	50                   	push   %eax
  801d21:	ff 75 08             	pushl  0x8(%ebp)
  801d24:	e8 81 fb ff ff       	call   8018aa <fd_lookup>
  801d29:	83 c4 08             	add    $0x8,%esp
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	78 4b                	js     801d7b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d30:	83 ec 08             	sub    $0x8,%esp
  801d33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d36:	50                   	push   %eax
  801d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3a:	ff 30                	pushl  (%eax)
  801d3c:	e8 bf fb ff ff       	call   801900 <dev_lookup>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 33                	js     801d7b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d4f:	74 2f                	je     801d80 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d51:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d54:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d5b:	00 00 00 
	stat->st_isdir = 0;
  801d5e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d65:	00 00 00 
	stat->st_dev = dev;
  801d68:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d6e:	83 ec 08             	sub    $0x8,%esp
  801d71:	53                   	push   %ebx
  801d72:	ff 75 f0             	pushl  -0x10(%ebp)
  801d75:	ff 50 14             	call   *0x14(%eax)
  801d78:	83 c4 10             	add    $0x10,%esp
}
  801d7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    
		return -E_NOT_SUPP;
  801d80:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d85:	eb f4                	jmp    801d7b <fstat+0x68>

00801d87 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	56                   	push   %esi
  801d8b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d8c:	83 ec 08             	sub    $0x8,%esp
  801d8f:	6a 00                	push   $0x0
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	e8 e7 01 00 00       	call   801f80 <open>
  801d99:	89 c3                	mov    %eax,%ebx
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 1b                	js     801dbd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	50                   	push   %eax
  801da9:	e8 65 ff ff ff       	call   801d13 <fstat>
  801dae:	89 c6                	mov    %eax,%esi
	close(fd);
  801db0:	89 1c 24             	mov    %ebx,(%esp)
  801db3:	e8 27 fc ff ff       	call   8019df <close>
	return r;
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	89 f3                	mov    %esi,%ebx
}
  801dbd:	89 d8                	mov    %ebx,%eax
  801dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc2:	5b                   	pop    %ebx
  801dc3:	5e                   	pop    %esi
  801dc4:	5d                   	pop    %ebp
  801dc5:	c3                   	ret    

00801dc6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
  801dcb:	89 c6                	mov    %eax,%esi
  801dcd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801dcf:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  801dd6:	74 27                	je     801dff <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801dd8:	6a 07                	push   $0x7
  801dda:	68 00 60 80 00       	push   $0x806000
  801ddf:	56                   	push   %esi
  801de0:	ff 35 18 50 80 00    	pushl  0x805018
  801de6:	e8 bc f9 ff ff       	call   8017a7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801deb:	83 c4 0c             	add    $0xc,%esp
  801dee:	6a 00                	push   $0x0
  801df0:	53                   	push   %ebx
  801df1:	6a 00                	push   $0x0
  801df3:	e8 48 f9 ff ff       	call   801740 <ipc_recv>
}
  801df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfb:	5b                   	pop    %ebx
  801dfc:	5e                   	pop    %esi
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	6a 01                	push   $0x1
  801e04:	e8 f2 f9 ff ff       	call   8017fb <ipc_find_env>
  801e09:	a3 18 50 80 00       	mov    %eax,0x805018
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	eb c5                	jmp    801dd8 <fsipc+0x12>

00801e13 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e31:	b8 02 00 00 00       	mov    $0x2,%eax
  801e36:	e8 8b ff ff ff       	call   801dc6 <fsipc>
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <devfile_flush>:
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	8b 40 0c             	mov    0xc(%eax),%eax
  801e49:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e53:	b8 06 00 00 00       	mov    $0x6,%eax
  801e58:	e8 69 ff ff ff       	call   801dc6 <fsipc>
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <devfile_stat>:
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	53                   	push   %ebx
  801e63:	83 ec 04             	sub    $0x4,%esp
  801e66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6f:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e74:	ba 00 00 00 00       	mov    $0x0,%edx
  801e79:	b8 05 00 00 00       	mov    $0x5,%eax
  801e7e:	e8 43 ff ff ff       	call   801dc6 <fsipc>
  801e83:	85 c0                	test   %eax,%eax
  801e85:	78 2c                	js     801eb3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e87:	83 ec 08             	sub    $0x8,%esp
  801e8a:	68 00 60 80 00       	push   $0x806000
  801e8f:	53                   	push   %ebx
  801e90:	e8 04 f0 ff ff       	call   800e99 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e95:	a1 80 60 80 00       	mov    0x806080,%eax
  801e9a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ea0:	a1 84 60 80 00       	mov    0x806084,%eax
  801ea5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <devfile_write>:
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801ec6:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801ecb:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ece:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed1:	8b 52 0c             	mov    0xc(%edx),%edx
  801ed4:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801eda:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801edf:	50                   	push   %eax
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	68 08 60 80 00       	push   $0x806008
  801ee8:	e8 3a f1 ff ff       	call   801027 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801eed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef2:	b8 04 00 00 00       	mov    $0x4,%eax
  801ef7:	e8 ca fe ff ff       	call   801dc6 <fsipc>
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <devfile_read>:
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	56                   	push   %esi
  801f02:	53                   	push   %ebx
  801f03:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f11:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f17:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f21:	e8 a0 fe ff ff       	call   801dc6 <fsipc>
  801f26:	89 c3                	mov    %eax,%ebx
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 1f                	js     801f4b <devfile_read+0x4d>
	assert(r <= n);
  801f2c:	39 f0                	cmp    %esi,%eax
  801f2e:	77 24                	ja     801f54 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f30:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f35:	7f 33                	jg     801f6a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f37:	83 ec 04             	sub    $0x4,%esp
  801f3a:	50                   	push   %eax
  801f3b:	68 00 60 80 00       	push   $0x806000
  801f40:	ff 75 0c             	pushl  0xc(%ebp)
  801f43:	e8 df f0 ff ff       	call   801027 <memmove>
	return r;
  801f48:	83 c4 10             	add    $0x10,%esp
}
  801f4b:	89 d8                	mov    %ebx,%eax
  801f4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
	assert(r <= n);
  801f54:	68 a8 32 80 00       	push   $0x8032a8
  801f59:	68 af 32 80 00       	push   $0x8032af
  801f5e:	6a 7b                	push   $0x7b
  801f60:	68 c4 32 80 00       	push   $0x8032c4
  801f65:	e8 35 e8 ff ff       	call   80079f <_panic>
	assert(r <= PGSIZE);
  801f6a:	68 cf 32 80 00       	push   $0x8032cf
  801f6f:	68 af 32 80 00       	push   $0x8032af
  801f74:	6a 7c                	push   $0x7c
  801f76:	68 c4 32 80 00       	push   $0x8032c4
  801f7b:	e8 1f e8 ff ff       	call   80079f <_panic>

00801f80 <open>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	56                   	push   %esi
  801f84:	53                   	push   %ebx
  801f85:	83 ec 1c             	sub    $0x1c,%esp
  801f88:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f8b:	56                   	push   %esi
  801f8c:	e8 d1 ee ff ff       	call   800e62 <strlen>
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f99:	7f 6c                	jg     802007 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa1:	50                   	push   %eax
  801fa2:	e8 b4 f8 ff ff       	call   80185b <fd_alloc>
  801fa7:	89 c3                	mov    %eax,%ebx
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 3c                	js     801fec <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801fb0:	83 ec 08             	sub    $0x8,%esp
  801fb3:	56                   	push   %esi
  801fb4:	68 00 60 80 00       	push   $0x806000
  801fb9:	e8 db ee ff ff       	call   800e99 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fce:	e8 f3 fd ff ff       	call   801dc6 <fsipc>
  801fd3:	89 c3                	mov    %eax,%ebx
  801fd5:	83 c4 10             	add    $0x10,%esp
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	78 19                	js     801ff5 <open+0x75>
	return fd2num(fd);
  801fdc:	83 ec 0c             	sub    $0xc,%esp
  801fdf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe2:	e8 4d f8 ff ff       	call   801834 <fd2num>
  801fe7:	89 c3                	mov    %eax,%ebx
  801fe9:	83 c4 10             	add    $0x10,%esp
}
  801fec:	89 d8                	mov    %ebx,%eax
  801fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    
		fd_close(fd, 0);
  801ff5:	83 ec 08             	sub    $0x8,%esp
  801ff8:	6a 00                	push   $0x0
  801ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffd:	e8 54 f9 ff ff       	call   801956 <fd_close>
		return r;
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	eb e5                	jmp    801fec <open+0x6c>
		return -E_BAD_PATH;
  802007:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80200c:	eb de                	jmp    801fec <open+0x6c>

0080200e <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802014:	ba 00 00 00 00       	mov    $0x0,%edx
  802019:	b8 08 00 00 00       	mov    $0x8,%eax
  80201e:	e8 a3 fd ff ff       	call   801dc6 <fsipc>
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80202b:	68 db 32 80 00       	push   $0x8032db
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	e8 61 ee ff ff       	call   800e99 <strcpy>
	return 0;
}
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <devsock_close>:
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	53                   	push   %ebx
  802043:	83 ec 10             	sub    $0x10,%esp
  802046:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802049:	53                   	push   %ebx
  80204a:	e8 90 09 00 00       	call   8029df <pageref>
  80204f:	83 c4 10             	add    $0x10,%esp
		return 0;
  802052:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802057:	83 f8 01             	cmp    $0x1,%eax
  80205a:	74 07                	je     802063 <devsock_close+0x24>
}
  80205c:	89 d0                	mov    %edx,%eax
  80205e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802061:	c9                   	leave  
  802062:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802063:	83 ec 0c             	sub    $0xc,%esp
  802066:	ff 73 0c             	pushl  0xc(%ebx)
  802069:	e8 b7 02 00 00       	call   802325 <nsipc_close>
  80206e:	89 c2                	mov    %eax,%edx
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	eb e7                	jmp    80205c <devsock_close+0x1d>

00802075 <devsock_write>:
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80207b:	6a 00                	push   $0x0
  80207d:	ff 75 10             	pushl  0x10(%ebp)
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	ff 70 0c             	pushl  0xc(%eax)
  802089:	e8 74 03 00 00       	call   802402 <nsipc_send>
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_read>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802096:	6a 00                	push   $0x0
  802098:	ff 75 10             	pushl  0x10(%ebp)
  80209b:	ff 75 0c             	pushl  0xc(%ebp)
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	ff 70 0c             	pushl  0xc(%eax)
  8020a4:	e8 ed 02 00 00       	call   802396 <nsipc_recv>
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <fd2sockid>:
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020b1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020b4:	52                   	push   %edx
  8020b5:	50                   	push   %eax
  8020b6:	e8 ef f7 ff ff       	call   8018aa <fd_lookup>
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	78 10                	js     8020d2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020cb:	39 08                	cmp    %ecx,(%eax)
  8020cd:	75 05                	jne    8020d4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020cf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8020d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020d9:	eb f7                	jmp    8020d2 <fd2sockid+0x27>

008020db <alloc_sockfd>:
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	56                   	push   %esi
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 1c             	sub    $0x1c,%esp
  8020e3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e8:	50                   	push   %eax
  8020e9:	e8 6d f7 ff ff       	call   80185b <fd_alloc>
  8020ee:	89 c3                	mov    %eax,%ebx
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 43                	js     80213a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 07 04 00 00       	push   $0x407
  8020ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802102:	6a 00                	push   $0x0
  802104:	e8 89 f1 ff ff       	call   801292 <sys_page_alloc>
  802109:	89 c3                	mov    %eax,%ebx
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 28                	js     80213a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80211b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802127:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80212a:	83 ec 0c             	sub    $0xc,%esp
  80212d:	50                   	push   %eax
  80212e:	e8 01 f7 ff ff       	call   801834 <fd2num>
  802133:	89 c3                	mov    %eax,%ebx
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	eb 0c                	jmp    802146 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	56                   	push   %esi
  80213e:	e8 e2 01 00 00       	call   802325 <nsipc_close>
		return r;
  802143:	83 c4 10             	add    $0x10,%esp
}
  802146:	89 d8                	mov    %ebx,%eax
  802148:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80214b:	5b                   	pop    %ebx
  80214c:	5e                   	pop    %esi
  80214d:	5d                   	pop    %ebp
  80214e:	c3                   	ret    

0080214f <accept>:
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	e8 4e ff ff ff       	call   8020ab <fd2sockid>
  80215d:	85 c0                	test   %eax,%eax
  80215f:	78 1b                	js     80217c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	ff 75 10             	pushl  0x10(%ebp)
  802167:	ff 75 0c             	pushl  0xc(%ebp)
  80216a:	50                   	push   %eax
  80216b:	e8 0e 01 00 00       	call   80227e <nsipc_accept>
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	85 c0                	test   %eax,%eax
  802175:	78 05                	js     80217c <accept+0x2d>
	return alloc_sockfd(r);
  802177:	e8 5f ff ff ff       	call   8020db <alloc_sockfd>
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <bind>:
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	e8 1f ff ff ff       	call   8020ab <fd2sockid>
  80218c:	85 c0                	test   %eax,%eax
  80218e:	78 12                	js     8021a2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	ff 75 10             	pushl  0x10(%ebp)
  802196:	ff 75 0c             	pushl  0xc(%ebp)
  802199:	50                   	push   %eax
  80219a:	e8 2f 01 00 00       	call   8022ce <nsipc_bind>
  80219f:	83 c4 10             	add    $0x10,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <shutdown>:
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	e8 f9 fe ff ff       	call   8020ab <fd2sockid>
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 0f                	js     8021c5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021b6:	83 ec 08             	sub    $0x8,%esp
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	50                   	push   %eax
  8021bd:	e8 41 01 00 00       	call   802303 <nsipc_shutdown>
  8021c2:	83 c4 10             	add    $0x10,%esp
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <connect>:
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	e8 d6 fe ff ff       	call   8020ab <fd2sockid>
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 12                	js     8021eb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	ff 75 10             	pushl  0x10(%ebp)
  8021df:	ff 75 0c             	pushl  0xc(%ebp)
  8021e2:	50                   	push   %eax
  8021e3:	e8 57 01 00 00       	call   80233f <nsipc_connect>
  8021e8:	83 c4 10             	add    $0x10,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <listen>:
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	e8 b0 fe ff ff       	call   8020ab <fd2sockid>
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 0f                	js     80220e <listen+0x21>
	return nsipc_listen(r, backlog);
  8021ff:	83 ec 08             	sub    $0x8,%esp
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	50                   	push   %eax
  802206:	e8 69 01 00 00       	call   802374 <nsipc_listen>
  80220b:	83 c4 10             	add    $0x10,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <socket>:

int
socket(int domain, int type, int protocol)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802216:	ff 75 10             	pushl  0x10(%ebp)
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	e8 3c 02 00 00       	call   802460 <nsipc_socket>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	85 c0                	test   %eax,%eax
  802229:	78 05                	js     802230 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80222b:	e8 ab fe ff ff       	call   8020db <alloc_sockfd>
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	53                   	push   %ebx
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80223b:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  802242:	74 26                	je     80226a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802244:	6a 07                	push   $0x7
  802246:	68 00 70 80 00       	push   $0x807000
  80224b:	53                   	push   %ebx
  80224c:	ff 35 1c 50 80 00    	pushl  0x80501c
  802252:	e8 50 f5 ff ff       	call   8017a7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802257:	83 c4 0c             	add    $0xc,%esp
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	e8 db f4 ff ff       	call   801740 <ipc_recv>
}
  802265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802268:	c9                   	leave  
  802269:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80226a:	83 ec 0c             	sub    $0xc,%esp
  80226d:	6a 02                	push   $0x2
  80226f:	e8 87 f5 ff ff       	call   8017fb <ipc_find_env>
  802274:	a3 1c 50 80 00       	mov    %eax,0x80501c
  802279:	83 c4 10             	add    $0x10,%esp
  80227c:	eb c6                	jmp    802244 <nsipc+0x12>

0080227e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	56                   	push   %esi
  802282:	53                   	push   %ebx
  802283:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80228e:	8b 06                	mov    (%esi),%eax
  802290:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802295:	b8 01 00 00 00       	mov    $0x1,%eax
  80229a:	e8 93 ff ff ff       	call   802232 <nsipc>
  80229f:	89 c3                	mov    %eax,%ebx
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	78 20                	js     8022c5 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022a5:	83 ec 04             	sub    $0x4,%esp
  8022a8:	ff 35 10 70 80 00    	pushl  0x807010
  8022ae:	68 00 70 80 00       	push   $0x807000
  8022b3:	ff 75 0c             	pushl  0xc(%ebp)
  8022b6:	e8 6c ed ff ff       	call   801027 <memmove>
		*addrlen = ret->ret_addrlen;
  8022bb:	a1 10 70 80 00       	mov    0x807010,%eax
  8022c0:	89 06                	mov    %eax,(%esi)
  8022c2:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8022c5:	89 d8                	mov    %ebx,%eax
  8022c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ca:	5b                   	pop    %ebx
  8022cb:	5e                   	pop    %esi
  8022cc:	5d                   	pop    %ebp
  8022cd:	c3                   	ret    

008022ce <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	53                   	push   %ebx
  8022d2:	83 ec 08             	sub    $0x8,%esp
  8022d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022e0:	53                   	push   %ebx
  8022e1:	ff 75 0c             	pushl  0xc(%ebp)
  8022e4:	68 04 70 80 00       	push   $0x807004
  8022e9:	e8 39 ed ff ff       	call   801027 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022ee:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022f4:	b8 02 00 00 00       	mov    $0x2,%eax
  8022f9:	e8 34 ff ff ff       	call   802232 <nsipc>
}
  8022fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802311:	8b 45 0c             	mov    0xc(%ebp),%eax
  802314:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802319:	b8 03 00 00 00       	mov    $0x3,%eax
  80231e:	e8 0f ff ff ff       	call   802232 <nsipc>
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <nsipc_close>:

int
nsipc_close(int s)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802333:	b8 04 00 00 00       	mov    $0x4,%eax
  802338:	e8 f5 fe ff ff       	call   802232 <nsipc>
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	53                   	push   %ebx
  802343:	83 ec 08             	sub    $0x8,%esp
  802346:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802351:	53                   	push   %ebx
  802352:	ff 75 0c             	pushl  0xc(%ebp)
  802355:	68 04 70 80 00       	push   $0x807004
  80235a:	e8 c8 ec ff ff       	call   801027 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80235f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802365:	b8 05 00 00 00       	mov    $0x5,%eax
  80236a:	e8 c3 fe ff ff       	call   802232 <nsipc>
}
  80236f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802382:	8b 45 0c             	mov    0xc(%ebp),%eax
  802385:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80238a:	b8 06 00 00 00       	mov    $0x6,%eax
  80238f:	e8 9e fe ff ff       	call   802232 <nsipc>
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	56                   	push   %esi
  80239a:	53                   	push   %ebx
  80239b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023a6:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8023af:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023b4:	b8 07 00 00 00       	mov    $0x7,%eax
  8023b9:	e8 74 fe ff ff       	call   802232 <nsipc>
  8023be:	89 c3                	mov    %eax,%ebx
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	78 1f                	js     8023e3 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023c4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023c9:	7f 21                	jg     8023ec <nsipc_recv+0x56>
  8023cb:	39 c6                	cmp    %eax,%esi
  8023cd:	7c 1d                	jl     8023ec <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023cf:	83 ec 04             	sub    $0x4,%esp
  8023d2:	50                   	push   %eax
  8023d3:	68 00 70 80 00       	push   $0x807000
  8023d8:	ff 75 0c             	pushl  0xc(%ebp)
  8023db:	e8 47 ec ff ff       	call   801027 <memmove>
  8023e0:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023e3:	89 d8                	mov    %ebx,%eax
  8023e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e8:	5b                   	pop    %ebx
  8023e9:	5e                   	pop    %esi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023ec:	68 e7 32 80 00       	push   $0x8032e7
  8023f1:	68 af 32 80 00       	push   $0x8032af
  8023f6:	6a 62                	push   $0x62
  8023f8:	68 fc 32 80 00       	push   $0x8032fc
  8023fd:	e8 9d e3 ff ff       	call   80079f <_panic>

00802402 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	53                   	push   %ebx
  802406:	83 ec 04             	sub    $0x4,%esp
  802409:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802414:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80241a:	7f 2e                	jg     80244a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80241c:	83 ec 04             	sub    $0x4,%esp
  80241f:	53                   	push   %ebx
  802420:	ff 75 0c             	pushl  0xc(%ebp)
  802423:	68 0c 70 80 00       	push   $0x80700c
  802428:	e8 fa eb ff ff       	call   801027 <memmove>
	nsipcbuf.send.req_size = size;
  80242d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802433:	8b 45 14             	mov    0x14(%ebp),%eax
  802436:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80243b:	b8 08 00 00 00       	mov    $0x8,%eax
  802440:	e8 ed fd ff ff       	call   802232 <nsipc>
}
  802445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802448:	c9                   	leave  
  802449:	c3                   	ret    
	assert(size < 1600);
  80244a:	68 08 33 80 00       	push   $0x803308
  80244f:	68 af 32 80 00       	push   $0x8032af
  802454:	6a 6d                	push   $0x6d
  802456:	68 fc 32 80 00       	push   $0x8032fc
  80245b:	e8 3f e3 ff ff       	call   80079f <_panic>

00802460 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80246e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802471:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802476:	8b 45 10             	mov    0x10(%ebp),%eax
  802479:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80247e:	b8 09 00 00 00       	mov    $0x9,%eax
  802483:	e8 aa fd ff ff       	call   802232 <nsipc>
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	56                   	push   %esi
  80248e:	53                   	push   %ebx
  80248f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802492:	83 ec 0c             	sub    $0xc,%esp
  802495:	ff 75 08             	pushl  0x8(%ebp)
  802498:	e8 a7 f3 ff ff       	call   801844 <fd2data>
  80249d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80249f:	83 c4 08             	add    $0x8,%esp
  8024a2:	68 14 33 80 00       	push   $0x803314
  8024a7:	53                   	push   %ebx
  8024a8:	e8 ec e9 ff ff       	call   800e99 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024ad:	8b 46 04             	mov    0x4(%esi),%eax
  8024b0:	2b 06                	sub    (%esi),%eax
  8024b2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024b8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024bf:	00 00 00 
	stat->st_dev = &devpipe;
  8024c2:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8024c9:	40 80 00 
	return 0;
}
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d4:	5b                   	pop    %ebx
  8024d5:	5e                   	pop    %esi
  8024d6:	5d                   	pop    %ebp
  8024d7:	c3                   	ret    

008024d8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	53                   	push   %ebx
  8024dc:	83 ec 0c             	sub    $0xc,%esp
  8024df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024e2:	53                   	push   %ebx
  8024e3:	6a 00                	push   $0x0
  8024e5:	e8 2d ee ff ff       	call   801317 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024ea:	89 1c 24             	mov    %ebx,(%esp)
  8024ed:	e8 52 f3 ff ff       	call   801844 <fd2data>
  8024f2:	83 c4 08             	add    $0x8,%esp
  8024f5:	50                   	push   %eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	e8 1a ee ff ff       	call   801317 <sys_page_unmap>
}
  8024fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <_pipeisclosed>:
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
  802505:	57                   	push   %edi
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
  802508:	83 ec 1c             	sub    $0x1c,%esp
  80250b:	89 c7                	mov    %eax,%edi
  80250d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80250f:	a1 20 50 80 00       	mov    0x805020,%eax
  802514:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802517:	83 ec 0c             	sub    $0xc,%esp
  80251a:	57                   	push   %edi
  80251b:	e8 bf 04 00 00       	call   8029df <pageref>
  802520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802523:	89 34 24             	mov    %esi,(%esp)
  802526:	e8 b4 04 00 00       	call   8029df <pageref>
		nn = thisenv->env_runs;
  80252b:	8b 15 20 50 80 00    	mov    0x805020,%edx
  802531:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	39 cb                	cmp    %ecx,%ebx
  802539:	74 1b                	je     802556 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80253b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80253e:	75 cf                	jne    80250f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802540:	8b 42 58             	mov    0x58(%edx),%eax
  802543:	6a 01                	push   $0x1
  802545:	50                   	push   %eax
  802546:	53                   	push   %ebx
  802547:	68 1b 33 80 00       	push   $0x80331b
  80254c:	e8 29 e3 ff ff       	call   80087a <cprintf>
  802551:	83 c4 10             	add    $0x10,%esp
  802554:	eb b9                	jmp    80250f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802556:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802559:	0f 94 c0             	sete   %al
  80255c:	0f b6 c0             	movzbl %al,%eax
}
  80255f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802562:	5b                   	pop    %ebx
  802563:	5e                   	pop    %esi
  802564:	5f                   	pop    %edi
  802565:	5d                   	pop    %ebp
  802566:	c3                   	ret    

00802567 <devpipe_write>:
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	57                   	push   %edi
  80256b:	56                   	push   %esi
  80256c:	53                   	push   %ebx
  80256d:	83 ec 28             	sub    $0x28,%esp
  802570:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802573:	56                   	push   %esi
  802574:	e8 cb f2 ff ff       	call   801844 <fd2data>
  802579:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80257b:	83 c4 10             	add    $0x10,%esp
  80257e:	bf 00 00 00 00       	mov    $0x0,%edi
  802583:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802586:	74 4f                	je     8025d7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802588:	8b 43 04             	mov    0x4(%ebx),%eax
  80258b:	8b 0b                	mov    (%ebx),%ecx
  80258d:	8d 51 20             	lea    0x20(%ecx),%edx
  802590:	39 d0                	cmp    %edx,%eax
  802592:	72 14                	jb     8025a8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802594:	89 da                	mov    %ebx,%edx
  802596:	89 f0                	mov    %esi,%eax
  802598:	e8 65 ff ff ff       	call   802502 <_pipeisclosed>
  80259d:	85 c0                	test   %eax,%eax
  80259f:	75 3a                	jne    8025db <devpipe_write+0x74>
			sys_yield();
  8025a1:	e8 cd ec ff ff       	call   801273 <sys_yield>
  8025a6:	eb e0                	jmp    802588 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ab:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025af:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025b2:	89 c2                	mov    %eax,%edx
  8025b4:	c1 fa 1f             	sar    $0x1f,%edx
  8025b7:	89 d1                	mov    %edx,%ecx
  8025b9:	c1 e9 1b             	shr    $0x1b,%ecx
  8025bc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025bf:	83 e2 1f             	and    $0x1f,%edx
  8025c2:	29 ca                	sub    %ecx,%edx
  8025c4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025c8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025cc:	83 c0 01             	add    $0x1,%eax
  8025cf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025d2:	83 c7 01             	add    $0x1,%edi
  8025d5:	eb ac                	jmp    802583 <devpipe_write+0x1c>
	return i;
  8025d7:	89 f8                	mov    %edi,%eax
  8025d9:	eb 05                	jmp    8025e0 <devpipe_write+0x79>
				return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025e3:	5b                   	pop    %ebx
  8025e4:	5e                   	pop    %esi
  8025e5:	5f                   	pop    %edi
  8025e6:	5d                   	pop    %ebp
  8025e7:	c3                   	ret    

008025e8 <devpipe_read>:
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
  8025eb:	57                   	push   %edi
  8025ec:	56                   	push   %esi
  8025ed:	53                   	push   %ebx
  8025ee:	83 ec 18             	sub    $0x18,%esp
  8025f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025f4:	57                   	push   %edi
  8025f5:	e8 4a f2 ff ff       	call   801844 <fd2data>
  8025fa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025fc:	83 c4 10             	add    $0x10,%esp
  8025ff:	be 00 00 00 00       	mov    $0x0,%esi
  802604:	3b 75 10             	cmp    0x10(%ebp),%esi
  802607:	74 47                	je     802650 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802609:	8b 03                	mov    (%ebx),%eax
  80260b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80260e:	75 22                	jne    802632 <devpipe_read+0x4a>
			if (i > 0)
  802610:	85 f6                	test   %esi,%esi
  802612:	75 14                	jne    802628 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802614:	89 da                	mov    %ebx,%edx
  802616:	89 f8                	mov    %edi,%eax
  802618:	e8 e5 fe ff ff       	call   802502 <_pipeisclosed>
  80261d:	85 c0                	test   %eax,%eax
  80261f:	75 33                	jne    802654 <devpipe_read+0x6c>
			sys_yield();
  802621:	e8 4d ec ff ff       	call   801273 <sys_yield>
  802626:	eb e1                	jmp    802609 <devpipe_read+0x21>
				return i;
  802628:	89 f0                	mov    %esi,%eax
}
  80262a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5e                   	pop    %esi
  80262f:	5f                   	pop    %edi
  802630:	5d                   	pop    %ebp
  802631:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802632:	99                   	cltd   
  802633:	c1 ea 1b             	shr    $0x1b,%edx
  802636:	01 d0                	add    %edx,%eax
  802638:	83 e0 1f             	and    $0x1f,%eax
  80263b:	29 d0                	sub    %edx,%eax
  80263d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802642:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802645:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802648:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80264b:	83 c6 01             	add    $0x1,%esi
  80264e:	eb b4                	jmp    802604 <devpipe_read+0x1c>
	return i;
  802650:	89 f0                	mov    %esi,%eax
  802652:	eb d6                	jmp    80262a <devpipe_read+0x42>
				return 0;
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
  802659:	eb cf                	jmp    80262a <devpipe_read+0x42>

0080265b <pipe>:
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	56                   	push   %esi
  80265f:	53                   	push   %ebx
  802660:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802663:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802666:	50                   	push   %eax
  802667:	e8 ef f1 ff ff       	call   80185b <fd_alloc>
  80266c:	89 c3                	mov    %eax,%ebx
  80266e:	83 c4 10             	add    $0x10,%esp
  802671:	85 c0                	test   %eax,%eax
  802673:	78 5b                	js     8026d0 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 07 04 00 00       	push   $0x407
  80267d:	ff 75 f4             	pushl  -0xc(%ebp)
  802680:	6a 00                	push   $0x0
  802682:	e8 0b ec ff ff       	call   801292 <sys_page_alloc>
  802687:	89 c3                	mov    %eax,%ebx
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	85 c0                	test   %eax,%eax
  80268e:	78 40                	js     8026d0 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802690:	83 ec 0c             	sub    $0xc,%esp
  802693:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802696:	50                   	push   %eax
  802697:	e8 bf f1 ff ff       	call   80185b <fd_alloc>
  80269c:	89 c3                	mov    %eax,%ebx
  80269e:	83 c4 10             	add    $0x10,%esp
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	78 1b                	js     8026c0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 07 04 00 00       	push   $0x407
  8026ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b0:	6a 00                	push   $0x0
  8026b2:	e8 db eb ff ff       	call   801292 <sys_page_alloc>
  8026b7:	89 c3                	mov    %eax,%ebx
  8026b9:	83 c4 10             	add    $0x10,%esp
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	79 19                	jns    8026d9 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8026c0:	83 ec 08             	sub    $0x8,%esp
  8026c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c6:	6a 00                	push   $0x0
  8026c8:	e8 4a ec ff ff       	call   801317 <sys_page_unmap>
  8026cd:	83 c4 10             	add    $0x10,%esp
}
  8026d0:	89 d8                	mov    %ebx,%eax
  8026d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026d5:	5b                   	pop    %ebx
  8026d6:	5e                   	pop    %esi
  8026d7:	5d                   	pop    %ebp
  8026d8:	c3                   	ret    
	va = fd2data(fd0);
  8026d9:	83 ec 0c             	sub    $0xc,%esp
  8026dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026df:	e8 60 f1 ff ff       	call   801844 <fd2data>
  8026e4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e6:	83 c4 0c             	add    $0xc,%esp
  8026e9:	68 07 04 00 00       	push   $0x407
  8026ee:	50                   	push   %eax
  8026ef:	6a 00                	push   $0x0
  8026f1:	e8 9c eb ff ff       	call   801292 <sys_page_alloc>
  8026f6:	89 c3                	mov    %eax,%ebx
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	0f 88 8c 00 00 00    	js     80278f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802703:	83 ec 0c             	sub    $0xc,%esp
  802706:	ff 75 f0             	pushl  -0x10(%ebp)
  802709:	e8 36 f1 ff ff       	call   801844 <fd2data>
  80270e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802715:	50                   	push   %eax
  802716:	6a 00                	push   $0x0
  802718:	56                   	push   %esi
  802719:	6a 00                	push   $0x0
  80271b:	e8 b5 eb ff ff       	call   8012d5 <sys_page_map>
  802720:	89 c3                	mov    %eax,%ebx
  802722:	83 c4 20             	add    $0x20,%esp
  802725:	85 c0                	test   %eax,%eax
  802727:	78 58                	js     802781 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802732:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802747:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802753:	83 ec 0c             	sub    $0xc,%esp
  802756:	ff 75 f4             	pushl  -0xc(%ebp)
  802759:	e8 d6 f0 ff ff       	call   801834 <fd2num>
  80275e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802761:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802763:	83 c4 04             	add    $0x4,%esp
  802766:	ff 75 f0             	pushl  -0x10(%ebp)
  802769:	e8 c6 f0 ff ff       	call   801834 <fd2num>
  80276e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802771:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802774:	83 c4 10             	add    $0x10,%esp
  802777:	bb 00 00 00 00       	mov    $0x0,%ebx
  80277c:	e9 4f ff ff ff       	jmp    8026d0 <pipe+0x75>
	sys_page_unmap(0, va);
  802781:	83 ec 08             	sub    $0x8,%esp
  802784:	56                   	push   %esi
  802785:	6a 00                	push   $0x0
  802787:	e8 8b eb ff ff       	call   801317 <sys_page_unmap>
  80278c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80278f:	83 ec 08             	sub    $0x8,%esp
  802792:	ff 75 f0             	pushl  -0x10(%ebp)
  802795:	6a 00                	push   $0x0
  802797:	e8 7b eb ff ff       	call   801317 <sys_page_unmap>
  80279c:	83 c4 10             	add    $0x10,%esp
  80279f:	e9 1c ff ff ff       	jmp    8026c0 <pipe+0x65>

008027a4 <pipeisclosed>:
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
  8027a7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ad:	50                   	push   %eax
  8027ae:	ff 75 08             	pushl  0x8(%ebp)
  8027b1:	e8 f4 f0 ff ff       	call   8018aa <fd_lookup>
  8027b6:	83 c4 10             	add    $0x10,%esp
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	78 18                	js     8027d5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027bd:	83 ec 0c             	sub    $0xc,%esp
  8027c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c3:	e8 7c f0 ff ff       	call   801844 <fd2data>
	return _pipeisclosed(fd, p);
  8027c8:	89 c2                	mov    %eax,%edx
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	e8 30 fd ff ff       	call   802502 <_pipeisclosed>
  8027d2:	83 c4 10             	add    $0x10,%esp
}
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
  8027df:	5d                   	pop    %ebp
  8027e0:	c3                   	ret    

008027e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027e7:	68 33 33 80 00       	push   $0x803333
  8027ec:	ff 75 0c             	pushl  0xc(%ebp)
  8027ef:	e8 a5 e6 ff ff       	call   800e99 <strcpy>
	return 0;
}
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <devcons_write>:
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	57                   	push   %edi
  8027ff:	56                   	push   %esi
  802800:	53                   	push   %ebx
  802801:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802807:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80280c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802812:	eb 2f                	jmp    802843 <devcons_write+0x48>
		m = n - tot;
  802814:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802817:	29 f3                	sub    %esi,%ebx
  802819:	83 fb 7f             	cmp    $0x7f,%ebx
  80281c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802821:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	53                   	push   %ebx
  802828:	89 f0                	mov    %esi,%eax
  80282a:	03 45 0c             	add    0xc(%ebp),%eax
  80282d:	50                   	push   %eax
  80282e:	57                   	push   %edi
  80282f:	e8 f3 e7 ff ff       	call   801027 <memmove>
		sys_cputs(buf, m);
  802834:	83 c4 08             	add    $0x8,%esp
  802837:	53                   	push   %ebx
  802838:	57                   	push   %edi
  802839:	e8 98 e9 ff ff       	call   8011d6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80283e:	01 de                	add    %ebx,%esi
  802840:	83 c4 10             	add    $0x10,%esp
  802843:	3b 75 10             	cmp    0x10(%ebp),%esi
  802846:	72 cc                	jb     802814 <devcons_write+0x19>
}
  802848:	89 f0                	mov    %esi,%eax
  80284a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80284d:	5b                   	pop    %ebx
  80284e:	5e                   	pop    %esi
  80284f:	5f                   	pop    %edi
  802850:	5d                   	pop    %ebp
  802851:	c3                   	ret    

00802852 <devcons_read>:
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	83 ec 08             	sub    $0x8,%esp
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80285d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802861:	75 07                	jne    80286a <devcons_read+0x18>
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    
		sys_yield();
  802865:	e8 09 ea ff ff       	call   801273 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80286a:	e8 85 e9 ff ff       	call   8011f4 <sys_cgetc>
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 f2                	je     802865 <devcons_read+0x13>
	if (c < 0)
  802873:	85 c0                	test   %eax,%eax
  802875:	78 ec                	js     802863 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802877:	83 f8 04             	cmp    $0x4,%eax
  80287a:	74 0c                	je     802888 <devcons_read+0x36>
	*(char*)vbuf = c;
  80287c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287f:	88 02                	mov    %al,(%edx)
	return 1;
  802881:	b8 01 00 00 00       	mov    $0x1,%eax
  802886:	eb db                	jmp    802863 <devcons_read+0x11>
		return 0;
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
  80288d:	eb d4                	jmp    802863 <devcons_read+0x11>

0080288f <cputchar>:
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80289b:	6a 01                	push   $0x1
  80289d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028a0:	50                   	push   %eax
  8028a1:	e8 30 e9 ff ff       	call   8011d6 <sys_cputs>
}
  8028a6:	83 c4 10             	add    $0x10,%esp
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <getchar>:
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028b1:	6a 01                	push   $0x1
  8028b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028b6:	50                   	push   %eax
  8028b7:	6a 00                	push   $0x0
  8028b9:	e8 5d f2 ff ff       	call   801b1b <read>
	if (r < 0)
  8028be:	83 c4 10             	add    $0x10,%esp
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	78 08                	js     8028cd <getchar+0x22>
	if (r < 1)
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	7e 06                	jle    8028cf <getchar+0x24>
	return c;
  8028c9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    
		return -E_EOF;
  8028cf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028d4:	eb f7                	jmp    8028cd <getchar+0x22>

008028d6 <iscons>:
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
  8028d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028df:	50                   	push   %eax
  8028e0:	ff 75 08             	pushl  0x8(%ebp)
  8028e3:	e8 c2 ef ff ff       	call   8018aa <fd_lookup>
  8028e8:	83 c4 10             	add    $0x10,%esp
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	78 11                	js     802900 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028f8:	39 10                	cmp    %edx,(%eax)
  8028fa:	0f 94 c0             	sete   %al
  8028fd:	0f b6 c0             	movzbl %al,%eax
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <opencons>:
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802908:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80290b:	50                   	push   %eax
  80290c:	e8 4a ef ff ff       	call   80185b <fd_alloc>
  802911:	83 c4 10             	add    $0x10,%esp
  802914:	85 c0                	test   %eax,%eax
  802916:	78 3a                	js     802952 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 07 04 00 00       	push   $0x407
  802920:	ff 75 f4             	pushl  -0xc(%ebp)
  802923:	6a 00                	push   $0x0
  802925:	e8 68 e9 ff ff       	call   801292 <sys_page_alloc>
  80292a:	83 c4 10             	add    $0x10,%esp
  80292d:	85 c0                	test   %eax,%eax
  80292f:	78 21                	js     802952 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80293a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802946:	83 ec 0c             	sub    $0xc,%esp
  802949:	50                   	push   %eax
  80294a:	e8 e5 ee ff ff       	call   801834 <fd2num>
  80294f:	83 c4 10             	add    $0x10,%esp
}
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
  802957:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  80295a:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802961:	74 0a                	je     80296d <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80296b:	c9                   	leave  
  80296c:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  80296d:	a1 20 50 80 00       	mov    0x805020,%eax
  802972:	8b 40 48             	mov    0x48(%eax),%eax
  802975:	83 ec 04             	sub    $0x4,%esp
  802978:	6a 07                	push   $0x7
  80297a:	68 00 f0 bf ee       	push   $0xeebff000
  80297f:	50                   	push   %eax
  802980:	e8 0d e9 ff ff       	call   801292 <sys_page_alloc>
  802985:	83 c4 10             	add    $0x10,%esp
  802988:	85 c0                	test   %eax,%eax
  80298a:	78 1b                	js     8029a7 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80298c:	a1 20 50 80 00       	mov    0x805020,%eax
  802991:	8b 40 48             	mov    0x48(%eax),%eax
  802994:	83 ec 08             	sub    $0x8,%esp
  802997:	68 b9 29 80 00       	push   $0x8029b9
  80299c:	50                   	push   %eax
  80299d:	e8 3b ea ff ff       	call   8013dd <sys_env_set_pgfault_upcall>
  8029a2:	83 c4 10             	add    $0x10,%esp
  8029a5:	eb bc                	jmp    802963 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  8029a7:	50                   	push   %eax
  8029a8:	68 3f 33 80 00       	push   $0x80333f
  8029ad:	6a 22                	push   $0x22
  8029af:	68 57 33 80 00       	push   $0x803357
  8029b4:	e8 e6 dd ff ff       	call   80079f <_panic>

008029b9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029b9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029ba:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029bf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029c1:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8029c4:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8029c8:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8029cb:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8029cf:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8029d3:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8029d5:	83 c4 08             	add    $0x8,%esp
	popal
  8029d8:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8029d9:	83 c4 04             	add    $0x4,%esp
	popfl
  8029dc:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029dd:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029de:	c3                   	ret    

008029df <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029e5:	89 d0                	mov    %edx,%eax
  8029e7:	c1 e8 16             	shr    $0x16,%eax
  8029ea:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029f1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029f6:	f6 c1 01             	test   $0x1,%cl
  8029f9:	74 1d                	je     802a18 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029fb:	c1 ea 0c             	shr    $0xc,%edx
  8029fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a05:	f6 c2 01             	test   $0x1,%dl
  802a08:	74 0e                	je     802a18 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a0a:	c1 ea 0c             	shr    $0xc,%edx
  802a0d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a14:	ef 
  802a15:	0f b7 c0             	movzwl %ax,%eax
}
  802a18:	5d                   	pop    %ebp
  802a19:	c3                   	ret    
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	66 90                	xchg   %ax,%ax
  802a1e:	66 90                	xchg   %ax,%ax

00802a20 <__udivdi3>:
  802a20:	55                   	push   %ebp
  802a21:	57                   	push   %edi
  802a22:	56                   	push   %esi
  802a23:	53                   	push   %ebx
  802a24:	83 ec 1c             	sub    $0x1c,%esp
  802a27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a37:	85 d2                	test   %edx,%edx
  802a39:	75 35                	jne    802a70 <__udivdi3+0x50>
  802a3b:	39 f3                	cmp    %esi,%ebx
  802a3d:	0f 87 bd 00 00 00    	ja     802b00 <__udivdi3+0xe0>
  802a43:	85 db                	test   %ebx,%ebx
  802a45:	89 d9                	mov    %ebx,%ecx
  802a47:	75 0b                	jne    802a54 <__udivdi3+0x34>
  802a49:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4e:	31 d2                	xor    %edx,%edx
  802a50:	f7 f3                	div    %ebx
  802a52:	89 c1                	mov    %eax,%ecx
  802a54:	31 d2                	xor    %edx,%edx
  802a56:	89 f0                	mov    %esi,%eax
  802a58:	f7 f1                	div    %ecx
  802a5a:	89 c6                	mov    %eax,%esi
  802a5c:	89 e8                	mov    %ebp,%eax
  802a5e:	89 f7                	mov    %esi,%edi
  802a60:	f7 f1                	div    %ecx
  802a62:	89 fa                	mov    %edi,%edx
  802a64:	83 c4 1c             	add    $0x1c,%esp
  802a67:	5b                   	pop    %ebx
  802a68:	5e                   	pop    %esi
  802a69:	5f                   	pop    %edi
  802a6a:	5d                   	pop    %ebp
  802a6b:	c3                   	ret    
  802a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a70:	39 f2                	cmp    %esi,%edx
  802a72:	77 7c                	ja     802af0 <__udivdi3+0xd0>
  802a74:	0f bd fa             	bsr    %edx,%edi
  802a77:	83 f7 1f             	xor    $0x1f,%edi
  802a7a:	0f 84 98 00 00 00    	je     802b18 <__udivdi3+0xf8>
  802a80:	89 f9                	mov    %edi,%ecx
  802a82:	b8 20 00 00 00       	mov    $0x20,%eax
  802a87:	29 f8                	sub    %edi,%eax
  802a89:	d3 e2                	shl    %cl,%edx
  802a8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a8f:	89 c1                	mov    %eax,%ecx
  802a91:	89 da                	mov    %ebx,%edx
  802a93:	d3 ea                	shr    %cl,%edx
  802a95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a99:	09 d1                	or     %edx,%ecx
  802a9b:	89 f2                	mov    %esi,%edx
  802a9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aa1:	89 f9                	mov    %edi,%ecx
  802aa3:	d3 e3                	shl    %cl,%ebx
  802aa5:	89 c1                	mov    %eax,%ecx
  802aa7:	d3 ea                	shr    %cl,%edx
  802aa9:	89 f9                	mov    %edi,%ecx
  802aab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802aaf:	d3 e6                	shl    %cl,%esi
  802ab1:	89 eb                	mov    %ebp,%ebx
  802ab3:	89 c1                	mov    %eax,%ecx
  802ab5:	d3 eb                	shr    %cl,%ebx
  802ab7:	09 de                	or     %ebx,%esi
  802ab9:	89 f0                	mov    %esi,%eax
  802abb:	f7 74 24 08          	divl   0x8(%esp)
  802abf:	89 d6                	mov    %edx,%esi
  802ac1:	89 c3                	mov    %eax,%ebx
  802ac3:	f7 64 24 0c          	mull   0xc(%esp)
  802ac7:	39 d6                	cmp    %edx,%esi
  802ac9:	72 0c                	jb     802ad7 <__udivdi3+0xb7>
  802acb:	89 f9                	mov    %edi,%ecx
  802acd:	d3 e5                	shl    %cl,%ebp
  802acf:	39 c5                	cmp    %eax,%ebp
  802ad1:	73 5d                	jae    802b30 <__udivdi3+0x110>
  802ad3:	39 d6                	cmp    %edx,%esi
  802ad5:	75 59                	jne    802b30 <__udivdi3+0x110>
  802ad7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ada:	31 ff                	xor    %edi,%edi
  802adc:	89 fa                	mov    %edi,%edx
  802ade:	83 c4 1c             	add    $0x1c,%esp
  802ae1:	5b                   	pop    %ebx
  802ae2:	5e                   	pop    %esi
  802ae3:	5f                   	pop    %edi
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	8d 76 00             	lea    0x0(%esi),%esi
  802ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802af0:	31 ff                	xor    %edi,%edi
  802af2:	31 c0                	xor    %eax,%eax
  802af4:	89 fa                	mov    %edi,%edx
  802af6:	83 c4 1c             	add    $0x1c,%esp
  802af9:	5b                   	pop    %ebx
  802afa:	5e                   	pop    %esi
  802afb:	5f                   	pop    %edi
  802afc:	5d                   	pop    %ebp
  802afd:	c3                   	ret    
  802afe:	66 90                	xchg   %ax,%ax
  802b00:	31 ff                	xor    %edi,%edi
  802b02:	89 e8                	mov    %ebp,%eax
  802b04:	89 f2                	mov    %esi,%edx
  802b06:	f7 f3                	div    %ebx
  802b08:	89 fa                	mov    %edi,%edx
  802b0a:	83 c4 1c             	add    $0x1c,%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5e                   	pop    %esi
  802b0f:	5f                   	pop    %edi
  802b10:	5d                   	pop    %ebp
  802b11:	c3                   	ret    
  802b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b18:	39 f2                	cmp    %esi,%edx
  802b1a:	72 06                	jb     802b22 <__udivdi3+0x102>
  802b1c:	31 c0                	xor    %eax,%eax
  802b1e:	39 eb                	cmp    %ebp,%ebx
  802b20:	77 d2                	ja     802af4 <__udivdi3+0xd4>
  802b22:	b8 01 00 00 00       	mov    $0x1,%eax
  802b27:	eb cb                	jmp    802af4 <__udivdi3+0xd4>
  802b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b30:	89 d8                	mov    %ebx,%eax
  802b32:	31 ff                	xor    %edi,%edi
  802b34:	eb be                	jmp    802af4 <__udivdi3+0xd4>
  802b36:	66 90                	xchg   %ax,%ax
  802b38:	66 90                	xchg   %ax,%ax
  802b3a:	66 90                	xchg   %ax,%ax
  802b3c:	66 90                	xchg   %ax,%ax
  802b3e:	66 90                	xchg   %ax,%ax

00802b40 <__umoddi3>:
  802b40:	55                   	push   %ebp
  802b41:	57                   	push   %edi
  802b42:	56                   	push   %esi
  802b43:	53                   	push   %ebx
  802b44:	83 ec 1c             	sub    $0x1c,%esp
  802b47:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  802b4b:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b4f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b57:	85 ed                	test   %ebp,%ebp
  802b59:	89 f0                	mov    %esi,%eax
  802b5b:	89 da                	mov    %ebx,%edx
  802b5d:	75 19                	jne    802b78 <__umoddi3+0x38>
  802b5f:	39 df                	cmp    %ebx,%edi
  802b61:	0f 86 b1 00 00 00    	jbe    802c18 <__umoddi3+0xd8>
  802b67:	f7 f7                	div    %edi
  802b69:	89 d0                	mov    %edx,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	83 c4 1c             	add    $0x1c,%esp
  802b70:	5b                   	pop    %ebx
  802b71:	5e                   	pop    %esi
  802b72:	5f                   	pop    %edi
  802b73:	5d                   	pop    %ebp
  802b74:	c3                   	ret    
  802b75:	8d 76 00             	lea    0x0(%esi),%esi
  802b78:	39 dd                	cmp    %ebx,%ebp
  802b7a:	77 f1                	ja     802b6d <__umoddi3+0x2d>
  802b7c:	0f bd cd             	bsr    %ebp,%ecx
  802b7f:	83 f1 1f             	xor    $0x1f,%ecx
  802b82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b86:	0f 84 b4 00 00 00    	je     802c40 <__umoddi3+0x100>
  802b8c:	b8 20 00 00 00       	mov    $0x20,%eax
  802b91:	89 c2                	mov    %eax,%edx
  802b93:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b97:	29 c2                	sub    %eax,%edx
  802b99:	89 c1                	mov    %eax,%ecx
  802b9b:	89 f8                	mov    %edi,%eax
  802b9d:	d3 e5                	shl    %cl,%ebp
  802b9f:	89 d1                	mov    %edx,%ecx
  802ba1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802ba5:	d3 e8                	shr    %cl,%eax
  802ba7:	09 c5                	or     %eax,%ebp
  802ba9:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bad:	89 c1                	mov    %eax,%ecx
  802baf:	d3 e7                	shl    %cl,%edi
  802bb1:	89 d1                	mov    %edx,%ecx
  802bb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802bb7:	89 df                	mov    %ebx,%edi
  802bb9:	d3 ef                	shr    %cl,%edi
  802bbb:	89 c1                	mov    %eax,%ecx
  802bbd:	89 f0                	mov    %esi,%eax
  802bbf:	d3 e3                	shl    %cl,%ebx
  802bc1:	89 d1                	mov    %edx,%ecx
  802bc3:	89 fa                	mov    %edi,%edx
  802bc5:	d3 e8                	shr    %cl,%eax
  802bc7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bcc:	09 d8                	or     %ebx,%eax
  802bce:	f7 f5                	div    %ebp
  802bd0:	d3 e6                	shl    %cl,%esi
  802bd2:	89 d1                	mov    %edx,%ecx
  802bd4:	f7 64 24 08          	mull   0x8(%esp)
  802bd8:	39 d1                	cmp    %edx,%ecx
  802bda:	89 c3                	mov    %eax,%ebx
  802bdc:	89 d7                	mov    %edx,%edi
  802bde:	72 06                	jb     802be6 <__umoddi3+0xa6>
  802be0:	75 0e                	jne    802bf0 <__umoddi3+0xb0>
  802be2:	39 c6                	cmp    %eax,%esi
  802be4:	73 0a                	jae    802bf0 <__umoddi3+0xb0>
  802be6:	2b 44 24 08          	sub    0x8(%esp),%eax
  802bea:	19 ea                	sbb    %ebp,%edx
  802bec:	89 d7                	mov    %edx,%edi
  802bee:	89 c3                	mov    %eax,%ebx
  802bf0:	89 ca                	mov    %ecx,%edx
  802bf2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802bf7:	29 de                	sub    %ebx,%esi
  802bf9:	19 fa                	sbb    %edi,%edx
  802bfb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802bff:	89 d0                	mov    %edx,%eax
  802c01:	d3 e0                	shl    %cl,%eax
  802c03:	89 d9                	mov    %ebx,%ecx
  802c05:	d3 ee                	shr    %cl,%esi
  802c07:	d3 ea                	shr    %cl,%edx
  802c09:	09 f0                	or     %esi,%eax
  802c0b:	83 c4 1c             	add    $0x1c,%esp
  802c0e:	5b                   	pop    %ebx
  802c0f:	5e                   	pop    %esi
  802c10:	5f                   	pop    %edi
  802c11:	5d                   	pop    %ebp
  802c12:	c3                   	ret    
  802c13:	90                   	nop
  802c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c18:	85 ff                	test   %edi,%edi
  802c1a:	89 f9                	mov    %edi,%ecx
  802c1c:	75 0b                	jne    802c29 <__umoddi3+0xe9>
  802c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c23:	31 d2                	xor    %edx,%edx
  802c25:	f7 f7                	div    %edi
  802c27:	89 c1                	mov    %eax,%ecx
  802c29:	89 d8                	mov    %ebx,%eax
  802c2b:	31 d2                	xor    %edx,%edx
  802c2d:	f7 f1                	div    %ecx
  802c2f:	89 f0                	mov    %esi,%eax
  802c31:	f7 f1                	div    %ecx
  802c33:	e9 31 ff ff ff       	jmp    802b69 <__umoddi3+0x29>
  802c38:	90                   	nop
  802c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c40:	39 dd                	cmp    %ebx,%ebp
  802c42:	72 08                	jb     802c4c <__umoddi3+0x10c>
  802c44:	39 f7                	cmp    %esi,%edi
  802c46:	0f 87 21 ff ff ff    	ja     802b6d <__umoddi3+0x2d>
  802c4c:	89 da                	mov    %ebx,%edx
  802c4e:	89 f0                	mov    %esi,%eax
  802c50:	29 f8                	sub    %edi,%eax
  802c52:	19 ea                	sbb    %ebp,%edx
  802c54:	e9 14 ff ff ff       	jmp    802b6d <__umoddi3+0x2d>

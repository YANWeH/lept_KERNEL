
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 82 04 00 00       	call   8004b3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 c0 26 80 00       	push   $0x8026c0
  80003f:	e8 64 05 00 00       	call   8005a8 <cprintf>
	exit();
  800044:	e8 b0 04 00 00       	call   8004f9 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <umain>:

void umain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 58             	sub    $0x58,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  800057:	68 c4 26 80 00       	push   $0x8026c4
  80005c:	e8 47 05 00 00       	call   8005a8 <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800061:	c7 04 24 d4 26 80 00 	movl   $0x8026d4,(%esp)
  800068:	e8 14 04 00 00       	call   800481 <inet_addr>
  80006d:	83 c4 0c             	add    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	68 d4 26 80 00       	push   $0x8026d4
  800076:	68 de 26 80 00       	push   $0x8026de
  80007b:	e8 28 05 00 00       	call   8005a8 <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800080:	83 c4 0c             	add    $0xc,%esp
  800083:	6a 06                	push   $0x6
  800085:	6a 01                	push   $0x1
  800087:	6a 02                	push   $0x2
  800089:	e8 1e 1b 00 00       	call   801bac <socket>
  80008e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 b4 00 00 00    	js     800150 <umain+0x102>
		die("Failed to create socket");

	cprintf("opened socket\n");
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	68 0b 27 80 00       	push   $0x80270b
  8000a4:	e8 ff 04 00 00       	call   8005a8 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000a9:	83 c4 0c             	add    $0xc,%esp
  8000ac:	6a 10                	push   $0x10
  8000ae:	6a 00                	push   $0x0
  8000b0:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b3:	53                   	push   %ebx
  8000b4:	e8 4f 0c 00 00       	call   800d08 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000b9:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000bd:	c7 04 24 d4 26 80 00 	movl   $0x8026d4,(%esp)
  8000c4:	e8 b8 03 00 00       	call   800481 <inet_addr>
  8000c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000cc:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d3:	e8 93 01 00 00       	call   80026b <htons>
  8000d8:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000dc:	c7 04 24 1a 27 80 00 	movl   $0x80271a,(%esp)
  8000e3:	e8 c0 04 00 00       	call   8005a8 <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000e8:	83 c4 0c             	add    $0xc,%esp
  8000eb:	6a 10                	push   $0x10
  8000ed:	53                   	push   %ebx
  8000ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f1:	e8 6d 1a 00 00       	call   801b63 <connect>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	78 62                	js     80015f <umain+0x111>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	68 55 27 80 00       	push   $0x802755
  800105:	e8 9e 04 00 00       	call   8005a8 <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010a:	83 c4 04             	add    $0x4,%esp
  80010d:	ff 35 00 30 80 00    	pushl  0x803000
  800113:	e8 78 0a 00 00       	call   800b90 <strlen>
  800118:	89 c7                	mov    %eax,%edi
  80011a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80011d:	83 c4 0c             	add    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	ff 35 00 30 80 00    	pushl  0x803000
  800127:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012a:	e8 56 14 00 00       	call   801585 <write>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	39 c7                	cmp    %eax,%edi
  800134:	75 35                	jne    80016b <umain+0x11d>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 6a 27 80 00       	push   $0x80276a
  80013e:	e8 65 04 00 00       	call   8005a8 <cprintf>
	while (received < echolen) {
  800143:	83 c4 10             	add    $0x10,%esp
	int received = 0;
  800146:	be 00 00 00 00       	mov    $0x0,%esi
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80014b:	8d 7d b8             	lea    -0x48(%ebp),%edi
	while (received < echolen) {
  80014e:	eb 3a                	jmp    80018a <umain+0x13c>
		die("Failed to create socket");
  800150:	b8 f3 26 80 00       	mov    $0x8026f3,%eax
  800155:	e8 d9 fe ff ff       	call   800033 <die>
  80015a:	e9 3d ff ff ff       	jmp    80009c <umain+0x4e>
		die("Failed to connect with server");
  80015f:	b8 37 27 80 00       	mov    $0x802737,%eax
  800164:	e8 ca fe ff ff       	call   800033 <die>
  800169:	eb 92                	jmp    8000fd <umain+0xaf>
		die("Mismatch in number of sent bytes");
  80016b:	b8 84 27 80 00       	mov    $0x802784,%eax
  800170:	e8 be fe ff ff       	call   800033 <die>
  800175:	eb bf                	jmp    800136 <umain+0xe8>
			die("Failed to receive bytes from server");
		}
		received += bytes;
  800177:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  800179:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	57                   	push   %edi
  800182:	e8 21 04 00 00       	call   8005a8 <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018a:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  80018d:	73 23                	jae    8001b2 <umain+0x164>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	6a 1f                	push   $0x1f
  800194:	57                   	push   %edi
  800195:	ff 75 b4             	pushl  -0x4c(%ebp)
  800198:	e8 1a 13 00 00       	call   8014b7 <read>
  80019d:	89 c3                	mov    %eax,%ebx
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	7f d1                	jg     800177 <umain+0x129>
			die("Failed to receive bytes from server");
  8001a6:	b8 a8 27 80 00       	mov    $0x8027a8,%eax
  8001ab:	e8 83 fe ff ff       	call   800033 <die>
  8001b0:	eb c5                	jmp    800177 <umain+0x129>
	}
	cprintf("\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 74 27 80 00       	push   $0x802774
  8001ba:	e8 e9 03 00 00       	call   8005a8 <cprintf>

	close(sock);
  8001bf:	83 c4 04             	add    $0x4,%esp
  8001c2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c5:	e8 b1 11 00 00       	call   80137b <close>
}
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d0:	5b                   	pop    %ebx
  8001d1:	5e                   	pop    %esi
  8001d2:	5f                   	pop    %edi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  8001e4:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  8001e7:	c7 45 e0 00 40 80 00 	movl   $0x804000,-0x20(%ebp)
  8001ee:	eb 30                	jmp    800220 <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8001f0:	0f b6 c2             	movzbl %dl,%eax
  8001f3:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  8001f8:	88 01                	mov    %al,(%ecx)
  8001fa:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  8001fd:	83 ea 01             	sub    $0x1,%edx
  800200:	80 fa ff             	cmp    $0xff,%dl
  800203:	75 eb                	jne    8001f0 <inet_ntoa+0x1b>
  800205:	89 f0                	mov    %esi,%eax
  800207:	0f b6 f0             	movzbl %al,%esi
  80020a:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  80020d:	8d 46 01             	lea    0x1(%esi),%eax
  800210:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800213:	c6 06 2e             	movb   $0x2e,(%esi)
  800216:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  800219:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80021c:	39 c7                	cmp    %eax,%edi
  80021e:	74 3b                	je     80025b <inet_ntoa+0x86>
  rp = str;
  800220:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  800225:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  800228:	0f b6 da             	movzbl %dl,%ebx
  80022b:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80022e:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  800231:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800234:	66 c1 e8 0b          	shr    $0xb,%ax
  800238:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  80023a:	8d 71 01             	lea    0x1(%ecx),%esi
  80023d:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  800240:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  800243:	01 db                	add    %ebx,%ebx
  800245:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  800247:	83 c2 30             	add    $0x30,%edx
  80024a:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  80024e:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  800250:	84 c0                	test   %al,%al
  800252:	75 d1                	jne    800225 <inet_ntoa+0x50>
  800254:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  800257:	89 f2                	mov    %esi,%edx
  800259:	eb a2                	jmp    8001fd <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  80025b:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  80025e:	b8 00 40 80 00       	mov    $0x804000,%eax
  800263:	83 c4 14             	add    $0x14,%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80026e:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800272:	66 c1 c0 08          	rol    $0x8,%ax
}
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80027b:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80027f:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  80028b:	89 d0                	mov    %edx,%eax
  80028d:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800290:	89 d1                	mov    %edx,%ecx
  800292:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800295:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800297:	89 d1                	mov    %edx,%ecx
  800299:	c1 e1 08             	shl    $0x8,%ecx
  80029c:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002a2:	09 c8                	or     %ecx,%eax
  8002a4:	c1 ea 08             	shr    $0x8,%edx
  8002a7:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002ad:	09 d0                	or     %edx,%eax
}
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <inet_aton>:
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 1c             	sub    $0x1c,%esp
  8002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002bd:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002c0:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8002c3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8002c6:	e9 a9 00 00 00       	jmp    800374 <inet_aton+0xc3>
      c = *++cp;
  8002cb:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002cf:	89 d1                	mov    %edx,%ecx
  8002d1:	83 e1 df             	and    $0xffffffdf,%ecx
  8002d4:	80 f9 58             	cmp    $0x58,%cl
  8002d7:	74 12                	je     8002eb <inet_aton+0x3a>
      c = *++cp;
  8002d9:	83 c0 01             	add    $0x1,%eax
  8002dc:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8002df:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  8002e6:	e9 a5 00 00 00       	jmp    800390 <inet_aton+0xdf>
        c = *++cp;
  8002eb:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8002ef:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8002f2:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  8002f9:	e9 92 00 00 00       	jmp    800390 <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  8002fe:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  800302:	75 4a                	jne    80034e <inet_aton+0x9d>
  800304:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  800307:	89 d1                	mov    %edx,%ecx
  800309:	83 e1 df             	and    $0xffffffdf,%ecx
  80030c:	83 e9 41             	sub    $0x41,%ecx
  80030f:	80 f9 05             	cmp    $0x5,%cl
  800312:	77 3a                	ja     80034e <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800314:	c1 e7 04             	shl    $0x4,%edi
  800317:	83 c2 0a             	add    $0xa,%edx
  80031a:	80 fb 1a             	cmp    $0x1a,%bl
  80031d:	19 c9                	sbb    %ecx,%ecx
  80031f:	83 e1 20             	and    $0x20,%ecx
  800322:	83 c1 41             	add    $0x41,%ecx
  800325:	29 ca                	sub    %ecx,%edx
  800327:	09 d7                	or     %edx,%edi
        c = *++cp;
  800329:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80032c:	0f be 56 01          	movsbl 0x1(%esi),%edx
  800330:	83 c0 01             	add    $0x1,%eax
  800333:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  800336:	89 d6                	mov    %edx,%esi
  800338:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80033b:	80 f9 09             	cmp    $0x9,%cl
  80033e:	77 be                	ja     8002fe <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  800340:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  800344:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800348:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80034c:	eb e2                	jmp    800330 <inet_aton+0x7f>
    if (c == '.') {
  80034e:	83 fa 2e             	cmp    $0x2e,%edx
  800351:	75 44                	jne    800397 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800353:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800356:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800359:	39 c3                	cmp    %eax,%ebx
  80035b:	0f 84 13 01 00 00    	je     800474 <inet_aton+0x1c3>
      *pp++ = val;
  800361:	83 c3 04             	add    $0x4,%ebx
  800364:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800367:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  80036a:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80036d:	8d 46 01             	lea    0x1(%esi),%eax
  800370:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800374:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800377:	80 f9 09             	cmp    $0x9,%cl
  80037a:	0f 87 ed 00 00 00    	ja     80046d <inet_aton+0x1bc>
    base = 10;
  800380:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  800387:	83 fa 30             	cmp    $0x30,%edx
  80038a:	0f 84 3b ff ff ff    	je     8002cb <inet_aton+0x1a>
        base = 8;
  800390:	bf 00 00 00 00       	mov    $0x0,%edi
  800395:	eb 9c                	jmp    800333 <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800397:	85 d2                	test   %edx,%edx
  800399:	74 29                	je     8003c4 <inet_aton+0x113>
    return (0);
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003a0:	89 f3                	mov    %esi,%ebx
  8003a2:	80 fb 1f             	cmp    $0x1f,%bl
  8003a5:	0f 86 ce 00 00 00    	jbe    800479 <inet_aton+0x1c8>
  8003ab:	84 d2                	test   %dl,%dl
  8003ad:	0f 88 c6 00 00 00    	js     800479 <inet_aton+0x1c8>
  8003b3:	83 fa 20             	cmp    $0x20,%edx
  8003b6:	74 0c                	je     8003c4 <inet_aton+0x113>
  8003b8:	83 ea 09             	sub    $0x9,%edx
  8003bb:	83 fa 04             	cmp    $0x4,%edx
  8003be:	0f 87 b5 00 00 00    	ja     800479 <inet_aton+0x1c8>
  n = pp - parts + 1;
  8003c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8003c7:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8003ca:	29 c6                	sub    %eax,%esi
  8003cc:	89 f0                	mov    %esi,%eax
  8003ce:	c1 f8 02             	sar    $0x2,%eax
  8003d1:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003d4:	83 f8 02             	cmp    $0x2,%eax
  8003d7:	74 5e                	je     800437 <inet_aton+0x186>
  8003d9:	83 f8 02             	cmp    $0x2,%eax
  8003dc:	7e 35                	jle    800413 <inet_aton+0x162>
  8003de:	83 f8 03             	cmp    $0x3,%eax
  8003e1:	74 6b                	je     80044e <inet_aton+0x19d>
  8003e3:	83 f8 04             	cmp    $0x4,%eax
  8003e6:	75 2f                	jne    800417 <inet_aton+0x166>
      return (0);
  8003e8:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8003ed:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  8003f3:	0f 87 80 00 00 00    	ja     800479 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8003f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fc:	c1 e0 18             	shl    $0x18,%eax
  8003ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800402:	c1 e2 10             	shl    $0x10,%edx
  800405:	09 d0                	or     %edx,%eax
  800407:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80040a:	c1 e2 08             	shl    $0x8,%edx
  80040d:	09 d0                	or     %edx,%eax
  80040f:	09 c7                	or     %eax,%edi
    break;
  800411:	eb 04                	jmp    800417 <inet_aton+0x166>
  switch (n) {
  800413:	85 c0                	test   %eax,%eax
  800415:	74 62                	je     800479 <inet_aton+0x1c8>
  return (1);
  800417:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  80041c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800420:	74 57                	je     800479 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  800422:	57                   	push   %edi
  800423:	e8 5d fe ff ff       	call   800285 <htonl>
  800428:	83 c4 04             	add    $0x4,%esp
  80042b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80042e:	89 06                	mov    %eax,(%esi)
  return (1);
  800430:	b8 01 00 00 00       	mov    $0x1,%eax
  800435:	eb 42                	jmp    800479 <inet_aton+0x1c8>
      return (0);
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80043c:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  800442:	77 35                	ja     800479 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  800444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800447:	c1 e0 18             	shl    $0x18,%eax
  80044a:	09 c7                	or     %eax,%edi
    break;
  80044c:	eb c9                	jmp    800417 <inet_aton+0x166>
      return (0);
  80044e:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800453:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  800459:	77 1e                	ja     800479 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045e:	c1 e0 18             	shl    $0x18,%eax
  800461:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800464:	c1 e2 10             	shl    $0x10,%edx
  800467:	09 d0                	or     %edx,%eax
  800469:	09 c7                	or     %eax,%edi
    break;
  80046b:	eb aa                	jmp    800417 <inet_aton+0x166>
      return (0);
  80046d:	b8 00 00 00 00       	mov    $0x0,%eax
  800472:	eb 05                	jmp    800479 <inet_aton+0x1c8>
        return (0);
  800474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800479:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047c:	5b                   	pop    %ebx
  80047d:	5e                   	pop    %esi
  80047e:	5f                   	pop    %edi
  80047f:	5d                   	pop    %ebp
  800480:	c3                   	ret    

00800481 <inet_addr>:
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  800487:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80048a:	50                   	push   %eax
  80048b:	ff 75 08             	pushl  0x8(%ebp)
  80048e:	e8 1e fe ff ff       	call   8002b1 <inet_aton>
  800493:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  800496:	85 c0                	test   %eax,%eax
  800498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80049d:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  8004a6:	ff 75 08             	pushl  0x8(%ebp)
  8004a9:	e8 d7 fd ff ff       	call   800285 <htonl>
  8004ae:	83 c4 04             	add    $0x4,%esp
}
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004bb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004be:	e8 bf 0a 00 00       	call   800f82 <sys_getenvid>
  8004c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004c8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004cb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004d0:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d5:	85 db                	test   %ebx,%ebx
  8004d7:	7e 07                	jle    8004e0 <libmain+0x2d>
		binaryname = argv[0];
  8004d9:	8b 06                	mov    (%esi),%eax
  8004db:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	56                   	push   %esi
  8004e4:	53                   	push   %ebx
  8004e5:	e8 64 fb ff ff       	call   80004e <umain>

	// exit gracefully
	exit();
  8004ea:	e8 0a 00 00 00       	call   8004f9 <exit>
}
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004f5:	5b                   	pop    %ebx
  8004f6:	5e                   	pop    %esi
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    

008004f9 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004ff:	e8 a2 0e 00 00       	call   8013a6 <close_all>
	sys_env_destroy(0);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	6a 00                	push   $0x0
  800509:	e8 33 0a 00 00       	call   800f41 <sys_env_destroy>
}
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	c9                   	leave  
  800512:	c3                   	ret    

00800513 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	53                   	push   %ebx
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80051d:	8b 13                	mov    (%ebx),%edx
  80051f:	8d 42 01             	lea    0x1(%edx),%eax
  800522:	89 03                	mov    %eax,(%ebx)
  800524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800527:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80052b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800530:	74 09                	je     80053b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800532:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800539:	c9                   	leave  
  80053a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	68 ff 00 00 00       	push   $0xff
  800543:	8d 43 08             	lea    0x8(%ebx),%eax
  800546:	50                   	push   %eax
  800547:	e8 b8 09 00 00       	call   800f04 <sys_cputs>
		b->idx = 0;
  80054c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb db                	jmp    800532 <putch+0x1f>

00800557 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800560:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800567:	00 00 00 
	b.cnt = 0;
  80056a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800571:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800574:	ff 75 0c             	pushl  0xc(%ebp)
  800577:	ff 75 08             	pushl  0x8(%ebp)
  80057a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800580:	50                   	push   %eax
  800581:	68 13 05 80 00       	push   $0x800513
  800586:	e8 1a 01 00 00       	call   8006a5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80058b:	83 c4 08             	add    $0x8,%esp
  80058e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800594:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80059a:	50                   	push   %eax
  80059b:	e8 64 09 00 00       	call   800f04 <sys_cputs>

	return b.cnt;
}
  8005a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ae:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005b1:	50                   	push   %eax
  8005b2:	ff 75 08             	pushl  0x8(%ebp)
  8005b5:	e8 9d ff ff ff       	call   800557 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    

008005bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	57                   	push   %edi
  8005c0:	56                   	push   %esi
  8005c1:	53                   	push   %ebx
  8005c2:	83 ec 1c             	sub    $0x1c,%esp
  8005c5:	89 c7                	mov    %eax,%edi
  8005c7:	89 d6                	mov    %edx,%esi
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005dd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005e3:	39 d3                	cmp    %edx,%ebx
  8005e5:	72 05                	jb     8005ec <printnum+0x30>
  8005e7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8005ea:	77 7a                	ja     800666 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	ff 75 18             	pushl  0x18(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f8:	53                   	push   %ebx
  8005f9:	ff 75 10             	pushl  0x10(%ebp)
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800602:	ff 75 e0             	pushl  -0x20(%ebp)
  800605:	ff 75 dc             	pushl  -0x24(%ebp)
  800608:	ff 75 d8             	pushl  -0x28(%ebp)
  80060b:	e8 60 1e 00 00       	call   802470 <__udivdi3>
  800610:	83 c4 18             	add    $0x18,%esp
  800613:	52                   	push   %edx
  800614:	50                   	push   %eax
  800615:	89 f2                	mov    %esi,%edx
  800617:	89 f8                	mov    %edi,%eax
  800619:	e8 9e ff ff ff       	call   8005bc <printnum>
  80061e:	83 c4 20             	add    $0x20,%esp
  800621:	eb 13                	jmp    800636 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	56                   	push   %esi
  800627:	ff 75 18             	pushl  0x18(%ebp)
  80062a:	ff d7                	call   *%edi
  80062c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80062f:	83 eb 01             	sub    $0x1,%ebx
  800632:	85 db                	test   %ebx,%ebx
  800634:	7f ed                	jg     800623 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	56                   	push   %esi
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800640:	ff 75 e0             	pushl  -0x20(%ebp)
  800643:	ff 75 dc             	pushl  -0x24(%ebp)
  800646:	ff 75 d8             	pushl  -0x28(%ebp)
  800649:	e8 42 1f 00 00       	call   802590 <__umoddi3>
  80064e:	83 c4 14             	add    $0x14,%esp
  800651:	0f be 80 d6 27 80 00 	movsbl 0x8027d6(%eax),%eax
  800658:	50                   	push   %eax
  800659:	ff d7                	call   *%edi
}
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    
  800666:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800669:	eb c4                	jmp    80062f <printnum+0x73>

0080066b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80066b:	55                   	push   %ebp
  80066c:	89 e5                	mov    %esp,%ebp
  80066e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800671:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800675:	8b 10                	mov    (%eax),%edx
  800677:	3b 50 04             	cmp    0x4(%eax),%edx
  80067a:	73 0a                	jae    800686 <sprintputch+0x1b>
		*b->buf++ = ch;
  80067c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80067f:	89 08                	mov    %ecx,(%eax)
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	88 02                	mov    %al,(%edx)
}
  800686:	5d                   	pop    %ebp
  800687:	c3                   	ret    

00800688 <printfmt>:
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80068e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800691:	50                   	push   %eax
  800692:	ff 75 10             	pushl  0x10(%ebp)
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 08             	pushl  0x8(%ebp)
  80069b:	e8 05 00 00 00       	call   8006a5 <vprintfmt>
}
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <vprintfmt>:
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	57                   	push   %edi
  8006a9:	56                   	push   %esi
  8006aa:	53                   	push   %ebx
  8006ab:	83 ec 2c             	sub    $0x2c,%esp
  8006ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006b4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006b7:	e9 c1 03 00 00       	jmp    800a7d <vprintfmt+0x3d8>
		padc = ' ';
  8006bc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006c7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006d5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	8d 47 01             	lea    0x1(%edi),%eax
  8006dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e0:	0f b6 17             	movzbl (%edi),%edx
  8006e3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8006e6:	3c 55                	cmp    $0x55,%al
  8006e8:	0f 87 12 04 00 00    	ja     800b00 <vprintfmt+0x45b>
  8006ee:	0f b6 c0             	movzbl %al,%eax
  8006f1:	ff 24 85 20 29 80 00 	jmp    *0x802920(,%eax,4)
  8006f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8006fb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8006ff:	eb d9                	jmp    8006da <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800701:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800704:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800708:	eb d0                	jmp    8006da <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80070a:	0f b6 d2             	movzbl %dl,%edx
  80070d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800710:	b8 00 00 00 00       	mov    $0x0,%eax
  800715:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800718:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80071b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80071f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800722:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800725:	83 f9 09             	cmp    $0x9,%ecx
  800728:	77 55                	ja     80077f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80072a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80072d:	eb e9                	jmp    800718 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 40 04             	lea    0x4(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800740:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800743:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800747:	79 91                	jns    8006da <vprintfmt+0x35>
				width = precision, precision = -1;
  800749:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80074c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80074f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800756:	eb 82                	jmp    8006da <vprintfmt+0x35>
  800758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075b:	85 c0                	test   %eax,%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
  800762:	0f 49 d0             	cmovns %eax,%edx
  800765:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80076b:	e9 6a ff ff ff       	jmp    8006da <vprintfmt+0x35>
  800770:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800773:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80077a:	e9 5b ff ff ff       	jmp    8006da <vprintfmt+0x35>
  80077f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800782:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800785:	eb bc                	jmp    800743 <vprintfmt+0x9e>
			lflag++;
  800787:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80078a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80078d:	e9 48 ff ff ff       	jmp    8006da <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8d 78 04             	lea    0x4(%eax),%edi
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	53                   	push   %ebx
  80079c:	ff 30                	pushl  (%eax)
  80079e:	ff d6                	call   *%esi
			break;
  8007a0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007a3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007a6:	e9 cf 02 00 00       	jmp    800a7a <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 78 04             	lea    0x4(%eax),%edi
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	99                   	cltd   
  8007b4:	31 d0                	xor    %edx,%eax
  8007b6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007b8:	83 f8 0f             	cmp    $0xf,%eax
  8007bb:	7f 23                	jg     8007e0 <vprintfmt+0x13b>
  8007bd:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  8007c4:	85 d2                	test   %edx,%edx
  8007c6:	74 18                	je     8007e0 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007c8:	52                   	push   %edx
  8007c9:	68 b5 2b 80 00       	push   $0x802bb5
  8007ce:	53                   	push   %ebx
  8007cf:	56                   	push   %esi
  8007d0:	e8 b3 fe ff ff       	call   800688 <printfmt>
  8007d5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007d8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007db:	e9 9a 02 00 00       	jmp    800a7a <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8007e0:	50                   	push   %eax
  8007e1:	68 ee 27 80 00       	push   $0x8027ee
  8007e6:	53                   	push   %ebx
  8007e7:	56                   	push   %esi
  8007e8:	e8 9b fe ff ff       	call   800688 <printfmt>
  8007ed:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007f0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8007f3:	e9 82 02 00 00       	jmp    800a7a <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800806:	85 ff                	test   %edi,%edi
  800808:	b8 e7 27 80 00       	mov    $0x8027e7,%eax
  80080d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800810:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800814:	0f 8e bd 00 00 00    	jle    8008d7 <vprintfmt+0x232>
  80081a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80081e:	75 0e                	jne    80082e <vprintfmt+0x189>
  800820:	89 75 08             	mov    %esi,0x8(%ebp)
  800823:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800826:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800829:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80082c:	eb 6d                	jmp    80089b <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 d0             	pushl  -0x30(%ebp)
  800834:	57                   	push   %edi
  800835:	e8 6e 03 00 00       	call   800ba8 <strnlen>
  80083a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80083d:	29 c1                	sub    %eax,%ecx
  80083f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800842:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800845:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800849:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80084c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80084f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800851:	eb 0f                	jmp    800862 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	53                   	push   %ebx
  800857:	ff 75 e0             	pushl  -0x20(%ebp)
  80085a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80085c:	83 ef 01             	sub    $0x1,%edi
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	85 ff                	test   %edi,%edi
  800864:	7f ed                	jg     800853 <vprintfmt+0x1ae>
  800866:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800869:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80086c:	85 c9                	test   %ecx,%ecx
  80086e:	b8 00 00 00 00       	mov    $0x0,%eax
  800873:	0f 49 c1             	cmovns %ecx,%eax
  800876:	29 c1                	sub    %eax,%ecx
  800878:	89 75 08             	mov    %esi,0x8(%ebp)
  80087b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80087e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800881:	89 cb                	mov    %ecx,%ebx
  800883:	eb 16                	jmp    80089b <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800885:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800889:	75 31                	jne    8008bc <vprintfmt+0x217>
					putch(ch, putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	50                   	push   %eax
  800892:	ff 55 08             	call   *0x8(%ebp)
  800895:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800898:	83 eb 01             	sub    $0x1,%ebx
  80089b:	83 c7 01             	add    $0x1,%edi
  80089e:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008a2:	0f be c2             	movsbl %dl,%eax
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	74 59                	je     800902 <vprintfmt+0x25d>
  8008a9:	85 f6                	test   %esi,%esi
  8008ab:	78 d8                	js     800885 <vprintfmt+0x1e0>
  8008ad:	83 ee 01             	sub    $0x1,%esi
  8008b0:	79 d3                	jns    800885 <vprintfmt+0x1e0>
  8008b2:	89 df                	mov    %ebx,%edi
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008ba:	eb 37                	jmp    8008f3 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008bc:	0f be d2             	movsbl %dl,%edx
  8008bf:	83 ea 20             	sub    $0x20,%edx
  8008c2:	83 fa 5e             	cmp    $0x5e,%edx
  8008c5:	76 c4                	jbe    80088b <vprintfmt+0x1e6>
					putch('?', putdat);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	6a 3f                	push   $0x3f
  8008cf:	ff 55 08             	call   *0x8(%ebp)
  8008d2:	83 c4 10             	add    $0x10,%esp
  8008d5:	eb c1                	jmp    800898 <vprintfmt+0x1f3>
  8008d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8008da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008dd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8008e3:	eb b6                	jmp    80089b <vprintfmt+0x1f6>
				putch(' ', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	53                   	push   %ebx
  8008e9:	6a 20                	push   $0x20
  8008eb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8008ed:	83 ef 01             	sub    $0x1,%edi
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	85 ff                	test   %edi,%edi
  8008f5:	7f ee                	jg     8008e5 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8008f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	e9 78 01 00 00       	jmp    800a7a <vprintfmt+0x3d5>
  800902:	89 df                	mov    %ebx,%edi
  800904:	8b 75 08             	mov    0x8(%ebp),%esi
  800907:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80090a:	eb e7                	jmp    8008f3 <vprintfmt+0x24e>
	if (lflag >= 2)
  80090c:	83 f9 01             	cmp    $0x1,%ecx
  80090f:	7e 3f                	jle    800950 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8b 50 04             	mov    0x4(%eax),%edx
  800917:	8b 00                	mov    (%eax),%eax
  800919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8d 40 08             	lea    0x8(%eax),%eax
  800925:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092c:	79 5c                	jns    80098a <vprintfmt+0x2e5>
				putch('-', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	53                   	push   %ebx
  800932:	6a 2d                	push   $0x2d
  800934:	ff d6                	call   *%esi
				num = -(long long) num;
  800936:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800939:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80093c:	f7 da                	neg    %edx
  80093e:	83 d1 00             	adc    $0x0,%ecx
  800941:	f7 d9                	neg    %ecx
  800943:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800946:	b8 0a 00 00 00       	mov    $0xa,%eax
  80094b:	e9 10 01 00 00       	jmp    800a60 <vprintfmt+0x3bb>
	else if (lflag)
  800950:	85 c9                	test   %ecx,%ecx
  800952:	75 1b                	jne    80096f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095c:	89 c1                	mov    %eax,%ecx
  80095e:	c1 f9 1f             	sar    $0x1f,%ecx
  800961:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8d 40 04             	lea    0x4(%eax),%eax
  80096a:	89 45 14             	mov    %eax,0x14(%ebp)
  80096d:	eb b9                	jmp    800928 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800977:	89 c1                	mov    %eax,%ecx
  800979:	c1 f9 1f             	sar    $0x1f,%ecx
  80097c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	8d 40 04             	lea    0x4(%eax),%eax
  800985:	89 45 14             	mov    %eax,0x14(%ebp)
  800988:	eb 9e                	jmp    800928 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80098a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80098d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800990:	b8 0a 00 00 00       	mov    $0xa,%eax
  800995:	e9 c6 00 00 00       	jmp    800a60 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80099a:	83 f9 01             	cmp    $0x1,%ecx
  80099d:	7e 18                	jle    8009b7 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8b 10                	mov    (%eax),%edx
  8009a4:	8b 48 04             	mov    0x4(%eax),%ecx
  8009a7:	8d 40 08             	lea    0x8(%eax),%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b2:	e9 a9 00 00 00       	jmp    800a60 <vprintfmt+0x3bb>
	else if (lflag)
  8009b7:	85 c9                	test   %ecx,%ecx
  8009b9:	75 1a                	jne    8009d5 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8b 10                	mov    (%eax),%edx
  8009c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009c5:	8d 40 04             	lea    0x4(%eax),%eax
  8009c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d0:	e9 8b 00 00 00       	jmp    800a60 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	8b 10                	mov    (%eax),%edx
  8009da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009df:	8d 40 04             	lea    0x4(%eax),%eax
  8009e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ea:	eb 74                	jmp    800a60 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8009ec:	83 f9 01             	cmp    $0x1,%ecx
  8009ef:	7e 15                	jle    800a06 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8009f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f4:	8b 10                	mov    (%eax),%edx
  8009f6:	8b 48 04             	mov    0x4(%eax),%ecx
  8009f9:	8d 40 08             	lea    0x8(%eax),%eax
  8009fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009ff:	b8 08 00 00 00       	mov    $0x8,%eax
  800a04:	eb 5a                	jmp    800a60 <vprintfmt+0x3bb>
	else if (lflag)
  800a06:	85 c9                	test   %ecx,%ecx
  800a08:	75 17                	jne    800a21 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	8b 10                	mov    (%eax),%edx
  800a0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a14:	8d 40 04             	lea    0x4(%eax),%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a1a:	b8 08 00 00 00       	mov    $0x8,%eax
  800a1f:	eb 3f                	jmp    800a60 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	8b 10                	mov    (%eax),%edx
  800a26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a2b:	8d 40 04             	lea    0x4(%eax),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a31:	b8 08 00 00 00       	mov    $0x8,%eax
  800a36:	eb 28                	jmp    800a60 <vprintfmt+0x3bb>
			putch('0', putdat);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	53                   	push   %ebx
  800a3c:	6a 30                	push   $0x30
  800a3e:	ff d6                	call   *%esi
			putch('x', putdat);
  800a40:	83 c4 08             	add    $0x8,%esp
  800a43:	53                   	push   %ebx
  800a44:	6a 78                	push   $0x78
  800a46:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	8b 10                	mov    (%eax),%edx
  800a4d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a52:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a55:	8d 40 04             	lea    0x4(%eax),%eax
  800a58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a60:	83 ec 0c             	sub    $0xc,%esp
  800a63:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800a67:	57                   	push   %edi
  800a68:	ff 75 e0             	pushl  -0x20(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	51                   	push   %ecx
  800a6d:	52                   	push   %edx
  800a6e:	89 da                	mov    %ebx,%edx
  800a70:	89 f0                	mov    %esi,%eax
  800a72:	e8 45 fb ff ff       	call   8005bc <printnum>
			break;
  800a77:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800a7a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7d:	83 c7 01             	add    $0x1,%edi
  800a80:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a84:	83 f8 25             	cmp    $0x25,%eax
  800a87:	0f 84 2f fc ff ff    	je     8006bc <vprintfmt+0x17>
			if (ch == '\0')
  800a8d:	85 c0                	test   %eax,%eax
  800a8f:	0f 84 8b 00 00 00    	je     800b20 <vprintfmt+0x47b>
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	53                   	push   %ebx
  800a99:	50                   	push   %eax
  800a9a:	ff d6                	call   *%esi
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	eb dc                	jmp    800a7d <vprintfmt+0x3d8>
	if (lflag >= 2)
  800aa1:	83 f9 01             	cmp    $0x1,%ecx
  800aa4:	7e 15                	jle    800abb <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	8b 10                	mov    (%eax),%edx
  800aab:	8b 48 04             	mov    0x4(%eax),%ecx
  800aae:	8d 40 08             	lea    0x8(%eax),%eax
  800ab1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab4:	b8 10 00 00 00       	mov    $0x10,%eax
  800ab9:	eb a5                	jmp    800a60 <vprintfmt+0x3bb>
	else if (lflag)
  800abb:	85 c9                	test   %ecx,%ecx
  800abd:	75 17                	jne    800ad6 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8b 10                	mov    (%eax),%edx
  800ac4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac9:	8d 40 04             	lea    0x4(%eax),%eax
  800acc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800acf:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad4:	eb 8a                	jmp    800a60 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	8b 10                	mov    (%eax),%edx
  800adb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae0:	8d 40 04             	lea    0x4(%eax),%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aeb:	e9 70 ff ff ff       	jmp    800a60 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	53                   	push   %ebx
  800af4:	6a 25                	push   $0x25
  800af6:	ff d6                	call   *%esi
			break;
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	e9 7a ff ff ff       	jmp    800a7a <vprintfmt+0x3d5>
			putch('%', putdat);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	53                   	push   %ebx
  800b04:	6a 25                	push   $0x25
  800b06:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	89 f8                	mov    %edi,%eax
  800b0d:	eb 03                	jmp    800b12 <vprintfmt+0x46d>
  800b0f:	83 e8 01             	sub    $0x1,%eax
  800b12:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b16:	75 f7                	jne    800b0f <vprintfmt+0x46a>
  800b18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b1b:	e9 5a ff ff ff       	jmp    800a7a <vprintfmt+0x3d5>
}
  800b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b3b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b45:	85 c0                	test   %eax,%eax
  800b47:	74 26                	je     800b6f <vsnprintf+0x47>
  800b49:	85 d2                	test   %edx,%edx
  800b4b:	7e 22                	jle    800b6f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b4d:	ff 75 14             	pushl  0x14(%ebp)
  800b50:	ff 75 10             	pushl  0x10(%ebp)
  800b53:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b56:	50                   	push   %eax
  800b57:	68 6b 06 80 00       	push   $0x80066b
  800b5c:	e8 44 fb ff ff       	call   8006a5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b64:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
}
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    
		return -E_INVAL;
  800b6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b74:	eb f7                	jmp    800b6d <vsnprintf+0x45>

00800b76 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b7f:	50                   	push   %eax
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	e8 9a ff ff ff       	call   800b28 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b96:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9b:	eb 03                	jmp    800ba0 <strlen+0x10>
		n++;
  800b9d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800ba0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ba4:	75 f7                	jne    800b9d <strlen+0xd>
	return n;
}
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb6:	eb 03                	jmp    800bbb <strnlen+0x13>
		n++;
  800bb8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbb:	39 d0                	cmp    %edx,%eax
  800bbd:	74 06                	je     800bc5 <strnlen+0x1d>
  800bbf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bc3:	75 f3                	jne    800bb8 <strnlen+0x10>
	return n;
}
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	53                   	push   %ebx
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bd1:	89 c2                	mov    %eax,%edx
  800bd3:	83 c1 01             	add    $0x1,%ecx
  800bd6:	83 c2 01             	add    $0x1,%edx
  800bd9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800bdd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800be0:	84 db                	test   %bl,%bl
  800be2:	75 ef                	jne    800bd3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800be4:	5b                   	pop    %ebx
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	53                   	push   %ebx
  800beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bee:	53                   	push   %ebx
  800bef:	e8 9c ff ff ff       	call   800b90 <strlen>
  800bf4:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	01 d8                	add    %ebx,%eax
  800bfc:	50                   	push   %eax
  800bfd:	e8 c5 ff ff ff       	call   800bc7 <strcpy>
	return dst;
}
  800c02:	89 d8                	mov    %ebx,%eax
  800c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	8b 75 08             	mov    0x8(%ebp),%esi
  800c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c14:	89 f3                	mov    %esi,%ebx
  800c16:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c19:	89 f2                	mov    %esi,%edx
  800c1b:	eb 0f                	jmp    800c2c <strncpy+0x23>
		*dst++ = *src;
  800c1d:	83 c2 01             	add    $0x1,%edx
  800c20:	0f b6 01             	movzbl (%ecx),%eax
  800c23:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c26:	80 39 01             	cmpb   $0x1,(%ecx)
  800c29:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800c2c:	39 da                	cmp    %ebx,%edx
  800c2e:	75 ed                	jne    800c1d <strncpy+0x14>
	}
	return ret;
}
  800c30:	89 f0                	mov    %esi,%eax
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
  800c3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c44:	89 f0                	mov    %esi,%eax
  800c46:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c4a:	85 c9                	test   %ecx,%ecx
  800c4c:	75 0b                	jne    800c59 <strlcpy+0x23>
  800c4e:	eb 17                	jmp    800c67 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c50:	83 c2 01             	add    $0x1,%edx
  800c53:	83 c0 01             	add    $0x1,%eax
  800c56:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800c59:	39 d8                	cmp    %ebx,%eax
  800c5b:	74 07                	je     800c64 <strlcpy+0x2e>
  800c5d:	0f b6 0a             	movzbl (%edx),%ecx
  800c60:	84 c9                	test   %cl,%cl
  800c62:	75 ec                	jne    800c50 <strlcpy+0x1a>
		*dst = '\0';
  800c64:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c67:	29 f0                	sub    %esi,%eax
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c73:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c76:	eb 06                	jmp    800c7e <strcmp+0x11>
		p++, q++;
  800c78:	83 c1 01             	add    $0x1,%ecx
  800c7b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800c7e:	0f b6 01             	movzbl (%ecx),%eax
  800c81:	84 c0                	test   %al,%al
  800c83:	74 04                	je     800c89 <strcmp+0x1c>
  800c85:	3a 02                	cmp    (%edx),%al
  800c87:	74 ef                	je     800c78 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c89:	0f b6 c0             	movzbl %al,%eax
  800c8c:	0f b6 12             	movzbl (%edx),%edx
  800c8f:	29 d0                	sub    %edx,%eax
}
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	53                   	push   %ebx
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9d:	89 c3                	mov    %eax,%ebx
  800c9f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ca2:	eb 06                	jmp    800caa <strncmp+0x17>
		n--, p++, q++;
  800ca4:	83 c0 01             	add    $0x1,%eax
  800ca7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800caa:	39 d8                	cmp    %ebx,%eax
  800cac:	74 16                	je     800cc4 <strncmp+0x31>
  800cae:	0f b6 08             	movzbl (%eax),%ecx
  800cb1:	84 c9                	test   %cl,%cl
  800cb3:	74 04                	je     800cb9 <strncmp+0x26>
  800cb5:	3a 0a                	cmp    (%edx),%cl
  800cb7:	74 eb                	je     800ca4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb9:	0f b6 00             	movzbl (%eax),%eax
  800cbc:	0f b6 12             	movzbl (%edx),%edx
  800cbf:	29 d0                	sub    %edx,%eax
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    
		return 0;
  800cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc9:	eb f6                	jmp    800cc1 <strncmp+0x2e>

00800ccb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd5:	0f b6 10             	movzbl (%eax),%edx
  800cd8:	84 d2                	test   %dl,%dl
  800cda:	74 09                	je     800ce5 <strchr+0x1a>
		if (*s == c)
  800cdc:	38 ca                	cmp    %cl,%dl
  800cde:	74 0a                	je     800cea <strchr+0x1f>
	for (; *s; s++)
  800ce0:	83 c0 01             	add    $0x1,%eax
  800ce3:	eb f0                	jmp    800cd5 <strchr+0xa>
			return (char *) s;
	return 0;
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf6:	eb 03                	jmp    800cfb <strfind+0xf>
  800cf8:	83 c0 01             	add    $0x1,%eax
  800cfb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cfe:	38 ca                	cmp    %cl,%dl
  800d00:	74 04                	je     800d06 <strfind+0x1a>
  800d02:	84 d2                	test   %dl,%dl
  800d04:	75 f2                	jne    800cf8 <strfind+0xc>
			break;
	return (char *) s;
}
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d14:	85 c9                	test   %ecx,%ecx
  800d16:	74 13                	je     800d2b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d18:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d1e:	75 05                	jne    800d25 <memset+0x1d>
  800d20:	f6 c1 03             	test   $0x3,%cl
  800d23:	74 0d                	je     800d32 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	fc                   	cld    
  800d29:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2b:	89 f8                	mov    %edi,%eax
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
		c &= 0xFF;
  800d32:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d36:	89 d3                	mov    %edx,%ebx
  800d38:	c1 e3 08             	shl    $0x8,%ebx
  800d3b:	89 d0                	mov    %edx,%eax
  800d3d:	c1 e0 18             	shl    $0x18,%eax
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	c1 e6 10             	shl    $0x10,%esi
  800d45:	09 f0                	or     %esi,%eax
  800d47:	09 c2                	or     %eax,%edx
  800d49:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800d4b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d4e:	89 d0                	mov    %edx,%eax
  800d50:	fc                   	cld    
  800d51:	f3 ab                	rep stos %eax,%es:(%edi)
  800d53:	eb d6                	jmp    800d2b <memset+0x23>

00800d55 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d60:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d63:	39 c6                	cmp    %eax,%esi
  800d65:	73 35                	jae    800d9c <memmove+0x47>
  800d67:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d6a:	39 c2                	cmp    %eax,%edx
  800d6c:	76 2e                	jbe    800d9c <memmove+0x47>
		s += n;
		d += n;
  800d6e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d71:	89 d6                	mov    %edx,%esi
  800d73:	09 fe                	or     %edi,%esi
  800d75:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d7b:	74 0c                	je     800d89 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d7d:	83 ef 01             	sub    $0x1,%edi
  800d80:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d83:	fd                   	std    
  800d84:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d86:	fc                   	cld    
  800d87:	eb 21                	jmp    800daa <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d89:	f6 c1 03             	test   $0x3,%cl
  800d8c:	75 ef                	jne    800d7d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d8e:	83 ef 04             	sub    $0x4,%edi
  800d91:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d94:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d97:	fd                   	std    
  800d98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d9a:	eb ea                	jmp    800d86 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d9c:	89 f2                	mov    %esi,%edx
  800d9e:	09 c2                	or     %eax,%edx
  800da0:	f6 c2 03             	test   $0x3,%dl
  800da3:	74 09                	je     800dae <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800da5:	89 c7                	mov    %eax,%edi
  800da7:	fc                   	cld    
  800da8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dae:	f6 c1 03             	test   $0x3,%cl
  800db1:	75 f2                	jne    800da5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800db3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800db6:	89 c7                	mov    %eax,%edi
  800db8:	fc                   	cld    
  800db9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dbb:	eb ed                	jmp    800daa <memmove+0x55>

00800dbd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800dc0:	ff 75 10             	pushl  0x10(%ebp)
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 87 ff ff ff       	call   800d55 <memmove>
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	56                   	push   %esi
  800dd4:	53                   	push   %ebx
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddb:	89 c6                	mov    %eax,%esi
  800ddd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800de0:	39 f0                	cmp    %esi,%eax
  800de2:	74 1c                	je     800e00 <memcmp+0x30>
		if (*s1 != *s2)
  800de4:	0f b6 08             	movzbl (%eax),%ecx
  800de7:	0f b6 1a             	movzbl (%edx),%ebx
  800dea:	38 d9                	cmp    %bl,%cl
  800dec:	75 08                	jne    800df6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dee:	83 c0 01             	add    $0x1,%eax
  800df1:	83 c2 01             	add    $0x1,%edx
  800df4:	eb ea                	jmp    800de0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800df6:	0f b6 c1             	movzbl %cl,%eax
  800df9:	0f b6 db             	movzbl %bl,%ebx
  800dfc:	29 d8                	sub    %ebx,%eax
  800dfe:	eb 05                	jmp    800e05 <memcmp+0x35>
	}

	return 0;
  800e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e12:	89 c2                	mov    %eax,%edx
  800e14:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e17:	39 d0                	cmp    %edx,%eax
  800e19:	73 09                	jae    800e24 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e1b:	38 08                	cmp    %cl,(%eax)
  800e1d:	74 05                	je     800e24 <memfind+0x1b>
	for (; s < ends; s++)
  800e1f:	83 c0 01             	add    $0x1,%eax
  800e22:	eb f3                	jmp    800e17 <memfind+0xe>
			break;
	return (void *) s;
}
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
  800e2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e32:	eb 03                	jmp    800e37 <strtol+0x11>
		s++;
  800e34:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e37:	0f b6 01             	movzbl (%ecx),%eax
  800e3a:	3c 20                	cmp    $0x20,%al
  800e3c:	74 f6                	je     800e34 <strtol+0xe>
  800e3e:	3c 09                	cmp    $0x9,%al
  800e40:	74 f2                	je     800e34 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e42:	3c 2b                	cmp    $0x2b,%al
  800e44:	74 2e                	je     800e74 <strtol+0x4e>
	int neg = 0;
  800e46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e4b:	3c 2d                	cmp    $0x2d,%al
  800e4d:	74 2f                	je     800e7e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e55:	75 05                	jne    800e5c <strtol+0x36>
  800e57:	80 39 30             	cmpb   $0x30,(%ecx)
  800e5a:	74 2c                	je     800e88 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e5c:	85 db                	test   %ebx,%ebx
  800e5e:	75 0a                	jne    800e6a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e60:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800e65:	80 39 30             	cmpb   $0x30,(%ecx)
  800e68:	74 28                	je     800e92 <strtol+0x6c>
		base = 10;
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e72:	eb 50                	jmp    800ec4 <strtol+0x9e>
		s++;
  800e74:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e77:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7c:	eb d1                	jmp    800e4f <strtol+0x29>
		s++, neg = 1;
  800e7e:	83 c1 01             	add    $0x1,%ecx
  800e81:	bf 01 00 00 00       	mov    $0x1,%edi
  800e86:	eb c7                	jmp    800e4f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e8c:	74 0e                	je     800e9c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800e8e:	85 db                	test   %ebx,%ebx
  800e90:	75 d8                	jne    800e6a <strtol+0x44>
		s++, base = 8;
  800e92:	83 c1 01             	add    $0x1,%ecx
  800e95:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e9a:	eb ce                	jmp    800e6a <strtol+0x44>
		s += 2, base = 16;
  800e9c:	83 c1 02             	add    $0x2,%ecx
  800e9f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ea4:	eb c4                	jmp    800e6a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ea6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ea9:	89 f3                	mov    %esi,%ebx
  800eab:	80 fb 19             	cmp    $0x19,%bl
  800eae:	77 29                	ja     800ed9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800eb0:	0f be d2             	movsbl %dl,%edx
  800eb3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800eb6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800eb9:	7d 30                	jge    800eeb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ebb:	83 c1 01             	add    $0x1,%ecx
  800ebe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ec2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ec4:	0f b6 11             	movzbl (%ecx),%edx
  800ec7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eca:	89 f3                	mov    %esi,%ebx
  800ecc:	80 fb 09             	cmp    $0x9,%bl
  800ecf:	77 d5                	ja     800ea6 <strtol+0x80>
			dig = *s - '0';
  800ed1:	0f be d2             	movsbl %dl,%edx
  800ed4:	83 ea 30             	sub    $0x30,%edx
  800ed7:	eb dd                	jmp    800eb6 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ed9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800edc:	89 f3                	mov    %esi,%ebx
  800ede:	80 fb 19             	cmp    $0x19,%bl
  800ee1:	77 08                	ja     800eeb <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ee3:	0f be d2             	movsbl %dl,%edx
  800ee6:	83 ea 37             	sub    $0x37,%edx
  800ee9:	eb cb                	jmp    800eb6 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eeb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eef:	74 05                	je     800ef6 <strtol+0xd0>
		*endptr = (char *) s;
  800ef1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ef4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ef6:	89 c2                	mov    %eax,%edx
  800ef8:	f7 da                	neg    %edx
  800efa:	85 ff                	test   %edi,%edi
  800efc:	0f 45 c2             	cmovne %edx,%eax
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f15:	89 c3                	mov    %eax,%ebx
  800f17:	89 c7                	mov    %eax,%edi
  800f19:	89 c6                	mov    %eax,%esi
  800f1b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    

00800f22 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f28:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  800f32:	89 d1                	mov    %edx,%ecx
  800f34:	89 d3                	mov    %edx,%ebx
  800f36:	89 d7                	mov    %edx,%edi
  800f38:	89 d6                	mov    %edx,%esi
  800f3a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	57                   	push   %edi
  800f45:	56                   	push   %esi
  800f46:	53                   	push   %ebx
  800f47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	b8 03 00 00 00       	mov    $0x3,%eax
  800f57:	89 cb                	mov    %ecx,%ebx
  800f59:	89 cf                	mov    %ecx,%edi
  800f5b:	89 ce                	mov    %ecx,%esi
  800f5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	7f 08                	jg     800f6b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	50                   	push   %eax
  800f6f:	6a 03                	push   $0x3
  800f71:	68 df 2a 80 00       	push   $0x802adf
  800f76:	6a 23                	push   $0x23
  800f78:	68 fc 2a 80 00       	push   $0x802afc
  800f7d:	e8 6e 13 00 00       	call   8022f0 <_panic>

00800f82 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	b8 02 00 00 00       	mov    $0x2,%eax
  800f92:	89 d1                	mov    %edx,%ecx
  800f94:	89 d3                	mov    %edx,%ebx
  800f96:	89 d7                	mov    %edx,%edi
  800f98:	89 d6                	mov    %edx,%esi
  800f9a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_yield>:

void
sys_yield(void)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fac:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fb1:	89 d1                	mov    %edx,%ecx
  800fb3:	89 d3                	mov    %edx,%ebx
  800fb5:	89 d7                	mov    %edx,%edi
  800fb7:	89 d6                	mov    %edx,%esi
  800fb9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
  800fc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc9:	be 00 00 00 00       	mov    $0x0,%esi
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd4:	b8 04 00 00 00       	mov    $0x4,%eax
  800fd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdc:	89 f7                	mov    %esi,%edi
  800fde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	7f 08                	jg     800fec <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	50                   	push   %eax
  800ff0:	6a 04                	push   $0x4
  800ff2:	68 df 2a 80 00       	push   $0x802adf
  800ff7:	6a 23                	push   $0x23
  800ff9:	68 fc 2a 80 00       	push   $0x802afc
  800ffe:	e8 ed 12 00 00       	call   8022f0 <_panic>

00801003 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100c:	8b 55 08             	mov    0x8(%ebp),%edx
  80100f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801012:	b8 05 00 00 00       	mov    $0x5,%eax
  801017:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80101a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80101d:	8b 75 18             	mov    0x18(%ebp),%esi
  801020:	cd 30                	int    $0x30
	if(check && ret > 0)
  801022:	85 c0                	test   %eax,%eax
  801024:	7f 08                	jg     80102e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801026:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	50                   	push   %eax
  801032:	6a 05                	push   $0x5
  801034:	68 df 2a 80 00       	push   $0x802adf
  801039:	6a 23                	push   $0x23
  80103b:	68 fc 2a 80 00       	push   $0x802afc
  801040:	e8 ab 12 00 00       	call   8022f0 <_panic>

00801045 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
  80104b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801059:	b8 06 00 00 00       	mov    $0x6,%eax
  80105e:	89 df                	mov    %ebx,%edi
  801060:	89 de                	mov    %ebx,%esi
  801062:	cd 30                	int    $0x30
	if(check && ret > 0)
  801064:	85 c0                	test   %eax,%eax
  801066:	7f 08                	jg     801070 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801070:	83 ec 0c             	sub    $0xc,%esp
  801073:	50                   	push   %eax
  801074:	6a 06                	push   $0x6
  801076:	68 df 2a 80 00       	push   $0x802adf
  80107b:	6a 23                	push   $0x23
  80107d:	68 fc 2a 80 00       	push   $0x802afc
  801082:	e8 69 12 00 00       	call   8022f0 <_panic>

00801087 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	57                   	push   %edi
  80108b:	56                   	push   %esi
  80108c:	53                   	push   %ebx
  80108d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	b8 08 00 00 00       	mov    $0x8,%eax
  8010a0:	89 df                	mov    %ebx,%edi
  8010a2:	89 de                	mov    %ebx,%esi
  8010a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	7f 08                	jg     8010b2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b2:	83 ec 0c             	sub    $0xc,%esp
  8010b5:	50                   	push   %eax
  8010b6:	6a 08                	push   $0x8
  8010b8:	68 df 2a 80 00       	push   $0x802adf
  8010bd:	6a 23                	push   $0x23
  8010bf:	68 fc 2a 80 00       	push   $0x802afc
  8010c4:	e8 27 12 00 00       	call   8022f0 <_panic>

008010c9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
  8010cf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010dd:	b8 09 00 00 00       	mov    $0x9,%eax
  8010e2:	89 df                	mov    %ebx,%edi
  8010e4:	89 de                	mov    %ebx,%esi
  8010e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	7f 08                	jg     8010f4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5f                   	pop    %edi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f4:	83 ec 0c             	sub    $0xc,%esp
  8010f7:	50                   	push   %eax
  8010f8:	6a 09                	push   $0x9
  8010fa:	68 df 2a 80 00       	push   $0x802adf
  8010ff:	6a 23                	push   $0x23
  801101:	68 fc 2a 80 00       	push   $0x802afc
  801106:	e8 e5 11 00 00       	call   8022f0 <_panic>

0080110b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801124:	89 df                	mov    %ebx,%edi
  801126:	89 de                	mov    %ebx,%esi
  801128:	cd 30                	int    $0x30
	if(check && ret > 0)
  80112a:	85 c0                	test   %eax,%eax
  80112c:	7f 08                	jg     801136 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80112e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	50                   	push   %eax
  80113a:	6a 0a                	push   $0xa
  80113c:	68 df 2a 80 00       	push   $0x802adf
  801141:	6a 23                	push   $0x23
  801143:	68 fc 2a 80 00       	push   $0x802afc
  801148:	e8 a3 11 00 00       	call   8022f0 <_panic>

0080114d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	57                   	push   %edi
  801151:	56                   	push   %esi
  801152:	53                   	push   %ebx
	asm volatile("int %1\n"
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	b8 0c 00 00 00       	mov    $0xc,%eax
  80115e:	be 00 00 00 00       	mov    $0x0,%esi
  801163:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801166:	8b 7d 14             	mov    0x14(%ebp),%edi
  801169:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5f                   	pop    %edi
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
  801176:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801179:	b9 00 00 00 00       	mov    $0x0,%ecx
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	b8 0d 00 00 00       	mov    $0xd,%eax
  801186:	89 cb                	mov    %ecx,%ebx
  801188:	89 cf                	mov    %ecx,%edi
  80118a:	89 ce                	mov    %ecx,%esi
  80118c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	7f 08                	jg     80119a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	50                   	push   %eax
  80119e:	6a 0d                	push   $0xd
  8011a0:	68 df 2a 80 00       	push   $0x802adf
  8011a5:	6a 23                	push   $0x23
  8011a7:	68 fc 2a 80 00       	push   $0x802afc
  8011ac:	e8 3f 11 00 00       	call   8022f0 <_panic>

008011b1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bc:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011c1:	89 d1                	mov    %edx,%ecx
  8011c3:	89 d3                	mov    %edx,%ebx
  8011c5:	89 d7                	mov    %edx,%edi
  8011c7:	89 d6                	mov    %edx,%esi
  8011c9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5f                   	pop    %edi
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8011db:	c1 e8 0c             	shr    $0xc,%eax
}
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    

008011e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    

008011f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801202:	89 c2                	mov    %eax,%edx
  801204:	c1 ea 16             	shr    $0x16,%edx
  801207:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80120e:	f6 c2 01             	test   $0x1,%dl
  801211:	74 2a                	je     80123d <fd_alloc+0x46>
  801213:	89 c2                	mov    %eax,%edx
  801215:	c1 ea 0c             	shr    $0xc,%edx
  801218:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80121f:	f6 c2 01             	test   $0x1,%dl
  801222:	74 19                	je     80123d <fd_alloc+0x46>
  801224:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801229:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80122e:	75 d2                	jne    801202 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801230:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801236:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80123b:	eb 07                	jmp    801244 <fd_alloc+0x4d>
			*fd_store = fd;
  80123d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    

00801246 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80124c:	83 f8 1f             	cmp    $0x1f,%eax
  80124f:	77 36                	ja     801287 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801251:	c1 e0 0c             	shl    $0xc,%eax
  801254:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801259:	89 c2                	mov    %eax,%edx
  80125b:	c1 ea 16             	shr    $0x16,%edx
  80125e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801265:	f6 c2 01             	test   $0x1,%dl
  801268:	74 24                	je     80128e <fd_lookup+0x48>
  80126a:	89 c2                	mov    %eax,%edx
  80126c:	c1 ea 0c             	shr    $0xc,%edx
  80126f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801276:	f6 c2 01             	test   $0x1,%dl
  801279:	74 1a                	je     801295 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	89 02                	mov    %eax,(%edx)
	return 0;
  801280:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    
		return -E_INVAL;
  801287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128c:	eb f7                	jmp    801285 <fd_lookup+0x3f>
		return -E_INVAL;
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801293:	eb f0                	jmp    801285 <fd_lookup+0x3f>
  801295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129a:	eb e9                	jmp    801285 <fd_lookup+0x3f>

0080129c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a5:	ba 88 2b 80 00       	mov    $0x802b88,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012aa:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012af:	39 08                	cmp    %ecx,(%eax)
  8012b1:	74 33                	je     8012e6 <dev_lookup+0x4a>
  8012b3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012b6:	8b 02                	mov    (%edx),%eax
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	75 f3                	jne    8012af <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012bc:	a1 18 40 80 00       	mov    0x804018,%eax
  8012c1:	8b 40 48             	mov    0x48(%eax),%eax
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	51                   	push   %ecx
  8012c8:	50                   	push   %eax
  8012c9:	68 0c 2b 80 00       	push   $0x802b0c
  8012ce:	e8 d5 f2 ff ff       	call   8005a8 <cprintf>
	*dev = 0;
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    
			*dev = devtab[i];
  8012e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f0:	eb f2                	jmp    8012e4 <dev_lookup+0x48>

008012f2 <fd_close>:
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	57                   	push   %edi
  8012f6:	56                   	push   %esi
  8012f7:	53                   	push   %ebx
  8012f8:	83 ec 1c             	sub    $0x1c,%esp
  8012fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8012fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801301:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801304:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801305:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80130b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80130e:	50                   	push   %eax
  80130f:	e8 32 ff ff ff       	call   801246 <fd_lookup>
  801314:	89 c3                	mov    %eax,%ebx
  801316:	83 c4 08             	add    $0x8,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	78 05                	js     801322 <fd_close+0x30>
	    || fd != fd2)
  80131d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801320:	74 16                	je     801338 <fd_close+0x46>
		return (must_exist ? r : 0);
  801322:	89 f8                	mov    %edi,%eax
  801324:	84 c0                	test   %al,%al
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	0f 44 d8             	cmove  %eax,%ebx
}
  80132e:	89 d8                	mov    %ebx,%eax
  801330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801333:	5b                   	pop    %ebx
  801334:	5e                   	pop    %esi
  801335:	5f                   	pop    %edi
  801336:	5d                   	pop    %ebp
  801337:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801338:	83 ec 08             	sub    $0x8,%esp
  80133b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	ff 36                	pushl  (%esi)
  801341:	e8 56 ff ff ff       	call   80129c <dev_lookup>
  801346:	89 c3                	mov    %eax,%ebx
  801348:	83 c4 10             	add    $0x10,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	78 15                	js     801364 <fd_close+0x72>
		if (dev->dev_close)
  80134f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801352:	8b 40 10             	mov    0x10(%eax),%eax
  801355:	85 c0                	test   %eax,%eax
  801357:	74 1b                	je     801374 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801359:	83 ec 0c             	sub    $0xc,%esp
  80135c:	56                   	push   %esi
  80135d:	ff d0                	call   *%eax
  80135f:	89 c3                	mov    %eax,%ebx
  801361:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801364:	83 ec 08             	sub    $0x8,%esp
  801367:	56                   	push   %esi
  801368:	6a 00                	push   $0x0
  80136a:	e8 d6 fc ff ff       	call   801045 <sys_page_unmap>
	return r;
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	eb ba                	jmp    80132e <fd_close+0x3c>
			r = 0;
  801374:	bb 00 00 00 00       	mov    $0x0,%ebx
  801379:	eb e9                	jmp    801364 <fd_close+0x72>

0080137b <close>:

int
close(int fdnum)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801381:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801384:	50                   	push   %eax
  801385:	ff 75 08             	pushl  0x8(%ebp)
  801388:	e8 b9 fe ff ff       	call   801246 <fd_lookup>
  80138d:	83 c4 08             	add    $0x8,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	78 10                	js     8013a4 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	6a 01                	push   $0x1
  801399:	ff 75 f4             	pushl  -0xc(%ebp)
  80139c:	e8 51 ff ff ff       	call   8012f2 <fd_close>
  8013a1:	83 c4 10             	add    $0x10,%esp
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <close_all>:

void
close_all(void)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	53                   	push   %ebx
  8013b6:	e8 c0 ff ff ff       	call   80137b <close>
	for (i = 0; i < MAXFD; i++)
  8013bb:	83 c3 01             	add    $0x1,%ebx
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	83 fb 20             	cmp    $0x20,%ebx
  8013c4:	75 ec                	jne    8013b2 <close_all+0xc>
}
  8013c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	57                   	push   %edi
  8013cf:	56                   	push   %esi
  8013d0:	53                   	push   %ebx
  8013d1:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d7:	50                   	push   %eax
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 66 fe ff ff       	call   801246 <fd_lookup>
  8013e0:	89 c3                	mov    %eax,%ebx
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	0f 88 81 00 00 00    	js     80146e <dup+0xa3>
		return r;
	close(newfdnum);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 0c             	pushl  0xc(%ebp)
  8013f3:	e8 83 ff ff ff       	call   80137b <close>

	newfd = INDEX2FD(newfdnum);
  8013f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013fb:	c1 e6 0c             	shl    $0xc,%esi
  8013fe:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801404:	83 c4 04             	add    $0x4,%esp
  801407:	ff 75 e4             	pushl  -0x1c(%ebp)
  80140a:	e8 d1 fd ff ff       	call   8011e0 <fd2data>
  80140f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801411:	89 34 24             	mov    %esi,(%esp)
  801414:	e8 c7 fd ff ff       	call   8011e0 <fd2data>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80141e:	89 d8                	mov    %ebx,%eax
  801420:	c1 e8 16             	shr    $0x16,%eax
  801423:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80142a:	a8 01                	test   $0x1,%al
  80142c:	74 11                	je     80143f <dup+0x74>
  80142e:	89 d8                	mov    %ebx,%eax
  801430:	c1 e8 0c             	shr    $0xc,%eax
  801433:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80143a:	f6 c2 01             	test   $0x1,%dl
  80143d:	75 39                	jne    801478 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80143f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801442:	89 d0                	mov    %edx,%eax
  801444:	c1 e8 0c             	shr    $0xc,%eax
  801447:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	25 07 0e 00 00       	and    $0xe07,%eax
  801456:	50                   	push   %eax
  801457:	56                   	push   %esi
  801458:	6a 00                	push   $0x0
  80145a:	52                   	push   %edx
  80145b:	6a 00                	push   $0x0
  80145d:	e8 a1 fb ff ff       	call   801003 <sys_page_map>
  801462:	89 c3                	mov    %eax,%ebx
  801464:	83 c4 20             	add    $0x20,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 31                	js     80149c <dup+0xd1>
		goto err;

	return newfdnum;
  80146b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80146e:	89 d8                	mov    %ebx,%eax
  801470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801473:	5b                   	pop    %ebx
  801474:	5e                   	pop    %esi
  801475:	5f                   	pop    %edi
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801478:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	25 07 0e 00 00       	and    $0xe07,%eax
  801487:	50                   	push   %eax
  801488:	57                   	push   %edi
  801489:	6a 00                	push   $0x0
  80148b:	53                   	push   %ebx
  80148c:	6a 00                	push   $0x0
  80148e:	e8 70 fb ff ff       	call   801003 <sys_page_map>
  801493:	89 c3                	mov    %eax,%ebx
  801495:	83 c4 20             	add    $0x20,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	79 a3                	jns    80143f <dup+0x74>
	sys_page_unmap(0, newfd);
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	56                   	push   %esi
  8014a0:	6a 00                	push   $0x0
  8014a2:	e8 9e fb ff ff       	call   801045 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	57                   	push   %edi
  8014ab:	6a 00                	push   $0x0
  8014ad:	e8 93 fb ff ff       	call   801045 <sys_page_unmap>
	return r;
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	eb b7                	jmp    80146e <dup+0xa3>

008014b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 14             	sub    $0x14,%esp
  8014be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c4:	50                   	push   %eax
  8014c5:	53                   	push   %ebx
  8014c6:	e8 7b fd ff ff       	call   801246 <fd_lookup>
  8014cb:	83 c4 08             	add    $0x8,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 3f                	js     801511 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d8:	50                   	push   %eax
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	ff 30                	pushl  (%eax)
  8014de:	e8 b9 fd ff ff       	call   80129c <dev_lookup>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 27                	js     801511 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ed:	8b 42 08             	mov    0x8(%edx),%eax
  8014f0:	83 e0 03             	and    $0x3,%eax
  8014f3:	83 f8 01             	cmp    $0x1,%eax
  8014f6:	74 1e                	je     801516 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fb:	8b 40 08             	mov    0x8(%eax),%eax
  8014fe:	85 c0                	test   %eax,%eax
  801500:	74 35                	je     801537 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	ff 75 10             	pushl  0x10(%ebp)
  801508:	ff 75 0c             	pushl  0xc(%ebp)
  80150b:	52                   	push   %edx
  80150c:	ff d0                	call   *%eax
  80150e:	83 c4 10             	add    $0x10,%esp
}
  801511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801514:	c9                   	leave  
  801515:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801516:	a1 18 40 80 00       	mov    0x804018,%eax
  80151b:	8b 40 48             	mov    0x48(%eax),%eax
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	53                   	push   %ebx
  801522:	50                   	push   %eax
  801523:	68 4d 2b 80 00       	push   $0x802b4d
  801528:	e8 7b f0 ff ff       	call   8005a8 <cprintf>
		return -E_INVAL;
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801535:	eb da                	jmp    801511 <read+0x5a>
		return -E_NOT_SUPP;
  801537:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153c:	eb d3                	jmp    801511 <read+0x5a>

0080153e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	57                   	push   %edi
  801542:	56                   	push   %esi
  801543:	53                   	push   %ebx
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	8b 7d 08             	mov    0x8(%ebp),%edi
  80154a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80154d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801552:	39 f3                	cmp    %esi,%ebx
  801554:	73 25                	jae    80157b <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801556:	83 ec 04             	sub    $0x4,%esp
  801559:	89 f0                	mov    %esi,%eax
  80155b:	29 d8                	sub    %ebx,%eax
  80155d:	50                   	push   %eax
  80155e:	89 d8                	mov    %ebx,%eax
  801560:	03 45 0c             	add    0xc(%ebp),%eax
  801563:	50                   	push   %eax
  801564:	57                   	push   %edi
  801565:	e8 4d ff ff ff       	call   8014b7 <read>
		if (m < 0)
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	78 08                	js     801579 <readn+0x3b>
			return m;
		if (m == 0)
  801571:	85 c0                	test   %eax,%eax
  801573:	74 06                	je     80157b <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801575:	01 c3                	add    %eax,%ebx
  801577:	eb d9                	jmp    801552 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801579:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80157b:	89 d8                	mov    %ebx,%eax
  80157d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801580:	5b                   	pop    %ebx
  801581:	5e                   	pop    %esi
  801582:	5f                   	pop    %edi
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 14             	sub    $0x14,%esp
  80158c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	53                   	push   %ebx
  801594:	e8 ad fc ff ff       	call   801246 <fd_lookup>
  801599:	83 c4 08             	add    $0x8,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 3a                	js     8015da <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	ff 30                	pushl  (%eax)
  8015ac:	e8 eb fc ff ff       	call   80129c <dev_lookup>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	78 22                	js     8015da <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015bf:	74 1e                	je     8015df <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c7:	85 d2                	test   %edx,%edx
  8015c9:	74 35                	je     801600 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	ff 75 10             	pushl  0x10(%ebp)
  8015d1:	ff 75 0c             	pushl  0xc(%ebp)
  8015d4:	50                   	push   %eax
  8015d5:	ff d2                	call   *%edx
  8015d7:	83 c4 10             	add    $0x10,%esp
}
  8015da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015df:	a1 18 40 80 00       	mov    0x804018,%eax
  8015e4:	8b 40 48             	mov    0x48(%eax),%eax
  8015e7:	83 ec 04             	sub    $0x4,%esp
  8015ea:	53                   	push   %ebx
  8015eb:	50                   	push   %eax
  8015ec:	68 69 2b 80 00       	push   $0x802b69
  8015f1:	e8 b2 ef ff ff       	call   8005a8 <cprintf>
		return -E_INVAL;
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fe:	eb da                	jmp    8015da <write+0x55>
		return -E_NOT_SUPP;
  801600:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801605:	eb d3                	jmp    8015da <write+0x55>

00801607 <seek>:

int
seek(int fdnum, off_t offset)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80160d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	ff 75 08             	pushl  0x8(%ebp)
  801614:	e8 2d fc ff ff       	call   801246 <fd_lookup>
  801619:	83 c4 08             	add    $0x8,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 0e                	js     80162e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801626:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	53                   	push   %ebx
  801634:	83 ec 14             	sub    $0x14,%esp
  801637:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163d:	50                   	push   %eax
  80163e:	53                   	push   %ebx
  80163f:	e8 02 fc ff ff       	call   801246 <fd_lookup>
  801644:	83 c4 08             	add    $0x8,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	78 37                	js     801682 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801651:	50                   	push   %eax
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801655:	ff 30                	pushl  (%eax)
  801657:	e8 40 fc ff ff       	call   80129c <dev_lookup>
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 1f                	js     801682 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801666:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80166a:	74 1b                	je     801687 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80166c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166f:	8b 52 18             	mov    0x18(%edx),%edx
  801672:	85 d2                	test   %edx,%edx
  801674:	74 32                	je     8016a8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	50                   	push   %eax
  80167d:	ff d2                	call   *%edx
  80167f:	83 c4 10             	add    $0x10,%esp
}
  801682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801685:	c9                   	leave  
  801686:	c3                   	ret    
			thisenv->env_id, fdnum);
  801687:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80168c:	8b 40 48             	mov    0x48(%eax),%eax
  80168f:	83 ec 04             	sub    $0x4,%esp
  801692:	53                   	push   %ebx
  801693:	50                   	push   %eax
  801694:	68 2c 2b 80 00       	push   $0x802b2c
  801699:	e8 0a ef ff ff       	call   8005a8 <cprintf>
		return -E_INVAL;
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a6:	eb da                	jmp    801682 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ad:	eb d3                	jmp    801682 <ftruncate+0x52>

008016af <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	53                   	push   %ebx
  8016b3:	83 ec 14             	sub    $0x14,%esp
  8016b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bc:	50                   	push   %eax
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 81 fb ff ff       	call   801246 <fd_lookup>
  8016c5:	83 c4 08             	add    $0x8,%esp
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	78 4b                	js     801717 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cc:	83 ec 08             	sub    $0x8,%esp
  8016cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d2:	50                   	push   %eax
  8016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d6:	ff 30                	pushl  (%eax)
  8016d8:	e8 bf fb ff ff       	call   80129c <dev_lookup>
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 33                	js     801717 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016eb:	74 2f                	je     80171c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016ed:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016f0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f7:	00 00 00 
	stat->st_isdir = 0;
  8016fa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801701:	00 00 00 
	stat->st_dev = dev;
  801704:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	53                   	push   %ebx
  80170e:	ff 75 f0             	pushl  -0x10(%ebp)
  801711:	ff 50 14             	call   *0x14(%eax)
  801714:	83 c4 10             	add    $0x10,%esp
}
  801717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    
		return -E_NOT_SUPP;
  80171c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801721:	eb f4                	jmp    801717 <fstat+0x68>

00801723 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	6a 00                	push   $0x0
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	e8 e7 01 00 00       	call   80191c <open>
  801735:	89 c3                	mov    %eax,%ebx
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 1b                	js     801759 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	50                   	push   %eax
  801745:	e8 65 ff ff ff       	call   8016af <fstat>
  80174a:	89 c6                	mov    %eax,%esi
	close(fd);
  80174c:	89 1c 24             	mov    %ebx,(%esp)
  80174f:	e8 27 fc ff ff       	call   80137b <close>
	return r;
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	89 f3                	mov    %esi,%ebx
}
  801759:	89 d8                	mov    %ebx,%eax
  80175b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175e:	5b                   	pop    %ebx
  80175f:	5e                   	pop    %esi
  801760:	5d                   	pop    %ebp
  801761:	c3                   	ret    

00801762 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	56                   	push   %esi
  801766:	53                   	push   %ebx
  801767:	89 c6                	mov    %eax,%esi
  801769:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80176b:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  801772:	74 27                	je     80179b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801774:	6a 07                	push   $0x7
  801776:	68 00 50 80 00       	push   $0x805000
  80177b:	56                   	push   %esi
  80177c:	ff 35 10 40 80 00    	pushl  0x804010
  801782:	e8 16 0c 00 00       	call   80239d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801787:	83 c4 0c             	add    $0xc,%esp
  80178a:	6a 00                	push   $0x0
  80178c:	53                   	push   %ebx
  80178d:	6a 00                	push   $0x0
  80178f:	e8 a2 0b 00 00       	call   802336 <ipc_recv>
}
  801794:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801797:	5b                   	pop    %ebx
  801798:	5e                   	pop    %esi
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	6a 01                	push   $0x1
  8017a0:	e8 4c 0c 00 00       	call   8023f1 <ipc_find_env>
  8017a5:	a3 10 40 80 00       	mov    %eax,0x804010
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	eb c5                	jmp    801774 <fsipc+0x12>

008017af <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cd:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d2:	e8 8b ff ff ff       	call   801762 <fsipc>
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <devfile_flush>:
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f4:	e8 69 ff ff ff       	call   801762 <fsipc>
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <devfile_stat>:
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 04             	sub    $0x4,%esp
  801802:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8b 40 0c             	mov    0xc(%eax),%eax
  80180b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801810:	ba 00 00 00 00       	mov    $0x0,%edx
  801815:	b8 05 00 00 00       	mov    $0x5,%eax
  80181a:	e8 43 ff ff ff       	call   801762 <fsipc>
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 2c                	js     80184f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801823:	83 ec 08             	sub    $0x8,%esp
  801826:	68 00 50 80 00       	push   $0x805000
  80182b:	53                   	push   %ebx
  80182c:	e8 96 f3 ff ff       	call   800bc7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801831:	a1 80 50 80 00       	mov    0x805080,%eax
  801836:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80183c:	a1 84 50 80 00       	mov    0x805084,%eax
  801841:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <devfile_write>:
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 0c             	sub    $0xc,%esp
  80185a:	8b 45 10             	mov    0x10(%ebp),%eax
  80185d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801862:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801867:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80186a:	8b 55 08             	mov    0x8(%ebp),%edx
  80186d:	8b 52 0c             	mov    0xc(%edx),%edx
  801870:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801876:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80187b:	50                   	push   %eax
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	68 08 50 80 00       	push   $0x805008
  801884:	e8 cc f4 ff ff       	call   800d55 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801889:	ba 00 00 00 00       	mov    $0x0,%edx
  80188e:	b8 04 00 00 00       	mov    $0x4,%eax
  801893:	e8 ca fe ff ff       	call   801762 <fsipc>
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <devfile_read>:
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ad:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8018bd:	e8 a0 fe ff ff       	call   801762 <fsipc>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 1f                	js     8018e7 <devfile_read+0x4d>
	assert(r <= n);
  8018c8:	39 f0                	cmp    %esi,%eax
  8018ca:	77 24                	ja     8018f0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018d1:	7f 33                	jg     801906 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	50                   	push   %eax
  8018d7:	68 00 50 80 00       	push   $0x805000
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	e8 71 f4 ff ff       	call   800d55 <memmove>
	return r;
  8018e4:	83 c4 10             	add    $0x10,%esp
}
  8018e7:	89 d8                	mov    %ebx,%eax
  8018e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5e                   	pop    %esi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
	assert(r <= n);
  8018f0:	68 9c 2b 80 00       	push   $0x802b9c
  8018f5:	68 a3 2b 80 00       	push   $0x802ba3
  8018fa:	6a 7b                	push   $0x7b
  8018fc:	68 b8 2b 80 00       	push   $0x802bb8
  801901:	e8 ea 09 00 00       	call   8022f0 <_panic>
	assert(r <= PGSIZE);
  801906:	68 c3 2b 80 00       	push   $0x802bc3
  80190b:	68 a3 2b 80 00       	push   $0x802ba3
  801910:	6a 7c                	push   $0x7c
  801912:	68 b8 2b 80 00       	push   $0x802bb8
  801917:	e8 d4 09 00 00       	call   8022f0 <_panic>

0080191c <open>:
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	56                   	push   %esi
  801920:	53                   	push   %ebx
  801921:	83 ec 1c             	sub    $0x1c,%esp
  801924:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801927:	56                   	push   %esi
  801928:	e8 63 f2 ff ff       	call   800b90 <strlen>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801935:	7f 6c                	jg     8019a3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193d:	50                   	push   %eax
  80193e:	e8 b4 f8 ff ff       	call   8011f7 <fd_alloc>
  801943:	89 c3                	mov    %eax,%ebx
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 3c                	js     801988 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	56                   	push   %esi
  801950:	68 00 50 80 00       	push   $0x805000
  801955:	e8 6d f2 ff ff       	call   800bc7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801965:	b8 01 00 00 00       	mov    $0x1,%eax
  80196a:	e8 f3 fd ff ff       	call   801762 <fsipc>
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	78 19                	js     801991 <open+0x75>
	return fd2num(fd);
  801978:	83 ec 0c             	sub    $0xc,%esp
  80197b:	ff 75 f4             	pushl  -0xc(%ebp)
  80197e:	e8 4d f8 ff ff       	call   8011d0 <fd2num>
  801983:	89 c3                	mov    %eax,%ebx
  801985:	83 c4 10             	add    $0x10,%esp
}
  801988:	89 d8                	mov    %ebx,%eax
  80198a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5e                   	pop    %esi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    
		fd_close(fd, 0);
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	6a 00                	push   $0x0
  801996:	ff 75 f4             	pushl  -0xc(%ebp)
  801999:	e8 54 f9 ff ff       	call   8012f2 <fd_close>
		return r;
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	eb e5                	jmp    801988 <open+0x6c>
		return -E_BAD_PATH;
  8019a3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019a8:	eb de                	jmp    801988 <open+0x6c>

008019aa <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ba:	e8 a3 fd ff ff       	call   801762 <fsipc>
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019c7:	68 cf 2b 80 00       	push   $0x802bcf
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	e8 f3 f1 ff ff       	call   800bc7 <strcpy>
	return 0;
}
  8019d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <devsock_close>:
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	53                   	push   %ebx
  8019df:	83 ec 10             	sub    $0x10,%esp
  8019e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019e5:	53                   	push   %ebx
  8019e6:	e8 3f 0a 00 00       	call   80242a <pageref>
  8019eb:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019ee:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019f3:	83 f8 01             	cmp    $0x1,%eax
  8019f6:	74 07                	je     8019ff <devsock_close+0x24>
}
  8019f8:	89 d0                	mov    %edx,%eax
  8019fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	ff 73 0c             	pushl  0xc(%ebx)
  801a05:	e8 b7 02 00 00       	call   801cc1 <nsipc_close>
  801a0a:	89 c2                	mov    %eax,%edx
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	eb e7                	jmp    8019f8 <devsock_close+0x1d>

00801a11 <devsock_write>:
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 10             	pushl  0x10(%ebp)
  801a1c:	ff 75 0c             	pushl  0xc(%ebp)
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	ff 70 0c             	pushl  0xc(%eax)
  801a25:	e8 74 03 00 00       	call   801d9e <nsipc_send>
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <devsock_read>:
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 10             	pushl  0x10(%ebp)
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	ff 70 0c             	pushl  0xc(%eax)
  801a40:	e8 ed 02 00 00       	call   801d32 <nsipc_recv>
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <fd2sockid>:
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a4d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	e8 ef f7 ff ff       	call   801246 <fd_lookup>
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 10                	js     801a6e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801a67:	39 08                	cmp    %ecx,(%eax)
  801a69:	75 05                	jne    801a70 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a6b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    
		return -E_NOT_SUPP;
  801a70:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a75:	eb f7                	jmp    801a6e <fd2sockid+0x27>

00801a77 <alloc_sockfd>:
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
  801a7c:	83 ec 1c             	sub    $0x1c,%esp
  801a7f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a84:	50                   	push   %eax
  801a85:	e8 6d f7 ff ff       	call   8011f7 <fd_alloc>
  801a8a:	89 c3                	mov    %eax,%ebx
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 43                	js     801ad6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a93:	83 ec 04             	sub    $0x4,%esp
  801a96:	68 07 04 00 00       	push   $0x407
  801a9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9e:	6a 00                	push   $0x0
  801aa0:	e8 1b f5 ff ff       	call   800fc0 <sys_page_alloc>
  801aa5:	89 c3                	mov    %eax,%ebx
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 28                	js     801ad6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801ab7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ac3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ac6:	83 ec 0c             	sub    $0xc,%esp
  801ac9:	50                   	push   %eax
  801aca:	e8 01 f7 ff ff       	call   8011d0 <fd2num>
  801acf:	89 c3                	mov    %eax,%ebx
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	eb 0c                	jmp    801ae2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ad6:	83 ec 0c             	sub    $0xc,%esp
  801ad9:	56                   	push   %esi
  801ada:	e8 e2 01 00 00       	call   801cc1 <nsipc_close>
		return r;
  801adf:	83 c4 10             	add    $0x10,%esp
}
  801ae2:	89 d8                	mov    %ebx,%eax
  801ae4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <accept>:
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	e8 4e ff ff ff       	call   801a47 <fd2sockid>
  801af9:	85 c0                	test   %eax,%eax
  801afb:	78 1b                	js     801b18 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	ff 75 10             	pushl  0x10(%ebp)
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	e8 0e 01 00 00       	call   801c1a <nsipc_accept>
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	78 05                	js     801b18 <accept+0x2d>
	return alloc_sockfd(r);
  801b13:	e8 5f ff ff ff       	call   801a77 <alloc_sockfd>
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <bind>:
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	e8 1f ff ff ff       	call   801a47 <fd2sockid>
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 12                	js     801b3e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	ff 75 10             	pushl  0x10(%ebp)
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	50                   	push   %eax
  801b36:	e8 2f 01 00 00       	call   801c6a <nsipc_bind>
  801b3b:	83 c4 10             	add    $0x10,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <shutdown>:
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	e8 f9 fe ff ff       	call   801a47 <fd2sockid>
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 0f                	js     801b61 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b52:	83 ec 08             	sub    $0x8,%esp
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	50                   	push   %eax
  801b59:	e8 41 01 00 00       	call   801c9f <nsipc_shutdown>
  801b5e:	83 c4 10             	add    $0x10,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <connect>:
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	e8 d6 fe ff ff       	call   801a47 <fd2sockid>
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 12                	js     801b87 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	ff 75 10             	pushl  0x10(%ebp)
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	50                   	push   %eax
  801b7f:	e8 57 01 00 00       	call   801cdb <nsipc_connect>
  801b84:	83 c4 10             	add    $0x10,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <listen>:
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	e8 b0 fe ff ff       	call   801a47 <fd2sockid>
  801b97:	85 c0                	test   %eax,%eax
  801b99:	78 0f                	js     801baa <listen+0x21>
	return nsipc_listen(r, backlog);
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	50                   	push   %eax
  801ba2:	e8 69 01 00 00       	call   801d10 <nsipc_listen>
  801ba7:	83 c4 10             	add    $0x10,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <socket>:

int
socket(int domain, int type, int protocol)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bb2:	ff 75 10             	pushl  0x10(%ebp)
  801bb5:	ff 75 0c             	pushl  0xc(%ebp)
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	e8 3c 02 00 00       	call   801dfc <nsipc_socket>
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 05                	js     801bcc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bc7:	e8 ab fe ff ff       	call   801a77 <alloc_sockfd>
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bd7:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801bde:	74 26                	je     801c06 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801be0:	6a 07                	push   $0x7
  801be2:	68 00 60 80 00       	push   $0x806000
  801be7:	53                   	push   %ebx
  801be8:	ff 35 14 40 80 00    	pushl  0x804014
  801bee:	e8 aa 07 00 00       	call   80239d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf3:	83 c4 0c             	add    $0xc,%esp
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	e8 35 07 00 00       	call   802336 <ipc_recv>
}
  801c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c06:	83 ec 0c             	sub    $0xc,%esp
  801c09:	6a 02                	push   $0x2
  801c0b:	e8 e1 07 00 00       	call   8023f1 <ipc_find_env>
  801c10:	a3 14 40 80 00       	mov    %eax,0x804014
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	eb c6                	jmp    801be0 <nsipc+0x12>

00801c1a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	56                   	push   %esi
  801c1e:	53                   	push   %ebx
  801c1f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c2a:	8b 06                	mov    (%esi),%eax
  801c2c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c31:	b8 01 00 00 00       	mov    $0x1,%eax
  801c36:	e8 93 ff ff ff       	call   801bce <nsipc>
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 20                	js     801c61 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	ff 35 10 60 80 00    	pushl  0x806010
  801c4a:	68 00 60 80 00       	push   $0x806000
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 fe f0 ff ff       	call   800d55 <memmove>
		*addrlen = ret->ret_addrlen;
  801c57:	a1 10 60 80 00       	mov    0x806010,%eax
  801c5c:	89 06                	mov    %eax,(%esi)
  801c5e:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c61:	89 d8                	mov    %ebx,%eax
  801c63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5e                   	pop    %esi
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    

00801c6a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	53                   	push   %ebx
  801c6e:	83 ec 08             	sub    $0x8,%esp
  801c71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c7c:	53                   	push   %ebx
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	68 04 60 80 00       	push   $0x806004
  801c85:	e8 cb f0 ff ff       	call   800d55 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c8a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c90:	b8 02 00 00 00       	mov    $0x2,%eax
  801c95:	e8 34 ff ff ff       	call   801bce <nsipc>
}
  801c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cb5:	b8 03 00 00 00       	mov    $0x3,%eax
  801cba:	e8 0f ff ff ff       	call   801bce <nsipc>
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <nsipc_close>:

int
nsipc_close(int s)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ccf:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd4:	e8 f5 fe ff ff       	call   801bce <nsipc>
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 08             	sub    $0x8,%esp
  801ce2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ced:	53                   	push   %ebx
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	68 04 60 80 00       	push   $0x806004
  801cf6:	e8 5a f0 ff ff       	call   800d55 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cfb:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d01:	b8 05 00 00 00       	mov    $0x5,%eax
  801d06:	e8 c3 fe ff ff       	call   801bce <nsipc>
}
  801d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d21:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d26:	b8 06 00 00 00       	mov    $0x6,%eax
  801d2b:	e8 9e fe ff ff       	call   801bce <nsipc>
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	56                   	push   %esi
  801d36:	53                   	push   %ebx
  801d37:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d42:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d50:	b8 07 00 00 00       	mov    $0x7,%eax
  801d55:	e8 74 fe ff ff       	call   801bce <nsipc>
  801d5a:	89 c3                	mov    %eax,%ebx
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 1f                	js     801d7f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d60:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d65:	7f 21                	jg     801d88 <nsipc_recv+0x56>
  801d67:	39 c6                	cmp    %eax,%esi
  801d69:	7c 1d                	jl     801d88 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	50                   	push   %eax
  801d6f:	68 00 60 80 00       	push   $0x806000
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	e8 d9 ef ff ff       	call   800d55 <memmove>
  801d7c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d7f:	89 d8                	mov    %ebx,%eax
  801d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d88:	68 db 2b 80 00       	push   $0x802bdb
  801d8d:	68 a3 2b 80 00       	push   $0x802ba3
  801d92:	6a 62                	push   $0x62
  801d94:	68 f0 2b 80 00       	push   $0x802bf0
  801d99:	e8 52 05 00 00       	call   8022f0 <_panic>

00801d9e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	53                   	push   %ebx
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801db0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801db6:	7f 2e                	jg     801de6 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	53                   	push   %ebx
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	68 0c 60 80 00       	push   $0x80600c
  801dc4:	e8 8c ef ff ff       	call   800d55 <memmove>
	nsipcbuf.send.req_size = size;
  801dc9:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dcf:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dd7:	b8 08 00 00 00       	mov    $0x8,%eax
  801ddc:	e8 ed fd ff ff       	call   801bce <nsipc>
}
  801de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    
	assert(size < 1600);
  801de6:	68 fc 2b 80 00       	push   $0x802bfc
  801deb:	68 a3 2b 80 00       	push   $0x802ba3
  801df0:	6a 6d                	push   $0x6d
  801df2:	68 f0 2b 80 00       	push   $0x802bf0
  801df7:	e8 f4 04 00 00       	call   8022f0 <_panic>

00801dfc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e12:	8b 45 10             	mov    0x10(%ebp),%eax
  801e15:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e1a:	b8 09 00 00 00       	mov    $0x9,%eax
  801e1f:	e8 aa fd ff ff       	call   801bce <nsipc>
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e2e:	83 ec 0c             	sub    $0xc,%esp
  801e31:	ff 75 08             	pushl  0x8(%ebp)
  801e34:	e8 a7 f3 ff ff       	call   8011e0 <fd2data>
  801e39:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e3b:	83 c4 08             	add    $0x8,%esp
  801e3e:	68 08 2c 80 00       	push   $0x802c08
  801e43:	53                   	push   %ebx
  801e44:	e8 7e ed ff ff       	call   800bc7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e49:	8b 46 04             	mov    0x4(%esi),%eax
  801e4c:	2b 06                	sub    (%esi),%eax
  801e4e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e54:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e5b:	00 00 00 
	stat->st_dev = &devpipe;
  801e5e:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801e65:	30 80 00 
	return 0;
}
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5e                   	pop    %esi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    

00801e74 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	53                   	push   %ebx
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e7e:	53                   	push   %ebx
  801e7f:	6a 00                	push   $0x0
  801e81:	e8 bf f1 ff ff       	call   801045 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e86:	89 1c 24             	mov    %ebx,(%esp)
  801e89:	e8 52 f3 ff ff       	call   8011e0 <fd2data>
  801e8e:	83 c4 08             	add    $0x8,%esp
  801e91:	50                   	push   %eax
  801e92:	6a 00                	push   $0x0
  801e94:	e8 ac f1 ff ff       	call   801045 <sys_page_unmap>
}
  801e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <_pipeisclosed>:
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 1c             	sub    $0x1c,%esp
  801ea7:	89 c7                	mov    %eax,%edi
  801ea9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801eab:	a1 18 40 80 00       	mov    0x804018,%eax
  801eb0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	57                   	push   %edi
  801eb7:	e8 6e 05 00 00       	call   80242a <pageref>
  801ebc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ebf:	89 34 24             	mov    %esi,(%esp)
  801ec2:	e8 63 05 00 00       	call   80242a <pageref>
		nn = thisenv->env_runs;
  801ec7:	8b 15 18 40 80 00    	mov    0x804018,%edx
  801ecd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	39 cb                	cmp    %ecx,%ebx
  801ed5:	74 1b                	je     801ef2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ed7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eda:	75 cf                	jne    801eab <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801edc:	8b 42 58             	mov    0x58(%edx),%eax
  801edf:	6a 01                	push   $0x1
  801ee1:	50                   	push   %eax
  801ee2:	53                   	push   %ebx
  801ee3:	68 0f 2c 80 00       	push   $0x802c0f
  801ee8:	e8 bb e6 ff ff       	call   8005a8 <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	eb b9                	jmp    801eab <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ef2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ef5:	0f 94 c0             	sete   %al
  801ef8:	0f b6 c0             	movzbl %al,%eax
}
  801efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5e                   	pop    %esi
  801f00:	5f                   	pop    %edi
  801f01:	5d                   	pop    %ebp
  801f02:	c3                   	ret    

00801f03 <devpipe_write>:
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	57                   	push   %edi
  801f07:	56                   	push   %esi
  801f08:	53                   	push   %ebx
  801f09:	83 ec 28             	sub    $0x28,%esp
  801f0c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f0f:	56                   	push   %esi
  801f10:	e8 cb f2 ff ff       	call   8011e0 <fd2data>
  801f15:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f22:	74 4f                	je     801f73 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f24:	8b 43 04             	mov    0x4(%ebx),%eax
  801f27:	8b 0b                	mov    (%ebx),%ecx
  801f29:	8d 51 20             	lea    0x20(%ecx),%edx
  801f2c:	39 d0                	cmp    %edx,%eax
  801f2e:	72 14                	jb     801f44 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f30:	89 da                	mov    %ebx,%edx
  801f32:	89 f0                	mov    %esi,%eax
  801f34:	e8 65 ff ff ff       	call   801e9e <_pipeisclosed>
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	75 3a                	jne    801f77 <devpipe_write+0x74>
			sys_yield();
  801f3d:	e8 5f f0 ff ff       	call   800fa1 <sys_yield>
  801f42:	eb e0                	jmp    801f24 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f47:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f4b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f4e:	89 c2                	mov    %eax,%edx
  801f50:	c1 fa 1f             	sar    $0x1f,%edx
  801f53:	89 d1                	mov    %edx,%ecx
  801f55:	c1 e9 1b             	shr    $0x1b,%ecx
  801f58:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f5b:	83 e2 1f             	and    $0x1f,%edx
  801f5e:	29 ca                	sub    %ecx,%edx
  801f60:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f64:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f68:	83 c0 01             	add    $0x1,%eax
  801f6b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f6e:	83 c7 01             	add    $0x1,%edi
  801f71:	eb ac                	jmp    801f1f <devpipe_write+0x1c>
	return i;
  801f73:	89 f8                	mov    %edi,%eax
  801f75:	eb 05                	jmp    801f7c <devpipe_write+0x79>
				return 0;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7f:	5b                   	pop    %ebx
  801f80:	5e                   	pop    %esi
  801f81:	5f                   	pop    %edi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    

00801f84 <devpipe_read>:
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	57                   	push   %edi
  801f88:	56                   	push   %esi
  801f89:	53                   	push   %ebx
  801f8a:	83 ec 18             	sub    $0x18,%esp
  801f8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f90:	57                   	push   %edi
  801f91:	e8 4a f2 ff ff       	call   8011e0 <fd2data>
  801f96:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	be 00 00 00 00       	mov    $0x0,%esi
  801fa0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa3:	74 47                	je     801fec <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801fa5:	8b 03                	mov    (%ebx),%eax
  801fa7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801faa:	75 22                	jne    801fce <devpipe_read+0x4a>
			if (i > 0)
  801fac:	85 f6                	test   %esi,%esi
  801fae:	75 14                	jne    801fc4 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801fb0:	89 da                	mov    %ebx,%edx
  801fb2:	89 f8                	mov    %edi,%eax
  801fb4:	e8 e5 fe ff ff       	call   801e9e <_pipeisclosed>
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	75 33                	jne    801ff0 <devpipe_read+0x6c>
			sys_yield();
  801fbd:	e8 df ef ff ff       	call   800fa1 <sys_yield>
  801fc2:	eb e1                	jmp    801fa5 <devpipe_read+0x21>
				return i;
  801fc4:	89 f0                	mov    %esi,%eax
}
  801fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5f                   	pop    %edi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fce:	99                   	cltd   
  801fcf:	c1 ea 1b             	shr    $0x1b,%edx
  801fd2:	01 d0                	add    %edx,%eax
  801fd4:	83 e0 1f             	and    $0x1f,%eax
  801fd7:	29 d0                	sub    %edx,%eax
  801fd9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fe4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fe7:	83 c6 01             	add    $0x1,%esi
  801fea:	eb b4                	jmp    801fa0 <devpipe_read+0x1c>
	return i;
  801fec:	89 f0                	mov    %esi,%eax
  801fee:	eb d6                	jmp    801fc6 <devpipe_read+0x42>
				return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	eb cf                	jmp    801fc6 <devpipe_read+0x42>

00801ff7 <pipe>:
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	56                   	push   %esi
  801ffb:	53                   	push   %ebx
  801ffc:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802002:	50                   	push   %eax
  802003:	e8 ef f1 ff ff       	call   8011f7 <fd_alloc>
  802008:	89 c3                	mov    %eax,%ebx
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 5b                	js     80206c <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802011:	83 ec 04             	sub    $0x4,%esp
  802014:	68 07 04 00 00       	push   $0x407
  802019:	ff 75 f4             	pushl  -0xc(%ebp)
  80201c:	6a 00                	push   $0x0
  80201e:	e8 9d ef ff ff       	call   800fc0 <sys_page_alloc>
  802023:	89 c3                	mov    %eax,%ebx
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 40                	js     80206c <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802032:	50                   	push   %eax
  802033:	e8 bf f1 ff ff       	call   8011f7 <fd_alloc>
  802038:	89 c3                	mov    %eax,%ebx
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 1b                	js     80205c <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	68 07 04 00 00       	push   $0x407
  802049:	ff 75 f0             	pushl  -0x10(%ebp)
  80204c:	6a 00                	push   $0x0
  80204e:	e8 6d ef ff ff       	call   800fc0 <sys_page_alloc>
  802053:	89 c3                	mov    %eax,%ebx
  802055:	83 c4 10             	add    $0x10,%esp
  802058:	85 c0                	test   %eax,%eax
  80205a:	79 19                	jns    802075 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80205c:	83 ec 08             	sub    $0x8,%esp
  80205f:	ff 75 f4             	pushl  -0xc(%ebp)
  802062:	6a 00                	push   $0x0
  802064:	e8 dc ef ff ff       	call   801045 <sys_page_unmap>
  802069:	83 c4 10             	add    $0x10,%esp
}
  80206c:	89 d8                	mov    %ebx,%eax
  80206e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    
	va = fd2data(fd0);
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	ff 75 f4             	pushl  -0xc(%ebp)
  80207b:	e8 60 f1 ff ff       	call   8011e0 <fd2data>
  802080:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802082:	83 c4 0c             	add    $0xc,%esp
  802085:	68 07 04 00 00       	push   $0x407
  80208a:	50                   	push   %eax
  80208b:	6a 00                	push   $0x0
  80208d:	e8 2e ef ff ff       	call   800fc0 <sys_page_alloc>
  802092:	89 c3                	mov    %eax,%ebx
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	85 c0                	test   %eax,%eax
  802099:	0f 88 8c 00 00 00    	js     80212b <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209f:	83 ec 0c             	sub    $0xc,%esp
  8020a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a5:	e8 36 f1 ff ff       	call   8011e0 <fd2data>
  8020aa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020b1:	50                   	push   %eax
  8020b2:	6a 00                	push   $0x0
  8020b4:	56                   	push   %esi
  8020b5:	6a 00                	push   $0x0
  8020b7:	e8 47 ef ff ff       	call   801003 <sys_page_map>
  8020bc:	89 c3                	mov    %eax,%ebx
  8020be:	83 c4 20             	add    $0x20,%esp
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	78 58                	js     80211d <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8020ce:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8020da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020dd:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8020e3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020ef:	83 ec 0c             	sub    $0xc,%esp
  8020f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f5:	e8 d6 f0 ff ff       	call   8011d0 <fd2num>
  8020fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020fd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020ff:	83 c4 04             	add    $0x4,%esp
  802102:	ff 75 f0             	pushl  -0x10(%ebp)
  802105:	e8 c6 f0 ff ff       	call   8011d0 <fd2num>
  80210a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80210d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	bb 00 00 00 00       	mov    $0x0,%ebx
  802118:	e9 4f ff ff ff       	jmp    80206c <pipe+0x75>
	sys_page_unmap(0, va);
  80211d:	83 ec 08             	sub    $0x8,%esp
  802120:	56                   	push   %esi
  802121:	6a 00                	push   $0x0
  802123:	e8 1d ef ff ff       	call   801045 <sys_page_unmap>
  802128:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80212b:	83 ec 08             	sub    $0x8,%esp
  80212e:	ff 75 f0             	pushl  -0x10(%ebp)
  802131:	6a 00                	push   $0x0
  802133:	e8 0d ef ff ff       	call   801045 <sys_page_unmap>
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	e9 1c ff ff ff       	jmp    80205c <pipe+0x65>

00802140 <pipeisclosed>:
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802146:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802149:	50                   	push   %eax
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	e8 f4 f0 ff ff       	call   801246 <fd_lookup>
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	85 c0                	test   %eax,%eax
  802157:	78 18                	js     802171 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	ff 75 f4             	pushl  -0xc(%ebp)
  80215f:	e8 7c f0 ff ff       	call   8011e0 <fd2data>
	return _pipeisclosed(fd, p);
  802164:	89 c2                	mov    %eax,%edx
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	e8 30 fd ff ff       	call   801e9e <_pipeisclosed>
  80216e:	83 c4 10             	add    $0x10,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
  80217b:	5d                   	pop    %ebp
  80217c:	c3                   	ret    

0080217d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802183:	68 27 2c 80 00       	push   $0x802c27
  802188:	ff 75 0c             	pushl  0xc(%ebp)
  80218b:	e8 37 ea ff ff       	call   800bc7 <strcpy>
	return 0;
}
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <devcons_write>:
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	57                   	push   %edi
  80219b:	56                   	push   %esi
  80219c:	53                   	push   %ebx
  80219d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021a3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021a8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021ae:	eb 2f                	jmp    8021df <devcons_write+0x48>
		m = n - tot;
  8021b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021b3:	29 f3                	sub    %esi,%ebx
  8021b5:	83 fb 7f             	cmp    $0x7f,%ebx
  8021b8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021bd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	53                   	push   %ebx
  8021c4:	89 f0                	mov    %esi,%eax
  8021c6:	03 45 0c             	add    0xc(%ebp),%eax
  8021c9:	50                   	push   %eax
  8021ca:	57                   	push   %edi
  8021cb:	e8 85 eb ff ff       	call   800d55 <memmove>
		sys_cputs(buf, m);
  8021d0:	83 c4 08             	add    $0x8,%esp
  8021d3:	53                   	push   %ebx
  8021d4:	57                   	push   %edi
  8021d5:	e8 2a ed ff ff       	call   800f04 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021da:	01 de                	add    %ebx,%esi
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021e2:	72 cc                	jb     8021b0 <devcons_write+0x19>
}
  8021e4:	89 f0                	mov    %esi,%eax
  8021e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e9:	5b                   	pop    %ebx
  8021ea:	5e                   	pop    %esi
  8021eb:	5f                   	pop    %edi
  8021ec:	5d                   	pop    %ebp
  8021ed:	c3                   	ret    

008021ee <devcons_read>:
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 08             	sub    $0x8,%esp
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021fd:	75 07                	jne    802206 <devcons_read+0x18>
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    
		sys_yield();
  802201:	e8 9b ed ff ff       	call   800fa1 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802206:	e8 17 ed ff ff       	call   800f22 <sys_cgetc>
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 f2                	je     802201 <devcons_read+0x13>
	if (c < 0)
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 ec                	js     8021ff <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802213:	83 f8 04             	cmp    $0x4,%eax
  802216:	74 0c                	je     802224 <devcons_read+0x36>
	*(char*)vbuf = c;
  802218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221b:	88 02                	mov    %al,(%edx)
	return 1;
  80221d:	b8 01 00 00 00       	mov    $0x1,%eax
  802222:	eb db                	jmp    8021ff <devcons_read+0x11>
		return 0;
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
  802229:	eb d4                	jmp    8021ff <devcons_read+0x11>

0080222b <cputchar>:
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802237:	6a 01                	push   $0x1
  802239:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223c:	50                   	push   %eax
  80223d:	e8 c2 ec ff ff       	call   800f04 <sys_cputs>
}
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <getchar>:
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80224d:	6a 01                	push   $0x1
  80224f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802252:	50                   	push   %eax
  802253:	6a 00                	push   $0x0
  802255:	e8 5d f2 ff ff       	call   8014b7 <read>
	if (r < 0)
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 08                	js     802269 <getchar+0x22>
	if (r < 1)
  802261:	85 c0                	test   %eax,%eax
  802263:	7e 06                	jle    80226b <getchar+0x24>
	return c;
  802265:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    
		return -E_EOF;
  80226b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802270:	eb f7                	jmp    802269 <getchar+0x22>

00802272 <iscons>:
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802278:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227b:	50                   	push   %eax
  80227c:	ff 75 08             	pushl  0x8(%ebp)
  80227f:	e8 c2 ef ff ff       	call   801246 <fd_lookup>
  802284:	83 c4 10             	add    $0x10,%esp
  802287:	85 c0                	test   %eax,%eax
  802289:	78 11                	js     80229c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802294:	39 10                	cmp    %edx,(%eax)
  802296:	0f 94 c0             	sete   %al
  802299:	0f b6 c0             	movzbl %al,%eax
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <opencons>:
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a7:	50                   	push   %eax
  8022a8:	e8 4a ef ff ff       	call   8011f7 <fd_alloc>
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	78 3a                	js     8022ee <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 07 04 00 00       	push   $0x407
  8022bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8022bf:	6a 00                	push   $0x0
  8022c1:	e8 fa ec ff ff       	call   800fc0 <sys_page_alloc>
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 21                	js     8022ee <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8022d6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022e2:	83 ec 0c             	sub    $0xc,%esp
  8022e5:	50                   	push   %eax
  8022e6:	e8 e5 ee ff ff       	call   8011d0 <fd2num>
  8022eb:	83 c4 10             	add    $0x10,%esp
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	56                   	push   %esi
  8022f4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8022f5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022f8:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8022fe:	e8 7f ec ff ff       	call   800f82 <sys_getenvid>
  802303:	83 ec 0c             	sub    $0xc,%esp
  802306:	ff 75 0c             	pushl  0xc(%ebp)
  802309:	ff 75 08             	pushl  0x8(%ebp)
  80230c:	56                   	push   %esi
  80230d:	50                   	push   %eax
  80230e:	68 34 2c 80 00       	push   $0x802c34
  802313:	e8 90 e2 ff ff       	call   8005a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802318:	83 c4 18             	add    $0x18,%esp
  80231b:	53                   	push   %ebx
  80231c:	ff 75 10             	pushl  0x10(%ebp)
  80231f:	e8 33 e2 ff ff       	call   800557 <vcprintf>
	cprintf("\n");
  802324:	c7 04 24 74 27 80 00 	movl   $0x802774,(%esp)
  80232b:	e8 78 e2 ff ff       	call   8005a8 <cprintf>
  802330:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802333:	cc                   	int3   
  802334:	eb fd                	jmp    802333 <_panic+0x43>

00802336 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	56                   	push   %esi
  80233a:	53                   	push   %ebx
  80233b:	8b 75 08             	mov    0x8(%ebp),%esi
  80233e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802341:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802344:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802346:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80234b:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  80234e:	83 ec 0c             	sub    $0xc,%esp
  802351:	50                   	push   %eax
  802352:	e8 19 ee ff ff       	call   801170 <sys_ipc_recv>
	if (from_env_store)
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	85 f6                	test   %esi,%esi
  80235c:	74 14                	je     802372 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  80235e:	ba 00 00 00 00       	mov    $0x0,%edx
  802363:	85 c0                	test   %eax,%eax
  802365:	78 09                	js     802370 <ipc_recv+0x3a>
  802367:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80236d:	8b 52 74             	mov    0x74(%edx),%edx
  802370:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802372:	85 db                	test   %ebx,%ebx
  802374:	74 14                	je     80238a <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802376:	ba 00 00 00 00       	mov    $0x0,%edx
  80237b:	85 c0                	test   %eax,%eax
  80237d:	78 09                	js     802388 <ipc_recv+0x52>
  80237f:	8b 15 18 40 80 00    	mov    0x804018,%edx
  802385:	8b 52 78             	mov    0x78(%edx),%edx
  802388:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80238a:	85 c0                	test   %eax,%eax
  80238c:	78 08                	js     802396 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  80238e:	a1 18 40 80 00       	mov    0x804018,%eax
  802393:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802396:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802399:	5b                   	pop    %ebx
  80239a:	5e                   	pop    %esi
  80239b:	5d                   	pop    %ebp
  80239c:	c3                   	ret    

0080239d <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	57                   	push   %edi
  8023a1:	56                   	push   %esi
  8023a2:	53                   	push   %ebx
  8023a3:	83 ec 0c             	sub    $0xc,%esp
  8023a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023af:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8023b1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023b6:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8023b9:	ff 75 14             	pushl  0x14(%ebp)
  8023bc:	53                   	push   %ebx
  8023bd:	56                   	push   %esi
  8023be:	57                   	push   %edi
  8023bf:	e8 89 ed ff ff       	call   80114d <sys_ipc_try_send>
		if (ret == 0)
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 1e                	je     8023e9 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  8023cb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023ce:	75 07                	jne    8023d7 <ipc_send+0x3a>
			sys_yield();
  8023d0:	e8 cc eb ff ff       	call   800fa1 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8023d5:	eb e2                	jmp    8023b9 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  8023d7:	50                   	push   %eax
  8023d8:	68 58 2c 80 00       	push   $0x802c58
  8023dd:	6a 3d                	push   $0x3d
  8023df:	68 6c 2c 80 00       	push   $0x802c6c
  8023e4:	e8 07 ff ff ff       	call   8022f0 <_panic>
	}
	// panic("ipc_send not implemented");
}
  8023e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    

008023f1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023fc:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023ff:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802405:	8b 52 50             	mov    0x50(%edx),%edx
  802408:	39 ca                	cmp    %ecx,%edx
  80240a:	74 11                	je     80241d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80240c:	83 c0 01             	add    $0x1,%eax
  80240f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802414:	75 e6                	jne    8023fc <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	eb 0b                	jmp    802428 <ipc_find_env+0x37>
			return envs[i].env_id;
  80241d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802420:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802425:	8b 40 48             	mov    0x48(%eax),%eax
}
  802428:	5d                   	pop    %ebp
  802429:	c3                   	ret    

0080242a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
  80242d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802430:	89 d0                	mov    %edx,%eax
  802432:	c1 e8 16             	shr    $0x16,%eax
  802435:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802441:	f6 c1 01             	test   $0x1,%cl
  802444:	74 1d                	je     802463 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802446:	c1 ea 0c             	shr    $0xc,%edx
  802449:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802450:	f6 c2 01             	test   $0x1,%dl
  802453:	74 0e                	je     802463 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802455:	c1 ea 0c             	shr    $0xc,%edx
  802458:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80245f:	ef 
  802460:	0f b7 c0             	movzwl %ax,%eax
}
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    
  802465:	66 90                	xchg   %ax,%ax
  802467:	66 90                	xchg   %ax,%ax
  802469:	66 90                	xchg   %ax,%ax
  80246b:	66 90                	xchg   %ax,%ax
  80246d:	66 90                	xchg   %ax,%ax
  80246f:	90                   	nop

00802470 <__udivdi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	53                   	push   %ebx
  802474:	83 ec 1c             	sub    $0x1c,%esp
  802477:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80247b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80247f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802483:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802487:	85 d2                	test   %edx,%edx
  802489:	75 35                	jne    8024c0 <__udivdi3+0x50>
  80248b:	39 f3                	cmp    %esi,%ebx
  80248d:	0f 87 bd 00 00 00    	ja     802550 <__udivdi3+0xe0>
  802493:	85 db                	test   %ebx,%ebx
  802495:	89 d9                	mov    %ebx,%ecx
  802497:	75 0b                	jne    8024a4 <__udivdi3+0x34>
  802499:	b8 01 00 00 00       	mov    $0x1,%eax
  80249e:	31 d2                	xor    %edx,%edx
  8024a0:	f7 f3                	div    %ebx
  8024a2:	89 c1                	mov    %eax,%ecx
  8024a4:	31 d2                	xor    %edx,%edx
  8024a6:	89 f0                	mov    %esi,%eax
  8024a8:	f7 f1                	div    %ecx
  8024aa:	89 c6                	mov    %eax,%esi
  8024ac:	89 e8                	mov    %ebp,%eax
  8024ae:	89 f7                	mov    %esi,%edi
  8024b0:	f7 f1                	div    %ecx
  8024b2:	89 fa                	mov    %edi,%edx
  8024b4:	83 c4 1c             	add    $0x1c,%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5f                   	pop    %edi
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    
  8024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024c0:	39 f2                	cmp    %esi,%edx
  8024c2:	77 7c                	ja     802540 <__udivdi3+0xd0>
  8024c4:	0f bd fa             	bsr    %edx,%edi
  8024c7:	83 f7 1f             	xor    $0x1f,%edi
  8024ca:	0f 84 98 00 00 00    	je     802568 <__udivdi3+0xf8>
  8024d0:	89 f9                	mov    %edi,%ecx
  8024d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024d7:	29 f8                	sub    %edi,%eax
  8024d9:	d3 e2                	shl    %cl,%edx
  8024db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024df:	89 c1                	mov    %eax,%ecx
  8024e1:	89 da                	mov    %ebx,%edx
  8024e3:	d3 ea                	shr    %cl,%edx
  8024e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e9:	09 d1                	or     %edx,%ecx
  8024eb:	89 f2                	mov    %esi,%edx
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 f9                	mov    %edi,%ecx
  8024f3:	d3 e3                	shl    %cl,%ebx
  8024f5:	89 c1                	mov    %eax,%ecx
  8024f7:	d3 ea                	shr    %cl,%edx
  8024f9:	89 f9                	mov    %edi,%ecx
  8024fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024ff:	d3 e6                	shl    %cl,%esi
  802501:	89 eb                	mov    %ebp,%ebx
  802503:	89 c1                	mov    %eax,%ecx
  802505:	d3 eb                	shr    %cl,%ebx
  802507:	09 de                	or     %ebx,%esi
  802509:	89 f0                	mov    %esi,%eax
  80250b:	f7 74 24 08          	divl   0x8(%esp)
  80250f:	89 d6                	mov    %edx,%esi
  802511:	89 c3                	mov    %eax,%ebx
  802513:	f7 64 24 0c          	mull   0xc(%esp)
  802517:	39 d6                	cmp    %edx,%esi
  802519:	72 0c                	jb     802527 <__udivdi3+0xb7>
  80251b:	89 f9                	mov    %edi,%ecx
  80251d:	d3 e5                	shl    %cl,%ebp
  80251f:	39 c5                	cmp    %eax,%ebp
  802521:	73 5d                	jae    802580 <__udivdi3+0x110>
  802523:	39 d6                	cmp    %edx,%esi
  802525:	75 59                	jne    802580 <__udivdi3+0x110>
  802527:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80252a:	31 ff                	xor    %edi,%edi
  80252c:	89 fa                	mov    %edi,%edx
  80252e:	83 c4 1c             	add    $0x1c,%esp
  802531:	5b                   	pop    %ebx
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    
  802536:	8d 76 00             	lea    0x0(%esi),%esi
  802539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802540:	31 ff                	xor    %edi,%edi
  802542:	31 c0                	xor    %eax,%eax
  802544:	89 fa                	mov    %edi,%edx
  802546:	83 c4 1c             	add    $0x1c,%esp
  802549:	5b                   	pop    %ebx
  80254a:	5e                   	pop    %esi
  80254b:	5f                   	pop    %edi
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    
  80254e:	66 90                	xchg   %ax,%ax
  802550:	31 ff                	xor    %edi,%edi
  802552:	89 e8                	mov    %ebp,%eax
  802554:	89 f2                	mov    %esi,%edx
  802556:	f7 f3                	div    %ebx
  802558:	89 fa                	mov    %edi,%edx
  80255a:	83 c4 1c             	add    $0x1c,%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5e                   	pop    %esi
  80255f:	5f                   	pop    %edi
  802560:	5d                   	pop    %ebp
  802561:	c3                   	ret    
  802562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802568:	39 f2                	cmp    %esi,%edx
  80256a:	72 06                	jb     802572 <__udivdi3+0x102>
  80256c:	31 c0                	xor    %eax,%eax
  80256e:	39 eb                	cmp    %ebp,%ebx
  802570:	77 d2                	ja     802544 <__udivdi3+0xd4>
  802572:	b8 01 00 00 00       	mov    $0x1,%eax
  802577:	eb cb                	jmp    802544 <__udivdi3+0xd4>
  802579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802580:	89 d8                	mov    %ebx,%eax
  802582:	31 ff                	xor    %edi,%edi
  802584:	eb be                	jmp    802544 <__udivdi3+0xd4>
  802586:	66 90                	xchg   %ax,%ax
  802588:	66 90                	xchg   %ax,%ax
  80258a:	66 90                	xchg   %ax,%ax
  80258c:	66 90                	xchg   %ax,%ax
  80258e:	66 90                	xchg   %ax,%ax

00802590 <__umoddi3>:
  802590:	55                   	push   %ebp
  802591:	57                   	push   %edi
  802592:	56                   	push   %esi
  802593:	53                   	push   %ebx
  802594:	83 ec 1c             	sub    $0x1c,%esp
  802597:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80259b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80259f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025a7:	85 ed                	test   %ebp,%ebp
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	89 da                	mov    %ebx,%edx
  8025ad:	75 19                	jne    8025c8 <__umoddi3+0x38>
  8025af:	39 df                	cmp    %ebx,%edi
  8025b1:	0f 86 b1 00 00 00    	jbe    802668 <__umoddi3+0xd8>
  8025b7:	f7 f7                	div    %edi
  8025b9:	89 d0                	mov    %edx,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	83 c4 1c             	add    $0x1c,%esp
  8025c0:	5b                   	pop    %ebx
  8025c1:	5e                   	pop    %esi
  8025c2:	5f                   	pop    %edi
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    
  8025c5:	8d 76 00             	lea    0x0(%esi),%esi
  8025c8:	39 dd                	cmp    %ebx,%ebp
  8025ca:	77 f1                	ja     8025bd <__umoddi3+0x2d>
  8025cc:	0f bd cd             	bsr    %ebp,%ecx
  8025cf:	83 f1 1f             	xor    $0x1f,%ecx
  8025d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025d6:	0f 84 b4 00 00 00    	je     802690 <__umoddi3+0x100>
  8025dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8025e1:	89 c2                	mov    %eax,%edx
  8025e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025e7:	29 c2                	sub    %eax,%edx
  8025e9:	89 c1                	mov    %eax,%ecx
  8025eb:	89 f8                	mov    %edi,%eax
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	89 d1                	mov    %edx,%ecx
  8025f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8025f5:	d3 e8                	shr    %cl,%eax
  8025f7:	09 c5                	or     %eax,%ebp
  8025f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025fd:	89 c1                	mov    %eax,%ecx
  8025ff:	d3 e7                	shl    %cl,%edi
  802601:	89 d1                	mov    %edx,%ecx
  802603:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802607:	89 df                	mov    %ebx,%edi
  802609:	d3 ef                	shr    %cl,%edi
  80260b:	89 c1                	mov    %eax,%ecx
  80260d:	89 f0                	mov    %esi,%eax
  80260f:	d3 e3                	shl    %cl,%ebx
  802611:	89 d1                	mov    %edx,%ecx
  802613:	89 fa                	mov    %edi,%edx
  802615:	d3 e8                	shr    %cl,%eax
  802617:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261c:	09 d8                	or     %ebx,%eax
  80261e:	f7 f5                	div    %ebp
  802620:	d3 e6                	shl    %cl,%esi
  802622:	89 d1                	mov    %edx,%ecx
  802624:	f7 64 24 08          	mull   0x8(%esp)
  802628:	39 d1                	cmp    %edx,%ecx
  80262a:	89 c3                	mov    %eax,%ebx
  80262c:	89 d7                	mov    %edx,%edi
  80262e:	72 06                	jb     802636 <__umoddi3+0xa6>
  802630:	75 0e                	jne    802640 <__umoddi3+0xb0>
  802632:	39 c6                	cmp    %eax,%esi
  802634:	73 0a                	jae    802640 <__umoddi3+0xb0>
  802636:	2b 44 24 08          	sub    0x8(%esp),%eax
  80263a:	19 ea                	sbb    %ebp,%edx
  80263c:	89 d7                	mov    %edx,%edi
  80263e:	89 c3                	mov    %eax,%ebx
  802640:	89 ca                	mov    %ecx,%edx
  802642:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802647:	29 de                	sub    %ebx,%esi
  802649:	19 fa                	sbb    %edi,%edx
  80264b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80264f:	89 d0                	mov    %edx,%eax
  802651:	d3 e0                	shl    %cl,%eax
  802653:	89 d9                	mov    %ebx,%ecx
  802655:	d3 ee                	shr    %cl,%esi
  802657:	d3 ea                	shr    %cl,%edx
  802659:	09 f0                	or     %esi,%eax
  80265b:	83 c4 1c             	add    $0x1c,%esp
  80265e:	5b                   	pop    %ebx
  80265f:	5e                   	pop    %esi
  802660:	5f                   	pop    %edi
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    
  802663:	90                   	nop
  802664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802668:	85 ff                	test   %edi,%edi
  80266a:	89 f9                	mov    %edi,%ecx
  80266c:	75 0b                	jne    802679 <__umoddi3+0xe9>
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	f7 f7                	div    %edi
  802677:	89 c1                	mov    %eax,%ecx
  802679:	89 d8                	mov    %ebx,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f1                	div    %ecx
  80267f:	89 f0                	mov    %esi,%eax
  802681:	f7 f1                	div    %ecx
  802683:	e9 31 ff ff ff       	jmp    8025b9 <__umoddi3+0x29>
  802688:	90                   	nop
  802689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802690:	39 dd                	cmp    %ebx,%ebp
  802692:	72 08                	jb     80269c <__umoddi3+0x10c>
  802694:	39 f7                	cmp    %esi,%edi
  802696:	0f 87 21 ff ff ff    	ja     8025bd <__umoddi3+0x2d>
  80269c:	89 da                	mov    %ebx,%edx
  80269e:	89 f0                	mov    %esi,%eax
  8026a0:	29 f8                	sub    %edi,%eax
  8026a2:	19 ea                	sbb    %ebp,%edx
  8026a4:	e9 14 ff ff ff       	jmp    8025bd <__umoddi3+0x2d>

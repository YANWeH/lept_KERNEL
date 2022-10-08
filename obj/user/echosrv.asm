
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 a0 04 00 00       	call   8004d1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 30 27 80 00       	push   $0x802730
  80003f:	e8 82 05 00 00       	call   8005c6 <cprintf>
	exit();
  800044:	e8 ce 04 00 00       	call   800517 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:

void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 30             	sub    $0x30,%esp
  800057:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005a:	6a 20                	push   $0x20
  80005c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	56                   	push   %esi
  800061:	e8 6f 14 00 00       	call   8014d5 <read>
  800066:	89 c3                	mov    %eax,%ebx
  800068:	83 c4 10             	add    $0x10,%esp
  80006b:	85 c0                	test   %eax,%eax
  80006d:	78 05                	js     800074 <handle_client+0x26>
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80006f:	8d 7d c8             	lea    -0x38(%ebp),%edi
  800072:	eb 21                	jmp    800095 <handle_client+0x47>
		die("Failed to receive initial bytes from client");
  800074:	b8 34 27 80 00       	mov    $0x802734,%eax
  800079:	e8 b5 ff ff ff       	call   800033 <die>
  80007e:	eb ef                	jmp    80006f <handle_client+0x21>
			die("Failed to send bytes to client");

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	6a 20                	push   $0x20
  800085:	57                   	push   %edi
  800086:	56                   	push   %esi
  800087:	e8 49 14 00 00       	call   8014d5 <read>
  80008c:	89 c3                	mov    %eax,%ebx
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	85 c0                	test   %eax,%eax
  800093:	78 22                	js     8000b7 <handle_client+0x69>
	while (received > 0) {
  800095:	85 db                	test   %ebx,%ebx
  800097:	7e 2a                	jle    8000c3 <handle_client+0x75>
		if (write(sock, buffer, received) != received)
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	53                   	push   %ebx
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	e8 ff 14 00 00       	call   8015a3 <write>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	39 d8                	cmp    %ebx,%eax
  8000a9:	74 d5                	je     800080 <handle_client+0x32>
			die("Failed to send bytes to client");
  8000ab:	b8 60 27 80 00       	mov    $0x802760,%eax
  8000b0:	e8 7e ff ff ff       	call   800033 <die>
  8000b5:	eb c9                	jmp    800080 <handle_client+0x32>
			die("Failed to receive additional bytes from client");
  8000b7:	b8 80 27 80 00       	mov    $0x802780,%eax
  8000bc:	e8 72 ff ff ff       	call   800033 <die>
  8000c1:	eb d2                	jmp    800095 <handle_client+0x47>
	}
	close(sock);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	56                   	push   %esi
  8000c7:	e8 cd 12 00 00       	call   801399 <close>
}
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <umain>:

void
umain(int argc, char **argv)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 40             	sub    $0x40,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e0:	6a 06                	push   $0x6
  8000e2:	6a 01                	push   $0x1
  8000e4:	6a 02                	push   $0x2
  8000e6:	e8 df 1a 00 00       	call   801bca <socket>
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	0f 88 86 00 00 00    	js     80017e <umain+0xa7>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	68 f8 26 80 00       	push   $0x8026f8
  800100:	e8 c1 04 00 00       	call   8005c6 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800105:	83 c4 0c             	add    $0xc,%esp
  800108:	6a 10                	push   $0x10
  80010a:	6a 00                	push   $0x0
  80010c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80010f:	53                   	push   %ebx
  800110:	e8 11 0c 00 00       	call   800d26 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800115:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800119:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800120:	e8 7e 01 00 00       	call   8002a3 <htonl>
  800125:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  800128:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80012f:	e8 55 01 00 00       	call   800289 <htons>
  800134:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  800138:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80013f:	e8 82 04 00 00       	call   8005c6 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800144:	83 c4 0c             	add    $0xc,%esp
  800147:	6a 10                	push   $0x10
  800149:	53                   	push   %ebx
  80014a:	56                   	push   %esi
  80014b:	e8 e8 19 00 00       	call   801b38 <bind>
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	85 c0                	test   %eax,%eax
  800155:	78 36                	js     80018d <umain+0xb6>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	6a 05                	push   $0x5
  80015c:	56                   	push   %esi
  80015d:	e8 45 1a 00 00       	call   801ba7 <listen>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	85 c0                	test   %eax,%eax
  800167:	78 30                	js     800199 <umain+0xc2>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 17 27 80 00       	push   $0x802717
  800171:	e8 50 04 00 00       	call   8005c6 <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  800179:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  80017c:	eb 4b                	jmp    8001c9 <umain+0xf2>
		die("Failed to create socket");
  80017e:	b8 e0 26 80 00       	mov    $0x8026e0,%eax
  800183:	e8 ab fe ff ff       	call   800033 <die>
  800188:	e9 6b ff ff ff       	jmp    8000f8 <umain+0x21>
		die("Failed to bind the server socket");
  80018d:	b8 b0 27 80 00       	mov    $0x8027b0,%eax
  800192:	e8 9c fe ff ff       	call   800033 <die>
  800197:	eb be                	jmp    800157 <umain+0x80>
		die("Failed to listen on server socket");
  800199:	b8 d4 27 80 00       	mov    $0x8027d4,%eax
  80019e:	e8 90 fe ff ff       	call   800033 <die>
  8001a3:	eb c4                	jmp    800169 <umain+0x92>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ab:	e8 43 00 00 00       	call   8001f3 <inet_ntoa>
  8001b0:	83 c4 08             	add    $0x8,%esp
  8001b3:	50                   	push   %eax
  8001b4:	68 1e 27 80 00       	push   $0x80271e
  8001b9:	e8 08 04 00 00       	call   8005c6 <cprintf>
		handle_client(clientsock);
  8001be:	89 1c 24             	mov    %ebx,(%esp)
  8001c1:	e8 88 fe ff ff       	call   80004e <handle_client>
	while (1) {
  8001c6:	83 c4 10             	add    $0x10,%esp
		unsigned int clientlen = sizeof(echoclient);
  8001c9:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock =
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	57                   	push   %edi
  8001d4:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001d7:	50                   	push   %eax
  8001d8:	56                   	push   %esi
  8001d9:	e8 2b 19 00 00       	call   801b09 <accept>
  8001de:	89 c3                	mov    %eax,%ebx
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	85 c0                	test   %eax,%eax
  8001e5:	79 be                	jns    8001a5 <umain+0xce>
			die("Failed to accept client connection");
  8001e7:	b8 f8 27 80 00       	mov    $0x8027f8,%eax
  8001ec:	e8 42 fe ff ff       	call   800033 <die>
  8001f1:	eb b2                	jmp    8001a5 <umain+0xce>

008001f3 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	57                   	push   %edi
  8001f7:	56                   	push   %esi
  8001f8:	53                   	push   %ebx
  8001f9:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800202:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  800205:	c7 45 e0 00 40 80 00 	movl   $0x804000,-0x20(%ebp)
  80020c:	eb 30                	jmp    80023e <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  80020e:	0f b6 c2             	movzbl %dl,%eax
  800211:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  800216:	88 01                	mov    %al,(%ecx)
  800218:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  80021b:	83 ea 01             	sub    $0x1,%edx
  80021e:	80 fa ff             	cmp    $0xff,%dl
  800221:	75 eb                	jne    80020e <inet_ntoa+0x1b>
  800223:	89 f0                	mov    %esi,%eax
  800225:	0f b6 f0             	movzbl %al,%esi
  800228:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  80022b:	8d 46 01             	lea    0x1(%esi),%eax
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800231:	c6 06 2e             	movb   $0x2e,(%esi)
  800234:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  800237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80023a:	39 c7                	cmp    %eax,%edi
  80023c:	74 3b                	je     800279 <inet_ntoa+0x86>
  rp = str;
  80023e:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  800243:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  800246:	0f b6 da             	movzbl %dl,%ebx
  800249:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  80024c:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  80024f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800252:	66 c1 e8 0b          	shr    $0xb,%ax
  800256:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800258:	8d 71 01             	lea    0x1(%ecx),%esi
  80025b:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  80025e:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  800261:	01 db                	add    %ebx,%ebx
  800263:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  800265:	83 c2 30             	add    $0x30,%edx
  800268:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  80026c:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  80026e:	84 c0                	test   %al,%al
  800270:	75 d1                	jne    800243 <inet_ntoa+0x50>
  800272:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  800275:	89 f2                	mov    %esi,%edx
  800277:	eb a2                	jmp    80021b <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  800279:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  80027c:	b8 00 40 80 00       	mov    $0x804000,%eax
  800281:	83 c4 14             	add    $0x14,%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    

00800289 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80028c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800290:	66 c1 c0 08          	rol    $0x8,%ax
}
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800299:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80029d:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002a9:	89 d0                	mov    %edx,%eax
  8002ab:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002ae:	89 d1                	mov    %edx,%ecx
  8002b0:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002b3:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	c1 e1 08             	shl    $0x8,%ecx
  8002ba:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002c0:	09 c8                	or     %ecx,%eax
  8002c2:	c1 ea 08             	shr    $0x8,%edx
  8002c5:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002cb:	09 d0                	or     %edx,%eax
}
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <inet_aton>:
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	57                   	push   %edi
  8002d3:	56                   	push   %esi
  8002d4:	53                   	push   %ebx
  8002d5:	83 ec 1c             	sub    $0x1c,%esp
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  8002db:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  8002de:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8002e1:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8002e4:	e9 a9 00 00 00       	jmp    800392 <inet_aton+0xc3>
      c = *++cp;
  8002e9:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8002ed:	89 d1                	mov    %edx,%ecx
  8002ef:	83 e1 df             	and    $0xffffffdf,%ecx
  8002f2:	80 f9 58             	cmp    $0x58,%cl
  8002f5:	74 12                	je     800309 <inet_aton+0x3a>
      c = *++cp;
  8002f7:	83 c0 01             	add    $0x1,%eax
  8002fa:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8002fd:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  800304:	e9 a5 00 00 00       	jmp    8003ae <inet_aton+0xdf>
        c = *++cp;
  800309:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80030d:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  800310:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  800317:	e9 92 00 00 00       	jmp    8003ae <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80031c:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  800320:	75 4a                	jne    80036c <inet_aton+0x9d>
  800322:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  800325:	89 d1                	mov    %edx,%ecx
  800327:	83 e1 df             	and    $0xffffffdf,%ecx
  80032a:	83 e9 41             	sub    $0x41,%ecx
  80032d:	80 f9 05             	cmp    $0x5,%cl
  800330:	77 3a                	ja     80036c <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800332:	c1 e7 04             	shl    $0x4,%edi
  800335:	83 c2 0a             	add    $0xa,%edx
  800338:	80 fb 1a             	cmp    $0x1a,%bl
  80033b:	19 c9                	sbb    %ecx,%ecx
  80033d:	83 e1 20             	and    $0x20,%ecx
  800340:	83 c1 41             	add    $0x41,%ecx
  800343:	29 ca                	sub    %ecx,%edx
  800345:	09 d7                	or     %edx,%edi
        c = *++cp;
  800347:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80034a:	0f be 56 01          	movsbl 0x1(%esi),%edx
  80034e:	83 c0 01             	add    $0x1,%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  800354:	89 d6                	mov    %edx,%esi
  800356:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800359:	80 f9 09             	cmp    $0x9,%cl
  80035c:	77 be                	ja     80031c <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  80035e:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  800362:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800366:	0f be 50 01          	movsbl 0x1(%eax),%edx
  80036a:	eb e2                	jmp    80034e <inet_aton+0x7f>
    if (c == '.') {
  80036c:	83 fa 2e             	cmp    $0x2e,%edx
  80036f:	75 44                	jne    8003b5 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800371:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800374:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800377:	39 c3                	cmp    %eax,%ebx
  800379:	0f 84 13 01 00 00    	je     800492 <inet_aton+0x1c3>
      *pp++ = val;
  80037f:	83 c3 04             	add    $0x4,%ebx
  800382:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800385:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  800388:	8b 75 e0             	mov    -0x20(%ebp),%esi
  80038b:	8d 46 01             	lea    0x1(%esi),%eax
  80038e:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  800392:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800395:	80 f9 09             	cmp    $0x9,%cl
  800398:	0f 87 ed 00 00 00    	ja     80048b <inet_aton+0x1bc>
    base = 10;
  80039e:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  8003a5:	83 fa 30             	cmp    $0x30,%edx
  8003a8:	0f 84 3b ff ff ff    	je     8002e9 <inet_aton+0x1a>
        base = 8;
  8003ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8003b3:	eb 9c                	jmp    800351 <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003b5:	85 d2                	test   %edx,%edx
  8003b7:	74 29                	je     8003e2 <inet_aton+0x113>
    return (0);
  8003b9:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003be:	89 f3                	mov    %esi,%ebx
  8003c0:	80 fb 1f             	cmp    $0x1f,%bl
  8003c3:	0f 86 ce 00 00 00    	jbe    800497 <inet_aton+0x1c8>
  8003c9:	84 d2                	test   %dl,%dl
  8003cb:	0f 88 c6 00 00 00    	js     800497 <inet_aton+0x1c8>
  8003d1:	83 fa 20             	cmp    $0x20,%edx
  8003d4:	74 0c                	je     8003e2 <inet_aton+0x113>
  8003d6:	83 ea 09             	sub    $0x9,%edx
  8003d9:	83 fa 04             	cmp    $0x4,%edx
  8003dc:	0f 87 b5 00 00 00    	ja     800497 <inet_aton+0x1c8>
  n = pp - parts + 1;
  8003e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8003e5:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8003e8:	29 c6                	sub    %eax,%esi
  8003ea:	89 f0                	mov    %esi,%eax
  8003ec:	c1 f8 02             	sar    $0x2,%eax
  8003ef:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8003f2:	83 f8 02             	cmp    $0x2,%eax
  8003f5:	74 5e                	je     800455 <inet_aton+0x186>
  8003f7:	83 f8 02             	cmp    $0x2,%eax
  8003fa:	7e 35                	jle    800431 <inet_aton+0x162>
  8003fc:	83 f8 03             	cmp    $0x3,%eax
  8003ff:	74 6b                	je     80046c <inet_aton+0x19d>
  800401:	83 f8 04             	cmp    $0x4,%eax
  800404:	75 2f                	jne    800435 <inet_aton+0x166>
      return (0);
  800406:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  80040b:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  800411:	0f 87 80 00 00 00    	ja     800497 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	c1 e0 18             	shl    $0x18,%eax
  80041d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800420:	c1 e2 10             	shl    $0x10,%edx
  800423:	09 d0                	or     %edx,%eax
  800425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800428:	c1 e2 08             	shl    $0x8,%edx
  80042b:	09 d0                	or     %edx,%eax
  80042d:	09 c7                	or     %eax,%edi
    break;
  80042f:	eb 04                	jmp    800435 <inet_aton+0x166>
  switch (n) {
  800431:	85 c0                	test   %eax,%eax
  800433:	74 62                	je     800497 <inet_aton+0x1c8>
  return (1);
  800435:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  80043a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043e:	74 57                	je     800497 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  800440:	57                   	push   %edi
  800441:	e8 5d fe ff ff       	call   8002a3 <htonl>
  800446:	83 c4 04             	add    $0x4,%esp
  800449:	8b 75 0c             	mov    0xc(%ebp),%esi
  80044c:	89 06                	mov    %eax,(%esi)
  return (1);
  80044e:	b8 01 00 00 00       	mov    $0x1,%eax
  800453:	eb 42                	jmp    800497 <inet_aton+0x1c8>
      return (0);
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  80045a:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  800460:	77 35                	ja     800497 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  800462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800465:	c1 e0 18             	shl    $0x18,%eax
  800468:	09 c7                	or     %eax,%edi
    break;
  80046a:	eb c9                	jmp    800435 <inet_aton+0x166>
      return (0);
  80046c:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  800471:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  800477:	77 1e                	ja     800497 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047c:	c1 e0 18             	shl    $0x18,%eax
  80047f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800482:	c1 e2 10             	shl    $0x10,%edx
  800485:	09 d0                	or     %edx,%eax
  800487:	09 c7                	or     %eax,%edi
    break;
  800489:	eb aa                	jmp    800435 <inet_aton+0x166>
      return (0);
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	eb 05                	jmp    800497 <inet_aton+0x1c8>
        return (0);
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800497:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80049a:	5b                   	pop    %ebx
  80049b:	5e                   	pop    %esi
  80049c:	5f                   	pop    %edi
  80049d:	5d                   	pop    %ebp
  80049e:	c3                   	ret    

0080049f <inet_addr>:
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  8004a5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004a8:	50                   	push   %eax
  8004a9:	ff 75 08             	pushl  0x8(%ebp)
  8004ac:	e8 1e fe ff ff       	call   8002cf <inet_aton>
  8004b1:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  8004b4:	85 c0                	test   %eax,%eax
  8004b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004bb:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	e8 d7 fd ff ff       	call   8002a3 <htonl>
  8004cc:	83 c4 04             	add    $0x4,%esp
}
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	56                   	push   %esi
  8004d5:	53                   	push   %ebx
  8004d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004d9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004dc:	e8 bf 0a 00 00       	call   800fa0 <sys_getenvid>
  8004e1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004e6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ee:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004f3:	85 db                	test   %ebx,%ebx
  8004f5:	7e 07                	jle    8004fe <libmain+0x2d>
		binaryname = argv[0];
  8004f7:	8b 06                	mov    (%esi),%eax
  8004f9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	56                   	push   %esi
  800502:	53                   	push   %ebx
  800503:	e8 cf fb ff ff       	call   8000d7 <umain>

	// exit gracefully
	exit();
  800508:	e8 0a 00 00 00       	call   800517 <exit>
}
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800513:	5b                   	pop    %ebx
  800514:	5e                   	pop    %esi
  800515:	5d                   	pop    %ebp
  800516:	c3                   	ret    

00800517 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80051d:	e8 a2 0e 00 00       	call   8013c4 <close_all>
	sys_env_destroy(0);
  800522:	83 ec 0c             	sub    $0xc,%esp
  800525:	6a 00                	push   $0x0
  800527:	e8 33 0a 00 00       	call   800f5f <sys_env_destroy>
}
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	53                   	push   %ebx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80053b:	8b 13                	mov    (%ebx),%edx
  80053d:	8d 42 01             	lea    0x1(%edx),%eax
  800540:	89 03                	mov    %eax,(%ebx)
  800542:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800545:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800549:	3d ff 00 00 00       	cmp    $0xff,%eax
  80054e:	74 09                	je     800559 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800550:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800554:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800557:	c9                   	leave  
  800558:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	68 ff 00 00 00       	push   $0xff
  800561:	8d 43 08             	lea    0x8(%ebx),%eax
  800564:	50                   	push   %eax
  800565:	e8 b8 09 00 00       	call   800f22 <sys_cputs>
		b->idx = 0;
  80056a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	eb db                	jmp    800550 <putch+0x1f>

00800575 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800585:	00 00 00 
	b.cnt = 0;
  800588:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800592:	ff 75 0c             	pushl  0xc(%ebp)
  800595:	ff 75 08             	pushl  0x8(%ebp)
  800598:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059e:	50                   	push   %eax
  80059f:	68 31 05 80 00       	push   $0x800531
  8005a4:	e8 1a 01 00 00       	call   8006c3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005a9:	83 c4 08             	add    $0x8,%esp
  8005ac:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005b8:	50                   	push   %eax
  8005b9:	e8 64 09 00 00       	call   800f22 <sys_cputs>

	return b.cnt;
}
  8005be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005cc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005cf:	50                   	push   %eax
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	e8 9d ff ff ff       	call   800575 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	57                   	push   %edi
  8005de:	56                   	push   %esi
  8005df:	53                   	push   %ebx
  8005e0:	83 ec 1c             	sub    $0x1c,%esp
  8005e3:	89 c7                	mov    %eax,%edi
  8005e5:	89 d6                	mov    %edx,%esi
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005fe:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800601:	39 d3                	cmp    %edx,%ebx
  800603:	72 05                	jb     80060a <printnum+0x30>
  800605:	39 45 10             	cmp    %eax,0x10(%ebp)
  800608:	77 7a                	ja     800684 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060a:	83 ec 0c             	sub    $0xc,%esp
  80060d:	ff 75 18             	pushl  0x18(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800616:	53                   	push   %ebx
  800617:	ff 75 10             	pushl  0x10(%ebp)
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800620:	ff 75 e0             	pushl  -0x20(%ebp)
  800623:	ff 75 dc             	pushl  -0x24(%ebp)
  800626:	ff 75 d8             	pushl  -0x28(%ebp)
  800629:	e8 62 1e 00 00       	call   802490 <__udivdi3>
  80062e:	83 c4 18             	add    $0x18,%esp
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	89 f2                	mov    %esi,%edx
  800635:	89 f8                	mov    %edi,%eax
  800637:	e8 9e ff ff ff       	call   8005da <printnum>
  80063c:	83 c4 20             	add    $0x20,%esp
  80063f:	eb 13                	jmp    800654 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	56                   	push   %esi
  800645:	ff 75 18             	pushl  0x18(%ebp)
  800648:	ff d7                	call   *%edi
  80064a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80064d:	83 eb 01             	sub    $0x1,%ebx
  800650:	85 db                	test   %ebx,%ebx
  800652:	7f ed                	jg     800641 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	56                   	push   %esi
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065e:	ff 75 e0             	pushl  -0x20(%ebp)
  800661:	ff 75 dc             	pushl  -0x24(%ebp)
  800664:	ff 75 d8             	pushl  -0x28(%ebp)
  800667:	e8 44 1f 00 00       	call   8025b0 <__umoddi3>
  80066c:	83 c4 14             	add    $0x14,%esp
  80066f:	0f be 80 25 28 80 00 	movsbl 0x802825(%eax),%eax
  800676:	50                   	push   %eax
  800677:	ff d7                	call   *%edi
}
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067f:	5b                   	pop    %ebx
  800680:	5e                   	pop    %esi
  800681:	5f                   	pop    %edi
  800682:	5d                   	pop    %ebp
  800683:	c3                   	ret    
  800684:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800687:	eb c4                	jmp    80064d <printnum+0x73>

00800689 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80068f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800693:	8b 10                	mov    (%eax),%edx
  800695:	3b 50 04             	cmp    0x4(%eax),%edx
  800698:	73 0a                	jae    8006a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80069d:	89 08                	mov    %ecx,(%eax)
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	88 02                	mov    %al,(%edx)
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <printfmt>:
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006af:	50                   	push   %eax
  8006b0:	ff 75 10             	pushl  0x10(%ebp)
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	ff 75 08             	pushl  0x8(%ebp)
  8006b9:	e8 05 00 00 00       	call   8006c3 <vprintfmt>
}
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	c9                   	leave  
  8006c2:	c3                   	ret    

008006c3 <vprintfmt>:
{
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
  8006c6:	57                   	push   %edi
  8006c7:	56                   	push   %esi
  8006c8:	53                   	push   %ebx
  8006c9:	83 ec 2c             	sub    $0x2c,%esp
  8006cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006d5:	e9 c1 03 00 00       	jmp    800a9b <vprintfmt+0x3d8>
		padc = ' ';
  8006da:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006de:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006e5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	8d 47 01             	lea    0x1(%edi),%eax
  8006fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006fe:	0f b6 17             	movzbl (%edi),%edx
  800701:	8d 42 dd             	lea    -0x23(%edx),%eax
  800704:	3c 55                	cmp    $0x55,%al
  800706:	0f 87 12 04 00 00    	ja     800b1e <vprintfmt+0x45b>
  80070c:	0f b6 c0             	movzbl %al,%eax
  80070f:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
  800716:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800719:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80071d:	eb d9                	jmp    8006f8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80071f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800722:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800726:	eb d0                	jmp    8006f8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800728:	0f b6 d2             	movzbl %dl,%edx
  80072b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80072e:	b8 00 00 00 00       	mov    $0x0,%eax
  800733:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800736:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800739:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80073d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800740:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800743:	83 f9 09             	cmp    $0x9,%ecx
  800746:	77 55                	ja     80079d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800748:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80074b:	eb e9                	jmp    800736 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 40 04             	lea    0x4(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80075e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800761:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800765:	79 91                	jns    8006f8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800767:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80076a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800774:	eb 82                	jmp    8006f8 <vprintfmt+0x35>
  800776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800779:	85 c0                	test   %eax,%eax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
  800780:	0f 49 d0             	cmovns %eax,%edx
  800783:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800786:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800789:	e9 6a ff ff ff       	jmp    8006f8 <vprintfmt+0x35>
  80078e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800791:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800798:	e9 5b ff ff ff       	jmp    8006f8 <vprintfmt+0x35>
  80079d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a3:	eb bc                	jmp    800761 <vprintfmt+0x9e>
			lflag++;
  8007a5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007ab:	e9 48 ff ff ff       	jmp    8006f8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8d 78 04             	lea    0x4(%eax),%edi
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	ff 30                	pushl  (%eax)
  8007bc:	ff d6                	call   *%esi
			break;
  8007be:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007c1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007c4:	e9 cf 02 00 00       	jmp    800a98 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 78 04             	lea    0x4(%eax),%edi
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	99                   	cltd   
  8007d2:	31 d0                	xor    %edx,%eax
  8007d4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007d6:	83 f8 0f             	cmp    $0xf,%eax
  8007d9:	7f 23                	jg     8007fe <vprintfmt+0x13b>
  8007db:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  8007e2:	85 d2                	test   %edx,%edx
  8007e4:	74 18                	je     8007fe <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007e6:	52                   	push   %edx
  8007e7:	68 f5 2b 80 00       	push   $0x802bf5
  8007ec:	53                   	push   %ebx
  8007ed:	56                   	push   %esi
  8007ee:	e8 b3 fe ff ff       	call   8006a6 <printfmt>
  8007f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007f6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007f9:	e9 9a 02 00 00       	jmp    800a98 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8007fe:	50                   	push   %eax
  8007ff:	68 3d 28 80 00       	push   $0x80283d
  800804:	53                   	push   %ebx
  800805:	56                   	push   %esi
  800806:	e8 9b fe ff ff       	call   8006a6 <printfmt>
  80080b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80080e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800811:	e9 82 02 00 00       	jmp    800a98 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 c0 04             	add    $0x4,%eax
  80081c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800824:	85 ff                	test   %edi,%edi
  800826:	b8 36 28 80 00       	mov    $0x802836,%eax
  80082b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80082e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800832:	0f 8e bd 00 00 00    	jle    8008f5 <vprintfmt+0x232>
  800838:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80083c:	75 0e                	jne    80084c <vprintfmt+0x189>
  80083e:	89 75 08             	mov    %esi,0x8(%ebp)
  800841:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800844:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800847:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80084a:	eb 6d                	jmp    8008b9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 d0             	pushl  -0x30(%ebp)
  800852:	57                   	push   %edi
  800853:	e8 6e 03 00 00       	call   800bc6 <strnlen>
  800858:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80085b:	29 c1                	sub    %eax,%ecx
  80085d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800860:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800863:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800867:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80086d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80086f:	eb 0f                	jmp    800880 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	53                   	push   %ebx
  800875:	ff 75 e0             	pushl  -0x20(%ebp)
  800878:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80087a:	83 ef 01             	sub    $0x1,%edi
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	85 ff                	test   %edi,%edi
  800882:	7f ed                	jg     800871 <vprintfmt+0x1ae>
  800884:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800887:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80088a:	85 c9                	test   %ecx,%ecx
  80088c:	b8 00 00 00 00       	mov    $0x0,%eax
  800891:	0f 49 c1             	cmovns %ecx,%eax
  800894:	29 c1                	sub    %eax,%ecx
  800896:	89 75 08             	mov    %esi,0x8(%ebp)
  800899:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80089c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80089f:	89 cb                	mov    %ecx,%ebx
  8008a1:	eb 16                	jmp    8008b9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8008a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008a7:	75 31                	jne    8008da <vprintfmt+0x217>
					putch(ch, putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	ff 55 08             	call   *0x8(%ebp)
  8008b3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b6:	83 eb 01             	sub    $0x1,%ebx
  8008b9:	83 c7 01             	add    $0x1,%edi
  8008bc:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008c0:	0f be c2             	movsbl %dl,%eax
  8008c3:	85 c0                	test   %eax,%eax
  8008c5:	74 59                	je     800920 <vprintfmt+0x25d>
  8008c7:	85 f6                	test   %esi,%esi
  8008c9:	78 d8                	js     8008a3 <vprintfmt+0x1e0>
  8008cb:	83 ee 01             	sub    $0x1,%esi
  8008ce:	79 d3                	jns    8008a3 <vprintfmt+0x1e0>
  8008d0:	89 df                	mov    %ebx,%edi
  8008d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d8:	eb 37                	jmp    800911 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008da:	0f be d2             	movsbl %dl,%edx
  8008dd:	83 ea 20             	sub    $0x20,%edx
  8008e0:	83 fa 5e             	cmp    $0x5e,%edx
  8008e3:	76 c4                	jbe    8008a9 <vprintfmt+0x1e6>
					putch('?', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	6a 3f                	push   $0x3f
  8008ed:	ff 55 08             	call   *0x8(%ebp)
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	eb c1                	jmp    8008b6 <vprintfmt+0x1f3>
  8008f5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008f8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008fb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008fe:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800901:	eb b6                	jmp    8008b9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	53                   	push   %ebx
  800907:	6a 20                	push   $0x20
  800909:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80090b:	83 ef 01             	sub    $0x1,%edi
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	85 ff                	test   %edi,%edi
  800913:	7f ee                	jg     800903 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800915:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	e9 78 01 00 00       	jmp    800a98 <vprintfmt+0x3d5>
  800920:	89 df                	mov    %ebx,%edi
  800922:	8b 75 08             	mov    0x8(%ebp),%esi
  800925:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800928:	eb e7                	jmp    800911 <vprintfmt+0x24e>
	if (lflag >= 2)
  80092a:	83 f9 01             	cmp    $0x1,%ecx
  80092d:	7e 3f                	jle    80096e <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8b 50 04             	mov    0x4(%eax),%edx
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8d 40 08             	lea    0x8(%eax),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800946:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094a:	79 5c                	jns    8009a8 <vprintfmt+0x2e5>
				putch('-', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	6a 2d                	push   $0x2d
  800952:	ff d6                	call   *%esi
				num = -(long long) num;
  800954:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800957:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80095a:	f7 da                	neg    %edx
  80095c:	83 d1 00             	adc    $0x0,%ecx
  80095f:	f7 d9                	neg    %ecx
  800961:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800964:	b8 0a 00 00 00       	mov    $0xa,%eax
  800969:	e9 10 01 00 00       	jmp    800a7e <vprintfmt+0x3bb>
	else if (lflag)
  80096e:	85 c9                	test   %ecx,%ecx
  800970:	75 1b                	jne    80098d <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800972:	8b 45 14             	mov    0x14(%ebp),%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097a:	89 c1                	mov    %eax,%ecx
  80097c:	c1 f9 1f             	sar    $0x1f,%ecx
  80097f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800982:	8b 45 14             	mov    0x14(%ebp),%eax
  800985:	8d 40 04             	lea    0x4(%eax),%eax
  800988:	89 45 14             	mov    %eax,0x14(%ebp)
  80098b:	eb b9                	jmp    800946 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800995:	89 c1                	mov    %eax,%ecx
  800997:	c1 f9 1f             	sar    $0x1f,%ecx
  80099a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80099d:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a0:	8d 40 04             	lea    0x4(%eax),%eax
  8009a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a6:	eb 9e                	jmp    800946 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8009a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009ab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8009ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b3:	e9 c6 00 00 00       	jmp    800a7e <vprintfmt+0x3bb>
	if (lflag >= 2)
  8009b8:	83 f9 01             	cmp    $0x1,%ecx
  8009bb:	7e 18                	jle    8009d5 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 10                	mov    (%eax),%edx
  8009c2:	8b 48 04             	mov    0x4(%eax),%ecx
  8009c5:	8d 40 08             	lea    0x8(%eax),%eax
  8009c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d0:	e9 a9 00 00 00       	jmp    800a7e <vprintfmt+0x3bb>
	else if (lflag)
  8009d5:	85 c9                	test   %ecx,%ecx
  8009d7:	75 1a                	jne    8009f3 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	8b 10                	mov    (%eax),%edx
  8009de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e3:	8d 40 04             	lea    0x4(%eax),%eax
  8009e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ee:	e9 8b 00 00 00       	jmp    800a7e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	8b 10                	mov    (%eax),%edx
  8009f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009fd:	8d 40 04             	lea    0x4(%eax),%eax
  800a00:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a08:	eb 74                	jmp    800a7e <vprintfmt+0x3bb>
	if (lflag >= 2)
  800a0a:	83 f9 01             	cmp    $0x1,%ecx
  800a0d:	7e 15                	jle    800a24 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	8b 10                	mov    (%eax),%edx
  800a14:	8b 48 04             	mov    0x4(%eax),%ecx
  800a17:	8d 40 08             	lea    0x8(%eax),%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a1d:	b8 08 00 00 00       	mov    $0x8,%eax
  800a22:	eb 5a                	jmp    800a7e <vprintfmt+0x3bb>
	else if (lflag)
  800a24:	85 c9                	test   %ecx,%ecx
  800a26:	75 17                	jne    800a3f <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	8b 10                	mov    (%eax),%edx
  800a2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a32:	8d 40 04             	lea    0x4(%eax),%eax
  800a35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a38:	b8 08 00 00 00       	mov    $0x8,%eax
  800a3d:	eb 3f                	jmp    800a7e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	8b 10                	mov    (%eax),%edx
  800a44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a49:	8d 40 04             	lea    0x4(%eax),%eax
  800a4c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a4f:	b8 08 00 00 00       	mov    $0x8,%eax
  800a54:	eb 28                	jmp    800a7e <vprintfmt+0x3bb>
			putch('0', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	53                   	push   %ebx
  800a5a:	6a 30                	push   $0x30
  800a5c:	ff d6                	call   *%esi
			putch('x', putdat);
  800a5e:	83 c4 08             	add    $0x8,%esp
  800a61:	53                   	push   %ebx
  800a62:	6a 78                	push   $0x78
  800a64:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	8b 10                	mov    (%eax),%edx
  800a6b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a70:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a73:	8d 40 04             	lea    0x4(%eax),%eax
  800a76:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a79:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a7e:	83 ec 0c             	sub    $0xc,%esp
  800a81:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800a85:	57                   	push   %edi
  800a86:	ff 75 e0             	pushl  -0x20(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	51                   	push   %ecx
  800a8b:	52                   	push   %edx
  800a8c:	89 da                	mov    %ebx,%edx
  800a8e:	89 f0                	mov    %esi,%eax
  800a90:	e8 45 fb ff ff       	call   8005da <printnum>
			break;
  800a95:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800a98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a9b:	83 c7 01             	add    $0x1,%edi
  800a9e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800aa2:	83 f8 25             	cmp    $0x25,%eax
  800aa5:	0f 84 2f fc ff ff    	je     8006da <vprintfmt+0x17>
			if (ch == '\0')
  800aab:	85 c0                	test   %eax,%eax
  800aad:	0f 84 8b 00 00 00    	je     800b3e <vprintfmt+0x47b>
			putch(ch, putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	53                   	push   %ebx
  800ab7:	50                   	push   %eax
  800ab8:	ff d6                	call   *%esi
  800aba:	83 c4 10             	add    $0x10,%esp
  800abd:	eb dc                	jmp    800a9b <vprintfmt+0x3d8>
	if (lflag >= 2)
  800abf:	83 f9 01             	cmp    $0x1,%ecx
  800ac2:	7e 15                	jle    800ad9 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	8b 10                	mov    (%eax),%edx
  800ac9:	8b 48 04             	mov    0x4(%eax),%ecx
  800acc:	8d 40 08             	lea    0x8(%eax),%eax
  800acf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad7:	eb a5                	jmp    800a7e <vprintfmt+0x3bb>
	else if (lflag)
  800ad9:	85 c9                	test   %ecx,%ecx
  800adb:	75 17                	jne    800af4 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	8b 10                	mov    (%eax),%edx
  800ae2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae7:	8d 40 04             	lea    0x4(%eax),%eax
  800aea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aed:	b8 10 00 00 00       	mov    $0x10,%eax
  800af2:	eb 8a                	jmp    800a7e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800af4:	8b 45 14             	mov    0x14(%ebp),%eax
  800af7:	8b 10                	mov    (%eax),%edx
  800af9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afe:	8d 40 04             	lea    0x4(%eax),%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b04:	b8 10 00 00 00       	mov    $0x10,%eax
  800b09:	e9 70 ff ff ff       	jmp    800a7e <vprintfmt+0x3bb>
			putch(ch, putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	53                   	push   %ebx
  800b12:	6a 25                	push   $0x25
  800b14:	ff d6                	call   *%esi
			break;
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	e9 7a ff ff ff       	jmp    800a98 <vprintfmt+0x3d5>
			putch('%', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	53                   	push   %ebx
  800b22:	6a 25                	push   $0x25
  800b24:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	89 f8                	mov    %edi,%eax
  800b2b:	eb 03                	jmp    800b30 <vprintfmt+0x46d>
  800b2d:	83 e8 01             	sub    $0x1,%eax
  800b30:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b34:	75 f7                	jne    800b2d <vprintfmt+0x46a>
  800b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b39:	e9 5a ff ff ff       	jmp    800a98 <vprintfmt+0x3d5>
}
  800b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	83 ec 18             	sub    $0x18,%esp
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b55:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b59:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 26                	je     800b8d <vsnprintf+0x47>
  800b67:	85 d2                	test   %edx,%edx
  800b69:	7e 22                	jle    800b8d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6b:	ff 75 14             	pushl  0x14(%ebp)
  800b6e:	ff 75 10             	pushl  0x10(%ebp)
  800b71:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b74:	50                   	push   %eax
  800b75:	68 89 06 80 00       	push   $0x800689
  800b7a:	e8 44 fb ff ff       	call   8006c3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b82:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b88:	83 c4 10             	add    $0x10,%esp
}
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    
		return -E_INVAL;
  800b8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b92:	eb f7                	jmp    800b8b <vsnprintf+0x45>

00800b94 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b9d:	50                   	push   %eax
  800b9e:	ff 75 10             	pushl  0x10(%ebp)
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	ff 75 08             	pushl  0x8(%ebp)
  800ba7:	e8 9a ff ff ff       	call   800b46 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb9:	eb 03                	jmp    800bbe <strlen+0x10>
		n++;
  800bbb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800bbe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bc2:	75 f7                	jne    800bbb <strlen+0xd>
	return n;
}
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd4:	eb 03                	jmp    800bd9 <strnlen+0x13>
		n++;
  800bd6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd9:	39 d0                	cmp    %edx,%eax
  800bdb:	74 06                	je     800be3 <strnlen+0x1d>
  800bdd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800be1:	75 f3                	jne    800bd6 <strnlen+0x10>
	return n;
}
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	53                   	push   %ebx
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bef:	89 c2                	mov    %eax,%edx
  800bf1:	83 c1 01             	add    $0x1,%ecx
  800bf4:	83 c2 01             	add    $0x1,%edx
  800bf7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800bfb:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bfe:	84 db                	test   %bl,%bl
  800c00:	75 ef                	jne    800bf1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c02:	5b                   	pop    %ebx
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	53                   	push   %ebx
  800c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c0c:	53                   	push   %ebx
  800c0d:	e8 9c ff ff ff       	call   800bae <strlen>
  800c12:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	01 d8                	add    %ebx,%eax
  800c1a:	50                   	push   %eax
  800c1b:	e8 c5 ff ff ff       	call   800be5 <strcpy>
	return dst;
}
  800c20:	89 d8                	mov    %ebx,%eax
  800c22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
  800c2c:	8b 75 08             	mov    0x8(%ebp),%esi
  800c2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c32:	89 f3                	mov    %esi,%ebx
  800c34:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c37:	89 f2                	mov    %esi,%edx
  800c39:	eb 0f                	jmp    800c4a <strncpy+0x23>
		*dst++ = *src;
  800c3b:	83 c2 01             	add    $0x1,%edx
  800c3e:	0f b6 01             	movzbl (%ecx),%eax
  800c41:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c44:	80 39 01             	cmpb   $0x1,(%ecx)
  800c47:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800c4a:	39 da                	cmp    %ebx,%edx
  800c4c:	75 ed                	jne    800c3b <strncpy+0x14>
	}
	return ret;
}
  800c4e:	89 f0                	mov    %esi,%eax
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	8b 75 08             	mov    0x8(%ebp),%esi
  800c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c62:	89 f0                	mov    %esi,%eax
  800c64:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c68:	85 c9                	test   %ecx,%ecx
  800c6a:	75 0b                	jne    800c77 <strlcpy+0x23>
  800c6c:	eb 17                	jmp    800c85 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c6e:	83 c2 01             	add    $0x1,%edx
  800c71:	83 c0 01             	add    $0x1,%eax
  800c74:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800c77:	39 d8                	cmp    %ebx,%eax
  800c79:	74 07                	je     800c82 <strlcpy+0x2e>
  800c7b:	0f b6 0a             	movzbl (%edx),%ecx
  800c7e:	84 c9                	test   %cl,%cl
  800c80:	75 ec                	jne    800c6e <strlcpy+0x1a>
		*dst = '\0';
  800c82:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c85:	29 f0                	sub    %esi,%eax
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c91:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c94:	eb 06                	jmp    800c9c <strcmp+0x11>
		p++, q++;
  800c96:	83 c1 01             	add    $0x1,%ecx
  800c99:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800c9c:	0f b6 01             	movzbl (%ecx),%eax
  800c9f:	84 c0                	test   %al,%al
  800ca1:	74 04                	je     800ca7 <strcmp+0x1c>
  800ca3:	3a 02                	cmp    (%edx),%al
  800ca5:	74 ef                	je     800c96 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca7:	0f b6 c0             	movzbl %al,%eax
  800caa:	0f b6 12             	movzbl (%edx),%edx
  800cad:	29 d0                	sub    %edx,%eax
}
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	53                   	push   %ebx
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbb:	89 c3                	mov    %eax,%ebx
  800cbd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cc0:	eb 06                	jmp    800cc8 <strncmp+0x17>
		n--, p++, q++;
  800cc2:	83 c0 01             	add    $0x1,%eax
  800cc5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cc8:	39 d8                	cmp    %ebx,%eax
  800cca:	74 16                	je     800ce2 <strncmp+0x31>
  800ccc:	0f b6 08             	movzbl (%eax),%ecx
  800ccf:	84 c9                	test   %cl,%cl
  800cd1:	74 04                	je     800cd7 <strncmp+0x26>
  800cd3:	3a 0a                	cmp    (%edx),%cl
  800cd5:	74 eb                	je     800cc2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd7:	0f b6 00             	movzbl (%eax),%eax
  800cda:	0f b6 12             	movzbl (%edx),%edx
  800cdd:	29 d0                	sub    %edx,%eax
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    
		return 0;
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce7:	eb f6                	jmp    800cdf <strncmp+0x2e>

00800ce9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf3:	0f b6 10             	movzbl (%eax),%edx
  800cf6:	84 d2                	test   %dl,%dl
  800cf8:	74 09                	je     800d03 <strchr+0x1a>
		if (*s == c)
  800cfa:	38 ca                	cmp    %cl,%dl
  800cfc:	74 0a                	je     800d08 <strchr+0x1f>
	for (; *s; s++)
  800cfe:	83 c0 01             	add    $0x1,%eax
  800d01:	eb f0                	jmp    800cf3 <strchr+0xa>
			return (char *) s;
	return 0;
  800d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d14:	eb 03                	jmp    800d19 <strfind+0xf>
  800d16:	83 c0 01             	add    $0x1,%eax
  800d19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d1c:	38 ca                	cmp    %cl,%dl
  800d1e:	74 04                	je     800d24 <strfind+0x1a>
  800d20:	84 d2                	test   %dl,%dl
  800d22:	75 f2                	jne    800d16 <strfind+0xc>
			break;
	return (char *) s;
}
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d32:	85 c9                	test   %ecx,%ecx
  800d34:	74 13                	je     800d49 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d36:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d3c:	75 05                	jne    800d43 <memset+0x1d>
  800d3e:	f6 c1 03             	test   $0x3,%cl
  800d41:	74 0d                	je     800d50 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	fc                   	cld    
  800d47:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d49:	89 f8                	mov    %edi,%eax
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    
		c &= 0xFF;
  800d50:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d54:	89 d3                	mov    %edx,%ebx
  800d56:	c1 e3 08             	shl    $0x8,%ebx
  800d59:	89 d0                	mov    %edx,%eax
  800d5b:	c1 e0 18             	shl    $0x18,%eax
  800d5e:	89 d6                	mov    %edx,%esi
  800d60:	c1 e6 10             	shl    $0x10,%esi
  800d63:	09 f0                	or     %esi,%eax
  800d65:	09 c2                	or     %eax,%edx
  800d67:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800d69:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d6c:	89 d0                	mov    %edx,%eax
  800d6e:	fc                   	cld    
  800d6f:	f3 ab                	rep stos %eax,%es:(%edi)
  800d71:	eb d6                	jmp    800d49 <memset+0x23>

00800d73 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d81:	39 c6                	cmp    %eax,%esi
  800d83:	73 35                	jae    800dba <memmove+0x47>
  800d85:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d88:	39 c2                	cmp    %eax,%edx
  800d8a:	76 2e                	jbe    800dba <memmove+0x47>
		s += n;
		d += n;
  800d8c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8f:	89 d6                	mov    %edx,%esi
  800d91:	09 fe                	or     %edi,%esi
  800d93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d99:	74 0c                	je     800da7 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d9b:	83 ef 01             	sub    $0x1,%edi
  800d9e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800da1:	fd                   	std    
  800da2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800da4:	fc                   	cld    
  800da5:	eb 21                	jmp    800dc8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800da7:	f6 c1 03             	test   $0x3,%cl
  800daa:	75 ef                	jne    800d9b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dac:	83 ef 04             	sub    $0x4,%edi
  800daf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800db2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800db5:	fd                   	std    
  800db6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db8:	eb ea                	jmp    800da4 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dba:	89 f2                	mov    %esi,%edx
  800dbc:	09 c2                	or     %eax,%edx
  800dbe:	f6 c2 03             	test   $0x3,%dl
  800dc1:	74 09                	je     800dcc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dc3:	89 c7                	mov    %eax,%edi
  800dc5:	fc                   	cld    
  800dc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dcc:	f6 c1 03             	test   $0x3,%cl
  800dcf:	75 f2                	jne    800dc3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dd1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dd4:	89 c7                	mov    %eax,%edi
  800dd6:	fc                   	cld    
  800dd7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dd9:	eb ed                	jmp    800dc8 <memmove+0x55>

00800ddb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800dde:	ff 75 10             	pushl  0x10(%ebp)
  800de1:	ff 75 0c             	pushl  0xc(%ebp)
  800de4:	ff 75 08             	pushl  0x8(%ebp)
  800de7:	e8 87 ff ff ff       	call   800d73 <memmove>
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df9:	89 c6                	mov    %eax,%esi
  800dfb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dfe:	39 f0                	cmp    %esi,%eax
  800e00:	74 1c                	je     800e1e <memcmp+0x30>
		if (*s1 != *s2)
  800e02:	0f b6 08             	movzbl (%eax),%ecx
  800e05:	0f b6 1a             	movzbl (%edx),%ebx
  800e08:	38 d9                	cmp    %bl,%cl
  800e0a:	75 08                	jne    800e14 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e0c:	83 c0 01             	add    $0x1,%eax
  800e0f:	83 c2 01             	add    $0x1,%edx
  800e12:	eb ea                	jmp    800dfe <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e14:	0f b6 c1             	movzbl %cl,%eax
  800e17:	0f b6 db             	movzbl %bl,%ebx
  800e1a:	29 d8                	sub    %ebx,%eax
  800e1c:	eb 05                	jmp    800e23 <memcmp+0x35>
	}

	return 0;
  800e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e30:	89 c2                	mov    %eax,%edx
  800e32:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e35:	39 d0                	cmp    %edx,%eax
  800e37:	73 09                	jae    800e42 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e39:	38 08                	cmp    %cl,(%eax)
  800e3b:	74 05                	je     800e42 <memfind+0x1b>
	for (; s < ends; s++)
  800e3d:	83 c0 01             	add    $0x1,%eax
  800e40:	eb f3                	jmp    800e35 <memfind+0xe>
			break;
	return (void *) s;
}
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
  800e4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x11>
		s++;
  800e52:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e55:	0f b6 01             	movzbl (%ecx),%eax
  800e58:	3c 20                	cmp    $0x20,%al
  800e5a:	74 f6                	je     800e52 <strtol+0xe>
  800e5c:	3c 09                	cmp    $0x9,%al
  800e5e:	74 f2                	je     800e52 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e60:	3c 2b                	cmp    $0x2b,%al
  800e62:	74 2e                	je     800e92 <strtol+0x4e>
	int neg = 0;
  800e64:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e69:	3c 2d                	cmp    $0x2d,%al
  800e6b:	74 2f                	je     800e9c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e6d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e73:	75 05                	jne    800e7a <strtol+0x36>
  800e75:	80 39 30             	cmpb   $0x30,(%ecx)
  800e78:	74 2c                	je     800ea6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e7a:	85 db                	test   %ebx,%ebx
  800e7c:	75 0a                	jne    800e88 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e7e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800e83:	80 39 30             	cmpb   $0x30,(%ecx)
  800e86:	74 28                	je     800eb0 <strtol+0x6c>
		base = 10;
  800e88:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e90:	eb 50                	jmp    800ee2 <strtol+0x9e>
		s++;
  800e92:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e95:	bf 00 00 00 00       	mov    $0x0,%edi
  800e9a:	eb d1                	jmp    800e6d <strtol+0x29>
		s++, neg = 1;
  800e9c:	83 c1 01             	add    $0x1,%ecx
  800e9f:	bf 01 00 00 00       	mov    $0x1,%edi
  800ea4:	eb c7                	jmp    800e6d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eaa:	74 0e                	je     800eba <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800eac:	85 db                	test   %ebx,%ebx
  800eae:	75 d8                	jne    800e88 <strtol+0x44>
		s++, base = 8;
  800eb0:	83 c1 01             	add    $0x1,%ecx
  800eb3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800eb8:	eb ce                	jmp    800e88 <strtol+0x44>
		s += 2, base = 16;
  800eba:	83 c1 02             	add    $0x2,%ecx
  800ebd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ec2:	eb c4                	jmp    800e88 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ec4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ec7:	89 f3                	mov    %esi,%ebx
  800ec9:	80 fb 19             	cmp    $0x19,%bl
  800ecc:	77 29                	ja     800ef7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ece:	0f be d2             	movsbl %dl,%edx
  800ed1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ed4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ed7:	7d 30                	jge    800f09 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ed9:	83 c1 01             	add    $0x1,%ecx
  800edc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ee0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ee2:	0f b6 11             	movzbl (%ecx),%edx
  800ee5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ee8:	89 f3                	mov    %esi,%ebx
  800eea:	80 fb 09             	cmp    $0x9,%bl
  800eed:	77 d5                	ja     800ec4 <strtol+0x80>
			dig = *s - '0';
  800eef:	0f be d2             	movsbl %dl,%edx
  800ef2:	83 ea 30             	sub    $0x30,%edx
  800ef5:	eb dd                	jmp    800ed4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ef7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800efa:	89 f3                	mov    %esi,%ebx
  800efc:	80 fb 19             	cmp    $0x19,%bl
  800eff:	77 08                	ja     800f09 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f01:	0f be d2             	movsbl %dl,%edx
  800f04:	83 ea 37             	sub    $0x37,%edx
  800f07:	eb cb                	jmp    800ed4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 05                	je     800f14 <strtol+0xd0>
		*endptr = (char *) s;
  800f0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f12:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f14:	89 c2                	mov    %eax,%edx
  800f16:	f7 da                	neg    %edx
  800f18:	85 ff                	test   %edi,%edi
  800f1a:	0f 45 c2             	cmovne %edx,%eax
}
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    

00800f22 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f33:	89 c3                	mov    %eax,%ebx
  800f35:	89 c7                	mov    %eax,%edi
  800f37:	89 c6                	mov    %eax,%esi
  800f39:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f46:	ba 00 00 00 00       	mov    $0x0,%edx
  800f4b:	b8 01 00 00 00       	mov    $0x1,%eax
  800f50:	89 d1                	mov    %edx,%ecx
  800f52:	89 d3                	mov    %edx,%ebx
  800f54:	89 d7                	mov    %edx,%edi
  800f56:	89 d6                	mov    %edx,%esi
  800f58:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
  800f65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f68:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	b8 03 00 00 00       	mov    $0x3,%eax
  800f75:	89 cb                	mov    %ecx,%ebx
  800f77:	89 cf                	mov    %ecx,%edi
  800f79:	89 ce                	mov    %ecx,%esi
  800f7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	7f 08                	jg     800f89 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	83 ec 0c             	sub    $0xc,%esp
  800f8c:	50                   	push   %eax
  800f8d:	6a 03                	push   $0x3
  800f8f:	68 1f 2b 80 00       	push   $0x802b1f
  800f94:	6a 23                	push   $0x23
  800f96:	68 3c 2b 80 00       	push   $0x802b3c
  800f9b:	e8 6e 13 00 00       	call   80230e <_panic>

00800fa0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fab:	b8 02 00 00 00       	mov    $0x2,%eax
  800fb0:	89 d1                	mov    %edx,%ecx
  800fb2:	89 d3                	mov    %edx,%ebx
  800fb4:	89 d7                	mov    %edx,%edi
  800fb6:	89 d6                	mov    %edx,%esi
  800fb8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5f                   	pop    %edi
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <sys_yield>:

void
sys_yield(void)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fca:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fcf:	89 d1                	mov    %edx,%ecx
  800fd1:	89 d3                	mov    %edx,%ebx
  800fd3:	89 d7                	mov    %edx,%edi
  800fd5:	89 d6                	mov    %edx,%esi
  800fd7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fd9:	5b                   	pop    %ebx
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe7:	be 00 00 00 00       	mov    $0x0,%esi
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ff7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ffa:	89 f7                	mov    %esi,%edi
  800ffc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffe:	85 c0                	test   %eax,%eax
  801000:	7f 08                	jg     80100a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801002:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	50                   	push   %eax
  80100e:	6a 04                	push   $0x4
  801010:	68 1f 2b 80 00       	push   $0x802b1f
  801015:	6a 23                	push   $0x23
  801017:	68 3c 2b 80 00       	push   $0x802b3c
  80101c:	e8 ed 12 00 00       	call   80230e <_panic>

00801021 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	57                   	push   %edi
  801025:	56                   	push   %esi
  801026:	53                   	push   %ebx
  801027:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	b8 05 00 00 00       	mov    $0x5,%eax
  801035:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801038:	8b 7d 14             	mov    0x14(%ebp),%edi
  80103b:	8b 75 18             	mov    0x18(%ebp),%esi
  80103e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801040:	85 c0                	test   %eax,%eax
  801042:	7f 08                	jg     80104c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104c:	83 ec 0c             	sub    $0xc,%esp
  80104f:	50                   	push   %eax
  801050:	6a 05                	push   $0x5
  801052:	68 1f 2b 80 00       	push   $0x802b1f
  801057:	6a 23                	push   $0x23
  801059:	68 3c 2b 80 00       	push   $0x802b3c
  80105e:	e8 ab 12 00 00       	call   80230e <_panic>

00801063 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	57                   	push   %edi
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
  801069:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80106c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801071:	8b 55 08             	mov    0x8(%ebp),%edx
  801074:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801077:	b8 06 00 00 00       	mov    $0x6,%eax
  80107c:	89 df                	mov    %ebx,%edi
  80107e:	89 de                	mov    %ebx,%esi
  801080:	cd 30                	int    $0x30
	if(check && ret > 0)
  801082:	85 c0                	test   %eax,%eax
  801084:	7f 08                	jg     80108e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801086:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801089:	5b                   	pop    %ebx
  80108a:	5e                   	pop    %esi
  80108b:	5f                   	pop    %edi
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108e:	83 ec 0c             	sub    $0xc,%esp
  801091:	50                   	push   %eax
  801092:	6a 06                	push   $0x6
  801094:	68 1f 2b 80 00       	push   $0x802b1f
  801099:	6a 23                	push   $0x23
  80109b:	68 3c 2b 80 00       	push   $0x802b3c
  8010a0:	e8 69 12 00 00       	call   80230e <_panic>

008010a5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	57                   	push   %edi
  8010a9:	56                   	push   %esi
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8010be:	89 df                	mov    %ebx,%edi
  8010c0:	89 de                	mov    %ebx,%esi
  8010c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	7f 08                	jg     8010d0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5f                   	pop    %edi
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d0:	83 ec 0c             	sub    $0xc,%esp
  8010d3:	50                   	push   %eax
  8010d4:	6a 08                	push   $0x8
  8010d6:	68 1f 2b 80 00       	push   $0x802b1f
  8010db:	6a 23                	push   $0x23
  8010dd:	68 3c 2b 80 00       	push   $0x802b3c
  8010e2:	e8 27 12 00 00       	call   80230e <_panic>

008010e7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fb:	b8 09 00 00 00       	mov    $0x9,%eax
  801100:	89 df                	mov    %ebx,%edi
  801102:	89 de                	mov    %ebx,%esi
  801104:	cd 30                	int    $0x30
	if(check && ret > 0)
  801106:	85 c0                	test   %eax,%eax
  801108:	7f 08                	jg     801112 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80110a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801112:	83 ec 0c             	sub    $0xc,%esp
  801115:	50                   	push   %eax
  801116:	6a 09                	push   $0x9
  801118:	68 1f 2b 80 00       	push   $0x802b1f
  80111d:	6a 23                	push   $0x23
  80111f:	68 3c 2b 80 00       	push   $0x802b3c
  801124:	e8 e5 11 00 00       	call   80230e <_panic>

00801129 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	57                   	push   %edi
  80112d:	56                   	push   %esi
  80112e:	53                   	push   %ebx
  80112f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801132:	bb 00 00 00 00       	mov    $0x0,%ebx
  801137:	8b 55 08             	mov    0x8(%ebp),%edx
  80113a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801142:	89 df                	mov    %ebx,%edi
  801144:	89 de                	mov    %ebx,%esi
  801146:	cd 30                	int    $0x30
	if(check && ret > 0)
  801148:	85 c0                	test   %eax,%eax
  80114a:	7f 08                	jg     801154 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80114c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	50                   	push   %eax
  801158:	6a 0a                	push   $0xa
  80115a:	68 1f 2b 80 00       	push   $0x802b1f
  80115f:	6a 23                	push   $0x23
  801161:	68 3c 2b 80 00       	push   $0x802b3c
  801166:	e8 a3 11 00 00       	call   80230e <_panic>

0080116b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	57                   	push   %edi
  80116f:	56                   	push   %esi
  801170:	53                   	push   %ebx
	asm volatile("int %1\n"
  801171:	8b 55 08             	mov    0x8(%ebp),%edx
  801174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801177:	b8 0c 00 00 00       	mov    $0xc,%eax
  80117c:	be 00 00 00 00       	mov    $0x0,%esi
  801181:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801184:	8b 7d 14             	mov    0x14(%ebp),%edi
  801187:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801197:	b9 00 00 00 00       	mov    $0x0,%ecx
  80119c:	8b 55 08             	mov    0x8(%ebp),%edx
  80119f:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011a4:	89 cb                	mov    %ecx,%ebx
  8011a6:	89 cf                	mov    %ecx,%edi
  8011a8:	89 ce                	mov    %ecx,%esi
  8011aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	7f 08                	jg     8011b8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b3:	5b                   	pop    %ebx
  8011b4:	5e                   	pop    %esi
  8011b5:	5f                   	pop    %edi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	50                   	push   %eax
  8011bc:	6a 0d                	push   $0xd
  8011be:	68 1f 2b 80 00       	push   $0x802b1f
  8011c3:	6a 23                	push   $0x23
  8011c5:	68 3c 2b 80 00       	push   $0x802b3c
  8011ca:	e8 3f 11 00 00       	call   80230e <_panic>

008011cf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011da:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011df:	89 d1                	mov    %edx,%ecx
  8011e1:	89 d3                	mov    %edx,%ebx
  8011e3:	89 d7                	mov    %edx,%edi
  8011e5:	89 d6                	mov    %edx,%esi
  8011e7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011e9:	5b                   	pop    %ebx
  8011ea:	5e                   	pop    %esi
  8011eb:	5f                   	pop    %edi
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	05 00 00 00 30       	add    $0x30000000,%eax
  8011f9:	c1 e8 0c             	shr    $0xc,%eax
}
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801209:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80120e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801220:	89 c2                	mov    %eax,%edx
  801222:	c1 ea 16             	shr    $0x16,%edx
  801225:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80122c:	f6 c2 01             	test   $0x1,%dl
  80122f:	74 2a                	je     80125b <fd_alloc+0x46>
  801231:	89 c2                	mov    %eax,%edx
  801233:	c1 ea 0c             	shr    $0xc,%edx
  801236:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123d:	f6 c2 01             	test   $0x1,%dl
  801240:	74 19                	je     80125b <fd_alloc+0x46>
  801242:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801247:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80124c:	75 d2                	jne    801220 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80124e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801254:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801259:	eb 07                	jmp    801262 <fd_alloc+0x4d>
			*fd_store = fd;
  80125b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    

00801264 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80126a:	83 f8 1f             	cmp    $0x1f,%eax
  80126d:	77 36                	ja     8012a5 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80126f:	c1 e0 0c             	shl    $0xc,%eax
  801272:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801277:	89 c2                	mov    %eax,%edx
  801279:	c1 ea 16             	shr    $0x16,%edx
  80127c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801283:	f6 c2 01             	test   $0x1,%dl
  801286:	74 24                	je     8012ac <fd_lookup+0x48>
  801288:	89 c2                	mov    %eax,%edx
  80128a:	c1 ea 0c             	shr    $0xc,%edx
  80128d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801294:	f6 c2 01             	test   $0x1,%dl
  801297:	74 1a                	je     8012b3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129c:	89 02                	mov    %eax,(%edx)
	return 0;
  80129e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    
		return -E_INVAL;
  8012a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012aa:	eb f7                	jmp    8012a3 <fd_lookup+0x3f>
		return -E_INVAL;
  8012ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b1:	eb f0                	jmp    8012a3 <fd_lookup+0x3f>
  8012b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b8:	eb e9                	jmp    8012a3 <fd_lookup+0x3f>

008012ba <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	83 ec 08             	sub    $0x8,%esp
  8012c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c3:	ba c8 2b 80 00       	mov    $0x802bc8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012c8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012cd:	39 08                	cmp    %ecx,(%eax)
  8012cf:	74 33                	je     801304 <dev_lookup+0x4a>
  8012d1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012d4:	8b 02                	mov    (%edx),%eax
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	75 f3                	jne    8012cd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012da:	a1 18 40 80 00       	mov    0x804018,%eax
  8012df:	8b 40 48             	mov    0x48(%eax),%eax
  8012e2:	83 ec 04             	sub    $0x4,%esp
  8012e5:	51                   	push   %ecx
  8012e6:	50                   	push   %eax
  8012e7:	68 4c 2b 80 00       	push   $0x802b4c
  8012ec:	e8 d5 f2 ff ff       	call   8005c6 <cprintf>
	*dev = 0;
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801302:	c9                   	leave  
  801303:	c3                   	ret    
			*dev = devtab[i];
  801304:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801307:	89 01                	mov    %eax,(%ecx)
			return 0;
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
  80130e:	eb f2                	jmp    801302 <dev_lookup+0x48>

00801310 <fd_close>:
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	57                   	push   %edi
  801314:	56                   	push   %esi
  801315:	53                   	push   %ebx
  801316:	83 ec 1c             	sub    $0x1c,%esp
  801319:	8b 75 08             	mov    0x8(%ebp),%esi
  80131c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80131f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801322:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801323:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801329:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80132c:	50                   	push   %eax
  80132d:	e8 32 ff ff ff       	call   801264 <fd_lookup>
  801332:	89 c3                	mov    %eax,%ebx
  801334:	83 c4 08             	add    $0x8,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	78 05                	js     801340 <fd_close+0x30>
	    || fd != fd2)
  80133b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80133e:	74 16                	je     801356 <fd_close+0x46>
		return (must_exist ? r : 0);
  801340:	89 f8                	mov    %edi,%eax
  801342:	84 c0                	test   %al,%al
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
  801349:	0f 44 d8             	cmove  %eax,%ebx
}
  80134c:	89 d8                	mov    %ebx,%eax
  80134e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5f                   	pop    %edi
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801356:	83 ec 08             	sub    $0x8,%esp
  801359:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80135c:	50                   	push   %eax
  80135d:	ff 36                	pushl  (%esi)
  80135f:	e8 56 ff ff ff       	call   8012ba <dev_lookup>
  801364:	89 c3                	mov    %eax,%ebx
  801366:	83 c4 10             	add    $0x10,%esp
  801369:	85 c0                	test   %eax,%eax
  80136b:	78 15                	js     801382 <fd_close+0x72>
		if (dev->dev_close)
  80136d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801370:	8b 40 10             	mov    0x10(%eax),%eax
  801373:	85 c0                	test   %eax,%eax
  801375:	74 1b                	je     801392 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801377:	83 ec 0c             	sub    $0xc,%esp
  80137a:	56                   	push   %esi
  80137b:	ff d0                	call   *%eax
  80137d:	89 c3                	mov    %eax,%ebx
  80137f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	56                   	push   %esi
  801386:	6a 00                	push   $0x0
  801388:	e8 d6 fc ff ff       	call   801063 <sys_page_unmap>
	return r;
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	eb ba                	jmp    80134c <fd_close+0x3c>
			r = 0;
  801392:	bb 00 00 00 00       	mov    $0x0,%ebx
  801397:	eb e9                	jmp    801382 <fd_close+0x72>

00801399 <close>:

int
close(int fdnum)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80139f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a2:	50                   	push   %eax
  8013a3:	ff 75 08             	pushl  0x8(%ebp)
  8013a6:	e8 b9 fe ff ff       	call   801264 <fd_lookup>
  8013ab:	83 c4 08             	add    $0x8,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 10                	js     8013c2 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	6a 01                	push   $0x1
  8013b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ba:	e8 51 ff ff ff       	call   801310 <fd_close>
  8013bf:	83 c4 10             	add    $0x10,%esp
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <close_all>:

void
close_all(void)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	53                   	push   %ebx
  8013c8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013cb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	53                   	push   %ebx
  8013d4:	e8 c0 ff ff ff       	call   801399 <close>
	for (i = 0; i < MAXFD; i++)
  8013d9:	83 c3 01             	add    $0x1,%ebx
  8013dc:	83 c4 10             	add    $0x10,%esp
  8013df:	83 fb 20             	cmp    $0x20,%ebx
  8013e2:	75 ec                	jne    8013d0 <close_all+0xc>
}
  8013e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	57                   	push   %edi
  8013ed:	56                   	push   %esi
  8013ee:	53                   	push   %ebx
  8013ef:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013f5:	50                   	push   %eax
  8013f6:	ff 75 08             	pushl  0x8(%ebp)
  8013f9:	e8 66 fe ff ff       	call   801264 <fd_lookup>
  8013fe:	89 c3                	mov    %eax,%ebx
  801400:	83 c4 08             	add    $0x8,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	0f 88 81 00 00 00    	js     80148c <dup+0xa3>
		return r;
	close(newfdnum);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	ff 75 0c             	pushl  0xc(%ebp)
  801411:	e8 83 ff ff ff       	call   801399 <close>

	newfd = INDEX2FD(newfdnum);
  801416:	8b 75 0c             	mov    0xc(%ebp),%esi
  801419:	c1 e6 0c             	shl    $0xc,%esi
  80141c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801422:	83 c4 04             	add    $0x4,%esp
  801425:	ff 75 e4             	pushl  -0x1c(%ebp)
  801428:	e8 d1 fd ff ff       	call   8011fe <fd2data>
  80142d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80142f:	89 34 24             	mov    %esi,(%esp)
  801432:	e8 c7 fd ff ff       	call   8011fe <fd2data>
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80143c:	89 d8                	mov    %ebx,%eax
  80143e:	c1 e8 16             	shr    $0x16,%eax
  801441:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801448:	a8 01                	test   $0x1,%al
  80144a:	74 11                	je     80145d <dup+0x74>
  80144c:	89 d8                	mov    %ebx,%eax
  80144e:	c1 e8 0c             	shr    $0xc,%eax
  801451:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801458:	f6 c2 01             	test   $0x1,%dl
  80145b:	75 39                	jne    801496 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80145d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801460:	89 d0                	mov    %edx,%eax
  801462:	c1 e8 0c             	shr    $0xc,%eax
  801465:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	25 07 0e 00 00       	and    $0xe07,%eax
  801474:	50                   	push   %eax
  801475:	56                   	push   %esi
  801476:	6a 00                	push   $0x0
  801478:	52                   	push   %edx
  801479:	6a 00                	push   $0x0
  80147b:	e8 a1 fb ff ff       	call   801021 <sys_page_map>
  801480:	89 c3                	mov    %eax,%ebx
  801482:	83 c4 20             	add    $0x20,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 31                	js     8014ba <dup+0xd1>
		goto err;

	return newfdnum;
  801489:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80148c:	89 d8                	mov    %ebx,%eax
  80148e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801491:	5b                   	pop    %ebx
  801492:	5e                   	pop    %esi
  801493:	5f                   	pop    %edi
  801494:	5d                   	pop    %ebp
  801495:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801496:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80149d:	83 ec 0c             	sub    $0xc,%esp
  8014a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a5:	50                   	push   %eax
  8014a6:	57                   	push   %edi
  8014a7:	6a 00                	push   $0x0
  8014a9:	53                   	push   %ebx
  8014aa:	6a 00                	push   $0x0
  8014ac:	e8 70 fb ff ff       	call   801021 <sys_page_map>
  8014b1:	89 c3                	mov    %eax,%ebx
  8014b3:	83 c4 20             	add    $0x20,%esp
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	79 a3                	jns    80145d <dup+0x74>
	sys_page_unmap(0, newfd);
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	56                   	push   %esi
  8014be:	6a 00                	push   $0x0
  8014c0:	e8 9e fb ff ff       	call   801063 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014c5:	83 c4 08             	add    $0x8,%esp
  8014c8:	57                   	push   %edi
  8014c9:	6a 00                	push   $0x0
  8014cb:	e8 93 fb ff ff       	call   801063 <sys_page_unmap>
	return r;
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	eb b7                	jmp    80148c <dup+0xa3>

008014d5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	53                   	push   %ebx
  8014d9:	83 ec 14             	sub    $0x14,%esp
  8014dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e2:	50                   	push   %eax
  8014e3:	53                   	push   %ebx
  8014e4:	e8 7b fd ff ff       	call   801264 <fd_lookup>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 3f                	js     80152f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f0:	83 ec 08             	sub    $0x8,%esp
  8014f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f6:	50                   	push   %eax
  8014f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fa:	ff 30                	pushl  (%eax)
  8014fc:	e8 b9 fd ff ff       	call   8012ba <dev_lookup>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 27                	js     80152f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801508:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150b:	8b 42 08             	mov    0x8(%edx),%eax
  80150e:	83 e0 03             	and    $0x3,%eax
  801511:	83 f8 01             	cmp    $0x1,%eax
  801514:	74 1e                	je     801534 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801519:	8b 40 08             	mov    0x8(%eax),%eax
  80151c:	85 c0                	test   %eax,%eax
  80151e:	74 35                	je     801555 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	ff 75 10             	pushl  0x10(%ebp)
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	52                   	push   %edx
  80152a:	ff d0                	call   *%eax
  80152c:	83 c4 10             	add    $0x10,%esp
}
  80152f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801532:	c9                   	leave  
  801533:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801534:	a1 18 40 80 00       	mov    0x804018,%eax
  801539:	8b 40 48             	mov    0x48(%eax),%eax
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	53                   	push   %ebx
  801540:	50                   	push   %eax
  801541:	68 8d 2b 80 00       	push   $0x802b8d
  801546:	e8 7b f0 ff ff       	call   8005c6 <cprintf>
		return -E_INVAL;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801553:	eb da                	jmp    80152f <read+0x5a>
		return -E_NOT_SUPP;
  801555:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155a:	eb d3                	jmp    80152f <read+0x5a>

0080155c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	57                   	push   %edi
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	8b 7d 08             	mov    0x8(%ebp),%edi
  801568:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80156b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801570:	39 f3                	cmp    %esi,%ebx
  801572:	73 25                	jae    801599 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	89 f0                	mov    %esi,%eax
  801579:	29 d8                	sub    %ebx,%eax
  80157b:	50                   	push   %eax
  80157c:	89 d8                	mov    %ebx,%eax
  80157e:	03 45 0c             	add    0xc(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	57                   	push   %edi
  801583:	e8 4d ff ff ff       	call   8014d5 <read>
		if (m < 0)
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	78 08                	js     801597 <readn+0x3b>
			return m;
		if (m == 0)
  80158f:	85 c0                	test   %eax,%eax
  801591:	74 06                	je     801599 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801593:	01 c3                	add    %eax,%ebx
  801595:	eb d9                	jmp    801570 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801597:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801599:	89 d8                	mov    %ebx,%eax
  80159b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159e:	5b                   	pop    %ebx
  80159f:	5e                   	pop    %esi
  8015a0:	5f                   	pop    %edi
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    

008015a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 14             	sub    $0x14,%esp
  8015aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	53                   	push   %ebx
  8015b2:	e8 ad fc ff ff       	call   801264 <fd_lookup>
  8015b7:	83 c4 08             	add    $0x8,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 3a                	js     8015f8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c4:	50                   	push   %eax
  8015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c8:	ff 30                	pushl  (%eax)
  8015ca:	e8 eb fc ff ff       	call   8012ba <dev_lookup>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	78 22                	js     8015f8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015dd:	74 1e                	je     8015fd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8015e5:	85 d2                	test   %edx,%edx
  8015e7:	74 35                	je     80161e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	ff 75 10             	pushl  0x10(%ebp)
  8015ef:	ff 75 0c             	pushl  0xc(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff d2                	call   *%edx
  8015f5:	83 c4 10             	add    $0x10,%esp
}
  8015f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015fd:	a1 18 40 80 00       	mov    0x804018,%eax
  801602:	8b 40 48             	mov    0x48(%eax),%eax
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	53                   	push   %ebx
  801609:	50                   	push   %eax
  80160a:	68 a9 2b 80 00       	push   $0x802ba9
  80160f:	e8 b2 ef ff ff       	call   8005c6 <cprintf>
		return -E_INVAL;
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161c:	eb da                	jmp    8015f8 <write+0x55>
		return -E_NOT_SUPP;
  80161e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801623:	eb d3                	jmp    8015f8 <write+0x55>

00801625 <seek>:

int
seek(int fdnum, off_t offset)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80162e:	50                   	push   %eax
  80162f:	ff 75 08             	pushl  0x8(%ebp)
  801632:	e8 2d fc ff ff       	call   801264 <fd_lookup>
  801637:	83 c4 08             	add    $0x8,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 0e                	js     80164c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801644:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	53                   	push   %ebx
  801652:	83 ec 14             	sub    $0x14,%esp
  801655:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801658:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	53                   	push   %ebx
  80165d:	e8 02 fc ff ff       	call   801264 <fd_lookup>
  801662:	83 c4 08             	add    $0x8,%esp
  801665:	85 c0                	test   %eax,%eax
  801667:	78 37                	js     8016a0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	ff 30                	pushl  (%eax)
  801675:	e8 40 fc ff ff       	call   8012ba <dev_lookup>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 1f                	js     8016a0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801684:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801688:	74 1b                	je     8016a5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80168a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168d:	8b 52 18             	mov    0x18(%edx),%edx
  801690:	85 d2                	test   %edx,%edx
  801692:	74 32                	je     8016c6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	50                   	push   %eax
  80169b:	ff d2                	call   *%edx
  80169d:	83 c4 10             	add    $0x10,%esp
}
  8016a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016a5:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016aa:	8b 40 48             	mov    0x48(%eax),%eax
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	53                   	push   %ebx
  8016b1:	50                   	push   %eax
  8016b2:	68 6c 2b 80 00       	push   $0x802b6c
  8016b7:	e8 0a ef ff ff       	call   8005c6 <cprintf>
		return -E_INVAL;
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c4:	eb da                	jmp    8016a0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cb:	eb d3                	jmp    8016a0 <ftruncate+0x52>

008016cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 14             	sub    $0x14,%esp
  8016d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016da:	50                   	push   %eax
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	e8 81 fb ff ff       	call   801264 <fd_lookup>
  8016e3:	83 c4 08             	add    $0x8,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 4b                	js     801735 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f0:	50                   	push   %eax
  8016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f4:	ff 30                	pushl  (%eax)
  8016f6:	e8 bf fb ff ff       	call   8012ba <dev_lookup>
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 33                	js     801735 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801709:	74 2f                	je     80173a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80170b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80170e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801715:	00 00 00 
	stat->st_isdir = 0;
  801718:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80171f:	00 00 00 
	stat->st_dev = dev;
  801722:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	53                   	push   %ebx
  80172c:	ff 75 f0             	pushl  -0x10(%ebp)
  80172f:	ff 50 14             	call   *0x14(%eax)
  801732:	83 c4 10             	add    $0x10,%esp
}
  801735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801738:	c9                   	leave  
  801739:	c3                   	ret    
		return -E_NOT_SUPP;
  80173a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173f:	eb f4                	jmp    801735 <fstat+0x68>

00801741 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	56                   	push   %esi
  801745:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801746:	83 ec 08             	sub    $0x8,%esp
  801749:	6a 00                	push   $0x0
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	e8 e7 01 00 00       	call   80193a <open>
  801753:	89 c3                	mov    %eax,%ebx
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 1b                	js     801777 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80175c:	83 ec 08             	sub    $0x8,%esp
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	50                   	push   %eax
  801763:	e8 65 ff ff ff       	call   8016cd <fstat>
  801768:	89 c6                	mov    %eax,%esi
	close(fd);
  80176a:	89 1c 24             	mov    %ebx,(%esp)
  80176d:	e8 27 fc ff ff       	call   801399 <close>
	return r;
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 f3                	mov    %esi,%ebx
}
  801777:	89 d8                	mov    %ebx,%eax
  801779:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    

00801780 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
  801785:	89 c6                	mov    %eax,%esi
  801787:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801789:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  801790:	74 27                	je     8017b9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801792:	6a 07                	push   $0x7
  801794:	68 00 50 80 00       	push   $0x805000
  801799:	56                   	push   %esi
  80179a:	ff 35 10 40 80 00    	pushl  0x804010
  8017a0:	e8 16 0c 00 00       	call   8023bb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017a5:	83 c4 0c             	add    $0xc,%esp
  8017a8:	6a 00                	push   $0x0
  8017aa:	53                   	push   %ebx
  8017ab:	6a 00                	push   $0x0
  8017ad:	e8 a2 0b 00 00       	call   802354 <ipc_recv>
}
  8017b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017b9:	83 ec 0c             	sub    $0xc,%esp
  8017bc:	6a 01                	push   $0x1
  8017be:	e8 4c 0c 00 00       	call   80240f <ipc_find_env>
  8017c3:	a3 10 40 80 00       	mov    %eax,0x804010
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	eb c5                	jmp    801792 <fsipc+0x12>

008017cd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f0:	e8 8b ff ff ff       	call   801780 <fsipc>
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <devfile_flush>:
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 40 0c             	mov    0xc(%eax),%eax
  801803:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801808:	ba 00 00 00 00       	mov    $0x0,%edx
  80180d:	b8 06 00 00 00       	mov    $0x6,%eax
  801812:	e8 69 ff ff ff       	call   801780 <fsipc>
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <devfile_stat>:
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	53                   	push   %ebx
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8b 40 0c             	mov    0xc(%eax),%eax
  801829:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
  801833:	b8 05 00 00 00       	mov    $0x5,%eax
  801838:	e8 43 ff ff ff       	call   801780 <fsipc>
  80183d:	85 c0                	test   %eax,%eax
  80183f:	78 2c                	js     80186d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	68 00 50 80 00       	push   $0x805000
  801849:	53                   	push   %ebx
  80184a:	e8 96 f3 ff ff       	call   800be5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80184f:	a1 80 50 80 00       	mov    0x805080,%eax
  801854:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80185a:	a1 84 50 80 00       	mov    0x805084,%eax
  80185f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <devfile_write>:
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	8b 45 10             	mov    0x10(%ebp),%eax
  80187b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801880:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801885:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801888:	8b 55 08             	mov    0x8(%ebp),%edx
  80188b:	8b 52 0c             	mov    0xc(%edx),%edx
  80188e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801894:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801899:	50                   	push   %eax
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	68 08 50 80 00       	push   $0x805008
  8018a2:	e8 cc f4 ff ff       	call   800d73 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	b8 04 00 00 00       	mov    $0x4,%eax
  8018b1:	e8 ca fe ff ff       	call   801780 <fsipc>
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <devfile_read>:
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018cb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d6:	b8 03 00 00 00       	mov    $0x3,%eax
  8018db:	e8 a0 fe ff ff       	call   801780 <fsipc>
  8018e0:	89 c3                	mov    %eax,%ebx
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 1f                	js     801905 <devfile_read+0x4d>
	assert(r <= n);
  8018e6:	39 f0                	cmp    %esi,%eax
  8018e8:	77 24                	ja     80190e <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ef:	7f 33                	jg     801924 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	50                   	push   %eax
  8018f5:	68 00 50 80 00       	push   $0x805000
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	e8 71 f4 ff ff       	call   800d73 <memmove>
	return r;
  801902:	83 c4 10             	add    $0x10,%esp
}
  801905:	89 d8                	mov    %ebx,%eax
  801907:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    
	assert(r <= n);
  80190e:	68 dc 2b 80 00       	push   $0x802bdc
  801913:	68 e3 2b 80 00       	push   $0x802be3
  801918:	6a 7b                	push   $0x7b
  80191a:	68 f8 2b 80 00       	push   $0x802bf8
  80191f:	e8 ea 09 00 00       	call   80230e <_panic>
	assert(r <= PGSIZE);
  801924:	68 03 2c 80 00       	push   $0x802c03
  801929:	68 e3 2b 80 00       	push   $0x802be3
  80192e:	6a 7c                	push   $0x7c
  801930:	68 f8 2b 80 00       	push   $0x802bf8
  801935:	e8 d4 09 00 00       	call   80230e <_panic>

0080193a <open>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	56                   	push   %esi
  80193e:	53                   	push   %ebx
  80193f:	83 ec 1c             	sub    $0x1c,%esp
  801942:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801945:	56                   	push   %esi
  801946:	e8 63 f2 ff ff       	call   800bae <strlen>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801953:	7f 6c                	jg     8019c1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195b:	50                   	push   %eax
  80195c:	e8 b4 f8 ff ff       	call   801215 <fd_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	78 3c                	js     8019a6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	56                   	push   %esi
  80196e:	68 00 50 80 00       	push   $0x805000
  801973:	e8 6d f2 ff ff       	call   800be5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801983:	b8 01 00 00 00       	mov    $0x1,%eax
  801988:	e8 f3 fd ff ff       	call   801780 <fsipc>
  80198d:	89 c3                	mov    %eax,%ebx
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	78 19                	js     8019af <open+0x75>
	return fd2num(fd);
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	ff 75 f4             	pushl  -0xc(%ebp)
  80199c:	e8 4d f8 ff ff       	call   8011ee <fd2num>
  8019a1:	89 c3                	mov    %eax,%ebx
  8019a3:	83 c4 10             	add    $0x10,%esp
}
  8019a6:	89 d8                	mov    %ebx,%eax
  8019a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    
		fd_close(fd, 0);
  8019af:	83 ec 08             	sub    $0x8,%esp
  8019b2:	6a 00                	push   $0x0
  8019b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b7:	e8 54 f9 ff ff       	call   801310 <fd_close>
		return r;
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	eb e5                	jmp    8019a6 <open+0x6c>
		return -E_BAD_PATH;
  8019c1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c6:	eb de                	jmp    8019a6 <open+0x6c>

008019c8 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d8:	e8 a3 fd ff ff       	call   801780 <fsipc>
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019e5:	68 0f 2c 80 00       	push   $0x802c0f
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	e8 f3 f1 ff ff       	call   800be5 <strcpy>
	return 0;
}
  8019f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <devsock_close>:
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	53                   	push   %ebx
  8019fd:	83 ec 10             	sub    $0x10,%esp
  801a00:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a03:	53                   	push   %ebx
  801a04:	e8 3f 0a 00 00       	call   802448 <pageref>
  801a09:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a0c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a11:	83 f8 01             	cmp    $0x1,%eax
  801a14:	74 07                	je     801a1d <devsock_close+0x24>
}
  801a16:	89 d0                	mov    %edx,%eax
  801a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	ff 73 0c             	pushl  0xc(%ebx)
  801a23:	e8 b7 02 00 00       	call   801cdf <nsipc_close>
  801a28:	89 c2                	mov    %eax,%edx
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	eb e7                	jmp    801a16 <devsock_close+0x1d>

00801a2f <devsock_write>:
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 10             	pushl  0x10(%ebp)
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	ff 70 0c             	pushl  0xc(%eax)
  801a43:	e8 74 03 00 00       	call   801dbc <nsipc_send>
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <devsock_read>:
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 10             	pushl  0x10(%ebp)
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	ff 70 0c             	pushl  0xc(%eax)
  801a5e:	e8 ed 02 00 00       	call   801d50 <nsipc_recv>
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <fd2sockid>:
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a6b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a6e:	52                   	push   %edx
  801a6f:	50                   	push   %eax
  801a70:	e8 ef f7 ff ff       	call   801264 <fd_lookup>
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	78 10                	js     801a8c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a85:	39 08                	cmp    %ecx,(%eax)
  801a87:	75 05                	jne    801a8e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a89:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    
		return -E_NOT_SUPP;
  801a8e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a93:	eb f7                	jmp    801a8c <fd2sockid+0x27>

00801a95 <alloc_sockfd>:
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	56                   	push   %esi
  801a99:	53                   	push   %ebx
  801a9a:	83 ec 1c             	sub    $0x1c,%esp
  801a9d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa2:	50                   	push   %eax
  801aa3:	e8 6d f7 ff ff       	call   801215 <fd_alloc>
  801aa8:	89 c3                	mov    %eax,%ebx
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 43                	js     801af4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	68 07 04 00 00       	push   $0x407
  801ab9:	ff 75 f4             	pushl  -0xc(%ebp)
  801abc:	6a 00                	push   $0x0
  801abe:	e8 1b f5 ff ff       	call   800fde <sys_page_alloc>
  801ac3:	89 c3                	mov    %eax,%ebx
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	78 28                	js     801af4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ad5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ada:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ae1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ae4:	83 ec 0c             	sub    $0xc,%esp
  801ae7:	50                   	push   %eax
  801ae8:	e8 01 f7 ff ff       	call   8011ee <fd2num>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	eb 0c                	jmp    801b00 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	56                   	push   %esi
  801af8:	e8 e2 01 00 00       	call   801cdf <nsipc_close>
		return r;
  801afd:	83 c4 10             	add    $0x10,%esp
}
  801b00:	89 d8                	mov    %ebx,%eax
  801b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b05:	5b                   	pop    %ebx
  801b06:	5e                   	pop    %esi
  801b07:	5d                   	pop    %ebp
  801b08:	c3                   	ret    

00801b09 <accept>:
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	e8 4e ff ff ff       	call   801a65 <fd2sockid>
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 1b                	js     801b36 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b1b:	83 ec 04             	sub    $0x4,%esp
  801b1e:	ff 75 10             	pushl  0x10(%ebp)
  801b21:	ff 75 0c             	pushl  0xc(%ebp)
  801b24:	50                   	push   %eax
  801b25:	e8 0e 01 00 00       	call   801c38 <nsipc_accept>
  801b2a:	83 c4 10             	add    $0x10,%esp
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 05                	js     801b36 <accept+0x2d>
	return alloc_sockfd(r);
  801b31:	e8 5f ff ff ff       	call   801a95 <alloc_sockfd>
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <bind>:
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	e8 1f ff ff ff       	call   801a65 <fd2sockid>
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 12                	js     801b5c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	50                   	push   %eax
  801b54:	e8 2f 01 00 00       	call   801c88 <nsipc_bind>
  801b59:	83 c4 10             	add    $0x10,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <shutdown>:
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	e8 f9 fe ff ff       	call   801a65 <fd2sockid>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 0f                	js     801b7f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b70:	83 ec 08             	sub    $0x8,%esp
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	50                   	push   %eax
  801b77:	e8 41 01 00 00       	call   801cbd <nsipc_shutdown>
  801b7c:	83 c4 10             	add    $0x10,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <connect>:
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	e8 d6 fe ff ff       	call   801a65 <fd2sockid>
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 12                	js     801ba5 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	ff 75 10             	pushl  0x10(%ebp)
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	50                   	push   %eax
  801b9d:	e8 57 01 00 00       	call   801cf9 <nsipc_connect>
  801ba2:	83 c4 10             	add    $0x10,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <listen>:
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	e8 b0 fe ff ff       	call   801a65 <fd2sockid>
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 0f                	js     801bc8 <listen+0x21>
	return nsipc_listen(r, backlog);
  801bb9:	83 ec 08             	sub    $0x8,%esp
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	50                   	push   %eax
  801bc0:	e8 69 01 00 00       	call   801d2e <nsipc_listen>
  801bc5:	83 c4 10             	add    $0x10,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <socket>:

int
socket(int domain, int type, int protocol)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bd0:	ff 75 10             	pushl  0x10(%ebp)
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	e8 3c 02 00 00       	call   801e1a <nsipc_socket>
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 05                	js     801bea <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801be5:	e8 ab fe ff ff       	call   801a95 <alloc_sockfd>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bf5:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801bfc:	74 26                	je     801c24 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bfe:	6a 07                	push   $0x7
  801c00:	68 00 60 80 00       	push   $0x806000
  801c05:	53                   	push   %ebx
  801c06:	ff 35 14 40 80 00    	pushl  0x804014
  801c0c:	e8 aa 07 00 00       	call   8023bb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c11:	83 c4 0c             	add    $0xc,%esp
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	e8 35 07 00 00       	call   802354 <ipc_recv>
}
  801c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c24:	83 ec 0c             	sub    $0xc,%esp
  801c27:	6a 02                	push   $0x2
  801c29:	e8 e1 07 00 00       	call   80240f <ipc_find_env>
  801c2e:	a3 14 40 80 00       	mov    %eax,0x804014
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	eb c6                	jmp    801bfe <nsipc+0x12>

00801c38 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	56                   	push   %esi
  801c3c:	53                   	push   %ebx
  801c3d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c48:	8b 06                	mov    (%esi),%eax
  801c4a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c54:	e8 93 ff ff ff       	call   801bec <nsipc>
  801c59:	89 c3                	mov    %eax,%ebx
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 20                	js     801c7f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c5f:	83 ec 04             	sub    $0x4,%esp
  801c62:	ff 35 10 60 80 00    	pushl  0x806010
  801c68:	68 00 60 80 00       	push   $0x806000
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	e8 fe f0 ff ff       	call   800d73 <memmove>
		*addrlen = ret->ret_addrlen;
  801c75:	a1 10 60 80 00       	mov    0x806010,%eax
  801c7a:	89 06                	mov    %eax,(%esi)
  801c7c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c7f:	89 d8                	mov    %ebx,%eax
  801c81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    

00801c88 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	53                   	push   %ebx
  801c8c:	83 ec 08             	sub    $0x8,%esp
  801c8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c9a:	53                   	push   %ebx
  801c9b:	ff 75 0c             	pushl  0xc(%ebp)
  801c9e:	68 04 60 80 00       	push   $0x806004
  801ca3:	e8 cb f0 ff ff       	call   800d73 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ca8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cae:	b8 02 00 00 00       	mov    $0x2,%eax
  801cb3:	e8 34 ff ff ff       	call   801bec <nsipc>
}
  801cb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cce:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cd3:	b8 03 00 00 00       	mov    $0x3,%eax
  801cd8:	e8 0f ff ff ff       	call   801bec <nsipc>
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <nsipc_close>:

int
nsipc_close(int s)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ced:	b8 04 00 00 00       	mov    $0x4,%eax
  801cf2:	e8 f5 fe ff ff       	call   801bec <nsipc>
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	53                   	push   %ebx
  801cfd:	83 ec 08             	sub    $0x8,%esp
  801d00:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d0b:	53                   	push   %ebx
  801d0c:	ff 75 0c             	pushl  0xc(%ebp)
  801d0f:	68 04 60 80 00       	push   $0x806004
  801d14:	e8 5a f0 ff ff       	call   800d73 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d19:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d1f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d24:	e8 c3 fe ff ff       	call   801bec <nsipc>
}
  801d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d44:	b8 06 00 00 00       	mov    $0x6,%eax
  801d49:	e8 9e fe ff ff       	call   801bec <nsipc>
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d60:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d66:	8b 45 14             	mov    0x14(%ebp),%eax
  801d69:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d6e:	b8 07 00 00 00       	mov    $0x7,%eax
  801d73:	e8 74 fe ff ff       	call   801bec <nsipc>
  801d78:	89 c3                	mov    %eax,%ebx
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	78 1f                	js     801d9d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d7e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d83:	7f 21                	jg     801da6 <nsipc_recv+0x56>
  801d85:	39 c6                	cmp    %eax,%esi
  801d87:	7c 1d                	jl     801da6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	50                   	push   %eax
  801d8d:	68 00 60 80 00       	push   $0x806000
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	e8 d9 ef ff ff       	call   800d73 <memmove>
  801d9a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d9d:	89 d8                	mov    %ebx,%eax
  801d9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da2:	5b                   	pop    %ebx
  801da3:	5e                   	pop    %esi
  801da4:	5d                   	pop    %ebp
  801da5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801da6:	68 1b 2c 80 00       	push   $0x802c1b
  801dab:	68 e3 2b 80 00       	push   $0x802be3
  801db0:	6a 62                	push   $0x62
  801db2:	68 30 2c 80 00       	push   $0x802c30
  801db7:	e8 52 05 00 00       	call   80230e <_panic>

00801dbc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 04             	sub    $0x4,%esp
  801dc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dce:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dd4:	7f 2e                	jg     801e04 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	53                   	push   %ebx
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	68 0c 60 80 00       	push   $0x80600c
  801de2:	e8 8c ef ff ff       	call   800d73 <memmove>
	nsipcbuf.send.req_size = size;
  801de7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ded:	8b 45 14             	mov    0x14(%ebp),%eax
  801df0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801df5:	b8 08 00 00 00       	mov    $0x8,%eax
  801dfa:	e8 ed fd ff ff       	call   801bec <nsipc>
}
  801dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    
	assert(size < 1600);
  801e04:	68 3c 2c 80 00       	push   $0x802c3c
  801e09:	68 e3 2b 80 00       	push   $0x802be3
  801e0e:	6a 6d                	push   $0x6d
  801e10:	68 30 2c 80 00       	push   $0x802c30
  801e15:	e8 f4 04 00 00       	call   80230e <_panic>

00801e1a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e30:	8b 45 10             	mov    0x10(%ebp),%eax
  801e33:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e38:	b8 09 00 00 00       	mov    $0x9,%eax
  801e3d:	e8 aa fd ff ff       	call   801bec <nsipc>
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	56                   	push   %esi
  801e48:	53                   	push   %ebx
  801e49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	e8 a7 f3 ff ff       	call   8011fe <fd2data>
  801e57:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e59:	83 c4 08             	add    $0x8,%esp
  801e5c:	68 48 2c 80 00       	push   $0x802c48
  801e61:	53                   	push   %ebx
  801e62:	e8 7e ed ff ff       	call   800be5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e67:	8b 46 04             	mov    0x4(%esi),%eax
  801e6a:	2b 06                	sub    (%esi),%eax
  801e6c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e72:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e79:	00 00 00 
	stat->st_dev = &devpipe;
  801e7c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e83:	30 80 00 
	return 0;
}
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5e                   	pop    %esi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    

00801e92 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	53                   	push   %ebx
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e9c:	53                   	push   %ebx
  801e9d:	6a 00                	push   $0x0
  801e9f:	e8 bf f1 ff ff       	call   801063 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ea4:	89 1c 24             	mov    %ebx,(%esp)
  801ea7:	e8 52 f3 ff ff       	call   8011fe <fd2data>
  801eac:	83 c4 08             	add    $0x8,%esp
  801eaf:	50                   	push   %eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	e8 ac f1 ff ff       	call   801063 <sys_page_unmap>
}
  801eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <_pipeisclosed>:
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	57                   	push   %edi
  801ec0:	56                   	push   %esi
  801ec1:	53                   	push   %ebx
  801ec2:	83 ec 1c             	sub    $0x1c,%esp
  801ec5:	89 c7                	mov    %eax,%edi
  801ec7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ec9:	a1 18 40 80 00       	mov    0x804018,%eax
  801ece:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	57                   	push   %edi
  801ed5:	e8 6e 05 00 00       	call   802448 <pageref>
  801eda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801edd:	89 34 24             	mov    %esi,(%esp)
  801ee0:	e8 63 05 00 00       	call   802448 <pageref>
		nn = thisenv->env_runs;
  801ee5:	8b 15 18 40 80 00    	mov    0x804018,%edx
  801eeb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	39 cb                	cmp    %ecx,%ebx
  801ef3:	74 1b                	je     801f10 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ef5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ef8:	75 cf                	jne    801ec9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801efa:	8b 42 58             	mov    0x58(%edx),%eax
  801efd:	6a 01                	push   $0x1
  801eff:	50                   	push   %eax
  801f00:	53                   	push   %ebx
  801f01:	68 4f 2c 80 00       	push   $0x802c4f
  801f06:	e8 bb e6 ff ff       	call   8005c6 <cprintf>
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	eb b9                	jmp    801ec9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f10:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f13:	0f 94 c0             	sete   %al
  801f16:	0f b6 c0             	movzbl %al,%eax
}
  801f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f1c:	5b                   	pop    %ebx
  801f1d:	5e                   	pop    %esi
  801f1e:	5f                   	pop    %edi
  801f1f:	5d                   	pop    %ebp
  801f20:	c3                   	ret    

00801f21 <devpipe_write>:
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	57                   	push   %edi
  801f25:	56                   	push   %esi
  801f26:	53                   	push   %ebx
  801f27:	83 ec 28             	sub    $0x28,%esp
  801f2a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f2d:	56                   	push   %esi
  801f2e:	e8 cb f2 ff ff       	call   8011fe <fd2data>
  801f33:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f40:	74 4f                	je     801f91 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f42:	8b 43 04             	mov    0x4(%ebx),%eax
  801f45:	8b 0b                	mov    (%ebx),%ecx
  801f47:	8d 51 20             	lea    0x20(%ecx),%edx
  801f4a:	39 d0                	cmp    %edx,%eax
  801f4c:	72 14                	jb     801f62 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f4e:	89 da                	mov    %ebx,%edx
  801f50:	89 f0                	mov    %esi,%eax
  801f52:	e8 65 ff ff ff       	call   801ebc <_pipeisclosed>
  801f57:	85 c0                	test   %eax,%eax
  801f59:	75 3a                	jne    801f95 <devpipe_write+0x74>
			sys_yield();
  801f5b:	e8 5f f0 ff ff       	call   800fbf <sys_yield>
  801f60:	eb e0                	jmp    801f42 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f65:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f69:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f6c:	89 c2                	mov    %eax,%edx
  801f6e:	c1 fa 1f             	sar    $0x1f,%edx
  801f71:	89 d1                	mov    %edx,%ecx
  801f73:	c1 e9 1b             	shr    $0x1b,%ecx
  801f76:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f79:	83 e2 1f             	and    $0x1f,%edx
  801f7c:	29 ca                	sub    %ecx,%edx
  801f7e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f82:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f86:	83 c0 01             	add    $0x1,%eax
  801f89:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f8c:	83 c7 01             	add    $0x1,%edi
  801f8f:	eb ac                	jmp    801f3d <devpipe_write+0x1c>
	return i;
  801f91:	89 f8                	mov    %edi,%eax
  801f93:	eb 05                	jmp    801f9a <devpipe_write+0x79>
				return 0;
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9d:	5b                   	pop    %ebx
  801f9e:	5e                   	pop    %esi
  801f9f:	5f                   	pop    %edi
  801fa0:	5d                   	pop    %ebp
  801fa1:	c3                   	ret    

00801fa2 <devpipe_read>:
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	57                   	push   %edi
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 18             	sub    $0x18,%esp
  801fab:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fae:	57                   	push   %edi
  801faf:	e8 4a f2 ff ff       	call   8011fe <fd2data>
  801fb4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	be 00 00 00 00       	mov    $0x0,%esi
  801fbe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc1:	74 47                	je     80200a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801fc3:	8b 03                	mov    (%ebx),%eax
  801fc5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fc8:	75 22                	jne    801fec <devpipe_read+0x4a>
			if (i > 0)
  801fca:	85 f6                	test   %esi,%esi
  801fcc:	75 14                	jne    801fe2 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801fce:	89 da                	mov    %ebx,%edx
  801fd0:	89 f8                	mov    %edi,%eax
  801fd2:	e8 e5 fe ff ff       	call   801ebc <_pipeisclosed>
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	75 33                	jne    80200e <devpipe_read+0x6c>
			sys_yield();
  801fdb:	e8 df ef ff ff       	call   800fbf <sys_yield>
  801fe0:	eb e1                	jmp    801fc3 <devpipe_read+0x21>
				return i;
  801fe2:	89 f0                	mov    %esi,%eax
}
  801fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe7:	5b                   	pop    %ebx
  801fe8:	5e                   	pop    %esi
  801fe9:	5f                   	pop    %edi
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fec:	99                   	cltd   
  801fed:	c1 ea 1b             	shr    $0x1b,%edx
  801ff0:	01 d0                	add    %edx,%eax
  801ff2:	83 e0 1f             	and    $0x1f,%eax
  801ff5:	29 d0                	sub    %edx,%eax
  801ff7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fff:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802002:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802005:	83 c6 01             	add    $0x1,%esi
  802008:	eb b4                	jmp    801fbe <devpipe_read+0x1c>
	return i;
  80200a:	89 f0                	mov    %esi,%eax
  80200c:	eb d6                	jmp    801fe4 <devpipe_read+0x42>
				return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
  802013:	eb cf                	jmp    801fe4 <devpipe_read+0x42>

00802015 <pipe>:
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	56                   	push   %esi
  802019:	53                   	push   %ebx
  80201a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80201d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802020:	50                   	push   %eax
  802021:	e8 ef f1 ff ff       	call   801215 <fd_alloc>
  802026:	89 c3                	mov    %eax,%ebx
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	85 c0                	test   %eax,%eax
  80202d:	78 5b                	js     80208a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	68 07 04 00 00       	push   $0x407
  802037:	ff 75 f4             	pushl  -0xc(%ebp)
  80203a:	6a 00                	push   $0x0
  80203c:	e8 9d ef ff ff       	call   800fde <sys_page_alloc>
  802041:	89 c3                	mov    %eax,%ebx
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	85 c0                	test   %eax,%eax
  802048:	78 40                	js     80208a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80204a:	83 ec 0c             	sub    $0xc,%esp
  80204d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802050:	50                   	push   %eax
  802051:	e8 bf f1 ff ff       	call   801215 <fd_alloc>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 1b                	js     80207a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	68 07 04 00 00       	push   $0x407
  802067:	ff 75 f0             	pushl  -0x10(%ebp)
  80206a:	6a 00                	push   $0x0
  80206c:	e8 6d ef ff ff       	call   800fde <sys_page_alloc>
  802071:	89 c3                	mov    %eax,%ebx
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	85 c0                	test   %eax,%eax
  802078:	79 19                	jns    802093 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80207a:	83 ec 08             	sub    $0x8,%esp
  80207d:	ff 75 f4             	pushl  -0xc(%ebp)
  802080:	6a 00                	push   $0x0
  802082:	e8 dc ef ff ff       	call   801063 <sys_page_unmap>
  802087:	83 c4 10             	add    $0x10,%esp
}
  80208a:	89 d8                	mov    %ebx,%eax
  80208c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5d                   	pop    %ebp
  802092:	c3                   	ret    
	va = fd2data(fd0);
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	ff 75 f4             	pushl  -0xc(%ebp)
  802099:	e8 60 f1 ff ff       	call   8011fe <fd2data>
  80209e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a0:	83 c4 0c             	add    $0xc,%esp
  8020a3:	68 07 04 00 00       	push   $0x407
  8020a8:	50                   	push   %eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	e8 2e ef ff ff       	call   800fde <sys_page_alloc>
  8020b0:	89 c3                	mov    %eax,%ebx
  8020b2:	83 c4 10             	add    $0x10,%esp
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	0f 88 8c 00 00 00    	js     802149 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bd:	83 ec 0c             	sub    $0xc,%esp
  8020c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c3:	e8 36 f1 ff ff       	call   8011fe <fd2data>
  8020c8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020cf:	50                   	push   %eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	56                   	push   %esi
  8020d3:	6a 00                	push   $0x0
  8020d5:	e8 47 ef ff ff       	call   801021 <sys_page_map>
  8020da:	89 c3                	mov    %eax,%ebx
  8020dc:	83 c4 20             	add    $0x20,%esp
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 58                	js     80213b <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020ec:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8020f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802101:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802106:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	ff 75 f4             	pushl  -0xc(%ebp)
  802113:	e8 d6 f0 ff ff       	call   8011ee <fd2num>
  802118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80211b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80211d:	83 c4 04             	add    $0x4,%esp
  802120:	ff 75 f0             	pushl  -0x10(%ebp)
  802123:	e8 c6 f0 ff ff       	call   8011ee <fd2num>
  802128:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80212b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	bb 00 00 00 00       	mov    $0x0,%ebx
  802136:	e9 4f ff ff ff       	jmp    80208a <pipe+0x75>
	sys_page_unmap(0, va);
  80213b:	83 ec 08             	sub    $0x8,%esp
  80213e:	56                   	push   %esi
  80213f:	6a 00                	push   $0x0
  802141:	e8 1d ef ff ff       	call   801063 <sys_page_unmap>
  802146:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802149:	83 ec 08             	sub    $0x8,%esp
  80214c:	ff 75 f0             	pushl  -0x10(%ebp)
  80214f:	6a 00                	push   $0x0
  802151:	e8 0d ef ff ff       	call   801063 <sys_page_unmap>
  802156:	83 c4 10             	add    $0x10,%esp
  802159:	e9 1c ff ff ff       	jmp    80207a <pipe+0x65>

0080215e <pipeisclosed>:
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802164:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802167:	50                   	push   %eax
  802168:	ff 75 08             	pushl  0x8(%ebp)
  80216b:	e8 f4 f0 ff ff       	call   801264 <fd_lookup>
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	85 c0                	test   %eax,%eax
  802175:	78 18                	js     80218f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	ff 75 f4             	pushl  -0xc(%ebp)
  80217d:	e8 7c f0 ff ff       	call   8011fe <fd2data>
	return _pipeisclosed(fd, p);
  802182:	89 c2                	mov    %eax,%edx
  802184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802187:	e8 30 fd ff ff       	call   801ebc <_pipeisclosed>
  80218c:	83 c4 10             	add    $0x10,%esp
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	5d                   	pop    %ebp
  80219a:	c3                   	ret    

0080219b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021a1:	68 67 2c 80 00       	push   $0x802c67
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	e8 37 ea ff ff       	call   800be5 <strcpy>
	return 0;
}
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <devcons_write>:
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	57                   	push   %edi
  8021b9:	56                   	push   %esi
  8021ba:	53                   	push   %ebx
  8021bb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021c1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021cc:	eb 2f                	jmp    8021fd <devcons_write+0x48>
		m = n - tot;
  8021ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021d1:	29 f3                	sub    %esi,%ebx
  8021d3:	83 fb 7f             	cmp    $0x7f,%ebx
  8021d6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021db:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	53                   	push   %ebx
  8021e2:	89 f0                	mov    %esi,%eax
  8021e4:	03 45 0c             	add    0xc(%ebp),%eax
  8021e7:	50                   	push   %eax
  8021e8:	57                   	push   %edi
  8021e9:	e8 85 eb ff ff       	call   800d73 <memmove>
		sys_cputs(buf, m);
  8021ee:	83 c4 08             	add    $0x8,%esp
  8021f1:	53                   	push   %ebx
  8021f2:	57                   	push   %edi
  8021f3:	e8 2a ed ff ff       	call   800f22 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021f8:	01 de                	add    %ebx,%esi
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	3b 75 10             	cmp    0x10(%ebp),%esi
  802200:	72 cc                	jb     8021ce <devcons_write+0x19>
}
  802202:	89 f0                	mov    %esi,%eax
  802204:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802207:	5b                   	pop    %ebx
  802208:	5e                   	pop    %esi
  802209:	5f                   	pop    %edi
  80220a:	5d                   	pop    %ebp
  80220b:	c3                   	ret    

0080220c <devcons_read>:
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 08             	sub    $0x8,%esp
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802217:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80221b:	75 07                	jne    802224 <devcons_read+0x18>
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    
		sys_yield();
  80221f:	e8 9b ed ff ff       	call   800fbf <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802224:	e8 17 ed ff ff       	call   800f40 <sys_cgetc>
  802229:	85 c0                	test   %eax,%eax
  80222b:	74 f2                	je     80221f <devcons_read+0x13>
	if (c < 0)
  80222d:	85 c0                	test   %eax,%eax
  80222f:	78 ec                	js     80221d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802231:	83 f8 04             	cmp    $0x4,%eax
  802234:	74 0c                	je     802242 <devcons_read+0x36>
	*(char*)vbuf = c;
  802236:	8b 55 0c             	mov    0xc(%ebp),%edx
  802239:	88 02                	mov    %al,(%edx)
	return 1;
  80223b:	b8 01 00 00 00       	mov    $0x1,%eax
  802240:	eb db                	jmp    80221d <devcons_read+0x11>
		return 0;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
  802247:	eb d4                	jmp    80221d <devcons_read+0x11>

00802249 <cputchar>:
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802255:	6a 01                	push   $0x1
  802257:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80225a:	50                   	push   %eax
  80225b:	e8 c2 ec ff ff       	call   800f22 <sys_cputs>
}
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <getchar>:
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80226b:	6a 01                	push   $0x1
  80226d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802270:	50                   	push   %eax
  802271:	6a 00                	push   $0x0
  802273:	e8 5d f2 ff ff       	call   8014d5 <read>
	if (r < 0)
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	85 c0                	test   %eax,%eax
  80227d:	78 08                	js     802287 <getchar+0x22>
	if (r < 1)
  80227f:	85 c0                	test   %eax,%eax
  802281:	7e 06                	jle    802289 <getchar+0x24>
	return c;
  802283:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    
		return -E_EOF;
  802289:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80228e:	eb f7                	jmp    802287 <getchar+0x22>

00802290 <iscons>:
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802296:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802299:	50                   	push   %eax
  80229a:	ff 75 08             	pushl  0x8(%ebp)
  80229d:	e8 c2 ef ff ff       	call   801264 <fd_lookup>
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	78 11                	js     8022ba <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022b2:	39 10                	cmp    %edx,(%eax)
  8022b4:	0f 94 c0             	sete   %al
  8022b7:	0f b6 c0             	movzbl %al,%eax
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <opencons>:
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c5:	50                   	push   %eax
  8022c6:	e8 4a ef ff ff       	call   801215 <fd_alloc>
  8022cb:	83 c4 10             	add    $0x10,%esp
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	78 3a                	js     80230c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022d2:	83 ec 04             	sub    $0x4,%esp
  8022d5:	68 07 04 00 00       	push   $0x407
  8022da:	ff 75 f4             	pushl  -0xc(%ebp)
  8022dd:	6a 00                	push   $0x0
  8022df:	e8 fa ec ff ff       	call   800fde <sys_page_alloc>
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	78 21                	js     80230c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022f4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	50                   	push   %eax
  802304:	e8 e5 ee ff ff       	call   8011ee <fd2num>
  802309:	83 c4 10             	add    $0x10,%esp
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	56                   	push   %esi
  802312:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802313:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802316:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80231c:	e8 7f ec ff ff       	call   800fa0 <sys_getenvid>
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	ff 75 0c             	pushl  0xc(%ebp)
  802327:	ff 75 08             	pushl  0x8(%ebp)
  80232a:	56                   	push   %esi
  80232b:	50                   	push   %eax
  80232c:	68 74 2c 80 00       	push   $0x802c74
  802331:	e8 90 e2 ff ff       	call   8005c6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802336:	83 c4 18             	add    $0x18,%esp
  802339:	53                   	push   %ebx
  80233a:	ff 75 10             	pushl  0x10(%ebp)
  80233d:	e8 33 e2 ff ff       	call   800575 <vcprintf>
	cprintf("\n");
  802342:	c7 04 24 60 2c 80 00 	movl   $0x802c60,(%esp)
  802349:	e8 78 e2 ff ff       	call   8005c6 <cprintf>
  80234e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802351:	cc                   	int3   
  802352:	eb fd                	jmp    802351 <_panic+0x43>

00802354 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	56                   	push   %esi
  802358:	53                   	push   %ebx
  802359:	8b 75 08             	mov    0x8(%ebp),%esi
  80235c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802362:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802364:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802369:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  80236c:	83 ec 0c             	sub    $0xc,%esp
  80236f:	50                   	push   %eax
  802370:	e8 19 ee ff ff       	call   80118e <sys_ipc_recv>
	if (from_env_store)
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	85 f6                	test   %esi,%esi
  80237a:	74 14                	je     802390 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  80237c:	ba 00 00 00 00       	mov    $0x0,%edx
  802381:	85 c0                	test   %eax,%eax
  802383:	78 09                	js     80238e <ipc_recv+0x3a>
  802385:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80238b:	8b 52 74             	mov    0x74(%edx),%edx
  80238e:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802390:	85 db                	test   %ebx,%ebx
  802392:	74 14                	je     8023a8 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802394:	ba 00 00 00 00       	mov    $0x0,%edx
  802399:	85 c0                	test   %eax,%eax
  80239b:	78 09                	js     8023a6 <ipc_recv+0x52>
  80239d:	8b 15 18 40 80 00    	mov    0x804018,%edx
  8023a3:	8b 52 78             	mov    0x78(%edx),%edx
  8023a6:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	78 08                	js     8023b4 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8023ac:	a1 18 40 80 00       	mov    0x804018,%eax
  8023b1:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023b7:	5b                   	pop    %ebx
  8023b8:	5e                   	pop    %esi
  8023b9:	5d                   	pop    %ebp
  8023ba:	c3                   	ret    

008023bb <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	57                   	push   %edi
  8023bf:	56                   	push   %esi
  8023c0:	53                   	push   %ebx
  8023c1:	83 ec 0c             	sub    $0xc,%esp
  8023c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023cd:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8023cf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023d4:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8023d7:	ff 75 14             	pushl  0x14(%ebp)
  8023da:	53                   	push   %ebx
  8023db:	56                   	push   %esi
  8023dc:	57                   	push   %edi
  8023dd:	e8 89 ed ff ff       	call   80116b <sys_ipc_try_send>
		if (ret == 0)
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	74 1e                	je     802407 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  8023e9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023ec:	75 07                	jne    8023f5 <ipc_send+0x3a>
			sys_yield();
  8023ee:	e8 cc eb ff ff       	call   800fbf <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8023f3:	eb e2                	jmp    8023d7 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  8023f5:	50                   	push   %eax
  8023f6:	68 98 2c 80 00       	push   $0x802c98
  8023fb:	6a 3d                	push   $0x3d
  8023fd:	68 ac 2c 80 00       	push   $0x802cac
  802402:	e8 07 ff ff ff       	call   80230e <_panic>
	}
	// panic("ipc_send not implemented");
}
  802407:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240a:	5b                   	pop    %ebx
  80240b:	5e                   	pop    %esi
  80240c:	5f                   	pop    %edi
  80240d:	5d                   	pop    %ebp
  80240e:	c3                   	ret    

0080240f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80241a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80241d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802423:	8b 52 50             	mov    0x50(%edx),%edx
  802426:	39 ca                	cmp    %ecx,%edx
  802428:	74 11                	je     80243b <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80242a:	83 c0 01             	add    $0x1,%eax
  80242d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802432:	75 e6                	jne    80241a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	eb 0b                	jmp    802446 <ipc_find_env+0x37>
			return envs[i].env_id;
  80243b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80243e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802443:	8b 40 48             	mov    0x48(%eax),%eax
}
  802446:	5d                   	pop    %ebp
  802447:	c3                   	ret    

00802448 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
  80244b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80244e:	89 d0                	mov    %edx,%eax
  802450:	c1 e8 16             	shr    $0x16,%eax
  802453:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80245f:	f6 c1 01             	test   $0x1,%cl
  802462:	74 1d                	je     802481 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802464:	c1 ea 0c             	shr    $0xc,%edx
  802467:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80246e:	f6 c2 01             	test   $0x1,%dl
  802471:	74 0e                	je     802481 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802473:	c1 ea 0c             	shr    $0xc,%edx
  802476:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80247d:	ef 
  80247e:	0f b7 c0             	movzwl %ax,%eax
}
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    
  802483:	66 90                	xchg   %ax,%ax
  802485:	66 90                	xchg   %ax,%ax
  802487:	66 90                	xchg   %ax,%ax
  802489:	66 90                	xchg   %ax,%ax
  80248b:	66 90                	xchg   %ax,%ax
  80248d:	66 90                	xchg   %ax,%ax
  80248f:	90                   	nop

00802490 <__udivdi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	53                   	push   %ebx
  802494:	83 ec 1c             	sub    $0x1c,%esp
  802497:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80249b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80249f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024a7:	85 d2                	test   %edx,%edx
  8024a9:	75 35                	jne    8024e0 <__udivdi3+0x50>
  8024ab:	39 f3                	cmp    %esi,%ebx
  8024ad:	0f 87 bd 00 00 00    	ja     802570 <__udivdi3+0xe0>
  8024b3:	85 db                	test   %ebx,%ebx
  8024b5:	89 d9                	mov    %ebx,%ecx
  8024b7:	75 0b                	jne    8024c4 <__udivdi3+0x34>
  8024b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024be:	31 d2                	xor    %edx,%edx
  8024c0:	f7 f3                	div    %ebx
  8024c2:	89 c1                	mov    %eax,%ecx
  8024c4:	31 d2                	xor    %edx,%edx
  8024c6:	89 f0                	mov    %esi,%eax
  8024c8:	f7 f1                	div    %ecx
  8024ca:	89 c6                	mov    %eax,%esi
  8024cc:	89 e8                	mov    %ebp,%eax
  8024ce:	89 f7                	mov    %esi,%edi
  8024d0:	f7 f1                	div    %ecx
  8024d2:	89 fa                	mov    %edi,%edx
  8024d4:	83 c4 1c             	add    $0x1c,%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5f                   	pop    %edi
  8024da:	5d                   	pop    %ebp
  8024db:	c3                   	ret    
  8024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024e0:	39 f2                	cmp    %esi,%edx
  8024e2:	77 7c                	ja     802560 <__udivdi3+0xd0>
  8024e4:	0f bd fa             	bsr    %edx,%edi
  8024e7:	83 f7 1f             	xor    $0x1f,%edi
  8024ea:	0f 84 98 00 00 00    	je     802588 <__udivdi3+0xf8>
  8024f0:	89 f9                	mov    %edi,%ecx
  8024f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024f7:	29 f8                	sub    %edi,%eax
  8024f9:	d3 e2                	shl    %cl,%edx
  8024fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024ff:	89 c1                	mov    %eax,%ecx
  802501:	89 da                	mov    %ebx,%edx
  802503:	d3 ea                	shr    %cl,%edx
  802505:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802509:	09 d1                	or     %edx,%ecx
  80250b:	89 f2                	mov    %esi,%edx
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 f9                	mov    %edi,%ecx
  802513:	d3 e3                	shl    %cl,%ebx
  802515:	89 c1                	mov    %eax,%ecx
  802517:	d3 ea                	shr    %cl,%edx
  802519:	89 f9                	mov    %edi,%ecx
  80251b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80251f:	d3 e6                	shl    %cl,%esi
  802521:	89 eb                	mov    %ebp,%ebx
  802523:	89 c1                	mov    %eax,%ecx
  802525:	d3 eb                	shr    %cl,%ebx
  802527:	09 de                	or     %ebx,%esi
  802529:	89 f0                	mov    %esi,%eax
  80252b:	f7 74 24 08          	divl   0x8(%esp)
  80252f:	89 d6                	mov    %edx,%esi
  802531:	89 c3                	mov    %eax,%ebx
  802533:	f7 64 24 0c          	mull   0xc(%esp)
  802537:	39 d6                	cmp    %edx,%esi
  802539:	72 0c                	jb     802547 <__udivdi3+0xb7>
  80253b:	89 f9                	mov    %edi,%ecx
  80253d:	d3 e5                	shl    %cl,%ebp
  80253f:	39 c5                	cmp    %eax,%ebp
  802541:	73 5d                	jae    8025a0 <__udivdi3+0x110>
  802543:	39 d6                	cmp    %edx,%esi
  802545:	75 59                	jne    8025a0 <__udivdi3+0x110>
  802547:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80254a:	31 ff                	xor    %edi,%edi
  80254c:	89 fa                	mov    %edi,%edx
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d 76 00             	lea    0x0(%esi),%esi
  802559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802560:	31 ff                	xor    %edi,%edi
  802562:	31 c0                	xor    %eax,%eax
  802564:	89 fa                	mov    %edi,%edx
  802566:	83 c4 1c             	add    $0x1c,%esp
  802569:	5b                   	pop    %ebx
  80256a:	5e                   	pop    %esi
  80256b:	5f                   	pop    %edi
  80256c:	5d                   	pop    %ebp
  80256d:	c3                   	ret    
  80256e:	66 90                	xchg   %ax,%ax
  802570:	31 ff                	xor    %edi,%edi
  802572:	89 e8                	mov    %ebp,%eax
  802574:	89 f2                	mov    %esi,%edx
  802576:	f7 f3                	div    %ebx
  802578:	89 fa                	mov    %edi,%edx
  80257a:	83 c4 1c             	add    $0x1c,%esp
  80257d:	5b                   	pop    %ebx
  80257e:	5e                   	pop    %esi
  80257f:	5f                   	pop    %edi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    
  802582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802588:	39 f2                	cmp    %esi,%edx
  80258a:	72 06                	jb     802592 <__udivdi3+0x102>
  80258c:	31 c0                	xor    %eax,%eax
  80258e:	39 eb                	cmp    %ebp,%ebx
  802590:	77 d2                	ja     802564 <__udivdi3+0xd4>
  802592:	b8 01 00 00 00       	mov    $0x1,%eax
  802597:	eb cb                	jmp    802564 <__udivdi3+0xd4>
  802599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025a0:	89 d8                	mov    %ebx,%eax
  8025a2:	31 ff                	xor    %edi,%edi
  8025a4:	eb be                	jmp    802564 <__udivdi3+0xd4>
  8025a6:	66 90                	xchg   %ax,%ax
  8025a8:	66 90                	xchg   %ax,%ax
  8025aa:	66 90                	xchg   %ax,%ax
  8025ac:	66 90                	xchg   %ax,%ax
  8025ae:	66 90                	xchg   %ax,%ax

008025b0 <__umoddi3>:
  8025b0:	55                   	push   %ebp
  8025b1:	57                   	push   %edi
  8025b2:	56                   	push   %esi
  8025b3:	53                   	push   %ebx
  8025b4:	83 ec 1c             	sub    $0x1c,%esp
  8025b7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8025bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025c7:	85 ed                	test   %ebp,%ebp
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	89 da                	mov    %ebx,%edx
  8025cd:	75 19                	jne    8025e8 <__umoddi3+0x38>
  8025cf:	39 df                	cmp    %ebx,%edi
  8025d1:	0f 86 b1 00 00 00    	jbe    802688 <__umoddi3+0xd8>
  8025d7:	f7 f7                	div    %edi
  8025d9:	89 d0                	mov    %edx,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	83 c4 1c             	add    $0x1c,%esp
  8025e0:	5b                   	pop    %ebx
  8025e1:	5e                   	pop    %esi
  8025e2:	5f                   	pop    %edi
  8025e3:	5d                   	pop    %ebp
  8025e4:	c3                   	ret    
  8025e5:	8d 76 00             	lea    0x0(%esi),%esi
  8025e8:	39 dd                	cmp    %ebx,%ebp
  8025ea:	77 f1                	ja     8025dd <__umoddi3+0x2d>
  8025ec:	0f bd cd             	bsr    %ebp,%ecx
  8025ef:	83 f1 1f             	xor    $0x1f,%ecx
  8025f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025f6:	0f 84 b4 00 00 00    	je     8026b0 <__umoddi3+0x100>
  8025fc:	b8 20 00 00 00       	mov    $0x20,%eax
  802601:	89 c2                	mov    %eax,%edx
  802603:	8b 44 24 04          	mov    0x4(%esp),%eax
  802607:	29 c2                	sub    %eax,%edx
  802609:	89 c1                	mov    %eax,%ecx
  80260b:	89 f8                	mov    %edi,%eax
  80260d:	d3 e5                	shl    %cl,%ebp
  80260f:	89 d1                	mov    %edx,%ecx
  802611:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802615:	d3 e8                	shr    %cl,%eax
  802617:	09 c5                	or     %eax,%ebp
  802619:	8b 44 24 04          	mov    0x4(%esp),%eax
  80261d:	89 c1                	mov    %eax,%ecx
  80261f:	d3 e7                	shl    %cl,%edi
  802621:	89 d1                	mov    %edx,%ecx
  802623:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802627:	89 df                	mov    %ebx,%edi
  802629:	d3 ef                	shr    %cl,%edi
  80262b:	89 c1                	mov    %eax,%ecx
  80262d:	89 f0                	mov    %esi,%eax
  80262f:	d3 e3                	shl    %cl,%ebx
  802631:	89 d1                	mov    %edx,%ecx
  802633:	89 fa                	mov    %edi,%edx
  802635:	d3 e8                	shr    %cl,%eax
  802637:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80263c:	09 d8                	or     %ebx,%eax
  80263e:	f7 f5                	div    %ebp
  802640:	d3 e6                	shl    %cl,%esi
  802642:	89 d1                	mov    %edx,%ecx
  802644:	f7 64 24 08          	mull   0x8(%esp)
  802648:	39 d1                	cmp    %edx,%ecx
  80264a:	89 c3                	mov    %eax,%ebx
  80264c:	89 d7                	mov    %edx,%edi
  80264e:	72 06                	jb     802656 <__umoddi3+0xa6>
  802650:	75 0e                	jne    802660 <__umoddi3+0xb0>
  802652:	39 c6                	cmp    %eax,%esi
  802654:	73 0a                	jae    802660 <__umoddi3+0xb0>
  802656:	2b 44 24 08          	sub    0x8(%esp),%eax
  80265a:	19 ea                	sbb    %ebp,%edx
  80265c:	89 d7                	mov    %edx,%edi
  80265e:	89 c3                	mov    %eax,%ebx
  802660:	89 ca                	mov    %ecx,%edx
  802662:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802667:	29 de                	sub    %ebx,%esi
  802669:	19 fa                	sbb    %edi,%edx
  80266b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80266f:	89 d0                	mov    %edx,%eax
  802671:	d3 e0                	shl    %cl,%eax
  802673:	89 d9                	mov    %ebx,%ecx
  802675:	d3 ee                	shr    %cl,%esi
  802677:	d3 ea                	shr    %cl,%edx
  802679:	09 f0                	or     %esi,%eax
  80267b:	83 c4 1c             	add    $0x1c,%esp
  80267e:	5b                   	pop    %ebx
  80267f:	5e                   	pop    %esi
  802680:	5f                   	pop    %edi
  802681:	5d                   	pop    %ebp
  802682:	c3                   	ret    
  802683:	90                   	nop
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	85 ff                	test   %edi,%edi
  80268a:	89 f9                	mov    %edi,%ecx
  80268c:	75 0b                	jne    802699 <__umoddi3+0xe9>
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 f7                	div    %edi
  802697:	89 c1                	mov    %eax,%ecx
  802699:	89 d8                	mov    %ebx,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	f7 f1                	div    %ecx
  80269f:	89 f0                	mov    %esi,%eax
  8026a1:	f7 f1                	div    %ecx
  8026a3:	e9 31 ff ff ff       	jmp    8025d9 <__umoddi3+0x29>
  8026a8:	90                   	nop
  8026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	39 dd                	cmp    %ebx,%ebp
  8026b2:	72 08                	jb     8026bc <__umoddi3+0x10c>
  8026b4:	39 f7                	cmp    %esi,%edi
  8026b6:	0f 87 21 ff ff ff    	ja     8025dd <__umoddi3+0x2d>
  8026bc:	89 da                	mov    %ebx,%edx
  8026be:	89 f0                	mov    %esi,%eax
  8026c0:	29 f8                	sub    %edi,%eax
  8026c2:	19 ea                	sbb    %ebp,%edx
  8026c4:	e9 14 ff ff ff       	jmp    8025dd <__umoddi3+0x2d>

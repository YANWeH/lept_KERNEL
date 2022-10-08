
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 5d 05 00 00       	call   80058e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 20 2a 80 00       	push   $0x802a20
  80003f:	e8 85 06 00 00       	call   8006c9 <cprintf>
	exit();
  800044:	e8 8b 05 00 00       	call   8005d4 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	81 ec 20 04 00 00    	sub    $0x420,%esp
  80005a:	89 c3                	mov    %eax,%ebx
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	68 00 02 00 00       	push   $0x200
  800061:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	53                   	push   %ebx
  800069:	e8 6a 15 00 00       	call   8015d8 <read>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	85 c0                	test   %eax,%eax
  800073:	78 3c                	js     8000b1 <handle_client+0x63>
			panic("failed to read");

		memset(req, 0, sizeof(*req));
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	6a 0c                	push   $0xc
  80007a:	6a 00                	push   $0x0
  80007c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80007f:	50                   	push   %eax
  800080:	e8 a4 0d 00 00       	call   800e29 <memset>

		req->sock = sock;
  800085:	89 5d dc             	mov    %ebx,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  800088:	83 c4 0c             	add    $0xc,%esp
  80008b:	6a 04                	push   $0x4
  80008d:	68 40 2a 80 00       	push   $0x802a40
  800092:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	e8 16 0d 00 00       	call   800db4 <strncmp>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 17 01 00 00    	jne    8001c0 <handle_client+0x172>
	request += 4;
  8000a9:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  8000af:	eb 1a                	jmp    8000cb <handle_client+0x7d>
			panic("failed to read");
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	68 24 2a 80 00       	push   $0x802a24
  8000b9:	68 04 01 00 00       	push   $0x104
  8000be:	68 33 2a 80 00       	push   $0x802a33
  8000c3:	e8 26 05 00 00       	call   8005ee <_panic>
		request++;
  8000c8:	83 c3 01             	add    $0x1,%ebx
	while (*request && *request != ' ')
  8000cb:	f6 03 df             	testb  $0xdf,(%ebx)
  8000ce:	75 f8                	jne    8000c8 <handle_client+0x7a>
	url_len = request - url;
  8000d0:	8d bd e0 fd ff ff    	lea    -0x220(%ebp),%edi
  8000d6:	89 de                	mov    %ebx,%esi
  8000d8:	29 fe                	sub    %edi,%esi
	req->url = malloc(url_len + 1);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	8d 46 01             	lea    0x1(%esi),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 0f 1f 00 00       	call   801ff5 <malloc>
  8000e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8000e9:	83 c4 0c             	add    $0xc,%esp
  8000ec:	56                   	push   %esi
  8000ed:	57                   	push   %edi
  8000ee:	50                   	push   %eax
  8000ef:	e8 82 0d 00 00       	call   800e76 <memmove>
	req->url[url_len] = '\0';
  8000f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f7:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
	request++;
  8000fb:	8d 73 01             	lea    0x1(%ebx),%esi
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 f0                	mov    %esi,%eax
  800103:	eb 03                	jmp    800108 <handle_client+0xba>
		request++;
  800105:	83 c0 01             	add    $0x1,%eax
	while (*request && *request != '\n')
  800108:	0f b6 10             	movzbl (%eax),%edx
  80010b:	84 d2                	test   %dl,%dl
  80010d:	74 05                	je     800114 <handle_client+0xc6>
  80010f:	80 fa 0a             	cmp    $0xa,%dl
  800112:	75 f1                	jne    800105 <handle_client+0xb7>
	version_len = request - version;
  800114:	29 f0                	sub    %esi,%eax
  800116:	89 c3                	mov    %eax,%ebx
	req->version = malloc(version_len + 1);
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	8d 40 01             	lea    0x1(%eax),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 d1 1e 00 00       	call   801ff5 <malloc>
  800124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  800127:	83 c4 0c             	add    $0xc,%esp
  80012a:	53                   	push   %ebx
  80012b:	56                   	push   %esi
  80012c:	50                   	push   %eax
  80012d:	e8 44 0d 00 00       	call   800e76 <memmove>
	req->version[version_len] = '\0';
  800132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800135:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
	panic("send_file not implemented");
  800139:	83 c4 0c             	add    $0xc,%esp
  80013c:	68 45 2a 80 00       	push   $0x802a45
  800141:	68 e2 00 00 00       	push   $0xe2
  800146:	68 33 2a 80 00       	push   $0x802a33
  80014b:	e8 9e 04 00 00       	call   8005ee <_panic>
		e++;
  800150:	83 c0 08             	add    $0x8,%eax
	while (e->code != 0 && e->msg != 0) {
  800153:	8b 10                	mov    (%eax),%edx
  800155:	85 d2                	test   %edx,%edx
  800157:	74 3e                	je     800197 <handle_client+0x149>
		if (e->code == code)
  800159:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80015d:	74 08                	je     800167 <handle_client+0x119>
  80015f:	81 fa 90 01 00 00    	cmp    $0x190,%edx
  800165:	75 e9                	jne    800150 <handle_client+0x102>
	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800167:	8b 40 04             	mov    0x4(%eax),%eax
  80016a:	83 ec 04             	sub    $0x4,%esp
  80016d:	50                   	push   %eax
  80016e:	52                   	push   %edx
  80016f:	50                   	push   %eax
  800170:	52                   	push   %edx
  800171:	68 94 2a 80 00       	push   $0x802a94
  800176:	68 00 02 00 00       	push   $0x200
  80017b:	8d b5 dc fb ff ff    	lea    -0x424(%ebp),%esi
  800181:	56                   	push   %esi
  800182:	e8 10 0b 00 00       	call   800c97 <snprintf>
	if (write(req->sock, buf, r) != r)
  800187:	83 c4 1c             	add    $0x1c,%esp
  80018a:	50                   	push   %eax
  80018b:	56                   	push   %esi
  80018c:	ff 75 dc             	pushl  -0x24(%ebp)
  80018f:	e8 12 15 00 00       	call   8016a6 <write>
  800194:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	ff 75 e0             	pushl  -0x20(%ebp)
  80019d:	e8 a5 1d 00 00       	call   801f47 <free>
	free(req->version);
  8001a2:	83 c4 04             	add    $0x4,%esp
  8001a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a8:	e8 9a 1d 00 00       	call   801f47 <free>

		// no keep alive
		break;
	}

	close(sock);
  8001ad:	89 1c 24             	mov    %ebx,(%esp)
  8001b0:	e8 e7 12 00 00       	call   80149c <close>
}
  8001b5:	83 c4 10             	add    $0x10,%esp
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
	struct error_messages *e = errors;
  8001c0:	b8 00 40 80 00       	mov    $0x804000,%eax
  8001c5:	eb 8c                	jmp    800153 <handle_client+0x105>

008001c7 <umain>:

void
umain(int argc, char **argv)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8001d0:	c7 05 20 40 80 00 5f 	movl   $0x802a5f,0x804020
  8001d7:	2a 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8001da:	6a 06                	push   $0x6
  8001dc:	6a 01                	push   $0x1
  8001de:	6a 02                	push   $0x2
  8001e0:	e8 e8 1a 00 00       	call   801ccd <socket>
  8001e5:	89 c6                	mov    %eax,%esi
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	78 6d                	js     80025b <umain+0x94>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 10                	push   $0x10
  8001f3:	6a 00                	push   $0x0
  8001f5:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	e8 2b 0c 00 00       	call   800e29 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8001fe:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800209:	e8 52 01 00 00       	call   800360 <htonl>
  80020e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  800211:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  800218:	e8 29 01 00 00       	call   800346 <htons>
  80021d:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800221:	83 c4 0c             	add    $0xc,%esp
  800224:	6a 10                	push   $0x10
  800226:	53                   	push   %ebx
  800227:	56                   	push   %esi
  800228:	e8 0e 1a 00 00       	call   801c3b <bind>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	85 c0                	test   %eax,%eax
  800232:	78 33                	js     800267 <umain+0xa0>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	6a 05                	push   $0x5
  800239:	56                   	push   %esi
  80023a:	e8 6b 1a 00 00       	call   801caa <listen>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	85 c0                	test   %eax,%eax
  800244:	78 2d                	js     800273 <umain+0xac>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 58 2b 80 00       	push   $0x802b58
  80024e:	e8 76 04 00 00       	call   8006c9 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800256:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800259:	eb 2b                	jmp    800286 <umain+0xbf>
		die("Failed to create socket");
  80025b:	b8 66 2a 80 00       	mov    $0x802a66,%eax
  800260:	e8 ce fd ff ff       	call   800033 <die>
  800265:	eb 87                	jmp    8001ee <umain+0x27>
		die("Failed to bind the server socket");
  800267:	b8 10 2b 80 00       	mov    $0x802b10,%eax
  80026c:	e8 c2 fd ff ff       	call   800033 <die>
  800271:	eb c1                	jmp    800234 <umain+0x6d>
		die("Failed to listen on server socket");
  800273:	b8 34 2b 80 00       	mov    $0x802b34,%eax
  800278:	e8 b6 fd ff ff       	call   800033 <die>
  80027d:	eb c7                	jmp    800246 <umain+0x7f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
		}
		handle_client(clientsock);
  80027f:	89 d8                	mov    %ebx,%eax
  800281:	e8 c8 fd ff ff       	call   80004e <handle_client>
		unsigned int clientlen = sizeof(client);
  800286:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	57                   	push   %edi
  800291:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800294:	50                   	push   %eax
  800295:	56                   	push   %esi
  800296:	e8 71 19 00 00       	call   801c0c <accept>
  80029b:	89 c3                	mov    %eax,%ebx
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	79 db                	jns    80027f <umain+0xb8>
			die("Failed to accept client connection");
  8002a4:	b8 7c 2b 80 00       	mov    $0x802b7c,%eax
  8002a9:	e8 85 fd ff ff       	call   800033 <die>
  8002ae:	eb cf                	jmp    80027f <umain+0xb8>

008002b0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 14             	sub    $0x14,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  8002bf:	8d 7d f0             	lea    -0x10(%ebp),%edi
  rp = str;
  8002c2:	c7 45 e0 00 50 80 00 	movl   $0x805000,-0x20(%ebp)
  8002c9:	eb 30                	jmp    8002fb <inet_ntoa+0x4b>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8002cb:	0f b6 c2             	movzbl %dl,%eax
  8002ce:	0f b6 44 05 ed       	movzbl -0x13(%ebp,%eax,1),%eax
  8002d3:	88 01                	mov    %al,(%ecx)
  8002d5:	83 c1 01             	add    $0x1,%ecx
    while(i--)
  8002d8:	83 ea 01             	sub    $0x1,%edx
  8002db:	80 fa ff             	cmp    $0xff,%dl
  8002de:	75 eb                	jne    8002cb <inet_ntoa+0x1b>
  8002e0:	89 f0                	mov    %esi,%eax
  8002e2:	0f b6 f0             	movzbl %al,%esi
  8002e5:	03 75 e0             	add    -0x20(%ebp),%esi
    *rp++ = '.';
  8002e8:	8d 46 01             	lea    0x1(%esi),%eax
  8002eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ee:	c6 06 2e             	movb   $0x2e,(%esi)
  8002f1:	83 c7 01             	add    $0x1,%edi
  for(n = 0; n < 4; n++) {
  8002f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8002f7:	39 c7                	cmp    %eax,%edi
  8002f9:	74 3b                	je     800336 <inet_ntoa+0x86>
  rp = str;
  8002fb:	b9 00 00 00 00       	mov    $0x0,%ecx
      rem = *ap % (u8_t)10;
  800300:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  800303:	0f b6 da             	movzbl %dl,%ebx
  800306:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  800309:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
  80030c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030f:	66 c1 e8 0b          	shr    $0xb,%ax
  800313:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800315:	8d 71 01             	lea    0x1(%ecx),%esi
  800318:	0f b6 c9             	movzbl %cl,%ecx
      rem = *ap % (u8_t)10;
  80031b:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  80031e:	01 db                	add    %ebx,%ebx
  800320:	29 da                	sub    %ebx,%edx
      inv[i++] = '0' + rem;
  800322:	83 c2 30             	add    $0x30,%edx
  800325:	88 54 0d ed          	mov    %dl,-0x13(%ebp,%ecx,1)
  800329:	89 f1                	mov    %esi,%ecx
    } while(*ap);
  80032b:	84 c0                	test   %al,%al
  80032d:	75 d1                	jne    800300 <inet_ntoa+0x50>
  80032f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      inv[i++] = '0' + rem;
  800332:	89 f2                	mov    %esi,%edx
  800334:	eb a2                	jmp    8002d8 <inet_ntoa+0x28>
    ap++;
  }
  *--rp = 0;
  800336:	c6 06 00             	movb   $0x0,(%esi)
  return str;
}
  800339:	b8 00 50 80 00       	mov    $0x805000,%eax
  80033e:	83 c4 14             	add    $0x14,%esp
  800341:	5b                   	pop    %ebx
  800342:	5e                   	pop    %esi
  800343:	5f                   	pop    %edi
  800344:	5d                   	pop    %ebp
  800345:	c3                   	ret    

00800346 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800349:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80034d:	66 c1 c0 08          	rol    $0x8,%ax
}
  800351:	5d                   	pop    %ebp
  800352:	c3                   	ret    

00800353 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800356:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80035a:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800366:	89 d0                	mov    %edx,%eax
  800368:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80036b:	89 d1                	mov    %edx,%ecx
  80036d:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800370:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800372:	89 d1                	mov    %edx,%ecx
  800374:	c1 e1 08             	shl    $0x8,%ecx
  800377:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80037d:	09 c8                	or     %ecx,%eax
  80037f:	c1 ea 08             	shr    $0x8,%edx
  800382:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800388:	09 d0                	or     %edx,%eax
}
  80038a:	5d                   	pop    %ebp
  80038b:	c3                   	ret    

0080038c <inet_aton>:
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	57                   	push   %edi
  800390:	56                   	push   %esi
  800391:	53                   	push   %ebx
  800392:	83 ec 1c             	sub    $0x1c,%esp
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  c = *cp;
  800398:	0f be 10             	movsbl (%eax),%edx
  u32_t *pp = parts;
  80039b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80039e:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8003a1:	e9 a9 00 00 00       	jmp    80044f <inet_aton+0xc3>
      c = *++cp;
  8003a6:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8003aa:	89 d1                	mov    %edx,%ecx
  8003ac:	83 e1 df             	and    $0xffffffdf,%ecx
  8003af:	80 f9 58             	cmp    $0x58,%cl
  8003b2:	74 12                	je     8003c6 <inet_aton+0x3a>
      c = *++cp;
  8003b4:	83 c0 01             	add    $0x1,%eax
  8003b7:	0f be d2             	movsbl %dl,%edx
        base = 8;
  8003ba:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
  8003c1:	e9 a5 00 00 00       	jmp    80046b <inet_aton+0xdf>
        c = *++cp;
  8003c6:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8003ca:	8d 40 02             	lea    0x2(%eax),%eax
        base = 16;
  8003cd:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
  8003d4:	e9 92 00 00 00       	jmp    80046b <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  8003d9:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  8003dd:	75 4a                	jne    800429 <inet_aton+0x9d>
  8003df:	8d 5e 9f             	lea    -0x61(%esi),%ebx
  8003e2:	89 d1                	mov    %edx,%ecx
  8003e4:	83 e1 df             	and    $0xffffffdf,%ecx
  8003e7:	83 e9 41             	sub    $0x41,%ecx
  8003ea:	80 f9 05             	cmp    $0x5,%cl
  8003ed:	77 3a                	ja     800429 <inet_aton+0x9d>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003ef:	c1 e7 04             	shl    $0x4,%edi
  8003f2:	83 c2 0a             	add    $0xa,%edx
  8003f5:	80 fb 1a             	cmp    $0x1a,%bl
  8003f8:	19 c9                	sbb    %ecx,%ecx
  8003fa:	83 e1 20             	and    $0x20,%ecx
  8003fd:	83 c1 41             	add    $0x41,%ecx
  800400:	29 ca                	sub    %ecx,%edx
  800402:	09 d7                	or     %edx,%edi
        c = *++cp;
  800404:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800407:	0f be 56 01          	movsbl 0x1(%esi),%edx
  80040b:	83 c0 01             	add    $0x1,%eax
  80040e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if (isdigit(c)) {
  800411:	89 d6                	mov    %edx,%esi
  800413:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800416:	80 f9 09             	cmp    $0x9,%cl
  800419:	77 be                	ja     8003d9 <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  80041b:	0f af 7d dc          	imul   -0x24(%ebp),%edi
  80041f:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800423:	0f be 50 01          	movsbl 0x1(%eax),%edx
  800427:	eb e2                	jmp    80040b <inet_aton+0x7f>
    if (c == '.') {
  800429:	83 fa 2e             	cmp    $0x2e,%edx
  80042c:	75 44                	jne    800472 <inet_aton+0xe6>
      if (pp >= parts + 3)
  80042e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800431:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800434:	39 c3                	cmp    %eax,%ebx
  800436:	0f 84 13 01 00 00    	je     80054f <inet_aton+0x1c3>
      *pp++ = val;
  80043c:	83 c3 04             	add    $0x4,%ebx
  80043f:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800442:	89 7b fc             	mov    %edi,-0x4(%ebx)
      c = *++cp;
  800445:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800448:	8d 46 01             	lea    0x1(%esi),%eax
  80044b:	0f be 56 01          	movsbl 0x1(%esi),%edx
    if (!isdigit(c))
  80044f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800452:	80 f9 09             	cmp    $0x9,%cl
  800455:	0f 87 ed 00 00 00    	ja     800548 <inet_aton+0x1bc>
    base = 10;
  80045b:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  800462:	83 fa 30             	cmp    $0x30,%edx
  800465:	0f 84 3b ff ff ff    	je     8003a6 <inet_aton+0x1a>
        base = 8;
  80046b:	bf 00 00 00 00       	mov    $0x0,%edi
  800470:	eb 9c                	jmp    80040e <inet_aton+0x82>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800472:	85 d2                	test   %edx,%edx
  800474:	74 29                	je     80049f <inet_aton+0x113>
    return (0);
  800476:	b8 00 00 00 00       	mov    $0x0,%eax
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80047b:	89 f3                	mov    %esi,%ebx
  80047d:	80 fb 1f             	cmp    $0x1f,%bl
  800480:	0f 86 ce 00 00 00    	jbe    800554 <inet_aton+0x1c8>
  800486:	84 d2                	test   %dl,%dl
  800488:	0f 88 c6 00 00 00    	js     800554 <inet_aton+0x1c8>
  80048e:	83 fa 20             	cmp    $0x20,%edx
  800491:	74 0c                	je     80049f <inet_aton+0x113>
  800493:	83 ea 09             	sub    $0x9,%edx
  800496:	83 fa 04             	cmp    $0x4,%edx
  800499:	0f 87 b5 00 00 00    	ja     800554 <inet_aton+0x1c8>
  n = pp - parts + 1;
  80049f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a2:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004a5:	29 c6                	sub    %eax,%esi
  8004a7:	89 f0                	mov    %esi,%eax
  8004a9:	c1 f8 02             	sar    $0x2,%eax
  8004ac:	83 c0 01             	add    $0x1,%eax
  switch (n) {
  8004af:	83 f8 02             	cmp    $0x2,%eax
  8004b2:	74 5e                	je     800512 <inet_aton+0x186>
  8004b4:	83 f8 02             	cmp    $0x2,%eax
  8004b7:	7e 35                	jle    8004ee <inet_aton+0x162>
  8004b9:	83 f8 03             	cmp    $0x3,%eax
  8004bc:	74 6b                	je     800529 <inet_aton+0x19d>
  8004be:	83 f8 04             	cmp    $0x4,%eax
  8004c1:	75 2f                	jne    8004f2 <inet_aton+0x166>
      return (0);
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xff)
  8004c8:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  8004ce:	0f 87 80 00 00 00    	ja     800554 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8004d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d7:	c1 e0 18             	shl    $0x18,%eax
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	c1 e2 10             	shl    $0x10,%edx
  8004e0:	09 d0                	or     %edx,%eax
  8004e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e5:	c1 e2 08             	shl    $0x8,%edx
  8004e8:	09 d0                	or     %edx,%eax
  8004ea:	09 c7                	or     %eax,%edi
    break;
  8004ec:	eb 04                	jmp    8004f2 <inet_aton+0x166>
  switch (n) {
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	74 62                	je     800554 <inet_aton+0x1c8>
  return (1);
  8004f2:	b8 01 00 00 00       	mov    $0x1,%eax
  if (addr)
  8004f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fb:	74 57                	je     800554 <inet_aton+0x1c8>
    addr->s_addr = htonl(val);
  8004fd:	57                   	push   %edi
  8004fe:	e8 5d fe ff ff       	call   800360 <htonl>
  800503:	83 c4 04             	add    $0x4,%esp
  800506:	8b 75 0c             	mov    0xc(%ebp),%esi
  800509:	89 06                	mov    %eax,(%esi)
  return (1);
  80050b:	b8 01 00 00 00       	mov    $0x1,%eax
  800510:	eb 42                	jmp    800554 <inet_aton+0x1c8>
      return (0);
  800512:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffffffUL)
  800517:	81 ff ff ff ff 00    	cmp    $0xffffff,%edi
  80051d:	77 35                	ja     800554 <inet_aton+0x1c8>
    val |= parts[0] << 24;
  80051f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800522:	c1 e0 18             	shl    $0x18,%eax
  800525:	09 c7                	or     %eax,%edi
    break;
  800527:	eb c9                	jmp    8004f2 <inet_aton+0x166>
      return (0);
  800529:	b8 00 00 00 00       	mov    $0x0,%eax
    if (val > 0xffff)
  80052e:	81 ff ff ff 00 00    	cmp    $0xffff,%edi
  800534:	77 1e                	ja     800554 <inet_aton+0x1c8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	c1 e0 18             	shl    $0x18,%eax
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	c1 e2 10             	shl    $0x10,%edx
  800542:	09 d0                	or     %edx,%eax
  800544:	09 c7                	or     %eax,%edi
    break;
  800546:	eb aa                	jmp    8004f2 <inet_aton+0x166>
      return (0);
  800548:	b8 00 00 00 00       	mov    $0x0,%eax
  80054d:	eb 05                	jmp    800554 <inet_aton+0x1c8>
        return (0);
  80054f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800554:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800557:	5b                   	pop    %ebx
  800558:	5e                   	pop    %esi
  800559:	5f                   	pop    %edi
  80055a:	5d                   	pop    %ebp
  80055b:	c3                   	ret    

0080055c <inet_addr>:
{
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	83 ec 10             	sub    $0x10,%esp
  if (inet_aton(cp, &val)) {
  800562:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800565:	50                   	push   %eax
  800566:	ff 75 08             	pushl  0x8(%ebp)
  800569:	e8 1e fe ff ff       	call   80038c <inet_aton>
  80056e:	83 c4 08             	add    $0x8,%esp
    return (val.s_addr);
  800571:	85 c0                	test   %eax,%eax
  800573:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800578:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
}
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  return htonl(n);
  800581:	ff 75 08             	pushl  0x8(%ebp)
  800584:	e8 d7 fd ff ff       	call   800360 <htonl>
  800589:	83 c4 04             	add    $0x4,%esp
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	56                   	push   %esi
  800592:	53                   	push   %ebx
  800593:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800596:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800599:	e8 05 0b 00 00       	call   8010a3 <sys_getenvid>
  80059e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005a3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005ab:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005b0:	85 db                	test   %ebx,%ebx
  8005b2:	7e 07                	jle    8005bb <libmain+0x2d>
		binaryname = argv[0];
  8005b4:	8b 06                	mov    (%esi),%eax
  8005b6:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	56                   	push   %esi
  8005bf:	53                   	push   %ebx
  8005c0:	e8 02 fc ff ff       	call   8001c7 <umain>

	// exit gracefully
	exit();
  8005c5:	e8 0a 00 00 00       	call   8005d4 <exit>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005d0:	5b                   	pop    %ebx
  8005d1:	5e                   	pop    %esi
  8005d2:	5d                   	pop    %ebp
  8005d3:	c3                   	ret    

008005d4 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8005da:	e8 e8 0e 00 00       	call   8014c7 <close_all>
	sys_env_destroy(0);
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	6a 00                	push   $0x0
  8005e4:	e8 79 0a 00 00       	call   801062 <sys_env_destroy>
}
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	c9                   	leave  
  8005ed:	c3                   	ret    

008005ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ee:	55                   	push   %ebp
  8005ef:	89 e5                	mov    %esp,%ebp
  8005f1:	56                   	push   %esi
  8005f2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8005f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005f6:	8b 35 20 40 80 00    	mov    0x804020,%esi
  8005fc:	e8 a2 0a 00 00       	call   8010a3 <sys_getenvid>
  800601:	83 ec 0c             	sub    $0xc,%esp
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	ff 75 08             	pushl  0x8(%ebp)
  80060a:	56                   	push   %esi
  80060b:	50                   	push   %eax
  80060c:	68 d0 2b 80 00       	push   $0x802bd0
  800611:	e8 b3 00 00 00       	call   8006c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800616:	83 c4 18             	add    $0x18,%esp
  800619:	53                   	push   %ebx
  80061a:	ff 75 10             	pushl  0x10(%ebp)
  80061d:	e8 56 00 00 00       	call   800678 <vcprintf>
	cprintf("\n");
  800622:	c7 04 24 95 30 80 00 	movl   $0x803095,(%esp)
  800629:	e8 9b 00 00 00       	call   8006c9 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800631:	cc                   	int3   
  800632:	eb fd                	jmp    800631 <_panic+0x43>

00800634 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	53                   	push   %ebx
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80063e:	8b 13                	mov    (%ebx),%edx
  800640:	8d 42 01             	lea    0x1(%edx),%eax
  800643:	89 03                	mov    %eax,(%ebx)
  800645:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800648:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80064c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800651:	74 09                	je     80065c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800653:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	68 ff 00 00 00       	push   $0xff
  800664:	8d 43 08             	lea    0x8(%ebx),%eax
  800667:	50                   	push   %eax
  800668:	e8 b8 09 00 00       	call   801025 <sys_cputs>
		b->idx = 0;
  80066d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	eb db                	jmp    800653 <putch+0x1f>

00800678 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800681:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800688:	00 00 00 
	b.cnt = 0;
  80068b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800692:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 08             	pushl  0x8(%ebp)
  80069b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a1:	50                   	push   %eax
  8006a2:	68 34 06 80 00       	push   $0x800634
  8006a7:	e8 1a 01 00 00       	call   8007c6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006ac:	83 c4 08             	add    $0x8,%esp
  8006af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8006b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006bb:	50                   	push   %eax
  8006bc:	e8 64 09 00 00       	call   801025 <sys_cputs>

	return b.cnt;
}
  8006c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006c7:	c9                   	leave  
  8006c8:	c3                   	ret    

008006c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 08             	pushl  0x8(%ebp)
  8006d6:	e8 9d ff ff ff       	call   800678 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	57                   	push   %edi
  8006e1:	56                   	push   %esi
  8006e2:	53                   	push   %ebx
  8006e3:	83 ec 1c             	sub    $0x1c,%esp
  8006e6:	89 c7                	mov    %eax,%edi
  8006e8:	89 d6                	mov    %edx,%esi
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8006f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fe:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800701:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800704:	39 d3                	cmp    %edx,%ebx
  800706:	72 05                	jb     80070d <printnum+0x30>
  800708:	39 45 10             	cmp    %eax,0x10(%ebp)
  80070b:	77 7a                	ja     800787 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070d:	83 ec 0c             	sub    $0xc,%esp
  800710:	ff 75 18             	pushl  0x18(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800719:	53                   	push   %ebx
  80071a:	ff 75 10             	pushl  0x10(%ebp)
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 e4             	pushl  -0x1c(%ebp)
  800723:	ff 75 e0             	pushl  -0x20(%ebp)
  800726:	ff 75 dc             	pushl  -0x24(%ebp)
  800729:	ff 75 d8             	pushl  -0x28(%ebp)
  80072c:	e8 9f 20 00 00       	call   8027d0 <__udivdi3>
  800731:	83 c4 18             	add    $0x18,%esp
  800734:	52                   	push   %edx
  800735:	50                   	push   %eax
  800736:	89 f2                	mov    %esi,%edx
  800738:	89 f8                	mov    %edi,%eax
  80073a:	e8 9e ff ff ff       	call   8006dd <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 13                	jmp    800757 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	56                   	push   %esi
  800748:	ff 75 18             	pushl  0x18(%ebp)
  80074b:	ff d7                	call   *%edi
  80074d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800750:	83 eb 01             	sub    $0x1,%ebx
  800753:	85 db                	test   %ebx,%ebx
  800755:	7f ed                	jg     800744 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	56                   	push   %esi
  80075b:	83 ec 04             	sub    $0x4,%esp
  80075e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800761:	ff 75 e0             	pushl  -0x20(%ebp)
  800764:	ff 75 dc             	pushl  -0x24(%ebp)
  800767:	ff 75 d8             	pushl  -0x28(%ebp)
  80076a:	e8 81 21 00 00       	call   8028f0 <__umoddi3>
  80076f:	83 c4 14             	add    $0x14,%esp
  800772:	0f be 80 f3 2b 80 00 	movsbl 0x802bf3(%eax),%eax
  800779:	50                   	push   %eax
  80077a:	ff d7                	call   *%edi
}
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800782:	5b                   	pop    %ebx
  800783:	5e                   	pop    %esi
  800784:	5f                   	pop    %edi
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    
  800787:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80078a:	eb c4                	jmp    800750 <printnum+0x73>

0080078c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800792:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800796:	8b 10                	mov    (%eax),%edx
  800798:	3b 50 04             	cmp    0x4(%eax),%edx
  80079b:	73 0a                	jae    8007a7 <sprintputch+0x1b>
		*b->buf++ = ch;
  80079d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007a0:	89 08                	mov    %ecx,(%eax)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	88 02                	mov    %al,(%edx)
}
  8007a7:	5d                   	pop    %ebp
  8007a8:	c3                   	ret    

008007a9 <printfmt>:
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007af:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 10             	pushl  0x10(%ebp)
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 05 00 00 00       	call   8007c6 <vprintfmt>
}
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <vprintfmt>:
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	57                   	push   %edi
  8007ca:	56                   	push   %esi
  8007cb:	53                   	push   %ebx
  8007cc:	83 ec 2c             	sub    $0x2c,%esp
  8007cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007d5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8007d8:	e9 c1 03 00 00       	jmp    800b9e <vprintfmt+0x3d8>
		padc = ' ';
  8007dd:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8007e1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8007e8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8007ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007fb:	8d 47 01             	lea    0x1(%edi),%eax
  8007fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800801:	0f b6 17             	movzbl (%edi),%edx
  800804:	8d 42 dd             	lea    -0x23(%edx),%eax
  800807:	3c 55                	cmp    $0x55,%al
  800809:	0f 87 12 04 00 00    	ja     800c21 <vprintfmt+0x45b>
  80080f:	0f b6 c0             	movzbl %al,%eax
  800812:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  800819:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80081c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800820:	eb d9                	jmp    8007fb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800822:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800825:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800829:	eb d0                	jmp    8007fb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80082b:	0f b6 d2             	movzbl %dl,%edx
  80082e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800839:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80083c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800840:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800843:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800846:	83 f9 09             	cmp    $0x9,%ecx
  800849:	77 55                	ja     8008a0 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80084b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80084e:	eb e9                	jmp    800839 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8d 40 04             	lea    0x4(%eax),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800861:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 91                	jns    8007fb <vprintfmt+0x35>
				width = precision, precision = -1;
  80086a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80086d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800870:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800877:	eb 82                	jmp    8007fb <vprintfmt+0x35>
  800879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80087c:	85 c0                	test   %eax,%eax
  80087e:	ba 00 00 00 00       	mov    $0x0,%edx
  800883:	0f 49 d0             	cmovns %eax,%edx
  800886:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800889:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80088c:	e9 6a ff ff ff       	jmp    8007fb <vprintfmt+0x35>
  800891:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800894:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80089b:	e9 5b ff ff ff       	jmp    8007fb <vprintfmt+0x35>
  8008a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a6:	eb bc                	jmp    800864 <vprintfmt+0x9e>
			lflag++;
  8008a8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008ae:	e9 48 ff ff ff       	jmp    8007fb <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8d 78 04             	lea    0x4(%eax),%edi
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	ff 30                	pushl  (%eax)
  8008bf:	ff d6                	call   *%esi
			break;
  8008c1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8008c4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8008c7:	e9 cf 02 00 00       	jmp    800b9b <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8d 78 04             	lea    0x4(%eax),%edi
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	99                   	cltd   
  8008d5:	31 d0                	xor    %edx,%eax
  8008d7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d9:	83 f8 0f             	cmp    $0xf,%eax
  8008dc:	7f 23                	jg     800901 <vprintfmt+0x13b>
  8008de:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  8008e5:	85 d2                	test   %edx,%edx
  8008e7:	74 18                	je     800901 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8008e9:	52                   	push   %edx
  8008ea:	68 d5 2f 80 00       	push   $0x802fd5
  8008ef:	53                   	push   %ebx
  8008f0:	56                   	push   %esi
  8008f1:	e8 b3 fe ff ff       	call   8007a9 <printfmt>
  8008f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8008f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008fc:	e9 9a 02 00 00       	jmp    800b9b <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800901:	50                   	push   %eax
  800902:	68 0b 2c 80 00       	push   $0x802c0b
  800907:	53                   	push   %ebx
  800908:	56                   	push   %esi
  800909:	e8 9b fe ff ff       	call   8007a9 <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800911:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800914:	e9 82 02 00 00       	jmp    800b9b <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	83 c0 04             	add    $0x4,%eax
  80091f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800927:	85 ff                	test   %edi,%edi
  800929:	b8 04 2c 80 00       	mov    $0x802c04,%eax
  80092e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800931:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800935:	0f 8e bd 00 00 00    	jle    8009f8 <vprintfmt+0x232>
  80093b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80093f:	75 0e                	jne    80094f <vprintfmt+0x189>
  800941:	89 75 08             	mov    %esi,0x8(%ebp)
  800944:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800947:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80094a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80094d:	eb 6d                	jmp    8009bc <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 d0             	pushl  -0x30(%ebp)
  800955:	57                   	push   %edi
  800956:	e8 6e 03 00 00       	call   800cc9 <strnlen>
  80095b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80095e:	29 c1                	sub    %eax,%ecx
  800960:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800963:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800966:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80096a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80096d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800970:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800972:	eb 0f                	jmp    800983 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	53                   	push   %ebx
  800978:	ff 75 e0             	pushl  -0x20(%ebp)
  80097b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	83 ef 01             	sub    $0x1,%edi
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	85 ff                	test   %edi,%edi
  800985:	7f ed                	jg     800974 <vprintfmt+0x1ae>
  800987:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80098a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80098d:	85 c9                	test   %ecx,%ecx
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
  800994:	0f 49 c1             	cmovns %ecx,%eax
  800997:	29 c1                	sub    %eax,%ecx
  800999:	89 75 08             	mov    %esi,0x8(%ebp)
  80099c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80099f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8009a2:	89 cb                	mov    %ecx,%ebx
  8009a4:	eb 16                	jmp    8009bc <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009aa:	75 31                	jne    8009dd <vprintfmt+0x217>
					putch(ch, putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	50                   	push   %eax
  8009b3:	ff 55 08             	call   *0x8(%ebp)
  8009b6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	83 eb 01             	sub    $0x1,%ebx
  8009bc:	83 c7 01             	add    $0x1,%edi
  8009bf:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8009c3:	0f be c2             	movsbl %dl,%eax
  8009c6:	85 c0                	test   %eax,%eax
  8009c8:	74 59                	je     800a23 <vprintfmt+0x25d>
  8009ca:	85 f6                	test   %esi,%esi
  8009cc:	78 d8                	js     8009a6 <vprintfmt+0x1e0>
  8009ce:	83 ee 01             	sub    $0x1,%esi
  8009d1:	79 d3                	jns    8009a6 <vprintfmt+0x1e0>
  8009d3:	89 df                	mov    %ebx,%edi
  8009d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009db:	eb 37                	jmp    800a14 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	0f be d2             	movsbl %dl,%edx
  8009e0:	83 ea 20             	sub    $0x20,%edx
  8009e3:	83 fa 5e             	cmp    $0x5e,%edx
  8009e6:	76 c4                	jbe    8009ac <vprintfmt+0x1e6>
					putch('?', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 3f                	push   $0x3f
  8009f0:	ff 55 08             	call   *0x8(%ebp)
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	eb c1                	jmp    8009b9 <vprintfmt+0x1f3>
  8009f8:	89 75 08             	mov    %esi,0x8(%ebp)
  8009fb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009fe:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a01:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a04:	eb b6                	jmp    8009bc <vprintfmt+0x1f6>
				putch(' ', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	53                   	push   %ebx
  800a0a:	6a 20                	push   $0x20
  800a0c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a0e:	83 ef 01             	sub    $0x1,%edi
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	85 ff                	test   %edi,%edi
  800a16:	7f ee                	jg     800a06 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800a18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1e:	e9 78 01 00 00       	jmp    800b9b <vprintfmt+0x3d5>
  800a23:	89 df                	mov    %ebx,%edi
  800a25:	8b 75 08             	mov    0x8(%ebp),%esi
  800a28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a2b:	eb e7                	jmp    800a14 <vprintfmt+0x24e>
	if (lflag >= 2)
  800a2d:	83 f9 01             	cmp    $0x1,%ecx
  800a30:	7e 3f                	jle    800a71 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	8b 50 04             	mov    0x4(%eax),%edx
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8d 40 08             	lea    0x8(%eax),%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a4d:	79 5c                	jns    800aab <vprintfmt+0x2e5>
				putch('-', putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	6a 2d                	push   $0x2d
  800a55:	ff d6                	call   *%esi
				num = -(long long) num;
  800a57:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a5a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800a5d:	f7 da                	neg    %edx
  800a5f:	83 d1 00             	adc    $0x0,%ecx
  800a62:	f7 d9                	neg    %ecx
  800a64:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800a67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6c:	e9 10 01 00 00       	jmp    800b81 <vprintfmt+0x3bb>
	else if (lflag)
  800a71:	85 c9                	test   %ecx,%ecx
  800a73:	75 1b                	jne    800a90 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	8b 00                	mov    (%eax),%eax
  800a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7d:	89 c1                	mov    %eax,%ecx
  800a7f:	c1 f9 1f             	sar    $0x1f,%ecx
  800a82:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	8d 40 04             	lea    0x4(%eax),%eax
  800a8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8e:	eb b9                	jmp    800a49 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800a90:	8b 45 14             	mov    0x14(%ebp),%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a98:	89 c1                	mov    %eax,%ecx
  800a9a:	c1 f9 1f             	sar    $0x1f,%ecx
  800a9d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	8d 40 04             	lea    0x4(%eax),%eax
  800aa6:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa9:	eb 9e                	jmp    800a49 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800aab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aae:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800ab1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab6:	e9 c6 00 00 00       	jmp    800b81 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800abb:	83 f9 01             	cmp    $0x1,%ecx
  800abe:	7e 18                	jle    800ad8 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	8b 10                	mov    (%eax),%edx
  800ac5:	8b 48 04             	mov    0x4(%eax),%ecx
  800ac8:	8d 40 08             	lea    0x8(%eax),%eax
  800acb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ace:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad3:	e9 a9 00 00 00       	jmp    800b81 <vprintfmt+0x3bb>
	else if (lflag)
  800ad8:	85 c9                	test   %ecx,%ecx
  800ada:	75 1a                	jne    800af6 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	8b 10                	mov    (%eax),%edx
  800ae1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae6:	8d 40 04             	lea    0x4(%eax),%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af1:	e9 8b 00 00 00       	jmp    800b81 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	8b 10                	mov    (%eax),%edx
  800afb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b00:	8d 40 04             	lea    0x4(%eax),%eax
  800b03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b06:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0b:	eb 74                	jmp    800b81 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800b0d:	83 f9 01             	cmp    $0x1,%ecx
  800b10:	7e 15                	jle    800b27 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 48 04             	mov    0x4(%eax),%ecx
  800b1a:	8d 40 08             	lea    0x8(%eax),%eax
  800b1d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b20:	b8 08 00 00 00       	mov    $0x8,%eax
  800b25:	eb 5a                	jmp    800b81 <vprintfmt+0x3bb>
	else if (lflag)
  800b27:	85 c9                	test   %ecx,%ecx
  800b29:	75 17                	jne    800b42 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2e:	8b 10                	mov    (%eax),%edx
  800b30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b35:	8d 40 04             	lea    0x4(%eax),%eax
  800b38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b3b:	b8 08 00 00 00       	mov    $0x8,%eax
  800b40:	eb 3f                	jmp    800b81 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800b42:	8b 45 14             	mov    0x14(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4c:	8d 40 04             	lea    0x4(%eax),%eax
  800b4f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b52:	b8 08 00 00 00       	mov    $0x8,%eax
  800b57:	eb 28                	jmp    800b81 <vprintfmt+0x3bb>
			putch('0', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	53                   	push   %ebx
  800b5d:	6a 30                	push   $0x30
  800b5f:	ff d6                	call   *%esi
			putch('x', putdat);
  800b61:	83 c4 08             	add    $0x8,%esp
  800b64:	53                   	push   %ebx
  800b65:	6a 78                	push   $0x78
  800b67:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	8b 10                	mov    (%eax),%edx
  800b6e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800b73:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b76:	8d 40 04             	lea    0x4(%eax),%eax
  800b79:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b7c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b81:	83 ec 0c             	sub    $0xc,%esp
  800b84:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800b88:	57                   	push   %edi
  800b89:	ff 75 e0             	pushl  -0x20(%ebp)
  800b8c:	50                   	push   %eax
  800b8d:	51                   	push   %ecx
  800b8e:	52                   	push   %edx
  800b8f:	89 da                	mov    %ebx,%edx
  800b91:	89 f0                	mov    %esi,%eax
  800b93:	e8 45 fb ff ff       	call   8006dd <printnum>
			break;
  800b98:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800b9b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b9e:	83 c7 01             	add    $0x1,%edi
  800ba1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ba5:	83 f8 25             	cmp    $0x25,%eax
  800ba8:	0f 84 2f fc ff ff    	je     8007dd <vprintfmt+0x17>
			if (ch == '\0')
  800bae:	85 c0                	test   %eax,%eax
  800bb0:	0f 84 8b 00 00 00    	je     800c41 <vprintfmt+0x47b>
			putch(ch, putdat);
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	53                   	push   %ebx
  800bba:	50                   	push   %eax
  800bbb:	ff d6                	call   *%esi
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	eb dc                	jmp    800b9e <vprintfmt+0x3d8>
	if (lflag >= 2)
  800bc2:	83 f9 01             	cmp    $0x1,%ecx
  800bc5:	7e 15                	jle    800bdc <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bca:	8b 10                	mov    (%eax),%edx
  800bcc:	8b 48 04             	mov    0x4(%eax),%ecx
  800bcf:	8d 40 08             	lea    0x8(%eax),%eax
  800bd2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bd5:	b8 10 00 00 00       	mov    $0x10,%eax
  800bda:	eb a5                	jmp    800b81 <vprintfmt+0x3bb>
	else if (lflag)
  800bdc:	85 c9                	test   %ecx,%ecx
  800bde:	75 17                	jne    800bf7 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	8b 10                	mov    (%eax),%edx
  800be5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bea:	8d 40 04             	lea    0x4(%eax),%eax
  800bed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bf0:	b8 10 00 00 00       	mov    $0x10,%eax
  800bf5:	eb 8a                	jmp    800b81 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfa:	8b 10                	mov    (%eax),%edx
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	8d 40 04             	lea    0x4(%eax),%eax
  800c04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c07:	b8 10 00 00 00       	mov    $0x10,%eax
  800c0c:	e9 70 ff ff ff       	jmp    800b81 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800c11:	83 ec 08             	sub    $0x8,%esp
  800c14:	53                   	push   %ebx
  800c15:	6a 25                	push   $0x25
  800c17:	ff d6                	call   *%esi
			break;
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	e9 7a ff ff ff       	jmp    800b9b <vprintfmt+0x3d5>
			putch('%', putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	53                   	push   %ebx
  800c25:	6a 25                	push   $0x25
  800c27:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c29:	83 c4 10             	add    $0x10,%esp
  800c2c:	89 f8                	mov    %edi,%eax
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x46d>
  800c30:	83 e8 01             	sub    $0x1,%eax
  800c33:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c37:	75 f7                	jne    800c30 <vprintfmt+0x46a>
  800c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3c:	e9 5a ff ff ff       	jmp    800b9b <vprintfmt+0x3d5>
}
  800c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 18             	sub    $0x18,%esp
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c58:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c5c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c66:	85 c0                	test   %eax,%eax
  800c68:	74 26                	je     800c90 <vsnprintf+0x47>
  800c6a:	85 d2                	test   %edx,%edx
  800c6c:	7e 22                	jle    800c90 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c6e:	ff 75 14             	pushl  0x14(%ebp)
  800c71:	ff 75 10             	pushl  0x10(%ebp)
  800c74:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c77:	50                   	push   %eax
  800c78:	68 8c 07 80 00       	push   $0x80078c
  800c7d:	e8 44 fb ff ff       	call   8007c6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c85:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    
		return -E_INVAL;
  800c90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c95:	eb f7                	jmp    800c8e <vsnprintf+0x45>

00800c97 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c9d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ca0:	50                   	push   %eax
  800ca1:	ff 75 10             	pushl  0x10(%ebp)
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	ff 75 08             	pushl  0x8(%ebp)
  800caa:	e8 9a ff ff ff       	call   800c49 <vsnprintf>
	va_end(ap);

	return rc;
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbc:	eb 03                	jmp    800cc1 <strlen+0x10>
		n++;
  800cbe:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800cc1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cc5:	75 f7                	jne    800cbe <strlen+0xd>
	return n;
}
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd7:	eb 03                	jmp    800cdc <strnlen+0x13>
		n++;
  800cd9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdc:	39 d0                	cmp    %edx,%eax
  800cde:	74 06                	je     800ce6 <strnlen+0x1d>
  800ce0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ce4:	75 f3                	jne    800cd9 <strnlen+0x10>
	return n;
}
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	53                   	push   %ebx
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cf2:	89 c2                	mov    %eax,%edx
  800cf4:	83 c1 01             	add    $0x1,%ecx
  800cf7:	83 c2 01             	add    $0x1,%edx
  800cfa:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800cfe:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d01:	84 db                	test   %bl,%bl
  800d03:	75 ef                	jne    800cf4 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d05:	5b                   	pop    %ebx
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	53                   	push   %ebx
  800d0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d0f:	53                   	push   %ebx
  800d10:	e8 9c ff ff ff       	call   800cb1 <strlen>
  800d15:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	01 d8                	add    %ebx,%eax
  800d1d:	50                   	push   %eax
  800d1e:	e8 c5 ff ff ff       	call   800ce8 <strcpy>
	return dst;
}
  800d23:	89 d8                	mov    %ebx,%eax
  800d25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	8b 75 08             	mov    0x8(%ebp),%esi
  800d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d35:	89 f3                	mov    %esi,%ebx
  800d37:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3a:	89 f2                	mov    %esi,%edx
  800d3c:	eb 0f                	jmp    800d4d <strncpy+0x23>
		*dst++ = *src;
  800d3e:	83 c2 01             	add    $0x1,%edx
  800d41:	0f b6 01             	movzbl (%ecx),%eax
  800d44:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d47:	80 39 01             	cmpb   $0x1,(%ecx)
  800d4a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800d4d:	39 da                	cmp    %ebx,%edx
  800d4f:	75 ed                	jne    800d3e <strncpy+0x14>
	}
	return ret;
}
  800d51:	89 f0                	mov    %esi,%eax
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
  800d5c:	8b 75 08             	mov    0x8(%ebp),%esi
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d65:	89 f0                	mov    %esi,%eax
  800d67:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d6b:	85 c9                	test   %ecx,%ecx
  800d6d:	75 0b                	jne    800d7a <strlcpy+0x23>
  800d6f:	eb 17                	jmp    800d88 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d71:	83 c2 01             	add    $0x1,%edx
  800d74:	83 c0 01             	add    $0x1,%eax
  800d77:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800d7a:	39 d8                	cmp    %ebx,%eax
  800d7c:	74 07                	je     800d85 <strlcpy+0x2e>
  800d7e:	0f b6 0a             	movzbl (%edx),%ecx
  800d81:	84 c9                	test   %cl,%cl
  800d83:	75 ec                	jne    800d71 <strlcpy+0x1a>
		*dst = '\0';
  800d85:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d88:	29 f0                	sub    %esi,%eax
}
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d94:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d97:	eb 06                	jmp    800d9f <strcmp+0x11>
		p++, q++;
  800d99:	83 c1 01             	add    $0x1,%ecx
  800d9c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800d9f:	0f b6 01             	movzbl (%ecx),%eax
  800da2:	84 c0                	test   %al,%al
  800da4:	74 04                	je     800daa <strcmp+0x1c>
  800da6:	3a 02                	cmp    (%edx),%al
  800da8:	74 ef                	je     800d99 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800daa:	0f b6 c0             	movzbl %al,%eax
  800dad:	0f b6 12             	movzbl (%edx),%edx
  800db0:	29 d0                	sub    %edx,%eax
}
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	53                   	push   %ebx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbe:	89 c3                	mov    %eax,%ebx
  800dc0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strncmp+0x17>
		n--, p++, q++;
  800dc5:	83 c0 01             	add    $0x1,%eax
  800dc8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800dcb:	39 d8                	cmp    %ebx,%eax
  800dcd:	74 16                	je     800de5 <strncmp+0x31>
  800dcf:	0f b6 08             	movzbl (%eax),%ecx
  800dd2:	84 c9                	test   %cl,%cl
  800dd4:	74 04                	je     800dda <strncmp+0x26>
  800dd6:	3a 0a                	cmp    (%edx),%cl
  800dd8:	74 eb                	je     800dc5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dda:	0f b6 00             	movzbl (%eax),%eax
  800ddd:	0f b6 12             	movzbl (%edx),%edx
  800de0:	29 d0                	sub    %edx,%eax
}
  800de2:	5b                   	pop    %ebx
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		return 0;
  800de5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dea:	eb f6                	jmp    800de2 <strncmp+0x2e>

00800dec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800df6:	0f b6 10             	movzbl (%eax),%edx
  800df9:	84 d2                	test   %dl,%dl
  800dfb:	74 09                	je     800e06 <strchr+0x1a>
		if (*s == c)
  800dfd:	38 ca                	cmp    %cl,%dl
  800dff:	74 0a                	je     800e0b <strchr+0x1f>
	for (; *s; s++)
  800e01:	83 c0 01             	add    $0x1,%eax
  800e04:	eb f0                	jmp    800df6 <strchr+0xa>
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e17:	eb 03                	jmp    800e1c <strfind+0xf>
  800e19:	83 c0 01             	add    $0x1,%eax
  800e1c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e1f:	38 ca                	cmp    %cl,%dl
  800e21:	74 04                	je     800e27 <strfind+0x1a>
  800e23:	84 d2                	test   %dl,%dl
  800e25:	75 f2                	jne    800e19 <strfind+0xc>
			break;
	return (char *) s;
}
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e32:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e35:	85 c9                	test   %ecx,%ecx
  800e37:	74 13                	je     800e4c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e39:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e3f:	75 05                	jne    800e46 <memset+0x1d>
  800e41:	f6 c1 03             	test   $0x3,%cl
  800e44:	74 0d                	je     800e53 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	fc                   	cld    
  800e4a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e4c:	89 f8                	mov    %edi,%eax
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    
		c &= 0xFF;
  800e53:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e57:	89 d3                	mov    %edx,%ebx
  800e59:	c1 e3 08             	shl    $0x8,%ebx
  800e5c:	89 d0                	mov    %edx,%eax
  800e5e:	c1 e0 18             	shl    $0x18,%eax
  800e61:	89 d6                	mov    %edx,%esi
  800e63:	c1 e6 10             	shl    $0x10,%esi
  800e66:	09 f0                	or     %esi,%eax
  800e68:	09 c2                	or     %eax,%edx
  800e6a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800e6c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e6f:	89 d0                	mov    %edx,%eax
  800e71:	fc                   	cld    
  800e72:	f3 ab                	rep stos %eax,%es:(%edi)
  800e74:	eb d6                	jmp    800e4c <memset+0x23>

00800e76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e81:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e84:	39 c6                	cmp    %eax,%esi
  800e86:	73 35                	jae    800ebd <memmove+0x47>
  800e88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e8b:	39 c2                	cmp    %eax,%edx
  800e8d:	76 2e                	jbe    800ebd <memmove+0x47>
		s += n;
		d += n;
  800e8f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e92:	89 d6                	mov    %edx,%esi
  800e94:	09 fe                	or     %edi,%esi
  800e96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e9c:	74 0c                	je     800eaa <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e9e:	83 ef 01             	sub    $0x1,%edi
  800ea1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ea4:	fd                   	std    
  800ea5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ea7:	fc                   	cld    
  800ea8:	eb 21                	jmp    800ecb <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eaa:	f6 c1 03             	test   $0x3,%cl
  800ead:	75 ef                	jne    800e9e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800eaf:	83 ef 04             	sub    $0x4,%edi
  800eb2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800eb5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800eb8:	fd                   	std    
  800eb9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ebb:	eb ea                	jmp    800ea7 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ebd:	89 f2                	mov    %esi,%edx
  800ebf:	09 c2                	or     %eax,%edx
  800ec1:	f6 c2 03             	test   $0x3,%dl
  800ec4:	74 09                	je     800ecf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ec6:	89 c7                	mov    %eax,%edi
  800ec8:	fc                   	cld    
  800ec9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ecb:	5e                   	pop    %esi
  800ecc:	5f                   	pop    %edi
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ecf:	f6 c1 03             	test   $0x3,%cl
  800ed2:	75 f2                	jne    800ec6 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ed4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ed7:	89 c7                	mov    %eax,%edi
  800ed9:	fc                   	cld    
  800eda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800edc:	eb ed                	jmp    800ecb <memmove+0x55>

00800ede <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ee1:	ff 75 10             	pushl  0x10(%ebp)
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	ff 75 08             	pushl  0x8(%ebp)
  800eea:	e8 87 ff ff ff       	call   800e76 <memmove>
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efc:	89 c6                	mov    %eax,%esi
  800efe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f01:	39 f0                	cmp    %esi,%eax
  800f03:	74 1c                	je     800f21 <memcmp+0x30>
		if (*s1 != *s2)
  800f05:	0f b6 08             	movzbl (%eax),%ecx
  800f08:	0f b6 1a             	movzbl (%edx),%ebx
  800f0b:	38 d9                	cmp    %bl,%cl
  800f0d:	75 08                	jne    800f17 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f0f:	83 c0 01             	add    $0x1,%eax
  800f12:	83 c2 01             	add    $0x1,%edx
  800f15:	eb ea                	jmp    800f01 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f17:	0f b6 c1             	movzbl %cl,%eax
  800f1a:	0f b6 db             	movzbl %bl,%ebx
  800f1d:	29 d8                	sub    %ebx,%eax
  800f1f:	eb 05                	jmp    800f26 <memcmp+0x35>
	}

	return 0;
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5d                   	pop    %ebp
  800f29:	c3                   	ret    

00800f2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f33:	89 c2                	mov    %eax,%edx
  800f35:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f38:	39 d0                	cmp    %edx,%eax
  800f3a:	73 09                	jae    800f45 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3c:	38 08                	cmp    %cl,(%eax)
  800f3e:	74 05                	je     800f45 <memfind+0x1b>
	for (; s < ends; s++)
  800f40:	83 c0 01             	add    $0x1,%eax
  800f43:	eb f3                	jmp    800f38 <memfind+0xe>
			break;
	return (void *) s;
}
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	57                   	push   %edi
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
  800f4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f53:	eb 03                	jmp    800f58 <strtol+0x11>
		s++;
  800f55:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f58:	0f b6 01             	movzbl (%ecx),%eax
  800f5b:	3c 20                	cmp    $0x20,%al
  800f5d:	74 f6                	je     800f55 <strtol+0xe>
  800f5f:	3c 09                	cmp    $0x9,%al
  800f61:	74 f2                	je     800f55 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f63:	3c 2b                	cmp    $0x2b,%al
  800f65:	74 2e                	je     800f95 <strtol+0x4e>
	int neg = 0;
  800f67:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f6c:	3c 2d                	cmp    $0x2d,%al
  800f6e:	74 2f                	je     800f9f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f70:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f76:	75 05                	jne    800f7d <strtol+0x36>
  800f78:	80 39 30             	cmpb   $0x30,(%ecx)
  800f7b:	74 2c                	je     800fa9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f7d:	85 db                	test   %ebx,%ebx
  800f7f:	75 0a                	jne    800f8b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f81:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800f86:	80 39 30             	cmpb   $0x30,(%ecx)
  800f89:	74 28                	je     800fb3 <strtol+0x6c>
		base = 10;
  800f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f90:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f93:	eb 50                	jmp    800fe5 <strtol+0x9e>
		s++;
  800f95:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f98:	bf 00 00 00 00       	mov    $0x0,%edi
  800f9d:	eb d1                	jmp    800f70 <strtol+0x29>
		s++, neg = 1;
  800f9f:	83 c1 01             	add    $0x1,%ecx
  800fa2:	bf 01 00 00 00       	mov    $0x1,%edi
  800fa7:	eb c7                	jmp    800f70 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fa9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fad:	74 0e                	je     800fbd <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800faf:	85 db                	test   %ebx,%ebx
  800fb1:	75 d8                	jne    800f8b <strtol+0x44>
		s++, base = 8;
  800fb3:	83 c1 01             	add    $0x1,%ecx
  800fb6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fbb:	eb ce                	jmp    800f8b <strtol+0x44>
		s += 2, base = 16;
  800fbd:	83 c1 02             	add    $0x2,%ecx
  800fc0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fc5:	eb c4                	jmp    800f8b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fc7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fca:	89 f3                	mov    %esi,%ebx
  800fcc:	80 fb 19             	cmp    $0x19,%bl
  800fcf:	77 29                	ja     800ffa <strtol+0xb3>
			dig = *s - 'a' + 10;
  800fd1:	0f be d2             	movsbl %dl,%edx
  800fd4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fd7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800fda:	7d 30                	jge    80100c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800fdc:	83 c1 01             	add    $0x1,%ecx
  800fdf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fe5:	0f b6 11             	movzbl (%ecx),%edx
  800fe8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800feb:	89 f3                	mov    %esi,%ebx
  800fed:	80 fb 09             	cmp    $0x9,%bl
  800ff0:	77 d5                	ja     800fc7 <strtol+0x80>
			dig = *s - '0';
  800ff2:	0f be d2             	movsbl %dl,%edx
  800ff5:	83 ea 30             	sub    $0x30,%edx
  800ff8:	eb dd                	jmp    800fd7 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ffa:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ffd:	89 f3                	mov    %esi,%ebx
  800fff:	80 fb 19             	cmp    $0x19,%bl
  801002:	77 08                	ja     80100c <strtol+0xc5>
			dig = *s - 'A' + 10;
  801004:	0f be d2             	movsbl %dl,%edx
  801007:	83 ea 37             	sub    $0x37,%edx
  80100a:	eb cb                	jmp    800fd7 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  80100c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801010:	74 05                	je     801017 <strtol+0xd0>
		*endptr = (char *) s;
  801012:	8b 75 0c             	mov    0xc(%ebp),%esi
  801015:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801017:	89 c2                	mov    %eax,%edx
  801019:	f7 da                	neg    %edx
  80101b:	85 ff                	test   %edi,%edi
  80101d:	0f 45 c2             	cmovne %edx,%eax
}
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	57                   	push   %edi
  801029:	56                   	push   %esi
  80102a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	89 c3                	mov    %eax,%ebx
  801038:	89 c7                	mov    %eax,%edi
  80103a:	89 c6                	mov    %eax,%esi
  80103c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    

00801043 <sys_cgetc>:

int
sys_cgetc(void)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
	asm volatile("int %1\n"
  801049:	ba 00 00 00 00       	mov    $0x0,%edx
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	89 d1                	mov    %edx,%ecx
  801055:	89 d3                	mov    %edx,%ebx
  801057:	89 d7                	mov    %edx,%edi
  801059:	89 d6                	mov    %edx,%esi
  80105b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80105d:	5b                   	pop    %ebx
  80105e:	5e                   	pop    %esi
  80105f:	5f                   	pop    %edi
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80106b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	b8 03 00 00 00       	mov    $0x3,%eax
  801078:	89 cb                	mov    %ecx,%ebx
  80107a:	89 cf                	mov    %ecx,%edi
  80107c:	89 ce                	mov    %ecx,%esi
  80107e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801080:	85 c0                	test   %eax,%eax
  801082:	7f 08                	jg     80108c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801084:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5f                   	pop    %edi
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	50                   	push   %eax
  801090:	6a 03                	push   $0x3
  801092:	68 ff 2e 80 00       	push   $0x802eff
  801097:	6a 23                	push   $0x23
  801099:	68 1c 2f 80 00       	push   $0x802f1c
  80109e:	e8 4b f5 ff ff       	call   8005ee <_panic>

008010a3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8010b3:	89 d1                	mov    %edx,%ecx
  8010b5:	89 d3                	mov    %edx,%ebx
  8010b7:	89 d7                	mov    %edx,%edi
  8010b9:	89 d6                	mov    %edx,%esi
  8010bb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5f                   	pop    %edi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    

008010c2 <sys_yield>:

void
sys_yield(void)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	57                   	push   %edi
  8010c6:	56                   	push   %esi
  8010c7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cd:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010d2:	89 d1                	mov    %edx,%ecx
  8010d4:	89 d3                	mov    %edx,%ebx
  8010d6:	89 d7                	mov    %edx,%edi
  8010d8:	89 d6                	mov    %edx,%esi
  8010da:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5f                   	pop    %edi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ea:	be 00 00 00 00       	mov    $0x0,%esi
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f5:	b8 04 00 00 00       	mov    $0x4,%eax
  8010fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010fd:	89 f7                	mov    %esi,%edi
  8010ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  801101:	85 c0                	test   %eax,%eax
  801103:	7f 08                	jg     80110d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801105:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801108:	5b                   	pop    %ebx
  801109:	5e                   	pop    %esi
  80110a:	5f                   	pop    %edi
  80110b:	5d                   	pop    %ebp
  80110c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110d:	83 ec 0c             	sub    $0xc,%esp
  801110:	50                   	push   %eax
  801111:	6a 04                	push   $0x4
  801113:	68 ff 2e 80 00       	push   $0x802eff
  801118:	6a 23                	push   $0x23
  80111a:	68 1c 2f 80 00       	push   $0x802f1c
  80111f:	e8 ca f4 ff ff       	call   8005ee <_panic>

00801124 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	57                   	push   %edi
  801128:	56                   	push   %esi
  801129:	53                   	push   %ebx
  80112a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112d:	8b 55 08             	mov    0x8(%ebp),%edx
  801130:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801133:	b8 05 00 00 00       	mov    $0x5,%eax
  801138:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80113b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80113e:	8b 75 18             	mov    0x18(%ebp),%esi
  801141:	cd 30                	int    $0x30
	if(check && ret > 0)
  801143:	85 c0                	test   %eax,%eax
  801145:	7f 08                	jg     80114f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801147:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114a:	5b                   	pop    %ebx
  80114b:	5e                   	pop    %esi
  80114c:	5f                   	pop    %edi
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114f:	83 ec 0c             	sub    $0xc,%esp
  801152:	50                   	push   %eax
  801153:	6a 05                	push   $0x5
  801155:	68 ff 2e 80 00       	push   $0x802eff
  80115a:	6a 23                	push   $0x23
  80115c:	68 1c 2f 80 00       	push   $0x802f1c
  801161:	e8 88 f4 ff ff       	call   8005ee <_panic>

00801166 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117a:	b8 06 00 00 00       	mov    $0x6,%eax
  80117f:	89 df                	mov    %ebx,%edi
  801181:	89 de                	mov    %ebx,%esi
  801183:	cd 30                	int    $0x30
	if(check && ret > 0)
  801185:	85 c0                	test   %eax,%eax
  801187:	7f 08                	jg     801191 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	50                   	push   %eax
  801195:	6a 06                	push   $0x6
  801197:	68 ff 2e 80 00       	push   $0x802eff
  80119c:	6a 23                	push   $0x23
  80119e:	68 1c 2f 80 00       	push   $0x802f1c
  8011a3:	e8 46 f4 ff ff       	call   8005ee <_panic>

008011a8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	57                   	push   %edi
  8011ac:	56                   	push   %esi
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8011c1:	89 df                	mov    %ebx,%edi
  8011c3:	89 de                	mov    %ebx,%esi
  8011c5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	7f 08                	jg     8011d3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ce:	5b                   	pop    %ebx
  8011cf:	5e                   	pop    %esi
  8011d0:	5f                   	pop    %edi
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d3:	83 ec 0c             	sub    $0xc,%esp
  8011d6:	50                   	push   %eax
  8011d7:	6a 08                	push   $0x8
  8011d9:	68 ff 2e 80 00       	push   $0x802eff
  8011de:	6a 23                	push   $0x23
  8011e0:	68 1c 2f 80 00       	push   $0x802f1c
  8011e5:	e8 04 f4 ff ff       	call   8005ee <_panic>

008011ea <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	57                   	push   %edi
  8011ee:	56                   	push   %esi
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	b8 09 00 00 00       	mov    $0x9,%eax
  801203:	89 df                	mov    %ebx,%edi
  801205:	89 de                	mov    %ebx,%esi
  801207:	cd 30                	int    $0x30
	if(check && ret > 0)
  801209:	85 c0                	test   %eax,%eax
  80120b:	7f 08                	jg     801215 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80120d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	50                   	push   %eax
  801219:	6a 09                	push   $0x9
  80121b:	68 ff 2e 80 00       	push   $0x802eff
  801220:	6a 23                	push   $0x23
  801222:	68 1c 2f 80 00       	push   $0x802f1c
  801227:	e8 c2 f3 ff ff       	call   8005ee <_panic>

0080122c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123a:	8b 55 08             	mov    0x8(%ebp),%edx
  80123d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801240:	b8 0a 00 00 00       	mov    $0xa,%eax
  801245:	89 df                	mov    %ebx,%edi
  801247:	89 de                	mov    %ebx,%esi
  801249:	cd 30                	int    $0x30
	if(check && ret > 0)
  80124b:	85 c0                	test   %eax,%eax
  80124d:	7f 08                	jg     801257 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80124f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801252:	5b                   	pop    %ebx
  801253:	5e                   	pop    %esi
  801254:	5f                   	pop    %edi
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	50                   	push   %eax
  80125b:	6a 0a                	push   $0xa
  80125d:	68 ff 2e 80 00       	push   $0x802eff
  801262:	6a 23                	push   $0x23
  801264:	68 1c 2f 80 00       	push   $0x802f1c
  801269:	e8 80 f3 ff ff       	call   8005ee <_panic>

0080126e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	57                   	push   %edi
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
	asm volatile("int %1\n"
  801274:	8b 55 08             	mov    0x8(%ebp),%edx
  801277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80127f:	be 00 00 00 00       	mov    $0x0,%esi
  801284:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801287:	8b 7d 14             	mov    0x14(%ebp),%edi
  80128a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5f                   	pop    %edi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	57                   	push   %edi
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
  801297:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80129a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80129f:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a2:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012a7:	89 cb                	mov    %ecx,%ebx
  8012a9:	89 cf                	mov    %ecx,%edi
  8012ab:	89 ce                	mov    %ecx,%esi
  8012ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	7f 08                	jg     8012bb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	50                   	push   %eax
  8012bf:	6a 0d                	push   $0xd
  8012c1:	68 ff 2e 80 00       	push   $0x802eff
  8012c6:	6a 23                	push   $0x23
  8012c8:	68 1c 2f 80 00       	push   $0x802f1c
  8012cd:	e8 1c f3 ff ff       	call   8005ee <_panic>

008012d2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012dd:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012e2:	89 d1                	mov    %edx,%ecx
  8012e4:	89 d3                	mov    %edx,%ebx
  8012e6:	89 d7                	mov    %edx,%edi
  8012e8:	89 d6                	mov    %edx,%esi
  8012ea:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5f                   	pop    %edi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	05 00 00 00 30       	add    $0x30000000,%eax
  8012fc:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    

00801301 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80130c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801311:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801316:	5d                   	pop    %ebp
  801317:	c3                   	ret    

00801318 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801323:	89 c2                	mov    %eax,%edx
  801325:	c1 ea 16             	shr    $0x16,%edx
  801328:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80132f:	f6 c2 01             	test   $0x1,%dl
  801332:	74 2a                	je     80135e <fd_alloc+0x46>
  801334:	89 c2                	mov    %eax,%edx
  801336:	c1 ea 0c             	shr    $0xc,%edx
  801339:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801340:	f6 c2 01             	test   $0x1,%dl
  801343:	74 19                	je     80135e <fd_alloc+0x46>
  801345:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80134a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80134f:	75 d2                	jne    801323 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801351:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801357:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80135c:	eb 07                	jmp    801365 <fd_alloc+0x4d>
			*fd_store = fd;
  80135e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801360:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801365:	5d                   	pop    %ebp
  801366:	c3                   	ret    

00801367 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80136d:	83 f8 1f             	cmp    $0x1f,%eax
  801370:	77 36                	ja     8013a8 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801372:	c1 e0 0c             	shl    $0xc,%eax
  801375:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80137a:	89 c2                	mov    %eax,%edx
  80137c:	c1 ea 16             	shr    $0x16,%edx
  80137f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801386:	f6 c2 01             	test   $0x1,%dl
  801389:	74 24                	je     8013af <fd_lookup+0x48>
  80138b:	89 c2                	mov    %eax,%edx
  80138d:	c1 ea 0c             	shr    $0xc,%edx
  801390:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801397:	f6 c2 01             	test   $0x1,%dl
  80139a:	74 1a                	je     8013b6 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80139c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139f:	89 02                	mov    %eax,(%edx)
	return 0;
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a6:	5d                   	pop    %ebp
  8013a7:	c3                   	ret    
		return -E_INVAL;
  8013a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ad:	eb f7                	jmp    8013a6 <fd_lookup+0x3f>
		return -E_INVAL;
  8013af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b4:	eb f0                	jmp    8013a6 <fd_lookup+0x3f>
  8013b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bb:	eb e9                	jmp    8013a6 <fd_lookup+0x3f>

008013bd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c6:	ba a8 2f 80 00       	mov    $0x802fa8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013cb:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013d0:	39 08                	cmp    %ecx,(%eax)
  8013d2:	74 33                	je     801407 <dev_lookup+0x4a>
  8013d4:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013d7:	8b 02                	mov    (%edx),%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	75 f3                	jne    8013d0 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013dd:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8013e2:	8b 40 48             	mov    0x48(%eax),%eax
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	51                   	push   %ecx
  8013e9:	50                   	push   %eax
  8013ea:	68 2c 2f 80 00       	push   $0x802f2c
  8013ef:	e8 d5 f2 ff ff       	call   8006c9 <cprintf>
	*dev = 0;
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    
			*dev = devtab[i];
  801407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
  801411:	eb f2                	jmp    801405 <dev_lookup+0x48>

00801413 <fd_close>:
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	57                   	push   %edi
  801417:	56                   	push   %esi
  801418:	53                   	push   %ebx
  801419:	83 ec 1c             	sub    $0x1c,%esp
  80141c:	8b 75 08             	mov    0x8(%ebp),%esi
  80141f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801422:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801425:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801426:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80142c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80142f:	50                   	push   %eax
  801430:	e8 32 ff ff ff       	call   801367 <fd_lookup>
  801435:	89 c3                	mov    %eax,%ebx
  801437:	83 c4 08             	add    $0x8,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 05                	js     801443 <fd_close+0x30>
	    || fd != fd2)
  80143e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801441:	74 16                	je     801459 <fd_close+0x46>
		return (must_exist ? r : 0);
  801443:	89 f8                	mov    %edi,%eax
  801445:	84 c0                	test   %al,%al
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
  80144c:	0f 44 d8             	cmove  %eax,%ebx
}
  80144f:	89 d8                	mov    %ebx,%eax
  801451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801454:	5b                   	pop    %ebx
  801455:	5e                   	pop    %esi
  801456:	5f                   	pop    %edi
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80145f:	50                   	push   %eax
  801460:	ff 36                	pushl  (%esi)
  801462:	e8 56 ff ff ff       	call   8013bd <dev_lookup>
  801467:	89 c3                	mov    %eax,%ebx
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 15                	js     801485 <fd_close+0x72>
		if (dev->dev_close)
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	8b 40 10             	mov    0x10(%eax),%eax
  801476:	85 c0                	test   %eax,%eax
  801478:	74 1b                	je     801495 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80147a:	83 ec 0c             	sub    $0xc,%esp
  80147d:	56                   	push   %esi
  80147e:	ff d0                	call   *%eax
  801480:	89 c3                	mov    %eax,%ebx
  801482:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	56                   	push   %esi
  801489:	6a 00                	push   $0x0
  80148b:	e8 d6 fc ff ff       	call   801166 <sys_page_unmap>
	return r;
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	eb ba                	jmp    80144f <fd_close+0x3c>
			r = 0;
  801495:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149a:	eb e9                	jmp    801485 <fd_close+0x72>

0080149c <close>:

int
close(int fdnum)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a5:	50                   	push   %eax
  8014a6:	ff 75 08             	pushl  0x8(%ebp)
  8014a9:	e8 b9 fe ff ff       	call   801367 <fd_lookup>
  8014ae:	83 c4 08             	add    $0x8,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 10                	js     8014c5 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	6a 01                	push   $0x1
  8014ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8014bd:	e8 51 ff ff ff       	call   801413 <fd_close>
  8014c2:	83 c4 10             	add    $0x10,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <close_all>:

void
close_all(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ce:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	53                   	push   %ebx
  8014d7:	e8 c0 ff ff ff       	call   80149c <close>
	for (i = 0; i < MAXFD; i++)
  8014dc:	83 c3 01             	add    $0x1,%ebx
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	83 fb 20             	cmp    $0x20,%ebx
  8014e5:	75 ec                	jne    8014d3 <close_all+0xc>
}
  8014e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	57                   	push   %edi
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014f8:	50                   	push   %eax
  8014f9:	ff 75 08             	pushl  0x8(%ebp)
  8014fc:	e8 66 fe ff ff       	call   801367 <fd_lookup>
  801501:	89 c3                	mov    %eax,%ebx
  801503:	83 c4 08             	add    $0x8,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	0f 88 81 00 00 00    	js     80158f <dup+0xa3>
		return r;
	close(newfdnum);
  80150e:	83 ec 0c             	sub    $0xc,%esp
  801511:	ff 75 0c             	pushl  0xc(%ebp)
  801514:	e8 83 ff ff ff       	call   80149c <close>

	newfd = INDEX2FD(newfdnum);
  801519:	8b 75 0c             	mov    0xc(%ebp),%esi
  80151c:	c1 e6 0c             	shl    $0xc,%esi
  80151f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801525:	83 c4 04             	add    $0x4,%esp
  801528:	ff 75 e4             	pushl  -0x1c(%ebp)
  80152b:	e8 d1 fd ff ff       	call   801301 <fd2data>
  801530:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801532:	89 34 24             	mov    %esi,(%esp)
  801535:	e8 c7 fd ff ff       	call   801301 <fd2data>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80153f:	89 d8                	mov    %ebx,%eax
  801541:	c1 e8 16             	shr    $0x16,%eax
  801544:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80154b:	a8 01                	test   $0x1,%al
  80154d:	74 11                	je     801560 <dup+0x74>
  80154f:	89 d8                	mov    %ebx,%eax
  801551:	c1 e8 0c             	shr    $0xc,%eax
  801554:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80155b:	f6 c2 01             	test   $0x1,%dl
  80155e:	75 39                	jne    801599 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801560:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801563:	89 d0                	mov    %edx,%eax
  801565:	c1 e8 0c             	shr    $0xc,%eax
  801568:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80156f:	83 ec 0c             	sub    $0xc,%esp
  801572:	25 07 0e 00 00       	and    $0xe07,%eax
  801577:	50                   	push   %eax
  801578:	56                   	push   %esi
  801579:	6a 00                	push   $0x0
  80157b:	52                   	push   %edx
  80157c:	6a 00                	push   $0x0
  80157e:	e8 a1 fb ff ff       	call   801124 <sys_page_map>
  801583:	89 c3                	mov    %eax,%ebx
  801585:	83 c4 20             	add    $0x20,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 31                	js     8015bd <dup+0xd1>
		goto err;

	return newfdnum;
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80158f:	89 d8                	mov    %ebx,%eax
  801591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801594:	5b                   	pop    %ebx
  801595:	5e                   	pop    %esi
  801596:	5f                   	pop    %edi
  801597:	5d                   	pop    %ebp
  801598:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801599:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a0:	83 ec 0c             	sub    $0xc,%esp
  8015a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a8:	50                   	push   %eax
  8015a9:	57                   	push   %edi
  8015aa:	6a 00                	push   $0x0
  8015ac:	53                   	push   %ebx
  8015ad:	6a 00                	push   $0x0
  8015af:	e8 70 fb ff ff       	call   801124 <sys_page_map>
  8015b4:	89 c3                	mov    %eax,%ebx
  8015b6:	83 c4 20             	add    $0x20,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	79 a3                	jns    801560 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	56                   	push   %esi
  8015c1:	6a 00                	push   $0x0
  8015c3:	e8 9e fb ff ff       	call   801166 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015c8:	83 c4 08             	add    $0x8,%esp
  8015cb:	57                   	push   %edi
  8015cc:	6a 00                	push   $0x0
  8015ce:	e8 93 fb ff ff       	call   801166 <sys_page_unmap>
	return r;
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	eb b7                	jmp    80158f <dup+0xa3>

008015d8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 14             	sub    $0x14,%esp
  8015df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e5:	50                   	push   %eax
  8015e6:	53                   	push   %ebx
  8015e7:	e8 7b fd ff ff       	call   801367 <fd_lookup>
  8015ec:	83 c4 08             	add    $0x8,%esp
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 3f                	js     801632 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	ff 30                	pushl  (%eax)
  8015ff:	e8 b9 fd ff ff       	call   8013bd <dev_lookup>
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	78 27                	js     801632 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80160b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160e:	8b 42 08             	mov    0x8(%edx),%eax
  801611:	83 e0 03             	and    $0x3,%eax
  801614:	83 f8 01             	cmp    $0x1,%eax
  801617:	74 1e                	je     801637 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	8b 40 08             	mov    0x8(%eax),%eax
  80161f:	85 c0                	test   %eax,%eax
  801621:	74 35                	je     801658 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	ff 75 10             	pushl  0x10(%ebp)
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	52                   	push   %edx
  80162d:	ff d0                	call   *%eax
  80162f:	83 c4 10             	add    $0x10,%esp
}
  801632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801635:	c9                   	leave  
  801636:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801637:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80163c:	8b 40 48             	mov    0x48(%eax),%eax
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	53                   	push   %ebx
  801643:	50                   	push   %eax
  801644:	68 6d 2f 80 00       	push   $0x802f6d
  801649:	e8 7b f0 ff ff       	call   8006c9 <cprintf>
		return -E_INVAL;
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801656:	eb da                	jmp    801632 <read+0x5a>
		return -E_NOT_SUPP;
  801658:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165d:	eb d3                	jmp    801632 <read+0x5a>

0080165f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	57                   	push   %edi
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	83 ec 0c             	sub    $0xc,%esp
  801668:	8b 7d 08             	mov    0x8(%ebp),%edi
  80166b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80166e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801673:	39 f3                	cmp    %esi,%ebx
  801675:	73 25                	jae    80169c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	89 f0                	mov    %esi,%eax
  80167c:	29 d8                	sub    %ebx,%eax
  80167e:	50                   	push   %eax
  80167f:	89 d8                	mov    %ebx,%eax
  801681:	03 45 0c             	add    0xc(%ebp),%eax
  801684:	50                   	push   %eax
  801685:	57                   	push   %edi
  801686:	e8 4d ff ff ff       	call   8015d8 <read>
		if (m < 0)
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 08                	js     80169a <readn+0x3b>
			return m;
		if (m == 0)
  801692:	85 c0                	test   %eax,%eax
  801694:	74 06                	je     80169c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801696:	01 c3                	add    %eax,%ebx
  801698:	eb d9                	jmp    801673 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80169a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80169c:	89 d8                	mov    %ebx,%eax
  80169e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5f                   	pop    %edi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 14             	sub    $0x14,%esp
  8016ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b3:	50                   	push   %eax
  8016b4:	53                   	push   %ebx
  8016b5:	e8 ad fc ff ff       	call   801367 <fd_lookup>
  8016ba:	83 c4 08             	add    $0x8,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 3a                	js     8016fb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	ff 30                	pushl  (%eax)
  8016cd:	e8 eb fc ff ff       	call   8013bd <dev_lookup>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 22                	js     8016fb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e0:	74 1e                	je     801700 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8016e8:	85 d2                	test   %edx,%edx
  8016ea:	74 35                	je     801721 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	ff 75 10             	pushl  0x10(%ebp)
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	50                   	push   %eax
  8016f6:	ff d2                	call   *%edx
  8016f8:	83 c4 10             	add    $0x10,%esp
}
  8016fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801700:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801705:	8b 40 48             	mov    0x48(%eax),%eax
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	53                   	push   %ebx
  80170c:	50                   	push   %eax
  80170d:	68 89 2f 80 00       	push   $0x802f89
  801712:	e8 b2 ef ff ff       	call   8006c9 <cprintf>
		return -E_INVAL;
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171f:	eb da                	jmp    8016fb <write+0x55>
		return -E_NOT_SUPP;
  801721:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801726:	eb d3                	jmp    8016fb <write+0x55>

00801728 <seek>:

int
seek(int fdnum, off_t offset)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80172e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801731:	50                   	push   %eax
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 2d fc ff ff       	call   801367 <fd_lookup>
  80173a:	83 c4 08             	add    $0x8,%esp
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 0e                	js     80174f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801741:	8b 55 0c             	mov    0xc(%ebp),%edx
  801744:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801747:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	53                   	push   %ebx
  801755:	83 ec 14             	sub    $0x14,%esp
  801758:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80175e:	50                   	push   %eax
  80175f:	53                   	push   %ebx
  801760:	e8 02 fc ff ff       	call   801367 <fd_lookup>
  801765:	83 c4 08             	add    $0x8,%esp
  801768:	85 c0                	test   %eax,%eax
  80176a:	78 37                	js     8017a3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801772:	50                   	push   %eax
  801773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801776:	ff 30                	pushl  (%eax)
  801778:	e8 40 fc ff ff       	call   8013bd <dev_lookup>
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	85 c0                	test   %eax,%eax
  801782:	78 1f                	js     8017a3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801787:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80178b:	74 1b                	je     8017a8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80178d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801790:	8b 52 18             	mov    0x18(%edx),%edx
  801793:	85 d2                	test   %edx,%edx
  801795:	74 32                	je     8017c9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801797:	83 ec 08             	sub    $0x8,%esp
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	50                   	push   %eax
  80179e:	ff d2                	call   *%edx
  8017a0:	83 c4 10             	add    $0x10,%esp
}
  8017a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017a8:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017ad:	8b 40 48             	mov    0x48(%eax),%eax
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	53                   	push   %ebx
  8017b4:	50                   	push   %eax
  8017b5:	68 4c 2f 80 00       	push   $0x802f4c
  8017ba:	e8 0a ef ff ff       	call   8006c9 <cprintf>
		return -E_INVAL;
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c7:	eb da                	jmp    8017a3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ce:	eb d3                	jmp    8017a3 <ftruncate+0x52>

008017d0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	53                   	push   %ebx
  8017d4:	83 ec 14             	sub    $0x14,%esp
  8017d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017dd:	50                   	push   %eax
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	e8 81 fb ff ff       	call   801367 <fd_lookup>
  8017e6:	83 c4 08             	add    $0x8,%esp
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	78 4b                	js     801838 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ed:	83 ec 08             	sub    $0x8,%esp
  8017f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f3:	50                   	push   %eax
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f7:	ff 30                	pushl  (%eax)
  8017f9:	e8 bf fb ff ff       	call   8013bd <dev_lookup>
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	85 c0                	test   %eax,%eax
  801803:	78 33                	js     801838 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80180c:	74 2f                	je     80183d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80180e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801811:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801818:	00 00 00 
	stat->st_isdir = 0;
  80181b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801822:	00 00 00 
	stat->st_dev = dev;
  801825:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	53                   	push   %ebx
  80182f:	ff 75 f0             	pushl  -0x10(%ebp)
  801832:	ff 50 14             	call   *0x14(%eax)
  801835:	83 c4 10             	add    $0x10,%esp
}
  801838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    
		return -E_NOT_SUPP;
  80183d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801842:	eb f4                	jmp    801838 <fstat+0x68>

00801844 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801849:	83 ec 08             	sub    $0x8,%esp
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 08             	pushl  0x8(%ebp)
  801851:	e8 e7 01 00 00       	call   801a3d <open>
  801856:	89 c3                	mov    %eax,%ebx
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 1b                	js     80187a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	50                   	push   %eax
  801866:	e8 65 ff ff ff       	call   8017d0 <fstat>
  80186b:	89 c6                	mov    %eax,%esi
	close(fd);
  80186d:	89 1c 24             	mov    %ebx,(%esp)
  801870:	e8 27 fc ff ff       	call   80149c <close>
	return r;
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	89 f3                	mov    %esi,%ebx
}
  80187a:	89 d8                	mov    %ebx,%eax
  80187c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187f:	5b                   	pop    %ebx
  801880:	5e                   	pop    %esi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	89 c6                	mov    %eax,%esi
  80188a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80188c:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801893:	74 27                	je     8018bc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801895:	6a 07                	push   $0x7
  801897:	68 00 60 80 00       	push   $0x806000
  80189c:	56                   	push   %esi
  80189d:	ff 35 10 50 80 00    	pushl  0x805010
  8018a3:	e8 56 0e 00 00       	call   8026fe <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018a8:	83 c4 0c             	add    $0xc,%esp
  8018ab:	6a 00                	push   $0x0
  8018ad:	53                   	push   %ebx
  8018ae:	6a 00                	push   $0x0
  8018b0:	e8 e2 0d 00 00       	call   802697 <ipc_recv>
}
  8018b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b8:	5b                   	pop    %ebx
  8018b9:	5e                   	pop    %esi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018bc:	83 ec 0c             	sub    $0xc,%esp
  8018bf:	6a 01                	push   $0x1
  8018c1:	e8 8c 0e 00 00       	call   802752 <ipc_find_env>
  8018c6:	a3 10 50 80 00       	mov    %eax,0x805010
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	eb c5                	jmp    801895 <fsipc+0x12>

008018d0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018dc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8018e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ee:	b8 02 00 00 00       	mov    $0x2,%eax
  8018f3:	e8 8b ff ff ff       	call   801883 <fsipc>
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <devfile_flush>:
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8b 40 0c             	mov    0xc(%eax),%eax
  801906:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80190b:	ba 00 00 00 00       	mov    $0x0,%edx
  801910:	b8 06 00 00 00       	mov    $0x6,%eax
  801915:	e8 69 ff ff ff       	call   801883 <fsipc>
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <devfile_stat>:
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	53                   	push   %ebx
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8b 40 0c             	mov    0xc(%eax),%eax
  80192c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	b8 05 00 00 00       	mov    $0x5,%eax
  80193b:	e8 43 ff ff ff       	call   801883 <fsipc>
  801940:	85 c0                	test   %eax,%eax
  801942:	78 2c                	js     801970 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	68 00 60 80 00       	push   $0x806000
  80194c:	53                   	push   %ebx
  80194d:	e8 96 f3 ff ff       	call   800ce8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801952:	a1 80 60 80 00       	mov    0x806080,%eax
  801957:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80195d:	a1 84 60 80 00       	mov    0x806084,%eax
  801962:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <devfile_write>:
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 0c             	sub    $0xc,%esp
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801983:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801988:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80198b:	8b 55 08             	mov    0x8(%ebp),%edx
  80198e:	8b 52 0c             	mov    0xc(%edx),%edx
  801991:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801997:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80199c:	50                   	push   %eax
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	68 08 60 80 00       	push   $0x806008
  8019a5:	e8 cc f4 ff ff       	call   800e76 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019af:	b8 04 00 00 00       	mov    $0x4,%eax
  8019b4:	e8 ca fe ff ff       	call   801883 <fsipc>
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <devfile_read>:
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8019ce:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8019de:	e8 a0 fe ff ff       	call   801883 <fsipc>
  8019e3:	89 c3                	mov    %eax,%ebx
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	78 1f                	js     801a08 <devfile_read+0x4d>
	assert(r <= n);
  8019e9:	39 f0                	cmp    %esi,%eax
  8019eb:	77 24                	ja     801a11 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019f2:	7f 33                	jg     801a27 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	50                   	push   %eax
  8019f8:	68 00 60 80 00       	push   $0x806000
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	e8 71 f4 ff ff       	call   800e76 <memmove>
	return r;
  801a05:	83 c4 10             	add    $0x10,%esp
}
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    
	assert(r <= n);
  801a11:	68 bc 2f 80 00       	push   $0x802fbc
  801a16:	68 c3 2f 80 00       	push   $0x802fc3
  801a1b:	6a 7b                	push   $0x7b
  801a1d:	68 d8 2f 80 00       	push   $0x802fd8
  801a22:	e8 c7 eb ff ff       	call   8005ee <_panic>
	assert(r <= PGSIZE);
  801a27:	68 e3 2f 80 00       	push   $0x802fe3
  801a2c:	68 c3 2f 80 00       	push   $0x802fc3
  801a31:	6a 7c                	push   $0x7c
  801a33:	68 d8 2f 80 00       	push   $0x802fd8
  801a38:	e8 b1 eb ff ff       	call   8005ee <_panic>

00801a3d <open>:
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 1c             	sub    $0x1c,%esp
  801a45:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a48:	56                   	push   %esi
  801a49:	e8 63 f2 ff ff       	call   800cb1 <strlen>
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a56:	7f 6c                	jg     801ac4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5e:	50                   	push   %eax
  801a5f:	e8 b4 f8 ff ff       	call   801318 <fd_alloc>
  801a64:	89 c3                	mov    %eax,%ebx
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 3c                	js     801aa9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	56                   	push   %esi
  801a71:	68 00 60 80 00       	push   $0x806000
  801a76:	e8 6d f2 ff ff       	call   800ce8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a86:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8b:	e8 f3 fd ff ff       	call   801883 <fsipc>
  801a90:	89 c3                	mov    %eax,%ebx
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 19                	js     801ab2 <open+0x75>
	return fd2num(fd);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9f:	e8 4d f8 ff ff       	call   8012f1 <fd2num>
  801aa4:	89 c3                	mov    %eax,%ebx
  801aa6:	83 c4 10             	add    $0x10,%esp
}
  801aa9:	89 d8                	mov    %ebx,%eax
  801aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5e                   	pop    %esi
  801ab0:	5d                   	pop    %ebp
  801ab1:	c3                   	ret    
		fd_close(fd, 0);
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	6a 00                	push   $0x0
  801ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aba:	e8 54 f9 ff ff       	call   801413 <fd_close>
		return r;
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	eb e5                	jmp    801aa9 <open+0x6c>
		return -E_BAD_PATH;
  801ac4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ac9:	eb de                	jmp    801aa9 <open+0x6c>

00801acb <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad6:	b8 08 00 00 00       	mov    $0x8,%eax
  801adb:	e8 a3 fd ff ff       	call   801883 <fsipc>
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ae8:	68 ef 2f 80 00       	push   $0x802fef
  801aed:	ff 75 0c             	pushl  0xc(%ebp)
  801af0:	e8 f3 f1 ff ff       	call   800ce8 <strcpy>
	return 0;
}
  801af5:	b8 00 00 00 00       	mov    $0x0,%eax
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <devsock_close>:
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	53                   	push   %ebx
  801b00:	83 ec 10             	sub    $0x10,%esp
  801b03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b06:	53                   	push   %ebx
  801b07:	e8 7f 0c 00 00       	call   80278b <pageref>
  801b0c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b0f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b14:	83 f8 01             	cmp    $0x1,%eax
  801b17:	74 07                	je     801b20 <devsock_close+0x24>
}
  801b19:	89 d0                	mov    %edx,%eax
  801b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	ff 73 0c             	pushl  0xc(%ebx)
  801b26:	e8 b7 02 00 00       	call   801de2 <nsipc_close>
  801b2b:	89 c2                	mov    %eax,%edx
  801b2d:	83 c4 10             	add    $0x10,%esp
  801b30:	eb e7                	jmp    801b19 <devsock_close+0x1d>

00801b32 <devsock_write>:
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 10             	pushl  0x10(%ebp)
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	ff 70 0c             	pushl  0xc(%eax)
  801b46:	e8 74 03 00 00       	call   801ebf <nsipc_send>
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <devsock_read>:
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	ff 75 10             	pushl  0x10(%ebp)
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	ff 70 0c             	pushl  0xc(%eax)
  801b61:	e8 ed 02 00 00       	call   801e53 <nsipc_recv>
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <fd2sockid>:
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b6e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b71:	52                   	push   %edx
  801b72:	50                   	push   %eax
  801b73:	e8 ef f7 ff ff       	call   801367 <fd_lookup>
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	78 10                	js     801b8f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b82:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  801b88:	39 08                	cmp    %ecx,(%eax)
  801b8a:	75 05                	jne    801b91 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b8c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    
		return -E_NOT_SUPP;
  801b91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b96:	eb f7                	jmp    801b8f <fd2sockid+0x27>

00801b98 <alloc_sockfd>:
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	56                   	push   %esi
  801b9c:	53                   	push   %ebx
  801b9d:	83 ec 1c             	sub    $0x1c,%esp
  801ba0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ba2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba5:	50                   	push   %eax
  801ba6:	e8 6d f7 ff ff       	call   801318 <fd_alloc>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	78 43                	js     801bf7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	68 07 04 00 00       	push   $0x407
  801bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbf:	6a 00                	push   $0x0
  801bc1:	e8 1b f5 ff ff       	call   8010e1 <sys_page_alloc>
  801bc6:	89 c3                	mov    %eax,%ebx
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	78 28                	js     801bf7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801bd8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801be4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 01 f7 ff ff       	call   8012f1 <fd2num>
  801bf0:	89 c3                	mov    %eax,%ebx
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	eb 0c                	jmp    801c03 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	56                   	push   %esi
  801bfb:	e8 e2 01 00 00       	call   801de2 <nsipc_close>
		return r;
  801c00:	83 c4 10             	add    $0x10,%esp
}
  801c03:	89 d8                	mov    %ebx,%eax
  801c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    

00801c0c <accept>:
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	e8 4e ff ff ff       	call   801b68 <fd2sockid>
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	78 1b                	js     801c39 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	e8 0e 01 00 00       	call   801d3b <nsipc_accept>
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	85 c0                	test   %eax,%eax
  801c32:	78 05                	js     801c39 <accept+0x2d>
	return alloc_sockfd(r);
  801c34:	e8 5f ff ff ff       	call   801b98 <alloc_sockfd>
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <bind>:
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	e8 1f ff ff ff       	call   801b68 <fd2sockid>
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	78 12                	js     801c5f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	ff 75 10             	pushl  0x10(%ebp)
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	50                   	push   %eax
  801c57:	e8 2f 01 00 00       	call   801d8b <nsipc_bind>
  801c5c:	83 c4 10             	add    $0x10,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <shutdown>:
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	e8 f9 fe ff ff       	call   801b68 <fd2sockid>
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	78 0f                	js     801c82 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	50                   	push   %eax
  801c7a:	e8 41 01 00 00       	call   801dc0 <nsipc_shutdown>
  801c7f:	83 c4 10             	add    $0x10,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <connect>:
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	e8 d6 fe ff ff       	call   801b68 <fd2sockid>
  801c92:	85 c0                	test   %eax,%eax
  801c94:	78 12                	js     801ca8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	ff 75 10             	pushl  0x10(%ebp)
  801c9c:	ff 75 0c             	pushl  0xc(%ebp)
  801c9f:	50                   	push   %eax
  801ca0:	e8 57 01 00 00       	call   801dfc <nsipc_connect>
  801ca5:	83 c4 10             	add    $0x10,%esp
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <listen>:
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	e8 b0 fe ff ff       	call   801b68 <fd2sockid>
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 0f                	js     801ccb <listen+0x21>
	return nsipc_listen(r, backlog);
  801cbc:	83 ec 08             	sub    $0x8,%esp
  801cbf:	ff 75 0c             	pushl  0xc(%ebp)
  801cc2:	50                   	push   %eax
  801cc3:	e8 69 01 00 00       	call   801e31 <nsipc_listen>
  801cc8:	83 c4 10             	add    $0x10,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <socket>:

int
socket(int domain, int type, int protocol)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cd3:	ff 75 10             	pushl  0x10(%ebp)
  801cd6:	ff 75 0c             	pushl  0xc(%ebp)
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	e8 3c 02 00 00       	call   801f1d <nsipc_socket>
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	78 05                	js     801ced <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ce8:	e8 ab fe ff ff       	call   801b98 <alloc_sockfd>
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	53                   	push   %ebx
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cf8:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801cff:	74 26                	je     801d27 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d01:	6a 07                	push   $0x7
  801d03:	68 00 70 80 00       	push   $0x807000
  801d08:	53                   	push   %ebx
  801d09:	ff 35 14 50 80 00    	pushl  0x805014
  801d0f:	e8 ea 09 00 00       	call   8026fe <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d14:	83 c4 0c             	add    $0xc,%esp
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	e8 75 09 00 00       	call   802697 <ipc_recv>
}
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d27:	83 ec 0c             	sub    $0xc,%esp
  801d2a:	6a 02                	push   $0x2
  801d2c:	e8 21 0a 00 00       	call   802752 <ipc_find_env>
  801d31:	a3 14 50 80 00       	mov    %eax,0x805014
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	eb c6                	jmp    801d01 <nsipc+0x12>

00801d3b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d4b:	8b 06                	mov    (%esi),%eax
  801d4d:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d52:	b8 01 00 00 00       	mov    $0x1,%eax
  801d57:	e8 93 ff ff ff       	call   801cef <nsipc>
  801d5c:	89 c3                	mov    %eax,%ebx
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 20                	js     801d82 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	ff 35 10 70 80 00    	pushl  0x807010
  801d6b:	68 00 70 80 00       	push   $0x807000
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	e8 fe f0 ff ff       	call   800e76 <memmove>
		*addrlen = ret->ret_addrlen;
  801d78:	a1 10 70 80 00       	mov    0x807010,%eax
  801d7d:	89 06                	mov    %eax,(%esi)
  801d7f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801d82:	89 d8                	mov    %ebx,%eax
  801d84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    

00801d8b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	53                   	push   %ebx
  801d8f:	83 ec 08             	sub    $0x8,%esp
  801d92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d9d:	53                   	push   %ebx
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	68 04 70 80 00       	push   $0x807004
  801da6:	e8 cb f0 ff ff       	call   800e76 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dab:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801db1:	b8 02 00 00 00       	mov    $0x2,%eax
  801db6:	e8 34 ff ff ff       	call   801cef <nsipc>
}
  801dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801dd6:	b8 03 00 00 00       	mov    $0x3,%eax
  801ddb:	e8 0f ff ff ff       	call   801cef <nsipc>
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <nsipc_close>:

int
nsipc_close(int s)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801df0:	b8 04 00 00 00       	mov    $0x4,%eax
  801df5:	e8 f5 fe ff ff       	call   801cef <nsipc>
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	53                   	push   %ebx
  801e00:	83 ec 08             	sub    $0x8,%esp
  801e03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e0e:	53                   	push   %ebx
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	68 04 70 80 00       	push   $0x807004
  801e17:	e8 5a f0 ff ff       	call   800e76 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e1c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801e22:	b8 05 00 00 00       	mov    $0x5,%eax
  801e27:	e8 c3 fe ff ff       	call   801cef <nsipc>
}
  801e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e42:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801e47:	b8 06 00 00 00       	mov    $0x6,%eax
  801e4c:	e8 9e fe ff ff       	call   801cef <nsipc>
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801e63:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801e69:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6c:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e71:	b8 07 00 00 00       	mov    $0x7,%eax
  801e76:	e8 74 fe ff ff       	call   801cef <nsipc>
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	78 1f                	js     801ea0 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e81:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e86:	7f 21                	jg     801ea9 <nsipc_recv+0x56>
  801e88:	39 c6                	cmp    %eax,%esi
  801e8a:	7c 1d                	jl     801ea9 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	50                   	push   %eax
  801e90:	68 00 70 80 00       	push   $0x807000
  801e95:	ff 75 0c             	pushl  0xc(%ebp)
  801e98:	e8 d9 ef ff ff       	call   800e76 <memmove>
  801e9d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ea0:	89 d8                	mov    %ebx,%eax
  801ea2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea5:	5b                   	pop    %ebx
  801ea6:	5e                   	pop    %esi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ea9:	68 fb 2f 80 00       	push   $0x802ffb
  801eae:	68 c3 2f 80 00       	push   $0x802fc3
  801eb3:	6a 62                	push   $0x62
  801eb5:	68 10 30 80 00       	push   $0x803010
  801eba:	e8 2f e7 ff ff       	call   8005ee <_panic>

00801ebf <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	53                   	push   %ebx
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801ed1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ed7:	7f 2e                	jg     801f07 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ed9:	83 ec 04             	sub    $0x4,%esp
  801edc:	53                   	push   %ebx
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	68 0c 70 80 00       	push   $0x80700c
  801ee5:	e8 8c ef ff ff       	call   800e76 <memmove>
	nsipcbuf.send.req_size = size;
  801eea:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801ef0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801ef8:	b8 08 00 00 00       	mov    $0x8,%eax
  801efd:	e8 ed fd ff ff       	call   801cef <nsipc>
}
  801f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    
	assert(size < 1600);
  801f07:	68 1c 30 80 00       	push   $0x80301c
  801f0c:	68 c3 2f 80 00       	push   $0x802fc3
  801f11:	6a 6d                	push   $0x6d
  801f13:	68 10 30 80 00       	push   $0x803010
  801f18:	e8 d1 e6 ff ff       	call   8005ee <_panic>

00801f1d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2e:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801f33:	8b 45 10             	mov    0x10(%ebp),%eax
  801f36:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801f3b:	b8 09 00 00 00       	mov    $0x9,%eax
  801f40:	e8 aa fd ff ff       	call   801cef <nsipc>
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <free>:
	return v;
}

void
free(void *v)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	53                   	push   %ebx
  801f4b:	83 ec 04             	sub    $0x4,%esp
  801f4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  801f51:	85 db                	test   %ebx,%ebx
  801f53:	0f 84 87 00 00 00    	je     801fe0 <free+0x99>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  801f59:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  801f5f:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  801f64:	77 51                	ja     801fb7 <free+0x70>

	c = ROUNDDOWN(v, PGSIZE);
  801f66:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  801f6c:	89 d8                	mov    %ebx,%eax
  801f6e:	c1 e8 0c             	shr    $0xc,%eax
  801f71:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f78:	f6 c4 02             	test   $0x2,%ah
  801f7b:	74 50                	je     801fcd <free+0x86>
		sys_page_unmap(0, c);
  801f7d:	83 ec 08             	sub    $0x8,%esp
  801f80:	53                   	push   %ebx
  801f81:	6a 00                	push   $0x0
  801f83:	e8 de f1 ff ff       	call   801166 <sys_page_unmap>
		c += PGSIZE;
  801f88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  801f8e:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  801f9c:	76 ce                	jbe    801f6c <free+0x25>
  801f9e:	68 65 30 80 00       	push   $0x803065
  801fa3:	68 c3 2f 80 00       	push   $0x802fc3
  801fa8:	68 81 00 00 00       	push   $0x81
  801fad:	68 58 30 80 00       	push   $0x803058
  801fb2:	e8 37 e6 ff ff       	call   8005ee <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  801fb7:	68 28 30 80 00       	push   $0x803028
  801fbc:	68 c3 2f 80 00       	push   $0x802fc3
  801fc1:	6a 7a                	push   $0x7a
  801fc3:	68 58 30 80 00       	push   $0x803058
  801fc8:	e8 21 e6 ff ff       	call   8005ee <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  801fcd:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  801fd3:	83 e8 01             	sub    $0x1,%eax
  801fd6:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	74 05                	je     801fe5 <free+0x9e>
		sys_page_unmap(0, c);
}
  801fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    
		sys_page_unmap(0, c);
  801fe5:	83 ec 08             	sub    $0x8,%esp
  801fe8:	53                   	push   %ebx
  801fe9:	6a 00                	push   $0x0
  801feb:	e8 76 f1 ff ff       	call   801166 <sys_page_unmap>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	eb eb                	jmp    801fe0 <free+0x99>

00801ff5 <malloc>:
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	57                   	push   %edi
  801ff9:	56                   	push   %esi
  801ffa:	53                   	push   %ebx
  801ffb:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  801ffe:	a1 18 50 80 00       	mov    0x805018,%eax
  802003:	85 c0                	test   %eax,%eax
  802005:	74 55                	je     80205c <malloc+0x67>
	n = ROUNDUP(n, 4);
  802007:	8b 7d 08             	mov    0x8(%ebp),%edi
  80200a:	8d 57 03             	lea    0x3(%edi),%edx
  80200d:	83 e2 fc             	and    $0xfffffffc,%edx
  802010:	89 d7                	mov    %edx,%edi
  802012:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802015:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80201b:	0f 87 a5 01 00 00    	ja     8021c6 <malloc+0x1d1>
	if ((uintptr_t) mptr % PGSIZE){
  802021:	89 c2                	mov    %eax,%edx
  802023:	a9 ff 0f 00 00       	test   $0xfff,%eax
  802028:	74 53                	je     80207d <malloc+0x88>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  80202a:	89 c3                	mov    %eax,%ebx
  80202c:	c1 eb 0c             	shr    $0xc,%ebx
  80202f:	8d 4c 38 03          	lea    0x3(%eax,%edi,1),%ecx
  802033:	c1 e9 0c             	shr    $0xc,%ecx
  802036:	39 cb                	cmp    %ecx,%ebx
  802038:	74 61                	je     80209b <malloc+0xa6>
		free(mptr);	/* drop reference to this page */
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	50                   	push   %eax
  80203e:	e8 04 ff ff ff       	call   801f47 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802043:	a1 18 50 80 00       	mov    0x805018,%eax
  802048:	05 00 10 00 00       	add    $0x1000,%eax
  80204d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802052:	a3 18 50 80 00       	mov    %eax,0x805018
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	eb 21                	jmp    80207d <malloc+0x88>
		mptr = mbegin;
  80205c:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802063:	00 00 08 
	n = ROUNDUP(n, 4);
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	83 c0 03             	add    $0x3,%eax
  80206c:	83 e0 fc             	and    $0xfffffffc,%eax
  80206f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802072:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  802077:	0f 87 42 01 00 00    	ja     8021bf <malloc+0x1ca>
  80207d:	8b 35 18 50 80 00    	mov    0x805018,%esi
{
  802083:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  80208a:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
		if (isfree(mptr, n + 4))
  80208e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802091:	8d 58 04             	lea    0x4(%eax),%ebx
  802094:	bf 01 00 00 00       	mov    $0x1,%edi
  802099:	eb 66                	jmp    802101 <malloc+0x10c>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  80209b:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  8020a1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			(*ref)++;
  8020a7:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			mptr += n;
  8020ab:	01 c7                	add    %eax,%edi
  8020ad:	89 3d 18 50 80 00    	mov    %edi,0x805018
			return v;
  8020b3:	e9 ff 00 00 00       	jmp    8021b7 <malloc+0x1c2>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8020b8:	05 00 10 00 00       	add    $0x1000,%eax
  8020bd:	39 c8                	cmp    %ecx,%eax
  8020bf:	0f 83 90 00 00 00    	jae    802155 <malloc+0x160>
		if (va >= (uintptr_t) mend
  8020c5:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  8020ca:	77 22                	ja     8020ee <malloc+0xf9>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  8020cc:	89 c2                	mov    %eax,%edx
  8020ce:	c1 ea 16             	shr    $0x16,%edx
  8020d1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8020d8:	f6 c2 01             	test   $0x1,%dl
  8020db:	74 db                	je     8020b8 <malloc+0xc3>
  8020dd:	89 c2                	mov    %eax,%edx
  8020df:	c1 ea 0c             	shr    $0xc,%edx
  8020e2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8020e9:	f6 c2 01             	test   $0x1,%dl
  8020ec:	74 ca                	je     8020b8 <malloc+0xc3>
  8020ee:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8020f4:	89 f8                	mov    %edi,%eax
  8020f6:	88 45 e7             	mov    %al,-0x19(%ebp)
		if (mptr == mend) {
  8020f9:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  8020ff:	74 0a                	je     80210b <malloc+0x116>
  802101:	89 75 e0             	mov    %esi,-0x20(%ebp)
  802104:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802107:	89 f0                	mov    %esi,%eax
  802109:	eb b2                	jmp    8020bd <malloc+0xc8>
			mptr = mbegin;
  80210b:	be 00 00 00 08       	mov    $0x8000000,%esi
  802110:	c6 45 e7 01          	movb   $0x1,-0x19(%ebp)
			if (++nwrap == 2)
  802114:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  802118:	75 e7                	jne    802101 <malloc+0x10c>
  80211a:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802121:	00 00 08 
				return 0;	/* out of address space */
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
  802129:	e9 89 00 00 00       	jmp    8021b7 <malloc+0x1c2>
				sys_page_unmap(0, mptr + i);
  80212e:	83 ec 08             	sub    $0x8,%esp
  802131:	89 f0                	mov    %esi,%eax
  802133:	03 05 18 50 80 00    	add    0x805018,%eax
  802139:	50                   	push   %eax
  80213a:	6a 00                	push   $0x0
  80213c:	e8 25 f0 ff ff       	call   801166 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  802141:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	85 f6                	test   %esi,%esi
  80214c:	79 e0                	jns    80212e <malloc+0x139>
			return 0;	/* out of physical memory */
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	eb 62                	jmp    8021b7 <malloc+0x1c2>
  802155:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
  802159:	75 3a                	jne    802195 <malloc+0x1a0>
	for (i = 0; i < n + 4; i += PGSIZE){
  80215b:	be 00 00 00 00       	mov    $0x0,%esi
  802160:	89 f2                	mov    %esi,%edx
  802162:	39 f3                	cmp    %esi,%ebx
  802164:	76 39                	jbe    80219f <malloc+0x1aa>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  802166:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  80216c:	39 df                	cmp    %ebx,%edi
  80216e:	19 c0                	sbb    %eax,%eax
  802170:	25 00 02 00 00       	and    $0x200,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	83 c8 07             	or     $0x7,%eax
  80217b:	50                   	push   %eax
  80217c:	03 15 18 50 80 00    	add    0x805018,%edx
  802182:	52                   	push   %edx
  802183:	6a 00                	push   $0x0
  802185:	e8 57 ef ff ff       	call   8010e1 <sys_page_alloc>
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	85 c0                	test   %eax,%eax
  80218f:	78 b9                	js     80214a <malloc+0x155>
	for (i = 0; i < n + 4; i += PGSIZE){
  802191:	89 fe                	mov    %edi,%esi
  802193:	eb cb                	jmp    802160 <malloc+0x16b>
  802195:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802198:	a3 18 50 80 00       	mov    %eax,0x805018
  80219d:	eb bc                	jmp    80215b <malloc+0x166>
	ref = (uint32_t*) (mptr + i - 4);
  80219f:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8021a4:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  8021ab:	00 
	mptr += n;
  8021ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021af:	01 c2                	add    %eax,%edx
  8021b1:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  8021b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ba:	5b                   	pop    %ebx
  8021bb:	5e                   	pop    %esi
  8021bc:	5f                   	pop    %edi
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    
		return 0;
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	eb f1                	jmp    8021b7 <malloc+0x1c2>
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	eb ea                	jmp    8021b7 <malloc+0x1c2>

008021cd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021d5:	83 ec 0c             	sub    $0xc,%esp
  8021d8:	ff 75 08             	pushl  0x8(%ebp)
  8021db:	e8 21 f1 ff ff       	call   801301 <fd2data>
  8021e0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021e2:	83 c4 08             	add    $0x8,%esp
  8021e5:	68 7d 30 80 00       	push   $0x80307d
  8021ea:	53                   	push   %ebx
  8021eb:	e8 f8 ea ff ff       	call   800ce8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021f0:	8b 46 04             	mov    0x4(%esi),%eax
  8021f3:	2b 06                	sub    (%esi),%eax
  8021f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802202:	00 00 00 
	stat->st_dev = &devpipe;
  802205:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  80220c:	40 80 00 
	return 0;
}
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    

0080221b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	53                   	push   %ebx
  80221f:	83 ec 0c             	sub    $0xc,%esp
  802222:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802225:	53                   	push   %ebx
  802226:	6a 00                	push   $0x0
  802228:	e8 39 ef ff ff       	call   801166 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80222d:	89 1c 24             	mov    %ebx,(%esp)
  802230:	e8 cc f0 ff ff       	call   801301 <fd2data>
  802235:	83 c4 08             	add    $0x8,%esp
  802238:	50                   	push   %eax
  802239:	6a 00                	push   $0x0
  80223b:	e8 26 ef ff ff       	call   801166 <sys_page_unmap>
}
  802240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <_pipeisclosed>:
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	57                   	push   %edi
  802249:	56                   	push   %esi
  80224a:	53                   	push   %ebx
  80224b:	83 ec 1c             	sub    $0x1c,%esp
  80224e:	89 c7                	mov    %eax,%edi
  802250:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802252:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802257:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80225a:	83 ec 0c             	sub    $0xc,%esp
  80225d:	57                   	push   %edi
  80225e:	e8 28 05 00 00       	call   80278b <pageref>
  802263:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802266:	89 34 24             	mov    %esi,(%esp)
  802269:	e8 1d 05 00 00       	call   80278b <pageref>
		nn = thisenv->env_runs;
  80226e:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  802274:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802277:	83 c4 10             	add    $0x10,%esp
  80227a:	39 cb                	cmp    %ecx,%ebx
  80227c:	74 1b                	je     802299 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80227e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802281:	75 cf                	jne    802252 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802283:	8b 42 58             	mov    0x58(%edx),%eax
  802286:	6a 01                	push   $0x1
  802288:	50                   	push   %eax
  802289:	53                   	push   %ebx
  80228a:	68 84 30 80 00       	push   $0x803084
  80228f:	e8 35 e4 ff ff       	call   8006c9 <cprintf>
  802294:	83 c4 10             	add    $0x10,%esp
  802297:	eb b9                	jmp    802252 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802299:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80229c:	0f 94 c0             	sete   %al
  80229f:	0f b6 c0             	movzbl %al,%eax
}
  8022a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a5:	5b                   	pop    %ebx
  8022a6:	5e                   	pop    %esi
  8022a7:	5f                   	pop    %edi
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    

008022aa <devpipe_write>:
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	57                   	push   %edi
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
  8022b0:	83 ec 28             	sub    $0x28,%esp
  8022b3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022b6:	56                   	push   %esi
  8022b7:	e8 45 f0 ff ff       	call   801301 <fd2data>
  8022bc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022be:	83 c4 10             	add    $0x10,%esp
  8022c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022c9:	74 4f                	je     80231a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8022ce:	8b 0b                	mov    (%ebx),%ecx
  8022d0:	8d 51 20             	lea    0x20(%ecx),%edx
  8022d3:	39 d0                	cmp    %edx,%eax
  8022d5:	72 14                	jb     8022eb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022d7:	89 da                	mov    %ebx,%edx
  8022d9:	89 f0                	mov    %esi,%eax
  8022db:	e8 65 ff ff ff       	call   802245 <_pipeisclosed>
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	75 3a                	jne    80231e <devpipe_write+0x74>
			sys_yield();
  8022e4:	e8 d9 ed ff ff       	call   8010c2 <sys_yield>
  8022e9:	eb e0                	jmp    8022cb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ee:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022f2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022f5:	89 c2                	mov    %eax,%edx
  8022f7:	c1 fa 1f             	sar    $0x1f,%edx
  8022fa:	89 d1                	mov    %edx,%ecx
  8022fc:	c1 e9 1b             	shr    $0x1b,%ecx
  8022ff:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802302:	83 e2 1f             	and    $0x1f,%edx
  802305:	29 ca                	sub    %ecx,%edx
  802307:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80230b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80230f:	83 c0 01             	add    $0x1,%eax
  802312:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802315:	83 c7 01             	add    $0x1,%edi
  802318:	eb ac                	jmp    8022c6 <devpipe_write+0x1c>
	return i;
  80231a:	89 f8                	mov    %edi,%eax
  80231c:	eb 05                	jmp    802323 <devpipe_write+0x79>
				return 0;
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802326:	5b                   	pop    %ebx
  802327:	5e                   	pop    %esi
  802328:	5f                   	pop    %edi
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    

0080232b <devpipe_read>:
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	57                   	push   %edi
  80232f:	56                   	push   %esi
  802330:	53                   	push   %ebx
  802331:	83 ec 18             	sub    $0x18,%esp
  802334:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802337:	57                   	push   %edi
  802338:	e8 c4 ef ff ff       	call   801301 <fd2data>
  80233d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80233f:	83 c4 10             	add    $0x10,%esp
  802342:	be 00 00 00 00       	mov    $0x0,%esi
  802347:	3b 75 10             	cmp    0x10(%ebp),%esi
  80234a:	74 47                	je     802393 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80234c:	8b 03                	mov    (%ebx),%eax
  80234e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802351:	75 22                	jne    802375 <devpipe_read+0x4a>
			if (i > 0)
  802353:	85 f6                	test   %esi,%esi
  802355:	75 14                	jne    80236b <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802357:	89 da                	mov    %ebx,%edx
  802359:	89 f8                	mov    %edi,%eax
  80235b:	e8 e5 fe ff ff       	call   802245 <_pipeisclosed>
  802360:	85 c0                	test   %eax,%eax
  802362:	75 33                	jne    802397 <devpipe_read+0x6c>
			sys_yield();
  802364:	e8 59 ed ff ff       	call   8010c2 <sys_yield>
  802369:	eb e1                	jmp    80234c <devpipe_read+0x21>
				return i;
  80236b:	89 f0                	mov    %esi,%eax
}
  80236d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802375:	99                   	cltd   
  802376:	c1 ea 1b             	shr    $0x1b,%edx
  802379:	01 d0                	add    %edx,%eax
  80237b:	83 e0 1f             	and    $0x1f,%eax
  80237e:	29 d0                	sub    %edx,%eax
  802380:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802385:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802388:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80238b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80238e:	83 c6 01             	add    $0x1,%esi
  802391:	eb b4                	jmp    802347 <devpipe_read+0x1c>
	return i;
  802393:	89 f0                	mov    %esi,%eax
  802395:	eb d6                	jmp    80236d <devpipe_read+0x42>
				return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
  80239c:	eb cf                	jmp    80236d <devpipe_read+0x42>

0080239e <pipe>:
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	56                   	push   %esi
  8023a2:	53                   	push   %ebx
  8023a3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023a9:	50                   	push   %eax
  8023aa:	e8 69 ef ff ff       	call   801318 <fd_alloc>
  8023af:	89 c3                	mov    %eax,%ebx
  8023b1:	83 c4 10             	add    $0x10,%esp
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	78 5b                	js     802413 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023b8:	83 ec 04             	sub    $0x4,%esp
  8023bb:	68 07 04 00 00       	push   $0x407
  8023c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c3:	6a 00                	push   $0x0
  8023c5:	e8 17 ed ff ff       	call   8010e1 <sys_page_alloc>
  8023ca:	89 c3                	mov    %eax,%ebx
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	78 40                	js     802413 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023d9:	50                   	push   %eax
  8023da:	e8 39 ef ff ff       	call   801318 <fd_alloc>
  8023df:	89 c3                	mov    %eax,%ebx
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 1b                	js     802403 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	68 07 04 00 00       	push   $0x407
  8023f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8023f3:	6a 00                	push   $0x0
  8023f5:	e8 e7 ec ff ff       	call   8010e1 <sys_page_alloc>
  8023fa:	89 c3                	mov    %eax,%ebx
  8023fc:	83 c4 10             	add    $0x10,%esp
  8023ff:	85 c0                	test   %eax,%eax
  802401:	79 19                	jns    80241c <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802403:	83 ec 08             	sub    $0x8,%esp
  802406:	ff 75 f4             	pushl  -0xc(%ebp)
  802409:	6a 00                	push   $0x0
  80240b:	e8 56 ed ff ff       	call   801166 <sys_page_unmap>
  802410:	83 c4 10             	add    $0x10,%esp
}
  802413:	89 d8                	mov    %ebx,%eax
  802415:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802418:	5b                   	pop    %ebx
  802419:	5e                   	pop    %esi
  80241a:	5d                   	pop    %ebp
  80241b:	c3                   	ret    
	va = fd2data(fd0);
  80241c:	83 ec 0c             	sub    $0xc,%esp
  80241f:	ff 75 f4             	pushl  -0xc(%ebp)
  802422:	e8 da ee ff ff       	call   801301 <fd2data>
  802427:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802429:	83 c4 0c             	add    $0xc,%esp
  80242c:	68 07 04 00 00       	push   $0x407
  802431:	50                   	push   %eax
  802432:	6a 00                	push   $0x0
  802434:	e8 a8 ec ff ff       	call   8010e1 <sys_page_alloc>
  802439:	89 c3                	mov    %eax,%ebx
  80243b:	83 c4 10             	add    $0x10,%esp
  80243e:	85 c0                	test   %eax,%eax
  802440:	0f 88 8c 00 00 00    	js     8024d2 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802446:	83 ec 0c             	sub    $0xc,%esp
  802449:	ff 75 f0             	pushl  -0x10(%ebp)
  80244c:	e8 b0 ee ff ff       	call   801301 <fd2data>
  802451:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802458:	50                   	push   %eax
  802459:	6a 00                	push   $0x0
  80245b:	56                   	push   %esi
  80245c:	6a 00                	push   $0x0
  80245e:	e8 c1 ec ff ff       	call   801124 <sys_page_map>
  802463:	89 c3                	mov    %eax,%ebx
  802465:	83 c4 20             	add    $0x20,%esp
  802468:	85 c0                	test   %eax,%eax
  80246a:	78 58                	js     8024c4 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802475:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802484:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80248a:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802496:	83 ec 0c             	sub    $0xc,%esp
  802499:	ff 75 f4             	pushl  -0xc(%ebp)
  80249c:	e8 50 ee ff ff       	call   8012f1 <fd2num>
  8024a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024a6:	83 c4 04             	add    $0x4,%esp
  8024a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ac:	e8 40 ee ff ff       	call   8012f1 <fd2num>
  8024b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024b4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024b7:	83 c4 10             	add    $0x10,%esp
  8024ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024bf:	e9 4f ff ff ff       	jmp    802413 <pipe+0x75>
	sys_page_unmap(0, va);
  8024c4:	83 ec 08             	sub    $0x8,%esp
  8024c7:	56                   	push   %esi
  8024c8:	6a 00                	push   $0x0
  8024ca:	e8 97 ec ff ff       	call   801166 <sys_page_unmap>
  8024cf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024d2:	83 ec 08             	sub    $0x8,%esp
  8024d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8024d8:	6a 00                	push   $0x0
  8024da:	e8 87 ec ff ff       	call   801166 <sys_page_unmap>
  8024df:	83 c4 10             	add    $0x10,%esp
  8024e2:	e9 1c ff ff ff       	jmp    802403 <pipe+0x65>

008024e7 <pipeisclosed>:
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f0:	50                   	push   %eax
  8024f1:	ff 75 08             	pushl  0x8(%ebp)
  8024f4:	e8 6e ee ff ff       	call   801367 <fd_lookup>
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	78 18                	js     802518 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802500:	83 ec 0c             	sub    $0xc,%esp
  802503:	ff 75 f4             	pushl  -0xc(%ebp)
  802506:	e8 f6 ed ff ff       	call   801301 <fd2data>
	return _pipeisclosed(fd, p);
  80250b:	89 c2                	mov    %eax,%edx
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	e8 30 fd ff ff       	call   802245 <_pipeisclosed>
  802515:	83 c4 10             	add    $0x10,%esp
}
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80251d:	b8 00 00 00 00       	mov    $0x0,%eax
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    

00802524 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80252a:	68 9c 30 80 00       	push   $0x80309c
  80252f:	ff 75 0c             	pushl  0xc(%ebp)
  802532:	e8 b1 e7 ff ff       	call   800ce8 <strcpy>
	return 0;
}
  802537:	b8 00 00 00 00       	mov    $0x0,%eax
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <devcons_write>:
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	53                   	push   %ebx
  802544:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80254a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80254f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802555:	eb 2f                	jmp    802586 <devcons_write+0x48>
		m = n - tot;
  802557:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80255a:	29 f3                	sub    %esi,%ebx
  80255c:	83 fb 7f             	cmp    $0x7f,%ebx
  80255f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802564:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	53                   	push   %ebx
  80256b:	89 f0                	mov    %esi,%eax
  80256d:	03 45 0c             	add    0xc(%ebp),%eax
  802570:	50                   	push   %eax
  802571:	57                   	push   %edi
  802572:	e8 ff e8 ff ff       	call   800e76 <memmove>
		sys_cputs(buf, m);
  802577:	83 c4 08             	add    $0x8,%esp
  80257a:	53                   	push   %ebx
  80257b:	57                   	push   %edi
  80257c:	e8 a4 ea ff ff       	call   801025 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802581:	01 de                	add    %ebx,%esi
  802583:	83 c4 10             	add    $0x10,%esp
  802586:	3b 75 10             	cmp    0x10(%ebp),%esi
  802589:	72 cc                	jb     802557 <devcons_write+0x19>
}
  80258b:	89 f0                	mov    %esi,%eax
  80258d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802590:	5b                   	pop    %ebx
  802591:	5e                   	pop    %esi
  802592:	5f                   	pop    %edi
  802593:	5d                   	pop    %ebp
  802594:	c3                   	ret    

00802595 <devcons_read>:
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 08             	sub    $0x8,%esp
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025a4:	75 07                	jne    8025ad <devcons_read+0x18>
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    
		sys_yield();
  8025a8:	e8 15 eb ff ff       	call   8010c2 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8025ad:	e8 91 ea ff ff       	call   801043 <sys_cgetc>
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 f2                	je     8025a8 <devcons_read+0x13>
	if (c < 0)
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	78 ec                	js     8025a6 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8025ba:	83 f8 04             	cmp    $0x4,%eax
  8025bd:	74 0c                	je     8025cb <devcons_read+0x36>
	*(char*)vbuf = c;
  8025bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c2:	88 02                	mov    %al,(%edx)
	return 1;
  8025c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c9:	eb db                	jmp    8025a6 <devcons_read+0x11>
		return 0;
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d0:	eb d4                	jmp    8025a6 <devcons_read+0x11>

008025d2 <cputchar>:
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025de:	6a 01                	push   $0x1
  8025e0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025e3:	50                   	push   %eax
  8025e4:	e8 3c ea ff ff       	call   801025 <sys_cputs>
}
  8025e9:	83 c4 10             	add    $0x10,%esp
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <getchar>:
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025f4:	6a 01                	push   $0x1
  8025f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025f9:	50                   	push   %eax
  8025fa:	6a 00                	push   $0x0
  8025fc:	e8 d7 ef ff ff       	call   8015d8 <read>
	if (r < 0)
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	85 c0                	test   %eax,%eax
  802606:	78 08                	js     802610 <getchar+0x22>
	if (r < 1)
  802608:	85 c0                	test   %eax,%eax
  80260a:	7e 06                	jle    802612 <getchar+0x24>
	return c;
  80260c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    
		return -E_EOF;
  802612:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802617:	eb f7                	jmp    802610 <getchar+0x22>

00802619 <iscons>:
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80261f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802622:	50                   	push   %eax
  802623:	ff 75 08             	pushl  0x8(%ebp)
  802626:	e8 3c ed ff ff       	call   801367 <fd_lookup>
  80262b:	83 c4 10             	add    $0x10,%esp
  80262e:	85 c0                	test   %eax,%eax
  802630:	78 11                	js     802643 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 15 78 40 80 00    	mov    0x804078,%edx
  80263b:	39 10                	cmp    %edx,(%eax)
  80263d:	0f 94 c0             	sete   %al
  802640:	0f b6 c0             	movzbl %al,%eax
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <opencons>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80264b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264e:	50                   	push   %eax
  80264f:	e8 c4 ec ff ff       	call   801318 <fd_alloc>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	78 3a                	js     802695 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 07 04 00 00       	push   $0x407
  802663:	ff 75 f4             	pushl  -0xc(%ebp)
  802666:	6a 00                	push   $0x0
  802668:	e8 74 ea ff ff       	call   8010e1 <sys_page_alloc>
  80266d:	83 c4 10             	add    $0x10,%esp
  802670:	85 c0                	test   %eax,%eax
  802672:	78 21                	js     802695 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 15 78 40 80 00    	mov    0x804078,%edx
  80267d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802689:	83 ec 0c             	sub    $0xc,%esp
  80268c:	50                   	push   %eax
  80268d:	e8 5f ec ff ff       	call   8012f1 <fd2num>
  802692:	83 c4 10             	add    $0x10,%esp
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	56                   	push   %esi
  80269b:	53                   	push   %ebx
  80269c:	8b 75 08             	mov    0x8(%ebp),%esi
  80269f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8026a5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8026a7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8026ac:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8026af:	83 ec 0c             	sub    $0xc,%esp
  8026b2:	50                   	push   %eax
  8026b3:	e8 d9 eb ff ff       	call   801291 <sys_ipc_recv>
	if (from_env_store)
  8026b8:	83 c4 10             	add    $0x10,%esp
  8026bb:	85 f6                	test   %esi,%esi
  8026bd:	74 14                	je     8026d3 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8026bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	78 09                	js     8026d1 <ipc_recv+0x3a>
  8026c8:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8026ce:	8b 52 74             	mov    0x74(%edx),%edx
  8026d1:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8026d3:	85 db                	test   %ebx,%ebx
  8026d5:	74 14                	je     8026eb <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8026d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	78 09                	js     8026e9 <ipc_recv+0x52>
  8026e0:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8026e6:	8b 52 78             	mov    0x78(%edx),%edx
  8026e9:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	78 08                	js     8026f7 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8026ef:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8026f4:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8026f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026fa:	5b                   	pop    %ebx
  8026fb:	5e                   	pop    %esi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    

008026fe <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	57                   	push   %edi
  802702:	56                   	push   %esi
  802703:	53                   	push   %ebx
  802704:	83 ec 0c             	sub    $0xc,%esp
  802707:	8b 7d 08             	mov    0x8(%ebp),%edi
  80270a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80270d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802710:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802712:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802717:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80271a:	ff 75 14             	pushl  0x14(%ebp)
  80271d:	53                   	push   %ebx
  80271e:	56                   	push   %esi
  80271f:	57                   	push   %edi
  802720:	e8 49 eb ff ff       	call   80126e <sys_ipc_try_send>
		if (ret == 0)
  802725:	83 c4 10             	add    $0x10,%esp
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 1e                	je     80274a <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80272c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80272f:	75 07                	jne    802738 <ipc_send+0x3a>
			sys_yield();
  802731:	e8 8c e9 ff ff       	call   8010c2 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802736:	eb e2                	jmp    80271a <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802738:	50                   	push   %eax
  802739:	68 a8 30 80 00       	push   $0x8030a8
  80273e:	6a 3d                	push   $0x3d
  802740:	68 bc 30 80 00       	push   $0x8030bc
  802745:	e8 a4 de ff ff       	call   8005ee <_panic>
	}
	// panic("ipc_send not implemented");
}
  80274a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80274d:	5b                   	pop    %ebx
  80274e:	5e                   	pop    %esi
  80274f:	5f                   	pop    %edi
  802750:	5d                   	pop    %ebp
  802751:	c3                   	ret    

00802752 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
  802755:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802758:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80275d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802760:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802766:	8b 52 50             	mov    0x50(%edx),%edx
  802769:	39 ca                	cmp    %ecx,%edx
  80276b:	74 11                	je     80277e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80276d:	83 c0 01             	add    $0x1,%eax
  802770:	3d 00 04 00 00       	cmp    $0x400,%eax
  802775:	75 e6                	jne    80275d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
  80277c:	eb 0b                	jmp    802789 <ipc_find_env+0x37>
			return envs[i].env_id;
  80277e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802781:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802786:	8b 40 48             	mov    0x48(%eax),%eax
}
  802789:	5d                   	pop    %ebp
  80278a:	c3                   	ret    

0080278b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802791:	89 d0                	mov    %edx,%eax
  802793:	c1 e8 16             	shr    $0x16,%eax
  802796:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8027a2:	f6 c1 01             	test   $0x1,%cl
  8027a5:	74 1d                	je     8027c4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8027a7:	c1 ea 0c             	shr    $0xc,%edx
  8027aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027b1:	f6 c2 01             	test   $0x1,%dl
  8027b4:	74 0e                	je     8027c4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027b6:	c1 ea 0c             	shr    $0xc,%edx
  8027b9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027c0:	ef 
  8027c1:	0f b7 c0             	movzwl %ax,%eax
}
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
  8027c6:	66 90                	xchg   %ax,%ax
  8027c8:	66 90                	xchg   %ax,%ax
  8027ca:	66 90                	xchg   %ax,%ax
  8027cc:	66 90                	xchg   %ax,%ax
  8027ce:	66 90                	xchg   %ax,%ax

008027d0 <__udivdi3>:
  8027d0:	55                   	push   %ebp
  8027d1:	57                   	push   %edi
  8027d2:	56                   	push   %esi
  8027d3:	53                   	push   %ebx
  8027d4:	83 ec 1c             	sub    $0x1c,%esp
  8027d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027e7:	85 d2                	test   %edx,%edx
  8027e9:	75 35                	jne    802820 <__udivdi3+0x50>
  8027eb:	39 f3                	cmp    %esi,%ebx
  8027ed:	0f 87 bd 00 00 00    	ja     8028b0 <__udivdi3+0xe0>
  8027f3:	85 db                	test   %ebx,%ebx
  8027f5:	89 d9                	mov    %ebx,%ecx
  8027f7:	75 0b                	jne    802804 <__udivdi3+0x34>
  8027f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027fe:	31 d2                	xor    %edx,%edx
  802800:	f7 f3                	div    %ebx
  802802:	89 c1                	mov    %eax,%ecx
  802804:	31 d2                	xor    %edx,%edx
  802806:	89 f0                	mov    %esi,%eax
  802808:	f7 f1                	div    %ecx
  80280a:	89 c6                	mov    %eax,%esi
  80280c:	89 e8                	mov    %ebp,%eax
  80280e:	89 f7                	mov    %esi,%edi
  802810:	f7 f1                	div    %ecx
  802812:	89 fa                	mov    %edi,%edx
  802814:	83 c4 1c             	add    $0x1c,%esp
  802817:	5b                   	pop    %ebx
  802818:	5e                   	pop    %esi
  802819:	5f                   	pop    %edi
  80281a:	5d                   	pop    %ebp
  80281b:	c3                   	ret    
  80281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802820:	39 f2                	cmp    %esi,%edx
  802822:	77 7c                	ja     8028a0 <__udivdi3+0xd0>
  802824:	0f bd fa             	bsr    %edx,%edi
  802827:	83 f7 1f             	xor    $0x1f,%edi
  80282a:	0f 84 98 00 00 00    	je     8028c8 <__udivdi3+0xf8>
  802830:	89 f9                	mov    %edi,%ecx
  802832:	b8 20 00 00 00       	mov    $0x20,%eax
  802837:	29 f8                	sub    %edi,%eax
  802839:	d3 e2                	shl    %cl,%edx
  80283b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80283f:	89 c1                	mov    %eax,%ecx
  802841:	89 da                	mov    %ebx,%edx
  802843:	d3 ea                	shr    %cl,%edx
  802845:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802849:	09 d1                	or     %edx,%ecx
  80284b:	89 f2                	mov    %esi,%edx
  80284d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802851:	89 f9                	mov    %edi,%ecx
  802853:	d3 e3                	shl    %cl,%ebx
  802855:	89 c1                	mov    %eax,%ecx
  802857:	d3 ea                	shr    %cl,%edx
  802859:	89 f9                	mov    %edi,%ecx
  80285b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80285f:	d3 e6                	shl    %cl,%esi
  802861:	89 eb                	mov    %ebp,%ebx
  802863:	89 c1                	mov    %eax,%ecx
  802865:	d3 eb                	shr    %cl,%ebx
  802867:	09 de                	or     %ebx,%esi
  802869:	89 f0                	mov    %esi,%eax
  80286b:	f7 74 24 08          	divl   0x8(%esp)
  80286f:	89 d6                	mov    %edx,%esi
  802871:	89 c3                	mov    %eax,%ebx
  802873:	f7 64 24 0c          	mull   0xc(%esp)
  802877:	39 d6                	cmp    %edx,%esi
  802879:	72 0c                	jb     802887 <__udivdi3+0xb7>
  80287b:	89 f9                	mov    %edi,%ecx
  80287d:	d3 e5                	shl    %cl,%ebp
  80287f:	39 c5                	cmp    %eax,%ebp
  802881:	73 5d                	jae    8028e0 <__udivdi3+0x110>
  802883:	39 d6                	cmp    %edx,%esi
  802885:	75 59                	jne    8028e0 <__udivdi3+0x110>
  802887:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80288a:	31 ff                	xor    %edi,%edi
  80288c:	89 fa                	mov    %edi,%edx
  80288e:	83 c4 1c             	add    $0x1c,%esp
  802891:	5b                   	pop    %ebx
  802892:	5e                   	pop    %esi
  802893:	5f                   	pop    %edi
  802894:	5d                   	pop    %ebp
  802895:	c3                   	ret    
  802896:	8d 76 00             	lea    0x0(%esi),%esi
  802899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8028a0:	31 ff                	xor    %edi,%edi
  8028a2:	31 c0                	xor    %eax,%eax
  8028a4:	89 fa                	mov    %edi,%edx
  8028a6:	83 c4 1c             	add    $0x1c,%esp
  8028a9:	5b                   	pop    %ebx
  8028aa:	5e                   	pop    %esi
  8028ab:	5f                   	pop    %edi
  8028ac:	5d                   	pop    %ebp
  8028ad:	c3                   	ret    
  8028ae:	66 90                	xchg   %ax,%ax
  8028b0:	31 ff                	xor    %edi,%edi
  8028b2:	89 e8                	mov    %ebp,%eax
  8028b4:	89 f2                	mov    %esi,%edx
  8028b6:	f7 f3                	div    %ebx
  8028b8:	89 fa                	mov    %edi,%edx
  8028ba:	83 c4 1c             	add    $0x1c,%esp
  8028bd:	5b                   	pop    %ebx
  8028be:	5e                   	pop    %esi
  8028bf:	5f                   	pop    %edi
  8028c0:	5d                   	pop    %ebp
  8028c1:	c3                   	ret    
  8028c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028c8:	39 f2                	cmp    %esi,%edx
  8028ca:	72 06                	jb     8028d2 <__udivdi3+0x102>
  8028cc:	31 c0                	xor    %eax,%eax
  8028ce:	39 eb                	cmp    %ebp,%ebx
  8028d0:	77 d2                	ja     8028a4 <__udivdi3+0xd4>
  8028d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d7:	eb cb                	jmp    8028a4 <__udivdi3+0xd4>
  8028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028e0:	89 d8                	mov    %ebx,%eax
  8028e2:	31 ff                	xor    %edi,%edi
  8028e4:	eb be                	jmp    8028a4 <__udivdi3+0xd4>
  8028e6:	66 90                	xchg   %ax,%ax
  8028e8:	66 90                	xchg   %ax,%ax
  8028ea:	66 90                	xchg   %ax,%ax
  8028ec:	66 90                	xchg   %ax,%ax
  8028ee:	66 90                	xchg   %ax,%ax

008028f0 <__umoddi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	83 ec 1c             	sub    $0x1c,%esp
  8028f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8028fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802903:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802907:	85 ed                	test   %ebp,%ebp
  802909:	89 f0                	mov    %esi,%eax
  80290b:	89 da                	mov    %ebx,%edx
  80290d:	75 19                	jne    802928 <__umoddi3+0x38>
  80290f:	39 df                	cmp    %ebx,%edi
  802911:	0f 86 b1 00 00 00    	jbe    8029c8 <__umoddi3+0xd8>
  802917:	f7 f7                	div    %edi
  802919:	89 d0                	mov    %edx,%eax
  80291b:	31 d2                	xor    %edx,%edx
  80291d:	83 c4 1c             	add    $0x1c,%esp
  802920:	5b                   	pop    %ebx
  802921:	5e                   	pop    %esi
  802922:	5f                   	pop    %edi
  802923:	5d                   	pop    %ebp
  802924:	c3                   	ret    
  802925:	8d 76 00             	lea    0x0(%esi),%esi
  802928:	39 dd                	cmp    %ebx,%ebp
  80292a:	77 f1                	ja     80291d <__umoddi3+0x2d>
  80292c:	0f bd cd             	bsr    %ebp,%ecx
  80292f:	83 f1 1f             	xor    $0x1f,%ecx
  802932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802936:	0f 84 b4 00 00 00    	je     8029f0 <__umoddi3+0x100>
  80293c:	b8 20 00 00 00       	mov    $0x20,%eax
  802941:	89 c2                	mov    %eax,%edx
  802943:	8b 44 24 04          	mov    0x4(%esp),%eax
  802947:	29 c2                	sub    %eax,%edx
  802949:	89 c1                	mov    %eax,%ecx
  80294b:	89 f8                	mov    %edi,%eax
  80294d:	d3 e5                	shl    %cl,%ebp
  80294f:	89 d1                	mov    %edx,%ecx
  802951:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802955:	d3 e8                	shr    %cl,%eax
  802957:	09 c5                	or     %eax,%ebp
  802959:	8b 44 24 04          	mov    0x4(%esp),%eax
  80295d:	89 c1                	mov    %eax,%ecx
  80295f:	d3 e7                	shl    %cl,%edi
  802961:	89 d1                	mov    %edx,%ecx
  802963:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802967:	89 df                	mov    %ebx,%edi
  802969:	d3 ef                	shr    %cl,%edi
  80296b:	89 c1                	mov    %eax,%ecx
  80296d:	89 f0                	mov    %esi,%eax
  80296f:	d3 e3                	shl    %cl,%ebx
  802971:	89 d1                	mov    %edx,%ecx
  802973:	89 fa                	mov    %edi,%edx
  802975:	d3 e8                	shr    %cl,%eax
  802977:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80297c:	09 d8                	or     %ebx,%eax
  80297e:	f7 f5                	div    %ebp
  802980:	d3 e6                	shl    %cl,%esi
  802982:	89 d1                	mov    %edx,%ecx
  802984:	f7 64 24 08          	mull   0x8(%esp)
  802988:	39 d1                	cmp    %edx,%ecx
  80298a:	89 c3                	mov    %eax,%ebx
  80298c:	89 d7                	mov    %edx,%edi
  80298e:	72 06                	jb     802996 <__umoddi3+0xa6>
  802990:	75 0e                	jne    8029a0 <__umoddi3+0xb0>
  802992:	39 c6                	cmp    %eax,%esi
  802994:	73 0a                	jae    8029a0 <__umoddi3+0xb0>
  802996:	2b 44 24 08          	sub    0x8(%esp),%eax
  80299a:	19 ea                	sbb    %ebp,%edx
  80299c:	89 d7                	mov    %edx,%edi
  80299e:	89 c3                	mov    %eax,%ebx
  8029a0:	89 ca                	mov    %ecx,%edx
  8029a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8029a7:	29 de                	sub    %ebx,%esi
  8029a9:	19 fa                	sbb    %edi,%edx
  8029ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8029af:	89 d0                	mov    %edx,%eax
  8029b1:	d3 e0                	shl    %cl,%eax
  8029b3:	89 d9                	mov    %ebx,%ecx
  8029b5:	d3 ee                	shr    %cl,%esi
  8029b7:	d3 ea                	shr    %cl,%edx
  8029b9:	09 f0                	or     %esi,%eax
  8029bb:	83 c4 1c             	add    $0x1c,%esp
  8029be:	5b                   	pop    %ebx
  8029bf:	5e                   	pop    %esi
  8029c0:	5f                   	pop    %edi
  8029c1:	5d                   	pop    %ebp
  8029c2:	c3                   	ret    
  8029c3:	90                   	nop
  8029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	85 ff                	test   %edi,%edi
  8029ca:	89 f9                	mov    %edi,%ecx
  8029cc:	75 0b                	jne    8029d9 <__umoddi3+0xe9>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	31 d2                	xor    %edx,%edx
  8029d5:	f7 f7                	div    %edi
  8029d7:	89 c1                	mov    %eax,%ecx
  8029d9:	89 d8                	mov    %ebx,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	f7 f1                	div    %ecx
  8029df:	89 f0                	mov    %esi,%eax
  8029e1:	f7 f1                	div    %ecx
  8029e3:	e9 31 ff ff ff       	jmp    802919 <__umoddi3+0x29>
  8029e8:	90                   	nop
  8029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	39 dd                	cmp    %ebx,%ebp
  8029f2:	72 08                	jb     8029fc <__umoddi3+0x10c>
  8029f4:	39 f7                	cmp    %esi,%edi
  8029f6:	0f 87 21 ff ff ff    	ja     80291d <__umoddi3+0x2d>
  8029fc:	89 da                	mov    %ebx,%edx
  8029fe:	89 f0                	mov    %esi,%eax
  802a00:	29 f8                	sub    %edi,%eax
  802a02:	19 ea                	sbb    %ebp,%edx
  802a04:	e9 14 ff ff ff       	jmp    80291d <__umoddi3+0x2d>

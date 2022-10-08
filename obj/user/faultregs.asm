
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 ae 05 00 00       	call   8005df <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 91 28 80 00       	push   $0x802891
  800049:	68 60 28 80 00       	push   $0x802860
  80004e:	e8 c7 06 00 00       	call   80071a <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 70 28 80 00       	push   $0x802870
  80005c:	68 74 28 80 00       	push   $0x802874
  800061:	e8 b4 06 00 00       	call   80071a <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 31 02 00 00    	je     8002a4 <check_regs+0x271>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 88 28 80 00       	push   $0x802888
  80007b:	e8 9a 06 00 00       	call   80071a <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 92 28 80 00       	push   $0x802892
  800093:	68 74 28 80 00       	push   $0x802874
  800098:	e8 7d 06 00 00       	call   80071a <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 12 02 00 00    	je     8002be <check_regs+0x28b>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 88 28 80 00       	push   $0x802888
  8000b4:	e8 61 06 00 00       	call   80071a <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 96 28 80 00       	push   $0x802896
  8000cc:	68 74 28 80 00       	push   $0x802874
  8000d1:	e8 44 06 00 00       	call   80071a <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 ee 01 00 00    	je     8002d3 <check_regs+0x2a0>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 88 28 80 00       	push   $0x802888
  8000ed:	e8 28 06 00 00       	call   80071a <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 9a 28 80 00       	push   $0x80289a
  800105:	68 74 28 80 00       	push   $0x802874
  80010a:	e8 0b 06 00 00       	call   80071a <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 ca 01 00 00    	je     8002e8 <check_regs+0x2b5>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 88 28 80 00       	push   $0x802888
  800126:	e8 ef 05 00 00       	call   80071a <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 9e 28 80 00       	push   $0x80289e
  80013e:	68 74 28 80 00       	push   $0x802874
  800143:	e8 d2 05 00 00       	call   80071a <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a6 01 00 00    	je     8002fd <check_regs+0x2ca>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 88 28 80 00       	push   $0x802888
  80015f:	e8 b6 05 00 00       	call   80071a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 a2 28 80 00       	push   $0x8028a2
  800177:	68 74 28 80 00       	push   $0x802874
  80017c:	e8 99 05 00 00       	call   80071a <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 82 01 00 00    	je     800312 <check_regs+0x2df>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 88 28 80 00       	push   $0x802888
  800198:	e8 7d 05 00 00       	call   80071a <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 a6 28 80 00       	push   $0x8028a6
  8001b0:	68 74 28 80 00       	push   $0x802874
  8001b5:	e8 60 05 00 00       	call   80071a <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5e 01 00 00    	je     800327 <check_regs+0x2f4>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 88 28 80 00       	push   $0x802888
  8001d1:	e8 44 05 00 00       	call   80071a <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 aa 28 80 00       	push   $0x8028aa
  8001e9:	68 74 28 80 00       	push   $0x802874
  8001ee:	e8 27 05 00 00       	call   80071a <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 3a 01 00 00    	je     80033c <check_regs+0x309>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 88 28 80 00       	push   $0x802888
  80020a:	e8 0b 05 00 00       	call   80071a <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ae 28 80 00       	push   $0x8028ae
  800222:	68 74 28 80 00       	push   $0x802874
  800227:	e8 ee 04 00 00       	call   80071a <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 16 01 00 00    	je     800351 <check_regs+0x31e>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 88 28 80 00       	push   $0x802888
  800243:	e8 d2 04 00 00       	call   80071a <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 b5 28 80 00       	push   $0x8028b5
  800253:	68 74 28 80 00       	push   $0x802874
  800258:	e8 bd 04 00 00       	call   80071a <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 88 28 80 00       	push   $0x802888
  800274:	e8 a1 04 00 00       	call   80071a <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 b9 28 80 00       	push   $0x8028b9
  800284:	e8 91 04 00 00       	call   80071a <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 88 28 80 00       	push   $0x802888
  800294:	e8 81 04 00 00       	call   80071a <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
	CHECK(edi, regs.reg_edi);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 84 28 80 00       	push   $0x802884
  8002ac:	e8 69 04 00 00       	call   80071a <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b9:	e9 ca fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 84 28 80 00       	push   $0x802884
  8002c6:	e8 4f 04 00 00       	call   80071a <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	e9 ee fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	68 84 28 80 00       	push   $0x802884
  8002db:	e8 3a 04 00 00       	call   80071a <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	e9 12 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	68 84 28 80 00       	push   $0x802884
  8002f0:	e8 25 04 00 00       	call   80071a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	e9 36 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	68 84 28 80 00       	push   $0x802884
  800305:	e8 10 04 00 00       	call   80071a <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	e9 5a fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	68 84 28 80 00       	push   $0x802884
  80031a:	e8 fb 03 00 00       	call   80071a <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	e9 7e fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	68 84 28 80 00       	push   $0x802884
  80032f:	e8 e6 03 00 00       	call   80071a <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	e9 a2 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 84 28 80 00       	push   $0x802884
  800344:	e8 d1 03 00 00       	call   80071a <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 c6 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	68 84 28 80 00       	push   $0x802884
  800359:	e8 bc 03 00 00       	call   80071a <cprintf>
	CHECK(esp, esp);
  80035e:	ff 73 28             	pushl  0x28(%ebx)
  800361:	ff 76 28             	pushl  0x28(%esi)
  800364:	68 b5 28 80 00       	push   $0x8028b5
  800369:	68 74 28 80 00       	push   $0x802874
  80036e:	e8 a7 03 00 00       	call   80071a <cprintf>
  800373:	83 c4 20             	add    $0x20,%esp
  800376:	8b 43 28             	mov    0x28(%ebx),%eax
  800379:	39 46 28             	cmp    %eax,0x28(%esi)
  80037c:	0f 85 ea fe ff ff    	jne    80026c <check_regs+0x239>
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 84 28 80 00       	push   $0x802884
  80038a:	e8 8b 03 00 00       	call   80071a <cprintf>
	cprintf("Registers %s ", testname);
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	ff 75 0c             	pushl  0xc(%ebp)
  800395:	68 b9 28 80 00       	push   $0x8028b9
  80039a:	e8 7b 03 00 00       	call   80071a <cprintf>
	if (!mismatch)
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	85 ff                	test   %edi,%edi
  8003a4:	0f 85 e2 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 84 28 80 00       	push   $0x802884
  8003b2:	e8 63 03 00 00       	call   80071a <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	e9 dd fe ff ff       	jmp    80029c <check_regs+0x269>
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 84 28 80 00       	push   $0x802884
  8003c7:	e8 4e 03 00 00       	call   80071a <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 b9 28 80 00       	push   $0x8028b9
  8003d7:	e8 3e 03 00 00       	call   80071a <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 40 40 80 00    	mov    %edx,0x804040
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 44 40 80 00    	mov    %edx,0x804044
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 48 40 80 00    	mov    %edx,0x804048
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 50 40 80 00    	mov    %edx,0x804050
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 54 40 80 00    	mov    %edx,0x804054
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 58 40 80 00    	mov    %edx,0x804058
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 df 28 80 00       	push   $0x8028df
  80046b:	68 ed 28 80 00       	push   $0x8028ed
  800470:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800475:	ba d8 28 80 00       	mov    $0x8028d8,%edx
  80047a:	b8 80 40 80 00       	mov    $0x804080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 9d 0c 00 00       	call   801132 <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 20 29 80 00       	push   $0x802920
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 c7 28 80 00       	push   $0x8028c7
  8004b1:	e8 89 01 00 00       	call   80063f <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 f4 28 80 00       	push   $0x8028f4
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 c7 28 80 00       	push   $0x8028c7
  8004c3:	e8 77 01 00 00       	call   80063f <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 6a 0e 00 00       	call   801342 <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d 80 40 80 00    	mov    %edi,0x804080
  8004f9:	89 35 84 40 80 00    	mov    %esi,0x804084
  8004ff:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  800505:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  80050b:	89 15 94 40 80 00    	mov    %edx,0x804094
  800511:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  800517:	a3 9c 40 80 00       	mov    %eax,0x80409c
  80051c:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 00 40 80 00    	mov    %edi,0x804000
  800532:	89 35 04 40 80 00    	mov    %esi,0x804004
  800538:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  80053e:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  800544:	89 15 14 40 80 00    	mov    %edx,0x804014
  80054a:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800550:	a3 1c 40 80 00       	mov    %eax,0x80401c
  800555:	89 25 28 40 80 00    	mov    %esp,0x804028
  80055b:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800561:	8b 35 84 40 80 00    	mov    0x804084,%esi
  800567:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  80056d:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  800573:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800579:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  80057f:	a1 9c 40 80 00       	mov    0x80409c,%eax
  800584:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 24 40 80 00       	mov    %eax,0x804024
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	74 10                	je     8005af <umain+0xe7>
		cprintf("EIP after page-fault MISMATCH\n");
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	68 54 29 80 00       	push   $0x802954
  8005a7:	e8 6e 01 00 00       	call   80071a <cprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
	after.eip = before.eip;
  8005af:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  8005b4:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	68 07 29 80 00       	push   $0x802907
  8005c1:	68 18 29 80 00       	push   $0x802918
  8005c6:	b9 00 40 80 00       	mov    $0x804000,%ecx
  8005cb:	ba d8 28 80 00       	mov    $0x8028d8,%edx
  8005d0:	b8 80 40 80 00       	mov    $0x804080,%eax
  8005d5:	e8 59 fa ff ff       	call   800033 <check_regs>
}
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	56                   	push   %esi
  8005e3:	53                   	push   %ebx
  8005e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005ea:	e8 05 0b 00 00       	call   8010f4 <sys_getenvid>
  8005ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005fc:	a3 b4 40 80 00       	mov    %eax,0x8040b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800601:	85 db                	test   %ebx,%ebx
  800603:	7e 07                	jle    80060c <libmain+0x2d>
		binaryname = argv[0];
  800605:	8b 06                	mov    (%esi),%eax
  800607:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	e8 b2 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800616:	e8 0a 00 00 00       	call   800625 <exit>
}
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800621:	5b                   	pop    %ebx
  800622:	5e                   	pop    %esi
  800623:	5d                   	pop    %ebp
  800624:	c3                   	ret    

00800625 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800625:	55                   	push   %ebp
  800626:	89 e5                	mov    %esp,%ebp
  800628:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80062b:	e8 73 0f 00 00       	call   8015a3 <close_all>
	sys_env_destroy(0);
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	6a 00                	push   $0x0
  800635:	e8 79 0a 00 00       	call   8010b3 <sys_env_destroy>
}
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	56                   	push   %esi
  800643:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800644:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800647:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80064d:	e8 a2 0a 00 00       	call   8010f4 <sys_getenvid>
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	ff 75 08             	pushl  0x8(%ebp)
  80065b:	56                   	push   %esi
  80065c:	50                   	push   %eax
  80065d:	68 80 29 80 00       	push   $0x802980
  800662:	e8 b3 00 00 00       	call   80071a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800667:	83 c4 18             	add    $0x18,%esp
  80066a:	53                   	push   %ebx
  80066b:	ff 75 10             	pushl  0x10(%ebp)
  80066e:	e8 56 00 00 00       	call   8006c9 <vcprintf>
	cprintf("\n");
  800673:	c7 04 24 90 28 80 00 	movl   $0x802890,(%esp)
  80067a:	e8 9b 00 00 00       	call   80071a <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800682:	cc                   	int3   
  800683:	eb fd                	jmp    800682 <_panic+0x43>

00800685 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	53                   	push   %ebx
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80068f:	8b 13                	mov    (%ebx),%edx
  800691:	8d 42 01             	lea    0x1(%edx),%eax
  800694:	89 03                	mov    %eax,(%ebx)
  800696:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800699:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	74 09                	je     8006ad <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ab:	c9                   	leave  
  8006ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	68 ff 00 00 00       	push   $0xff
  8006b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b8:	50                   	push   %eax
  8006b9:	e8 b8 09 00 00       	call   801076 <sys_cputs>
		b->idx = 0;
  8006be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	eb db                	jmp    8006a4 <putch+0x1f>

008006c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d9:	00 00 00 
	b.cnt = 0;
  8006dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	68 85 06 80 00       	push   $0x800685
  8006f8:	e8 1a 01 00 00       	call   800817 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006fd:	83 c4 08             	add    $0x8,%esp
  800700:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800706:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	e8 64 09 00 00       	call   801076 <sys_cputs>

	return b.cnt;
}
  800712:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800720:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800723:	50                   	push   %eax
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	e8 9d ff ff ff       	call   8006c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	57                   	push   %edi
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 1c             	sub    $0x1c,%esp
  800737:	89 c7                	mov    %eax,%edi
  800739:	89 d6                	mov    %edx,%esi
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800747:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80074a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80074f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800752:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800755:	39 d3                	cmp    %edx,%ebx
  800757:	72 05                	jb     80075e <printnum+0x30>
  800759:	39 45 10             	cmp    %eax,0x10(%ebp)
  80075c:	77 7a                	ja     8007d8 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075e:	83 ec 0c             	sub    $0xc,%esp
  800761:	ff 75 18             	pushl  0x18(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80076a:	53                   	push   %ebx
  80076b:	ff 75 10             	pushl  0x10(%ebp)
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 e4             	pushl  -0x1c(%ebp)
  800774:	ff 75 e0             	pushl  -0x20(%ebp)
  800777:	ff 75 dc             	pushl  -0x24(%ebp)
  80077a:	ff 75 d8             	pushl  -0x28(%ebp)
  80077d:	e8 9e 1e 00 00       	call   802620 <__udivdi3>
  800782:	83 c4 18             	add    $0x18,%esp
  800785:	52                   	push   %edx
  800786:	50                   	push   %eax
  800787:	89 f2                	mov    %esi,%edx
  800789:	89 f8                	mov    %edi,%eax
  80078b:	e8 9e ff ff ff       	call   80072e <printnum>
  800790:	83 c4 20             	add    $0x20,%esp
  800793:	eb 13                	jmp    8007a8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	56                   	push   %esi
  800799:	ff 75 18             	pushl  0x18(%ebp)
  80079c:	ff d7                	call   *%edi
  80079e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8007a1:	83 eb 01             	sub    $0x1,%ebx
  8007a4:	85 db                	test   %ebx,%ebx
  8007a6:	7f ed                	jg     800795 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	56                   	push   %esi
  8007ac:	83 ec 04             	sub    $0x4,%esp
  8007af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007bb:	e8 80 1f 00 00       	call   802740 <__umoddi3>
  8007c0:	83 c4 14             	add    $0x14,%esp
  8007c3:	0f be 80 a3 29 80 00 	movsbl 0x8029a3(%eax),%eax
  8007ca:	50                   	push   %eax
  8007cb:	ff d7                	call   *%edi
}
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d3:	5b                   	pop    %ebx
  8007d4:	5e                   	pop    %esi
  8007d5:	5f                   	pop    %edi
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    
  8007d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007db:	eb c4                	jmp    8007a1 <printnum+0x73>

008007dd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007e3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007e7:	8b 10                	mov    (%eax),%edx
  8007e9:	3b 50 04             	cmp    0x4(%eax),%edx
  8007ec:	73 0a                	jae    8007f8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007f1:	89 08                	mov    %ecx,(%eax)
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	88 02                	mov    %al,(%edx)
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <printfmt>:
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800803:	50                   	push   %eax
  800804:	ff 75 10             	pushl  0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 05 00 00 00       	call   800817 <vprintfmt>
}
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <vprintfmt>:
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	57                   	push   %edi
  80081b:	56                   	push   %esi
  80081c:	53                   	push   %ebx
  80081d:	83 ec 2c             	sub    $0x2c,%esp
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800826:	8b 7d 10             	mov    0x10(%ebp),%edi
  800829:	e9 c1 03 00 00       	jmp    800bef <vprintfmt+0x3d8>
		padc = ' ';
  80082e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800832:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800839:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800840:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800847:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8d 47 01             	lea    0x1(%edi),%eax
  80084f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800852:	0f b6 17             	movzbl (%edi),%edx
  800855:	8d 42 dd             	lea    -0x23(%edx),%eax
  800858:	3c 55                	cmp    $0x55,%al
  80085a:	0f 87 12 04 00 00    	ja     800c72 <vprintfmt+0x45b>
  800860:	0f b6 c0             	movzbl %al,%eax
  800863:	ff 24 85 e0 2a 80 00 	jmp    *0x802ae0(,%eax,4)
  80086a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80086d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800871:	eb d9                	jmp    80084c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800873:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800876:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80087a:	eb d0                	jmp    80084c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80087c:	0f b6 d2             	movzbl %dl,%edx
  80087f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
  800887:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80088a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80088d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800891:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800894:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800897:	83 f9 09             	cmp    $0x9,%ecx
  80089a:	77 55                	ja     8008f1 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80089c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80089f:	eb e9                	jmp    80088a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8d 40 04             	lea    0x4(%eax),%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b9:	79 91                	jns    80084c <vprintfmt+0x35>
				width = precision, precision = -1;
  8008bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8008c8:	eb 82                	jmp    80084c <vprintfmt+0x35>
  8008ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	0f 49 d0             	cmovns %eax,%edx
  8008d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008dd:	e9 6a ff ff ff       	jmp    80084c <vprintfmt+0x35>
  8008e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8008ec:	e9 5b ff ff ff       	jmp    80084c <vprintfmt+0x35>
  8008f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008f7:	eb bc                	jmp    8008b5 <vprintfmt+0x9e>
			lflag++;
  8008f9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008ff:	e9 48 ff ff ff       	jmp    80084c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8d 78 04             	lea    0x4(%eax),%edi
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	53                   	push   %ebx
  80090e:	ff 30                	pushl  (%eax)
  800910:	ff d6                	call   *%esi
			break;
  800912:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800915:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800918:	e9 cf 02 00 00       	jmp    800bec <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8d 78 04             	lea    0x4(%eax),%edi
  800923:	8b 00                	mov    (%eax),%eax
  800925:	99                   	cltd   
  800926:	31 d0                	xor    %edx,%eax
  800928:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80092a:	83 f8 0f             	cmp    $0xf,%eax
  80092d:	7f 23                	jg     800952 <vprintfmt+0x13b>
  80092f:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  800936:	85 d2                	test   %edx,%edx
  800938:	74 18                	je     800952 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80093a:	52                   	push   %edx
  80093b:	68 9d 2d 80 00       	push   $0x802d9d
  800940:	53                   	push   %ebx
  800941:	56                   	push   %esi
  800942:	e8 b3 fe ff ff       	call   8007fa <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80094a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80094d:	e9 9a 02 00 00       	jmp    800bec <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800952:	50                   	push   %eax
  800953:	68 bb 29 80 00       	push   $0x8029bb
  800958:	53                   	push   %ebx
  800959:	56                   	push   %esi
  80095a:	e8 9b fe ff ff       	call   8007fa <printfmt>
  80095f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800962:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800965:	e9 82 02 00 00       	jmp    800bec <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 c0 04             	add    $0x4,%eax
  800970:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800978:	85 ff                	test   %edi,%edi
  80097a:	b8 b4 29 80 00       	mov    $0x8029b4,%eax
  80097f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800982:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800986:	0f 8e bd 00 00 00    	jle    800a49 <vprintfmt+0x232>
  80098c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800990:	75 0e                	jne    8009a0 <vprintfmt+0x189>
  800992:	89 75 08             	mov    %esi,0x8(%ebp)
  800995:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800998:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80099b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80099e:	eb 6d                	jmp    800a0d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8009a6:	57                   	push   %edi
  8009a7:	e8 6e 03 00 00       	call   800d1a <strnlen>
  8009ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009af:	29 c1                	sub    %eax,%ecx
  8009b1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8009b4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8009b7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009be:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8009c1:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c3:	eb 0f                	jmp    8009d4 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	53                   	push   %ebx
  8009c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8009cc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ce:	83 ef 01             	sub    $0x1,%edi
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	85 ff                	test   %edi,%edi
  8009d6:	7f ed                	jg     8009c5 <vprintfmt+0x1ae>
  8009d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8009db:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8009de:	85 c9                	test   %ecx,%ecx
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e5:	0f 49 c1             	cmovns %ecx,%eax
  8009e8:	29 c1                	sub    %eax,%ecx
  8009ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8009ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8009f3:	89 cb                	mov    %ecx,%ebx
  8009f5:	eb 16                	jmp    800a0d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009fb:	75 31                	jne    800a2e <vprintfmt+0x217>
					putch(ch, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	50                   	push   %eax
  800a04:	ff 55 08             	call   *0x8(%ebp)
  800a07:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0a:	83 eb 01             	sub    $0x1,%ebx
  800a0d:	83 c7 01             	add    $0x1,%edi
  800a10:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800a14:	0f be c2             	movsbl %dl,%eax
  800a17:	85 c0                	test   %eax,%eax
  800a19:	74 59                	je     800a74 <vprintfmt+0x25d>
  800a1b:	85 f6                	test   %esi,%esi
  800a1d:	78 d8                	js     8009f7 <vprintfmt+0x1e0>
  800a1f:	83 ee 01             	sub    $0x1,%esi
  800a22:	79 d3                	jns    8009f7 <vprintfmt+0x1e0>
  800a24:	89 df                	mov    %ebx,%edi
  800a26:	8b 75 08             	mov    0x8(%ebp),%esi
  800a29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a2c:	eb 37                	jmp    800a65 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a2e:	0f be d2             	movsbl %dl,%edx
  800a31:	83 ea 20             	sub    $0x20,%edx
  800a34:	83 fa 5e             	cmp    $0x5e,%edx
  800a37:	76 c4                	jbe    8009fd <vprintfmt+0x1e6>
					putch('?', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 3f                	push   $0x3f
  800a41:	ff 55 08             	call   *0x8(%ebp)
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	eb c1                	jmp    800a0a <vprintfmt+0x1f3>
  800a49:	89 75 08             	mov    %esi,0x8(%ebp)
  800a4c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a4f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a52:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a55:	eb b6                	jmp    800a0d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	6a 20                	push   $0x20
  800a5d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a5f:	83 ef 01             	sub    $0x1,%edi
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	85 ff                	test   %edi,%edi
  800a67:	7f ee                	jg     800a57 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800a69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6f:	e9 78 01 00 00       	jmp    800bec <vprintfmt+0x3d5>
  800a74:	89 df                	mov    %ebx,%edi
  800a76:	8b 75 08             	mov    0x8(%ebp),%esi
  800a79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a7c:	eb e7                	jmp    800a65 <vprintfmt+0x24e>
	if (lflag >= 2)
  800a7e:	83 f9 01             	cmp    $0x1,%ecx
  800a81:	7e 3f                	jle    800ac2 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	8b 50 04             	mov    0x4(%eax),%edx
  800a89:	8b 00                	mov    (%eax),%eax
  800a8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	8d 40 08             	lea    0x8(%eax),%eax
  800a97:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a9e:	79 5c                	jns    800afc <vprintfmt+0x2e5>
				putch('-', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	53                   	push   %ebx
  800aa4:	6a 2d                	push   $0x2d
  800aa6:	ff d6                	call   *%esi
				num = -(long long) num;
  800aa8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800aae:	f7 da                	neg    %edx
  800ab0:	83 d1 00             	adc    $0x0,%ecx
  800ab3:	f7 d9                	neg    %ecx
  800ab5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ab8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800abd:	e9 10 01 00 00       	jmp    800bd2 <vprintfmt+0x3bb>
	else if (lflag)
  800ac2:	85 c9                	test   %ecx,%ecx
  800ac4:	75 1b                	jne    800ae1 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	8b 00                	mov    (%eax),%eax
  800acb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ace:	89 c1                	mov    %eax,%ecx
  800ad0:	c1 f9 1f             	sar    $0x1f,%ecx
  800ad3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	8d 40 04             	lea    0x4(%eax),%eax
  800adc:	89 45 14             	mov    %eax,0x14(%ebp)
  800adf:	eb b9                	jmp    800a9a <vprintfmt+0x283>
		return va_arg(*ap, long);
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae9:	89 c1                	mov    %eax,%ecx
  800aeb:	c1 f9 1f             	sar    $0x1f,%ecx
  800aee:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	8d 40 04             	lea    0x4(%eax),%eax
  800af7:	89 45 14             	mov    %eax,0x14(%ebp)
  800afa:	eb 9e                	jmp    800a9a <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800afc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aff:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800b02:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b07:	e9 c6 00 00 00       	jmp    800bd2 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800b0c:	83 f9 01             	cmp    $0x1,%ecx
  800b0f:	7e 18                	jle    800b29 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	8b 10                	mov    (%eax),%edx
  800b16:	8b 48 04             	mov    0x4(%eax),%ecx
  800b19:	8d 40 08             	lea    0x8(%eax),%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b1f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b24:	e9 a9 00 00 00       	jmp    800bd2 <vprintfmt+0x3bb>
	else if (lflag)
  800b29:	85 c9                	test   %ecx,%ecx
  800b2b:	75 1a                	jne    800b47 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b30:	8b 10                	mov    (%eax),%edx
  800b32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b37:	8d 40 04             	lea    0x4(%eax),%eax
  800b3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b3d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b42:	e9 8b 00 00 00       	jmp    800bd2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	8b 10                	mov    (%eax),%edx
  800b4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b51:	8d 40 04             	lea    0x4(%eax),%eax
  800b54:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b57:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b5c:	eb 74                	jmp    800bd2 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800b5e:	83 f9 01             	cmp    $0x1,%ecx
  800b61:	7e 15                	jle    800b78 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800b63:	8b 45 14             	mov    0x14(%ebp),%eax
  800b66:	8b 10                	mov    (%eax),%edx
  800b68:	8b 48 04             	mov    0x4(%eax),%ecx
  800b6b:	8d 40 08             	lea    0x8(%eax),%eax
  800b6e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b71:	b8 08 00 00 00       	mov    $0x8,%eax
  800b76:	eb 5a                	jmp    800bd2 <vprintfmt+0x3bb>
	else if (lflag)
  800b78:	85 c9                	test   %ecx,%ecx
  800b7a:	75 17                	jne    800b93 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7f:	8b 10                	mov    (%eax),%edx
  800b81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b86:	8d 40 04             	lea    0x4(%eax),%eax
  800b89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b8c:	b8 08 00 00 00       	mov    $0x8,%eax
  800b91:	eb 3f                	jmp    800bd2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800b93:	8b 45 14             	mov    0x14(%ebp),%eax
  800b96:	8b 10                	mov    (%eax),%edx
  800b98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9d:	8d 40 04             	lea    0x4(%eax),%eax
  800ba0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ba3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ba8:	eb 28                	jmp    800bd2 <vprintfmt+0x3bb>
			putch('0', putdat);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	53                   	push   %ebx
  800bae:	6a 30                	push   $0x30
  800bb0:	ff d6                	call   *%esi
			putch('x', putdat);
  800bb2:	83 c4 08             	add    $0x8,%esp
  800bb5:	53                   	push   %ebx
  800bb6:	6a 78                	push   $0x78
  800bb8:	ff d6                	call   *%esi
			num = (unsigned long long)
  800bba:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbd:	8b 10                	mov    (%eax),%edx
  800bbf:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800bc4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bc7:	8d 40 04             	lea    0x4(%eax),%eax
  800bca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bcd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bd2:	83 ec 0c             	sub    $0xc,%esp
  800bd5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800bd9:	57                   	push   %edi
  800bda:	ff 75 e0             	pushl  -0x20(%ebp)
  800bdd:	50                   	push   %eax
  800bde:	51                   	push   %ecx
  800bdf:	52                   	push   %edx
  800be0:	89 da                	mov    %ebx,%edx
  800be2:	89 f0                	mov    %esi,%eax
  800be4:	e8 45 fb ff ff       	call   80072e <printnum>
			break;
  800be9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800bec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	83 c7 01             	add    $0x1,%edi
  800bf2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bf6:	83 f8 25             	cmp    $0x25,%eax
  800bf9:	0f 84 2f fc ff ff    	je     80082e <vprintfmt+0x17>
			if (ch == '\0')
  800bff:	85 c0                	test   %eax,%eax
  800c01:	0f 84 8b 00 00 00    	je     800c92 <vprintfmt+0x47b>
			putch(ch, putdat);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	53                   	push   %ebx
  800c0b:	50                   	push   %eax
  800c0c:	ff d6                	call   *%esi
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	eb dc                	jmp    800bef <vprintfmt+0x3d8>
	if (lflag >= 2)
  800c13:	83 f9 01             	cmp    $0x1,%ecx
  800c16:	7e 15                	jle    800c2d <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800c18:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1b:	8b 10                	mov    (%eax),%edx
  800c1d:	8b 48 04             	mov    0x4(%eax),%ecx
  800c20:	8d 40 08             	lea    0x8(%eax),%eax
  800c23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c26:	b8 10 00 00 00       	mov    $0x10,%eax
  800c2b:	eb a5                	jmp    800bd2 <vprintfmt+0x3bb>
	else if (lflag)
  800c2d:	85 c9                	test   %ecx,%ecx
  800c2f:	75 17                	jne    800c48 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800c31:	8b 45 14             	mov    0x14(%ebp),%eax
  800c34:	8b 10                	mov    (%eax),%edx
  800c36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3b:	8d 40 04             	lea    0x4(%eax),%eax
  800c3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c41:	b8 10 00 00 00       	mov    $0x10,%eax
  800c46:	eb 8a                	jmp    800bd2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800c48:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4b:	8b 10                	mov    (%eax),%edx
  800c4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c52:	8d 40 04             	lea    0x4(%eax),%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c58:	b8 10 00 00 00       	mov    $0x10,%eax
  800c5d:	e9 70 ff ff ff       	jmp    800bd2 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	53                   	push   %ebx
  800c66:	6a 25                	push   $0x25
  800c68:	ff d6                	call   *%esi
			break;
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	e9 7a ff ff ff       	jmp    800bec <vprintfmt+0x3d5>
			putch('%', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	53                   	push   %ebx
  800c76:	6a 25                	push   $0x25
  800c78:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 f8                	mov    %edi,%eax
  800c7f:	eb 03                	jmp    800c84 <vprintfmt+0x46d>
  800c81:	83 e8 01             	sub    $0x1,%eax
  800c84:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c88:	75 f7                	jne    800c81 <vprintfmt+0x46a>
  800c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c8d:	e9 5a ff ff ff       	jmp    800bec <vprintfmt+0x3d5>
}
  800c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ca6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ca9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cad:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cb7:	85 c0                	test   %eax,%eax
  800cb9:	74 26                	je     800ce1 <vsnprintf+0x47>
  800cbb:	85 d2                	test   %edx,%edx
  800cbd:	7e 22                	jle    800ce1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cbf:	ff 75 14             	pushl  0x14(%ebp)
  800cc2:	ff 75 10             	pushl  0x10(%ebp)
  800cc5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc8:	50                   	push   %eax
  800cc9:	68 dd 07 80 00       	push   $0x8007dd
  800cce:	e8 44 fb ff ff       	call   800817 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cdc:	83 c4 10             	add    $0x10,%esp
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    
		return -E_INVAL;
  800ce1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce6:	eb f7                	jmp    800cdf <vsnprintf+0x45>

00800ce8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cee:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 10             	pushl  0x10(%ebp)
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	ff 75 08             	pushl  0x8(%ebp)
  800cfb:	e8 9a ff ff ff       	call   800c9a <vsnprintf>
	va_end(ap);

	return rc;
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d08:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0d:	eb 03                	jmp    800d12 <strlen+0x10>
		n++;
  800d0f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800d12:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d16:	75 f7                	jne    800d0f <strlen+0xd>
	return n;
}
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d20:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d23:	b8 00 00 00 00       	mov    $0x0,%eax
  800d28:	eb 03                	jmp    800d2d <strnlen+0x13>
		n++;
  800d2a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2d:	39 d0                	cmp    %edx,%eax
  800d2f:	74 06                	je     800d37 <strnlen+0x1d>
  800d31:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d35:	75 f3                	jne    800d2a <strnlen+0x10>
	return n;
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	53                   	push   %ebx
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d43:	89 c2                	mov    %eax,%edx
  800d45:	83 c1 01             	add    $0x1,%ecx
  800d48:	83 c2 01             	add    $0x1,%edx
  800d4b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d4f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d52:	84 db                	test   %bl,%bl
  800d54:	75 ef                	jne    800d45 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d56:	5b                   	pop    %ebx
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	53                   	push   %ebx
  800d5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d60:	53                   	push   %ebx
  800d61:	e8 9c ff ff ff       	call   800d02 <strlen>
  800d66:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	01 d8                	add    %ebx,%eax
  800d6e:	50                   	push   %eax
  800d6f:	e8 c5 ff ff ff       	call   800d39 <strcpy>
	return dst;
}
  800d74:	89 d8                	mov    %ebx,%eax
  800d76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d79:	c9                   	leave  
  800d7a:	c3                   	ret    

00800d7b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	8b 75 08             	mov    0x8(%ebp),%esi
  800d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d86:	89 f3                	mov    %esi,%ebx
  800d88:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d8b:	89 f2                	mov    %esi,%edx
  800d8d:	eb 0f                	jmp    800d9e <strncpy+0x23>
		*dst++ = *src;
  800d8f:	83 c2 01             	add    $0x1,%edx
  800d92:	0f b6 01             	movzbl (%ecx),%eax
  800d95:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d98:	80 39 01             	cmpb   $0x1,(%ecx)
  800d9b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800d9e:	39 da                	cmp    %ebx,%edx
  800da0:	75 ed                	jne    800d8f <strncpy+0x14>
	}
	return ret;
}
  800da2:	89 f0                	mov    %esi,%eax
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	8b 75 08             	mov    0x8(%ebp),%esi
  800db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800db6:	89 f0                	mov    %esi,%eax
  800db8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800dbc:	85 c9                	test   %ecx,%ecx
  800dbe:	75 0b                	jne    800dcb <strlcpy+0x23>
  800dc0:	eb 17                	jmp    800dd9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800dc2:	83 c2 01             	add    $0x1,%edx
  800dc5:	83 c0 01             	add    $0x1,%eax
  800dc8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800dcb:	39 d8                	cmp    %ebx,%eax
  800dcd:	74 07                	je     800dd6 <strlcpy+0x2e>
  800dcf:	0f b6 0a             	movzbl (%edx),%ecx
  800dd2:	84 c9                	test   %cl,%cl
  800dd4:	75 ec                	jne    800dc2 <strlcpy+0x1a>
		*dst = '\0';
  800dd6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd9:	29 f0                	sub    %esi,%eax
}
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800de8:	eb 06                	jmp    800df0 <strcmp+0x11>
		p++, q++;
  800dea:	83 c1 01             	add    $0x1,%ecx
  800ded:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800df0:	0f b6 01             	movzbl (%ecx),%eax
  800df3:	84 c0                	test   %al,%al
  800df5:	74 04                	je     800dfb <strcmp+0x1c>
  800df7:	3a 02                	cmp    (%edx),%al
  800df9:	74 ef                	je     800dea <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dfb:	0f b6 c0             	movzbl %al,%eax
  800dfe:	0f b6 12             	movzbl (%edx),%edx
  800e01:	29 d0                	sub    %edx,%eax
}
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	53                   	push   %ebx
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strncmp+0x17>
		n--, p++, q++;
  800e16:	83 c0 01             	add    $0x1,%eax
  800e19:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e1c:	39 d8                	cmp    %ebx,%eax
  800e1e:	74 16                	je     800e36 <strncmp+0x31>
  800e20:	0f b6 08             	movzbl (%eax),%ecx
  800e23:	84 c9                	test   %cl,%cl
  800e25:	74 04                	je     800e2b <strncmp+0x26>
  800e27:	3a 0a                	cmp    (%edx),%cl
  800e29:	74 eb                	je     800e16 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2b:	0f b6 00             	movzbl (%eax),%eax
  800e2e:	0f b6 12             	movzbl (%edx),%edx
  800e31:	29 d0                	sub    %edx,%eax
}
  800e33:	5b                   	pop    %ebx
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    
		return 0;
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3b:	eb f6                	jmp    800e33 <strncmp+0x2e>

00800e3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e47:	0f b6 10             	movzbl (%eax),%edx
  800e4a:	84 d2                	test   %dl,%dl
  800e4c:	74 09                	je     800e57 <strchr+0x1a>
		if (*s == c)
  800e4e:	38 ca                	cmp    %cl,%dl
  800e50:	74 0a                	je     800e5c <strchr+0x1f>
	for (; *s; s++)
  800e52:	83 c0 01             	add    $0x1,%eax
  800e55:	eb f0                	jmp    800e47 <strchr+0xa>
			return (char *) s;
	return 0;
  800e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e68:	eb 03                	jmp    800e6d <strfind+0xf>
  800e6a:	83 c0 01             	add    $0x1,%eax
  800e6d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e70:	38 ca                	cmp    %cl,%dl
  800e72:	74 04                	je     800e78 <strfind+0x1a>
  800e74:	84 d2                	test   %dl,%dl
  800e76:	75 f2                	jne    800e6a <strfind+0xc>
			break;
	return (char *) s;
}
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e86:	85 c9                	test   %ecx,%ecx
  800e88:	74 13                	je     800e9d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e8a:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e90:	75 05                	jne    800e97 <memset+0x1d>
  800e92:	f6 c1 03             	test   $0x3,%cl
  800e95:	74 0d                	je     800ea4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	fc                   	cld    
  800e9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e9d:	89 f8                	mov    %edi,%eax
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
		c &= 0xFF;
  800ea4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ea8:	89 d3                	mov    %edx,%ebx
  800eaa:	c1 e3 08             	shl    $0x8,%ebx
  800ead:	89 d0                	mov    %edx,%eax
  800eaf:	c1 e0 18             	shl    $0x18,%eax
  800eb2:	89 d6                	mov    %edx,%esi
  800eb4:	c1 e6 10             	shl    $0x10,%esi
  800eb7:	09 f0                	or     %esi,%eax
  800eb9:	09 c2                	or     %eax,%edx
  800ebb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ebd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ec0:	89 d0                	mov    %edx,%eax
  800ec2:	fc                   	cld    
  800ec3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ec5:	eb d6                	jmp    800e9d <memset+0x23>

00800ec7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ed2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ed5:	39 c6                	cmp    %eax,%esi
  800ed7:	73 35                	jae    800f0e <memmove+0x47>
  800ed9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800edc:	39 c2                	cmp    %eax,%edx
  800ede:	76 2e                	jbe    800f0e <memmove+0x47>
		s += n;
		d += n;
  800ee0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ee3:	89 d6                	mov    %edx,%esi
  800ee5:	09 fe                	or     %edi,%esi
  800ee7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eed:	74 0c                	je     800efb <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eef:	83 ef 01             	sub    $0x1,%edi
  800ef2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ef5:	fd                   	std    
  800ef6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ef8:	fc                   	cld    
  800ef9:	eb 21                	jmp    800f1c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800efb:	f6 c1 03             	test   $0x3,%cl
  800efe:	75 ef                	jne    800eef <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f00:	83 ef 04             	sub    $0x4,%edi
  800f03:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f09:	fd                   	std    
  800f0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f0c:	eb ea                	jmp    800ef8 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f0e:	89 f2                	mov    %esi,%edx
  800f10:	09 c2                	or     %eax,%edx
  800f12:	f6 c2 03             	test   $0x3,%dl
  800f15:	74 09                	je     800f20 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f17:	89 c7                	mov    %eax,%edi
  800f19:	fc                   	cld    
  800f1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f20:	f6 c1 03             	test   $0x3,%cl
  800f23:	75 f2                	jne    800f17 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f28:	89 c7                	mov    %eax,%edi
  800f2a:	fc                   	cld    
  800f2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f2d:	eb ed                	jmp    800f1c <memmove+0x55>

00800f2f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800f32:	ff 75 10             	pushl  0x10(%ebp)
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	ff 75 08             	pushl  0x8(%ebp)
  800f3b:	e8 87 ff ff ff       	call   800ec7 <memmove>
}
  800f40:	c9                   	leave  
  800f41:	c3                   	ret    

00800f42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	56                   	push   %esi
  800f46:	53                   	push   %ebx
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	89 c6                	mov    %eax,%esi
  800f4f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f52:	39 f0                	cmp    %esi,%eax
  800f54:	74 1c                	je     800f72 <memcmp+0x30>
		if (*s1 != *s2)
  800f56:	0f b6 08             	movzbl (%eax),%ecx
  800f59:	0f b6 1a             	movzbl (%edx),%ebx
  800f5c:	38 d9                	cmp    %bl,%cl
  800f5e:	75 08                	jne    800f68 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f60:	83 c0 01             	add    $0x1,%eax
  800f63:	83 c2 01             	add    $0x1,%edx
  800f66:	eb ea                	jmp    800f52 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f68:	0f b6 c1             	movzbl %cl,%eax
  800f6b:	0f b6 db             	movzbl %bl,%ebx
  800f6e:	29 d8                	sub    %ebx,%eax
  800f70:	eb 05                	jmp    800f77 <memcmp+0x35>
	}

	return 0;
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f84:	89 c2                	mov    %eax,%edx
  800f86:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f89:	39 d0                	cmp    %edx,%eax
  800f8b:	73 09                	jae    800f96 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f8d:	38 08                	cmp    %cl,(%eax)
  800f8f:	74 05                	je     800f96 <memfind+0x1b>
	for (; s < ends; s++)
  800f91:	83 c0 01             	add    $0x1,%eax
  800f94:	eb f3                	jmp    800f89 <memfind+0xe>
			break;
	return (void *) s;
}
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
  800f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa4:	eb 03                	jmp    800fa9 <strtol+0x11>
		s++;
  800fa6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fa9:	0f b6 01             	movzbl (%ecx),%eax
  800fac:	3c 20                	cmp    $0x20,%al
  800fae:	74 f6                	je     800fa6 <strtol+0xe>
  800fb0:	3c 09                	cmp    $0x9,%al
  800fb2:	74 f2                	je     800fa6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fb4:	3c 2b                	cmp    $0x2b,%al
  800fb6:	74 2e                	je     800fe6 <strtol+0x4e>
	int neg = 0;
  800fb8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	74 2f                	je     800ff0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fc1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800fc7:	75 05                	jne    800fce <strtol+0x36>
  800fc9:	80 39 30             	cmpb   $0x30,(%ecx)
  800fcc:	74 2c                	je     800ffa <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fce:	85 db                	test   %ebx,%ebx
  800fd0:	75 0a                	jne    800fdc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fd2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800fd7:	80 39 30             	cmpb   $0x30,(%ecx)
  800fda:	74 28                	je     801004 <strtol+0x6c>
		base = 10;
  800fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800fe4:	eb 50                	jmp    801036 <strtol+0x9e>
		s++;
  800fe6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fe9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fee:	eb d1                	jmp    800fc1 <strtol+0x29>
		s++, neg = 1;
  800ff0:	83 c1 01             	add    $0x1,%ecx
  800ff3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ff8:	eb c7                	jmp    800fc1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ffa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ffe:	74 0e                	je     80100e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801000:	85 db                	test   %ebx,%ebx
  801002:	75 d8                	jne    800fdc <strtol+0x44>
		s++, base = 8;
  801004:	83 c1 01             	add    $0x1,%ecx
  801007:	bb 08 00 00 00       	mov    $0x8,%ebx
  80100c:	eb ce                	jmp    800fdc <strtol+0x44>
		s += 2, base = 16;
  80100e:	83 c1 02             	add    $0x2,%ecx
  801011:	bb 10 00 00 00       	mov    $0x10,%ebx
  801016:	eb c4                	jmp    800fdc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801018:	8d 72 9f             	lea    -0x61(%edx),%esi
  80101b:	89 f3                	mov    %esi,%ebx
  80101d:	80 fb 19             	cmp    $0x19,%bl
  801020:	77 29                	ja     80104b <strtol+0xb3>
			dig = *s - 'a' + 10;
  801022:	0f be d2             	movsbl %dl,%edx
  801025:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801028:	3b 55 10             	cmp    0x10(%ebp),%edx
  80102b:	7d 30                	jge    80105d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80102d:	83 c1 01             	add    $0x1,%ecx
  801030:	0f af 45 10          	imul   0x10(%ebp),%eax
  801034:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801036:	0f b6 11             	movzbl (%ecx),%edx
  801039:	8d 72 d0             	lea    -0x30(%edx),%esi
  80103c:	89 f3                	mov    %esi,%ebx
  80103e:	80 fb 09             	cmp    $0x9,%bl
  801041:	77 d5                	ja     801018 <strtol+0x80>
			dig = *s - '0';
  801043:	0f be d2             	movsbl %dl,%edx
  801046:	83 ea 30             	sub    $0x30,%edx
  801049:	eb dd                	jmp    801028 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80104e:	89 f3                	mov    %esi,%ebx
  801050:	80 fb 19             	cmp    $0x19,%bl
  801053:	77 08                	ja     80105d <strtol+0xc5>
			dig = *s - 'A' + 10;
  801055:	0f be d2             	movsbl %dl,%edx
  801058:	83 ea 37             	sub    $0x37,%edx
  80105b:	eb cb                	jmp    801028 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  80105d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801061:	74 05                	je     801068 <strtol+0xd0>
		*endptr = (char *) s;
  801063:	8b 75 0c             	mov    0xc(%ebp),%esi
  801066:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801068:	89 c2                	mov    %eax,%edx
  80106a:	f7 da                	neg    %edx
  80106c:	85 ff                	test   %edi,%edi
  80106e:	0f 45 c2             	cmovne %edx,%eax
}
  801071:	5b                   	pop    %ebx
  801072:	5e                   	pop    %esi
  801073:	5f                   	pop    %edi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107c:	b8 00 00 00 00       	mov    $0x0,%eax
  801081:	8b 55 08             	mov    0x8(%ebp),%edx
  801084:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801087:	89 c3                	mov    %eax,%ebx
  801089:	89 c7                	mov    %eax,%edi
  80108b:	89 c6                	mov    %eax,%esi
  80108d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <sys_cgetc>:

int
sys_cgetc(void)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109a:	ba 00 00 00 00       	mov    $0x0,%edx
  80109f:	b8 01 00 00 00       	mov    $0x1,%eax
  8010a4:	89 d1                	mov    %edx,%ecx
  8010a6:	89 d3                	mov    %edx,%ebx
  8010a8:	89 d7                	mov    %edx,%edi
  8010aa:	89 d6                	mov    %edx,%esi
  8010ac:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8010c9:	89 cb                	mov    %ecx,%ebx
  8010cb:	89 cf                	mov    %ecx,%edi
  8010cd:	89 ce                	mov    %ecx,%esi
  8010cf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	7f 08                	jg     8010dd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d8:	5b                   	pop    %ebx
  8010d9:	5e                   	pop    %esi
  8010da:	5f                   	pop    %edi
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010dd:	83 ec 0c             	sub    $0xc,%esp
  8010e0:	50                   	push   %eax
  8010e1:	6a 03                	push   $0x3
  8010e3:	68 9f 2c 80 00       	push   $0x802c9f
  8010e8:	6a 23                	push   $0x23
  8010ea:	68 bc 2c 80 00       	push   $0x802cbc
  8010ef:	e8 4b f5 ff ff       	call   80063f <_panic>

008010f4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	57                   	push   %edi
  8010f8:	56                   	push   %esi
  8010f9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801104:	89 d1                	mov    %edx,%ecx
  801106:	89 d3                	mov    %edx,%ebx
  801108:	89 d7                	mov    %edx,%edi
  80110a:	89 d6                	mov    %edx,%esi
  80110c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80110e:	5b                   	pop    %ebx
  80110f:	5e                   	pop    %esi
  801110:	5f                   	pop    %edi
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <sys_yield>:

void
sys_yield(void)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	57                   	push   %edi
  801117:	56                   	push   %esi
  801118:	53                   	push   %ebx
	asm volatile("int %1\n"
  801119:	ba 00 00 00 00       	mov    $0x0,%edx
  80111e:	b8 0b 00 00 00       	mov    $0xb,%eax
  801123:	89 d1                	mov    %edx,%ecx
  801125:	89 d3                	mov    %edx,%ebx
  801127:	89 d7                	mov    %edx,%edi
  801129:	89 d6                	mov    %edx,%esi
  80112b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
  801138:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80113b:	be 00 00 00 00       	mov    $0x0,%esi
  801140:	8b 55 08             	mov    0x8(%ebp),%edx
  801143:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801146:	b8 04 00 00 00       	mov    $0x4,%eax
  80114b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114e:	89 f7                	mov    %esi,%edi
  801150:	cd 30                	int    $0x30
	if(check && ret > 0)
  801152:	85 c0                	test   %eax,%eax
  801154:	7f 08                	jg     80115e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801156:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801159:	5b                   	pop    %ebx
  80115a:	5e                   	pop    %esi
  80115b:	5f                   	pop    %edi
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115e:	83 ec 0c             	sub    $0xc,%esp
  801161:	50                   	push   %eax
  801162:	6a 04                	push   $0x4
  801164:	68 9f 2c 80 00       	push   $0x802c9f
  801169:	6a 23                	push   $0x23
  80116b:	68 bc 2c 80 00       	push   $0x802cbc
  801170:	e8 ca f4 ff ff       	call   80063f <_panic>

00801175 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	57                   	push   %edi
  801179:	56                   	push   %esi
  80117a:	53                   	push   %ebx
  80117b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801184:	b8 05 00 00 00       	mov    $0x5,%eax
  801189:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80118c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80118f:	8b 75 18             	mov    0x18(%ebp),%esi
  801192:	cd 30                	int    $0x30
	if(check && ret > 0)
  801194:	85 c0                	test   %eax,%eax
  801196:	7f 08                	jg     8011a0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a0:	83 ec 0c             	sub    $0xc,%esp
  8011a3:	50                   	push   %eax
  8011a4:	6a 05                	push   $0x5
  8011a6:	68 9f 2c 80 00       	push   $0x802c9f
  8011ab:	6a 23                	push   $0x23
  8011ad:	68 bc 2c 80 00       	push   $0x802cbc
  8011b2:	e8 88 f4 ff ff       	call   80063f <_panic>

008011b7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	57                   	push   %edi
  8011bb:	56                   	push   %esi
  8011bc:	53                   	push   %ebx
  8011bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011cb:	b8 06 00 00 00       	mov    $0x6,%eax
  8011d0:	89 df                	mov    %ebx,%edi
  8011d2:	89 de                	mov    %ebx,%esi
  8011d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	7f 08                	jg     8011e2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011dd:	5b                   	pop    %ebx
  8011de:	5e                   	pop    %esi
  8011df:	5f                   	pop    %edi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	50                   	push   %eax
  8011e6:	6a 06                	push   $0x6
  8011e8:	68 9f 2c 80 00       	push   $0x802c9f
  8011ed:	6a 23                	push   $0x23
  8011ef:	68 bc 2c 80 00       	push   $0x802cbc
  8011f4:	e8 46 f4 ff ff       	call   80063f <_panic>

008011f9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801202:	bb 00 00 00 00       	mov    $0x0,%ebx
  801207:	8b 55 08             	mov    0x8(%ebp),%edx
  80120a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120d:	b8 08 00 00 00       	mov    $0x8,%eax
  801212:	89 df                	mov    %ebx,%edi
  801214:	89 de                	mov    %ebx,%esi
  801216:	cd 30                	int    $0x30
	if(check && ret > 0)
  801218:	85 c0                	test   %eax,%eax
  80121a:	7f 08                	jg     801224 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80121c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	50                   	push   %eax
  801228:	6a 08                	push   $0x8
  80122a:	68 9f 2c 80 00       	push   $0x802c9f
  80122f:	6a 23                	push   $0x23
  801231:	68 bc 2c 80 00       	push   $0x802cbc
  801236:	e8 04 f4 ff ff       	call   80063f <_panic>

0080123b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	57                   	push   %edi
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
  801241:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801244:	bb 00 00 00 00       	mov    $0x0,%ebx
  801249:	8b 55 08             	mov    0x8(%ebp),%edx
  80124c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124f:	b8 09 00 00 00       	mov    $0x9,%eax
  801254:	89 df                	mov    %ebx,%edi
  801256:	89 de                	mov    %ebx,%esi
  801258:	cd 30                	int    $0x30
	if(check && ret > 0)
  80125a:	85 c0                	test   %eax,%eax
  80125c:	7f 08                	jg     801266 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80125e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5f                   	pop    %edi
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	50                   	push   %eax
  80126a:	6a 09                	push   $0x9
  80126c:	68 9f 2c 80 00       	push   $0x802c9f
  801271:	6a 23                	push   $0x23
  801273:	68 bc 2c 80 00       	push   $0x802cbc
  801278:	e8 c2 f3 ff ff       	call   80063f <_panic>

0080127d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
  801283:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801286:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
  80128e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801291:	b8 0a 00 00 00       	mov    $0xa,%eax
  801296:	89 df                	mov    %ebx,%edi
  801298:	89 de                	mov    %ebx,%esi
  80129a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80129c:	85 c0                	test   %eax,%eax
  80129e:	7f 08                	jg     8012a8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	50                   	push   %eax
  8012ac:	6a 0a                	push   $0xa
  8012ae:	68 9f 2c 80 00       	push   $0x802c9f
  8012b3:	6a 23                	push   $0x23
  8012b5:	68 bc 2c 80 00       	push   $0x802cbc
  8012ba:	e8 80 f3 ff ff       	call   80063f <_panic>

008012bf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	57                   	push   %edi
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cb:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012d0:	be 00 00 00 00       	mov    $0x0,%esi
  8012d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012d8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012db:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5f                   	pop    %edi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    

008012e2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	57                   	push   %edi
  8012e6:	56                   	push   %esi
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f3:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012f8:	89 cb                	mov    %ecx,%ebx
  8012fa:	89 cf                	mov    %ecx,%edi
  8012fc:	89 ce                	mov    %ecx,%esi
  8012fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801300:	85 c0                	test   %eax,%eax
  801302:	7f 08                	jg     80130c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	50                   	push   %eax
  801310:	6a 0d                	push   $0xd
  801312:	68 9f 2c 80 00       	push   $0x802c9f
  801317:	6a 23                	push   $0x23
  801319:	68 bc 2c 80 00       	push   $0x802cbc
  80131e:	e8 1c f3 ff ff       	call   80063f <_panic>

00801323 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	57                   	push   %edi
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
	asm volatile("int %1\n"
  801329:	ba 00 00 00 00       	mov    $0x0,%edx
  80132e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801333:	89 d1                	mov    %edx,%ecx
  801335:	89 d3                	mov    %edx,%ebx
  801337:	89 d7                	mov    %edx,%edi
  801339:	89 d6                	mov    %edx,%esi
  80133b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80133d:	5b                   	pop    %ebx
  80133e:	5e                   	pop    %esi
  80133f:	5f                   	pop    %edi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  801348:	83 3d b8 40 80 00 00 	cmpl   $0x0,0x8040b8
  80134f:	74 0a                	je     80135b <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	a3 b8 40 80 00       	mov    %eax,0x8040b8
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  80135b:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  801360:	8b 40 48             	mov    0x48(%eax),%eax
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	6a 07                	push   $0x7
  801368:	68 00 f0 bf ee       	push   $0xeebff000
  80136d:	50                   	push   %eax
  80136e:	e8 bf fd ff ff       	call   801132 <sys_page_alloc>
  801373:	83 c4 10             	add    $0x10,%esp
  801376:	85 c0                	test   %eax,%eax
  801378:	78 1b                	js     801395 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80137a:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  80137f:	8b 40 48             	mov    0x48(%eax),%eax
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	68 a7 13 80 00       	push   $0x8013a7
  80138a:	50                   	push   %eax
  80138b:	e8 ed fe ff ff       	call   80127d <sys_env_set_pgfault_upcall>
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	eb bc                	jmp    801351 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  801395:	50                   	push   %eax
  801396:	68 ca 2c 80 00       	push   $0x802cca
  80139b:	6a 22                	push   $0x22
  80139d:	68 e2 2c 80 00       	push   $0x802ce2
  8013a2:	e8 98 f2 ff ff       	call   80063f <_panic>

008013a7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8013a7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8013a8:	a1 b8 40 80 00       	mov    0x8040b8,%eax
	call *%eax
  8013ad:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8013af:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8013b2:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8013b6:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8013b9:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8013bd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8013c1:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8013c3:	83 c4 08             	add    $0x8,%esp
	popal
  8013c6:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8013c7:	83 c4 04             	add    $0x4,%esp
	popfl
  8013ca:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8013cb:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8013cc:	c3                   	ret    

008013cd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	05 00 00 00 30       	add    $0x30000000,%eax
  8013d8:	c1 e8 0c             	shr    $0xc,%eax
}
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    

008013dd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ed:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013ff:	89 c2                	mov    %eax,%edx
  801401:	c1 ea 16             	shr    $0x16,%edx
  801404:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80140b:	f6 c2 01             	test   $0x1,%dl
  80140e:	74 2a                	je     80143a <fd_alloc+0x46>
  801410:	89 c2                	mov    %eax,%edx
  801412:	c1 ea 0c             	shr    $0xc,%edx
  801415:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141c:	f6 c2 01             	test   $0x1,%dl
  80141f:	74 19                	je     80143a <fd_alloc+0x46>
  801421:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801426:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80142b:	75 d2                	jne    8013ff <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80142d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801433:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801438:	eb 07                	jmp    801441 <fd_alloc+0x4d>
			*fd_store = fd;
  80143a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801441:	5d                   	pop    %ebp
  801442:	c3                   	ret    

00801443 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801449:	83 f8 1f             	cmp    $0x1f,%eax
  80144c:	77 36                	ja     801484 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80144e:	c1 e0 0c             	shl    $0xc,%eax
  801451:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801456:	89 c2                	mov    %eax,%edx
  801458:	c1 ea 16             	shr    $0x16,%edx
  80145b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801462:	f6 c2 01             	test   $0x1,%dl
  801465:	74 24                	je     80148b <fd_lookup+0x48>
  801467:	89 c2                	mov    %eax,%edx
  801469:	c1 ea 0c             	shr    $0xc,%edx
  80146c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801473:	f6 c2 01             	test   $0x1,%dl
  801476:	74 1a                	je     801492 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	89 02                	mov    %eax,(%edx)
	return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    
		return -E_INVAL;
  801484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801489:	eb f7                	jmp    801482 <fd_lookup+0x3f>
		return -E_INVAL;
  80148b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801490:	eb f0                	jmp    801482 <fd_lookup+0x3f>
  801492:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801497:	eb e9                	jmp    801482 <fd_lookup+0x3f>

00801499 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a2:	ba 70 2d 80 00       	mov    $0x802d70,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014a7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014ac:	39 08                	cmp    %ecx,(%eax)
  8014ae:	74 33                	je     8014e3 <dev_lookup+0x4a>
  8014b0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014b3:	8b 02                	mov    (%edx),%eax
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	75 f3                	jne    8014ac <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014b9:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8014be:	8b 40 48             	mov    0x48(%eax),%eax
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	51                   	push   %ecx
  8014c5:	50                   	push   %eax
  8014c6:	68 f0 2c 80 00       	push   $0x802cf0
  8014cb:	e8 4a f2 ff ff       	call   80071a <cprintf>
	*dev = 0;
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    
			*dev = devtab[i];
  8014e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ed:	eb f2                	jmp    8014e1 <dev_lookup+0x48>

008014ef <fd_close>:
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	57                   	push   %edi
  8014f3:	56                   	push   %esi
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 1c             	sub    $0x1c,%esp
  8014f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8014fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014fe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801501:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801502:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801508:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80150b:	50                   	push   %eax
  80150c:	e8 32 ff ff ff       	call   801443 <fd_lookup>
  801511:	89 c3                	mov    %eax,%ebx
  801513:	83 c4 08             	add    $0x8,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	78 05                	js     80151f <fd_close+0x30>
	    || fd != fd2)
  80151a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80151d:	74 16                	je     801535 <fd_close+0x46>
		return (must_exist ? r : 0);
  80151f:	89 f8                	mov    %edi,%eax
  801521:	84 c0                	test   %al,%al
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	0f 44 d8             	cmove  %eax,%ebx
}
  80152b:	89 d8                	mov    %ebx,%eax
  80152d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801530:	5b                   	pop    %ebx
  801531:	5e                   	pop    %esi
  801532:	5f                   	pop    %edi
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801535:	83 ec 08             	sub    $0x8,%esp
  801538:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	ff 36                	pushl  (%esi)
  80153e:	e8 56 ff ff ff       	call   801499 <dev_lookup>
  801543:	89 c3                	mov    %eax,%ebx
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 15                	js     801561 <fd_close+0x72>
		if (dev->dev_close)
  80154c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154f:	8b 40 10             	mov    0x10(%eax),%eax
  801552:	85 c0                	test   %eax,%eax
  801554:	74 1b                	je     801571 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	56                   	push   %esi
  80155a:	ff d0                	call   *%eax
  80155c:	89 c3                	mov    %eax,%ebx
  80155e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	56                   	push   %esi
  801565:	6a 00                	push   $0x0
  801567:	e8 4b fc ff ff       	call   8011b7 <sys_page_unmap>
	return r;
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	eb ba                	jmp    80152b <fd_close+0x3c>
			r = 0;
  801571:	bb 00 00 00 00       	mov    $0x0,%ebx
  801576:	eb e9                	jmp    801561 <fd_close+0x72>

00801578 <close>:

int
close(int fdnum)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 b9 fe ff ff       	call   801443 <fd_lookup>
  80158a:	83 c4 08             	add    $0x8,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 10                	js     8015a1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	6a 01                	push   $0x1
  801596:	ff 75 f4             	pushl  -0xc(%ebp)
  801599:	e8 51 ff ff ff       	call   8014ef <fd_close>
  80159e:	83 c4 10             	add    $0x10,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <close_all>:

void
close_all(void)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015aa:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	53                   	push   %ebx
  8015b3:	e8 c0 ff ff ff       	call   801578 <close>
	for (i = 0; i < MAXFD; i++)
  8015b8:	83 c3 01             	add    $0x1,%ebx
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	83 fb 20             	cmp    $0x20,%ebx
  8015c1:	75 ec                	jne    8015af <close_all+0xc>
}
  8015c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	57                   	push   %edi
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d4:	50                   	push   %eax
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	e8 66 fe ff ff       	call   801443 <fd_lookup>
  8015dd:	89 c3                	mov    %eax,%ebx
  8015df:	83 c4 08             	add    $0x8,%esp
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	0f 88 81 00 00 00    	js     80166b <dup+0xa3>
		return r;
	close(newfdnum);
  8015ea:	83 ec 0c             	sub    $0xc,%esp
  8015ed:	ff 75 0c             	pushl  0xc(%ebp)
  8015f0:	e8 83 ff ff ff       	call   801578 <close>

	newfd = INDEX2FD(newfdnum);
  8015f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015f8:	c1 e6 0c             	shl    $0xc,%esi
  8015fb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801601:	83 c4 04             	add    $0x4,%esp
  801604:	ff 75 e4             	pushl  -0x1c(%ebp)
  801607:	e8 d1 fd ff ff       	call   8013dd <fd2data>
  80160c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80160e:	89 34 24             	mov    %esi,(%esp)
  801611:	e8 c7 fd ff ff       	call   8013dd <fd2data>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80161b:	89 d8                	mov    %ebx,%eax
  80161d:	c1 e8 16             	shr    $0x16,%eax
  801620:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801627:	a8 01                	test   $0x1,%al
  801629:	74 11                	je     80163c <dup+0x74>
  80162b:	89 d8                	mov    %ebx,%eax
  80162d:	c1 e8 0c             	shr    $0xc,%eax
  801630:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801637:	f6 c2 01             	test   $0x1,%dl
  80163a:	75 39                	jne    801675 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80163c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80163f:	89 d0                	mov    %edx,%eax
  801641:	c1 e8 0c             	shr    $0xc,%eax
  801644:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	25 07 0e 00 00       	and    $0xe07,%eax
  801653:	50                   	push   %eax
  801654:	56                   	push   %esi
  801655:	6a 00                	push   $0x0
  801657:	52                   	push   %edx
  801658:	6a 00                	push   $0x0
  80165a:	e8 16 fb ff ff       	call   801175 <sys_page_map>
  80165f:	89 c3                	mov    %eax,%ebx
  801661:	83 c4 20             	add    $0x20,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	78 31                	js     801699 <dup+0xd1>
		goto err;

	return newfdnum;
  801668:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80166b:	89 d8                	mov    %ebx,%eax
  80166d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801670:	5b                   	pop    %ebx
  801671:	5e                   	pop    %esi
  801672:	5f                   	pop    %edi
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801675:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	25 07 0e 00 00       	and    $0xe07,%eax
  801684:	50                   	push   %eax
  801685:	57                   	push   %edi
  801686:	6a 00                	push   $0x0
  801688:	53                   	push   %ebx
  801689:	6a 00                	push   $0x0
  80168b:	e8 e5 fa ff ff       	call   801175 <sys_page_map>
  801690:	89 c3                	mov    %eax,%ebx
  801692:	83 c4 20             	add    $0x20,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	79 a3                	jns    80163c <dup+0x74>
	sys_page_unmap(0, newfd);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	56                   	push   %esi
  80169d:	6a 00                	push   $0x0
  80169f:	e8 13 fb ff ff       	call   8011b7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016a4:	83 c4 08             	add    $0x8,%esp
  8016a7:	57                   	push   %edi
  8016a8:	6a 00                	push   $0x0
  8016aa:	e8 08 fb ff ff       	call   8011b7 <sys_page_unmap>
	return r;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	eb b7                	jmp    80166b <dup+0xa3>

008016b4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	53                   	push   %ebx
  8016b8:	83 ec 14             	sub    $0x14,%esp
  8016bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c1:	50                   	push   %eax
  8016c2:	53                   	push   %ebx
  8016c3:	e8 7b fd ff ff       	call   801443 <fd_lookup>
  8016c8:	83 c4 08             	add    $0x8,%esp
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 3f                	js     80170e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cf:	83 ec 08             	sub    $0x8,%esp
  8016d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	ff 30                	pushl  (%eax)
  8016db:	e8 b9 fd ff ff       	call   801499 <dev_lookup>
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 27                	js     80170e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ea:	8b 42 08             	mov    0x8(%edx),%eax
  8016ed:	83 e0 03             	and    $0x3,%eax
  8016f0:	83 f8 01             	cmp    $0x1,%eax
  8016f3:	74 1e                	je     801713 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f8:	8b 40 08             	mov    0x8(%eax),%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	74 35                	je     801734 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	ff 75 10             	pushl  0x10(%ebp)
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	52                   	push   %edx
  801709:	ff d0                	call   *%eax
  80170b:	83 c4 10             	add    $0x10,%esp
}
  80170e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801711:	c9                   	leave  
  801712:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801713:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  801718:	8b 40 48             	mov    0x48(%eax),%eax
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	53                   	push   %ebx
  80171f:	50                   	push   %eax
  801720:	68 34 2d 80 00       	push   $0x802d34
  801725:	e8 f0 ef ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801732:	eb da                	jmp    80170e <read+0x5a>
		return -E_NOT_SUPP;
  801734:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801739:	eb d3                	jmp    80170e <read+0x5a>

0080173b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	57                   	push   %edi
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	83 ec 0c             	sub    $0xc,%esp
  801744:	8b 7d 08             	mov    0x8(%ebp),%edi
  801747:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80174a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80174f:	39 f3                	cmp    %esi,%ebx
  801751:	73 25                	jae    801778 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	89 f0                	mov    %esi,%eax
  801758:	29 d8                	sub    %ebx,%eax
  80175a:	50                   	push   %eax
  80175b:	89 d8                	mov    %ebx,%eax
  80175d:	03 45 0c             	add    0xc(%ebp),%eax
  801760:	50                   	push   %eax
  801761:	57                   	push   %edi
  801762:	e8 4d ff ff ff       	call   8016b4 <read>
		if (m < 0)
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 08                	js     801776 <readn+0x3b>
			return m;
		if (m == 0)
  80176e:	85 c0                	test   %eax,%eax
  801770:	74 06                	je     801778 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801772:	01 c3                	add    %eax,%ebx
  801774:	eb d9                	jmp    80174f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801776:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5f                   	pop    %edi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	53                   	push   %ebx
  801786:	83 ec 14             	sub    $0x14,%esp
  801789:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	53                   	push   %ebx
  801791:	e8 ad fc ff ff       	call   801443 <fd_lookup>
  801796:	83 c4 08             	add    $0x8,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 3a                	js     8017d7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	ff 30                	pushl  (%eax)
  8017a9:	e8 eb fc ff ff       	call   801499 <dev_lookup>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 22                	js     8017d7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017bc:	74 1e                	je     8017dc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8017c4:	85 d2                	test   %edx,%edx
  8017c6:	74 35                	je     8017fd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	ff 75 10             	pushl  0x10(%ebp)
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	50                   	push   %eax
  8017d2:	ff d2                	call   *%edx
  8017d4:	83 c4 10             	add    $0x10,%esp
}
  8017d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017dc:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8017e1:	8b 40 48             	mov    0x48(%eax),%eax
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	53                   	push   %ebx
  8017e8:	50                   	push   %eax
  8017e9:	68 50 2d 80 00       	push   $0x802d50
  8017ee:	e8 27 ef ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017fb:	eb da                	jmp    8017d7 <write+0x55>
		return -E_NOT_SUPP;
  8017fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801802:	eb d3                	jmp    8017d7 <write+0x55>

00801804 <seek>:

int
seek(int fdnum, off_t offset)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80180a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80180d:	50                   	push   %eax
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	e8 2d fc ff ff       	call   801443 <fd_lookup>
  801816:	83 c4 08             	add    $0x8,%esp
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 0e                	js     80182b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80181d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801823:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	53                   	push   %ebx
  801831:	83 ec 14             	sub    $0x14,%esp
  801834:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801837:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183a:	50                   	push   %eax
  80183b:	53                   	push   %ebx
  80183c:	e8 02 fc ff ff       	call   801443 <fd_lookup>
  801841:	83 c4 08             	add    $0x8,%esp
  801844:	85 c0                	test   %eax,%eax
  801846:	78 37                	js     80187f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801848:	83 ec 08             	sub    $0x8,%esp
  80184b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184e:	50                   	push   %eax
  80184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801852:	ff 30                	pushl  (%eax)
  801854:	e8 40 fc ff ff       	call   801499 <dev_lookup>
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 1f                	js     80187f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801863:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801867:	74 1b                	je     801884 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801869:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186c:	8b 52 18             	mov    0x18(%edx),%edx
  80186f:	85 d2                	test   %edx,%edx
  801871:	74 32                	je     8018a5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	ff 75 0c             	pushl  0xc(%ebp)
  801879:	50                   	push   %eax
  80187a:	ff d2                	call   *%edx
  80187c:	83 c4 10             	add    $0x10,%esp
}
  80187f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801882:	c9                   	leave  
  801883:	c3                   	ret    
			thisenv->env_id, fdnum);
  801884:	a1 b4 40 80 00       	mov    0x8040b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801889:	8b 40 48             	mov    0x48(%eax),%eax
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	53                   	push   %ebx
  801890:	50                   	push   %eax
  801891:	68 10 2d 80 00       	push   $0x802d10
  801896:	e8 7f ee ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a3:	eb da                	jmp    80187f <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018aa:	eb d3                	jmp    80187f <ftruncate+0x52>

008018ac <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 14             	sub    $0x14,%esp
  8018b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b9:	50                   	push   %eax
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 81 fb ff ff       	call   801443 <fd_lookup>
  8018c2:	83 c4 08             	add    $0x8,%esp
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	78 4b                	js     801914 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cf:	50                   	push   %eax
  8018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d3:	ff 30                	pushl  (%eax)
  8018d5:	e8 bf fb ff ff       	call   801499 <dev_lookup>
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 33                	js     801914 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018e8:	74 2f                	je     801919 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018ea:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018ed:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018f4:	00 00 00 
	stat->st_isdir = 0;
  8018f7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018fe:	00 00 00 
	stat->st_dev = dev;
  801901:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801907:	83 ec 08             	sub    $0x8,%esp
  80190a:	53                   	push   %ebx
  80190b:	ff 75 f0             	pushl  -0x10(%ebp)
  80190e:	ff 50 14             	call   *0x14(%eax)
  801911:	83 c4 10             	add    $0x10,%esp
}
  801914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801917:	c9                   	leave  
  801918:	c3                   	ret    
		return -E_NOT_SUPP;
  801919:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80191e:	eb f4                	jmp    801914 <fstat+0x68>

00801920 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801925:	83 ec 08             	sub    $0x8,%esp
  801928:	6a 00                	push   $0x0
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	e8 e7 01 00 00       	call   801b19 <open>
  801932:	89 c3                	mov    %eax,%ebx
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	85 c0                	test   %eax,%eax
  801939:	78 1b                	js     801956 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80193b:	83 ec 08             	sub    $0x8,%esp
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	50                   	push   %eax
  801942:	e8 65 ff ff ff       	call   8018ac <fstat>
  801947:	89 c6                	mov    %eax,%esi
	close(fd);
  801949:	89 1c 24             	mov    %ebx,(%esp)
  80194c:	e8 27 fc ff ff       	call   801578 <close>
	return r;
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	89 f3                	mov    %esi,%ebx
}
  801956:	89 d8                	mov    %ebx,%eax
  801958:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5d                   	pop    %ebp
  80195e:	c3                   	ret    

0080195f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	89 c6                	mov    %eax,%esi
  801966:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801968:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  80196f:	74 27                	je     801998 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801971:	6a 07                	push   $0x7
  801973:	68 00 50 80 00       	push   $0x805000
  801978:	56                   	push   %esi
  801979:	ff 35 ac 40 80 00    	pushl  0x8040ac
  80197f:	e8 d0 0b 00 00       	call   802554 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801984:	83 c4 0c             	add    $0xc,%esp
  801987:	6a 00                	push   $0x0
  801989:	53                   	push   %ebx
  80198a:	6a 00                	push   $0x0
  80198c:	e8 5c 0b 00 00       	call   8024ed <ipc_recv>
}
  801991:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801998:	83 ec 0c             	sub    $0xc,%esp
  80199b:	6a 01                	push   $0x1
  80199d:	e8 06 0c 00 00       	call   8025a8 <ipc_find_env>
  8019a2:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	eb c5                	jmp    801971 <fsipc+0x12>

008019ac <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	b8 02 00 00 00       	mov    $0x2,%eax
  8019cf:	e8 8b ff ff ff       	call   80195f <fsipc>
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <devfile_flush>:
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ec:	b8 06 00 00 00       	mov    $0x6,%eax
  8019f1:	e8 69 ff ff ff       	call   80195f <fsipc>
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <devfile_stat>:
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 04             	sub    $0x4,%esp
  8019ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8b 40 0c             	mov    0xc(%eax),%eax
  801a08:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a12:	b8 05 00 00 00       	mov    $0x5,%eax
  801a17:	e8 43 ff ff ff       	call   80195f <fsipc>
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 2c                	js     801a4c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a20:	83 ec 08             	sub    $0x8,%esp
  801a23:	68 00 50 80 00       	push   $0x805000
  801a28:	53                   	push   %ebx
  801a29:	e8 0b f3 ff ff       	call   800d39 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a2e:	a1 80 50 80 00       	mov    0x805080,%eax
  801a33:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a39:	a1 84 50 80 00       	mov    0x805084,%eax
  801a3e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <devfile_write>:
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 0c             	sub    $0xc,%esp
  801a57:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a5f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a64:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a67:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6a:	8b 52 0c             	mov    0xc(%edx),%edx
  801a6d:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801a73:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a78:	50                   	push   %eax
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	68 08 50 80 00       	push   $0x805008
  801a81:	e8 41 f4 ff ff       	call   800ec7 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801a86:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8b:	b8 04 00 00 00       	mov    $0x4,%eax
  801a90:	e8 ca fe ff ff       	call   80195f <fsipc>
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <devfile_read>:
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
  801a9c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aaa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab5:	b8 03 00 00 00       	mov    $0x3,%eax
  801aba:	e8 a0 fe ff ff       	call   80195f <fsipc>
  801abf:	89 c3                	mov    %eax,%ebx
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	78 1f                	js     801ae4 <devfile_read+0x4d>
	assert(r <= n);
  801ac5:	39 f0                	cmp    %esi,%eax
  801ac7:	77 24                	ja     801aed <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ac9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ace:	7f 33                	jg     801b03 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ad0:	83 ec 04             	sub    $0x4,%esp
  801ad3:	50                   	push   %eax
  801ad4:	68 00 50 80 00       	push   $0x805000
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	e8 e6 f3 ff ff       	call   800ec7 <memmove>
	return r;
  801ae1:	83 c4 10             	add    $0x10,%esp
}
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5e                   	pop    %esi
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    
	assert(r <= n);
  801aed:	68 84 2d 80 00       	push   $0x802d84
  801af2:	68 8b 2d 80 00       	push   $0x802d8b
  801af7:	6a 7b                	push   $0x7b
  801af9:	68 a0 2d 80 00       	push   $0x802da0
  801afe:	e8 3c eb ff ff       	call   80063f <_panic>
	assert(r <= PGSIZE);
  801b03:	68 ab 2d 80 00       	push   $0x802dab
  801b08:	68 8b 2d 80 00       	push   $0x802d8b
  801b0d:	6a 7c                	push   $0x7c
  801b0f:	68 a0 2d 80 00       	push   $0x802da0
  801b14:	e8 26 eb ff ff       	call   80063f <_panic>

00801b19 <open>:
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	56                   	push   %esi
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 1c             	sub    $0x1c,%esp
  801b21:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b24:	56                   	push   %esi
  801b25:	e8 d8 f1 ff ff       	call   800d02 <strlen>
  801b2a:	83 c4 10             	add    $0x10,%esp
  801b2d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b32:	7f 6c                	jg     801ba0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3a:	50                   	push   %eax
  801b3b:	e8 b4 f8 ff ff       	call   8013f4 <fd_alloc>
  801b40:	89 c3                	mov    %eax,%ebx
  801b42:	83 c4 10             	add    $0x10,%esp
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 3c                	js     801b85 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	56                   	push   %esi
  801b4d:	68 00 50 80 00       	push   $0x805000
  801b52:	e8 e2 f1 ff ff       	call   800d39 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	e8 f3 fd ff ff       	call   80195f <fsipc>
  801b6c:	89 c3                	mov    %eax,%ebx
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 19                	js     801b8e <open+0x75>
	return fd2num(fd);
  801b75:	83 ec 0c             	sub    $0xc,%esp
  801b78:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7b:	e8 4d f8 ff ff       	call   8013cd <fd2num>
  801b80:	89 c3                	mov    %eax,%ebx
  801b82:	83 c4 10             	add    $0x10,%esp
}
  801b85:	89 d8                	mov    %ebx,%eax
  801b87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8a:	5b                   	pop    %ebx
  801b8b:	5e                   	pop    %esi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    
		fd_close(fd, 0);
  801b8e:	83 ec 08             	sub    $0x8,%esp
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 f4             	pushl  -0xc(%ebp)
  801b96:	e8 54 f9 ff ff       	call   8014ef <fd_close>
		return r;
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	eb e5                	jmp    801b85 <open+0x6c>
		return -E_BAD_PATH;
  801ba0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ba5:	eb de                	jmp    801b85 <open+0x6c>

00801ba7 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bad:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb2:	b8 08 00 00 00       	mov    $0x8,%eax
  801bb7:	e8 a3 fd ff ff       	call   80195f <fsipc>
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801bc4:	68 b7 2d 80 00       	push   $0x802db7
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	e8 68 f1 ff ff       	call   800d39 <strcpy>
	return 0;
}
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <devsock_close>:
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	53                   	push   %ebx
  801bdc:	83 ec 10             	sub    $0x10,%esp
  801bdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801be2:	53                   	push   %ebx
  801be3:	e8 f9 09 00 00       	call   8025e1 <pageref>
  801be8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801beb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801bf0:	83 f8 01             	cmp    $0x1,%eax
  801bf3:	74 07                	je     801bfc <devsock_close+0x24>
}
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bfc:	83 ec 0c             	sub    $0xc,%esp
  801bff:	ff 73 0c             	pushl  0xc(%ebx)
  801c02:	e8 b7 02 00 00       	call   801ebe <nsipc_close>
  801c07:	89 c2                	mov    %eax,%edx
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	eb e7                	jmp    801bf5 <devsock_close+0x1d>

00801c0e <devsock_write>:
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 10             	pushl  0x10(%ebp)
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	ff 70 0c             	pushl  0xc(%eax)
  801c22:	e8 74 03 00 00       	call   801f9b <nsipc_send>
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <devsock_read>:
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	ff 75 10             	pushl  0x10(%ebp)
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	ff 70 0c             	pushl  0xc(%eax)
  801c3d:	e8 ed 02 00 00       	call   801f2f <nsipc_recv>
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <fd2sockid>:
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c4a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c4d:	52                   	push   %edx
  801c4e:	50                   	push   %eax
  801c4f:	e8 ef f7 ff ff       	call   801443 <fd_lookup>
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 10                	js     801c6b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c64:	39 08                	cmp    %ecx,(%eax)
  801c66:	75 05                	jne    801c6d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c68:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    
		return -E_NOT_SUPP;
  801c6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c72:	eb f7                	jmp    801c6b <fd2sockid+0x27>

00801c74 <alloc_sockfd>:
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	56                   	push   %esi
  801c78:	53                   	push   %ebx
  801c79:	83 ec 1c             	sub    $0x1c,%esp
  801c7c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c81:	50                   	push   %eax
  801c82:	e8 6d f7 ff ff       	call   8013f4 <fd_alloc>
  801c87:	89 c3                	mov    %eax,%ebx
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 43                	js     801cd3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	68 07 04 00 00       	push   $0x407
  801c98:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9b:	6a 00                	push   $0x0
  801c9d:	e8 90 f4 ff ff       	call   801132 <sys_page_alloc>
  801ca2:	89 c3                	mov    %eax,%ebx
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	78 28                	js     801cd3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cae:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cb4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cc0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cc3:	83 ec 0c             	sub    $0xc,%esp
  801cc6:	50                   	push   %eax
  801cc7:	e8 01 f7 ff ff       	call   8013cd <fd2num>
  801ccc:	89 c3                	mov    %eax,%ebx
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	eb 0c                	jmp    801cdf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	56                   	push   %esi
  801cd7:	e8 e2 01 00 00       	call   801ebe <nsipc_close>
		return r;
  801cdc:	83 c4 10             	add    $0x10,%esp
}
  801cdf:	89 d8                	mov    %ebx,%eax
  801ce1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    

00801ce8 <accept>:
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	e8 4e ff ff ff       	call   801c44 <fd2sockid>
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	78 1b                	js     801d15 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	ff 75 10             	pushl  0x10(%ebp)
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	50                   	push   %eax
  801d04:	e8 0e 01 00 00       	call   801e17 <nsipc_accept>
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	78 05                	js     801d15 <accept+0x2d>
	return alloc_sockfd(r);
  801d10:	e8 5f ff ff ff       	call   801c74 <alloc_sockfd>
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <bind>:
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	e8 1f ff ff ff       	call   801c44 <fd2sockid>
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 12                	js     801d3b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	ff 75 10             	pushl  0x10(%ebp)
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	50                   	push   %eax
  801d33:	e8 2f 01 00 00       	call   801e67 <nsipc_bind>
  801d38:	83 c4 10             	add    $0x10,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <shutdown>:
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	e8 f9 fe ff ff       	call   801c44 <fd2sockid>
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	78 0f                	js     801d5e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801d4f:	83 ec 08             	sub    $0x8,%esp
  801d52:	ff 75 0c             	pushl  0xc(%ebp)
  801d55:	50                   	push   %eax
  801d56:	e8 41 01 00 00       	call   801e9c <nsipc_shutdown>
  801d5b:	83 c4 10             	add    $0x10,%esp
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <connect>:
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	e8 d6 fe ff ff       	call   801c44 <fd2sockid>
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	78 12                	js     801d84 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801d72:	83 ec 04             	sub    $0x4,%esp
  801d75:	ff 75 10             	pushl  0x10(%ebp)
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	50                   	push   %eax
  801d7c:	e8 57 01 00 00       	call   801ed8 <nsipc_connect>
  801d81:	83 c4 10             	add    $0x10,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <listen>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	e8 b0 fe ff ff       	call   801c44 <fd2sockid>
  801d94:	85 c0                	test   %eax,%eax
  801d96:	78 0f                	js     801da7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801d98:	83 ec 08             	sub    $0x8,%esp
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	50                   	push   %eax
  801d9f:	e8 69 01 00 00       	call   801f0d <nsipc_listen>
  801da4:	83 c4 10             	add    $0x10,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801daf:	ff 75 10             	pushl  0x10(%ebp)
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	e8 3c 02 00 00       	call   801ff9 <nsipc_socket>
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	78 05                	js     801dc9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801dc4:	e8 ab fe ff ff       	call   801c74 <alloc_sockfd>
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801dd4:	83 3d b0 40 80 00 00 	cmpl   $0x0,0x8040b0
  801ddb:	74 26                	je     801e03 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ddd:	6a 07                	push   $0x7
  801ddf:	68 00 60 80 00       	push   $0x806000
  801de4:	53                   	push   %ebx
  801de5:	ff 35 b0 40 80 00    	pushl  0x8040b0
  801deb:	e8 64 07 00 00       	call   802554 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801df0:	83 c4 0c             	add    $0xc,%esp
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	e8 ef 06 00 00       	call   8024ed <ipc_recv>
}
  801dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	6a 02                	push   $0x2
  801e08:	e8 9b 07 00 00       	call   8025a8 <ipc_find_env>
  801e0d:	a3 b0 40 80 00       	mov    %eax,0x8040b0
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	eb c6                	jmp    801ddd <nsipc+0x12>

00801e17 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	56                   	push   %esi
  801e1b:	53                   	push   %ebx
  801e1c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e27:	8b 06                	mov    (%esi),%eax
  801e29:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e33:	e8 93 ff ff ff       	call   801dcb <nsipc>
  801e38:	89 c3                	mov    %eax,%ebx
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 20                	js     801e5e <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	ff 35 10 60 80 00    	pushl  0x806010
  801e47:	68 00 60 80 00       	push   $0x806000
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	e8 73 f0 ff ff       	call   800ec7 <memmove>
		*addrlen = ret->ret_addrlen;
  801e54:	a1 10 60 80 00       	mov    0x806010,%eax
  801e59:	89 06                	mov    %eax,(%esi)
  801e5b:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801e5e:	89 d8                	mov    %ebx,%eax
  801e60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5d                   	pop    %ebp
  801e66:	c3                   	ret    

00801e67 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	53                   	push   %ebx
  801e6b:	83 ec 08             	sub    $0x8,%esp
  801e6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e79:	53                   	push   %ebx
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	68 04 60 80 00       	push   $0x806004
  801e82:	e8 40 f0 ff ff       	call   800ec7 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e87:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e8d:	b8 02 00 00 00       	mov    $0x2,%eax
  801e92:	e8 34 ff ff ff       	call   801dcb <nsipc>
}
  801e97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ead:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801eb2:	b8 03 00 00 00       	mov    $0x3,%eax
  801eb7:	e8 0f ff ff ff       	call   801dcb <nsipc>
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <nsipc_close>:

int
nsipc_close(int s)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ecc:	b8 04 00 00 00       	mov    $0x4,%eax
  801ed1:	e8 f5 fe ff ff       	call   801dcb <nsipc>
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	53                   	push   %ebx
  801edc:	83 ec 08             	sub    $0x8,%esp
  801edf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801eea:	53                   	push   %ebx
  801eeb:	ff 75 0c             	pushl  0xc(%ebp)
  801eee:	68 04 60 80 00       	push   $0x806004
  801ef3:	e8 cf ef ff ff       	call   800ec7 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ef8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801efe:	b8 05 00 00 00       	mov    $0x5,%eax
  801f03:	e8 c3 fe ff ff       	call   801dcb <nsipc>
}
  801f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f23:	b8 06 00 00 00       	mov    $0x6,%eax
  801f28:	e8 9e fe ff ff       	call   801dcb <nsipc>
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	56                   	push   %esi
  801f33:	53                   	push   %ebx
  801f34:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f3f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f45:	8b 45 14             	mov    0x14(%ebp),%eax
  801f48:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f4d:	b8 07 00 00 00       	mov    $0x7,%eax
  801f52:	e8 74 fe ff ff       	call   801dcb <nsipc>
  801f57:	89 c3                	mov    %eax,%ebx
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 1f                	js     801f7c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f5d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f62:	7f 21                	jg     801f85 <nsipc_recv+0x56>
  801f64:	39 c6                	cmp    %eax,%esi
  801f66:	7c 1d                	jl     801f85 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	50                   	push   %eax
  801f6c:	68 00 60 80 00       	push   $0x806000
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	e8 4e ef ff ff       	call   800ec7 <memmove>
  801f79:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f85:	68 c3 2d 80 00       	push   $0x802dc3
  801f8a:	68 8b 2d 80 00       	push   $0x802d8b
  801f8f:	6a 62                	push   $0x62
  801f91:	68 d8 2d 80 00       	push   $0x802dd8
  801f96:	e8 a4 e6 ff ff       	call   80063f <_panic>

00801f9b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	53                   	push   %ebx
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fb3:	7f 2e                	jg     801fe3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fb5:	83 ec 04             	sub    $0x4,%esp
  801fb8:	53                   	push   %ebx
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	68 0c 60 80 00       	push   $0x80600c
  801fc1:	e8 01 ef ff ff       	call   800ec7 <memmove>
	nsipcbuf.send.req_size = size;
  801fc6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  801fcf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fd4:	b8 08 00 00 00       	mov    $0x8,%eax
  801fd9:	e8 ed fd ff ff       	call   801dcb <nsipc>
}
  801fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    
	assert(size < 1600);
  801fe3:	68 e4 2d 80 00       	push   $0x802de4
  801fe8:	68 8b 2d 80 00       	push   $0x802d8b
  801fed:	6a 6d                	push   $0x6d
  801fef:	68 d8 2d 80 00       	push   $0x802dd8
  801ff4:	e8 46 e6 ff ff       	call   80063f <_panic>

00801ff9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80200f:	8b 45 10             	mov    0x10(%ebp),%eax
  802012:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802017:	b8 09 00 00 00       	mov    $0x9,%eax
  80201c:	e8 aa fd ff ff       	call   801dcb <nsipc>
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	e8 a7 f3 ff ff       	call   8013dd <fd2data>
  802036:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802038:	83 c4 08             	add    $0x8,%esp
  80203b:	68 f0 2d 80 00       	push   $0x802df0
  802040:	53                   	push   %ebx
  802041:	e8 f3 ec ff ff       	call   800d39 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802046:	8b 46 04             	mov    0x4(%esi),%eax
  802049:	2b 06                	sub    (%esi),%eax
  80204b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802051:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802058:	00 00 00 
	stat->st_dev = &devpipe;
  80205b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  802062:	30 80 00 
	return 0;
}
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	53                   	push   %ebx
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80207b:	53                   	push   %ebx
  80207c:	6a 00                	push   $0x0
  80207e:	e8 34 f1 ff ff       	call   8011b7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802083:	89 1c 24             	mov    %ebx,(%esp)
  802086:	e8 52 f3 ff ff       	call   8013dd <fd2data>
  80208b:	83 c4 08             	add    $0x8,%esp
  80208e:	50                   	push   %eax
  80208f:	6a 00                	push   $0x0
  802091:	e8 21 f1 ff ff       	call   8011b7 <sys_page_unmap>
}
  802096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <_pipeisclosed>:
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	57                   	push   %edi
  80209f:	56                   	push   %esi
  8020a0:	53                   	push   %ebx
  8020a1:	83 ec 1c             	sub    $0x1c,%esp
  8020a4:	89 c7                	mov    %eax,%edi
  8020a6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020a8:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  8020ad:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	57                   	push   %edi
  8020b4:	e8 28 05 00 00       	call   8025e1 <pageref>
  8020b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020bc:	89 34 24             	mov    %esi,(%esp)
  8020bf:	e8 1d 05 00 00       	call   8025e1 <pageref>
		nn = thisenv->env_runs;
  8020c4:	8b 15 b4 40 80 00    	mov    0x8040b4,%edx
  8020ca:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	39 cb                	cmp    %ecx,%ebx
  8020d2:	74 1b                	je     8020ef <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020d4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020d7:	75 cf                	jne    8020a8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020d9:	8b 42 58             	mov    0x58(%edx),%eax
  8020dc:	6a 01                	push   $0x1
  8020de:	50                   	push   %eax
  8020df:	53                   	push   %ebx
  8020e0:	68 f7 2d 80 00       	push   $0x802df7
  8020e5:	e8 30 e6 ff ff       	call   80071a <cprintf>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	eb b9                	jmp    8020a8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020ef:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020f2:	0f 94 c0             	sete   %al
  8020f5:	0f b6 c0             	movzbl %al,%eax
}
  8020f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5f                   	pop    %edi
  8020fe:	5d                   	pop    %ebp
  8020ff:	c3                   	ret    

00802100 <devpipe_write>:
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	57                   	push   %edi
  802104:	56                   	push   %esi
  802105:	53                   	push   %ebx
  802106:	83 ec 28             	sub    $0x28,%esp
  802109:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80210c:	56                   	push   %esi
  80210d:	e8 cb f2 ff ff       	call   8013dd <fd2data>
  802112:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	bf 00 00 00 00       	mov    $0x0,%edi
  80211c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80211f:	74 4f                	je     802170 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802121:	8b 43 04             	mov    0x4(%ebx),%eax
  802124:	8b 0b                	mov    (%ebx),%ecx
  802126:	8d 51 20             	lea    0x20(%ecx),%edx
  802129:	39 d0                	cmp    %edx,%eax
  80212b:	72 14                	jb     802141 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80212d:	89 da                	mov    %ebx,%edx
  80212f:	89 f0                	mov    %esi,%eax
  802131:	e8 65 ff ff ff       	call   80209b <_pipeisclosed>
  802136:	85 c0                	test   %eax,%eax
  802138:	75 3a                	jne    802174 <devpipe_write+0x74>
			sys_yield();
  80213a:	e8 d4 ef ff ff       	call   801113 <sys_yield>
  80213f:	eb e0                	jmp    802121 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802141:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802144:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802148:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80214b:	89 c2                	mov    %eax,%edx
  80214d:	c1 fa 1f             	sar    $0x1f,%edx
  802150:	89 d1                	mov    %edx,%ecx
  802152:	c1 e9 1b             	shr    $0x1b,%ecx
  802155:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802158:	83 e2 1f             	and    $0x1f,%edx
  80215b:	29 ca                	sub    %ecx,%edx
  80215d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802161:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802165:	83 c0 01             	add    $0x1,%eax
  802168:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80216b:	83 c7 01             	add    $0x1,%edi
  80216e:	eb ac                	jmp    80211c <devpipe_write+0x1c>
	return i;
  802170:	89 f8                	mov    %edi,%eax
  802172:	eb 05                	jmp    802179 <devpipe_write+0x79>
				return 0;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <devpipe_read>:
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	57                   	push   %edi
  802185:	56                   	push   %esi
  802186:	53                   	push   %ebx
  802187:	83 ec 18             	sub    $0x18,%esp
  80218a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80218d:	57                   	push   %edi
  80218e:	e8 4a f2 ff ff       	call   8013dd <fd2data>
  802193:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	be 00 00 00 00       	mov    $0x0,%esi
  80219d:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a0:	74 47                	je     8021e9 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8021a2:	8b 03                	mov    (%ebx),%eax
  8021a4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021a7:	75 22                	jne    8021cb <devpipe_read+0x4a>
			if (i > 0)
  8021a9:	85 f6                	test   %esi,%esi
  8021ab:	75 14                	jne    8021c1 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8021ad:	89 da                	mov    %ebx,%edx
  8021af:	89 f8                	mov    %edi,%eax
  8021b1:	e8 e5 fe ff ff       	call   80209b <_pipeisclosed>
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	75 33                	jne    8021ed <devpipe_read+0x6c>
			sys_yield();
  8021ba:	e8 54 ef ff ff       	call   801113 <sys_yield>
  8021bf:	eb e1                	jmp    8021a2 <devpipe_read+0x21>
				return i;
  8021c1:	89 f0                	mov    %esi,%eax
}
  8021c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c6:	5b                   	pop    %ebx
  8021c7:	5e                   	pop    %esi
  8021c8:	5f                   	pop    %edi
  8021c9:	5d                   	pop    %ebp
  8021ca:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021cb:	99                   	cltd   
  8021cc:	c1 ea 1b             	shr    $0x1b,%edx
  8021cf:	01 d0                	add    %edx,%eax
  8021d1:	83 e0 1f             	and    $0x1f,%eax
  8021d4:	29 d0                	sub    %edx,%eax
  8021d6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021de:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021e1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021e4:	83 c6 01             	add    $0x1,%esi
  8021e7:	eb b4                	jmp    80219d <devpipe_read+0x1c>
	return i;
  8021e9:	89 f0                	mov    %esi,%eax
  8021eb:	eb d6                	jmp    8021c3 <devpipe_read+0x42>
				return 0;
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	eb cf                	jmp    8021c3 <devpipe_read+0x42>

008021f4 <pipe>:
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	56                   	push   %esi
  8021f8:	53                   	push   %ebx
  8021f9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ff:	50                   	push   %eax
  802200:	e8 ef f1 ff ff       	call   8013f4 <fd_alloc>
  802205:	89 c3                	mov    %eax,%ebx
  802207:	83 c4 10             	add    $0x10,%esp
  80220a:	85 c0                	test   %eax,%eax
  80220c:	78 5b                	js     802269 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80220e:	83 ec 04             	sub    $0x4,%esp
  802211:	68 07 04 00 00       	push   $0x407
  802216:	ff 75 f4             	pushl  -0xc(%ebp)
  802219:	6a 00                	push   $0x0
  80221b:	e8 12 ef ff ff       	call   801132 <sys_page_alloc>
  802220:	89 c3                	mov    %eax,%ebx
  802222:	83 c4 10             	add    $0x10,%esp
  802225:	85 c0                	test   %eax,%eax
  802227:	78 40                	js     802269 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802229:	83 ec 0c             	sub    $0xc,%esp
  80222c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80222f:	50                   	push   %eax
  802230:	e8 bf f1 ff ff       	call   8013f4 <fd_alloc>
  802235:	89 c3                	mov    %eax,%ebx
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	85 c0                	test   %eax,%eax
  80223c:	78 1b                	js     802259 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80223e:	83 ec 04             	sub    $0x4,%esp
  802241:	68 07 04 00 00       	push   $0x407
  802246:	ff 75 f0             	pushl  -0x10(%ebp)
  802249:	6a 00                	push   $0x0
  80224b:	e8 e2 ee ff ff       	call   801132 <sys_page_alloc>
  802250:	89 c3                	mov    %eax,%ebx
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	85 c0                	test   %eax,%eax
  802257:	79 19                	jns    802272 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802259:	83 ec 08             	sub    $0x8,%esp
  80225c:	ff 75 f4             	pushl  -0xc(%ebp)
  80225f:	6a 00                	push   $0x0
  802261:	e8 51 ef ff ff       	call   8011b7 <sys_page_unmap>
  802266:	83 c4 10             	add    $0x10,%esp
}
  802269:	89 d8                	mov    %ebx,%eax
  80226b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80226e:	5b                   	pop    %ebx
  80226f:	5e                   	pop    %esi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    
	va = fd2data(fd0);
  802272:	83 ec 0c             	sub    $0xc,%esp
  802275:	ff 75 f4             	pushl  -0xc(%ebp)
  802278:	e8 60 f1 ff ff       	call   8013dd <fd2data>
  80227d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80227f:	83 c4 0c             	add    $0xc,%esp
  802282:	68 07 04 00 00       	push   $0x407
  802287:	50                   	push   %eax
  802288:	6a 00                	push   $0x0
  80228a:	e8 a3 ee ff ff       	call   801132 <sys_page_alloc>
  80228f:	89 c3                	mov    %eax,%ebx
  802291:	83 c4 10             	add    $0x10,%esp
  802294:	85 c0                	test   %eax,%eax
  802296:	0f 88 8c 00 00 00    	js     802328 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229c:	83 ec 0c             	sub    $0xc,%esp
  80229f:	ff 75 f0             	pushl  -0x10(%ebp)
  8022a2:	e8 36 f1 ff ff       	call   8013dd <fd2data>
  8022a7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022ae:	50                   	push   %eax
  8022af:	6a 00                	push   $0x0
  8022b1:	56                   	push   %esi
  8022b2:	6a 00                	push   $0x0
  8022b4:	e8 bc ee ff ff       	call   801175 <sys_page_map>
  8022b9:	89 c3                	mov    %eax,%ebx
  8022bb:	83 c4 20             	add    $0x20,%esp
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 58                	js     80231a <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022cb:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8022d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022da:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022e0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022ec:	83 ec 0c             	sub    $0xc,%esp
  8022ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f2:	e8 d6 f0 ff ff       	call   8013cd <fd2num>
  8022f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022fa:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022fc:	83 c4 04             	add    $0x4,%esp
  8022ff:	ff 75 f0             	pushl  -0x10(%ebp)
  802302:	e8 c6 f0 ff ff       	call   8013cd <fd2num>
  802307:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	bb 00 00 00 00       	mov    $0x0,%ebx
  802315:	e9 4f ff ff ff       	jmp    802269 <pipe+0x75>
	sys_page_unmap(0, va);
  80231a:	83 ec 08             	sub    $0x8,%esp
  80231d:	56                   	push   %esi
  80231e:	6a 00                	push   $0x0
  802320:	e8 92 ee ff ff       	call   8011b7 <sys_page_unmap>
  802325:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802328:	83 ec 08             	sub    $0x8,%esp
  80232b:	ff 75 f0             	pushl  -0x10(%ebp)
  80232e:	6a 00                	push   $0x0
  802330:	e8 82 ee ff ff       	call   8011b7 <sys_page_unmap>
  802335:	83 c4 10             	add    $0x10,%esp
  802338:	e9 1c ff ff ff       	jmp    802259 <pipe+0x65>

0080233d <pipeisclosed>:
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802343:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802346:	50                   	push   %eax
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	e8 f4 f0 ff ff       	call   801443 <fd_lookup>
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	85 c0                	test   %eax,%eax
  802354:	78 18                	js     80236e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802356:	83 ec 0c             	sub    $0xc,%esp
  802359:	ff 75 f4             	pushl  -0xc(%ebp)
  80235c:	e8 7c f0 ff ff       	call   8013dd <fd2data>
	return _pipeisclosed(fd, p);
  802361:	89 c2                	mov    %eax,%edx
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	e8 30 fd ff ff       	call   80209b <_pipeisclosed>
  80236b:	83 c4 10             	add    $0x10,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    

0080237a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802380:	68 0f 2e 80 00       	push   $0x802e0f
  802385:	ff 75 0c             	pushl  0xc(%ebp)
  802388:	e8 ac e9 ff ff       	call   800d39 <strcpy>
	return 0;
}
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <devcons_write>:
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	57                   	push   %edi
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
  80239a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023a0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023a5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023ab:	eb 2f                	jmp    8023dc <devcons_write+0x48>
		m = n - tot;
  8023ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023b0:	29 f3                	sub    %esi,%ebx
  8023b2:	83 fb 7f             	cmp    $0x7f,%ebx
  8023b5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023ba:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023bd:	83 ec 04             	sub    $0x4,%esp
  8023c0:	53                   	push   %ebx
  8023c1:	89 f0                	mov    %esi,%eax
  8023c3:	03 45 0c             	add    0xc(%ebp),%eax
  8023c6:	50                   	push   %eax
  8023c7:	57                   	push   %edi
  8023c8:	e8 fa ea ff ff       	call   800ec7 <memmove>
		sys_cputs(buf, m);
  8023cd:	83 c4 08             	add    $0x8,%esp
  8023d0:	53                   	push   %ebx
  8023d1:	57                   	push   %edi
  8023d2:	e8 9f ec ff ff       	call   801076 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023d7:	01 de                	add    %ebx,%esi
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023df:	72 cc                	jb     8023ad <devcons_write+0x19>
}
  8023e1:	89 f0                	mov    %esi,%eax
  8023e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023e6:	5b                   	pop    %ebx
  8023e7:	5e                   	pop    %esi
  8023e8:	5f                   	pop    %edi
  8023e9:	5d                   	pop    %ebp
  8023ea:	c3                   	ret    

008023eb <devcons_read>:
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 08             	sub    $0x8,%esp
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023fa:	75 07                	jne    802403 <devcons_read+0x18>
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    
		sys_yield();
  8023fe:	e8 10 ed ff ff       	call   801113 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802403:	e8 8c ec ff ff       	call   801094 <sys_cgetc>
  802408:	85 c0                	test   %eax,%eax
  80240a:	74 f2                	je     8023fe <devcons_read+0x13>
	if (c < 0)
  80240c:	85 c0                	test   %eax,%eax
  80240e:	78 ec                	js     8023fc <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802410:	83 f8 04             	cmp    $0x4,%eax
  802413:	74 0c                	je     802421 <devcons_read+0x36>
	*(char*)vbuf = c;
  802415:	8b 55 0c             	mov    0xc(%ebp),%edx
  802418:	88 02                	mov    %al,(%edx)
	return 1;
  80241a:	b8 01 00 00 00       	mov    $0x1,%eax
  80241f:	eb db                	jmp    8023fc <devcons_read+0x11>
		return 0;
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	eb d4                	jmp    8023fc <devcons_read+0x11>

00802428 <cputchar>:
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802434:	6a 01                	push   $0x1
  802436:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802439:	50                   	push   %eax
  80243a:	e8 37 ec ff ff       	call   801076 <sys_cputs>
}
  80243f:	83 c4 10             	add    $0x10,%esp
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <getchar>:
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80244a:	6a 01                	push   $0x1
  80244c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80244f:	50                   	push   %eax
  802450:	6a 00                	push   $0x0
  802452:	e8 5d f2 ff ff       	call   8016b4 <read>
	if (r < 0)
  802457:	83 c4 10             	add    $0x10,%esp
  80245a:	85 c0                	test   %eax,%eax
  80245c:	78 08                	js     802466 <getchar+0x22>
	if (r < 1)
  80245e:	85 c0                	test   %eax,%eax
  802460:	7e 06                	jle    802468 <getchar+0x24>
	return c;
  802462:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    
		return -E_EOF;
  802468:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80246d:	eb f7                	jmp    802466 <getchar+0x22>

0080246f <iscons>:
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802475:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802478:	50                   	push   %eax
  802479:	ff 75 08             	pushl  0x8(%ebp)
  80247c:	e8 c2 ef ff ff       	call   801443 <fd_lookup>
  802481:	83 c4 10             	add    $0x10,%esp
  802484:	85 c0                	test   %eax,%eax
  802486:	78 11                	js     802499 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802491:	39 10                	cmp    %edx,(%eax)
  802493:	0f 94 c0             	sete   %al
  802496:	0f b6 c0             	movzbl %al,%eax
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <opencons>:
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024a4:	50                   	push   %eax
  8024a5:	e8 4a ef ff ff       	call   8013f4 <fd_alloc>
  8024aa:	83 c4 10             	add    $0x10,%esp
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	78 3a                	js     8024eb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024b1:	83 ec 04             	sub    $0x4,%esp
  8024b4:	68 07 04 00 00       	push   $0x407
  8024b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024bc:	6a 00                	push   $0x0
  8024be:	e8 6f ec ff ff       	call   801132 <sys_page_alloc>
  8024c3:	83 c4 10             	add    $0x10,%esp
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	78 21                	js     8024eb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024d3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024df:	83 ec 0c             	sub    $0xc,%esp
  8024e2:	50                   	push   %eax
  8024e3:	e8 e5 ee ff ff       	call   8013cd <fd2num>
  8024e8:	83 c4 10             	add    $0x10,%esp
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	56                   	push   %esi
  8024f1:	53                   	push   %ebx
  8024f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8024f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8024fb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8024fd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802502:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	50                   	push   %eax
  802509:	e8 d4 ed ff ff       	call   8012e2 <sys_ipc_recv>
	if (from_env_store)
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	85 f6                	test   %esi,%esi
  802513:	74 14                	je     802529 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802515:	ba 00 00 00 00       	mov    $0x0,%edx
  80251a:	85 c0                	test   %eax,%eax
  80251c:	78 09                	js     802527 <ipc_recv+0x3a>
  80251e:	8b 15 b4 40 80 00    	mov    0x8040b4,%edx
  802524:	8b 52 74             	mov    0x74(%edx),%edx
  802527:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802529:	85 db                	test   %ebx,%ebx
  80252b:	74 14                	je     802541 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  80252d:	ba 00 00 00 00       	mov    $0x0,%edx
  802532:	85 c0                	test   %eax,%eax
  802534:	78 09                	js     80253f <ipc_recv+0x52>
  802536:	8b 15 b4 40 80 00    	mov    0x8040b4,%edx
  80253c:	8b 52 78             	mov    0x78(%edx),%edx
  80253f:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802541:	85 c0                	test   %eax,%eax
  802543:	78 08                	js     80254d <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802545:	a1 b4 40 80 00       	mov    0x8040b4,%eax
  80254a:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  80254d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802550:	5b                   	pop    %ebx
  802551:	5e                   	pop    %esi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    

00802554 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	57                   	push   %edi
  802558:	56                   	push   %esi
  802559:	53                   	push   %ebx
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802560:	8b 75 0c             	mov    0xc(%ebp),%esi
  802563:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802566:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802568:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80256d:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802570:	ff 75 14             	pushl  0x14(%ebp)
  802573:	53                   	push   %ebx
  802574:	56                   	push   %esi
  802575:	57                   	push   %edi
  802576:	e8 44 ed ff ff       	call   8012bf <sys_ipc_try_send>
		if (ret == 0)
  80257b:	83 c4 10             	add    $0x10,%esp
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 1e                	je     8025a0 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802582:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802585:	75 07                	jne    80258e <ipc_send+0x3a>
			sys_yield();
  802587:	e8 87 eb ff ff       	call   801113 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80258c:	eb e2                	jmp    802570 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80258e:	50                   	push   %eax
  80258f:	68 1b 2e 80 00       	push   $0x802e1b
  802594:	6a 3d                	push   $0x3d
  802596:	68 2f 2e 80 00       	push   $0x802e2f
  80259b:	e8 9f e0 ff ff       	call   80063f <_panic>
	}
	// panic("ipc_send not implemented");
}
  8025a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025a3:	5b                   	pop    %ebx
  8025a4:	5e                   	pop    %esi
  8025a5:	5f                   	pop    %edi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    

008025a8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025b3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025b6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025bc:	8b 52 50             	mov    0x50(%edx),%edx
  8025bf:	39 ca                	cmp    %ecx,%edx
  8025c1:	74 11                	je     8025d4 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025c3:	83 c0 01             	add    $0x1,%eax
  8025c6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025cb:	75 e6                	jne    8025b3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d2:	eb 0b                	jmp    8025df <ipc_find_env+0x37>
			return envs[i].env_id;
  8025d4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025dc:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025df:	5d                   	pop    %ebp
  8025e0:	c3                   	ret    

008025e1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025e7:	89 d0                	mov    %edx,%eax
  8025e9:	c1 e8 16             	shr    $0x16,%eax
  8025ec:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025f8:	f6 c1 01             	test   $0x1,%cl
  8025fb:	74 1d                	je     80261a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025fd:	c1 ea 0c             	shr    $0xc,%edx
  802600:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802607:	f6 c2 01             	test   $0x1,%dl
  80260a:	74 0e                	je     80261a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80260c:	c1 ea 0c             	shr    $0xc,%edx
  80260f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802616:	ef 
  802617:	0f b7 c0             	movzwl %ax,%eax
}
  80261a:	5d                   	pop    %ebp
  80261b:	c3                   	ret    
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <__udivdi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 1c             	sub    $0x1c,%esp
  802627:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80262b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80262f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802633:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802637:	85 d2                	test   %edx,%edx
  802639:	75 35                	jne    802670 <__udivdi3+0x50>
  80263b:	39 f3                	cmp    %esi,%ebx
  80263d:	0f 87 bd 00 00 00    	ja     802700 <__udivdi3+0xe0>
  802643:	85 db                	test   %ebx,%ebx
  802645:	89 d9                	mov    %ebx,%ecx
  802647:	75 0b                	jne    802654 <__udivdi3+0x34>
  802649:	b8 01 00 00 00       	mov    $0x1,%eax
  80264e:	31 d2                	xor    %edx,%edx
  802650:	f7 f3                	div    %ebx
  802652:	89 c1                	mov    %eax,%ecx
  802654:	31 d2                	xor    %edx,%edx
  802656:	89 f0                	mov    %esi,%eax
  802658:	f7 f1                	div    %ecx
  80265a:	89 c6                	mov    %eax,%esi
  80265c:	89 e8                	mov    %ebp,%eax
  80265e:	89 f7                	mov    %esi,%edi
  802660:	f7 f1                	div    %ecx
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 1c             	add    $0x1c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
  80266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802670:	39 f2                	cmp    %esi,%edx
  802672:	77 7c                	ja     8026f0 <__udivdi3+0xd0>
  802674:	0f bd fa             	bsr    %edx,%edi
  802677:	83 f7 1f             	xor    $0x1f,%edi
  80267a:	0f 84 98 00 00 00    	je     802718 <__udivdi3+0xf8>
  802680:	89 f9                	mov    %edi,%ecx
  802682:	b8 20 00 00 00       	mov    $0x20,%eax
  802687:	29 f8                	sub    %edi,%eax
  802689:	d3 e2                	shl    %cl,%edx
  80268b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	89 da                	mov    %ebx,%edx
  802693:	d3 ea                	shr    %cl,%edx
  802695:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802699:	09 d1                	or     %edx,%ecx
  80269b:	89 f2                	mov    %esi,%edx
  80269d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a1:	89 f9                	mov    %edi,%ecx
  8026a3:	d3 e3                	shl    %cl,%ebx
  8026a5:	89 c1                	mov    %eax,%ecx
  8026a7:	d3 ea                	shr    %cl,%edx
  8026a9:	89 f9                	mov    %edi,%ecx
  8026ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026af:	d3 e6                	shl    %cl,%esi
  8026b1:	89 eb                	mov    %ebp,%ebx
  8026b3:	89 c1                	mov    %eax,%ecx
  8026b5:	d3 eb                	shr    %cl,%ebx
  8026b7:	09 de                	or     %ebx,%esi
  8026b9:	89 f0                	mov    %esi,%eax
  8026bb:	f7 74 24 08          	divl   0x8(%esp)
  8026bf:	89 d6                	mov    %edx,%esi
  8026c1:	89 c3                	mov    %eax,%ebx
  8026c3:	f7 64 24 0c          	mull   0xc(%esp)
  8026c7:	39 d6                	cmp    %edx,%esi
  8026c9:	72 0c                	jb     8026d7 <__udivdi3+0xb7>
  8026cb:	89 f9                	mov    %edi,%ecx
  8026cd:	d3 e5                	shl    %cl,%ebp
  8026cf:	39 c5                	cmp    %eax,%ebp
  8026d1:	73 5d                	jae    802730 <__udivdi3+0x110>
  8026d3:	39 d6                	cmp    %edx,%esi
  8026d5:	75 59                	jne    802730 <__udivdi3+0x110>
  8026d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026da:	31 ff                	xor    %edi,%edi
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d 76 00             	lea    0x0(%esi),%esi
  8026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8026f0:	31 ff                	xor    %edi,%edi
  8026f2:	31 c0                	xor    %eax,%eax
  8026f4:	89 fa                	mov    %edi,%edx
  8026f6:	83 c4 1c             	add    $0x1c,%esp
  8026f9:	5b                   	pop    %ebx
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    
  8026fe:	66 90                	xchg   %ax,%ax
  802700:	31 ff                	xor    %edi,%edi
  802702:	89 e8                	mov    %ebp,%eax
  802704:	89 f2                	mov    %esi,%edx
  802706:	f7 f3                	div    %ebx
  802708:	89 fa                	mov    %edi,%edx
  80270a:	83 c4 1c             	add    $0x1c,%esp
  80270d:	5b                   	pop    %ebx
  80270e:	5e                   	pop    %esi
  80270f:	5f                   	pop    %edi
  802710:	5d                   	pop    %ebp
  802711:	c3                   	ret    
  802712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802718:	39 f2                	cmp    %esi,%edx
  80271a:	72 06                	jb     802722 <__udivdi3+0x102>
  80271c:	31 c0                	xor    %eax,%eax
  80271e:	39 eb                	cmp    %ebp,%ebx
  802720:	77 d2                	ja     8026f4 <__udivdi3+0xd4>
  802722:	b8 01 00 00 00       	mov    $0x1,%eax
  802727:	eb cb                	jmp    8026f4 <__udivdi3+0xd4>
  802729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802730:	89 d8                	mov    %ebx,%eax
  802732:	31 ff                	xor    %edi,%edi
  802734:	eb be                	jmp    8026f4 <__udivdi3+0xd4>
  802736:	66 90                	xchg   %ax,%ax
  802738:	66 90                	xchg   %ax,%ax
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__umoddi3>:
  802740:	55                   	push   %ebp
  802741:	57                   	push   %edi
  802742:	56                   	push   %esi
  802743:	53                   	push   %ebx
  802744:	83 ec 1c             	sub    $0x1c,%esp
  802747:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80274b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80274f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802757:	85 ed                	test   %ebp,%ebp
  802759:	89 f0                	mov    %esi,%eax
  80275b:	89 da                	mov    %ebx,%edx
  80275d:	75 19                	jne    802778 <__umoddi3+0x38>
  80275f:	39 df                	cmp    %ebx,%edi
  802761:	0f 86 b1 00 00 00    	jbe    802818 <__umoddi3+0xd8>
  802767:	f7 f7                	div    %edi
  802769:	89 d0                	mov    %edx,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	39 dd                	cmp    %ebx,%ebp
  80277a:	77 f1                	ja     80276d <__umoddi3+0x2d>
  80277c:	0f bd cd             	bsr    %ebp,%ecx
  80277f:	83 f1 1f             	xor    $0x1f,%ecx
  802782:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802786:	0f 84 b4 00 00 00    	je     802840 <__umoddi3+0x100>
  80278c:	b8 20 00 00 00       	mov    $0x20,%eax
  802791:	89 c2                	mov    %eax,%edx
  802793:	8b 44 24 04          	mov    0x4(%esp),%eax
  802797:	29 c2                	sub    %eax,%edx
  802799:	89 c1                	mov    %eax,%ecx
  80279b:	89 f8                	mov    %edi,%eax
  80279d:	d3 e5                	shl    %cl,%ebp
  80279f:	89 d1                	mov    %edx,%ecx
  8027a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027a5:	d3 e8                	shr    %cl,%eax
  8027a7:	09 c5                	or     %eax,%ebp
  8027a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027ad:	89 c1                	mov    %eax,%ecx
  8027af:	d3 e7                	shl    %cl,%edi
  8027b1:	89 d1                	mov    %edx,%ecx
  8027b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027b7:	89 df                	mov    %ebx,%edi
  8027b9:	d3 ef                	shr    %cl,%edi
  8027bb:	89 c1                	mov    %eax,%ecx
  8027bd:	89 f0                	mov    %esi,%eax
  8027bf:	d3 e3                	shl    %cl,%ebx
  8027c1:	89 d1                	mov    %edx,%ecx
  8027c3:	89 fa                	mov    %edi,%edx
  8027c5:	d3 e8                	shr    %cl,%eax
  8027c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027cc:	09 d8                	or     %ebx,%eax
  8027ce:	f7 f5                	div    %ebp
  8027d0:	d3 e6                	shl    %cl,%esi
  8027d2:	89 d1                	mov    %edx,%ecx
  8027d4:	f7 64 24 08          	mull   0x8(%esp)
  8027d8:	39 d1                	cmp    %edx,%ecx
  8027da:	89 c3                	mov    %eax,%ebx
  8027dc:	89 d7                	mov    %edx,%edi
  8027de:	72 06                	jb     8027e6 <__umoddi3+0xa6>
  8027e0:	75 0e                	jne    8027f0 <__umoddi3+0xb0>
  8027e2:	39 c6                	cmp    %eax,%esi
  8027e4:	73 0a                	jae    8027f0 <__umoddi3+0xb0>
  8027e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8027ea:	19 ea                	sbb    %ebp,%edx
  8027ec:	89 d7                	mov    %edx,%edi
  8027ee:	89 c3                	mov    %eax,%ebx
  8027f0:	89 ca                	mov    %ecx,%edx
  8027f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8027f7:	29 de                	sub    %ebx,%esi
  8027f9:	19 fa                	sbb    %edi,%edx
  8027fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8027ff:	89 d0                	mov    %edx,%eax
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 d9                	mov    %ebx,%ecx
  802805:	d3 ee                	shr    %cl,%esi
  802807:	d3 ea                	shr    %cl,%edx
  802809:	09 f0                	or     %esi,%eax
  80280b:	83 c4 1c             	add    $0x1c,%esp
  80280e:	5b                   	pop    %ebx
  80280f:	5e                   	pop    %esi
  802810:	5f                   	pop    %edi
  802811:	5d                   	pop    %ebp
  802812:	c3                   	ret    
  802813:	90                   	nop
  802814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802818:	85 ff                	test   %edi,%edi
  80281a:	89 f9                	mov    %edi,%ecx
  80281c:	75 0b                	jne    802829 <__umoddi3+0xe9>
  80281e:	b8 01 00 00 00       	mov    $0x1,%eax
  802823:	31 d2                	xor    %edx,%edx
  802825:	f7 f7                	div    %edi
  802827:	89 c1                	mov    %eax,%ecx
  802829:	89 d8                	mov    %ebx,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	f7 f1                	div    %ecx
  80282f:	89 f0                	mov    %esi,%eax
  802831:	f7 f1                	div    %ecx
  802833:	e9 31 ff ff ff       	jmp    802769 <__umoddi3+0x29>
  802838:	90                   	nop
  802839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802840:	39 dd                	cmp    %ebx,%ebp
  802842:	72 08                	jb     80284c <__umoddi3+0x10c>
  802844:	39 f7                	cmp    %esi,%edi
  802846:	0f 87 21 ff ff ff    	ja     80276d <__umoddi3+0x2d>
  80284c:	89 da                	mov    %ebx,%edx
  80284e:	89 f0                	mov    %esi,%eax
  802850:	29 f8                	sub    %edi,%eax
  802852:	19 ea                	sbb    %ebp,%edx
  802854:	e9 14 ff ff ff       	jmp    80276d <__umoddi3+0x2d>

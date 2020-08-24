\ ft12.f
\ ������ � ��������� FT1.2
\ ���������� �.�.
\ v 1.1	�� 14.10.2004�.
\ v 1.2  �� 14.10.2004�. + ������� ���-�� ������

S" ~ilya\lib\tm\tm_com.f" INCLUDED
S" ~ilya\lib\tm\tm_lib.f" INCLUDED
S" ~yz\lib\common.f" INCLUDED
S" ~yz\lib\data.f" INCLUDED
WINAPI: GetTickCount	kernel32.dll


0 VALUE handle

0
1 -- .SS1		\ ��������� ����� 68�
1 -- .Len1		\ ���� ����� (0...255)
1 -- .Len2		\ ������
1 -- .SS2		\ ��������� ����� 68�
1 -- .CmdFld	\ ���� ����������
1 -- .AdrFld	\ �������� ����
1 -- .UsrDat	\
DROP

0
1 -- .CRC		\ ����������� ����� CRC
1 -- .SEnd		\ ����� ��������� 16� 
DROP

\ ������ 1 ��������������� ��������
0
1	--	.SobNum1
1	--	.Znach1
2	--	.Rezerv1
CELL	--	.Time1
CONSTANT	/F1Size

\ ������ 2 ��������������� ��������
0
1 -- .ColEl
CELL -- .Time
1 -- .SobNum
1 -- .Znach
CONSTANT /F2Size


\ ��������� master/slave
0x0F CONSTANT	MASKFUN 
0x40 CONSTANT	BMASTER 
0x10 CONSTANT	MASKFCV 
0x20 CONSTANT	MASKFCB 

0 	CONSTANT	MRESET	 
3 	CONSTANT	MDATA	 
8 	CONSTANT	MOPRTREB 
10 CONSTANT	MQUE1	 
11 CONSTANT	MQUE2  

0x20	CONSTANT	MASKQ1	
0 CONSTANT	SPKVIT	 
1 CONSTANT	SNOKVIT  
8 CONSTANT	SDATA	 
9 CONSTANT	SNODATA 

0x68 CONSTANT SStart
0x16 CONSTANT SEnd

0 VALUE CodFun
0 VALUE Ch
0 VALUE InBusNum		\ ����� ���������� � ����������
VARIABLE ColFrame		\ ���������� �������� ������
VARIABLE ColFrameFst		\ ���������� �������� ������ 1-�� ������
VARIABLE ColFrameSnd		\ ���������� �������� ������ 2-�� ������
VARIABLE ColFrameBad		\ ���������� ����� ������

\ �������������� �� ���� ���������� ���������
\ ������������ ���-�� ������� ������ 8
0 VALUE ch1				\ ��������� �� ����� ��� ������ 1
0 VALUE ch2
0 VALUE ch3
0 VALUE ch4
0 VALUE ch5
0 VALUE ch6
0 VALUE ch7
0 VALUE ch8
0 VALUE chOffset		\ �������� ������� ������������ 0

\ CREATE ch1 255 ALLOT
\ CREATE ch2 255 ALLOT
\ CREATE ch3 255 ALLOT


: M8b ( a c n -- ) \ a - �����, � - ��� �������, n - ���-�� �����. ������
	DUP
	esc-buf init->> esc-buf 20 ERASE
	SStart C>> C>> C>> SStart C>> C>> C>> 
	esc-buf DUP .CmdFld SWAP .Len1 C@ CRC C>> SEnd C>>
;
0 VALUE adr1
0 VALUE adr2

: MSyn
	DUP
	esc-buf init->> esc-buf 20 ERASE
	SStart C>> C>> C>> SStart C>> C>> C>> 
	27 C>> [CHAR] S C>> 0 C>> 11 DUP 2DUP C>> C>> C>> C>>
	esc-buf DUP .CmdFld SWAP .Len1 C@ CRC C>> SEnd C>>
;

\ ���������� ������ �� ��������������� �������
: toCHBuf ( n2 n1 -- )
\ ��� n1 - ����������� ����� � ������,
\ n2 - ��������
Ch CASE
		chOffset     OF	ch1 + C! ENDOF
		chOffset 1+  OF	ch2 + C! ENDOF
		chOffset 2 + OF	ch3 + C! ENDOF
		chOffset 3 + OF	ch4 + C! ENDOF
		chOffset 4 + OF	ch5 + C! ENDOF
		chOffset 5 + OF	ch6 + C! ENDOF
		chOffset 6 + OF	ch7 + C! ENDOF
		chOffset 7 + OF	ch8 + C! ENDOF
	ENDCASE
;
: F1@
adr2 .Znach1 C@
adr2 .SobNum1 C@
\ adr2 .Time1
toCHBuf
;

: F2@ ( n -- n3 n2 n1 )
 \ adr1 .Time @ TO T1 T1 .
adr1 .ColEl C@  DUP >R 0 ?DO 
			adr1 .Znach I 2 * + C@ 
			adr1 .SobNum I 2 * + C@ 
			toCHBuf
			LOOP	
			
adr1 R> 2 * + /F2Size + 2 - TO adr1			
;
: Syn?
rcv-buf .UsrDat  DUP >R C@ 
	0x1B = IF
				R> 1+ C@ [CHAR] G =
					IF
					15 TO cbs
					BMASTER OR  MASKFCV OR 0xF0 AND MDATA OR MASKFCB  XOR TO CodFun
					InBusNum CodFun 9
					MSyn
					COM-WRITE
					0x10 COM-READ
					
					8 TO cbs
					CR ." +++ Syncrho +++"
					THEN
			ELSE
			RDROP	
			THEN		
;

\ ��������� ���������������� ������ (������� ��� 7)
: PR20_7 { \ n --} 
	rcv-buf .UsrDat 2 + TO n  \ C@ CR ." Col=" . 
	n 1+ C@ TO Ch 
	n 2+ TO adr2 n C@  0  ?DO  F1@ adr2 /F1Size + TO adr2   LOOP \ DROP
;
\ ��������� ���������������� ������ (������� ��� 9)
: PR20_9 { \ n --} 
	rcv-buf .UsrDat 2 +  TO n \ C@ CR ." Col=" . 
	n 1+ C@ TO Ch 
	\ CR R@ 2 +  .Time @ ." Time=" U. R@ 2 + .SobNum C@ ." SobNum=" . CR
	
	n 2 + TO adr1 n C@  0  ?DO  I F2@ DROP   LOOP \ DROP
;

: 1ftCl 
rcv-buf .UsrDat C@
CASE
		20 OF
			rcv-buf .UsrDat 1+ C@
			CASE
					9	OF PR20_9 ENDOF
					7	OF PR20_7  ENDOF
					0x1B OF ENDOF
			ENDCASE
			ENDOF

ENDCASE
;

: S
\ Syn?

\ CR esc-buf 10 DUMP 
\ CR rcv-buf 30 DUMP

	rcv-buf 
	.CmdFld C@
	CASE
		0x20 OF
				\ CR ." 1-st Class Ready !" 
				ColFrameFst 1+!
				InBusNum
				CodFun
				BMASTER OR  MASKFCV OR 0xF0 AND MQUE1 OR MASKFCB  XOR TO CodFun
				CodFun 
				2 M8b
				\ COM-WRITE
				ENDOF
		0x28	OF
				\ CR ." 1-st Class Reading !" 
				\ CR rcv-buf cbr DUMP CR
				ColFrameFst 1+!
				1ftCl
				2
				CodFun
				BMASTER OR  MASKFCV OR 0xF0 AND  MQUE1 OR MASKFCB XOR TO CodFun
				CodFun
				2 M8b \ COM-WRITE
				ENDOF
		0x08	OF
				\ CR ." Second Class Ready !" 
				ColFrameSnd 1+!
				1ftCl 
				InBusNum
				CodFun
				BMASTER OR  MASKFCV OR 0xF0 AND  MQUE2 OR MASKFCB XOR TO CodFun
				CodFun
				2 M8b \ COM-WRITE
				ENDOF
		0x29	OF
				 \ CR ." Data End1 !"
				InBusNum
				CodFun
				BMASTER OR MASKFCV XOR 0xF0 AND  MOPRTREB OR MASKFCB XOR TO CodFun
				CodFun
				2 M8b \ COM-WRITE
				ENDOF	
		0x09	OF
				\ CR ." Data End2 !"
				InBusNum
				CodFun
				BMASTER OR MASKFCV XOR 0xF0 AND  MOPRTREB OR MASKFCB XOR TO CodFun
				CodFun
				2 M8b \ COM-WRITE
				ENDOF	
		0x00	OF
				\ CR ." Data End3 !"
				InBusNum
				CodFun
				BMASTER OR MASKFCV XOR 0xF0 AND  MQUE2 ( MOPRTREB) OR MASKFCB XOR TO CodFun
				CodFun
				2 M8b \ COM-WRITE
				ENDOF	
		
	ENDCASE

	
;
: initFT12	\ �������������� FT 1.2
rcvBufSize ALLOCATE THROW TO rcv-buf
255 ALLOCATE THROW TO ch1
255 ALLOCATE THROW TO ch2
255 ALLOCATE THROW TO ch3
255 ALLOCATE THROW TO ch4
255 ALLOCATE THROW TO ch5
255 ALLOCATE THROW TO ch6
255 ALLOCATE THROW TO ch7
255 ALLOCATE THROW TO ch8
;

: closeFT12 \ ��������� FT 1.2
rcv-buf FREEMEM
ch1 FREEMEM
ch2 FREEMEM
ch3 FREEMEM
ch4 FREEMEM
ch5 FREEMEM
ch6 FREEMEM
ch7 FREEMEM
ch8 FREEMEM
;

: FT12mCikl 
DROP
	\ S" COM2" COM-OPEN
   \ 10 com-handle SetTimeOut THROW
	\ 9600  8 2 0 com-handle SetModemParameters THROW
		
	8 TO cbs
	BMASTER TO CodFun
	InBusNum CodFun 2 M8b \ COM-WRITE	\ ����� ��������� ������
	HEX
	BEGIN
	
	COM-WRITE
	
	\ GetTickCount 
	\ CR ." ======= Send ======="
	\ esc-buf CR 10 DUMP
	\ CR ." ===================="
	\ 100 PAUSE
	
	\ PurgeRcv
	
   0xFF COM-READ
	cbr 0 > IF ColFrame 1+! THEN
	\ rcv-buf .CmdFld rcv-buf .Len1 C@ +  C@
   \ rcv-buf .CmdFld rcv-buf .Len1 C@ CRC
   \ CR ." CRC frame count=" . ." CRC=" .
   \ CR ." ============ DUMP =============="
   \ CR rcv-buf cbr DUMP
   \ CR ." ================================"
	\ GetTickCount SWAP - CR ." tick=" .
	rcv-buf .CmdFld rcv-buf .Len1 C@ +  C@
   rcv-buf .CmdFld rcv-buf .Len1 C@ CRC
   = IF
   S 
   ELSE
   ColFrameBad 1+!
   \ CR ." !!! Bad Frame !!!" \ ClearCommBreak 100 PAUSE SetCommBreak 
   THEN
     
   AGAIN 
   
 
	COM-CLOSE
	\ esc-buf 20 DUMP
	\ CR ." ==========="
;

\EOF
  

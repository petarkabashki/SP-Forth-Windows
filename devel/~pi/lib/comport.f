\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   ComPort v1.0 for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� ��� ࠡ��� � com ���⠬�
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|
\ -----------------------------------------------------------------------------

\ handle ������� ���⮢
0 VALUE com1
0 VALUE com2
0 VALUE com3
0 VALUE com4
\ ���� ��� �⥭��/����� com ����
CREATE buffcom 256 ALLOT

MODULE: HIDDEN

WINAPI: GetCommState		KERNEL32.DLL
WINAPI: SetCommState		KERNEL32.DLL
WINAPI: SetCommTimeouts		KERNEL32.DLL
WINAPI: PurgeComm		KERNEL32.DLL
WINAPI: TransmitCommChar	KERNEL32.DLL
WINAPI: WaitCommEvent		KERNEL32.DLL
WINAPI: GetCommMask		KERNEL32.DLL

\ ����⠭�� �⥭��/����� ����
-2147483648 CONSTANT GENERIC_READ
1073741824  CONSTANT GENERIC_WRITE

VARIABLE tempcom
VARIABLE ReadBuffer
VARIABLE EvtMask


0
CELL -- DCBlength	\ ������ �����, � �����, �������� DCB. 
CELL -- BaudRate	\ ᪮���� ��।�� ������. 
CELL -- Mode		\ ����砥� ������ ०�� ������ (�� 䫠��). 
2 -- wReserved		\ �� �ᯮ������, ������ ���� ��⠭������ � 0. 
2 -- XonLim		\ �������쭮� �᫮ ᨬ����� � �ਥ���� ���� ��। ���뫪�� ᨬ���� XON. 
2 -- XoffLim		\ ������⢮ ���� � �ਥ���� ���� ��। ���뫪�� ᨬ���� XOFF. 
1 -- ByteSize		\ �᫮ ���ଠ樮���� ��� � ��।������� � �ਭ������� �����. 4-8 
1 -- Parity		\ �奬� ����஫� �⭮�� 
	\ 0-4=��������� �� �⭮��,1,���������,��������� �� ���⭮��,0 
1 -- StopBits		\ ������ ������⢮ �⮯���� ���. 0,1,2 = 1, 1.5, 2 
1 -- XonChar		\ ������ ᨬ��� XON �ᯮ��㥬� ��� ��� �ਥ��, ⠪ � ��� ��।��. 
1 -- XoffChar		\ ������ ᨬ��� XOFF �ᯮ��㥬� ��� ��� �ਥ��, ⠪ � ��� ��।��. 
1 -- ErrorChar		\ ������ ᨬ���, �ᯮ����騩�� ��� ������ ᨬ����� � �訡�筮� �⭮����. 
1 -- EofChar		\ ������ ᨬ���, �ᯮ����騩�� ��� ᨣ������樨 � ���� ������. 
1 -- EvtChar		\ ������ ᨬ���, �ᯮ����騩�� ��� ᨣ������樨 � ᮡ�⨨. 
2 -- wReserved1		\ ��१�ࢨ஢��� � �� �ᯮ������. 
CONSTANT DCB
HERE DUP >R DCB DUP ALLOT ERASE VALUE MyDCB

0   
CELL -- ReadIntervalTimeout		\ ���ᨬ��쭮� �६�, � �����ᥪ㭤��, �����⨬�� ����� ���� ��᫥����⥫�묨 ᨬ������, ����-����묨 � ����㭨��樮���� �����. 
CELL -- ReadTotalTimeoutMultiplier	\ ������ �����⥫�, � �����ᥪ㭤��, �ᯮ��㥬� ��� ���᫥��� ��饣� ⠩�-��� ����樨 �⥭��. 
CELL -- ReadTotalTimeoutConstant	\ ������ ����⠭��, � �����ᥪ㭤��, �ᯮ��㥬�� ��� ���᫥��� ��饣� ⠩�-��� ����樨 �⥭��. 
CELL -- WriteTotalTimeoutMultiplier	\ ������ �����⥫�, � �����ᥪ㭤��, �ᯮ��㥬� ��� ���᫥��� ��饣� ⠩�-��� ����樨 �����.
CELL -- WriteTotalTimeoutConstant	\ ������ ����⠭��, � �����ᥪ㭤��, �ᯮ��㥬�� ��� ���᫥��� ��饣� ⠩�-��� ����樨 �����.
CONSTANT COMMTIMEOUTS
HERE DUP COMMTIMEOUTS DUP ALLOT ERASE VALUE CommTimeouts

\ ����⨥ com ���� �� ��� �����
: ComOpen ( �-addr u -> handle )
DROP >R
0 0 OPEN_EXISTING 0 0 GENERIC_READ GENERIC_WRITE OR R> CreateFileA
DUP -1 = IF DROP 0 THEN ;

\ ��ࢮ��砫쭠� ���樠������ ����
: ComInit ( handle -> ior )
	>R
	DCB MyDCB DCBlength !
	MyDCB R> DUP >R GetCommState DROP
	9600 MyDCB BaudRate ! 
	0x80000000 MyDCB Mode !
	8 MyDCB ByteSize C!
	1 MyDCB StopBits C!
	2 MyDCB Parity C!
	MyDCB R> SetCommState ; 

\ ��⠭���� ���ࢠ��� �������� ��� �⥭��/����� � ����
: Timeouts ( handle ms -> flag )
	SWAP >R
	10  CommTimeouts ReadIntervalTimeout !
	1   CommTimeouts ReadTotalTimeoutMultiplier !
	    CommTimeouts ReadTotalTimeoutConstant !
	100 CommTimeouts WriteTotalTimeoutMultiplier !
	1   CommTimeouts WriteTotalTimeoutConstant !
	    CommTimeouts R> SetCommTimeouts ;


EXPORT
\ ���뢠�� ���� com1
: COM1 ( -> flag )
	S" COM1" ComOpen DUP TO com1 0<> 
	IF com1 DUP ComInit DROP 1000 Timeouts DROP -1 ELSE 0 THEN ;
\ ���뢠�� ���� com2
: COM2 ( -> flag )
	S" COM2" ComOpen DUP TO com2 0<> 
	IF com2 DUP ComInit DROP 1000 Timeouts DROP -1 ELSE 0 THEN ;
\ ���뢠�� ���� com3
: COM3 ( -> flag )
	S" COM3" ComOpen DUP TO com3 0<> 
	IF com3 DUP ComInit DROP 1000 Timeouts DROP -1 ELSE 0 THEN ;
\ ���뢠�� ���� com4
: COM4 ( -> flag )
	S" COM4" ComOpen DUP TO com4 0<> 
	IF com4 DUP ComInit DROP 1000 Timeouts DROP -1 ELSE 0 THEN ;

\ ������� com ����
: COMClose ( handle -> ior )
	CloseHandle ;

\ ����� ��ப� �� com � ����
: COMRead ( handle -> c-addr u )
	>R 0 tempcom 256 buffcom R> ReadFile DROP
	buffcom ASCIIZ> 1- DUP 0< IF DROP 0 THEN ;

\ ������� ��ப� � com ����
: COMWrite ( c-addr u handle -> )
	>R SWAP 0 tempcom 2SWAP R> WriteFile DROP ;

\ �뢥�� �� ���᮫� ��ப� �� ���� com
: .COM ( c-addr u -> )
	TYPE 0 buffcom ! ;

\ �ਥ� ᨬ���� �� ����
: COMIn ( handle -- char )
	0 ReadBuffer ! >R 0 tempcom 1 ReadBuffer R> ReadFile DROP
	ReadBuffer C@ ;

\ ��।�� ᨬ���� � ������ ����
: COMOut ( char handle -- )
	TransmitCommChar DROP ;

\ ����ன�� ����
: COMSet ( handle BaudRate ByteSize StopBits Parity -> ior )
 MyDCB Parity C!
 MyDCB StopBits C!
 MyDCB ByteSize C!
 MyDCB BaudRate !
 MyDCB SetCommState 0 <> ;

\ ��頥� ��।� �ਥ��/��।�� � �ࠩ��� com ����
: COMClear ( handle -> )
	DUP 12 SWAP PurgeComm DROP ;


;MODULE

: main
	COM1
	IF
	COMClear
	 BEGIN
	  \ com1 COMWait 1 .
	  com1 COMRead .COM
	  \ com1 COMIn .
	 AGAIN
	THEN
;

\EOF

�� 㬮�砭�� com ����� ����� ����ன��:
 - ᪮����: 9600
 - ��� ������: 8
 - �⭮���: ���
 - �⮯��� ����: 1

com1		( -> handle ) - 奭�� com1 ��᫥ ���樠����樨
com2		( -> handle ) - 奭�� com2 ��᫥ ���樠����樨
com3		( -> handle ) - 奭�� com3 ��᫥ ���樠����樨
com4		( -> handle ) - 奭�� com4 ��᫥ ���樠����樨

COM1		( -> flag ) - ���뢠�� ���� com1
COM2		( -> flag ) - ���뢠�� ���� com2
COM3		( -> flag ) - ���뢠�� ���� com3
COM4		( -> flag ) - ���뢠�� ���� com4
COMClose 	( handle -> ior ) - ������� com ����
COMRead		( addr u handle -> c-addr u ) - ���� ��ப� �� com � ����
COMWrite	( c-addr u handle -> ) - ������� ��ப� � com ����
COMIn		( handle -- char ) - �ਥ� ᨬ���� �� ����
COMOut		( char handle -- ) - ��।�� ᨬ���� � ������ ����
COMSet 		( handle BaudRate ByteSize StopBits Parity -> ior ) - ����ன��
		����
COMClear	( handle -> ) - ��頥� ��।� �ਥ��/��।�� � �ࠩ��� com ����

\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   Console for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� ��� ࠡ��� � ���᮫��
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|
\ -----------------------------------------------------------------------------

MODULE: _CONSOLE

WINAPI: SetConsoleTitleA		KERNEL32.DLL
WINAPI: SetConsoleCursorPosition	KERNEL32.DLL
WINAPI: SetConsoleTextAttribute		KERNEL32.DLL
WINAPI: SetConsoleCursorInfo		KERNEL32.DLL
WINAPI: GetConsoleCursorInfo		KERNEL32.DLL
WINAPI: SetConsoleScreenBufferSize	KERNEL32.DLL
WINAPI: GetConsoleScreenBufferInfo	KERNEL32.DLL
WINAPI: FillConsoleOutputCharacterA	KERNEL32.DLL
WINAPI: FillConsoleOutputAttribute	KERNEL32.DLL
WINAPI: SetConsoleDisplayMode		KERNEL32.DLL
WINAPI: WriteConsoleOutputCharacterA	KERNEL32.DLL

0 VALUE XWin \ ���न��� X ����㠫쭮�� ����
0 VALUE YWin \ ���न��� Y ����㠫쭮�� ����
0 VALUE LWin \ ����� ����㠫쭮�� ����
0 VALUE HWin \ ���� ����㠫쭮�� ����
7 VALUE CWin \ 梥� ᨬ�����
0 VALUE BWin \ 䮭 ᨬ�����

EXPORT

\ �㡫���� 㪠������ ������⢮ �ᥫ � �⥪�
: DUPS ( n -> )
	DUP 0 ?DO DUP PICK SWAP LOOP DROP
 ;

\ ��������� ���न���� � �᫮
: XY->N ( x y -> n )
	16 LSHIFT OR ;

\ ��ᯠ������ ���न���� �� �᫠
: N->XY ( n -> x y )
	DUP 0xFFFF AND SWAP 16 RSHIFT ;

\ ��������� 梥� � 䮭 � �᫮
: Color->N ( 梥� 䮭 -> n )
	4 LSHIFT OR ;

\ ��ᯠ������ 梥� � 䮭 �� �᫠
: N->Color ( n -> 梥� 䮭 )
	DUP 0xF AND SWAP 4 RSHIFT ;
	

\ �������� ��� ���᮫�
: SetTitle ( addr n -> )
	DROP SetConsoleTitleA DROP ;

\ ��⠭����� ����� � ���᮫� � ������� ���न����
: SetLocate ( x y -> )
	XY->N H-STDOUT SetConsoleCursorPosition DROP ;

\ ������� ����� �� ���᮫�
: HideCursore ( -> )
	0 0 SP@ DUP H-STDOUT GetConsoleCursorInfo DROP
	ROT DROP 0 -ROT
	H-STDOUT SetConsoleCursorInfo DROP 2DROP ;

\ �������� ����� �� ���᮫�
: ShowCursore ( -> )
	0 0 SP@ DUP H-STDOUT GetConsoleCursorInfo DROP
	ROT DROP 1 -ROT
	H-STDOUT SetConsoleCursorInfo DROP 2DROP ;

\ ������ ����� (0-100)
: SizeCursore ( n -> )
	>R 0 0 SP@ DUP H-STDOUT GetConsoleCursorInfo DROP
	SWAP DROP R> SWAP
	H-STDOUT SetConsoleCursorInfo DROP 2DROP ;

\ ������ ���᮫� (�� 80) (�� 25)
: SizeConsole ( lenght height -> )
	XY->N H-STDOUT SetConsoleScreenBufferSize DROP ;

\ ������ ���᮫�
: GetLength ( -> n )
	0 0 0 0 0 0 SP@ H-STDOUT GetConsoleScreenBufferInfo DROP
	>R 2DROP 2DROP DROP R> 0xFFFF AND ;

\ ���� ���᮫�
: GetHeight ( -> n )
	0 0 0 0 0 0 SP@ H-STDOUT GetConsoleScreenBufferInfo DROP
	>R 2DROP 2DROP DROP R> 16 RSHIFT ;

\ ���न��� ����� X
: GetX ( -> n )
	0 0 0 0 0 0 SP@ H-STDOUT GetConsoleScreenBufferInfo DROP
	DROP >R 2DROP 2DROP R> 0xFFFF AND ;

\ ���न��� ����� Y
: GetY ( -> n )
	0 0 0 0 0 0 SP@ H-STDOUT GetConsoleScreenBufferInfo DROP
	DROP >R 2DROP 2DROP R> 16 RSHIFT ;

\ ������� ���न���� �����
: GetLocate ( -> x y )
	GetX GetY ;

\ ����騩 梥� ���᮫�
: GetColor ( -> n )
	0 0 0 0 0 0 SP@ H-STDOUT GetConsoleScreenBufferInfo DROP
	2DROP >R 2DROP DROP R> 0xF AND ;

\ ����騩 䮭 ���᮫�
: GetBackground ( -> n )
	0 0 0 0 0 0 SP@ H-STDOUT GetConsoleScreenBufferInfo DROP
	2DROP >R 2DROP DROP R> 4 RSHIFT ;

\ �������� 梥� ��室��� ᨬ����� �� ���᮫�
: SetColor ( n -> )
	
	GetBackground 4 LSHIFT OR H-STDOUT SetConsoleTextAttribute DROP ;

\ �������� 䮭 ��室��� ᨬ����� �� ���᮫�
: SetBackground ( n -> )
	16 * GetColor + H-STDOUT SetConsoleTextAttribute DROP ;

\ �������� ���न���� X ����� � ���᮫�
: SetX ( n -> )
	GetY SetLocate ; 

\ �������� ���न���� Y ����� � ���᮫�
: SetY ( n -> )
	GetX SWAP SetLocate ; 

\ ������ ���᮫�
: Cls ( -> )
	0 0 GetLocate XY->N DUP >R 32 H-STDOUT
	FillConsoleOutputCharacterA DROP
	0 0 R> GetColor GetBackground Color->N H-STDOUT
	FillConsoleOutputAttribute DROP
	0 0 SetLocate ;

\ ��������� ���᮫� �� ���� �࠭
: FullConsole ( -> )
	0 1 H-STDOUT SetConsoleDisplayMode DROP ;

\ ����� ������࠭��� ���᮫� � ����
: WindowsConsole ( -> )
	0 0 H-STDOUT SetConsoleDisplayMode DROP ;

\ ��⠭����� ��ਡ��� � ���� ���᮫�
: AttrWindow ( -> )
	XWin YWin XY->N
	HWin 0 ?DO
	DUP 0 SWAP LWin CWin BWin Color->N H-STDOUT
	FillConsoleOutputAttribute DROP 0x10000 +
	LOOP DROP ;

\ ������ ���� � ���᮫� ��� ��������� ��ਡ�⮢
: ClearWindow ( -> )
	XWin YWin XY->N
	HWin 0 ?DO
	DUP 0 SWAP LWin 32 H-STDOUT
	FillConsoleOutputCharacterA DROP 0x10000 +
	LOOP DROP ;

\ ������ ���� �� ���᮫�
: ClsWindow ( -> )
	ClearWindow AttrWindow ;

\ �������� 梥� 䮭 � 梥� ���᮫� ���⠬�
: SwapColor ( -> )
	GetBackground GetColor SetBackground SetColor ;

\ �뢮� ��ப� ��� ᬥ饭�� ����� � ��� ��������� 梥�
: Print� ( n addr x y -> )
	XY->N 0 SWAP 2SWAP SWAP H-STDOUT WriteConsoleOutputCharacterA DROP ;

\ �뢮� ᨬ���� ��� ᬥ饭�� ����� � ��� ��������� 梥�
: Emit� ( x y char -> )
	>R XY->N 0 SWAP 1 RP@ H-STDOUT WriteConsoleOutputCharacterA
	R> 2DROP ;

\ �����ୠ� ��ਧ��⠫쭠� �����
: LineH ( n -> )
	0 ?DO 0xC4 EMIT LOOP ;

\ ������� ��ਧ��⠫쭠� �����
: DLineH ( n -> )
	0 ?DO 0xCD EMIT LOOP ;

\ �����ୠ� ���⨪��쭠� �����
: LineV ( n -> )
	0 ?DO GetLocate 0xB3 EMIT 1+ SetLocate LOOP ;

\ ������� ���⨪��쭠� �����
: DLineV ( n -> )
	0 ?DO GetLocate 0xBA EMIT 1+ SetLocate LOOP ;

\ �뢥�� �������� ࠬ�� �� ����㠫쭮�� ����
: Box ( -> )
	GetColor GetBackground CWin SetColor BWin SetBackground
	XWin YWin SetLocate
	0xDA EMIT LWin 2- LineH 0xBF EMIT
	XWin YWin HWin 2- 0 ?DO
	1+ 2DUP SetLocate 0xB3 EMIT LWin 2- SPACES 0xB3 EMIT
	LOOP
	1+ SetLocate 0xC0 EMIT LWin 2- LineH 0xD9 EMIT
	SetBackground SetColor ;

\ �뢥�� ������� ࠬ�� �� ����㠫쭮�� ����
: DBox ( -> ) 
	GetColor GetBackground CWin SetColor BWin SetBackground
	XWin YWin SetLocate
	0xC9 EMIT LWin 2- DLineH 0xBB EMIT
	XWin YWin HWin 2- 0 ?DO
	1+ 2DUP SetLocate 0xBA EMIT LWin 2- SPACES 0xBA EMIT
	LOOP
	1+ SetLocate 0xC8 EMIT LWin 2- DLineH 0xBC EMIT
	SetBackground SetColor ;

\ �⠭����� ��⠭���� ��ਡ�⮢ ���᮫�
: Console ( -> )
	WindowsConsole
	0 SetBackground
	7 SetColor
	80 25 SizeConsole
	10 SizeCursore
	ShowCursore
	Cls ;
	

GetLength 	TO LWin
GetHeight 	TO HWin
GetColor	TO CWin
GetBackground	TO BWin

;MODULE
\EOF

---��騥 ᫮��---
DUPS		( n -> ) - �㡫���� 㪠������ ������⢮ �ᥫ � �⥪�
XY->N		( x y -> n ) - 㯠������ ���न���� � �᫮
N->XY		( n -> x y ) - �ᯠ������ ���न���� �� �᫠
Color->N	( 梥� 䮭 -> n ) - 㯠������ 梥� � 䮭 � �᫮
N->Color	( n -> 梥� 䮭 ) - �ᯠ������ 梥� � 䮭 �� �᫠

---�뢮� �� ���᮫�---
Char�		( x y char -> ) - �뢮� ᨬ���� ��� ᬥ饭�� ����� � ���������
		梥�
Print�		( n addr x y -> ) - �뢮� ��ப� ��� ᬥ饭�� ����� �
		��������� 梥�
LineH 		( n -> ) - �����ୠ� ��ਧ��⠫쭠� �����
DLineH		( n -> ) -  ������� ��ਧ��⠫쭠� �����
LineV		( n -> ) - �����ୠ� ���⨪��쭠� �����
DLineV		( n -> ) - ������� ���⨪��쭠� �����
Box		( -> ) - �뢥�� �������� ࠬ�� (�������� nWin)
DBox		( -> ) - �뢥�� ������� ࠬ�� (�������� nWin)


---����⢨� � ���न��⠬�---
SetLocate	( x y -> ) - ��⠭����� ����� � ���᮫� � ������� ���न����
GetLocate	( -> x y ) - ������� ���न���� �����
SetX		( n -> ) - �������� ���न���� X ����� � ���᮫�
SetY		( n -> ) - �������� ���न���� Y ����� � ���᮫�
GetX		( -> n ) - ���न��� ����� X
GetY		( -> n ) - ���न��� ����� Y

---����⢨� � ����஬---
HideCursore	( -> ) - ������ ����� �� ���᮫�
ShowCursore	( -> ) - �������� ����� �� ���᮫�
SizeCursore	( n -> ) - ࠧ��� ����� (0-100)

---����⢨� � ���᮫��---
SetTitle	( addr n -> ) - �������� ��� ���᮫�
FullConsole	( -> ) - ࠧ������ ���᮫� �� ���� �࠭
WindowsConsole	( -> ) - ᢥ���� ������࠭��� ���᮫� � ����
SizeConsole	( lenght height -> ) - ࠧ��� ���᮫� (�� 80) (�� 25)
GetLength	( -> n ) - ������ ���᮫�
GetHeight	( -> n ) - ���� ���᮫�
ClearWindow	( -> ) - ������ ���� ��� ��������� ��ਡ�⮢ (�������� nWin)
Cls		( -> ) - ������ ���᮫�
ClsWindow	( -> ) - ������ ���� �� ���᮫� (�������� nWin)

---����⢨� � 梥⠬� ���᮫�---
GetColor	( -> n ) - ⥪�騩 梥� ���᮫�
GetBackground	( -> n ) - ⥪�騩 䮭 ���᮫�
SetColor	( n -> ) - �������� 梥� ��室��� ᨬ����� �� ���᮫�
SetBackground	( n -> ) - �������� 䮭 ��室��� ᨬ����� �� ���᮫�
SwapColor	( -> ) - �������� 梥� 䮭 � 梥� ���᮫� ���⠬�
AttrWindow 	( -> ) - ��⠭����� ��ਡ��� � ���� ���᮫� (�������� nWin)

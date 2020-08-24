\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   graph for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� �뢮�� ⥪�� �� ���. ���᮫�
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.0
\ -----------------------------------------------------------------------------
REQUIRE ConCreate ~pi/lib/wincon/wincon.f

MODULE: _TEXT

0
CELL -- rectx
CELL -- recty
CELL -- recth
CELL -- rectl
CONSTANT RECT
0 VALUE rect
RECT ALLOCATE THROW TO rect

WINAPI: DrawTextA		USER32.DLL
WINAPI: SetTextColor		GDI32.DLL
WINAPI: SetBkColor		GDI32.DLL

EXPORT

\ ����� ��ப� � �������� ���न����
: Print ( x y c-addr n -> )
	length rect rectl !
	height rect recth !
	SWAP 2SWAP
	rect recty !
	rect rectx !
	0 -ROT
	rect -ROT
	phdc DrawTextA DROP ;

\ ��⠭����� 梥� ⥪��
: ColorText ( RGB -> )
	phdc SetTextColor DROP ;

\ ��⠭����� 梥� 䮭� ��� ⥪�⮬
: BackgroundText ( RGB -> )
	phdc SetBkColor DROP ;

;MODULE

0xFFFFFF ColorText
0 BackgroundText

\EOF

Print		( x y c-addr n -> ) - ����� ��ப� � �������� ���न����
ColorText	( RGB -> ) - ��⠭����� 梥� ⥪��
BackgroundText	( RGB -> ) - ��⠭����� 梥� 䮭� ��� ⥪�⮬

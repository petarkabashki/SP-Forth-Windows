\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   graph for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� �뢮�� ��䨪� �� ���. ���᮫�
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.4
\ -----------------------------------------------------------------------------
REQUIRE ConCreate ~pi/lib/wincon/wincon.f

MODULE: _GRAPH

WINAPI: SetPixel		GDI32.DLL
WINAPI: MoveToEx		GDI32.DLL
WINAPI: LineTo			GDI32.DLL
WINAPI: Ellipse			GDI32.DLL
WINAPI: RoundRect		GDI32.DLL
WINAPI: LoadImageA		USER32.DLL
WINAPI: StretchBlt		GDI32.DLL
WINAPI: GetObjectA		GDI32.DLL
WINAPI: DrawIcon		USER32.DLL
WINAPI: GetPixel		GDI32.DLL
WINAPI: Arc			GDI32.DLL
WINAPI: Pie			GDI32.DLL

0
CELL -- bmType
CELL -- bmWidth
CELL -- bmHeight
CELL -- bmWidthBytes
2 -- bmPlanes
2 -- bmBitsPixel
CELL -- bmBits
CONSTANT BITMAP
0 VALUE bitmap
BITMAP ALLOCATE THROW TO bitmap

EXPORT

\ ��६�頥� ��� ��砫� �ᮢ���� ��� Draw
: MoveTo ( x y -> )
	0 -ROT SWAP phdc MoveToEx DROP ;

\ ����� ����� �� ⥪�� �窨 �ᮢ����
: Draw ( x y -> )
	SWAP phdc LineTo DROP ;

\ ���ᮢ��� ���
: Point ( x y -> )
	SWAP color -ROT phdc SetPixel DROP ;

\ ���ᮢ��� �����
: Line ( x y x1 y1 -> )
	2SWAP MoveTo Draw ;

\ ���ᮢ��� ���
: Circle ( x y d -> )
	>R SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc Ellipse DROP ;

\ ���ᮢ��� ���
: Ellips ( x y x1 y1 -> )
	SWAP 2SWAP SWAP phdc Ellipse DROP ;

\ ���ᮢ��� ������
: Square ( x y l -> )
	>R SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc Rectangle DROP ;

\ ���ᮢ��� ��אַ㣮�쭨�
: Rect ( x y x1 y1 -> )
         SWAP 2SWAP SWAP phdc Rectangle DROP ;

\ ���ᮢ��� ��אַ㣮�쭨� c ��㣫���묨 ���栬�
: RRect ( x y x1 y1 ll lh -> )
         SWAP 2SWAP SWAP 2>R 2SWAP SWAP 2R> 2SWAP phdc RoundRect DROP ;

\ ���ᮢ��� ������  c ��㣫���묨 ���栬�
: RSquare ( x y l ll lh-> )
	SWAP 2SWAP >R -ROT 2SWAP SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc RoundRect DROP ;

\ �뢥�� ����ࠦ���� bmp �� 䠩�� �� ���᮫�
: Image ( addr u x y -> )
	{ x y | hbitmap bhdc pbhdc }
	DROP >R 0x10 0 0 0 R> hwdwin LoadImageA TO hbitmap
	bitmap 24 hbitmap GetObjectA DROP
	phdc CreateCompatibleDC TO bhdc
	hbitmap bhdc SelectObject TO pbhdc
	0xCC0020 bitmap bmHeight @ bitmap bmWidth @ 0 0 bhdc
	bitmap bmHeight @ bitmap bmWidth @ y x phdc StretchBlt DROP
	hbitmap DeleteObject DROP
	bhdc DeleteDC DROP ;

\ �����頥� 梥� ���ᥫ� � 㪠������ ���न����
: GPixel ( x y -> RGB )
	SWAP phdc GetPixel ;
	
\ �뢥�� ������ ico �� 䠩�� �� ���᮫�
: Icon ( addr u x y -> )
	2SWAP DROP >R 0x10 0 0 1 R> hwdwin LoadImageA DUP
	2SWAP SWAP phdc DrawIcon DROP DeleteObject DROP ;
\ �㣠
\ X1, Y1: ��p孨� ���� 㣮� ��p���稢��饣� �pאַ㣮�쭨��.
\ X2, Y2: �p��� ������ 㣮� ��p���稢��饣� �pאַ㣮�쭨��.
\ X3, Y3: ��砫쭠� �窠 �㣨.
\ X4, Y4: ����筠� �窠 �㣨. 
: Arcs  ( x1 y1 x2 y2 x3 y3 x4 y4 -> )
	{ x1 y1 x2 y2 }
	SWAP 2SWAP SWAP y2 x2 y1 x1 phdc Arc DROP ;

\ �����
\ X1, Y1: ��p孨� ���� 㣮� ��p���稢��饣� �pאַ㣮�쭨��.
\ X2, Y2: �p��� ������ 㣮� ��p���稢��饣� �pאַ㣮�쭨��.
\ X3, Y3: ��砫쭠� �窠 ᥪ��.
\ X4, Y4: ����筠� �窠 ᥪ��. 
: Sector ( x1 y1 x2 y2 x3 y3 x4 y4 -> )
	{ x1 y1 x2 y2 }
	SWAP 2SWAP SWAP y2 x2 y1 x1 phdc Pie DROP ;

;MODULE

\EOF

Point		( x y -> ) - ���ᮢ��� ���
MoveTo		( x y -> ) - ��६�頥� ��� ��砫� �ᮢ���� ��� Draw
Draw		( x y -> ) - ���� ����� �� ⥪�� �窨 �ᮢ����
Line		( x y x1 y1 -> ) - ���ᮢ��� �����
Square		( x y l -> ) - ���ᮢ��� ������
Rect 		( x y x1 y1 -> ) - ���ᮢ��� ��אַ㣮�쭨�
Ellips		( x y x1 y1 -> ) - ���ᮢ��� ���
Circle		( x y d -> ) - ���ᮢ��� ���
RRect		( x y x1 y1 h l -> ) - ���ᮢ��� ��אַ㣮�쭨� c ��㣫���묨 㣫���
RSquare		( x y l ll lh-> ) - ���ᮢ��� ������  c ��㣫���묨 㣫���
Image		( c-addr u x y -> ) - �뢥�� ����ࠦ���� bmp �� 䠩�� �� ���᮫�
Icon		( c-addr u x y -> ) - �뢥�� ������ ico �� 䠩�� �� ���᮫�
GPixel		( x y -> RGB ) - �����頥� 梥� ���ᥫz � 㪠������ ���न����
Arcs		( x1 y1 x2 y2 x3 y3 x4 y4 -> ) - �㣠
Sector		( x1 y1 x2 y2 x3 y3 x4 y4 -> ) - ᥪ��

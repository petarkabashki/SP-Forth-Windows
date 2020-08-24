\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   OpenGl for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� ��� ࠡ��� � opengl v0.01
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|
\ -----------------------------------------------------------------------------
S" lib\include\float2.f" INCLUDED
MODULE: HIDDEN

WINAPI: CreateWindowExA		USER32.DLL
WINAPI: GetSystemMetrics	USER32.DLL
WINAPI: GetDC			USER32.DLL
WINAPI: ReleaseDC		USER32.DLL
WINAPI: ShowCursor		USER32.DLL
WINAPI: GetAsyncKeyState	USER32.DLL

WINAPI: ChoosePixelFormat	GDI32.DLL
WINAPI: SetPixelFormat		GDI32.DLL
WINAPI: SwapBuffers		GDI32.DLL

WINAPI: wglCreateContext	OPENGL32.DLL
WINAPI: wglMakeCurrent		OPENGL32.DLL
WINAPI: glHint			OPENGL32.DLL
WINAPI: glMatrixMode		OPENGL32.DLL
WINAPI: glClear			OPENGL32.DLL
WINAPI: glLoadIdentity		OPENGL32.DLL
WINAPI: glTranslated		OPENGL32.DLL
WINAPI: glPointSize		OPENGL32.DLL
WINAPI: glBegin			OPENGL32.DLL
WINAPI:	glVertex2d		OPENGL32.DLL
WINAPI:	glEnd			OPENGL32.DLL
WINAPI: glColor3b		OPENGL32.DLL
WINAPI: glRotated		OPENGL32.DLL
WINAPI: glLineWidth		OPENGL32.DLL
WINAPI: glPolygonMode		OPENGL32.DLL
WINAPI: glEnable		OPENGL32.DLL
WINAPI: glDisable		OPENGL32.DLL

WINAPI: gluPerspective		GLU32.DLL

0
2 -- nSize
2 -- nVersion
CELL -- dwFlags
1 -- iPixelType
1 -- cColorBits
1 -- cRedBits
1 -- cRedShift
1 -- cGreenBits
1 -- cGreenShift
1 -- cBlueBits
1 -- cBlueShift
1 -- cAlphaBits
1 -- cAlphaShift
1 -- cAccumBits
1 -- cAccumRedBits
1 -- cAccumGreenBits
1 -- cAccumBlueBits
1 -- cAccumAlphaBits
1 -- cDepthBits
1 -- cStencilBits
1 -- cAuxBuffers
1 -- iLayerType
1 -- bReserved
CELL -- dwLayerMask
CELL -- dwVisibleMask
CELL -- dwDamageMask
CONSTANT PIXELFORMATDESCRIPTOR
0 VALUE pfd		\ ������� ��� opengl
PIXELFORMATDESCRIPTOR ALLOCATE THROW TO pfd
0x25 pfd dwFlags !
32 pfd cColorBits C! 
pfd FREE THROW

0 VALUE glhandle	\ 奭�� ����
0 VALUE glhdc		\ 奭�� ���⥪��

EXPORT

0.0E FVALUE X		\ ���न��� x
0.0E FVALUE Y		\ ���न��� y
0.0E FVALUE X1		\ ���न��� x1
0.0E FVALUE Y1		\ ���न��� y1
0.0E FVALUE X2		\ ���न��� x2
0.0E FVALUE Y2		\ ���न��� y2
0.0E FVALUE X3		\ ���न��� x3
0.0E FVALUE Y3		\ ���न��� y3

\ ���� ����ࠦ���� �࠭� � ���ᥫ��
: VScreen ( -> n )
	1 GetSystemMetrics ;

\ ��ਭ� ����ࠦ���� �࠭� � ���ᥫ��
: HScreen ( -> n )
	0 GetSystemMetrics ;

\ ��᫮ float � �⥪� float �� �⥪ ������
: F>FL  ( -> f ) ( F: f -> )
	[                 
	0x8D C, 0x6D C, 0xFC C, 
	0xD9 C, 0x5D C, 0x00 C, 
	0x87 C, 0x45 C, 0x00 C, 
	0xC3 C, ] ;

\ ��᫮ double � �⥪� float �� �⥪ ������
: F>DL ( -> d ) ( F: f -> )
	FLOAT>DATA SWAP ;

\ ��४������஢��� �᫮ �� �⥪� �� float
: S>FL ( n -> f )
	DS>F F>FL ;

\ ��४������஢��� �᫮ �� �⥪� � double
: S>DL ( n -> d )
	DS>F F>DL ;

\ �ᯥ�� ᮮ⭮襭�� �ਭ� � �����
: AScreen ( -> d )
	HScreen DS>F VScreen S>D D>F F/ F>DL ;

\ �뢮� 㪠������ �᫮ ����� �� �࠭ (�� �窨 �� 4)
: LineLoop ( n -> )
	DUP 0 > IF Y F>DL X F>DL glVertex2d DROP THEN
	DUP 1 > IF Y1 F>DL X2 F>DL glVertex2d DROP THEN
	DUP 2 > IF Y2 F>DL X2 F>DL glVertex2d DROP THEN
	DUP 3 > IF Y3 F>DL X3 F>DL glVertex2d DROP THEN
	DROP ;


\ �������� ����� �� �࠭�
: ShowCursore ( -> )
	1 ShowCursor DROP ;

\ ������� ����� c �࠭�
: HideCursore ( -> )
	0 ShowCursor DROP ;

\ ��室
: glClose ( -> )
	glhdc glhandle ReleaseDC 0 ExitProcess ;

\ �஢���� ����� �� ������ �� ��������� ����
: key ( n -- flag )
	GetAsyncKeyState ;

\ ���樠������ gl����
: glOpen ( -> )
 0 0 0 0 VScreen HScreen 0 0 0x90000000 S" edit" DROP DUP 8 CreateWindowExA
 DUP TO glhandle GetDC TO glhdc
 pfd DUP glhdc ChoosePixelFormat glhdc SetPixelFormat DROP
 glhdc wglCreateContext glhdc wglMakeCurrent DROP
 0x1102 0xC50 glHint DROP
 0x1701 glMatrixMode DROP
 100 S>DL 1 DS>F 10 DS>F F/ F>DL AScreen 90 S>DL gluPerspective DROP
 0x1700 glMatrixMode DROP ;

\ ������ ���� ����ࠦ����
: Cls ( -> )
	0x4000 glClear DROP ;

\ ����� ���� ����ࠦ���� (��� �ᮢ���)
: View ( -> )
	glhdc SwapBuffers DROP ;

\ �����筠� �����
: SingleMatrix ( -> )
	glLoadIdentity DROP ;

\ �믮���� ᤢ�� ⥪�饩 ������ �� ����� (x, y, z).
: ShiftMatrix ( F: f f f -> )
	F>DL F>DL F>DL glTranslated DROP ;

\ ������ �窨
: PointSize ( n -> )
	S>FL glPointSize DROP ;

\ �뢥�� 2D ��� �� �࠭ (X,Y)
: Point ( -> )
	0 glBegin DROP 1 LineLoop glEnd DROP ;

\ ��⠭����� 梥� (B G R)
: Color ( n n n -> )
	glColor3b DROP ;

\ �����稢��� ⥪���� ������ �� ������� 㣮� ����� ��������� �����.
\ z y x angle
: RotatedMatrix ( F: f f f f -> )
	F>DL F>DL F>DL F>DL glRotated DROP ;

\ �뢥�� 2D ����� (X,Y,X1,Y1)
: Line ( -> )
	1 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	glEnd DROP ;

\ ��ਭ� ��㥬�� �����
: LineSize ( n -> )
	S>FL glLineWidth DROP ;

\ �뢥�� 2D ��㣮�쭨� (X,Y,X1,Y1,X2,Y2)
: Triangle ( -> )
	4 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y2 F>DL X2 F>DL glVertex2d DROP
	glEnd DROP ;

\ ��ᮢ���� 䨣�� �஢����� �⨫��
: GlLine ( -> )
	0x1B01 0x408 glPolygonMode DROP ;

\ ��ᮢ���� 䨣�� ����襭�� �⨫��
: GlFill ( -> )
	0x1B02 0x408 glPolygonMode DROP ;

\ 2D ��אַ㣮�쭨� (X,Y,X1,Y1)
: Rectangle ( -> )
	7 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y F>DL X1 F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y1 F>DL X F>DL glVertex2d DROP
	glEnd DROP ;

\ �����������
: Smoothing ( -> )
	0xB10 glEnable DROP ;

\ ����� ᣫ��������
: NoSmoothing ( -> )
	0xB10 glDisable DROP ;

\ 2D �����㣮�쭨� (X,Y,X1,Y1,X2,Y2,X3,Y3)
: Tetragon ( -> ) 
	7 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y2 F>DL X2 F>DL glVertex2d DROP
	Y3 F>DL X3 F>DL glVertex2d DROP
	glEnd DROP ;

\ 2D 㣮� (X,Y,X1,Y1,X2,Y2)
: Corner ( -> )
	3 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y2 F>DL X2 F>DL glVertex2d DROP
	glEnd DROP ;

STARTLOG

;MODULE

0 VALUE msec					\ ��� ᨭ�࠭���樨
0 VALUE msei
0.0E FVALUE theta				\ 㣮� ������ ������
: main
 glOpen						\ ���樠������ opengl
 GlLine						\ ��㥬 �஢����� �⨫��
 Smoothing					\ ᣫ�������� �祪
 HideCursore					\ ������ �����
 0x1B key DROP					\ ��������� �� ���� ��ࠡ�⠥�
 BEGIN
  TIMER@ DROP TO msei				\ ᨭ�஭�����
  msei msec <> IF
   msei TO msec
   Cls						\ ���⪠ �࠭�
   SingleMatrix					\ ��⠭���� �������� ������
   0.0E 0.0E -5.0E ShiftMatrix			\ �⮤������ ������
   theta 0.0E 0.0E 1.0E RotatedMatrix           \ ���⨬ ������ ����� �ᥩ

   0 0 100 Color				\ ��⠭���� ���� 梥�
   10 PointSize					\ ࠧ��� �窨
   0.0E FTO X 0.0E FTO Y Point				\ ����㥬 �窨
   1.0E FTO Y Point
   2.0E FTO Y Point
   3.0E FTO Y Point
   4.0E FTO Y Point

   0 100 0 Color				\ ��⠭���� ������ 梥�
   3 LineSize                                   \ �ਭ� �����
   0.0E FTO Y 4.0E FTO X1 Line                  \ ����㥬 �����

   1 LineSize                                   \ �ਭ� �����
   100 0 0 Color				\ ��⠭���� ᨭ�� 梥�
   0.5E FTO Y1 2.0E FTO X1
   2.0E FTO Y2 1.5E FTO X2
   Triangle

   -4.0E FTO X 4.0E FTO Y
   -1.0E FTO X1 -2.0E FTO Y1
   Rectangle

   100 100 0 Color
   -3.5E FTO X 3.7E FTO Y
   1.5E FTO X1 2.0E FTO Y1
   3.4E FTO X2 -3.3E FTO Y2
   -1.0E FTO X3 -2.5E FTO Y3
   Tetragon

   100 100 100 Color
   -4.5E FTO X 3.2E FTO Y
   1.9E FTO X1 2.5E FTO Y1
   -3.4E FTO X2 -3.3E FTO Y2
   Corner

   View						\ ������� �� ���ᮢ���
   theta 0.5E F+ FTO theta
  THEN
 0x1B key UNTIL					\ 横� ���� �� ����� ESC
 glClose					\ ����뢠�� opengl �ਫ������
;

main


\EOF

glOpen		( -> ) - ���樠������ gl����
glClose		( -> ) - ��室
key		( n -> flag ) - ����� �� ������ �� ��������� ����

--- ��࠭ ---
VScreen		( -> n ) - ���� ����ࠦ���� �࠭� � ���ᥫ��
HScreen		( -> n ) - �ਭ� ����ࠦ���� �࠭� � ���ᥫ��
AScreen		( -> d ) - �ᯥ�� ᮮ⭮襭�� �ਭ� � �����
ShowCursore	( -> ) - �������� ����� �� �࠭�
HideCursore	( -> ) - ������ ����� c �࠭�
Cls		( -> ) - ������ ���� ����ࠦ����
View		( -> ) - ����� ���� ����ࠦ���� (��� �ᮢ���)
SingleMatrix	( -> ) - �����筠� �����
ShiftMatrix	( F: f f f -> ) - �믮���� ᤢ�� ⥪�饩 ������ �� �����
				(x, y, z).
RotatedMatrix	( F: f f f f -> ) - �����稢��� ⥪���� ������ �� ������� 㣮�
				����� ��������� ����� z y x angle.

--- float ---
F>FL		( -> f ) (F: f -- ) - �᫮ float � �⥪� float �� �⥪ ������
S>FL		( n -> f ) - ��४������஢��� �᫮ �� �⥪� �� float
F>DL		( -> d ) ( F: f -> ) - �᫮ double � �⥪� float �� �⥪ ������
S>DL		( n -> d ) - ��४������஢��� �᫮ �� �⥪� � double

--- �������� ---

Point		( -> ) - 2D �窠 �� �࠭ (X,Y)
Line		( -> ) - 2D ����� (X,Y,X1,Y1)
Triangle	( -> ) - 2D ��㣮�쭨� (X,Y,X1,Y1,X2,Y2)
Rectangle	( -> ) - 2D ��אַ㣮�쭨� (X,Y,X1,Y1)
Corner		( -> ) - 2D 㣮� (X,Y,X1,Y1,X2,Y2)

--- �����⢠ ����⮢ ---
Color		( n n n -> ) - ��⠭����� 梥� (B G R)
PointSize	( n -> ) - ࠧ��� �窨
LineSize	( n -> ) - �ਭ� ��㥬�� �����
GlLine		( -> ) - �ᮢ���� 䨣�� �஢����� �⨫��
GlFill		( -> ) - �ᮢ���� 䨣�� ����襭�� �⨫��
Smoothing	( -> ) - ᣫ��������
NoSmoothing	( -> ) - ���� ᣫ��������


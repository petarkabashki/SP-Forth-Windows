\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   wincon for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� ����᪮� ���᮫�
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.2
\ -----------------------------------------------------------------------------
REQUIRE STRUCT:	lib\ext\struct.f
REQUIRE { lib\ext\locals.f

WINAPI: GetModuleHandleA	KERNEL32.DLL

WINAPI: RegisterClassExA 	USER32.DLL
WINAPI: CreateWindowExA		USER32.DLL
WINAPI: LoadIconA		USER32.DLL
WINAPI: LoadCursorA		USER32.DLL
WINAPI: DefWindowProcA		USER32.DLL
WINAPI: PostQuitMessage		USER32.DLL
WINAPI: GetMessageA		USER32.DLL
WINAPI: TranslateMessage	USER32.DLL
WINAPI: DispatchMessageA	USER32.DLL
WINAPI: ShowWindow		USER32.DLL
WINAPI: MoveWindow		USER32.DLL
WINAPI: BeginPaint		USER32.DLL
WINAPI: EndPaint		USER32.DLL
WINAPI: GetDC			USER32.DLL
WINAPI: ReleaseDC		USER32.DLL
WINAPI: SendMessageA		USER32.DLL

WINAPI: DeleteObject		GDI32.DLL
WINAPI: CreateSolidBrush	GDI32.DLL
WINAPI: CreatePen		GDI32.DLL
WINAPI: CreateCompatibleDC	GDI32.DLL
WINAPI: DeleteDC		GDI32.DLL
WINAPI: CreateCompatibleBitmap	GDI32.DLL
WINAPI: BitBlt			GDI32.DLL
WINAPI: SelectObject		GDI32.DLL
WINAPI: Rectangle		GDI32.DLL



\ ������� ����� ����
STRUCT: WNDCLASSEX
 CELL -- cbSize
 CELL -- style
 CELL -- lpfnWndProc
 CELL -- cbClsExtra
 CELL -- cbWndExtra
 CELL -- hInstance
 CELL -- hIcon
 CELL -- hCursor
 CELL -- hbrBackground
 CELL -- lpszMenuName
 CELL -- lpszClassName
 CELL -- hIconSm
;STRUCT

\ ������� ᮮ�饭�� ����
STRUCT: MSG
 CELL -- hwnd
 CELL -- message
 CELL -- wParam
 CELL -- lParam
 CELL -- time
 CELL 4 * -- pt
;STRUCT

\ ������� �ᮢ����
STRUCT: PAINTSTRUCT
 CELL -- hdc
 CELL -- fErase
 CELL 4 * -- rcPaint
 CELL -- fRestore
 CELL -- fIncUpdate
 32 -- rgbReserved
;STRUCT

2 CONSTANT WM_DESTROY
0xF CONSTANT WM_PAINT

\ �뤥����� ����� ��� �������� ����� ����
CREATE classwin WNDCLASSEX::/SIZE ALLOT
CREATE msgwin MSG::/SIZE ALLOT
CREATE paint PAINTSTRUCT::/SIZE ALLOT

\ hendle ���᮫�
0 VALUE hwdwin
\ hendle ��⮪� ���᮫�
0 VALUE hwdwinp
\ ������ ���᮫� � ���ᥫ��
0 VALUE length
\ ���� ���᮫� � ���ᥫ��
0 VALUE height
\ ��ᯮ������� ���᮫� �⭮�⥫쭮 �࠭� �� �����
0 VALUE top
\ ��ᯮ������� ���᮫� �⭮�⥫쭮 �࠭� ᫥��
0 VALUE left
\ hdc ���᮫�
0 VALUE hdc
\ hdc ���᮫� � �����
0 VALUE phdc
\ hendel bitmap-� ���᮫� (���� ����ࠦ����
0 VALUE bufh
\ ���
0 VALUE penh
\ ����
0 VALUE color
\ ���騭�
0 VALUE psize
\ �����
0 VALUE brush
\ ���
0 VALUE background


\ ��室 �� �訡�� API �㭪権
: ERRORAPI ( -> )
	DUP 0=
	IF
		hdc hwdwin ReleaseDC DROP
		phdc DeleteDC DROP BYE
	THEN ;

\ ��室 �� �ணࠬ��
: BYE ( -> )
	hwdwinp STOP
	penh DeleteObject DROP
	hdc ReleaseDC DROP
	phdc DeleteDC DROP
	BYE ;

:NONAME { lpar wpar msg hwnd -- }
   msg WM_PAINT =
   IF
	paint hwdwin BeginPaint DROP
	0xCC0020 0 0 phdc height length top left hdc BitBlt DROP
	paint hwdwin EndPaint DROP
	0 EXIT
   THEN
   msg WM_DESTROY =
   IF
     0 PostQuitMessage
     BYE
   THEN
   lpar wpar msg hwnd DefWindowProcA
;

WNDPROC: MyWndProc

\ �������� ����� ��� ����
: INITWIN ( -> )
	48 classwin WNDCLASSEX::cbSize !
	0x23 classwin WNDCLASSEX::style !
	['] MyWndProc classwin WNDCLASSEX::lpfnWndProc !
	0 GetModuleHandleA ERRORAPI classwin WNDCLASSEX::hInstance !
	32512 0 LoadIconA ERRORAPI classwin WNDCLASSEX::hIcon !
	32512 0 LoadCursorA ERRORAPI classwin WNDCLASSEX::hCursor !
	0 CreateSolidBrush ERRORAPI classwin WNDCLASSEX::hbrBackground !
	S" CONSOLE" DROP classwin WNDCLASSEX::lpszClassName !
	classwin RegisterClassExA ERRORAPI DROP
	0 classwin WNDCLASSEX::hInstance @ 0 0 height length top left
	0x90000800 0 S" CONSOLE" DROP 0
	CreateWindowExA DUP ERRORAPI TO hwdwin
	BEGIN
		0 0 0 msgwin GetMessageA
	WHILE
		msgwin TranslateMessage DROP
		msgwin DispatchMessageA DROP
	REPEAT
	;

' INITWIN TASK: LoopWin


\ -+=================================================================+-

\ ��ॢ�� 梥⮢�� ����� � 梥�
: RGB ( R G B -> RGB )
	255 AND ROT 255 AND 16 LSHIFT ROT 255 AND 8 LSHIFT OR OR ;

\ ��⠭����� 梥� �ᮢ����
: Color ( RGB -> )
	penh DeleteObject DROP DUP TO color
	1 0 CreatePen DUP TO penh
	phdc SelectObject DROP ;

\ ��⠭����� 䮭 �ᮢ����
: Background ( RGB -> )
	DUP TO background
	brush DeleteObject DROP DUP TO brush
	CreateSolidBrush TO brush
	brush phdc SelectObject DROP ;

\ ������� ���᮫�
: ConCreate ( -> )
	200 TO length 100 TO height
	hwdwin 0= IF 0 LoopWin START TO hwdwinp THEN
	hwdwin GetDC ERRORAPI TO hdc 
	hwdwin CreateCompatibleDC ERRORAPI TO phdc
	bufh DeleteObject DROP
	height length hdc CreateCompatibleBitmap ERRORAPI TO bufh
	bufh phdc SelectObject ERRORAPI DROP
	0 CreateSolidBrush ERRORAPI
	phdc SelectObject ERRORAPI DROP
	0x00FFFFFF Color ;

\ ������� ���᮫�
: ConDestroy ( -> )
	hwdwinp STOP 0 TO hwdwin 0 TO length 0 TO height ;

\ ������� ���᮫�
: ConHide ( -> )
	0 hwdwin ShowWindow DROP ;

\ �������� ���᮫�
: ConShow ( -> )
	5 hwdwin ShowWindow DROP ;

\ �������� ���न���� ���᮫� �� �࠭�
: ConMove ( x y -> )
	TO top TO left
	1 height length top left hwdwin MoveWindow DROP ; 

\ �������� ������ � ����� ���᮫� � ������ ��
: ConSize ( length height -> )
	TO height TO length
	1 height length top left hwdwin MoveWindow DROP
	bufh DeleteObject DROP
	height length hdc CreateCompatibleBitmap ERRORAPI TO bufh
	bufh phdc SelectObject ERRORAPI DROP ;

\ ������ ���᮫�
: Cls ( -> )
	length height ConSize
	color background Color
	height length 0 0 phdc Rectangle DROP
	Color ;

\ �������� ���᮫�
: ConRefresh ( ->)
	0 0 WM_PAINT hwdwin SendMessageA DROP ;

ConCreate

\EOF

-+- ��� ᮧ����� ����� ���������⥩ -+-
phdc		( -> n ) - ���⥪�� ���᮫� � ����� �����⢫���� ���. �뢮�
hwdwin		( -> n ) - 奭��� ���� ���᮫�

-+- ���������� ����᪮� ���᮫� -+-
top		( -> n ) - �ᯮ������� ���᮫� �⭮�⥫쭮 �࠭� � �����
left		( -> n ) - �ᯮ������� ���᮫� �⭮�⥫쭮 �࠭� ᫥��
length		( -> n ) - ����� ���᮫� � ���ᥫ��
height		( -> n ) - ���� ���᮫� � ���ᥫ��
color		( -> RGB ) - ⥪�騩 梥�
background	( -> RGB ) - ⥪�騩 䮭

ConCreate	( -> ) - ������� ���᮫�
ConDestroy	( -> ) - 㤠���� ���᮫�
ConHide		( -> ) - ������ ���᮫�
ConShow		( -> ) - �������� ���᮫�
ConMove		( x y -> ) - �������� ���न���� ���᮫� �� �࠭�
ConSize		( length height -> ) - �������� ������ � ����� ���᮫� � ������ ��
Color		( RGB -> ) - ��⠭����� 梥� �ᮢ����
Background	( RGB -> ) - ��⠭����� 䮭 �ᮢ����
Cls		( -> ) - ������ ����
ConRefresh	( ->) - �������� ���᮫�

-+- �८�ࠧ������ -+-
RGB		( R G B -> RGB ) - ��ॢ�� 梥⮢�� ����� � 梥�

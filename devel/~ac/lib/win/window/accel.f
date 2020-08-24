\ ���������� ���������� "������ �������� ������" (�������������)
\ � (� ������� ����) �������� ������ ������� ��������� ��������� ����.

\ ������� ������������� ��� ��������� ���� � ���������� ATL-�����������,
\ ������� �� ����������� ������������, ��-�� ���� �� ���������� �����
\ ��������� �� �������� ���� DELETE, �� ������ �� � copy/paste, �.�.
\ � html-������� ����������� ���������� ��������. MS ��� �� ������ :)
\ ��. http://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=101801

\ ������������ � ����������� ������ ~day/wfl.

\ ��������� ������������� ��� ����������� � ���������� ~yz/winlib,
\ ������ ������� �������������� ����, �� �� ���������� � ������ 
\ ������� �������, ����� �������� ������.

\ TODO: ��� �����, ����� IDM_ � ������� TAB - ������ :)

\ FIXED: ��������� ���������� ������������� ������ �� ������� ����� �����,
\ �.�. ���� "����� ������", ��. TranslateBrowserAccelerator � browser.f.

\ REQUIRE WindowHide    ~ac/lib/win/window/window.f 

   1 CONSTANT FVIRTKEY
   2 CONSTANT FNOINVERT
   4 CONSTANT FSHIFT
   8 CONSTANT FCONTROL
0x10 CONSTANT FALT      

0x08 CONSTANT VK_BACK
0x09 CONSTANT VK_TAB
0x2D CONSTANT VK_INSERT
0x2E CONSTANT VK_DELETE
0x70 CONSTANT VK_F1
0x72 CONSTANT VK_F3
0x73 CONSTANT VK_F4


\ ��. mshtmcid.h, http://msdn.microsoft.com/en-us/library/aa741315(VS.85).aspx

2001 CONSTANT IDM_NEW
2000 CONSTANT IDM_OPEN
  70 CONSTANT IDM_SAVE
  27 CONSTANT IDM_PRINT
  43 CONSTANT IDM_UNDO
  16 CONSTANT IDM_CUT
  15 CONSTANT IDM_COPY
  26 CONSTANT IDM_PASTE
  67 CONSTANT IDM_FIND
2121 CONSTANT IDM_REPLACE
  17 CONSTANT IDM_DELETE
  17 CONSTANT IDM_CLEAR
2220 CONSTANT IDM_HELP ( _CONTENT)

\ #define IDM_CONTEXTMENU             2280
\ #define IDM_GOBACKWARD              2282
2283 CONSTANT IDM_GOFORWARD               
\ #define IDM_PRESTOP                 2284
\ #define IDM_REFRESH                 2300 ( F5)



   0 CONSTANT IDM_NEXT

: accel, ROT W, ( � �� C, ���� � BYTE) SWAP W, W, ;

CREATE ACCEL
\ ������������� FVIRTKEY OR ��� ���������� ������ ����� �� ������� 
\ �� ������������, �� ��� ����� ��������������� ����������� �� ��������
FCONTROL FVIRTKEY OR CHAR N IDM_NEW accel,
FCONTROL FVIRTKEY OR CHAR O IDM_OPEN accel,
FCONTROL FVIRTKEY OR CHAR S IDM_SAVE accel,
FCONTROL FVIRTKEY OR CHAR P IDM_PRINT accel,
FCONTROL FVIRTKEY OR CHAR Z IDM_UNDO accel,
FCONTROL FVIRTKEY OR CHAR X IDM_CUT accel,
FCONTROL FVIRTKEY OR CHAR C IDM_COPY accel,
FCONTROL FVIRTKEY OR CHAR V IDM_PASTE accel,
FCONTROL FVIRTKEY OR CHAR F IDM_FIND accel,
FCONTROL FVIRTKEY OR CHAR R IDM_REPLACE accel,

FALT     FVIRTKEY OR VK_BACK   IDM_UNDO accel,
FSHIFT   FVIRTKEY OR VK_DELETE IDM_CUT accel,
FCONTROL FVIRTKEY OR VK_INSERT IDM_COPY accel,
FSHIFT   FVIRTKEY OR VK_INSERT IDM_PASTE accel,

FVIRTKEY VK_DELETE IDM_DELETE accel,
FVIRTKEY VK_F3     IDM_NEXT accel,
FVIRTKEY VK_F1     IDM_HELP accel,

HERE ACCEL - 5 / CONSTANT #ACCEL

WINAPI: CreateAcceleratorTableA USER32.DLL
WINAPI: TranslateAcceleratorA USER32.DLL

: InitAccel ( -- h )
  #ACCEL ACCEL CreateAcceleratorTableA
;
\EOF

: MessageLoop2 ( wnd -- )
              \ ��������� ���������, ����������� � ������� ����
  || wnd mem haccel || (( wnd ))
  InitAccel -> haccel
  haccel 0= ABORT" CreateAcceleratorTable() error"
  /MSG ALLOCATE THROW -> mem
  BEGIN
    wnd IsWindow
    IF
      0 0 wnd mem GetMessageA 0 >
      mem CELL+ @ WM_CLOSE <> AND
      mem CELL+ @ WM_QUIT <> AND
    ELSE FALSE THEN
  WHILE
    DEBUG @ IF mem CELL+ @ WM_SYSTIMER <> IF mem 16 DUMP CR THEN THEN
    mem haccel wnd TranslateAcceleratorA 0=
    IF
      mem TranslateMessage DROP
      mem DispatchMessageA DROP
    THEN
  REPEAT
  mem FREE THROW
;
: TEST
  || h ||

  TRUE DEBUG !
  S" STATIC" SPF_STDEDIT 0 Window -> h
  500000 0 EM_EXLIMITTEXT h PostMessageA DROP

  400 200 h WindowPos
  150 250 h WindowSize
  h WindowShow
  h WindowMinimize
  h WindowRestore
  h MessageLoop2
  h WindowDelete
;

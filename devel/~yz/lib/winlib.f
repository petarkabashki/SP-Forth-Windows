\ WINLIB 1.14

\ ���������� ����������������� ���������� Windows
\ �. 1. ������� �������, ����, ����, ������� �������
\ �. �������, 8.12.2001

REQUIRE "       ~yz/lib/common.f
REQUIRE PROC:   ~yz/lib/proc.f
REQUIRE {       lib/ext/locals.f \ }
REQUIRE W:      ~yz/lib/wincons.f
REQUIRE >>      ~yz/lib/data.f
REQUIRE MGETMEM ~yz/lib/gmem.f
S" ~yz/cons/commctrl.const" LOAD-CONSTANTS

" yzWinLib" ASCIIZ classname

: OR! ( n a -- ) SWAP OVER @ OR SWAP ! ;
: ORC! ( c a -- ) SWAP OVER C@ OR SWAP C! ;

\ ��� ����� ��� ������, ������������ ����, �������� � �.�.
\ �� �������, ����� �������� ��������� ������� � ������������� � ������
\ �������, ���� ���������� � ������������ ������� � �������, � � ��� - ������ �����
\ ������ �������:
\ +0	b	����� (��. ����)
\ +1	�	������ / ����� ����� get
\ +5	�	����� ����� set
\ ��� ������-�������� � ������ ��� ����� ������ � ������ �������

\ �����
\ 7	���� ���������-getter
\ 6	���� ���������-setter
\ 5	����������� ������	(���� �� ������������)
\ 3-0	��� ������              (���� �� ������������)

0x40 == set-flag
0xC0 == getset-flag

: getter? ( a -- ?) C@ 0x80 AND ;
: setter? ( a -- ?) C@ 0x40 AND ;
: shared? ( a -- ?) C@ 0x20 AND ;
: datatype ( a -- ) C@ 0x0F AND ;

\ ���� ������
\ 0 == _val  \ ��������
\ 1 == _mem  \ ������� ������, �������� ����������� ����� FREEMEM
\ 2 == _gdi  \ ������ GDI, �������� ����������� ����� DeleteObject

2 CELLS 1+ == #tab

0 VALUE saved-names

: getproc ( index tab -- )
  >R #tab * R@ + DUP getter? IF 1+ @ R@ SWAP EXECUTE ELSE 1+ @ THEN RDROP ;

: setproc ( value index tab -- )
  >R #tab * R@ + DUP setter? IF 1+ CELL+ @ R@ SWAP EXECUTE ELSE 1+ ! THEN RDROP 
;

: indtab>a ( index tab -- addr) SWAP #tab * + 1+ ;
: store ( value index tab --) indtab>a ! ;
: storeset ( setproc index tab) indtab>a CELL+ ! ;
: setitem ( value1 value2 index tab -- )
  indtab>a >R
  SWAP R@ !
  R> CELL+ ! ;
: setflagitem ( val1 val2 flag index tab -- )
  indtab>a >R
  R@ 1- C!
  SWAP R@ !
  R> CELL+ ! ;

: make-getter ( ; index -- )
  DOES> ( tab -- ...) @ SWAP getproc ;
: make-setter ( ; index -- )
  DOES> ( ... tab -- ...) @ SWAP setproc ;
: make-constant ( ; index -- )
  DOES> ( -- index) @ ;

: table ( ->bl; parenttable/0 -- a)
  TEMP-WORDLIST TO saved-names
  CREATE HERE >R
  ?DUP IF 
    ( ptable) DUP CELL- @ DUP , #tab * DUP ALLOT ( pt #) R@ CELL+ SWAP CMOVE
  ELSE 
    0 ,
  THEN
  R>
  DOES> CELL+
;

: generate-names
  saved-names @
  BEGIN
    DUP
  WHILE
    DUP NAME> >BODY @ >R
    DUP COUNT ( a a2 n) >R PAD R@ CMOVE
    PAD R@ CREATED R>
    R@ , make-constant >R
    c: @ PAD R@ + C!
    PAD R@ 1+ CREATED R>
    R@ , make-getter
    DUP PAD + c: ! SWAP C!
    PAD SWAP 1+ CREATED
    R> , make-setter
    CDR
  REPEAT DROP ;

: endtable ( a -- ) 
  DROP 
  generate-names
  saved-names FREE-WORDLIST
;

: save-name ( ->bl; n --)
  GET-CURRENT >R
  saved-names SET-CURRENT
  CREATE ,
  R> SET-CURRENT
;

VARIABLE lastitem
: item ( ->bl ; a n -- a) 
  HERE lastitem !
  0 C, 0 , 0 ,  DUP @ save-name DUP 1+! ;

: shared  0x20 lastitem @ ORC! ;
: set  set-flag lastitem @ ORC! ;
: getset  getset-flag lastitem @ ORC! ;
: type ( n -- ) lastitem @ ORC! ;

: new-table ( table -- a)
  DUP CELL- @ #tab * DUP MGETMEM ( table # a )
  2DUP SWAP ERASE
  DUP >R SWAP CMOVE
  R> ;  

: del-table ( table -- ) MFREEMEM ;

\ ----------------------------------------
\ ��������, ����� ��� ���� ����
0 table common
  item -hwnd    	\ ���������� ����
  item -pre		\ ����������� �� ����������� ������� ���������
  item -wndproc		\ ������� ���������
  item -messages        \ ������ ������������ ��������� �� ���������
  item -style 	getset 	\ ����� ����
  item -color 		\ ���� ����
  item -bgcolor set	\ ���� ����
  item -bgbrush ( _gdi type)	\ ����� ��� ���� ����
  item -painter		\ ��������� ��������� ����
  item -xsize	\ ������ ���� �� �����������
  item -ysize	\ ������ ���� �� ���������
  item -parent	\ ����, � ������� �������� �������
  item -text getset	\ ������������ ������ ������ - 255 ��������. 
                	\ ��� richedit � ��� �������� - �������������� ������/������
  item -userdata        \ ���������������� ������
endtable

\ ����
0 table menu
  item -hmenu
  item -itemsinfo
endtable

WINAPI: SendMessageA USER32.DLL

: send-to-window ( wparam lparam msg hwnd -- result)
 2>R SWAP 2R> SendMessageA ;

: send ( wparam lparam msg win -- result)
  -hwnd@ send-to-window ;

: ?send ( ctl message -- n/ )  SWAP 0 0 2SWAP send ;
: wsend ( wparam ctl message -- n/ ) 0 -ROT SWAP send ;
: lsend ( lparam ctl message -- n/ ) >R 0 -ROT R> SWAP send ;

: set-text ( z ctl -- ) W: wm_settext lsend DROP ;

:NONAME \ get-text  tab --
  OVER >R >R 255 SWAP W: wm_gettext R> send R> + 0 SWAP C! ;
' set-text
-text common setitem

: -text# ( ctl -- ) W: wm_gettextlength ?send ;

0xFF0000 == red
0x00FF00 == green
0x0000FF == blue
0xFFFFFF == white
0x000000 == black
0xFFFF00 == yellow
0xFF00FF == violet
0x00FFFF == cyan

: >bgr { rgb -- bgr }
  ^ rgb C@ ^ rgb 2+ C@ ^ rgb C! ^ rgb 2+ C!
  rgb ; 
: rgb ( r g b -- rgb) SWAP 8 LSHIFT OR SWAP 16 LSHIFT OR ;

WINAPI: GetSysColor USER32.DLL

: syscolor ( index -- rgb)
  GetSysColor >bgr ;

-1 == transparent

WINAPI: CreateSolidBrush GDI32.DLL
WINAPI: GetStockObject   GDI32.DLL
WINAPI: SetBkColor       GDI32.DLL
WINAPI: SetTextColor     GDI32.DLL
WINAPI: SetBkMode        GDI32.DLL
WINAPI: DeleteObject     GDI32.DLL
WINAPI: InvalidateRect USER32.DLL
WINAPI: GetWindowRect  USER32.DLL

: invalidate { ctl \ [ 4 CELLS ] rect -- }
  ctl -parent@ IF
    rect ctl -hwnd@ GetWindowRect DROP
    TRUE rect ctl -parent@ -hwnd@ InvalidateRect DROP
  THEN ;
: ?invalidate ( ctl -- )
  DUP -bgcolor@ transparent = IF invalidate ELSE DROP THEN ;

0 \ get
:NONAME \ set-bgcolor ( rgb tab --)
  DUP >R -bgbrush@ DeleteObject DROP
  DUP -bgcolor R@ store
  DUP transparent = IF 
    DROP W: null_brush GetStockObject
    R@ invalidate
  ELSE
    >bgr CreateSolidBrush
  THEN
  R> -bgbrush!
;
-bgcolor common setitem

WINAPI: GetWindowLongA USER32.DLL
WINAPI: SetWindowLongA USER32.DLL

 :NONAME \ get-style   tab -- style
 W: gwl_style SWAP -hwnd@ GetWindowLongA ;
 :NONAME \ set-style   style tab --
 >R W: gwl_style R> -hwnd@ SetWindowLongA DROP ;
 -style common setitem

\ ----------------------------------------
common table window
 item -icon getset	\ ������
 item -smicon getset	\ ��������� ������
 item -menus		\ ���� ����
 item -status		\ ������
 item -toolbar          \ ������� ������������
 item -minustop		\ ������ ���������, ����������� ���� ������
 item -minusbottom	\ ������ ���������, ����������� ���� �����
 item -hscroll  	\ ������ ������������ �������������� ���������
 item -vscroll		\ ������ ������������ ������������ ���������
 item -grid set 	\ ������� ����
 item -gridresize     	\ ��������� ��������� �������� �������
\ item -gridctlresize
 item -dialog	  \ ������: ���� �� ������������ ���������� ������
 item -defaultbutton   \ ������ �� ���������
endtable

: window! ( n hwnd -- )
  W: gwl_userdata SWAP SetWindowLongA DROP ;

: window@ ( hwnd -- n)
  W: gwl_userdata SWAP GetWindowLongA ;

:NONAME \ get-icon  tab -- hicon
 >R W: icon_big 0 W: wm_geticon R> send ;
:NONAME \ set-icon  hicon tab --
 >R W: icon_big SWAP W: wm_seticon R> send DROP ;
-icon window setitem

:NONAME \ get-smicon  tab -- hicon
 >R W: icon_small 0 W: wm_geticon R> send ;
:NONAME \ set-smicon  hicon tab --
 >R W: icon_small SWAP W: wm_seticon R> send DROP ;
-smicon window setitem

\ ----------------------------------------
\ ������ ������������� �������:
\ +0 cell   ����� �������
\ +4 cell   ������� ���������
\ +8 ...    ������
: :no ;
: :ptr CELL+ ;
: :data 2 CELLS+ ;

: create-utable ( bytes -- ut)
  MGETMEM DUP :no 0! DUP :data OVER :ptr ! ;
: destroy-utable ( ut -- ) MFREEMEM ;
: u>> ( n ut -- )
  >R R@ :ptr @ !  R> :ptr CELL+! ;
: uw>> ( w ut -- )
  >R R@ :ptr @ W!  2 R> :ptr +! ;
: uc>> ( c ut -- )
  >R R@ :ptr @ C!  R> :ptr 1+! ;
: uan>> { a n ut -- }
  a ut :ptr @ n CMOVE
  n ut :ptr +! ;
: ut++ ( ut -- ) :no 1+! ;
: utable-size ( ut -- bytes )
  >R R@ :ptr @ R> :data - 0 :data + ;
: land-utable ( ut -- adr )
  >R HERE R@ OVER R> utable-size DUP ALLOT CMOVE ;
: land-utable-without-header ( ut -- adr )
  >R HERE R@ :data OVER R> utable-size 0 :data - DUP ALLOT CMOVE ;


\ ������ XtTable:
\ +0 c	���������� �������
\ +4 c  ���� �����
\ ������ �� ��� ������ ������:
\ id, xt

2 CELLS == #xttable

: :link CELL+ ;

VARIABLE xtname
0 VALUE xttable

0 VALUE ytable

: init-xtptr 
  300 CELLS create-utable TO xttable ;
: >xtptr ( n -- ) xttable u>> ;

: save-xtname ( a # -- )
  DUP 1+ MGETMEM xtname !
  DUP xtname @ C!  xtname @ 1+ SWAP CMOVE ;

: init-yptr
  100 CELLS create-utable TO ytable ;
: >yptr ( n -- ) ytable u>> ;
: c>yptr ( c -- ) ytable uc>> ;
: >>yptr ( a # -- )
  DUP >R ytable :ptr @ CZMOVE  R> 1+ ytable :ptr +! ;

: MESSAGES: ( ->bl; -- )
  BL PARSE save-xtname
  init-xtptr ;

: create-saved-xtname  
  xtname @ COUNT CREATED 
  xtname @ MFREEMEM ;

: land-xttable  ( -- )
  xttable land-utable :link 0! ;

: land-ytable ( -- )
  ytable land-utable-without-header DROP ;

: MESSAGES; ( -- )
  create-saved-xtname
  land-xttable  xttable destroy-utable
;

: :M ( msg# -- xt secret-sign)
  :NONAME CELL" M:  "
;

: M: ( ->message-name; -- msg# xt secret-sign)
  BL PARSE FIND-CONSTANT2 :M
;

: M; ( msg# xt secret-sign -- )
  CELL" M:  " <> ABORT" M; ��� M:"
  S" ;" EVAL-WORD
  ( msg# xt ) SWAP >xtptr >xtptr  xttable ut++
; IMMEDIATE

\  xlist:
\ +0 n	��������� �� ������ ������� ������ / 0
\ +4 n	��������� �� ��������� ������� ������

: XLIST ( ->bl; -- )
  CREATE 0 , 0 , ;

: create-xlist ( -- xlist)
  0 0 2 CELLS MGETMEM DUP >R 2! R> ;

: empty-xlist ( xlist -- )
  0 0 ROT 2! ;
  
: insert-to-begin { xtable xlist -- }
  xlist @ IF
    xlist @ xtable :link !
  ELSE
    xtable :link 0!
    xtable xlist CELL+ !
  THEN 
  xtable xlist ! 
;

: insert-to-end { xtable xlist -- }
  xlist @ IF
    xtable xlist CELL+ @ :link !
  ELSE
    xtable xlist ! 
  THEN 
  xtable :link 0!
  xtable xlist CELL+ !
;

: find-in-xtable ( id xttable -- result true / false)
  DUP 0= IF 2DROP FALSE EXIT THEN
  DUP @ #xttable * SWAP 2 CELLS+ DUP >R + R>
  ?DO
    DUP I @ = IF DROP I CELL+ @ EXECUTE TRUE UNLOOP EXIT THEN
  #xttable +LOOP
  DROP FALSE ;

\ ���� ��������� ����� ������� false, ������ ���, ��� ������ �� �����
: ?find-in-xtable ( id xttable -- ?)
  find-in-xtable DUP IF DROP THEN ;

USER-VALUE return-value
USER-VALUE this-xlist
USER-VALUE this-id

: RETURN ( n -- ) TO return-value ;

: find-and-execute ( id xlist -- ? )
  TO this-xlist  TO this-id
  this-xlist 0= IF FALSE EXIT THEN
  this-xlist @ ?DUP 0= IF FALSE EXIT THEN
  TO this-xlist
  BEGIN
    this-id this-xlist find-in-xtable ?DUP IF EXIT THEN
    this-xlist :link @ DUP TO this-xlist
  0= UNTIL 
  FALSE ;

: ?find-and-execute ( id xlist -- ? )
  TO this-xlist  TO this-id
  this-xlist 0= IF FALSE EXIT THEN
  this-xlist @ ?DUP 0= IF FALSE EXIT THEN
  TO this-xlist
  BEGIN
    this-id this-xlist ?find-in-xtable ?DUP IF EXIT THEN
    this-xlist :link @ DUP TO this-xlist
  0= UNTIL 
  FALSE
;

WINAPI: AdjustWindowRectEx USER32.DLL

\ ����������� ������ ������ ���� �� ������� ���������� �������
\ + ������ ������� + ������ ������ �����������
: nc-win-size { dx dy win \ [ 4 CELLS ] rect -- ex ey }
  dx rect 2 CELLS!  dy  rect 3 CELLS!
  W: gwl_exstyle win -hwnd@ GetWindowLongA win -menus@ 
  W: gwl_style win -hwnd@ GetWindowLongA rect 
  AdjustWindowRectEx DROP
  rect 2 CELLS@ rect @ -   rect 3 CELLS@ rect 1 CELLS@ -
  win -minustop@ + win -minusbottom@ +
;

\ --------------------------------------
0 VALUE winmain
0 VALUE current-window
0 VALUE accel-xtable
\ --------------------------------------
\ ������� �������

USER-VALUE hwnd
USER-VALUE message
USER-VALUE wparam
USER-VALUE lparam
USER-VALUE thiswin
USER-VALUE thisctl

WINAPI: BeginPaint USER32.DLL
WINAPI: EndPaint   USER32.DLL

USER-VALUE windc
USER-VALUE paint-rect

: wm-paint-proc 
 { \ [ 64 ] paintstruct -- }
 paintstruct hwnd BeginPaint TO windc
 paintstruct 2 CELLS + TO paint-rect
 thiswin -painter@ EXECUTE
 paintstruct hwnd EndPaint DROP
 TRUE
;

\ --------------------------------------
\ ������� ������� ��� ����������� ����

MESSAGES: main-dispatch

\ �������� ��� 
WINAPI: FillRect      USER32.DLL
WINAPI: GetClientRect USER32.DLL

M: wm_erasebkgnd
  { \ [ 4 CELLS ] rect -- }
  rect hwnd GetClientRect DROP
  thiswin -bgbrush@ rect wparam FillRect DROP
  TRUE RETURN
  TRUE
M;

M: wm_paint
 wm-paint-proc
M;

VECT menu-painter

M: wm_drawitem
   lparam @ W: odt_menu = IF 
     \ ��� ����
     menu-painter 
   ELSE
     \ ��� ������� ����������
     lparam 6 CELLS@ TO windc
     lparam 7 CELLS+ TO paint-rect
     lparam 5 CELLS@ window@ ?DUP IF
       -painter@ EXECUTE
     THEN
   THEN
   TRUE
M;

WINAPI: PostQuitMessage USER32.DLL

0 VALUE modal-window
VECT del-grid

M: wm_destroy
  thiswin -grid@ ?DUP IF del-grid THEN
  thiswin modal-window = IF 0 TO modal-window THEN
  winmain -hwnd@ hwnd = IF 0 PostQuitMessage DROP THEN
  TRUE
M;

0 VALUE dialog
0 VALUE dialog-termination

: end-dialog ( code -- ) TO dialog-termination ;
: dialog-ok  ( -- ) W: idok end-dialog ;
: dialog-cancel ( -- ) W: idcancel end-dialog ;

M: wm_close
  dialog 0= IF FALSE EXIT THEN
  hwnd dialog -hwnd@ = DUP >R IF dialog-cancel THEN R>
M;

WINAPI: PostMessageA USER32.DLL

\ lparam: 0  wparam: 0 - next, 1 - previous
M: wm_nextdlgctl
  lparam 0= thiswin -dialog@ AND IF
    wparam IF
      \ ��������� ������� Shift-Tab
      0x002A0001 W: vk_shift W: wm_keydown hwnd PostMessageA DROP
      0x000F0001 W: vk_tab   W: wm_keydown hwnd PostMessageA DROP
      0xC00F0001 W: vk_tab   W: wm_keyup   hwnd PostMessageA DROP
      0xC02A0001 W: vk_shift W: wm_keyup   hwnd PostMessageA DROP
    ELSE 
      \ ��������� ������� Tab
      0x000F0001 W: vk_tab W: wm_keydown hwnd PostMessageA DROP
      0x800F0001 W: vk_tab W: wm_keyup   hwnd PostMessageA DROP
    THEN  
  THEN
  TRUE
M;

M: wm_size
  \ ���������� ����� ������
  lparam LOWORD thiswin -xsize!
  lparam HIWORD thiswin -minustop@ - thiswin -minusbottom@ - thiswin -ysize!
  \ �������� ���� ������� � ������ ������������ � ���, ��� ������ ���������
  thiswin -status@ ?DUP IF
    >R 0 0 W: wm_size R> send DROP
  THEN
  thiswin -toolbar@ ?DUP IF
    >R 0 0 W: wm_size R> send DROP
  THEN
  \ �������� ������� ��������������
  thiswin -grid@ IF thiswin -gridresize@ EXECUTE THEN
  TRUE
M;

M: wm_getminmaxinfo
  thiswin -grid@ ?DUP IF
    DUP 2 CELLS@ SWAP 3 CELLS@ thiswin nc-win-size
    lparam 7 CELLS! lparam 6 CELLS!
    TRUE
  THEN
M;

WINAPI: SetActiveWindow USER32.DLL

0 VALUE dialog-filter

M: wm_activate
  \ ���� �������������� ���� � ������������� -dialog, ���������� ��� 
  \ ����������
  wparam LOWORD W: wa_inactive <> IF 
    thiswin -dialog@ IF hwnd ELSE 0 THEN
  THEN TO dialog-filter
  \ ���� ���� ��������� ����, �� ���� ������������� �� ������
  modal-window 0= IF FALSE EXIT THEN
  wparam LOWORD W: wa_inactive <> hwnd modal-window <> AND IF
    modal-window SetActiveWindow DROP
    TRUE
  ELSE 
    FALSE 
  THEN
M;

VECT command  ' NOOP TO command
VECT scrollctlproc  ' NOOP TO scrollctlproc
VECT notifyproc  ' NOOP TO notifyproc

10 == first-menu-id \ ����� ���� ����� IDxxx

M: wm_command
   lparam IF
     \ ������ �� ��������
     command
   ELSE
     wparam HIWORD IF
       \ ������� ������� 
       wparam LOWORD accel-xtable find-in-xtable DROP
     ELSE
       wparam LOWORD DUP first-menu-id < IF
         \ ���������� �������
         DUP W: idok = IF
           \ ���� ������ Enter - ���������� �������
           \ ������ �� ���������
           DROP
           thiswin -defaultbutton@ ?DUP IF
             W: bm_click ?send DROP
           THEN
         ELSE
           end-dialog
         THEN
       ELSE
         \ ������ �� ����
         thiswin -menus@ find-and-execute DROP
       THEN
     THEN
   THEN
   TRUE
M;

: set-colors
  lparam window@ DUP 0= IF EXIT THEN \ �� ���� ����
  TO thisctl
  thisctl -bgcolor@ transparent = IF
    W: transparent wparam SetBkMode DROP
  THEN
  thisctl -bgcolor@ >bgr wparam SetBkColor DROP
  thisctl -color@ >bgr wparam SetTextColor DROP
  thisctl -bgbrush@ RETURN
  TRUE ;

M: wm_ctlcolorstatic
  set-colors
M;

M: wm_ctlcoloredit
   set-colors
M;

M: wm_ctlcolorlistbox
  set-colors
M;

M: wm_ctlcolorscrollbar
  set-colors
M;

M: wm_hscroll
  lparam IF
    scrollctlproc
  ELSE
    wparam LOWORD thiswin -hscroll@ find-in-xtable DROP
  THEN 
  TRUE
M;

M: wm_vscroll
  lparam IF
    scrollctlproc
  ELSE
    wparam LOWORD thiswin -vscroll@ find-in-xtable DROP
  THEN
  TRUE 
M;

M: wm_notify
   notifyproc
M;

MESSAGES;

\ ---------------------------------
\ ����������� ������� ������� ��� ��������� ����������

MESSAGES: control-std-wndproc

M: wm_paint
  wm-paint-proc
M;

M: wm_size
  lparam LOWORD thiswin -xsize!
  lparam HIWORD thiswin -ysize!
 TRUE
M;

MESSAGES;

\ -------------------------------

XLIST common-window-proclist
XLIST common-control-proclist

: extend-window-proc  ( xtable -- ) common-window-proclist insert-to-end ;

WINAPI: DefWindowProcA USER32.DLL

:NONAME ( lparam wparam msg hwnd -- result)
  TO hwnd  TO message  TO wparam  TO lparam 
\      ." hwnd=" hwnd . ." message=" message .H 
\      ." wparam=" wparam . ." lparam=" lparam .H CR
  hwnd window@ TO thiswin
  thiswin 0= IF
    \ ���� ��� �� ������������
    lparam wparam message hwnd DefWindowProcA EXIT
  THEN
  0 TO return-value
  message thiswin -pre@ ?find-in-xtable
  ?DUP 0= IF
    message thiswin -messages@ ?find-and-execute
    ?DUP 0= IF
      message thiswin -wndproc@ ?find-in-xtable
    THEN
  THEN
  IF  \ ���-�� ��������� ���������
    return-value
  ELSE
    lparam wparam message hwnd DefWindowProcA
  THEN
\  ." /" message .H DUP . CR
; WNDPROC: dispatch

\ --------------------------------------
\ ��������� � ����������� ����

WINAPI: CreateWindowExA USER32.DLL
WINAPI: ShowScrollBar   USER32.DLL
WINAPI: LoadIconA       USER32.DLL

: create-window-with-styles  ( parent style exstyle -- )
  { parent style exstyle \ win [ 4 CELLS ] rect -- a/0 }
  (* ws_hscroll ws_vscroll *) ^ style OR!
  window new-table TO win
  common-window-proclist win -messages!
  0 IMAGE-BASE 0 
  parent DUP IF -hwnd@ style W: ws_child OR TO style THEN
  W: cw_usedefault DUP 2DUP style ""
  classname exstyle CreateWindowExA DUP 0= IF win del-table EXIT THEN
  ( hwnd) DUP >R win -hwnd!
  win R> window!
  ['] NOOP win -painter!
  \ ������� ������ ���������
  FALSE W: sb_both win -hwnd@ ShowScrollBar DROP
  \ �������� ������
  parent 0= IF
    1 IMAGE-BASE LoadIconA win -icon!
    2 IMAGE-BASE LoadIconA win -smicon!
  THEN
  win DUP TO current-window ;

: create-window ( parent -- win/0)
  W: ws_overlappedwindow W: ws_ex_appwindow  
  create-window-with-styles
  DUP IF W: color_window syscolor OVER -bgcolor! THEN ;

: dialog-window ( parent -- win/0)
  DUP IF 
    (* ws_popupwindow ws_caption ws_clipsiblings *)
    (* ds_modalframe ds_setforeground ds_control *) OR
  ELSE
    (* ws_overlapped ws_caption ws_dlgframe ws_clipsiblings ws_sysmenu *) 
  THEN
  W: ws_ex_controlparent
  create-window-with-styles
  DUP IF
    W: color_3dface syscolor OVER -bgcolor!
    TRUE OVER -dialog!
  THEN ;

: tool-window ( parent -- win/0)
  W: ws_overlappedwindow W: ws_ex_palettewindow
  create-window-with-styles
  DUP IF W: color_3dface syscolor OVER -bgcolor! THEN ;

WINAPI: DestroyWindow USER32.DLL

: destroy-window ( win -- )
  DUP -hwnd@ DestroyWindow DROP
  del-table ;

\ --------------------------------------
\ ������������ �������� ��� ������

WINAPI: ShowWindow USER32.DLL

: (show) ( win flag -- )
  SWAP -hwnd@ ShowWindow DROP ;
: winshow ( win -- ) W: sw_show (show) ;
: winhide ( win -- ) W: sw_hide (show) ;
: winminimize ( win -- ) W: sw_minimize (show) ;
: winmaximize ( win -- ) W: sw_maximize (show) ;
: winrestore ( win -- ) W: sw_normal (show) ;

WINAPI: EnableWindow USER32.DLL

: winenable ( win -- )
  TRUE SWAP -hwnd@ EnableWindow DROP ;
: windisable ( win -- )
  FALSE SWAP -hwnd@ EnableWindow DROP ;

WINAPI: SetFocus USER32.DLL

: winfocus ( ctl -- ) -hwnd@ SetFocus DROP ;

: win-rect { win \ [ 4 CELLS ] rect -- x1 y1 x2 y2 }
  rect win -hwnd@ GetWindowRect DROP
  rect @  rect 1 CELLS@ 
  rect 2 CELLS@  rect 3 CELLS@
;

WINAPI: ScreenToClient USER32.DLL

\ �� �� �����, �� � ����������� ������������� ����
: child-win-rect { win \ [ 4 CELLS ] rect -- x1 y1 x2 y2 }
  rect win -hwnd@ GetWindowRect DROP
  win -parent@ ?DUP IF
    -hwnd@ rect OVER ScreenToClient DROP
    rect 2 CELLS+ SWAP ScreenToClient DROP
  THEN
  rect @  rect 1 CELLS@ 
  rect 2 CELLS@  rect 3 CELLS@
;

\ ��������� ������ ����
: win-size ( win -- )
  win-rect SWAP >R SWAP - R> ROT - SWAP ;

WINAPI: SetWindowPos USER32.DLL

: winmove ( x y win -- )
  >R >R >R (* swp_nosize swp_noownerzorder swp_nozorder *) 0 0 R> R> SWAP
  0 R> -hwnd@ SetWindowPos DROP ;

: new-size ( xsize ysize win -- )
  >R SWAP (* swp_nomove swp_noownerzorder swp_nozorder *) -ROT 
  0 0 0 R> -hwnd@ SetWindowPos DROP ;

\ �������� ������ �������� ���� (���� ������ ����������)
: resize ( xsize ysize win -- )
  DUP >R new-size
  R@ win-size R@ -ysize! R> -xsize!
;

\ �������� ������ �������� ����
: winresize ( xsize ysize win -- )
  DUP >R nc-win-size R> new-size
  \ ����� ������ ���� � ���� ������� ��������� wm_size
;

\ ��������� ���� �������������� � ��������� �����
: force-redraw ( win -- )
  TRUE 0 ROT -hwnd@ InvalidateRect DROP
;
\ --------------------------------------
\ Message Boxes

\ ���� = 0, �� ��������� ������� ������ ��������� "������"
0 VALUE mbox-title

WINAPI: MessageBoxA USER32.DLL

: message-box ( title text style -- result)
  ROT ROT winmain DUP IF -hwnd@ THEN MessageBoxA ;
: msg ( text -- )
  mbox-title SWAP (* mb_ok mb_iconwarning *) message-box DROP ;
: err ( text -- )
  mbox-title SWAP (* mb_ok mb_iconstop *) message-box DROP ;

\ --------------------------------------
\ ������ ����������
WINAPI: GetSystemMetrics USER32.DLL

: screen-x ( -- x) W: sm_cxscreen GetSystemMetrics ;
: screen-y ( -- x) W: sm_cyscreen GetSystemMetrics ;

\ --------------------------------------
: wincenter ( win -- )
  DUP >R win-size screen-y SWAP - 2/ SWAP screen-x SWAP - 2/ SWAP R> 
  winmove ;

\ --------------------------------------
\ ������� ���������������

VARIABLE menu-id   first-menu-id menu-id !
: next-menu-id  ( -- n) menu-id @  menu-id 1+! ;
 
\ --------------------------------------
\ �������

VARIABLE menu-flags

: MENU: ( ->bl; -- )
  menu-flags 0!
  init-xtptr
  init-yptr
  BL PARSE save-xtname ;

: LINE ( -- )
  2 CELLS 1+ c>yptr
  CELL" line" >yptr 
  W: mf_separator >yptr 
  menu-flags 0! ;

: SUBMENU ( ->eol; menu -- )
  >R
  1 PARSE
  DUP 2+ 3 CELLS + c>yptr 
  CELL" menu" >yptr
  menu-flags @ (* mf_string mf_popup *) OR >yptr
  menu-flags 0!
  R> >yptr 
  >>yptr ;

: MENUITEM ( ->eol; proc -- )
  1 PARSE HERE ESC-CZMOVE
  HERE DUP ZLEN
  DUP 2+ 3 CELLS + c>yptr
  CELL" item" >yptr
  menu-flags @ (* mf_string mf_enabled *) OR >yptr
  menu-flags 0!
  next-menu-id DUP >yptr >xtptr 
  >>yptr
  >xtptr xttable ut++ ;

: CHECKED   W: mf_checked menu-flags OR! ;
: DISABLED  W: mf_grayed  menu-flags OR! ;

: MENU; ( -- )
  0 c>yptr
  create-saved-xtname
  \ ������ table �������
  0 C, 0 , 0 , \ ���� � ���� ����� ����� �������� hmenu
  0 C, HERE xttable utable-size + 2 CELLS + , 0 , \ ����� ������� � ����������� �� ��������� ����
  land-xttable  \ xttable
  land-ytable   \ ���������� �� ��������� ����
  xttable destroy-utable
  ytable destroy-utable
;

VARIABLE (wake-menu)

WINAPI: AppendMenuA USER32.DLL

: append-to-menu { menu hmenu \ ptr flags -- }
  menu -itemsinfo@ TO ptr
  BEGIN
    ptr C@
  WHILE
    ptr 1+ CELL+ @ TO flags
    ptr 1+ @ CASE
      CELL" line" OF 
        0 0 flags hmenu AppendMenuA DROP
      ENDOF
      CELL" item" OF
        ptr 1+ 3 CELLS +  ptr 1+ 2 CELLS + @ ( id) flags hmenu AppendMenuA DROP
      ENDOF
      CELL" menu" OF
        ptr 1+ 3 CELLS+  
        ptr 1+ 2 CELLS + @ ( menu)
          DUP (wake-menu) @ EXECUTE -hmenu@ flags hmenu AppendMenuA DROP
      ENDOF
    DROP
    END-CASE 
    ptr C@ ptr + TO ptr
  REPEAT
  hmenu menu -hmenu! ;

WINAPI: CreatePopupMenu USER32.DLL
WINAPI: CreateMenu      USER32.DLL
WINAPI: DestroyMenu     USER32.DLL
WINAPI: DrawMenuBar     USER32.DLL

: wake-menu ( menu -- )
  DUP -hmenu@ 0= IF
  CreatePopupMenu append-to-menu 
  ELSE
    DROP 
  THEN ;

' wake-menu (wake-menu) !

: wake-menubar ( menu -- ) 
  DUP -hmenu@ 0= IF
    CreateMenu append-to-menu 
  ELSE
    DROP 
  THEN ;

: destroy-menu ( menu -- )
  DUP -hmenu@ DestroyMenu DROP 
  0 SWAP -hmenu! ;

WINAPI: SetMenu USER32.DLL

: append-xtable-to-menuslist { menu mlist \ ptr -- }
  menu 2 #tab * + mlist insert-to-end
  menu -itemsinfo@ TO ptr
  BEGIN
    ptr C@
  WHILE
    ptr 1+ @ CELL" menu" = IF
      ptr 1+ 2 CELLS+ @ mlist RECURSE
    THEN
    ptr C@ ptr + TO ptr
  REPEAT
;

: make-menus-list ( menu -- menu-list )
  create-xlist DUP >R
  append-xtable-to-menuslist
  R> 
;

: attach-menubar ( menu window -- ) 
  SWAP DUP wake-menubar DUP make-menus-list >R -hmenu@ SWAP 
  DUP R> SWAP -menus! -hwnd@ SetMenu DROP ;
: detach-menubar ( window -- )
  DUP -menus@ MFREEMEM
  0 OVER -menus!
  0 SWAP -hwnd@ SetMenu DROP ;

WINAPI: TrackPopupMenu USER32.DLL

\ �������� ������ ��� ������������� winmain
: show-menu { menu x y \ menulist -- }
  menu wake-menu
  menu make-menus-list TO menulist
  0 winmain -hwnd@ 0 y x (* tpm_leftalign tpm_returncmd *) menu -hmenu@
  TrackPopupMenu
  ?DUP IF menulist find-and-execute DROP THEN
  menulist MFREEMEM
;

WINAPI: EnableMenuItem     USER32.DLL
WINAPI: SetMenuDefaultItem USER32.DLL
WINAPI: CheckMenuItem      USER32.DLL
WINAPI: CheckMenuRadioItem USER32.DLL
WINAPI: GetMenuState       USER32.DLL
WINAPI: GetMenuItemID      USER32.DLL

: check-menu-item ( no menu -- ) 
  >R (* mf_byposition mf_checked *) SWAP R> -hmenu@ CheckMenuItem DROP ;
: uncheck-menu-item ( no menu -- ) 
  >R (* mf_byposition mf_unchecked *) SWAP R> -hmenu@ CheckMenuItem DROP ;

: (un)check-me ( -- ?)
  W: mf_bycommand this-id this-xlist -3 CELLS@ GetMenuState
  W: mf_checked AND 0= >R
  R@ IF W: mf_checked ELSE W: mf_unchecked THEN 
  this-id this-xlist -3 CELLS@ CheckMenuItem DROP 
  R> ;

: check-menu-radio ( first last no menu -- )
  >R >R W: mf_byposition ROT ROT R> ROT ROT SWAP R> -hmenu@ CheckMenuRadioItem
  DROP ;

: select-me { first last -- }
  this-xlist -3 CELLS@ >R
  W: mf_bycommand this-id
  last R@ GetMenuItemID DUP -1 = IF DROP 0 THEN
  first R@ GetMenuItemID DUP -1 = IF DROP 0 THEN
  R> CheckMenuRadioItem DROP 
;

: enable-menu-item ( no menu -- ) 
  >R (* mf_byposition mf_enabled *) SWAP R> -hmenu@ EnableMenuItem DROP ;
: disable-menu-item ( no menu -- ) 
  >R (* mf_byposition mf_grayed *) SWAP R> -hmenu@ EnableMenuItem DROP ;

: default-menu-item ( no menu -- )
  >R TRUE SWAP R> -hmenu@ SetMenuDefaultItem DROP ;

: redraw-window-menu ( win -- )
  -hwnd@ DrawMenuBar DROP ;

\ --------------------------------------
\ ������� �������� ������

0 VALUE acctable

: KEYTABLE ( -- )
  1000 CELLS create-utable TO acctable 
  init-xtptr
;

: ?modifier ( adr n -- adr1 n1 flags )
  OVER >R S" ctrl+"  R> OVER COMPARE 0= IF 5 - SWAP 5 + SWAP  W: fcontrol EXIT THEN
  OVER >R S" alt+"   R> OVER COMPARE 0= IF 4 - SWAP 4 + SWAP  W: falt     EXIT THEN  
  OVER >R S" shift+" R> OVER COMPARE 0= IF 6 - SWAP 6 + SWAP  W: fshift   EXIT THEN
  0
;

: parse-key ( adr n -- key flags )
  { \ flags }
  W: fvirtkey TO flags
  BEGIN 
    ?modifier ( -- adr1 n1 flag) ?DUP WHILE
    ^ flags OR!
  REPEAT
  OVER >R FIND-CONSTANT 0= IF R@ C@ THEN RDROP
  flags
;

\ ������� ������ ������� ��� ��������� ��� ���� id, ���� ���� � ��� ��� ����
\ ���� ���, ���������� MENUITEM. ��� �� �������, ��������� 16000 id ������
\ ������� ����
: ONKEY ( ->bl; proc -- ) 
  BL PARSE parse-key acctable uc>> 
  0 acctable uc>> acctable uw>>
  next-menu-id DUP acctable uw>>
  acctable ut++
  >xtptr >xtptr  xttable ut++
;

: KEYTABLE; ( -- )
  acctable land-utable
  acctable destroy-utable 
  TO acctable
  HERE TO accel-xtable
  land-xttable
  xttable destroy-utable
;

\ ----------------------------------
\ ������
VARIABLE font-attr   font-attr 0!
: bold   1 font-attr OR! ;
: italic 2 font-attr OR! ;
: underline  4 font-attr OR! ;
: strike-out 8 font-attr OR! ;

0 VALUE logpixels

: pt>devunits ( n -- n1) logpixels 72 */ NEGATE ;

WINAPI: CreateFontA GDI32.DLL

: create-font-devunits ( zname devunits -- ) 
  >R (* default_pitch ff_dontcare *) W: default_quality
  W: clip_default_precis W: out_default_precis W: ansi_charset
  font-attr @ 8 AND  font-attr @ 4 AND  font-attr @ 2 AND 
  font-attr @ 1 AND IF 700 ELSE 400 THEN
  0 0 0 R> CreateFontA 
  font-attr 0! ;

: create-font ( zname size -- font )
  pt>devunits create-font-devunits ;
  
: delete-font ( font -- ) DeleteObject DROP ;

0 VALUE def-font

\ --------------------------------------
0 VALUE hbaseunits
0 VALUE vbaseunits

\ �������� ������� ���������� ������ � �������
: hdu ( n -- n1) hbaseunits 4 */ ;
: vdu ( n -- n1) vbaseunits 8 */ ;
: dunits ( n n1 -- n2 n3) vdu SWAP hdu SWAP ;
\ --------------------------------------
\ ����������� ������ ���� � ����� �������������

WINAPI: InitCommonControlsEx COMCTL32.DLL

: initcc { what \ [ 2 CELLS ] buf -- }
  2 CELLS buf !
  what buf CELL+ !
  buf InitCommonControlsEx DROP ;

WINAPI: RegisterClassA     USER32.DLL
WINAPI: GetDialogBaseUnits USER32.DLL
WINAPI: LoadCursorA        USER32.DLL
WINAPI: CreateCompatibleDC GDI32.DLL
WINAPI: GetDeviceCaps GDI32.DLL
WINAPI: DeleteDC      GDI32.DLL

: WINDOWS...
\ �������������
  main-dispatch common-window-proclist insert-to-begin
  control-std-wndproc common-control-proclist insert-to-begin
\ ����������� ������ ����
  HERE init->>
\ typedef struct _WNDCLASS {    // wc  
 (* cs_vredraw cs_hredraw cs_dblclks cs_bytealignclient *) >>  \ UINT    style; 
 ['] dispatch >>  	\   WNDPROC lpfnWndProc; 
 0 >>			\   int     cbClsExtra; 
 0 >>			\   int     cbWndExtra; 
 IMAGE-BASE >>		\   HANDLE  hInstance; 
 0 >>			\   HICON   hIcon; 
 W: idc_arrow 0
 LoadCursorA >>		\   HCURSOR hCursor; 
 0 >>			\   HBRUSH  hbrBackground; 
 0 >>			\   LPCTSTR lpszMenuName; 
 classname >>		\   LPCTSTR lpszClassName; 
\ } WNDCLASS; 
 HERE RegisterClassA 0= IF " WinLib: �� ���� ���������������� ����� ����" 
      err BYE THEN
\ ������ ���������� ���������� ������
  0 CreateCompatibleDC W: logpixelsx OVER GetDeviceCaps
  TO logpixels DeleteDC DROP
\ ������� ������ ���������� ������
  GetDialogBaseUnits DUP LOWORD TO hbaseunits HIWORD TO vbaseunits
\ ����� ������
 W: icc_win95_classes initcc ;

WINAPI: GetMessageA             USER32.DLL
WINAPI: TranslateMessage        USER32.DLL
WINAPI: DispatchMessageA        USER32.DLL
WINAPI: CreateAcceleratorTableA USER32.DLL
WINAPI: DestroyAcceleratorTable USER32.DLL
WINAPI: TranslateAccelerator    USER32.DLL
WINAPI: IsDialogMessage         USER32.DLL

: ?dialog ( msg -- ?) 
  dialog-filter DUP IF IsDialogMessage ELSE 2DROP FALSE THEN ;

: ...WINDOWS \ ������� ���� ����
  { \ [ 7 CELLS ] msg keytable -- }
  acctable IF
    acctable :no @ acctable :data CreateAcceleratorTableA
  ELSE
    0
  THEN TO keytable
  BEGIN
    0 0 0 msg GetMessageA
  WHILE
    msg keytable msg @ ( hwnd) TranslateAccelerator
    0= IF
      msg ?dialog 0= IF
        msg TranslateMessage DROP
        msg DispatchMessageA DROP
      THEN
    THEN
  REPEAT
  keytable DestroyAcceleratorTable DROP ;

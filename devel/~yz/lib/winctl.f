\ WINLIB 1.13

\ ���������� ����������������� ���������� Windows
\ �. 2. ����������� �������� ���������� � �� ����������
\ �. �������, 2.02.2002

REQUIRE WINDOWS... ~yz/lib/winlib.f

0 VALUE common-tooltip

\ ------------------------------
\ �������� ���������

WINAPI: SelectObject          GDI32.DLL
WINAPI: GetTextExtentPoint32A GDI32.DLL
WINAPI: GetDC                 USER32.DLL
WINAPI: ReleaseDC             USER32.DLL

common table control
  item -font	getset	\ �����
  item -align 	set 	\ ������������ ������
  item -notify  	\ ���������� �����������
  item -command 	\ ����� �������
  item -defcommand	\ ��������� �� ���������
  item -updown		\ ����-��������
  item -tooltip  getset \ ���������
  item -tooltipexists   \ ������: ���� �� ���������
  item -locked          \ ������ ������ �������
  \ ������������������ �����
  item -calcsize        \ ����� ���������� �������� ����
  item -ctlshow         \ ����� ������ ��������
  item -ctlhide         \ ����� ���������� ������ ��������
  item -ctlresize       \ ��������� ��������
  item -ctlmove		\ ������������ ��������
  item -ctladdpart      \ ���������� ���������� ������ � ����
endtable

VECT common-tooltip-op
VECT ctlresize

:NONAME \ get-tooltip ( z ctl -- )
  W: ttm_gettexta common-tooltip-op ;
:NONAME \ set-tooltip ( z ctl -- )
  DUP -tooltipexists@ 
  OVER TRUE SWAP -tooltipexists!
  IF W: ttm_updatetiptexta ELSE W: ttm_addtoola THEN common-tooltip-op
; -tooltip control setitem

: text-size { z ctl \ dc [ 2 CELLS ] size -- tx ty }
  ctl -hwnd@ GetDC TO dc
  ctl -font@ dc SelectObject DROP
  size z ASCIIZ> SWAP dc GetTextExtentPoint32A DROP
  dc ctl -hwnd@ ReleaseDC DROP
  size @ size 1 CELLS@ ;

: size-of-text { ctl \ [ 255 ] str -- tx ty }
  str ctl -text@  str ctl text-size ;

WINAPI: GetObjectA  GDI32.DLL
WINAPI: GetIconInfo USER32.DLL

: bitmap-size { bmp \ [ 6 CELLS ] buf -- x y }
  buf 6 CELLS bmp GetObjectA DROP
  buf 1 CELLS@ buf 2 CELLS@ ;
: icon-size { icon \ [ 5 CELLS ] buf -- x y }
  buf icon GetIconInfo DROP
  buf 3 CELLS@ DUP bitmap-size ROT DeleteObject DROP 
  buf 4 CELLS@ DeleteObject DROP ;

: +style ( style ctl -- ) DUP -style@ ROT OR SWAP -style! ;

\ -----------------------------------
\ �������� ����������

:NONAME \ get-font ( ctl -- font)
  W: wm_getfont ?send ;
:NONAME \ set-font ( font ctl -- )
  >R 1 W: wm_setfont R@ send DROP
  R> ?invalidate
; -font control setitem

USER-VALUE this

: create-control-exstyle-notchild { table class style exstyle -- ctl/0 }
  table new-table TO this
  common-control-proclist this -messages!
  0 IMAGE-BASE 0 
  current-window -hwnd@ 
  0 0 0 0 style  "" class exstyle
  CreateWindowExA DUP 0= IF this del-table EXIT THEN
  DUP >R this -hwnd! this R> window!
  W: color_3dface syscolor this -bgcolor!
  W: color_btntext syscolor this -color!
  ['] NOOP this -command!
  ['] NOOP this -painter!
  def-font ?DUP IF this -font! THEN
  20 20 this resize
  this ;

: create-control-exstyle ( table class style exstyle -- ctl/0)
  SWAP W: ws_child OR SWAP create-control-exstyle-notchild ;

: create-control ( table class style -- ctl ) 0 create-control-exstyle ;

:NONAME
  lparam @ window@ TO thisctl
  thisctl 0= IF FALSE EXIT THEN \ ��������� �� �� ����� �������� �� ������������
  lparam 3 CELLS + TO lparam
  lparam CELL- @
  \ ��������� ��������� ��� ������ ������������
  DUP W: tbn_dropdown = IF DROP W: bn_clicked THEN
  DUP thisctl -defcommand@ = IF
    DROP thisctl -command@ EXECUTE
  ELSE
    thisctl -notify@ find-in-xtable DROP
  THEN TRUE
; TO notifyproc

\ ----------------------------------
\ ����� �� ���������

: default-font ( font -- ) TO def-font ;
: -sysfont  0 this -font! ;

\ ----------------------------------
\ ������ �������

WINAPI: CreateStatusWindow COMCTL32.DLL

: create-status ( win -- )
  >R 0 R@ -hwnd@ "" (* ws_child ws_visible *) CreateStatusWindow
  control new-table >R
  DUP R@ SWAP window!
  R@ -hwnd!
  ['] NOOP R@ -command!
  W: nm_click R@ -defcommand!
  R@ win-size PRESS
  R> R@ -status! 
  R> -minusbottom! ;

: split-status { array no win -- }
  no array W: sb_setparts win -status@ send DROP ;

: set-status ( z no win -- )
 >R SWAP W: sb_settexta R> -status@ send DROP ;

\ --------------------------------
\ ����������� ��������

0 == left
1 == center
2 == right

" STATIC" ASCIIZ static

control table buttonlike
  item -xpad		\ �������������� ���������� �� ������ �� ����
  item -ypad		\ ������������ ���������� �� ������ �� ����
  item -image	getset	\ ������� ��������
  item -state	getset
endtable

: +pads { x y ctl -- x1 y1 }
  ctl -xpad@ 2* x +  ctl -ypad@ 2* y + ;

: resize-if-unlocked ( xsize ysize win -- )
  DUP -locked@ IF DROP 2DROP ELSE ctlresize THEN ;

: adjust-size { ctl -- }
  ctl size-of-text  ctl +pads  ctl resize-if-unlocked ;

:NONAME \ set-labeltext ( z ctl -- ) 
  2DUP set-text DUP ?invalidate DUP adjust-size 
  \ �������� ������� �������������� ��� ���
  set-text
; -text buttonlike storeset

:NONAME \ set-font ( font ctl -- )
  >R 1 W: wm_setfont R@ send DROP
  R@ ?invalidate
  R> adjust-size
; -font buttonlike storeset

: rectangle ( -- ctl)
  control static (* ss_notify ss_left *) create-control 
  black OVER -bgcolor! ;

: hline ( -- ctl) rectangle >R 1 1 R@ resize R> ;

: filler ( -- ctl) control static (* ss_notify ss_left *) create-control
  transparent OVER -bgcolor! ;

: set-stalign ( align ctl -- )
  2DUP -align SWAP store
  DUP -style@ W: ss_typemask INVERT AND ROT OR OVER -style!
  ?invalidate ;

: label ( z -- ctl)
  buttonlike static (* ss_notify ss_left ss_noprefix *) create-control >R
  DUP R@ text-size R@ resize
  R@ -text! 
  ['] set-stalign -align R@ storeset
  R> ;

: set-icon ( hicon ctl -- )
  >R DUP icon-size R@ +pads R@ resize
  0 W: stm_seticon R> send DROP ;
: get-icon ( ctl -- hicon)
  W: stm_geticon ?send ;

: icon ( hicon -- ctl)
  buttonlike static (* ss_icon ss_notify *) create-control >R
  ['] get-icon ['] set-icon -image R@ setitem
  R@ -image! 
  R> ;

: set-image ( hbmp ctl -- )
  >R DUP bitmap-size R@ +pads R@ resize
  W: image_bitmap SWAP W: stm_setimage R> send DROP ;
: get-image ( ctl -- hbmp)
  >R W: image_bitmap 0 W: stm_getimage R> send ;

: bitmap ( hbmp -- ctl)
  buttonlike static (* ss_bitmap ss_notify *) create-control >R
  ['] get-image ['] set-image -image R@ setitem
  R@ -image! 
  R> ;

: groupedge ( -- ctl )
  control static W: ss_blackframe W: ws_ex_staticedge 
  create-control-exstyle ;

\ -----------------------------
\ ������

" BUTTON" ASCIIZ buttons

: groupbox ( z -- ctl )
  control buttons W: bs_groupbox create-control >R
  R@ -text!  R>
;

(* bs_left bs_center bs_right *) INVERT == bs_alignmask

: button-align ( align ctl -- )
  2DUP -align SWAP store
  DUP -style@ bs_alignmask AND ROT 
  CASE
    left OF W: bs_left ENDOF
    right OF W: bs_right ENDOF
  DROP W: bs_center
  END-CASE
  OR SWAP -style!
;

: button ( z -- ctl)
  buttonlike buttons (* bs_pushbutton bs_notify ws_tabstop *) create-control >R
  10 R@ -xpad!
  5 R@ -ypad!
  R@ -text!
  ['] button-align -align R@ storeset
  center -align R@ store
  R> ;

: -defbutton  ( -- ) 
  W: bs_defpushbutton this +style 
  this current-window -defaultbutton! ;

: ok-button ( z xt -- ctl ) >R button -defbutton R> this -command! ;

: cancel-button ( z -- ctl) button
  ['] dialog-cancel this -command! ;

: set-buttonicon ( hicon ctl -- )
  >R DUP icon-size R@ +pads R@ resize
  W: image_icon SWAP W: bm_setimage R> send DROP ;
: get-buttonicon ( ctl -- hicon)
  >R W: image_icon 0 W: bm_getimage R> send ;

: icon-button ( icon -- ctl )
  buttonlike buttons (* bs_pushbutton bs_notify ws_tabstop bs_icon *) create-control 
  >R
  ['] get-buttonicon ['] set-buttonicon -image R@ setitem
  3 R@ -xpad!  3 R@ -ypad!
  R@ -image!
  R> ;

: set-buttonbmp ( hbmp ctl -- )
  >R DUP bitmap-size R@ +pads R@ resize
  W: image_bitmap SWAP W: bm_setimage R> send DROP ;
: get-buttonbmp ( ctl -- hbmp)
  >R W: image_bitmap 0 W: bm_getimage R> send ;

: bitmap-button ( icon -- ctl )
  buttonlike buttons (* bs_pushbutton bs_notify ws_tabstop bs_bitmap *) create-control 
  >R
  ['] get-buttonbmp ['] set-buttonbmp -image R@ setitem
  3 R@ -xpad!  3 R@ -ypad!
  R@ -image!
  R> ;

: checkbox-align ( align ctl -- )
  2DUP -align SWAP store
  DUP -style@ ROT left = 
  IF W: bs_lefttext OR ELSE W: bs_lefttext INVERT AND THEN 
  SWAP -style! ;

: get-state ( ctl -- )  W: bm_getcheck ?send ;
: set-state ( state ctl -- )
  >R 0 W: bm_setcheck R> send DROP ;
 
: checkbox ( z -- ctl)
  buttonlike buttons (* bs_autocheckbox bs_notify ws_tabstop *) 
  create-control >R
  10 R@ -xpad!
  1 R@ -ypad!
  R@ -text!
  right -align R@ store
  ['] checkbox-align -align R@ storeset
  ['] get-state ['] set-state -state R@ setitem
  R> ;

: ?uncheck-group ( grp -- ) CELL+ @ ?DUP IF 0 SWAP set-state THEN ;

\ ������ ������:
\ +0	cell	��� ������������� ������
\ +4	cell	����� ������������� ������

: GROUP ( ->bl; -- ) 
  CREATE -1 , 0 , ;

0 VALUE last-group
VARIABLE (ws_group)  (ws_group) 0!

: ?ws_group ( n -- n) (ws_group) @ DUP IF (ws_group) 0! THEN OR ;

: start-group ( group -- ) TO last-group  (* ws_group ws_tabstop *) (ws_group) ! ;

: clear-group ( grp -- ) DUP ?uncheck-group DUP OFF DUP CELL+ ON ;

buttonlike table radiobutton
  item -group
  item -value
endtable

: check-radio ( ctl -- )
  DUP get-state
  IF
    DROP
  ELSE
    DUP -group@ ?uncheck-group
    DUP -value@ OVER -group@ !
    1 OVER set-state
    DUP -group@ CELL+ !
  THEN ;

PROC: check-this-radio ( -- ) thisctl check-radio ;

\ ���������� state - ����������� �� ���� ���������� �� �����
: set-radio-state ( state ctl -- )
  PRESS check-radio ;

: radio ( value z -- ctl)
  radiobutton buttons (* bs_radiobutton bs_notify *) ?ws_group
  create-control >R
  10 R@ -xpad!
  1 R@ -ypad!
  R@ -text!
  R@ -value!
  last-group R@ -group!
  right -align R@ store
  ['] checkbox-align -align R@ storeset
  ['] get-state ['] set-radio-state -state R@ setitem
  check-this-radio R@ -command!
  W: bn_clicked R@ -defcommand!
  R> ;

\ -----------------------------
\ ������ ��������������

" EDIT" ASCIIZ edits

: adjust-height ( ctl -- ) >R 
  R@ -xsize@ " ." R@ text-size PRESS 6 + R> resize-if-unlocked ;

: set-editfont ( font ctl -- )
  >R 1 W: wm_setfont R@ send DROP
  R@ ?invalidate
  R> adjust-height ;

: edit ( -- ctl)
  control edits (* es_autohscroll es_autovscroll ws_tabstop *) W: ws_ex_clientedge
  create-control-exstyle  >R
  ['] set-editfont -font R@ storeset
  0xFFFFFF R@ -bgcolor!
  R@ adjust-height
  R> ;

: multiedit ( -- ctl)
  control edits 
  (* es_autohscroll es_autovscroll es_multiline es_wantreturn ws_tabstop *) 
  W: ws_ex_clientedge create-control-exstyle >R 
  0xFFFFFF R@ -bgcolor!
  R> ;

: limit-edit ( n ctl -- ) W: em_setlimittext wsend DROP ;

\ ------------------------------
\ ��������� ��������� wm_command

:NONAME
  lparam window@ TO thisctl
  thisctl 0= IF EXIT THEN
  wparam HIWORD DUP thisctl -defcommand@ = IF
    DROP thisctl -command@ EXECUTE
  ELSE
    thisctl -notify@ find-in-xtable DROP
  THEN
; TO command

\ -----------------------------
\ ����-������

control table listlike
  item -selected getset	\ ������� ��������� �������
endtable

: lb-getsel ( ctl -- pos)
  W: lb_getcursel ?send ;
: lb-setsel ( pos ctl -- )
  >R 0 W: lb_setcursel R> send DROP ;

: listbox ( -- ctl) 
  listlike " LISTBOX" (* ws_vscroll lbs_notify ws_tabstop *) W: ws_ex_clientedge
  create-control-exstyle >R
  ['] lb-getsel ['] lb-setsel -selected R@ setitem
  0xFFFFFF R@ -bgcolor!
  R> ;

: lb-addstring ( z ctl -- )
  >R 0 SWAP W: lb_addstring R> send DROP ;
: lb-insertstring ( z pos ctl -- )
  >R SWAP W: lb_insertstring R> send DROP ;
: lb-clear ( ctl -- )
  W: lb_resetcontent ?send DROP ;
: lb-deletestring ( pos ctl -- )
  >R 0 W: lb_deletestring R> send DROP ;
: fromlist ( addr pos ctl -- )
  >R SWAP W: lb_gettext R> send DROP ;
: lb-dir ( mask attr ctl -- )
  >R SWAP W: lb_dir R> send DROP ;
: lb-count ( lb -- n) W: lb_getcount ?send ;

\ ----------------------------------
\ ��������������� ������

: cb-getsel ( ctl -- pos)
  W: cb_getcursel ?send ;
: cb-setsel ( pos ctl -- )
  >R 0 W: cb_setcursel R> send DROP ;

: combo ( -- ctl)
  listlike " COMBOBOX" (* cbs_dropdownlist ws_vscroll ws_tabstop *) create-control >R
  ['] cb-getsel ['] cb-setsel -selected R@ setitem
  1 0 W: cb_setextendedui R@ send DROP
  0xFFFFFF R@ -bgcolor!
  W: cbn_selendok R@ -defcommand!
  R@ adjust-height
  R> ;

: addstring ( z ctl -- )  W: cb_addstring lsend DROP ;
: insertstring ( z pos ctl -- )
  >R SWAP W: cb_insertstring R> send DROP ;
: clear-combo ( ctl -- )
  W: cb_resetcontent ?send DROP ;
: deletestring ( pos ctl -- )  W: cb_deletestring wsend DROP ;
: fromcombo ( addr pos ctl -- )
  >R SWAP W: cb_getlbtext R> send DROP ;
: combo-dir ( mask attr ctl -- )
  >R SWAP W: cb_dir R> send DROP ;
: combo-count ( lb -- n) W: cb_getcount ?send ;

\ --------------------------------
\ ������ ���������

" SCROLLBAR" ASCIIZ scrolls

control table scrolllike
  item -pos	getset	\ ������� �������
  item -min	getset  \ ����������� ������� ���������
  item -max	getset	\ ������������ ������� ���������
endtable

WINAPI: GetScrollPos   USER32.DLL
WINAPI: SetScrollPos   USER32.DLL
WINAPI: GetScrollRange USER32.DLL
WINAPI: SetScrollRange USER32.DLL

: get-pos ( ctl -- pos)
  -hwnd@ W: sb_ctl SWAP GetScrollPos ;
: set-pos ( pos ctl -- )
  >R TRUE SWAP W: sb_ctl R> -hwnd@ SetScrollPos DROP ;

: scrollminmax { ctl \ min max -- min max }
  ^ max ^ min W: sb_ctl ctl -hwnd@ GetScrollRange DROP
  min max ;

: setscrollminmax ( min max ctl -- )
  >R SWAP TRUE -ROT W: sb_ctl R> -hwnd@ SetScrollRange DROP ;

: get-min ( ctl -- min)
  scrollminmax DROP ;
: set-min ( min ctl -- )
  DUP -max@ SWAP setscrollminmax ;

: get-max ( ctl -- max)
  scrollminmax PRESS ;
: set-max ( max ctl -- )
  DUP -min@ -ROT setscrollminmax ; 

: hscroll ( -- ctl )
  scrolllike scrolls W: sbs_horz create-control >R
  R@ -xsize@ W: sm_cyhscroll GetSystemMetrics R@ resize
  ['] get-pos ['] set-pos -pos R@ setitem
  ['] get-min ['] set-min -min R@ setitem
  ['] get-max ['] set-max -max R@ setitem
  100 R@ -max!
  R> ;

: vscroll ( -- ctl )
  scrolllike scrolls W: sbs_vert create-control >R
  W: sm_cxvscroll GetSystemMetrics R@ -ysize@ R@ resize
  ['] get-pos ['] set-pos -pos R@ setitem
  ['] get-min ['] set-min -min R@ setitem
  ['] get-max ['] set-max -max R@ setitem
  100 R@ -max!
  R> ;

:NONAME
  lparam window@ TO thisctl
  wparam LOWORD thisctl -notify@ find-in-xtable DROP
; TO scrollctlproc

\ -----------------------------
\ ���������� ��������

: ctl-size ( ctl -- x y)
  DUP -calcsize@ ?DUP IF
    >R DUP R> EXECUTE
  ELSE
    DUP win-size
  THEN
  ROT -updown@ ?DUP IF
    win-size DROP ROT + 2- SWAP
  THEN
;

: (set-ud) ( ctl what -- )
  SWAP >R 0 W: udm_setbuddy R> -updown@ send DROP ;

\ ���� �������� �������, ��� ��� ������� ������-�� ��� ����������
\ ������ ���, ���� ���� ��������� � ���� �����
: add-ud ( ctl -- ) DUP DUP -hwnd@ (set-ud) -updown@ winshow ;

: remove-ud ( ctl -- ) DUP ctl-size 2 PICK 0 (set-ud) ROT resize ;

: ctlmove  ( x y ctl -- )
  DUP -ctlmove@ ?DUP 0= IF ['] winmove THEN
  ( x y ctl xt -- )
  OVER -updown@ IF
    OVER remove-ud  OVER >R EXECUTE  R> add-ud
  ELSE
    EXECUTE
  THEN ; 

:NONAME  ( x y ctl -- )
  DUP -ctlresize@ ?DUP 0= IF ['] resize THEN
  ( x y ctl xt -- )
  OVER -updown@ IF
    OVER remove-ud  OVER >R EXECUTE  R> add-ud
  ELSE
    EXECUTE
  THEN ; TO ctlresize

: ctlshow { ctl -- }
  ctl -ctlshow@ ?DUP IF
    ctl SWAP EXECUTE
  ELSE
    ctl winshow
  THEN
  ctl -updown@ ?DUP IF winshow THEN ;

: ctlhide { ctl -- }
  ctl -ctlhide@ ?DUP IF
    ctl SWAP EXECUTE
  ELSE
    ctl winhide
  THEN
  ctl -updown@ ?DUP IF winhide THEN ;

: ctl-destroy ( ctl -- ) >R
  R@ -tooltipexists@ IF 0 R@ W: ttm_deltoola common-tooltip-op THEN
  R> destroy-window 
;

WINAPI: GetParent  USER32.DLL
WINAPI: SetParent USER32.DLL

: link-to-current ( ctl -- )
  >R current-window -hwnd@ R@ -hwnd@ SetParent DROP
  current-window R> -parent! ;

: set-parent ( ctl -- )
  DUP link-to-current
  -updown@ ?DUP IF link-to-current THEN ;

: place ( x y ctl -- )
  DUP set-parent
  SWAP current-window -minustop@ + SWAP
  DUP >R ctlmove R> ctlshow ;

: another-place ( x y ctl -- )
  SWAP current-window -minustop@ + SWAP ctlmove ;

: remove ( ctl -- ) 
  DUP winhide 0 SWAP -parent! ;

\ ������� ������������� �������� �������
\ (/ -font f  -color blue  -bgcolor white  /)

\ ����� ������ ����:
\ (/ -name value-var  -size 100 200 /)

-1 == -size

: (/  (( ;
: /) ( ... -- )
  )) 2DUP < IF
  DO
    I @ CASE
    -size OF 
      I CELL- @ I 2 CELLS - @ this ctlresize
      3 ( ���������)
    ENDOF
      I CELL- @ SWAP this setproc
      2 ( ���������)
    END-CASE
  CELLS NEGATE +LOOP
  ELSE
    2DROP
  THEN remove-stack-block
;

: -name ( ->bl; -- ) POSTPONE this [COMPILE] TO ; IMMEDIATE

\ -----------------------------
\ �����

VARIABLE cur-grid
VARIABLE cur-row
VARIABLE cur-bind
VARIABLE cur-halign
VARIABLE cur-valign
VARIABLE cur-xx
VARIABLE cur-yy
VARIABLE cur-width
VARIABLE cur-height

0 == bleft
1 == bright
2 == bcenter
3 == bspan

: bhdir ( ->bl; n -- ) CREATE , DOES> @ cur-halign ! ;
: bvdir ( ->bl; n -- ) CREATE , DOES> @ cur-valign ! ;

bleft   bhdir -left
bright  bhdir -right
bcenter bhdir -center
bspan   bhdir -xspan
bleft   bvdir -top
bright  bvdir -bottom
bcenter bvdir -middle
bspan   bvdir -yspan

: bfield ( ->bl; var -- ) CREATE , DOES> ( n -- ) @ ! ;

cur-xx     bfield -xmargin
cur-yy     bfield -ymargin
cur-width  bfield -width
cur-height bfield -height

100000 == fixed
: -xfixed  fixed -width ;
: -yfixed  fixed -height ;

0
CELL -- :gsign 	 \ ������� "GRID"
CELL -- :glink   \ ��������� �� ������ ���
CELL -- :gwidth  \ ������ �����: ������ ���� 3-�� (wm_getminmaxinfo)
CELL -- :gheight \ ������ �����: ������ ���� 4-�� (wm_getminmaxinfo)
CELL -- :gfixheight \ ����� ������������� �� ������ ������
CELL -- :gbox	 \ ����� ������ �����
== #grid

0 
CELL -- :rlink   \ ��������� �� ��������� ���
CELL -- :rbacklink  \ ��������� �� ���������� ���
CELL -- :rblink  \ ��������� �� ������ ����
CELL -- :rwidth  \ ������ ����
CELL -- :rheight \ ������ ����
CELL -- :rfixwidth  \ ����� ������������� �� � ������
== #row

0
CELL -- :blink     \ ��������� �� ��������� ������
CELL -- :bbacklink \ ��������� �� ���������� ������
CELL -- :bwidth   \ ������ ������
CELL -- :bheight  \ ������ ������
CELL -- :brelw    \ ������������� ������ ������
CELL -- :brelh    \ ������������� ������ ������
CELL -- :bxmargin \ �������������� ����
CELL -- :bymargin \ ������������ ����
CELL -- :bhalign  \ ������������ �� �����������
CELL -- :bvalign  \ ������������ �� ���������
CELL -- :bdweller \ ��������� ������
CELL -- :bdwellerw \ ��� ������
CELL -- :bdwellerh \ � ������
CELL -- :bnostretch \ �� ����������� ������
== #binding

: defaultbind ( -- ) 
  -left -top  5 -xmargin  5 -ymargin  0 -width  0 -height ;

: === ( -- )
  #row MGETMEM DUP
  cur-row @ OVER :rbacklink !
  cur-row @ ?DUP
  IF ( new new old) :rlink ! ELSE ( new new) cur-grid @ :glink ! THEN
  cur-row ! 
  defaultbind 
  cur-bind 0! ;

: GRID ( -- savedparams )
  this cur-grid @ cur-row @ cur-bind @
  cur-halign @ cur-valign @
  cur-xx @ cur-yy @
  cur-width @ cur-height @
  #grid MGETMEM >R
  CELL" GRID" R@ :gsign !
  -1 R@ :gwidth !
  -1 R@ :gheight !
  R> cur-grid !
  cur-row 0! 
  === ;

: -boxed ( -- ) "" groupbox  cur-grid @ :gbox ! ;
: -bevel ( -- ) groupedge cur-grid @ :gbox ! ;

: | ( ctl/grid -- )
  #binding MGETMEM DUP
  cur-bind @ OVER :bbacklink !
  cur-bind @ ?DUP IF :blink ! ELSE cur-row @ :rblink ! THEN
  >R
  R@ :bdweller !
  cur-halign @ R@ :bhalign !
  cur-valign @ R@ :bvalign !
  cur-xx      @ R@ :bxmargin !
  cur-yy      @ R@ :bymargin !
  cur-width   @ R@ :brelw !
  cur-height  @ R@ :brelh !
  cur-width   @ 0= 0= R@ :bnostretch !
  R> cur-bind !
  defaultbind ;

: grid? ( a -- ? ) @ CELL" GRID" = ;

:NONAME ( grid -- )
  DUP :glink @ ?DUP IF
    BEGIN
      DUP :rblink @ ?DUP IF
        BEGIN
          DUP :bdweller @
            DUP grid?
            IF del-grid ELSE ctl-destroy THEN
          DUP :blink @ SWAP MFREEMEM
        ?DUP 0= UNTIL
      THEN
      DUP :rlink @ SWAP MFREEMEM
    ?DUP 0= UNTIL
  THEN
  DUP :gbox @ ?DUP IF ctl-destroy THEN
  MFREEMEM ; TO del-grid

: traverse-grid ( xt -- )
  cur-grid @ :glink @ ?DUP IF
    BEGIN
      cur-row !
      DUP EXECUTE
      cur-row @ :rlink @
    ?DUP 0= UNTIL
  THEN DROP ;

: traverse-row ( xt -- )
  cur-row @ :rblink @ ?DUP IF
    BEGIN
      cur-bind !
      DUP EXECUTE
      cur-bind @ :blink @
    ?DUP 0= UNTIL
  THEN DROP ;

: save-grid-vars ( -- n n1 n2)
  cur-grid @ cur-row @ cur-bind @ ;
: restore-grid-vars ( n n1 n2 --  )
  cur-bind ! cur-row ! cur-grid ! ;

\ ��������������� �������� � ������ ---------

\ ������� �� �����: ��� ������ � ������� ������� ��������� ���������.
\ �������� � ���, ��� ���� ����������� ������ � ��� ������ ����� ������
\ ���������� ��������� ���������� ����������.
\ ���������� �������� ������, ��������� ��������� ��������� �� ������ ������.
\ ������� ��� � ����� �� ����� ���������� ������� :-(

: (find-grid-x) ( x grid -- )
  :rblink @ DUP 0= IF EXIT THEN
  SWAP >R 0 SWAP
  BEGIN
    ( cnt link)
    DUP 0= IF PRESS RDROP EXIT THEN
    OVER R@ = IF PRESS RDROP EXIT THEN
    >R 1+ R> :blink @
  AGAIN ;

: (find-grid-y) ( y grid -- )
  :glink @ DUP 0= IF EXIT THEN
  ( y cnt) SWAP >R 0 SWAP
  BEGIN
    ( cnt link)
    OVER R@ = IF PRESS RDROP EXIT THEN
    DUP 0= IF PRESS RDROP EXIT THEN
    >R 1+ R> :rlink @
  AGAIN ;

: grid[] ( x y grid -- dweller/0)
  >R SWAP R> (find-grid-y) DUP 0= IF PRESS EXIT THEN
  ( x row) (find-grid-x) DUP 0= IF EXIT THEN 
  ( bind) :bdweller @ ;

: window[] ( x y win -- )
  DUP -grid@ ?DUP IF PRESS grid[] ELSE 2DROP DROP 0 THEN ;


VECT walk-do-grid
VECT walk-do-control

PROC: (walkbind)
  cur-bind @ :bdweller @ DUP grid? IF walk-do-grid ELSE walk-do-control THEN
PROC;

PROC: (walkrow)
  (walkbind) traverse-row
PROC;

: walk-controls ( grid do-grid do-ctl -- ) 
  TO walk-do-control TO walk-do-grid
  >R save-grid-vars
  R> cur-grid !
  (walkrow) traverse-grid
  restore-grid-vars ;

VECT show-grid ( grid -- )
:NONAME 
  DUP ['] show-grid ['] ctlshow walk-controls 
  :gbox @ ?DUP IF ctlshow THEN
; TO show-grid

VECT hide-grid ( grid -- )
:NONAME 
  DUP ['] hide-grid ['] ctlhide walk-controls 
  :gbox @ ?DUP IF ctlhide THEN
; TO hide-grid

PROC: (rgrid)
  CR ." bind" cur-bind @ 20 DUMP
PROC;

PROC: (ggrid)
  CR ." row" cur-row @ 10 DUMP
   (rgrid) traverse-row
 PROC;

: .grid ( grid -- ) >R save-grid-vars
   R> cur-grid !
  (ggrid) traverse-grid
 restore-grid-vars ;

\ �������� ����� --------------

VECT arrange-grid
VARIABLE temp
VARIABLE temp2

: grid-size ( grid -- w h)
  >R
  R@ :gwidth @ -1 = IF 
    save-grid-vars temp @ R@ arrange-grid temp ! restore-grid-vars
  THEN
  R@ :gwidth @ R> :gheight @ ;

: GRID; ( savedparams -- grid )
  \ �������� ����� ���������� ���� ���������
  cur-grid @ >R
  cur-height ! cur-width !
  cur-yy !
  cur-xx !
  cur-valign !
  cur-halign !
  cur-bind ! cur-row ! cur-grid ! TO this
  R> DUP grid-size 2DROP ;

: dweller-size ( a -- w h) DUP grid? IF grid-size ELSE ctl-size THEN ;

\ ������ ������ ����:
\ �������� �� ���� �������, ������� ������������ ������ � ����� ������
PROC: row-pass1
  cur-bind @ >R
  R@ :bdweller @ dweller-size DUP R@ :bdwellerh ! OVER R@ :bdwellerw !
  R@ :bymargin @ 2* +
  SWAP R@ :bxmargin @ 2* + 2DUP ( y x ) R@ :bwidth ! R> :bheight !
  cur-row @ :rwidth +!  cur-row @ :rheight @ MAX cur-row @ :rheight ! 
\ ." rp1: " cur-bind @ :bwidth @ . cur-bind @ :bheight @ . CR
PROC;

\ ������ ������:
\ ������� ������� ������� ��������� ������ + ����
\ � ����������� ������� ������� ����
PROC: grid-pass1
  cur-row @ :rwidth 0!  cur-row @ :rheight 0!
  row-pass1 traverse-row 
\ ." gp1: " cur-row @ :rwidth @ . cur-row @ :rheight @ . CR
PROC;

\ ������ ������:
\ ������� ����� ������ � ������������ ������ �������
PROC: grid-pass2
  cur-grid @ :gwidth @ cur-row @ :rwidth @ MAX cur-grid @ :gwidth !
  cur-row @ :rheight @ cur-grid @ :gheight +!
\ ." gp2: " cur-grid @ :gwidth @ . cur-grid @ :gheight @ . CR
PROC;

\ ������ ������:
\ ������� ��� ������������� ������, ���������� �� ������� � �������� ������
\ � ����������� �� ����� ����� � ���������� ����
PROC: row-pass3
  cur-bind @ :brelw @ fixed = IF
    cur-bind @ :bwidth @ DUP NEGATE cur-bind @ :brelw !
    cur-row @ :rfixwidth +!
  THEN
  \ ���� ������ ������ ����������� - ������� ���� ���� � temp
  cur-bind @ :brelh @ fixed = IF
    TRUE temp !
  THEN
\ ." rp3: rfixw=" cur-row @ :rfixwidth @ . ." fixwflag=" temp @ . 
\ ." brelw=" cur-bind @ :brelw @ . CR
PROC;

PROC: grid-pass3
  temp 0!
  row-pass3 traverse-row
  temp @ IF
  \ ���� ������ ���� �����������, ������� �� � �������� ������
    cur-row @ :rheight @ DUP NEGATE cur-row @ :rheight !
    \ � �������� � ���������� �����
    cur-grid @ :gfixheight +!
  THEN
\ ." gp3: rfixh=" cur-grid @ :gfixheight @ . CR
PROC;

\ ��������� ������:
\ ����������� ������� ������ ��������������� ������ � ������� ���������������� ����
\ � %% � ����� ������ �������

PROC: row-pass4
  cur-bind @ :brelw @ DUP 0< NOT IF
    ?DUP 0= IF 
      cur-bind @ :bwidth @ 1000 temp @ */
    \ ���� ���������� - ��������� �� % � %%
    ELSE 
      10 *
    THEN
  THEN
  cur-bind @ :brelw ! 
\ ." rp4: " cur-bind @ :brelw @ . ." %%" CR
PROC;

PROC: grid-pass4
  \ ������ �������� ���� ��� ������������� ������
  cur-row @ :rwidth @ cur-row @ :rfixwidth @ - temp !
  row-pass4 traverse-row
  cur-row @ :rheight @ 0 > IF
    \ ��������� ������ ���� � %%
    cur-row @ :rheight @ 1000 cur-grid @ :gheight @ cur-grid @ :gfixheight @ - */
    cur-row @ :rheight !
  THEN
\ ." gp4: " cur-row @ :rheight @ . ." %%" CR
PROC;

VECT add-grid-to-window

: add-control ( dweller -- )
  DUP grid? IF 
    temp @ SWAP current-window add-grid-to-window
  ELSE 
    TRUE OVER -locked!
    DUP set-parent 
    DUP -ctladdpart@ ?DUP IF >R DUP R> EXECUTE THEN
    temp @ IF ctlshow ELSE DROP THEN
  THEN 
;

: add-controls-in-row ( row -- )
  \ ���� ��������� ������...
  ?DUP IF
    BEGIN
      ?DUP
    WHILE
      DUP cur-bind !
      :blink @
    REPEAT
     \ � �������� ������ � �������� �������
     cur-bind @ 
     BEGIN
       DUP :bdweller @ add-control
       :bbacklink @
    ?DUP 0= UNTIL
  THEN ;

\ �������� ��� ����� ����� ������� � ���������� � ���� 
\ ��� �������� ����������
:NONAME ( show? grid win -- )
  ROT temp !
  current-window -ROT
  TO current-window
  cur-grid @ SWAP cur-grid !
  \ ���� ��������� ���...
  cur-grid @ :glink @ ?DUP IF
    BEGIN
      ?DUP
    WHILE
      DUP cur-row !
      :rlink @
    REPEAT
    \ � �������� ���� � �������� �������
    cur-row @ 
    BEGIN
      DUP :rblink @ add-controls-in-row
      :rbacklink @
    ?DUP 0= UNTIL
  THEN
  cur-grid @ :gbox @ ?DUP IF ctlshow THEN 
  cur-grid ! TO current-window
  ; TO add-grid-to-window

: (arrange-grid) ( grid -- ) cur-grid !
\ ." arrange-grid <<<" CR
  cur-grid @ :gwidth 0!  cur-grid @ :gheight 0!
  grid-pass1 traverse-grid
  grid-pass2 traverse-grid
  grid-pass3 traverse-grid 
  grid-pass4 traverse-grid 
\ ." arrange-grid >>>" CR
;

' (arrange-grid) TO arrange-grid

\ ---------------------------
VECT map-grid

\ � cur-halign � cur-valign �������� ������ ������ � ������ ����

PROC: map-bind { \ new-w new-h new-x new-y ww hh xm ym resize? }
  cur-bind @ :bwidth @ cur-halign !
  cur-bind @ :bxmargin @ TO xm
  cur-bind @ :bymargin @ TO ym
  cur-halign @ xm 2* - TO ww
  cur-valign @ ym 2* - TO hh
\ ������������ �
  cur-bind @ :bhalign @ CASE
    bleft   OF xm ENDOF
    bcenter OF 
      ww cur-bind @ :bdwellerw @ - 2/ xm +
    ENDOF
    bright  OF 
      cur-halign @ xm - cur-bind @ :bdwellerw @ - 2-
    ENDOF
    bspan   OF 
      ww TO new-w
      xm
    ENDOF
  ENDCASE TO new-x
\ ������������ y
  cur-bind @ :bvalign @ CASE
    bleft   OF ym ENDOF
    bcenter OF 
      hh cur-bind @ :bdwellerh @ - 2/ ym +
    ENDOF
    bright  OF 
      cur-valign @ ym - cur-bind @ :bdwellerh @ - 1+
    ENDOF
    bspan   OF 
      hh TO new-h
      ym
    ENDOF
  ENDCASE TO new-y
\ ." map-bind: xx=" cur-xx @ . ." width=" cur-halign @ .
\ ." newx=" new-x . ." newy=" new-y .
\ ." neww=" new-w . ." newh=" new-h . CR
\ ���� ���� - �������� ������
  new-w new-h + DUP TO resize? IF
    new-w 0= IF cur-bind @ :bdwellerw @ TO new-w THEN
    new-h 0= IF cur-bind @ :bdwellerh @ TO new-h THEN
  THEN
  \ 
  cur-bind @ :bdweller @ DUP grid? IF
    >R cur-xx @ new-x + cur-yy @ new-y + 
    resize? IF new-w new-h ELSE R@ grid-size THEN
    2OVER 2OVER R@ map-grid
    R> :gbox @ ?DUP IF 
      ( x y w h ctl)
      >R ym + SWAP xm + SWAP R@ resize
      ( x y)
      ym 2/ - SWAP xm 2/ - SWAP R> another-place
    ELSE 
      2DROP 2DROP
    THEN
  ELSE 
    resize? IF 
      DUP new-w new-h ROT ctlresize 
      new-w cur-bind @ :bdwellerw !
      new-h cur-bind @ :bdwellerh !
    THEN
    new-x cur-xx @ + new-y cur-yy @ + ROT another-place
  THEN
\ ������������� ������
  cur-halign @ cur-xx +!
PROC;

PROC: calc-bind
  cur-bind @ :brelw @ DUP 0< 
    IF ABS ELSE cur-width @ cur-row @ :rfixwidth @ - 1000 */ THEN 
  DUP cur-bind @ :bwidth !  temp +!
  cur-bind @ :bnostretch @ IF cur-bind @ :bwidth @ temp2 +! THEN
PROC;

PROC: stretch-bind
  \ temp - ����� ����� ����������
  \ temp2 - ����� ���� ������������� �����
  \ ������������ �������������� ����� ��������������� ����� ������
  cur-bind @ :bnostretch @ 0= IF
    cur-bind @ :bwidth @ temp @ temp2 @ */ cur-bind @ :bwidth +!
  THEN
PROC;

PROC: map-row
  cur-row @ :rheight @ DUP 0< 
    IF ABS ELSE cur-height @ cur-grid @ :gfixheight @ - 1000 */ THEN
  cur-valign !
\ ." map-row: yy=" cur-yy @ . ." height=" cur-valign @ . CR
\ ��������� ������ ������ ������, ����� ����� ����� (temp) 
\ � ����� ��������������� ����� (temp2)
  temp 0!  temp2 0!
  calc-bind traverse-row
\ �������� ��� ������������� ������
  cur-width @ temp @ - 1 > IF
    \ ����� ������������� �����
    temp @ temp2 @ - temp2 !
    \ ����� ����� ����������
    cur-width @ temp @ - temp !
    stretch-bind traverse-row
  THEN
\ ��������� ���������� �����
  cur-xx @
  map-bind traverse-row
  cur-valign @ cur-yy +!
  cur-xx !
PROC;

:NONAME ( xbeg ybeg width height grid -- )
\ ." map-grid: xbeg=" 4 PICK . ." ybeg=" 3 PICK . ." w=" 2 PICK . ." h=" 1 PICK . CR
  >R >R >R >R >R
  \ �������� ��� ���������� ����������
  save-grid-vars
  cur-width @ cur-height @
  cur-xx @ cur-yy @
  cur-halign @ cur-valign @
  R> cur-xx ! R> cur-yy ! 
  R> cur-width ! R> cur-height ! R> cur-grid !
  map-row traverse-grid
  \ ����������� ���������� ����������
  cur-valign ! cur-halign !
  cur-yy ! cur-xx !
  cur-height ! cur-width !
\ ." /map-grid" CR
  restore-grid-vars ; 
TO map-grid

: resize-window-grid ( win -- )
  >R current-window
  R@ TO current-window
  0 0 R@ -xsize@ R@ -ysize@ R> -grid@ map-grid
  TO current-window ;

: max-win-size ( win -- w h)
  -hwnd@ GetParent ?DUP IF 
    window@ DUP -xsize@ SWAP -ysize@
  ELSE
    screen-x 10 - screen-y 20 - ( � ��������� ��������� �� ���������� ����)
  THEN ;

:NONAME { grid win -- }
  grid -grid win store
  grid 0= IF EXIT THEN
  grid grid-size ( w h)
  win max-win-size ( w h maxw maxh)
  ROT MIN >R MIN R> ( neww newh)
  win winresize
  TRUE grid win add-grid-to-window
; -grid window storeset

:NONAME ( -- )
  thiswin resize-window-grid
; -gridresize window store

\ ��������� ������� ==================

: MODAL... ( z -- oldmw olddlg )
  modal-window dialog 
  winmain dialog-window TO dialog 
  ROT dialog -text! ;

: SHOW ( grid -- )
  { \ [ 7 CELLS ] msg -- }
  dialog -grid!
  dialog wincenter
  dialog -hwnd@ TO modal-window
  FALSE end-dialog
  dialog winshow
  BEGIN
    0 0 0 msg GetMessageA DROP
    msg ?dialog 0= IF
      msg TranslateMessage DROP
      msg DispatchMessageA DROP
    THEN
  dialog-termination UNTIL
  0 TO modal-window
  dialog winhide ;

: ...MODAL  ( oldmw olddlg -- )
  dialog destroy-window 
  DUP TO dialog ?DUP IF winfocus THEN
  TO modal-window
;

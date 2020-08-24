\ $Id: autoc.f,v 1.15 2008/01/14 14:57:14 ygreks Exp $
\
\ ���������� ���� � ������� SPF
\
\ ������� ��������� ���������� - Tab
\ ������� ����� - ������� ����/�����
\ �������� ������� ���� - Esc
\ ��������� - Home, End, ������� �����/������
\ �������� - Bksp, Del
\ ������� �� ������ ������ - Ctrl-V, Shift-Ins
\
\ ������ ���������� ��� ���� � ��.

REQUIRE [IF] lib/include/tools.f

\ ��������� �������� �� �����
C" ACCEPT-Autocompletion" FIND NIP [IF] \EOF [THEN]

MODULE: ACCEPT-Autocompletion

\ ������ ��� ���� ������ �.�. ����� ���� ��������� ����������

REQUIRE /STRING lib/include/string.f
REQUIRE AT-XY ~day/common/console.f
REQUIRE InsertNodeEnd ~day/lib/staticlist.f
REQUIRE FileLines=> ~ygrek/lib/filelines.f
REQUIRE ATTACH-LINE-CATCH ~pinka/samples/2005/lib/append-file.f
REQUIRE LAMBDA{ ~pinka/lib/lambda.f
REQUIRE CBString ~day/lib/clipboard.f

WINAPI: GetConsoleScreenBufferInfo KERNEL32.DLL

0 VALUE _addr \ ����� ������ ��� ACCEPT
0 VALUE _n1 \ ����� ������ ��� ACCEPT
0 VALUE _in \ ����� ������
0 VALUE _last \ ������� ���������� ������� ��������� ������ (�� ���������������)
0 VALUE _y \ ����� ������ �� �������
0 VALUE _x \ ����� �������
0 VALUE in-history \ ��������� �������� �������
0 VALUE history \ ������ ����� �������
0 VALUE _cursor \ ������� � ������ �� ������� ��������� ������� ������

: history-file S" spf.history" +ModuleDirName ;

/node
CELL -- .val
CONSTANT /history

CREATE CONSOLE_SCREEN_BUFFER_INFO 22 ALLOT

: AT-XY? ( -- x y )
\ ����������� ��������� �������
  CONSOLE_SCREEN_BUFFER_INFO H-STDOUT GetConsoleScreenBufferInfo DROP
  CONSOLE_SCREEN_BUFFER_INFO 4 + DUP W@ SWAP 2+ W@ ;

: CLEAR-LINE ( x y -- )
\ �������� ������
   16 LSHIFT OR 0 >R RP@ SWAP MAX-XY NIP BL H-STDOUT FillConsoleOutputCharacterA R> 2DROP ;

: scanback ( addr u -- a' u' )
\ ����� ������ ����� (������������ ����� �� ������)
  2DUP
  BEGIN
    1-
    2DUP + C@ IsDelimiter IF NIP 1+ /STRING EXIT THEN
    DUP 0=
  UNTIL
  2DROP
;

: SUBSTART ( a u a1 u1 -- 0 | -1 )
\ ��������� � ������ ������
   2>R OVER 2R> ROT >R
   ( a u a1 u1 ) ( R: a ) \ %)
   SEARCH NIP IF R> <> ELSE DROP RDROP -1 THEN ;

: CDR-BY-NAME-START ( a u nfa1|0 -- a u nfa2|0 )
\ ����� ��������� ����� � ������ ���� ������������ �� a u
 BEGIN  ( a u NFA | a u 0 )
   DUP
 WHILE  ( a u NFA )
   >R 2DUP R@ COUNT 2SWAP SUBSTART R> SWAP
 WHILE
   CDR  ( a u NFA2 )
 REPEAT THEN
;

: put ( a u -- in )
\ ��������� ������ ������� �� _last
   _last OVER + _n1 > IF 2DROP _in EXIT THEN
   >R _addr _last scanback DROP R> 2DUP + >R CMOVE
   R> _addr - ;

: nfa-of-input ( -- nfa -1 | 0 )
   _addr _in scanback \ last full word
   CONTEXT @ SEARCH-WORDLIST-NFA ;

: completion ( nfa1 -- nfa2 )
   _addr _last scanback \ last realpart word
   ROT
   CDR-BY-NAME-START
   NIP NIP ;

: insert-string { a u -- }
    _addr _cursor + DUP u + _in _cursor - MOVE
    a _addr _cursor + u MOVE
    a FREE THROW
    u _cursor + TO _cursor
    u _in + TO _in ;

: accept-ascii ( c -- )
   DUP 9 = \ tab
   IF
     0 TO in-history
     nfa-of-input 0= IF CONTEXT @ @ ELSE CDR THEN
     completion DUP IF COUNT put TO _in ELSE DROP _last TO _in THEN
     _in TO _cursor
   THEN

   DUP 8 = \ bksp
   IF
     0 TO in-history
     _cursor 0= IF DROP EXIT THEN
     _addr _cursor + DUP 1- _in _cursor - CMOVE
     _in 1 MAX 1- TO _in
     _in TO _last
     _cursor 1- TO _cursor
   THEN

   DUP 13 = IF
     0 TO in-history
   THEN

   DUP 22 = IF \ Ctrl-V
     CBString insert-string
     _in TO _last
   THEN

   DUP 27 = IF \ Esc - �������� ����
     0 TO in-history
     0 TO _cursor
     0 TO _in
     0 TO _last
   THEN

   DUP 32 < IF DROP EXIT THEN

   \ put one char
   0 TO in-history
   _addr _cursor + DUP 1+ _in _cursor - CMOVE>
   _addr _cursor + C!
   _in 1+ TO _in
   _cursor 1+ TO _cursor
   _in TO _last

   EXIT \ ����������������� ���� %)

   \ ?AUTOCOMPLETION 0= IF EXIT THEN
   \ ���� �� ����� ������� ����� - ������ �� ������
   nfa-of-input IF DROP EXIT THEN
   \ ����� ���� ����������
   CONTEXT @ @ completion DUP 0= IF DROP EXIT THEN \ ���� �� ��� - �������
   DUP CDR completion IF DROP EXIT THEN \ ���� �� ������ ������ - ���� �������
   \ ����� ����������� �����!
   COUNT put TO _in
   _in TO _cursor ;

: accept-scan ( c -- )
   DUP 72 = IF \ up arrow
     in-history DUP 0= IF DROP history firstNode THEN
     PrevCircleNode TO in-history
     0 TO _last
     in-history .val @ STR@ put DUP TO _in TO _last
     _in TO _cursor
   THEN
   DUP 80 = IF \ down arrow
     in-history DUP 0= IF DROP history firstNode THEN
     NextCircleNode TO in-history
     0 TO _last
     in-history .val @ STR@ put DUP TO _in TO _last
     _in TO _cursor
   THEN
   DUP 75 = IF \ left arrow
     _cursor 1 MAX 1- TO _cursor
   THEN
   DUP 77 = IF \ right arrow
     _cursor 1+ _in MIN TO _cursor
   THEN
   DUP 71 = IF \ Home
     0 TO _cursor
   THEN
   DUP 79 = IF \ End
     _in TO _cursor
   THEN
   DUP 82 = IF \ Shift-Ins
     CBString insert-string
     _in TO _last
   THEN
   DUP 83 = IF \ Delete
     0 TO in-history
     _addr _cursor + DUP 1+ SWAP _in _cursor - CMOVE
     _in 1 MAX 1- _cursor MAX TO _in
     _in TO _last
   THEN
   DROP ;

: accept-one ( c -1|0 -- ? )
\ ��������� ������ �������
   IF DUP accept-ascii 13 <> ELSE accept-scan TRUE THEN ;

: \STRING ( a u n -- a+u-n n ) OVER MIN >R + R@ - R> ;
: MAX-X MAX-XY DROP 1- ;

: display ( ? -- )
\ �������� �����
\   LT LTL @ TO-LOG _y .TO-LOG _in .TO-LOG
   _x _y AT-XY
   _x _y CLEAR-LINE
   H-STDLOG >R
   0= IF 0 TO H-STDLOG THEN \ don't want it to appear in spf.log
   _addr _in TYPE
   R> TO H-STDLOG
   _cursor _x + _y AT-XY
\   _addr _in DUP MAX-X > IF MAX-X \STRING THEN TYPE
;

: skey ( -- c -1|0 )
\ �������� ������� � ����������
\ -1 - ��� ASCII
\  0 - ���� ���
   BEGIN
    EKEY
    EKEY>CHAR IF TRUE EXIT THEN
    EKEY>SCAN IF FALSE EXIT ELSE DROP THEN
   AGAIN ;

\ --------------------------------

: List=> ( list -- ) R> SWAP ForEach ;
: add-history ( s -- ) history AllocateNodeEnd .val ! ;
: dump-history ( -- ) \ ��� ������� � ���� ������
   \ �������� ����
   history-file R/W CREATE-FILE THROW CLOSE-FILE THROW
   \ �������� ���� ������
   LAMBDA{ .val @ STR@ history-file ATTACH-LINE-CATCH DROP } history ForEach ;

: load-history
  /history CreateList TO history
  START{
   history-file FileLines=>
   DUP
   STR@ >STR add-history
  }EMERGE
  history listSize 0= IF
   "" add-history \ ������ ���� ���� ������� � ������!
  THEN ;

: htype history List=> .val @ STR@ CR TYPE ;

: SAFE-COMPARE { a u a1 u1 -- ? }
   a 0= IF TRUE EXIT THEN
   a1 0= IF TRUE EXIT THEN
   a u a1 u1 COMPARE ;

: ACCEPT-WITH-AUTOCOMPLETION ( a u -- n )
   history 0 = IF load-history THEN
   TO _n1
   TO _addr
   0 TO in-history
   0 TO _in
   0 TO _last
   0 TO _cursor
   AT-XY? TO _y TO _x
  BEGIN
   _in 1+ _n1 > IF _in EXIT THEN
   skey accept-one
  WHILE
   FALSE display
  REPEAT
  TRUE display
  CR
  _in 0= IF _in EXIT THEN
  LAMBDA{
   DUP .val @ STR@ _addr _in SAFE-COMPARE 0= IF .val @ add-history FALSE ELSE DROP TRUE THEN
  } history ?ForEach
  DUP
  IF
    FreeNode
    dump-history
  ELSE
   DROP
   _addr _in >STR add-history \ �������� � �������
   _addr _in history-file ATTACH-LINE-CATCH DROP
  THEN
  _in
;

: init 
  0 TO history
  ['] ACCEPT-WITH-AUTOCOMPLETION TO ACCEPT ;

init 
.( Autocompletion loaded) CR
..: AT-PROCESS-STARTING init ;..

;MODULE

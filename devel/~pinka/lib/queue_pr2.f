\ 07.Jul.2001 Sat 21:27 Ruv

\ ������� � �����������  Low Value First

( module export:
     queue.  LeaveLow        Enterly NewQueue       
     VocPrioritySupport      DelQueue 
)
\ 05.Jul.2002 Fri 23:47 + Queue-Count + ^cnt
\ 14.Sep.2003 Sun  + mapQueue * ���������� ��������� ������ ������ ^cnt
\ 06.Oct.2003 + QueueLow,   rename: Queue-Count -> QueueLen, Aa-Bb -> AaBb

REQUIRE {  lib/ext/locals.f

MODULE:  VocPrioritySupport

\ priority: LowValueFirst

( ��������������� ������������� �� priority ������. )
0  \ list element
1 CELLS  -- ^next
1 CELLS  -- ^prev
1 CELLS  -- ^priority
      0  -- ^cnt  \ �.�. ������������ ������ � ������� ������-�������� ( a )
1 CELLS  -- ^value
CONSTANT /elist

: insert { newel elem -- }
\ newelem before ( at left) elem
  elem ^prev @  DUP 
    newel ^prev  !
    newel SWAP ^next !
  elem newel ^next !
  newel elem ^prev !
;
: remove { elem -- }
  elem ^next @  elem ^prev @  ^next !
  elem ^prev @  elem ^next @  ^prev !
  \ ������ ������ ������ �� elem 
  \ ��� elem  �� ������.
  \ ������ ���� ���� ����� � ������ (����������)
;

EXPORT

: NewQueue ( -- queue )
  { \ a z }
  /elist ALLOCATE THROW  -> a  a /elist ERASE
  /elist ALLOCATE THROW  -> z  z /elist ERASE
  z a ^next !
  a z ^prev !
  -1 a ^priority !
   0 z ^priority ! \ must be so !
   ( ������� - �� ���������� priority )
  a  z ^value !
  z
; \ queue = elem_z

DEFINITIONS

: first ( q -- elem )
  ^value @  ^next @
;

EXPORT

: Enterly { x pr  queue  \ newel  -- }
\ �������� ������� x � ������� queue � ����������� pr
  queue ^value @ ^cnt 1+!
  queue first ( elem )
  BEGIN pr OVER ^priority @ U< WHILE ^next @ REPEAT ( elem ) 
  /elist ALLOCATE THROW -> newel
  x   newel ^value    !
  pr  newel ^priority !
  newel SWAP insert
;

: LeaveLow  ( queue -- x true | false )
\ ��������� �� ������� ������ ������� (c ���������� ��������� ��������� pr),
\ �������� ������� �� ����� � true, � ������ ������
\ ��� false � ������ �� ������ (������ �������).
  { q \ elem }
  q ^value @ ^cnt @ IF
    -1 q ^value @ ^cnt +!
    q ^prev @ -> elem
    \ q ^value @ elem = IF FALSE EXIT THEN
    elem remove
    elem ^value @  -1
    elem FREE THROW 
    EXIT     
  THEN  FALSE
;

: DelQueue ( queue -- )
  BEGIN DUP WHILE DUP ^prev @ SWAP FREE THROW REPEAT  DROP
;

\ Include ( x pr  queue -- )
\ ExcludeLow ( queue -- x true | false )

: queue. { q -- }
  q first BEGIN DUP q <> WHILE
    DUP .  DUP ^priority @ . DUP ^value @ . CR
    ^next @
  REPEAT DROP
;
: QueueLen ( q -- len )
  ^value @  ^cnt @
;
: QueueLow { q -- priority-low }
  q ^value @ ^cnt @         IF
  q ^prev @  ^priority @    ELSE
  0                         THEN
;
: mapQueue { q xt \ e -- }  
\ xt ( value pr -- )
  q first BEGIN DUP q <> WHILE -> e
    e ^value @ e ^priority  @ xt  EXECUTE
    e ^next @
  REPEAT DROP
;

;MODULE

 ( Example:
NewQueue VALUE q
10 5 q Enterly  \ value pr queue -- 
11 7 q Enterly
12 3 q Enterly
13 7 q Enterly
q queue.
q :NONAME DROP . ; mapQueue CR
q QueueLen . CR
q LeaveLow . . CR
q LeaveLow . . CR
q LeaveLow . . CR
q LeaveLow . . CR
q LeaveLow . CR
q DelQueue
\ )
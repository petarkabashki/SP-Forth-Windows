\ ���������������� ������.
\ list+  - �� ������������ ������, � ������ ���������.

\ 08.07.2000  Ruv
\ 14.Apr.2001
\   ������� ���������  List-ForEach - xt �� ��������� flag
\   ������ ��������� ������ ?List-ForEach
\ 18.Dec.2001 Tue 19:25 + List-Count
\ 14.Jan.2002 Mon 05:24
\   * List-ForEach ��������� ����������� ������.

( 
 0 \ struct node
 4   -- link
 ... -- body
)

: list+  ( a-node  hList -- )  \ �������� _����_ ( node) � ������.
\ hList @  - ����� ���������� ������������ ��������.
  DUP >R @ OVER ! R> !
;
: ?List-ForEach  ( xt hList -- )
\ xt ( node -- flag )  \ ����������, ���� true
    BEGIN  @ DUP  
    WHILE  2DUP 2>R SWAP EXECUTE 0= IF RDROP RDROP EXIT THEN 2R>
    REPEAT 2DROP
;
: List-ForEach  ( xt hList -- )
\ xt ( node -- )
    @ BEGIN  DUP WHILE 2DUP @ 2>R SWAP EXECUTE 2R> REPEAT 2DROP
;
: List-Count ( list -- count )
  0 BEGIN SWAP @ DUP WHILE SWAP 1+ REPEAT DROP
;

:NONAME  DUP . CELL+ @ . CR ;  ( S: xt )
: .list  ( list -- )  LITERAL SWAP List-ForEach ;

 ( example
VARIABLE hList  0 hList !

HERE 0 ,  hList list+
HERE 0 ,  hList list+
HERE 0 ,  hList list+

\ :NONAME  . .S CR  TRUE ;  hList  List-ForEach

hList .list

\ )

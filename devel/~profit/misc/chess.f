\ � �������� ������� ����� �� ����� (http://fforum.winglion.ru/viewtopic.php?p=7491#7491)

\ ������ � ����� ��������� �����

\ ��� ������� ����� ����������� SPF:
\ http://sourceforge.net/project/showfiles.php?group_id=17919

\ � ���������� ����������:
\ http://sourceforge.net/project/shownotes.php?release_id=497972&group_id=17919


REQUIRE HEAP-COPY ~ac/lib/ns/heap-copy.f
REQUIRE (:    ~yz/lib/inline.f
REQUIRE PRO   ~profit/lib/bac4th.f
REQUIRE __    ~profit/lib/cellfield.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE ENUM  ~nn/lib/enum.f
REQUIRE seq{  ~profit/lib/bac4th-sequence.f
REQUIRE NOT   ~profit/lib/logic.f
REQUIRE iterateByCellValues ~profit/lib/bac4th-iterators.f
REQUIRE list+ ~pinka/lib/list.f


3 CONSTANT W \ ������ ����
4 CONSTANT H \ ������ ����

50 CONSTANT MAX-MOVES \ ������������ ���-�� ����� � ��������

: list=> ( list --> value \ <-- ) R> SWAP List-ForEach ; \ �������� �� ������

\ ��������� ������
0
__ board-link
__ board-addr
__ board-moves
CONSTANT board-elem

\ ������������ ������� ������������
: 2KEEP! ( d addr --> \ <-- ) PRO SWAP OVER KEEP! CELL+ KEEP! CONT ;

 \ ������ ������� ������ ��������� �� ������������� ������� ��� �����
CREATE LAST-BOARDS MAX-MOVES CELLS ALLOT

W CONSTANT HORSES \ ������� ����� � ����� � � ������

CREATE STABLES \ �������� ������� ���������
HORSES 2 CELLS * ALLOT \ white horses
HORSES 2 CELLS * ALLOT \ black horses

: HORSE ( i -- x y ) 2 CELLS * STABLES + ;
: WHITE ( i -- i )  ;
: BLACK ( i -- i' ) HORSES + ;

: WHITE-HORSES ( --> i \ <-- i ) PRO \ ����� �������
HORSES 0 DO I WHITE CONT DROP LOOP ;

: BLACK-HORSES ( --> i \ <-- i ) PRO \ ������ �������
HORSES 0 DO I BLACK CONT DROP LOOP ;

: WCOORD (  --> x  \  <-- x )  PRO W 1+ 1 DO  I CONT DROP  LOOP ; \ ������ �� �����������
: HCOORD (  --> y  \  <-- y )  PRO H 1+ 1 DO  I CONT DROP  LOOP ; \ ������ �� ���������

: BOARD ( --> y x \ <-- y x ) PRO HCOORD WCOORD CONT ; \ ������ �� ���� �����
\ ������� "�������" ����� � WCOORD � HCOORD ����� �������� ��� �����

\ ������, ���������� ������ �� �������� ��������� ������� ����� ���������� ��� ����
: ?HORSE-MOVE ( x1 y1 y2 x2 <--> x1 y1 y2 x2 ) PRO
2OVER 2OVER
ROT - ABS  -ROT - ABS
*> 2RESTB <*> SWAP <*   1 2 D= ONTRUE CONT ;

\ ������������ ��� ��������� ���� ���� �� ��������� x y
: HORSE-MOVES ( x y --> u v \ <-- u v ) PRO 2DROPB WCOORD HCOORD ( x y ) ?HORSE-MOVE CONT ;

\ ������ ����� ��������?
: ?IS-WHITE-HERE ( x y --> x y \ <-- x y ) PRO
LOCAL x  LOCAL y
2DUP y ! x !
S| CUT: WHITE-HORSES DUP HORSE 2@ x @ y @ D= ONTRUE -CUT CONT ;

\ ������ ������ ��������?
: ?IS-BLACK-HERE ( x y --> x y \ <-- x y ) PRO
LOCAL x  LOCAL y
2DUP y ! x ! 
S| CUT: BLACK-HORSES DUP HORSE 2@ x @ y @ D= ONTRUE -CUT CONT ;

\ ������ �� ������?
: ?CAN-MOVE-HERE ( x y --> x y \ <-- x y ) PRO S|
NOT: ?IS-WHITE-HERE -NOT \ ��� ����� ������� � ������� x y
                         \ �
NOT: ?IS-BLACK-HERE -NOT \ ��� ר���� ������� � ������� x y
CONT ;

\ ��������� ����� ����?
: ?IS-ATTACKED-BY-WHITE ( x y --> x y \ <-- x y ) PRO
LOCAL x  LOCAL y
2DUP y ! x !
S| CUT: WHITE-HORSES DUP HORSE 2@ x @ y @ 2DROPB ?HORSE-MOVE -CUT CONT ;

\ ��������� ������ ����?
: ?IS-ATTACKED-BY-BLACK ( x y --> x y \ <-- x y ) PRO
LOCAL x  LOCAL y
2DUP y ! x !
S| CUT: BLACK-HORSES DUP HORSE 2@ x @ y @ 2DROPB ?HORSE-MOVE -CUT CONT ;

\ ����� ���� ����� ����� ����?
: ?CAN-WHITE-MOVE-HERE PRO
?CAN-MOVE-HERE
S| NOT: ?IS-ATTACKED-BY-BLACK -NOT CONT ;

\ ������ ���� ����� ����� ����?
: ?CAN-BLACK-MOVE-HERE PRO
?CAN-MOVE-HERE
S| NOT: ?IS-ATTACKED-BY-WHITE -NOT CONT ;

\ ������� ������ ���� ��� ������� i
: MOVE-WHITE-HORSE ( i --> \ <-- i ) PRO LOCAL h DUP
HORSE DUP h ! 2@ HORSE-MOVES ( x y )
?CAN-WHITE-MOVE-HERE  2DUP h @ 2KEEP! CONT ;

\ ������� ������� ���� ��� ������� i
: MOVE-BLACK-HORSE ( i --> \ <-- i ) PRO LOCAL h DUP
HORSE DUP h ! 2@ HORSE-MOVES ( x y )
?CAN-BLACK-MOVE-HERE  2DUP h @ 2KEEP! CONT ;

\ ���������� ����� �� ��������� �������
: INIT-POS
LOCAL i

i 0!
START{
WHITE-HORSES
i 1+! i @ OVER 1 SWAP HORSE 2!
}EMERGE

i 0!
START{
BLACK-HORSES
i 1+! i @ OVER H SWAP HORSE 2!
}EMERGE ;

 \ ������ ������� ������ ���� �������� ������������� ������� ������� �����
: DRAW-BOARD  ( --> addr u \ <-- )
PRO arr{ \ �������� ������������ ������
BOARD ( y x ) 2DUP 2DROPB SWAP
S| PREDICATE ?IS-WHITE-HERE SUCCEEDS \ ���� ����� �������
IF [CHAR] @ ELSE
S| PREDICATE ?IS-BLACK-HERE SUCCEEDS \ ���� ������ �������
IF [CHAR] # ELSE
   BL       THEN THEN                \ ���� ���� ������
}arr CONT ;

: PRINT-BOARD ( addr u -- ) \ ����������� ������������� ������� �����

(: CR ."    " WCOORD DUP . SPACE ;)
BACK EXECUTE TRACKING RESTB EXECUTE
(: CR ."   -" WCOORD ." ---" ;)
BACK EXECUTE TRACKING RESTB EXECUTE

LOCAL i  i 0!
CELL / iterateByCellValues
i @ W /MOD SWAP 0= IF CR [CHAR] A + EMIT ."  |" ELSE DROP THEN
i 1+! DUP EMIT ."  |" ;

: SHOW-BOARD ( -- ) DRAW-BOARD PRINT-BOARD ;

INIT-POS ( 1 c   1 BLACK HORSE 2! ) \ SHOW-BOARD \EOF
\ DRAW-BOARD DUMP

\ ��� 2 ����������� �����������

: ?ARE-WE-DONE-YET ( -- f ) \ ����������� �����������
&{ BLACK-HORSES DUP HORSE 2@ ( x y ) NIP 1 = }& \ AND(y(��� ������ �������)=1)
&{ WHITE-HORSES DUP HORSE 2@ ( x y ) NIP H = }& \ AND(y(��� �����  �������)=h)
AND ;

: ?ARE-WE-DONE-YET ( -- f ) PREDICATE \ ����������� ��������� ���������
S| NOT: BLACK-HORSES DUP HORSE 2@ ( x y ) NIP 1 = ONFALSE -NOT \ ��� ����� �����  ������� � ������� ����� �� ����� 1
S| NOT: WHITE-HORSES DUP HORSE 2@ ( x y ) NIP H = ONFALSE -NOT \ ��� ����� ר���� ������� � ������� ����� �� ����� H
SUCCEEDS ;

: ?ODD ( n -- f )  1 AND ;

:NONAME

LOCAL moves \ ���������� ����

LOCAL cur-board
LOCAL cur-board#

LOCAL boards \ ������ �������
boards 0!

LOCAL i

moves 0!

START{ \ ������� ���� ��������
BEGIN
boards @ \ ������ �������� ������ ���������

START{ \ ���� ����������� ������������ �������
DRAW-BOARD cur-board# ! cur-board !
S| NOT:
boards list=> DROPB \ ���� �� ������ �������
DUP board-moves @ ?ODD moves @ ?ODD = ONTRUE \ 
DUP board-moves @ moves @ > ONFALSE \ ������ ����� ������� ��������� � ������ �����
DUP board-addr @ cur-board# @ cur-board @ cur-board# @ COMPARE 0= ONTRUE \ ���������� ������� �� ���������
-NOT \ ��� ������� � ������, ����������� � �������
\ ��� ������ ��� ������� ���������, � ����

\ ���������� ����� ������� ������
board-elem ALLOCATE THROW >R \ ������� �������
cur-board @ cur-board# @ HEAP-COPY \ DRAW-BOARD ������� "����" ������� ������ �� ����, ������� �������� ����
DUP R@ board-addr ! \ ���������� � ���� �����
moves @ CELLS LAST-BOARDS + ! \ ����� ����� ������� ����� ����� � ������� �������� �������
moves @ R@ board-moves ! \ ���������� ������� ���
R> boards list+

}EMERGE

boards @ = ONFALSE \ ����� �� �������? ������������ �� ��������� ������ boards

?ARE-WE-DONE-YET IF \ ��������� �� � ��� ������ ������� �� �����?
CR CR DEPTH ." S: " . ."  R: " RP@ R0 @ - ABS CELL / . \ �������� ���� �������� ������� ������
START{ i 0! \ �������� ���� ������ ������� ����� �������
LAST-BOARDS moves @ iterateByCellValues DUP cur-board# @
CR CR i 1+! ." Move:" i @ . PRINT-BOARD }EMERGE
THEN

moves @ ?ODD                  IF
WHITE-HORSES MOVE-WHITE-HORSE ELSE \ ������ �������� "����" -- ����� �����
BLACK-HORSES MOVE-BLACK-HORSE THEN \ �������� -- ������
moves KEEP moves 1+! \ ���������� ���� ����������� (KEEP � ����������)

moves @ MAX-MOVES > ONFALSE \ ������������ ������� ������������ ��������
AGAIN \ ���� �� ����� -- ���� ���� ������� �� ��������� ����
}EMERGE

CR ." Maximum move: " MAX-MOVES .
CR ." Positions processed: "

+{ boards list=> FREE THROW  1 }+ .
; STARTLOG EXECUTE
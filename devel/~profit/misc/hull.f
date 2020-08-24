\ ����� �������� ��� ��������� �������� �����
\ http://fforum.winglion.ru/viewtopic.php?t=877
\ ����� ��������� ����� � ���� ������������� ����������
\ ������������ ���� ����� ����� ������� INPUT-POINT ( -- x y )
\ � END-OF-POINTS ( -- f ), ��������� ���������� ����� ��������� �����

REQUIRE CHOOSE lib/ext/rnd.f
REQUIRE F. lib/include/float2.f

\ REQUIRE /TEST ~profit/lib/testing.f
: /TEST INCLUDE-DEPTH @ 1 <> IF \EOF THEN ; \ � SPF 4.18 testing.f �������

REQUIRE PRO ~profit/lib/bac4th.f
: 2DROPB R> EXECUTE 2DROP ; \ � SPF 4.18 � bac4th.f ��� 2DROPB

REQUIRE split ~profit/lib/bac4th-str.f
REQUIRE iterateByByteValues ~profit/lib/bac4th-iterators.f

REQUIRE HASH!R ~pinka/lib/hash-table.f
\ �������� �� ����
: hash=> ( hash --> addrI uI addrEl|value \ <-- ) R> for-hash ;

VARIABLE row
VARIABLE col

\ ������ ������ addr u ��� ������������� � �������
: str-points=> ( addr u --> x y n / <-- x y n ) PRO
row 0!

2DUP byRows split DUP STR@ \ ������� �� �������
2DROPB                     \ ����������� ����� STR@ addr u �� �������� ���� �������
DUP 0= ONFALSE             \ ������ ������ ���������� (?)
row 1+!                    \ ������� ������
col 0!                     \ �������� ������� � ������ ������
2DUP iterateByByteValues   \ ������� �� ������
col 1+!                    \ ������� �������
DUP [CHAR] . <> IF         \ ���� �� �����, ��
col @ OVER row @ SWAP CONT \ ���������� ������ "�� �����"
2DROP DROP THEN ;

\ ������ ���
small-hash VALUE POINTS

\ ���� �� ���� ������ � ����
: points=> ( --> addrEl \ <-- addrEl ) PRO POINTS hash=> 2DROP ( addrEl ) CONT DROP ;

\ � ������ ���� ����� ����� ���������:
\ ������� ���� ������� ��
\ ���������� ����� -- � ������ ���� (x, y).
\ ���� ����� -- ������ ����� �������-������ (����� �� ������ ����� ��� ��������� �������������� ������ �������� � �������)

0
2 CELLS -- xy
   CELL -- name
CONSTANT /point

: y ( addr -- addr' ) xy ;
: x ( addr -- addr' ) y CELL+ ;

\ ������������� ������ c �� ����� � ��������� ������ ��� ����
: letter-str ( c -- addr u ) S" ." >R TUCK C! R> ;

\ CHAR a letter-str TYPE \EOF
\ CHAR Z letter-str TYPE \EOF

\ ����� �������� �� ���� POINTS ������� ����� ��������� ������������� addr u, ���� ������ ��� -- �������
: (POINTS@) ( addr u -- addr )
2DUP POINTS HASH@R ?DUP 0= IF
/point -ROT POINTS HASH!R  ELSE
NIP NIP                    THEN ;

\ ������ ������� ������ (�������� � ��� ������) �� ���� ��� ������� c
: POINTS@  ( c -- addr ) letter-str (POINTS@) ;

\ ������ ������ addr u , ����� ��������� � ��� POINTS
: read-points ( addr u -- )
POINTS clear-hash
str-points=>
\ DEPTH . BACK DEPTH . KEY DROP TRACKING
DUP POINTS@ 2DUP name !
2>R 2DUP R> xy 2! R> ;

\ ��������� ������������� � ����� � ������ addr u � ����� ��������� � ��� POINTS
: load-points ( addr u -- ) load-file read-points ;

\ cur-point ������ ����� �������� ����� � ����, � �� ���� �������� ���������
0 VALUE cur-point \ ������� �����
0 VALUE first-point \ ������ �����

\ ���������� ������ ����� ������ ����� � cur-point (���� �� ���������,
\ �� ��� �� ������ �� ������ -- ������ ������ ����������)
: find-max-y-cur-point ( -- )
0 TO cur-point 
points=>
cur-point 0=            IF DUP TO cur-point EXIT THEN
DUP y @ cur-point y @ > IF DUP TO cur-point THEN ;

: 4DUP ( d1 d2 -- d1 d2 d1 d2 ) 2OVER 2OVER ;

: coords ( addri addrj -- x1 y1 x2 y2 )
>R xy 2@ R> xy 2@ ;

\ �������� ���� ������������ ����� ������ (x1,y1)-(x2,y2)
\ � ���� x
: quadrant ( x1 y1 x2 y2 -- quadrant# )
ROT > IF > IF 3 ELSE 4 THEN ELSE > IF 2 ELSE 1 THEN THEN ;
\         ^ y      
\         |        
\    2    |   1    
\         |        
\ --------+--------> x
\         |        
\         |        
\    3    |   4    
\         |        

\ ���� ���� ����������� ����� ������ (x1,y1)-(x2,y2)
\ � ���� x (���� ������ ����� ������ pi/2 [90 ��������])
\ �� ������ -- �������� ���� �� ����� float
: (get-angle0) ( x1 y1 x2 y2 -- D:    F: alpha )
4DUP D=           IF
2DROP 2DROP 0.e   ELSE \ ���� ����� ���������, �� ����=0
ROT
- S>D D>F  ( F: dy )
- S>D D>F  ( F: dy dx )
F/ FABS FATAN     THEN ;


\ ��������� ���� ����� ��������� (0,0)-(x2-x1,y2-y1) � (0,0)-(infinity,0)
: (get-angle) ( x1 y1 x2 y2 -- D:    F: alpha )
4DUP (get-angle0) quadrant \ �������� � ������ ��������� ����
DUP 1 AND 0= IF FPI 2e F/ F- FNEGATE THEN \ ������������� �� 90 �������� � 2 � 4-� ����������, ���� ���������� �� (get-angle0)
1- S>D D>F FPI F* 2e F/ F+ \ ��������� ����� ������ ������� ���������
;

\ "����������" ����
: flip-angle ( F: a -- F: 2Pi-a ) FNEGATE FPI F+ FPI F+ ;

\ ������� ���������� -- ������� ���� ����� (���������� ��������)
: angle-distance ( F: angle1 angle2 -- F: delta )
F- FABS \ ���������� �������
FDUP FPI FSWAP F< IF flip-angle THEN \ ���� ���� ������ 180 �������� (pi), �� ����� ��� "����������"
;

\ ��������� ���� ����� (0,0)-(infinity,0) � (x1,y1)-(x2,y2),
\ ��� (x1,y1) -- ���������� ������� ����� (cur-point)
\ ��� (x2,y2) -- ���������� ����� ������������ ����� "������" 
\ �� ����� -- ����� �������� ���� �����
: get-angle ( addrEl -- F: angle )
cur-point SWAP coords (get-angle) ;

\ "��������" ���� -- ����, ����������� � ������� ��� ���������� ����� �������� ��������
\ ���� ����� ���������� � ��������� ������ ������ ���� ������������ ��������� � 
\ "��������� ����" (��� �������� ���� ������ ����� ����� �������)
0e FVALUE desired-angle

\ ������� (�������) ����� "�������� �����" � ����� ����� ���������� ��
\ ������� ����� �� �����, "������" ������� ����� �� �����
: get-proximity ( addrEl -- F: proximity ) get-angle desired-angle angle-distance ;

\ �������� �� ��������� ����� �����
0 VALUE candidate-point
\ �������� �� "��������������" � "���������" ���� �����-��������� 
\ (������ ����������� �������� ����� ���������)
100e FVALUE candidate-proximity

\ ��� �������� ������� ����� (cur-point) � "�������� ����" (desired-angle)
\ ���������� ����� �����, ��� ���� ����� �� cur-point � ��� ����� ��������
\ ������������ � desired-angle (�������� ���������� ����������)
: next-in-hull ( -- D: addrEl F: angle )
100e FTO candidate-proximity \ �������� �������� ������� ��������
START{ points=>
DUP cur-point = ONFALSE

\ DUP name @ CR EMIT SPACE
DUP get-proximity \ FDUP F. KEY DROP

candidate-proximity
         FOVER FSWAP F< IF   \ ." %%%"
FTO candidate-proximity
DUP TO candidate-point  ELSE \ ." &&&"
FDROP                   THEN }EMERGE
candidate-point ;

\ ��������, ��������������� �������� ����� �� �������� ��������
: hull=> ( --> addrEl \ addrEl <-- )
PRO
find-max-y-cur-point
cur-point TO first-point \ ���������� ������ ����� � ��������
0.e FTO desired-angle \ "�������� ����" �� ������ ����� "�������"

BEGIN
cur-point CONT DROP \ ���������� ����� � ������� ������
\ cur-point name @ CR EMIT SPACE
\ desired-angle F. KEY DROP CR

next-in-hull \ ����������� ��������� ����� ��������
DUP get-angle FTO desired-angle \ ���� ������ �����
DUP TO cur-point \ ������ ��� -- ����� ������� �����
first-point = UNTIL \ ���������, ���� �� ������� � ������ �����
;

CREATE toFind 0. , ,
VARIABLE found

\ ����� ����� �����, ���������� ������� ����� (x,y)
\ ���� ����� �� �������, �� ��������� =0
: findXY ( x y -- addrEl|0 )
toFind 2! found 0!
START{ points=>
DUP xy 2@ toFind 2@ D= ONTRUE
DUP found ! }EMERGE found @ ;

\ ������� ������������ ���������� x ����� �����
: maxX ( -- maxX )
found 0!
START{ points=> \ hull=> \ ����� ���������� � ���������� ����� ������ �� ��������, ��� ���� � ����� ���������, �� �������������
DUP x @ found @ MAX found ! }EMERGE found @ ;


\ ������� ������������ ���������� y ����� �����
: maxY ( -- maxY )
found 0!
START{ points=>
DUP y @ found @ MAX found ! }EMERGE found @ ;

\ �������� "�����"
: show-board
maxY 1+ 0 DO CR
maxX 1+ 0 DO
I J findXY ( addrEl )
?DUP 0= IF [CHAR] . ELSE name @ THEN EMIT
LOOP LOOP ;

\ ����������� ����� �� �������� ��������
: print-hull ." [ " BACK ."  ]" TRACKING hull=> DUP name @ EMIT ;

VECT INPUT-POINT ( -- x y ) \ �� ����� ����� ����� � ���, ����� ���������� ���� ������, �� ������ �������� ���������� �����
VECT END-OF-POINTS ( -- f ) \ ���� ������ ���������� �������� �� ��� ��� �����

: INPUT ( -- )
POINTS clear-hash
-1 [CHAR] A DO \ ����������� ����� ����������� ����
END-OF-POINTS IF LEAVE THEN \ ����� �� �����
I SP@ CELL ( i addr u ) \ addr u -- ��� "������"-�������������, �� ����� ���� �� ������, � ������ ����� ������������ ����� i �� �����
\ ��� ���� �� ���������� �� �� ��� � ���������� ����� ������-�������������� �������������� ��� ASCIIZ-�������
(POINTS@) INPUT-POINT ( i addr x y )
>R OVER x !
R> OVER y !
( I addr ) name !
LOOP ;

40 VALUE width
30 VALUE height

\ ��������� ���� ����� � ��������� ������ �� ����� 40x30
: generate-point ( -- x y ) BEGIN
width CHOOSE height CHOOSE
2DUP findXY                 WHILE \ ��������� ���� �� ����� 0 (�.�. ������ � ��������� ������������ �� ������)
2DROP                       REPEAT ;

VARIABLE points#
: points0= ( -- f ) points# @ 0=   -1 points# +! ;

\ �������� ���������� ����� �� ����� 40x30
: generate-points ( n -- )
points# ! RANDOMIZE
['] generate-point TO INPUT-POINT
['] points0= TO END-OF-POINTS
INPUT ;

/TEST

 ( ���������� ������, ���� ��� ������� ���������������, �� ��� ���������

"
.........................................................................
.....................................c...................................
.........................................................................
..........a..............................................................
.........................................................................
...........................e.........................................f...
.....................................................l...................
.........................................................................
..................................i......................................
.........................................................................
.........................................................................
.................b.......................................................
.........................................................................
.........................................................................
..............r...................j.................k....................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
.........................................................................
..........d.............................................................g
.................................h.......................................
.........................................................................
.........................................................................
.........................................................................
...........................................m.............................
..................................q......................................
.........................................................................
.............................................z..........................."
STR@ read-points


show-board
find-max-y-cur-point

CR
S" cur point: " CR TYPE cur-point xy 2@ . . KEY DROP \ z

: point CHAR POINTS@ ;

CR
point j  point f coords quadrant . \ 1
point j  point e coords quadrant . \ 2
point j  point d coords quadrant . \ 3
point j  point m coords quadrant . \ 4
KEY DROP

CR 
point c xy 2@ . .
point c TO cur-point
point a get-angle F.
KEY DROP

point j TO cur-point

0.e FTO desired-angle

CR point k get-proximity F. S" 0" TYPE
CR point l get-proximity F.
CR point i get-proximity F. S" pi/2" TYPE
CR point e get-proximity F.
CR point a get-proximity F.
CR point b get-proximity F. 
CR point r get-proximity F. S" pi, max angle distance from 0 radians" TYPE
CR point d get-proximity F.
CR point q get-proximity F. S" pi/2" TYPE
CR point m get-proximity F.
KEY DROP

\EOF
\ )

\ �� �����: ��� �������� ����� �� �����, ���� ��������� ���������
\ S" hull.txt" load-points show-board CR print-hull (
26 generate-points show-board CR print-hull \ )

\ �������� ������������ ������-�����, �� ������ ������ -- ������ �� ������
( \ ������������ ��� ������� ����� ��������
1000 TO width
1000 TO height
5000 generate-points


CR S" points generated. Press any key" TYPE KEY DROP
: r hull=> CR DUP x @ . DUP y @ . ; r
\ )
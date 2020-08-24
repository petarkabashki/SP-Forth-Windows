\ ���������������� ������ �� ��������� �����. �� ������ �� ���,
\ �� ���� �� ����, �� ������ ����� ������ � ������ � ������ � �.�.

\ �������: ���������� �������� �������� � ������������� �����.
\ ������: ��� ������������� step, ������ �� ���� ������������� len?
\ �����: ����� �������� iterateByByteValues � ������, step �� ������ 
\ ���� �������������. ������� ������������� ������ ���������� len

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE compiledCode ~profit/lib/bac4th-closures.f

\ �������� ������ � ����� ��� ������� ��� �� ����� �������� � �������� �������
: reverse ( start len -- start+len -len ) DUP NEGATE -ROT + 1- SWAP ;

\ ����� ������� (� �������) �������
: iterateBy1  ( start len step --> i \ i <-- i ) PRO LOCAL step step !
OVER + SWAP ?DO
I CONT DROP
step @ +LOOP ;

\ ������� ���������, ��� DO LOOP � ������������� R-�����
: iterateBy2  ( start len step --> i \ i <-- i ) PRO
LOCAL step step !
OVER +
LOCAL end DUP end !
OVER > IF
BEGIN
CONT
step @ +
DUP end @ < 0= UNTIL
ELSE
BEGIN
CONT
step @ -
DUP end @ > 0= UNTIL
THEN DROP ;

\ ������� � ������������ ���������� ���� �����
: iterateBy3  ( start len step --> i \ i <-- i ) PRO
OVER >R >R
OVER + ( start end  R: len step )
SWAP R> SWAP ( end step start  R: len )
R> 0 > IF
" LITERAL
BEGIN
[ R@ENTER, ]
LITERAL +
DUP LITERAL < 0= UNTIL
DROP RDROP"
ELSE
" LITERAL
BEGIN
[ R@ENTER, ]
LITERAL -
DUP LITERAL > 0= UNTIL
DROP RDROP"
THEN
STRcompiledCode ENTER CONT ;

\ ������� ����� ������������, ��������� ���� �������� � ������ ����� �� ��������� (2-� ��� 3-�)
\ ����� ������������
: iterateBy ( start len step --> i \ i <-- i )
OVER 0= IF 2DROP DROP RDROP EXIT THEN \ ���� ����� ������� ��� ������, ������ ������ ������ ��� ������..
2DUP 6 LSHIFT ( 2* 2* 2* 2* 2* 2* ) SWAP ABS >
\ ������: ���� ���-�� �������� � ����� ����� ������ ���, ������ 64 (����� � �������),
IF RUSH> iterateBy2 ELSE
\ �� ������� ����������,
   RUSH> iterateBy3 THEN ;
\ �����, ���� ������ ��� 64, -- �� ���������� ���� � ������� � ��

  \ : iterateBy RUSH> iterateBy1 ;
\ ^-- "������� � ������ ������" (�) (���������)
\ ���� ����� ������� � ����������, ����� �������� �����������
\ �������� ������, ������ � ������� ��� ������� iterateBy1

: iterateByBytes ( addr u <--> caddr )        1 RUSH> iterateBy ;
\ ������ �� ������ ������ ����������� ������������ RUSH>
\ ���� ������ iterateByBytes ��� ������������ �������� � RUSH> 
\ �������� �� ��� ���������� ����� "������" (�����), ������� 
\ ������ PRO ... CONT � ��� ���� ���� ��� ���������� ����� �� 
\ �������� �� L-�����, �� � ��������� �� ������������.

: iterateByWords ( addr u <--> waddr )        2 RUSH> iterateBy ;
: iterateByCells ( addr u <--> addr )      CELL RUSH> iterateBy ;
: iterateByDCells ( addr u <--> qaddr ) 2 CELLS RUSH> iterateBy ;

: iterateByByteValues ( addr n <--> char ) PRO       iterateByBytes DUP C@ CONT DROP ;
: iterateByWordValues ( addr n <--> word ) PRO 2*    iterateByWords DUP W@ CONT DROP ;
: iterateByCellValues ( addr n <--> cell )  PRO CELLS iterateByCells DUP @ CONT DROP ;

: times ( n --> \ <-- ) 1 SWAP 1 RUSH> iterateBy ;

/TEST
: printByOne iterateByByteValues DUP EMIT ." _" ;
$> S" abc" printByOne  S" ]" TYPE

$> S" abc" reverse  printByOne  S" ]" TYPE

: 10-3. 10 -3 1 iterateBy DUP . ;
$> 10-3.

: 1-100. 1 100 1 iterateBy DUP . ;
$> 1-100.

: 150-50. 150 -100 1 iterateBy DUP . ;
$> 150-50.

: 0. 150 0 1 iterateBy DUP . ;
$> 0.

: s 100 0 DO +{ 1 200000 1 iterateBy DUP }+ . LOOP ;
\ ResetProfiles s .AllStatistic
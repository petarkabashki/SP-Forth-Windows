REQUIRE /TEST ~profit/lib/testing.f
REQUIRE <= ~profit/lib/logic.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE PRO ~profit/lib/bac4th.f

\ �������� ����� �� �������. a , b -- ��� ��������� �������� 
\ ������������� �������� ���������� ������� f , ������� 
\ ������������ xt �����. ���������
\ ��� ������� ��������� ���� ���� ����������� �������� �� �����
\ � ����� +1|0|-1 , ���������� -- ����, +1 -- ������, -1 -- 
\ ������.
\ �� ������ ���� � ��������� �������� ��������� ������� f ��� �������
\ f=0, ���� ���� �� ���� �������, �� ��������� ����������� � ����

\ ����� ������������ � ��� ��� ������ �� ���������������� �������, ��� 
\ � ��� ���������� �������� ������� (��. ������� �����).

\ binary-search ���������! ����������� reverse-function
: binary-search ( a b f -- i 0|-1 ) >R \ f ( i -- +1|0|-1)
BEGIN 2DUP < WHILE
2DUP + 2/
DUP R@ EXECUTE ( +x|0|-x ) \ ������|�����|������
DUP 0= IF DROP NIP NIP TRUE RDROP EXIT THEN \ ���� ����������
0< IF NIP 1- ELSE ROT DROP 1+ SWAP THEN \ �����
REPEAT

DUP R@ EXECUTE 0= IF NIP TRUE RDROP EXIT THEN \ ���. �������� �� ������� ������
DROP FALSE RDROP ;

\ ���� ��������� ������. ����� �������� c � ������� �������� ����, 
\ ����������� ���� ��� ���� ������ (���� ��� ����� �� ��� �����,
\ �� ��� ������ ����� ���������� ������� ���������).
\ ������ ����� ����� ����� -- ��� ����������� ���� � �����������
\ ��� ��� ������ � ��������� ���
\ �� �����: ��������� �������� (a,b)
: fork-cycle ( a b --> c \ <-- flag ) PRO
BEGIN
2DUP <= WHILE
2DUP + 2/ ( a b c )
DUP CONT ( flag )
IF NIP 1- ELSE ROT DROP 1+ SWAP THEN \ �����
REPEAT ;
\ TODO: ������ �� ����� ����� �� ��������� �����������������

\ ���� � ��������� (a,b) ����� �������� x, ��� ������� 
\ (���������� � ����� ���� ����� ��) ����� res
\ ���� ������� flag=TRUE � x -- ��������, ��� f(x)=res
\ ���� �� �������, �� flag=FALSE � x -- ����� ����
\ floor(x'), ��� f(x')=res, ���� ����� ������ �� �������
\ �������� ���� �������� �������� ��������� ������ ��� �
\ �������� ���������.
\ ������ ��� �������� �������, ���� �����.
: reverse-function ( a b res --> x \ x flag <-- x' )
R> LOCAL f f ! \ PRO .. CONT �� �������� ��-�� ���� ��� PREDICATE .. SUCCEEDS ���� ���������� L-����
\ ������� ����� ������ ��������� � ��������� ���������� � �������� �������
LOCAL res res !
PREDICATE
fork-cycle f @ ENTER \ ��� ���������� �� fork-cycle c ��������� ������� 
( fc ) \ � ����� �������� �������� f(c)
res @ - ( delta ) \ ������� ��������� �� �������������
BACK 0 > TRACKING \ ���� �� ������, ������ ���� ��� ������ � fork-cycle 
\ ������� �����������, ��� ������ ������
DUP 0= \ ������ ���������?
ONTRUE
SUCCEEDS
DUP IF NIP 2SWAP 2DROP ELSE ROT DROP THEN ;
\ ��������� �������� ��������� �����... ����������� �� ������� 
\ ���������� fork-cycle ���� ���� �� ������ (TODO)

/TEST

CREATE tmp
HERE
$> 0 , 1 , 3 , 5 , 6 , 10 , 20 , 33 , 123 , 231 , 400 ,
HERE SWAP - CELL / VALUE len

0 VALUE n

: 3DUP 2OVER 2OVER 3 ROLL DROP ;


:NONAME ( i -- f )  CELLS tmp + @ n - NEGATE ; CONSTANT arrI
0 len arrI
$> 10 TO n binary-search . .
0 len arrI
$> 400 TO n binary-search . .
0 len arrI
$> 8 TO n binary-search . .

:NONAME ( x -- f ) DUP * n - NEGATE ; CONSTANT sqrF

$> 1 1000 sqrF 400 TO n binary-search . .
$> 1 1000 sqrF 9 TO n binary-search . .
$> 1 1000 sqrF 1001 TO n binary-search . .

: 10/ ( res -- x ) 0 SWAP DUP DROPB reverse-function 10 * ;

REQUIRE factor ~profit/lib/bin-mul.f

: sqrt
DUP MAX{ factor DUP }MAX \ ������� ������������ ������� ������ � �����
2/ \ ���� �� �� ���������� ������, �.�. ����� ������� �� ���
defactor \ ��������� �� ����������������� ���� � ��������, �.�. �������� � �������
DUP 2* \ ��������� �������� � ������� ��������� ������ �����
ROT DROPB reverse-function DUP * ;

: // ( a b -- a/b )
OVER -ROT ( a a b )
LOCAL b DUP b !
MAX{ factor DUP }MAX 1+
RSHIFT DUP 2*
ROT DROPB reverse-function b @ * ;

:NONAME
CR CR ." sqrt " CR   200 0 DO I sqrt . LOOP
CR CR ." 10/  " CR   200 0 DO I 10/ . LOOP
CR CR ." //  " CR
1234567890 111111 // . ." =" 1234567890 111111 / .
; EXECUTE
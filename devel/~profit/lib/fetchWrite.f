REQUIRE /TEST ~profit/lib/testing.f

\ ���������������� ������ � ������ � ������ � ��������, �������� ����� ������� ������
\ ����������-������� -- ������� ������ ��� ��������-������������ � ��������� @+ !+
\ (��. MachineForth)

\ ������� ����� (���� �����) ������ ���������� �����������, ������ ����� �����
\ ������������ �� ������ �� ��� ��� ������ (��. ������ move), ����� ���������
\ ���������� ���� �������� VARIABLE, � �� VALUE-�����������.

: fetchByte ( addr -- b ) DUP  @ C@ SWAP 1+! ;
: writeByte ( n addr -- ) TUCK @ C!      1+! ;

: fetchWord ( addr -- b ) DUP  @ W@ SWAP 2 SWAP +! ;
: writeWord ( n addr -- ) TUCK @ W!      2 SWAP +! ;

: fetchCell ( addr -- b ) DUP  @ @  SWAP CELL SWAP +! ;
: writeCell ( n addr -- ) TUCK @ !       CELL SWAP +! ;


/TEST

REQUIRE TESTCASES ~ygrek/lib/testcase.f

REQUIRE { lib/ext/locals.f

TESTCASES fetchWrite tests

CREATE m 20 ALLOT

VARIABLE a

m a !
01 a writeByte
22 a writeByte
03 a writeByte

m a !
(( a fetchByte -> 1 ))
(( a fetchByte -> 22 ))
(( a fetchByte -> 3 ))

m a !
01 a writeWord
22 a writeWord
03 a writeWord

m a !
(( a fetchWord -> 1 ))
(( a fetchWord -> 22 ))
(( a fetchWord -> 3 ))

m a !
01 a writeCell
22 a writeCell
03 a writeCell

m a !
(( a fetchCell -> 1 ))
(( a fetchCell -> 22 ))
(( a fetchCell -> 3 ))

m a !
01 a writeByte
22 a writeWord
03 a writeCell

m a !
(( a fetchByte -> 1 ))
(( a fetchWord -> 22 ))
(( a fetchCell -> 3 ))

\ ����� ������ ����� MOVE � ������� ��������:
: move ( src len dest -- ) { \ [ CELL ] A [ CELL ] B -- }
B !  SWAP A ! 0 DO
A fetchByte ( x ) B writeByte
LOOP ;

CREATE tmp 1000 ALLOT
: check S" check00" ;
check tmp move

check tmp OVER TEST-ARRAY

END-TESTCASES

\ lib/ext/disasm.f
\ SEE move
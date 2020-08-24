REQUIRE /TEST ~profit/lib/testing.f

CREATE L0   \ ������ �����
100 CELLS ALLOT  \ ������ 100 �����
VARIABLE LP    \ ��������� ������� �����

: LEMPTY  L0  LP ! ; \ ���������� ��������� ����� �� ���
: LDEPTH ( -- d ) LP @ L0 -  CELL / ; \ ��������� ������� �����
LEMPTY  

: LUNDROP CELL  LP +! ;
: LDROP CELL NEGATE LP +! ;
: L@ ( -- n ) LP @ CELL- @ ;  \ ����� � L-�����, ������� ����� �� ��������

: L> ( -- n ) \ ����� � L-�����
L@  LDROP ;

: >L ( n -- ) \ �������� �� L-����
LP @ !  LUNDROP ;

/TEST
$> 1 >L  2 >L  L> . L> .
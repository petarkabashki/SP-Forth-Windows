\ Filename: darray.f - ������ � ��������
\ ���������� �.�. 
\ 27.02.2006�.
\ adr+0 - ���-�� �������
\ adr+1 - ���-�� �����
\
\
\

REQUIRE { lib/ext/locals.f
\ ������ ����� 2-� ������ ������
: new_array ( col row -- )
	2DUP * CELL * 2 CELLS + 
	ALLOCATE THROW >R
	R@ CELL + ! R@ ! R>
;

\ �������� �� row (�������) ������ arr
: resize_array ( row arr -- arr1 )
2DUP CELL + !
DUP >R @ * CELLS 2 CELLS +
R> SWAP RESIZE THROW
;

\ �������� ������ (� �������) �������
: size_array? ( arr -- n )
DUP @ SWAP CELL + @ * CELLS 2 CELLS +
;

\ ��������� ������������ ���������
: range_array? ( col row arr -- f )
>R 0 R@ CELL + @ 1+ WITHIN
SWAP
0 R> @ 1+ WITHIN
AND
;

\ ��������� ����� �������� � �������
: el_adr ( col row arr -- adr )
>R 2DUP R@ range_array?
	IF
		R@ @ * CELLS SWAP CELLS + 2 CELLS + R> +
	ELSE
		DROP 2DROP 0 RDROP
	THEN
;

\ �������� ������� � ������
: put_el ( val col row arr -- )
el_adr ?DUP IF ! THEN
;

\ �������� ������� �� �������
: get_el ( col row arr -- val )
el_adr ?DUP IF @ ELSE 0 THEN
;

\ �������� ����� ������ n (������� ���� � ������)
: rec_adr ( n arr -- adr )
SWAP 0 SWAP ROT el_adr
;


\ ���������� n3 ������� ������� � ������ n1, � n2
: move_records { n1 n2 n3 arr -- }
\ 2>R					\ R: n3 arr
n1 arr rec_adr		\ adr1
n2 arr rec_adr		\ adr1 adr2
arr @ CELLS n3 * 	\ adr1 adr2 col's
OVER OVER 2>R
MOVE
2R> + arr @ CELLS n1 n2 - * ERASE			\ ������������ ������� ��������
;

\ ���������� ��� ������ ������� � n1 b �� ����� �������, � n2
: move_allend_rec ( n1 n2 arr -- )
DUP CELL+ @ SWAP >R	\ n1 n2 col's
2 PICK - R> move_records
;

\ ����������� ������ ���������� ��� ������
: free_array ( arr -- )
FREE THROW
;


\EOF
0 VALUE m1

: test
10 10 new_array TO m1
m1 size_array? CR ." size=" .
10 0 DO
10 0 DO
	 J 10 * I + I J m1 put_el
	LOOP
LOOP
m1 500 DUMP
\ 20 m1 resize_array TO m1
\ 5 1 3 m1 move_records
6 1 m1 move_allend_rec
CR ." ====" CR
\ 10 0 DO I 4 m1 get_el CR ." el[ " I . ." ]=" HEX . DECIMAL LOOP
m1 500 DUMP
m1 size_array? CR ." size=" .
m1 free_array
;
test

\EOF
: _type
1000 0 DO I CELL * m1 + @ . SPACE  LOOP
;
10 12 new_array TO m1
1173 1 0 m1 put_el
7311 0 1 m1 put_el
7304 1 1 m1 put_el
m1 100 DUMP
m1 size_array? CR .( size=) .
20 m1 resize_array TO m1
m1 100 DUMP
m1 size_array? CR .( size=) .
CR
0 1 m1 get_el .
1 0 m1 get_el .
1 1 m1 get_el .

\EOF
1173 1 1 m1 el_adr .S m1 . \ - CELL / .
m1 100 DUMP
m1 free_array
\EOF
: test
1000 ALLOCATE THROW
TO m1
1000 0 DO I DUP CELL * m1 + ! LOOP
m1 100 DUMP
CR ." Key?" KEY DROP
_type
CR ." Key?" KEY DROP
m1 1000 RESIZE THROW TO m1
_type
m1 FREE
;
test
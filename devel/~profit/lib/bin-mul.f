\ : 3* DUP 2* + ;
\ : 5* DUP 2* 2* + ;
\ : 10* 2* DUP 2* 2* + ;

\ *,  ( u -- )
\ ����������� �������� ������������������ ����
\ ��� ������������ �������� �� �����
\ ���������� ������������ �������� ���������� ����������
\ ����� "�����������" �� ������� ���� �� ���� �����������

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE PRO ~profit/lib/bac4th.f

\ ��������� ����� �� ������������ ��� ������� ������, ������� ��� ���� ������� ������
: factor ( n --> f \ <-- f ) PRO
CELL 8 * \ ���-�� ����� � ������
0 DO DUP 1 AND IF I CONT DROP THEN 2/ LOOP DROP ;
\ 10 factor ����� 1 � 3:
\ 10=2+8=2^1+2^3

: defactor ( f -- n ) 1 SWAP LSHIFT ; \ �������� ����� � ������� ������
\ : r +{ factor DUP defactor }+ . ;
\ �������������� ������������ ������� ������ �����, ����� ������ ���� ��������� � ��������� �������
\ 3434 r

\ : len +{ factor  1 }+ ; \ ���������� ���-�� ���������� ��������
\ 112121 len .

: shift+, ( f -- ) \ ������������� ������������ ������� ������
POSTPONE OVER
           ?DUP IF \ �������� �� 2^0=1 �� �����
LIT,
POSTPONE LSHIFT THEN
POSTPONE + ;

: *, ( u -- )
0 LIT,
START{ factor DUP shift+, }EMERGE
POSTPONE NIP ;

/TEST

$> : r [ 10 *, ] ; 13 r .
REQUIRE SEE lib/ext/disasm.f
$> SEE r

REQUIRE .elapsed ~af/lib/elapse.f

REQUIRE reverse-function ~profit/lib/binary-search.f
: 10/ ( res -- x ) 0 SWAP DUP DROPB reverse-function [ 10 *, ] ;

VARIABLE a
:NONAME
CR ." *,     "
time-reset 100000000 0 DO I [ 112121 *, ] a ! LOOP .elapsed
CR ." *      "
time-reset 100000000 0 DO I 112121 * a ! LOOP .elapsed
CR ." 10/ *, "
time-reset 1000000 0 DO I 10/ a ! LOOP .elapsed
CR ." 10/ *  "
time-reset 1000000 0 DO I 10 / a ! LOOP .elapsed
; DROP \ EXECUTE
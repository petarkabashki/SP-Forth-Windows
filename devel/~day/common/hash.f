\ (c) D. Yakimov [ftech@tula.net]
\ ����� - ���������� �������� ������� ����
\ � ������� �������

: ROL  ( u -- u1 )
[ BASE @ HEX
 C1  C, 45  C, 0  C, 1  C,
BASE ! ] ;

: HASH ( addr u -- u1 )
    SWAP 2DUP
    + SWAP
    ?DO
      I C@ XOR ROL
    LOOP
;

\ examples
\ ��� ���� ����� �������� �� ������� ������ 25 ��������� (� �������)
\ ��� ������ �������������� ����� � ������� �������� ������
(
S" dima" HASH 25 MOD .
S" test" HASH 25 MOD .
S" ����������������" HASH 25 MOD .
)
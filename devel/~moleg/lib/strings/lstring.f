\ 2008-03-21 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ �������� ����� �� ��������� ���������� �����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 S" devel\~mOleg\lib\util\bytes.f" INCLUDED
 REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f
 REQUIRE COMPILE  devel\~moleg\lib\util\compile.f

  \ ������������ ���-�� ����, ��������� ��� ������� ������
 4 CONSTANT SCNT# ( --> const )

\ ��������� �������� �������� ������ u, ������� ��� �����
: SCNT! ( u addr --> # )
        >R 0x80 OVER U> IF 1 LSHIFT R> B! 1 EXIT THEN
           0x4000 OVER U> IF 2 LSHIFT 1 OR R> W! 2 EXIT THEN
        2 LSHIFT 3 OR R> ! 4 ;

\ ������� �������� �������� ������ u � ��� ����� #
: SCNT@ ( addr --> u # )
        @ DUP 1 AND IFNOT 1 RSHIFT 0x7F AND 1 EXIT THEN
       DUP 2 AND IFNOT 2 RSHIFT 0x3FFF AND 2 EXIT THEN
       2 RSHIFT 4 ;

\ ������� ����� ������ � ����� ���� (������)
: COUNT ( addr --> addr u ) DUP SCNT@ ROT + SWAP ;

\ ������������� ����� �� ������� ���������
: SCNT, ( u --> ) HERE SCNT! ALLOT ;

\ ������������� ������ �� ��������� �� ������� ���������
: S", ( asc # --> ) DUP SCNT, S, ;

\ �������� ����� � ������ ������, ������� � ���� �� SLITERAL
: (SLITERAL) ( r: addr --> asc # ) R> COUNT 2DUP + 1 + >R ;

\ �������������� ����������� ������, �������� asc # � ������� �����������
: SLIT, ( asc # --> ) COMPILE (SLITERAL) S", 0 B, ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ CREATE zzz 0 ,
      0x7F zzz SCNT! 1 <> THROW  zzz SCNT@ 1 <> THROW 0x7F <> THROW
      0x3FFF zzz SCNT! 2 <> THROW  zzz SCNT@ 2 <> THROW 0x3FFF <> THROW
      0x1FFFFF zzz SCNT! 4 <> THROW  zzz SCNT@ 4 <> THROW 0x1FFFFF <> THROW
      0xFFFFFFF zzz SCNT! 4 <> THROW  zzz SCNT@ 4 <> THROW 0xFFFFFFF <> THROW
      zzz DUP COUNT 0xFFFFFFF <> THROW CELL - <> THROW
  S" passed" TYPE
}test

\EOF ������ ���������� ����� ���������� ������������� ������� ������ ������
����� 255 ��������, ��� ����, ��� ������, ���������� ����� ������ ��������
��������� ���������, �� ������� �� �������� �� ������ ����� �������.
������� ��, ����� ������� ������� ����� ������ � 4 �����... �� ������� �����
�������� �������...
� ������ ����������� ����� �������� ������ ����� ���������� 1,2,4 ����� - �
����������� �� ����� ������: 127\16383\2^30-1
���������� ����� ������ 2^30-1 = 1073741823 ����

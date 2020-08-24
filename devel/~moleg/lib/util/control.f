\ 19-04-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ����������: ��������� � �����
\ ����� ������������ ���� �� ����� ����������.

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f
 REQUIRE ;stop    devel\~moleg\lib\util\run.f

\ ������ ���������. ��� �� ������ IF ����������� � ������, ���� flag <> 0
: IF ( flag --> )
     STATE @ IFNOT init: THEN
     2 controls +!
     HERE ?BRANCH, >MARK 1 ; IMMEDIATE

\ �������������� ���������. ��� �� else ����������� � ������, ����
\ �������� ��� �� ��������: IF ��� IFNOT ����������.
: ELSE ( --> ) ?COMP HERE BRANCH, >RESOLVE  >MARK 2  ; IMMEDIATE

\ ��������� ������ �����. �� ��� �� ������ BEGIN ���������� ����������
\ � ������ ���������� �����
: BEGIN ( --> )
        STATE @ IFNOT init: THEN
        2 controls +!
        <MARK 3 ; IMMEDIATE

\ ������� ��� ������� �� ����� BEGIN. �������� ����� ���� ������������ �����.
: AGAIN ( --> )
        ?COMP -2 controls +!
        3 = IFNOT -2006 THROW THEN  BRANCH,
        controls @ IFNOT ;stop THEN ; IMMEDIATE

\ ������� �� ����� ����� BEGIN ���� flag <> 0 (���� � ������������)
: UNTIL ( flag --> )
        ?COMP -2 controls +!
        3 = IFNOT -2004 THROW THEN ?BRANCH,
        controls @ IFNOT ;stop THEN ; IMMEDIATE

\ �������� ����� �� �����, ���� flag = 0
\ ������������ ����� BEGIN � REPEAT, ����������� ������ � ����� �����
: WHILE ( flag --> )
        ?COMP 2 controls +!
        HERE ?BRANCH, >MARK 1 2SWAP ; IMMEDIATE

\ �������� ����� �� �����, ���� flag <> 0. ������������ ���������� WHILE
: WHILENOT ( flag --> )
           ?COMP 2 controls +!
           HERE N?BRANCH, >MARK 1 2SWAP ; IMMEDIATE

\ ����������� ������� �� BEGIN. ������������ ������ � BEGIN � WHILE
: REPEAT ( --> )
         ?COMP -4 controls +!
         3 = IFNOT -2005 THROW THEN BRANCH, >RESOLVE
         controls @ IFNOT ;stop THEN ; IMMEDIATE

\ ������ ���������. ������������� ���.
: ifnot ( flag --> )
        STATE @ IFNOT init: THEN
        2 controls +!
        HERE N?BRANCH, >MARK 1 ;

\ ����� ���������. �� ����� �� THEN ��������� ���������� ����� ����������
\ ����� �� �����������, �� ���� ���� ����� IF IFNOT ��� ELSE
: THEN ( --> )
       ?COMP -2 controls +!
       >RESOLVE
       controls @ IFNOT ;stop THEN ; IMMEDIATE

\ ������ ���������. ��� �� ������ IFNOT ����������� � ������, ���� flag = 0
: IFNOT ifnot ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 123 456 FALSE IF DROP ELSE NIP THEN 456 <> THROW
      123 456 TRUE IF DROP ELSE NIP THEN 123 <> THROW
   S" passed" TYPE
}test

\EOF -- ������� ������������� ------------------------------------------------

S" ������ ���� true = " TYPE  1 IF ." true " ELSE ." false " THEN CR
S" ������ ���� false = " TYPE 0 IF ." true " ELSE ." false " THEN CR
: testa IF ." true " ELSE ." false " THEN CR ;

S" ������ ���� true = " TYPE  1 testa
S" ������ ���� false = " TYPE 0 testa

S" ��������� ��� �� 10 �� 0 = " TYPE 10
 BEGIN DUP . DUP WHILE 1 - REPEAT DROP CR

S" ��������� ��� �� 10 �� 1 = " TYPE 10
 BEGIN DUP . 1 - DUP 0= UNTIL DROP CR

S" ��������� ��� �� 9 �� 6 = "  TYPE 10
 BEGIN 1 - DUP WHILE DUP 5 <> WHILE DUP . REPEAT THEN DROP CR

S" ��������� ��� �� 10 �� 6 = " TYPE 10
 BEGIN DUP . 1 - DUP WHILE DUP 5 = UNTIL ELSE THEN DROP CR

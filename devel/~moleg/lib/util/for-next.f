\ 02-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���������� ������ FOR NEXT ��� ���
\ c ������������ ������������� �� ����� ���������� (�.� ��� STATE = 0)

 REQUIRE COMPILE  devel\~moleg\lib\util\compile.f
 REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f
 REQUIRE controls devel\~moleg\lib\util\run.f
 REQUIRE R+       devel\~moleg\lib\util\rstack.f

\ ������ ���� NOW .. SINCE .. TILL\NEXT
: NOW ( u --> )
      STATE @ IFNOT init: THEN
      3 controls +! COMPILE >R ; IMMEDIATE

\ ����� ��� �������� �����
: SINCE ( --> ) <MARK ; IMMEDIATE

\ ������ ����������� ����� �� ���������
: FOR ( n --> ) [COMPILE] NOW [COMPILE] SINCE ; IMMEDIATE

\ ���� ������� ����� �� ����� ���� ������� � �����, ���������� ������ FOR
\ ����� ������� ������� �����, � ����� �� �����.
: NEXT ( --> )
       ?COMP -3 controls +!
       COMPILE R@ -1 LIT, COMPILE R+ N?BRANCH, COMPILE RDROP
       controls @ IFNOT [COMPILE] ;stop THEN ; IMMEDIATE

\ ���������� NEXT ��������� ��������� ����� �� ���������,
\ ������ ���� ������� �� ���������� 1, � �� 0
: TILL ( --> )
       ?COMP -3 controls +!
       -1 LIT, COMPILE R+ COMPILE R@ N?BRANCH, COMPILE RDROP
       controls @ IFNOT [COMPILE] ;stop THEN ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 3 FOR R@ NEXT 0 <> THROW 1 <> THROW 2 <> THROW 3 <> THROW
      3 FOR R@ TILL 1 <> THROW 2 <> THROW 3 <> THROW
      : summa ( [ a .. z ] # --> d ) 1 - NOW S>D SINCE ROT S>D D+ TILL ;
      11 22 33 44 4 summa THROW 110 <> THROW
   S" passed" TYPE
}test

\EOF ������ �������������:
     10 FOR R@ . NEXT
     ������ ������ ��� ����� �� 10 �� 0

     � �� �����, ��� 10 FOR R@ . TILL
     ������ ������ ��� ����� �� 10 �� 1

�������������� ��������:

 NOW ... SINCE ... TILL
 NOW ... SINCE ... NEXT

������:
\ ����� ����� ����� a .. z ����������� #
: summa ( [ a .. z ] # --> d ) 1 - NOW S>D SINCE ROT S>D D+ TILL ;

10 20 30 40 4 summa D.

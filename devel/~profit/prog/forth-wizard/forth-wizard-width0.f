\ ������� ��������� Forth-Wizard'� � ��������� � ������.

REQUIRE FOR ~profit/lib/for-next.f
REQUIRE ��������� ~profit/lib/chartable.f

��������� ��������
������: 1 ." DUP " ;
������: 2 ." SWAP " ;
������: 3 ." OVER " ;
������: 4 ." DROP " ;
������: 5 ." ROT " ;
������: 6 ." >R " ;
������: 7 ." R> " ;

: str ( n -- addr u ) S>D <# #S #> ;

: convertNumber2Operations ( n -- )
str SWAP �������� ���������-������ -��������-���������� ;

: r BASE @
8 BASE !

BASE @
3 ( ���-�� ����. ����� ) 1 DO BASE @ * LOOP
0 DO CR I convertNumber2Operations LOOP
BASE !
;
STARTLOG r
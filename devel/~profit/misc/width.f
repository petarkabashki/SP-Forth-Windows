REQUIRE /TEST ~profit/lib/testing.f
REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE NOT ~profit/lib/logic.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE fetchCell ~profit/lib/fetchwrite.f
REQUIRE iterateBy ~profit/lib/bac4th-iterators.f
REQUIRE arr{ ~profit/lib/bac4th-sequence.f

\ ������� ���������� addr u (������ ��� ����������� �������� � ������)
\ ����� ������ ������� ������������ ����� A[i] (0..max[i]) �� ����������,
\ ������������ ����������� �� i-� ����, ��� ��� ��� ����� �� i-� ���� 
\ ���-�� ����������� ����� max[i]

\ addr u -- ������ 32-������ ��������
\ max -- ������ � ����� �� ������ � ��������
\ ������ ������ ������� addr u ������������� ������ ������� max u
\ max ���������� ������������ �������� � ������ "�������"-������

\ ��������� ������ ����� ���������� ���������� ���:
\ ������� ������ ������������� � ��������. ���� �������� ����� ������
\ �����-���� �������� max, �� ��� ������������� ���� � �������� ������� 
\ � ��������� ������. ���� �������� ������ ������ ��� max �� ���������
\ ����� ���������� ���������.

\ increment ����� ���������� _���_ ��������� ���������� ��� �������� addr u max
\ ����� ��� ������������� ����������� S| CUT: ... -CUT (��. ������)
\ u1 -- ������� ����� ����������, �� ���� "�����������" ������� �� ���� ��������� 
\ ����� ���������� �����, ���� �� ��������� � u
: incrementMinMax ( addr u max --> addr u1 \ <-- addr u1 ) PRO 2DROPB
LOCAL max  max !
LOCAL lastDigit OVER lastDigit !

BEGIN
OVER lastDigit @ OVER - CELL+ CONT 2DROP
START{ max KEEP
S| CUT:
2DUP CELL iterateBy DUP 1+!
DUP lastDigit !
DUP @ max fetchCell = DUP IF OVER 0! THEN ONFALSE
-CUT }EMERGE AGAIN ;


\ ������ ��� ����� �������� ������, � ��� ������ ���� ��� ���� ��������
\ min � max ���������
: increment ( addr u maxConst --> addr u1 \ <-- addr u1 ) PRO
LOCAL max  max !
arr{ DUP  times max @ DROPB }arr DROP ( addr u min )
incrementMinMax CONT ;

/TEST

HERE 10 CELLS DUP ALLOT
: combination LITERAL LITERAL SWAP ;
combination ERASE

:NONAME
START{
S| CUT: combination 5 ( addr u max )
increment ( addr u ) \ addr u -- ������� ����������, u -- ������� �����
2DUP DUMP
DUP 2 CELLS = ONTRUE     \ ���� ����� ���������� �������� ��� 2 "��������"
OVER CELL+ @ 4 = ONTRUE  \ � ���� ������ ������ ����� "4", ��...
-CUT                     \ ��������, �.�. ���������� ���������� ���������
}EMERGE
; EXECUTE
\ Forth-Wizard �� ��������. ������� � �������.
\ ���������� �� http://fforum.winglion.ru/viewtopic.php?t=179
\ � � http://winglion.ru/irc_logs/forth_new/forth20060926_pg1.html

\ ��������� ������� ������������������ �������� ������ ��� ����������
\ ������� ��������� �� ����� ������� �� ���������.
\ ���������� (***) �������� ��������� ���������


REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE concat{ ~profit/lib/bac4th-str.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE >S ~profit/lib/str-stack.f
REQUIRE 2ROT lib/include/double.f


: STACK  PRO  DEPTH 0  ?DO  DEPTH I - 1- PICK  CONT DROP LOOP ;  \ ����� ����

: str ( n -- addr u ) S>D <# #S #> ;

\ ����� ���������� ����� � ���� ������ ���� "1 2 3 " (� �������� ����� *�������* �������� �����)
: STACK-STR PRO concat{ STACK DUP concat{ *> str <*> S"  " <* }concat DUP STR@ }concat CONT ;

\ *** ��� ��� ��������� ����� �� � ���� *** ---------v
: stack-needed ( ... -- f ) |{ STACK-STR DUP STR@ S" 4 1 3 3 " COMPARE 0= }| ;
\ ����� ���� � �� �������� ��������, �� ������ ����� ���� ������ � ��������� ��������� ����� �� ��������


VARIABLE counter
: s. STACK DUP . ;

: opBlock PRO
*>

DEPTH 1 > ONTRUE \ ��� SWAP ����� ��� ������� ��� ��������
S@ S" SWAP" COMPARE ONTRUE \ ��� ���� SWAP �� ����� ������, ������� ���� ����. �������� ���� ���� SWAP �� ��������� ��� ������������
SWAP \ ��������� ���� ��������
S" SWAP" >S \ ������������ �� ��������� ����� ����������
BACK SWAP SDROP TRACKING \ ���������� ��������: ���������� ��������� �� ����� � ������� ������� � ����������
<*>

DEPTH 0 > ONTRUE DUP S" DUP" >S
BACK DROP SDROP TRACKING
<*>

DEPTH 2 > ONTRUE
S> S@ SUNDROP COMPARE 0= S@ S" ROT" COMPARE 0= AND ONFALSE
ROT S" ROT" >S
BACK -ROT SDROP TRACKING
<*>

DEPTH 1 > ONTRUE OVER S" OVER" >S
BACK DROP SDROP TRACKING
<*>

DEPTH 0 > ONTRUE
S@ S" DUP" COMPARE ONTRUE
S@ S" OVER" COMPARE ONTRUE
BDROP S" DROP" >S
BACK SDROP TRACKING
<*>

DEPTH 1 > ONTRUE 2DUP S" 2DUP" >S
BACK 2DROP SDROP TRACKING
<*>

DEPTH 3 > ONTRUE
S@ S" 2SWAP" COMPARE ONTRUE
2SWAP S" 2SWAP" >S
BACK 2SWAP SDROP TRACKING
<*>

DEPTH 5 > ONTRUE
S> S@ SUNDROP COMPARE 0= S@ S" 2ROT" COMPARE 0= AND ONFALSE
2ROT S" 2ROT" >S
BACK 2ROT 2ROT SDROP TRACKING
<*>

DEPTH 3 > ONTRUE
2OVER S" 2OVER" >S
BACK 2DROP SDROP TRACKING
<*>

DEPTH 1 > ONTRUE
S@ S" 2DUP" COMPARE ONTRUE
S@ S" 2OVER" COMPARE ONTRUE
2RESTB 2DROP S" 2DROP" >S
BACK SDROP TRACKING
<* CONT ;

: start-search START{ counter 0! BEGIN counter @ 1+ counter KEEP!
opBlock
stack-needed IF CR S-TYPE THEN
counter @ 5 > UNTIL }EMERGE CR ." ----" ;
\         ^------------------ *** � ��� ������������ ���-�� �������� ***

1 2 3 4 start-search
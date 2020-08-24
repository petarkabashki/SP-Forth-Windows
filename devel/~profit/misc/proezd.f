\ ������ �� �������� ���������� ������� ������������ �� 
\ ����� ��������� ���� � ��������� �������� �������� 
\ ����� �������� �� ���������� ������� ��� ���������� 
\ ��������� �� ����� 100 
\ http://fforum.winglion.ru/viewtopic.php?t=1054 


REQUIRE /STRING lib/include/string.f 
REQUIRE [UNDEFINED] lib/include/tools.f 

REQUIRE *> ~profit/lib/bac4th.f 
[UNDEFINED] KEEP [IF] 
: KEEP   ( addr --> / <-- )    R> SWAP DUP @  2>R EXECUTE 2R> SWAP ! ; 
[THEN] 

REQUIRE FREEB ~profit/lib/bac4th-mem.f 

REQUIRE chartable ~profit/lib/chartable.f 
[UNDEFINED] state-table [IF] 
: state-table ������� ; 
[THEN] 

REQUIRE ENUM ~nn/lib/enum.f 

REQUIRE CLASS ~day/hype3/hype3.f 
REQUIRE CStack ~day/hype3/lib/stack.f 

REQUIRE GENRANDMAX ~ygrek/lib/neilbawd/mersenne.f \ Mersenne twister - high-speed and quality RNG 
: GENRANDMINMAX ( min max -- r ) TUCK - GENRANDMAX + ; 

WINAPI: GetTickCount KERNEL32.DLL 

CStack SUBCLASS CStackI 
   CELL PROPERTY runner \ ������� ����� 

   \ ��-���� ��� � ��������� �� ���������� (����������� count@) 
   \ ��� ���������� ������������� ���������� ����� ������� ���� 
   \ ���� �������� count ��� ������ ����� � ���� 
   CStack NEW s 
   s count@  1 s push  s count@ - ABS 
   CONSTANT countStep \ ��� ���������� �������� count 
   s dispose 

   : depth ( -- n ) SUPER count@ countStep / 1- ; 

   \ ����� ������� ����� 
   : tos' ( -- addr ) SUPER data@ depth CELLS + ; 

   \ ����������� � ������� �����, ������� �� ��� ��� 
   : prepare-fetch ( -- )   SUPER data@ runner! ; 
   \ �������� �� �� �������? 
   : eof ( -- f )    runner@ tos' > ; 
   \ ����� �������� �������� ��� �� ���: 
   : fetch ( -- n )    runner@ @  CELL runner +! ; 
;CLASS 

( 
CStackI NEW s 
1 s push 
2 s push 
3 s push 
\ 1 s count! 
\ s prepare-fetch 
\ s fetch . 
\ s fetch . 
\ s fetch . \EOF \ ) 

CStackI NEW ops \ ���� �������� 
CStackI NEW nums \ ���� ����� 


VARIABLE depth \ ���������� ������� ����� 

0 
ENUM lit \ ������ �����, ������ LITERAL 
ENUM plus 
ENUM minus 
ENUM mult 
ENUM divi 
ENUM neg 
ENUM fact 
( ops-num ) 

DUP state-table op-execute 
lit   asc: nums fetch ; 
plus  asc: + ; 
minus asc: - ; 
mult  asc: * ; 
divi  asc: / ; 
neg   asc: NEGATE ; 
fact  asc: DUP 2 < IF DROP 1 EXIT THEN 1 SWAP 1+ 1 DO I * LOOP ; \ ��������� 

DUP state-table op-print 
lit   asc: nums fetch . ; 
plus  asc: ." + " ; 
minus asc: ." - " ; 
mult  asc: ." * " ; 
divi  asc: ." / " ; 
neg   asc: ." ~ " ; 
fact  asc: ." fact " ; 

DROP 

\ �������� �� ������� ������������������ ���������� 
: ops=> ( --> op \ <-- ) PRO 
nums prepare-fetch  ops prepare-fetch 
BEGIN ops eof 0= WHILE 
ops fetch CONT REPEAT ; 


\ ����������� ������� ������������������ ���������� 
: ops. ops=> op-print ; 

\ ��������� ������� ������������������ ���������� 
: ops-execute ops=> op-execute ; 

\ ���� ������� ��� ����� ���������� �� ����� ����� ���������� 
\ ������� ������������������ ���������� (������� �������� � ops) 
\ ����� ���������� �� ��������� ������������ ���������� depth ������� 
\ ������ �������� ������� ����� ����� ���������� ������������������ 
: get-two ( -- n1 n2 ) 
ops-execute 2DUP 2>R \ ��������� � ����� ��� ������� ����� 
depth @ 0 DO DROP LOOP \ ������� ��� ����� ������ ops-execute 
2R> ; 

\ ���� ������� ����� ���������� �� ����� ����� ���������� 
\ ������� ������������������ ���������� 
: get-one ( -- n ) 
ops top lit = IF nums top ELSE get-two NIP THEN ; 



\ ����� �� ��������� �������� ������� � ������� ��������� ����� ����������� 
\ ����� ���������� ������� ������������������? 
: is-dividable ( -- f ) get-two DUP 0<> IF MOD 0= ELSE 2DROP FALSE THEN ; 

\ �������� �����, ������� ������ ����� �� ����� ������� ������������������ 
100 VALUE terminal 

\ �������� ����� �������� (� �������� ���������) 
: op-bpush ( op -- ) PRO ops count KEEP ops push CONT ; 

\ �������� ���������� �������� VARIABLE-���������� 
: B+! ( n addr -- ) PRO DUP KEEP +! CONT ; 

\ ��������, ������������ ��� ���������� ���� ��������� � ������ 
\ addr u � �������� 
\ ���������� ��������� � �������� ops � nums 
: comb ( addr u --> \ <-- ) PRO 
BACK 2DROP TRACKING 
depth 0! 
BEGIN 

*> \ ������������ 1: ������ ����� �� ������ addr u 

   DUP 0<> ONTRUE \ ������ ������ ���� �������� 
    *> \ ���-������������ 1.1 -- ������ ����� ���������� ��� ��������� 
      OVER C@ [CHAR] 0 - \ ���� ����� 
      nums count KEEP nums push \ ���������� � � ���� ����� (� �������� ���������) 
      lit op-bpush \ ���������� �������� lit 
      1 depth B+! \ ����� ����� ����������� ������� ����� 
   <*> \ ���-������������ 1.2 -- ������ ����� "������������" � ��� ������������ 
      ops count@ 0<> ONTRUE ops top lit = ONTRUE \ �������� �� ��������� �������� -- lit 
      OVER C@ [CHAR] 0 - \ ���� ����� 
      nums tos' KEEP \ ��������� ������ �������� ������� ����� ����� 
      nums pop 10 * + nums push \ ��������� �� ������� ����� ����� ����� ������ -- ������ ����� 
   <* 

   1 /STRING \ �������� ������ �� ���� ������ 
   BACK -1 /STRING TRACKING \ �������� �������� -- ����� � �������� ������� 

<*> \ ������������ 2: ������� � ����� ��������� 
   depth @ 0 > ONTRUE  \ ����������� ������� ������������ ������� � ����� ��������� -- �������� ���� 
    *> 
      EXIT \ <-- ������������� ��-��������� -- �������� ������ ���������������... 
      ops top neg <> ONTRUE \ ���������� �������� �� ������ ���� neg 
      neg op-bpush 
   <*> 
      EXIT \ <-- ������������� ��-��������� -- ������� ������ ����������... 
      ops top fact <> ONTRUE \ ����� ������ ���������� �� fact'�� 
      get-one 0 14 WITHIN ONTRUE \ ������� ����������� ���������� �� 2^32 -- [0;13]
      fact op-bpush 
   <* 

<*> \ ������������ 3: ������� � ����� ���������� 
   depth @ 1 > ONTRUE \ ����������� ������� ������������ ������� � ����� ���������� -- ����������� ������� ����� 
    *> 
      plus op-bpush 
   <*> 
      minus op-bpush 
   <*> 
      mult op-bpush 
   <*> 
      \ �������� ������������ �������� �������: �������� � ������� �� ������� ������ ���� ���������� 
      is-dividable ONTRUE 
      divi op-bpush 
   <* 

   -1 depth B+! \ ���������� ������� ����� (� �������� ���������) 
<* 
DUP 0= \ ����� ������ addr u ������� � ����� 
depth @ 1 = AND \ � �� ����� ������ ���� ��������... 
IF 
ops-execute \ ��������� ������������������ 
terminal = \ � ��������� � �� ��������� 100 
NEGATE ( 0|1 ) 0 ?DO CONT LOOP \ ���� ������, �� ������ "�����" 
\ ^-- ���������� ����� ����� SPF 4.18, �� ���� ������ �������� 
THEN 

\ ops depth 15 > ONFALSE \ ���������� ������� �������� 20-�� ������ 
AGAIN \ ��������� ���� �� ����� ��������� ��� ������������ � �� ���������� 
; 

\ ����������� ��� �������� �������� �������� � ������ �� ����� n ���������� � ���������� � 100 
: print-combs ( n -- ) 
S>D <# #S #> ( addr u )
TUCK HEAP-COPY FREEB SWAP
CR CR ." -----" 2DUP TYPE ." -----" 
START{ 
comb CR ops. }EMERGE 
CR ." ----------------" ; 

: stack-ops-galore ( n -- ) 
GetTickCount SGENRAND 
0 DO 
999999 100000 GENRANDMINMAX print-combs 
LOOP ; 

10 stack-ops-galore 
\ 200100 print-combs
\ 123456 print-combs
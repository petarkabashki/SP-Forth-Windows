\ ��������� ��� �������� ����������� �������.
\ ������� ������� �������, ������� ������������� � ����. 
\ ��� ������ ������� �������� ������� � ���� ���������.

\ S" 2 DUP * ." axt ( xt ) -- ������ �� ���� ����� ����
\ ������� ������������ ���� ������������� ��� ����������
\ ������

\ ������ ����� ������� ������� ���� ���������� �������
\ ������ DESTROY-VC (~profit/lib/compile2Heap.f)

\ ����� ������� ������� ���� �������������, ��� ������ 
\ �� �������� ����������� (��� ��� �������� "�� �������"
\ bac4th-������) ����� ������������ axt=>
\ S" 2 DUP * ." axt=> ( xt )

\ �������� ����� ������� ���� ������ � ��������� �����
\ ����� ������������ ������ ~ac/lib/str5.f
\ (������ �� ����� ������������� ������ �����):
\ " 2 DUP
\ * . " straxt=> ( xt )

\ ��� ���� � ������������ ������� ���� ���� ����� ����������������
\ ���� �����, ������� �� �� ����� ��� �������� ������������� ��������
\ IMMEDIATE-������� ��������� LITERAL , ��� ����� ������������ ���
\ �������� ����� �� ����� � ������������� �������:
\ 4 2 1 S" LITERAL LITERAL + LITERAL * ." axt EXECUTE
\ ���������� ��� "1 2 + 4 *" � �������� ���, ����������: "12"

\ ��� �� ����� ������� �������� � ����� ������������� ������� [ � ] :
\ ' . S" 3 0 DO I [ COMPILE, ] LOOP " axt EXECUTE
\ ������� 0 1 2
\ �������� ��� ��������� ����� �� ������ ������� ��������� ( ' . )
\ [ COMPILE, ] ������������� xt ������ ������������ �������

\ ����� �������� ��������, ������ "���������", ������������
\ ���������� ������ ������ 3.2.3.2 ANS-94:

\ "���� ������-����������, �����, �� �� �����������, ��������� 
\ ������������ � ����������. ���� �� ����������, �� ����� ����,
\ �� �� �����������, ���������� � �������������� ����� ������.
\ ������ ����� ������-���������� -- ������������  �����������.
\ ��� ��� ���� ������-����������  ����� ���� ���������� � 
\ �������������� ����� ������, ��������, ���������� �� ���� 
\ ������ ���������� ��� �������� ����� ��������� ���������
\ �� ���� ������-����������, � �������� ����������� �� �������� 
\ ��������� ����� ������-����������."

\ REQUIRE MemReport ~day/lib/memreport.f

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE VC-COMPILED ~profit/lib/compile2Heap.f
REQUIRE A_BEGIN ~mak/LIB/A_IF.F
REQUIRE STR@ ~ac/lib/str5.f

MODULE: bac4th-closures

\ ���������� ��������� ���������� � ��������� control-flow stack
: BEGIN [COMPILE] A_BEGIN ; IMMEDIATE
: WHILE	[COMPILE] A_WHILE ; IMMEDIATE
: AHEAD	[COMPILE] A_AHEAD ; IMMEDIATE
: IF 	[COMPILE] A_IF ; IMMEDIATE
: ELSE	[COMPILE] A_ELSE ; IMMEDIATE
: THEN	[COMPILE] A_THEN ; IMMEDIATE
: AGAIN	[COMPILE] A_AGAIN ; IMMEDIATE
: REPEAT [COMPILE] A_REPEAT ; IMMEDIATE
: UNTIL [COMPILE] A_UNTIL ; IMMEDIATE

\ ������ ��������� ��������� ������ � ���� ������,
\ ����� ��� ���� ������������ ��������� control-flow stack
: DO    CS-SP>< POSTPONE DO    CS-SP>< ; IMMEDIATE
: ?DO   CS-SP>< POSTPONE ?DO   CS-SP>< ; IMMEDIATE
: LOOP  CS-SP>< POSTPONE LOOP  CS-SP>< ; IMMEDIATE
: +LOOP CS-SP>< POSTPONE +LOOP CS-SP>< ; IMMEDIATE

EXPORT

: axt ( addr u -- xt )
CREATE-VC >R \ ������ ����������� ��������
ALSO bac4th-closures \ ���������� ������� � ������ ����������� ����������
R@ VC-COMPILED \ ����������� ������ � ����������� ��������
PREVIOUS \ ��������� ��� �� ��������� ����������
R@ VC-RET, \ ������ ������� ������
R> \ ��������� ����������� ����� ������ ���������
;

: axt=> ( addr u --> xt \ <-- ) PRO
axt \ ����������� ������, ���� ����������� ����� ����
BACK DESTROY-VC TRACKING RESTB \ �� ��������� ��������� �������� ��������
CONT \ � ������ ��� ������
;

\ �� �� ����� ��� � compiledCode , �� � ������������� �������� �� ~ac/lib/str5.f
\ ��� ��������� ������ ��� � ��������� �����
\ ������� �� ���� ������ ����� ����� ������������� �������������
: straxt=> ( s --> xt \ <-- ) PRO
START{ BACK STRFREE TRACKING RESTB STR@ axt }EMERGE
BACK DESTROY-VC TRACKING RESTB CONT ;

: compiledCode ( addr u --> xt \ <-- ) \ ������� ��� axt=>
RUSH> axt=> ;

: STRcompiledCode  ( s --> xt \ <-- ) RUSH> straxt=> ;

;MODULE

/TEST
REQUIRE TYPE>STR ~ygrek/lib/typestr.f
REQUIRE TESTCASES ~ygrek/lib/testcase.f
REQUIRE MemReport ~day/lib/memreport.f
\ REQUIRE SEE lib/ext/disasm.f

TESTCASES bac4th-closures

\ ��������� ������ �� ����� ������ ������������� ����
:NONAME 4 2 1 S" LITERAL LITERAL + LITERAL * ." axt=> EXECUTE ; TYPE>STR
DUP STR@ S" 12 " TEST-ARRAY STRFREE

\ ��������� ������ �� ����� ������ ����� ������������� ����
:NONAME 23 100 5 S" 0 BEGIN DUP LITERAL < WHILE LITERAL LITERAL + . 1+ REPEAT DROP " axt=> EXECUTE ; TYPE>STR
DUP STR@ S" 123 123 123 123 123 " TEST-ARRAY STRFREE

\ ��������� ������ �� ����� ������ ����� ������������� ����
:NONAME 11 S" 3 0 DO LITERAL . LOOP" axt=> EXECUTE ;  TYPE>STR
DUP STR@ S" 11 11 11 " TEST-ARRAY STRFREE

\ ��������� ��� ������ �������, "������" ���������
:NONAME ['] . S" 3 0 DO I [ COMPILE, ] LOOP " axt=> EXECUTE ; TYPE>STR
DUP STR@ S" 0 1 2 " TEST-ARRAY STRFREE

\ ������ ���� ����� ������ � straxt=>

\ ��������� ������ �� ����� ������ ������������� ����
:NONAME 4 2 1 "
LITERAL LITERAL + LITERAL * ." straxt=> EXECUTE ; TYPE>STR
DUP STR@ S" 12 " TEST-ARRAY STRFREE

\ ��������� ������ �� ����� ������ ����� ������������� ����
:NONAME 23 100 5 "
0 BEGIN
DUP LITERAL < WHILE
LITERAL LITERAL + . 1+ REPEAT
DROP " straxt=> EXECUTE ; TYPE>STR
DUP STR@ S" 123 123 123 123 123 " TEST-ARRAY STRFREE

\ ��������� ������ �� ����� ������ ����� ������������� ����
:NONAME 11 "
3 0 DO
LITERAL .
LOOP" straxt=> EXECUTE ;  TYPE>STR
DUP STR@ S" 11 11 11 " TEST-ARRAY STRFREE

\ ��������� ��� ������ �������, "������" ���������
:NONAME ['] . "
3 0 DO
I [ COMPILE, ]
LOOP " straxt=> EXECUTE ; TYPE>STR
DUP STR@ S" 0 1 2 " TEST-ARRAY STRFREE

(( countMem -> 0 0 ))

END-TESTCASES
\ ��� �� ���� ������.

\ ��������� ������: ����������� � EVALUATE ����� 
\ ������������� (������ ��������������) ��� 
\ �������� ���. ���� � ������ ������ �� ������

REQUIRE KEEP ~profit/lib/bac4th.f
REQUIRE /STRING lib/include/string.f
REQUIRE NextNFA lib/ext/vocs.f
REQUIRE SEE lib/ext/disasm.f
REQUIRE CODE lib/ext/spf-asm-tmp.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE TYPE>STR ~ygrek/lib/typestr.f
REQUIRE replace-str- ~pinka/samples/2005/lib/replace-str.f

"" ->VARIABLE code-collector

\ CALL 11111 ( word ) --> CALL ' word
\ ��� ����������� �����:

\ CALL ' _CLITERAL-CODE
\ ����. �����.
\ S" str" S", 0 C, (����� ������� ������������� ��� �������, ��� ������ ���������� ���� ��������� ������������ ����-���: 3 C,  CHAR s C, CHAR t C, CHAR r C, 0 C, )
\ ����. �����. 2

\ �������� �������� � �������� ����� ������������� ����� C, 
\ (��� ���� ������ ���� ���������� ����� �����, �� ���� ������ ��������� ����������, ������ �� �������)


: r ( xt -- )
NextWord
LAMBDA{
." CODE " TYPE CR
DUP DISASSEMBLER::FIND-REST-END SWAP ( xt-end xt )
BEGIN 
DISASSEMBLER::['] INST TYPE>STR DUP STR@ 2DUP 0
DO DUP C@ 9 = IF I LEAVE THEN 1 CHARS + LOOP NIP
/STRING TYPE CR STRFREE
2DUP < UNTIL 2DROP
." END-CODE" } TYPE>STR
DUP " FC [" " -4 [" replace-str-
DUP " F8 [" " -8 [" replace-str-
\ DUP STR@ EVALUATE
DUP STR@ TYPE
STRFREE ;

: s 10 0 DO 1 . LOOP ;

\ ' s DISASSEMBLER::INST
' s r b
\ SEE b
CODE b2
CALL ' _CLITERAL-CODE
RET
S" bubu" S", 0 C,
\ 0 HERE 1- C!

END-CODE
SEE b2
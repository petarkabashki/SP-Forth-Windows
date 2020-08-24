\ ��������� �����������. ��������� ��������� �������� �� ��������� (���������).
\ ����������� ����� ������������� ������� � �������������� ������ ��� ��� ����.
\ ��� �������� ��������� �������� �������� (HERE) ��������� �� ����������.

\ � ���������� �� ��������:
\ 1. ����� ������� ����� �� ������� (��������, � colorForth'�, ��� ��� ���� 
\ ������� ���������, ����� �� ������� �������� ����� (!) ���������� 
\ �������� ��������).
\ 2. ������������ ��������� ��������� �������� (��������, ��������� ����������
\ ���� �����, ���� �����).
\ 3. ����� ����� "��������" ��������� �������� �� ��������������� �����������
\ ����.
\ 4. ����������, ��������� ����������� ��� �������� ������ (������ ��. �����). 
\ �� ����� ����, ��� �� ��� �� � �������, �� ��� ������� �������� 
\ ��������������� (�������) ������� �������� ����� -- ����� ���������.
\ 5. ����������� �������������� � ������ �������� ������� (��. ����� 
\ FORGET-ALL � FORGET). ��� ���� "����������" ������ �����, HERE � ������ 
\ ���������������� � ��������� �� ���������.

\ �������� (TODO):
\ ��������������� � IMMEDIATE � VOC ������ �����, ��. ��������� ������� 
\ SHEADER .
\ �����, ���� ���������� ���� � ���� �� ��������� ������� SPF ����� ����� ���
\ ������� ���������������?

\ CREATE ... DOES> �� ��������.

\ ����� �� �������� ������ �� ������ (� ����� ���?), ���:
\ prevWord lastWord ?VOC CAR CDR

\ REQUIRE SEE lib/ext/disasm.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE HASH@ ~pinka/lib/hash-table.f
REQUIRE INVOKE ~ac/lib/ns/ns.f
REQUIRE __ ~profit/lib/cellfield.f
REQUIRE /TEST ~profit/lib/testing.f

MODULE: cascadedColons

0
__ lastWord \ ��������� ��� ������� �� ������
__ hash
CONSTANT vocSize

\ ��������� ������
0
__ prevWord ( word-id -- LFA )
__ flag     ( word-id -- FFA )
__ xt       ( word-id -- CFA )
CONSTANT wordSize

EXPORT

<<: FORTH cascaded

\ ������ ��������� ������
: SHEADER ( addr u -- )
\ CR ." SHEADER: " 2DUP TYPE
GET-CURRENT OBJ-DATA@
?DUP 0= IF big-hash DUP GET-CURRENT OBJ-DATA! THEN \ ���� ����� -- ������
( addr u h ) ROT wordSize SWAP 2SWAP ( wordSize addr u h )
HASH!R
DUP prevWord 0!
DUP flag 0!
HERE OVER xt !
flag 0 NAME>F - LAST ! \ �������������� ��� ��������� ��������� SPF
\ ����� IMMEDIATE � VOC ������ �� ��� ����
\ ��� ���� � ���������� LAST ����������� ��� ������ ������ �� NFA
;

: SEARCH-WORDLIST ( c-addr u oid -- 0 | xt 1 | xt -1 )
\ >R 2DUP CR TYPE R>
OBJ-DATA@ DUP IF HASH@R DUP IF DUP xt @ SWAP flag @ &IMMEDIATE AND IF 1 ELSE -1 THEN THEN ELSE NIP NIP THEN ;

>> CONSTANT cascaded-wl

: NO-WORDS ( wid -- f ) OBJ-DATA@ 0= ;

: FORGET-ALL ( wid -- )
\ "������" ��� ����� � ������� wid
\ �������� �� �� ��� ������� ��������� �� ��������
DUP NO-WORDS IF DROP EXIT THEN
  DUP  OBJ-DATA@ del-hash
0 SWAP OBJ-DATA! ;

: FORGET ( "word" -- ) NextWord
GET-CURRENT NO-WORDS IF 2DROP EXIT THEN
GET-CURRENT OBJ-DATA@ -HASH ;
\ ����� �� �������� ������ �����, "������" ��� (� ������ ���)
\ � ������� ��������� ������� (����� ��, ��� ��������)

;MODULE

MODULE: dontHide \ �� ������� (HIDE SMUDGE) ��� ������������� � ������ ������ �����

:NONAME HEADER ] ;

:NONAME ( -- )
  RET, [COMPILE] [
  ClearJpBuff
  0 TO LAST-NON
;

->VECT ; IMMEDIATE \ ���������� ��� ����� ����� ������� ����� �����
->VECT : IMMEDIATE \ ����� �� ��������� � ��� �����

;MODULE

/TEST

ALSO dontHide
ALSO cascaded NEW: casc DEFINITIONS

: 2*2. 2
: 2*. 2 *
: dot . ; IMMEDIATE

\ SEE 2*2.
$> 2*2.
$> 5 2*.
$> 12 dot
$> 12345 : r dot ;

$> 10 CONSTANT ten ten .

\ $> : var CREATE DOES> DROP ." bum" ; var b b

\ ���� FORGET �������� ��������� ��� ����� ����
\                   v-------------|
$> FORGET dot  2*2. ' dot

\ ������ ������ ��� ����� �� �������:
$> ' casc >BODY @ FORGET-ALL ' ten
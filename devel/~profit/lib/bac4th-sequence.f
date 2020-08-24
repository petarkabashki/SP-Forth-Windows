\ �����:
\ seq{ ... }seq -- ��������� ������-��������� � ���������������� ��������
\ �
\ arr{ ... }arr -- ��������� �������

\ {#} ( list-xt -- u ) ����� ����� ������-���������.

\ {seq} ( -- list-xt ) ������ �������������� ������, ������������� � ������ 
\ ������.

\ {seq} {#} ����� �������� ������� ����� ��������, ������ �� ����.

\ seq{ ... }seq ��������� �� ����� xt -- ����� ������� ����, ������� ����������
\ �� �� �������� ��� � ��������� ����� �������� seq{ ... }seq
\ �� ����, ��������� ���������� ��������� ��� �� ����������, "������������"
\ � ������, �������� ���������������� ���������.

\ ��� ������, �� ����, ������ ��������� �������:

\ ��� ���������� ������� �������� ��������� ������ (n-�) ��� ��� ��������
\ ��� ��������� ��� �� ������ �� �����, ����� �������� ���������� � ������
\ ��� �������� � �����-������ ���������. ���������������� ��������, �� ����,
\ � ����� ����� ������������� ����������. ������ ����������� ���������, � 
\ ���� ������� ����.

\ ����� ��, ���� �������� �����-����� ������� �� � �������� �������������
\ ���������� ���� ��������� ����� ��������� ������������ �������. ������:
\ 1 iterator ( 1 ... x )
\ ���� ���� �� ����� ��� iterator ���������� �� ����� ������ ���� ��������
\ �� ����� ����� ���� ��� ����� ���� ������������� �������� ���������� 
\ ���������, � ������� ������� � ������� �� ��������� �� ����������
\ ������ ���������� iterator , �� �� �����.
\ � ������ �� ����������� ��������� ������� ������������� �������� �� �����
\ �� ����� ��� ��� ���������������� �������� ����� ���������� �� ����� ������
\ ���������� ���������� ��������.

\ ����� ����, ��� ����������� ����� ������� ����������� ���������� ��������
\ ��������� ����� ��������, �������� ���������� �� �������� � ���� ������-
\ ��������, ����� �� ����������� � �.�. (��. ����� union , cross ).

\ ������� �������� ��� ��� ������������ ��������� �� �������� ������������
\ ����������� ������, ��� ��� ��������� ������ ���������������� ������ � ������
\ �� ������ ��� � ������������� ������ �� ��������.

\ ��� �������, ����� ������������ �� ��� ������������� ����, ����� ���������
\ ������ ��������� ����� ������� ���-�� ��������� � ���� ���������, ����� 
\ �� ������ �������� ������� ����. ��� �������� arr{ ... }arr �������
\ ������� �������� �������-����������.

\ arr{ ... }arr ��������� �� ����� ����� ������ ������� � ��� ����� (� ������).
\ ������ ������������ �� ������� �������� ���������� �� ����� ����� ������� 
\ ������ ���������� ����� ��������. ��� ������ ���� ������ ���������.

\ ��� ������ seq{ }seq ��� � ������ arr{ }arr �������� ����� {seq} �������
\ ����� ������������� �������� ������������ ������. {seq} ������ �����
\ ������-�������� (������ arr{ }arr -- ����).

\ TODO: �� ������ ������ ���������� {seq} ��������� ������������ ���
\ ������ ��������������� ������ ������ arr/seq, ���� �� ��������
\ ����������� ��� � ������ ���������.

\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE __ ~profit/lib/cellfield.f
REQUIRE writeCell ~profit/lib/fetchWrite.f
REQUIRE (: ~yz/lib/inline.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE CREATE-VC ~profit/lib/compile2Heap.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
REQUIRE PageSize ~profit/lib/get-system-info.f

MODULE: bac4th-sequence

0
1 -- rlit
__ handle  \ ���� ������������ ��������� (�� ������������ ������������ ����� � ����������� �����)
1 -- ret
__ALIGN
__ counter \ ������� ���-�� �������� �����
CONSTANT seq-struct \ �������������� ���������

:NONAME  ( -- seq ) \ ��������� ������������� seq{
seq-struct ALLOCATE THROW >R
(: RDROP ;) PageSize CELL - _CREATE-VC
R@ handle ! R@ counter 0!
0x68 R@ rlit C!  0xC3 R@ ret C!
R> ; CONSTANT (seq{)

:NONAME PRO @
BACK
DUP handle @ DESTROY-VC \ ������� ��������������� ���
FREE THROW \ ������� � �������������� ���������
TRACKING RESTB
CONT \ ������ �����

; CONSTANT (}seq) \ ��������� ������ }seq

EXPORT

: +VC ( x seq -- ) VC-
LIT,
R@ENTER,
POSTPONE DROP ;

\ ����� ����������� ������ ��� ��������� ���� ����� �������-����������
: seq{ ( -- ) ?COMP (seq{) COMPILE, agg{ ; IMMEDIATE

\ ����������� ������ ��� ��������� �������-���������� ��������� ��������
: }seq ( n -- list-xt ) ?COMP (: @
DUP counter 1+!
OVER SWAP
handle @ +VC ;) (}seq) }agg ; IMMEDIATE

\ ����������� ������ ��� ������� ��������
: }seq2 ( n -- list-xt ) ?COMP (: @
DUP counter 1+!
handle @ VC-
2DUP DLIT,
R@ENTER, \ POSTPONE CONT
POSTPONE 2DROP
;) (}seq) }agg ; IMMEDIATE

\ ����������� ������ ��� ������� ��������
: }seq3 ( n -- list-xt ) ?COMP (: @
DUP counter 1+!
handle @ VC-
ROT DUP LIT, -ROT 2DUP DLIT,
R@ENTER, \ POSTPONE CONT
POSTPONE 2DROP POSTPONE DROP
;) (}seq) }agg ; IMMEDIATE

\ ����������� ������ ��� ��������� ��������
: }seq4 ( n -- list-xt ) ?COMP (: @
DUP counter 1+!
handle @ VC-
2OVER DLIT, 2DUP DLIT,
R@ENTER, \ POSTPONE CONT 
POSTPONE 2DROP POSTPONE 2DROP
;) (}seq) }agg ; IMMEDIATE

: {seq} ( -- list-xt ) ?COMP (: ;) {agg} ; IMMEDIATE

: {#} ( list-xt -- u ) counter @ ;

\ ������� �������� ������-��������� � ���������������� ������ � ������
: seq>arr ( list-xt -- addr u ) LOCAL arr LOCAL runner
DUP {#} CELLS ALLOCATE THROW DUP arr ! runner !
START{ ( list-xt ) ENTER
DUP runner writeCell }EMERGE
arr @ runner @ OVER - ;

: arr{
(: 2 CELLS ALLOCATE THROW ;) COMPILE,
agg{
[COMPILE] seq{
; IMMEDIATE

: }arr
[COMPILE] }seq
(: @ SWAP seq>arr ROT 2! ;)
(: PRO @ DUP 2@ ROT FREE THROW SWAP FREEB SWAP CONT ;)
}agg ; IMMEDIATE

;MODULE

/TEST
: INTSTO PRO 0 DO I CONT DROP LOOP ;
: INTSFROMTO PRO SWAP 1+ SWAP DO I CONT DROP LOOP ;

: list. ( list-xt -- ) ENTER DUP . ;

: list-xt-generated seq{ 5 INTSTO }seq ( list-xt ) DUP . DUP {#} ." length: " . CR ." execute:" list. ;
$> list-xt-generated

: intermediate seq{ 5 INTSTO  CR {seq} list.  }seq ( xt ) ENTER ;
$> intermediate

: a PRO \ ������ �����
1 CONT DROP
2 CONT DROP
4 CONT DROP
5 CONT DROP
3 CONT DROP ;

: b PRO \ ��� ���� ������ �����
7 CONT DROP
4 CONT DROP 
6 CONT DROP ;

: number= ( a b -- a b f ) 2DUP = ;

: union PRO *> a <*> b <* CONT ; \ ����������� (������ -- ������������)
: cross PRO a b number= ONTRUE CONT ; \ �����������
: subtr PRO a S| NOT: b number= ONTRUE -NOT CONT ; \ ���������? (����� ��� ���������)

: 4ops
START{ CR ." a="   a     DUP . }EMERGE
START{ CR ." b="   b     DUP . }EMERGE
START{ CR ." a+b=" union DUP . }EMERGE
START{ CR ." axb=" cross DUP . }EMERGE
START{ CR ." a-b=" subtr DUP . }EMERGE ;
CR $> 4ops

 \ �����������, �� ������ ����� �������� ���������, ������ ����� ��������� ���� ���������� 
: union ( a b -- a+b ) PRO LOCAL b b ! LOCAL a a !
 *> a @ ENTER
<*> b @ ENTER
<*  CONT ;

: cross ( a b f -- axb ) PRO LOCAL f f ! LOCAL b b ! LOCAL a a !
a @ ENTER b @ ENTER f @ ENTER ONTRUE CONT ;
\ �������� ��������� ���� �������� ������� � �������� ����, ������ �� ������ 
\ ����� ��� ���� �����������: f ( ... -- 0|-1 )
: cross-number ( a b -- axb ) PRO ['] number=  cross CONT ;

: not-in ( a b f --> \ <-- ) PRO LOCAL f f ! LOCAL b b !
S| NOT: b @ ENTER f @ ENTER ONTRUE -NOT CONT ;

: subtr ( a b f -- a-b ) PRO LOCAL f f ! LOCAL b b !
ENTER b @ f @ not-in CONT ;

: subtr-number PRO ['] number= subtr CONT ;

: head ( a -- ... ) CUT: ENTER -CUT ;
: tail ( a -- ... a' ) CUT: ENTER R@ -CUT ;

: seq4ops LOCAL 0..4 LOCAL 2..5

seq{ 4 INTSTO }seq 0..4 ! \ �� 0 �� 4-�
seq{ 5 2 INTSFROMTO }seq 2..5 ! \ "�� ���� �� ����" (�)

CR ." [0..4]=" 0..4 @ list.
CR ." [2..5]=" 2..5 @ list.

CR ." head[0..4]=" 0..4 @ head . \ ������� ������ ����, ������ ��������
CR ." tail[0..4]=" 0..4 @ tail list.

START{
seq{ 0..4 @  2..5 @ union }seq
CR ." [0..4]+[2..5]="
list. }EMERGE

START{
seq{ 0..4 @  2..5 @ cross-number }seq
CR ." [0..4]x[2..5]="
list. }EMERGE

START{ seq{ 0..4 @  2..5 @ subtr-number }seq
CR ." [0..4]-[2..5]=" ENTER DUP . }EMERGE

START{ seq{
seq{ 0..4 @  2..5 @ cross-number }seq
seq{ 0..4 @  2..5 @ subtr-number }seq
union }seq
CR ." [0..4]x[2..5] + [0..4]-[2..5]=" list. }EMERGE ;
$> seq4ops

REQUIRE split-patch ~profit/lib/bac4th-str.f
REQUIRE COMPARE-U ~ac/lib/string/compare-u.f

:NONAME ( d1 d2 -- d1 d2 f ) 2OVER 2OVER COMPARE-U 0= ; CONSTANT str=

: cross-str PRO str= cross CONT ;

: commonWord ( addr1 u1 addr2 u2 -- )
seq{ BL byChar split-patch }seq2 ( list-xt1 ) -ROT
seq{ BL byChar split-patch }seq2 ( list-xt1 list-xt2 )
cross-str 2DUP TYPE SPACE ;

CR $> S" peach cherry lemon kiwi feyhoa" S" kiwi apple lemon orange" commonWord
\ ������ �����: kiwi lemon
: dump-arr arr{ a }arr DUMP ;
CR $> dump-arr

: uniq  POSTPONE {seq} POSTPONE SWAP POSTPONE not-in ; IMMEDIATE

: uniqueSeq seq{
BL byChar split-patch \ ����� �� �����-�������
str= uniq
}seq2 ENTER 2DUP CR TYPE ;

$> S" kiwi apple lemon apple lemon kiwi orange" uniqueSeq
\ MemReport

REQUIRE iterateBy ~profit/lib/bac4th-iterators.f

: TAKE-TWO PRO *> <*> BSWAP <* CONT ;

: arr-test arr{
BL byChar split-patch \ ����� �� �����-�������
( addr u )
TAKE-TWO          \ "��������" �������, �� ����: �������� }arr ��� ����� �� �����
}arr
( addr u )   \ ������ � ��� ������ ������� ��������
2 CELLS iterateBy \ ������ �� ���� ������, ������ �� ��� ������ �����
DUP 2@ CR TYPE ;

CR $> S" ac day mlg pinka profit" arr-test
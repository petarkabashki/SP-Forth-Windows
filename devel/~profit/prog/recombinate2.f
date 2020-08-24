\ �������� �����������, ���������� �� ��������� ������������, �����
\ ���������� �������� ���������� � ������������ � ��, � ���� �������,
\ -- � ������ � ������������������ DROP'��.

\ ����������� �������� ��������� n ... 3 2 1
\ ����������: http://fforum.winglion.ru/viewtopic.php?p=3479#3479 �
\ http://fforum.winglion.ru//viewtopic.php?p=4136#4136

\ �������� ���������� -- ���������� ����������� �������� �� �����.
\ ������������ ����� ��� ����� ����� ���������� �������� ��� ���������
\ ��� ��������� (������� -- ������, ���� ����������� �����):
\ ... 5 4 3 2 1
\ ������ ��������� ���������� ��������� ����� ������ � ������� � ���
\ �����, �������� �����.

\ �������� �������� -- ��� �������� ������� ���� � ����������.
\ ��������� �������� -- �������� ������� � ���������� ���.
\ ����� ���������� -- ���-�� �������� ���������.
\ ������� ���������� -- ������������ ����� ��������, �� ���� �����
\ ������ ��������� �������� ����������� ���� �����������.

\ �������� �������� 2DROP 2DROP 2DROP ������������� ���������� 7.
\ �������� ������� -- 7. ��������� �������� -- 123456.
\ ����� ���������� ����� 1. � ������� ����� 7-�.

\ ��� �������� ����������� ���������� �������� ��������, �������
\ ��� ��������������� �� ���������� �������������� � �����:

\ 4312 --> (4) (3) (12) --> (12) --> �������� ���������� ������ � ������ ��������
\ 3412 --> (34) (12) --> XCHG 3, 4; XCHG 1, 2
\ 4123 --> (4) (2) (13) --> (13) --> MOV t, 1; MOV 1, 3; MOV 3, t
\ 563241 --> (56) (342) (1) --> (56) (243) --> XCHG 5, 6;  XCHG 2, 4; XCHG 4, 3;
\ 7 --> 76'5'4'3'2'1' DROP^6 --> (7) (6') (5') (4') (3') (2') (1') DROP^6 --> DROP^6 
\ 23 --> 231' DROP^1 --> (23) (1') DROP^1 --> (23) DROP^1
\ 532 --> 5324'1' DROP^2 --> (5) (34'2) (1') DROP^2 --> (34'2) DROP^2

\ ����������:
\ DUP SWAP --> 11 12 --> 11
\ DUP OVER --> 11 212 --> 111

\ ����� ����� ����������� ����� ������ �������� �������
\ ����������:
\ SWAP 2SWAP --> 12 2143
\ � 12 ������� ������ ��� � 213, ������� ��������� 12 �������
\ �������� ������������������� ������������ �� � �������:
\ 12 --> 312 --> 4312
\ ������, ����� �� ����� �������, ���������� ������ ����������:
\ 4312 2143=1243

\ ������� �����:
\ 1243 --> (1324)

\ ����� ���������� ����� � �� ���� ���������� � DROP'��:
\ NIP DROP --> 31 2 --> 312' DROP^1  21' DROP^1
\ ���� ���-�� ������� ������ ���������� � �������� ������
\ ���������� �� ��� ���-�� ��������, ��� ���� ���-�� �������
\ �� ������ ���������� ��������� �� ������ � �����������:
\ 312 32'1' DROP^2 --> 31'2' DROP^2

\ ��� ������:
\ 2DROP ROT NIP --> 3 213 31 --> 32'1' DROP^2 213 312' DROP^1 -->
\ --> 321 4352'1' DROP^2 312' DROP^1 --> 321 43521 534'2'1' DROP^3
\ �������� �������:
\ 54321 43521 534'2'1' DROP^3 --> 4'532'1' DROP^3

\ ��� SPF �������� ��������� ����� ����� ������ �� � �������,
\ � �� ������� �������� (!). ��� ��� ������� ����������, ��
\ ������ � �� �������� ������� ��������� �������-����.

\ ����� �������� ��� ��������� �������� � "���� ��������"
\ ����� ������ � ������ ��������� ����������. �������� 
\ ����� ������� ������� ��������. ����� ����, ��� ���
\ ��������� �������� �������� � ���� ����, ��������
\ ������������ ����� ���������, ��������� � S.

\ 231' DROP^1 --> 21'3 S1 --> (1'23) S1
\ 7 --> 6'5'4'3'2'1'7 S6 --> (1'2'3'4'5'6'7) S6
\ ����� ����� ����� ���������� ���������� ���������� � ������
\ ������� ���������, �������:
\ (1'2'3'4'5'6'7) S6 --> (1'3'4'5'6'7) S6 -->
\ --> (1'4'5'6'7) S6 ... --> (1'7) S6
\ ����� ����� ��������� � ������������� ��������� ��������
\ � ���� ������� �� ���� ���������� ������ ���������.

\ �������������� �� ���������� � DROP'��� � ���������� � S'���
\ ����� ������ ������ ����� ��������� ���� ����������, ���
\ ���������� ���������� � S ��� ��������������� ���� ����.

\ TODO: ����� ��������� ��� � ������� ����� � ����� cycles.
\ TODO: ������� ������� � DROP �� NIP.
\ TODO: ������� ����������� ����������� ������ � ������������
\ � ���������� ���������� ( (1'2'3'4'5'6'7)-->(1'7) ).
\ TODO: ���� � ����� ��������� 1 (EAX) �� �����, ��������� ����
\ � ������ EAX ������ ��������� � �����, ������������ ��� EAX 
\ ������ ��������� ������� ������ 101 (EBX ��� ��� ��� ������).
\ TODO: DUP OVER TUCK � ������ �������� �������� *�����������* ��������.
\ TODO: ��������� (+ - /MOD). ��.. ������� ��?

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE __ ~profit/lib/cellfield.f
REQUIRE iterateBy ~profit/lib/bac4th-iterators.f
REQUIRE arr{ ~profit/lib/bac4th-sequence.f
REQUIRE ON lib/ext/onoff.f
REQUIRE writeCell ~profit/lib/fetchWrite.f
REQUIRE SEE lib/ext/disasm.f

MODULE: stackOptimizer

\ ������ ����������� ��������� ������ ����������:
\ ������� ���� ������ ��������� �� ���:

\ ���       |Len| �����������      |Drops|
CREATE swap   2 ,   1 , 2 ,          0 ,
CREATE dup    2 ,   1 , 1 ,          0 ,
CREATE tuck   3 ,   1 , 2 , 1 ,      0 ,
CREATE over   3 ,   2 , 1 , 2 ,      0 ,
CREATE rot    3 ,   2 , 1 , 3 ,      0 ,
CREATE -rot   3 ,   1 , 3 , 2 ,      0 ,
CREATE nip    2 ,   3 , 1 ,          0 ,
CREATE drop   1 ,   2 ,              0 ,
CREATE 2drop  1 ,   3 ,              0 ,
CREATE 2swap  4 ,   2 , 1 , 4 , 3 ,  0 ,
CREATE 6drop  1 ,   7 ,              0 ,
CREATE nop    0 ,                    0 ,
CREATE some   2 ,   2 , 4 ,          0 ,
CREATE 2dup   4 ,   2 , 1 , 2 , 2 ,  0 ,

\ ����� ����� i-�� (������� �� �������) �������� � ���������� addr
\ �� �� ������, ��� ���������� ���������� �� �����?
: i[] ( i addr -- n ) DUP @ CELLS + SWAP 1- CELLS - ;

\ �� ������ ���������� � ������ �������� ����� ������ � ���-� DROP'��
: drops ( comb -- addr ) 0 SWAP i[] ;

\ �������� �������� �� ���������� �������� ���������� � �������.
: comb=> ( addr --> n \ <-- ) DUP @ SWAP CELL+ SWAP  RUSH> iterateByCellValues ; \ �������� �� �����������

\ �������������� ������� ����� � ���������� (drops �������������� ����)
: arr>comb ( addr u --> comb \ <-- ) PRO
arr{ *> CELL / <*> iterateByCellValues <*> 0 DROPB <* }arr DROP CONT ;

: comb>arr ( comb -- addr u ) DUP @ 2 + CELLS ;
\ �������������� ���������� � ���� addr u (��� �������� � ����������� ������)

\ ��������� ���������� ����������, ��� ��������� �� ��������� ����� ������ ������ ����� ����.

\ ������� ����������
: depth ( addr -- u ) MAX{ comb=> DUP }MAX ;

\ ���������� ����������
: .comb ( addr -- ) 
DUP START{ comb=> DUP . }EMERGE ."  DROP^" drops @ . ;

\ ��������� ���������� addr1 �������� ������������������� �� start ������ � � ������ � len
\ len ����� ���� �������������
\ ������ ����� ������ �� ������� ��������� ���������� addr2
: extend ( addr1 start len --> addr2 \ <-- ) PRO
arr{ *> 1 iterateBy2 <*> comb=> <* }arr
arr>comb CONT ;

\ ���������� ���������� ���� �����������.
\ �������� � ������ ���� � ����������� ����� �����
\ � ��� �������� ��� �������������� ���������
: composeAligned ( addr1 addr2 --> addr3 \ <-- ) PRO LOCAL a SWAP a !
arr{ comb=> DUP a @ i[] @ DROPB }arr arr>comb CONT ;

\ ���������� � ����������� ����.
\ �� �������� ��� �������������� �������� �� ��� �� ��������������
: composeWithoutDeletions ( addr1 addr2 --> addr3 \ <-- ) PRO 2DUP @ SWAP @ OVER -
DUP 0 > 0= LOCAL dir dir !
2SWAP dir @ IF SWAP THEN 2SWAP
dir @ 0= IF DUP ROT + SWAP NEGATE THEN
extend dir @ IF SWAP THEN composeAligned CONT ;

\ ����������� ������������� ��������� ��������
:NONAME ( a b -- a b f ) 2DUP = ; CONSTANT number=

\ "���-�". ���� � ��������� b (���������!) ��� �������� a
\ (��������!), �� ������ �����
: not-in ( a b f --> \ <-- ) PRO LOCAL f f ! LOCAL b b !
S| NOT: b @ ENTER f @ ENTER ONTRUE -NOT CONT ;

\ ���������� �������� ��������� �� ���������� ���� ������ ��������
\ �� �� ������ ������� ���������� � �������������� � ���-� ���-�
\ DROP'��
: addDeleted ( addr1 -- addr2 ) PRO LOCAL i LOCAL drops2Add
DUP drops @ drops2Add !
arr{ \ ������ ������������� ������
DUP seq{ comb=> }seq  i ! \ �������� �������� � ������-��������
depth \ ������� �������
seq{ \ �������� ����������� ������ �������� ���������
DUP NEGATE 1 iterateBy \ ���������� ����� �� ������� ���������� �� 1-��
i @ number= not-in \ ���� ����� ��� � ����������, �� ������� ��� � ������
}seq ( list-xt ) \ ����� ������ �������� ��������
DUP {#} drops2Add +! \ ������� �������� ���� �������
\ ������������� ������
 *> i @ ENTER \ ������� -- ���� ����������
<*> ENTER \ ����� -- �������� ��������
<* }arr arr>comb
drops2Add @ OVER drops ! CONT ;

\ �������� ���������� �� ������ addr u
: str>comb ( addr u -- comb ) PRO
arr{ iterateByByteValues [CHAR] 1 - 1+ }arr
arr>comb addDeleted CONT ;

\ ����� ���� ��������� ���������� addr1 �� ����� shift
\ ������ ����� � ������� �������� ���������� addr2
: shiftComb ( addr1 shift --- addr2 ) PRO LOCAL shift shift !
arr{ comb=> DUP shift @ + DROPB }arr arr>comb CONT ;

\ ���������� � ����������� ���� � ������ �������� ��������� (��� �������������).
: compose ( a b -- c ) PRO
LOCAL b b !
( a ) addDeleted LOCAL combA+Deleted combA+Deleted !
b @   addDeleted ( combB+Deleted ) DUP b !
combA+Deleted @ drops @ shiftComb
addDeleted ( combB+Deleted+shifted+Deleted )

combA+Deleted @ SWAP composeWithoutDeletions
b @ drops @ combA+Deleted @ drops @ + OVER drops !
CONT ;


\ ����������, ����� ����������� � � �����, ����� ������� "���������"
\ (���������������?) -- ������� ����� ���������� �� ��������, ���
\ � i-� ������� ��������� �������� ������ ������� �������� i � ��������
\ ����������. �� ����:
\ 4321 ����� ��������� ���� ������������ � 1423
\ 3124                                      4321
: invertComb ( comb1 --> comb2 \ <-- ) PRO LOCAL c DUP c ! LOCAL len LOCAL res 
arr{ comb=> 0 DROPB }arr DUP len ! arr>comb res !
START{ len @ CELL / 1 SWAP 1 iterateBy
DUP DUP c @ i[] @
res @ i[] !
}EMERGE
res @ CONT ;

\ ��������� ������ ����� ������ �����������
\ comb -- ���������� ����������
\ i -- ������ � �������� ���� ����������
\ touched -- ����� ������� �������, ��� ������� ��� ���������� ���������
: cycle ( touched comb i --> j \ <-- j ) PRO
LOCAL comb SWAP comb !
LOCAL touched SWAP touched !
BEGIN
DUP 1- CELLS touched @ + DUP @ 0= WHILE
ON
CONT
comb @ i[] @
REPEAT
DROP ;

\ ��������� ���� ������ � �����������.
\ ���-�� ������� �����-� ���-�� ��������� ������ � �����������
\ ����� ���������� ���� � ���� �������� ����� � �� �������� �
\ ������� �� �����
: cycles ( addr1 --> addr2 u2 \ <-- ) PRO invertComb
123456789 DROPB SWAP  DROPB S| \ ���!.. � ��� � �� ����� �������� ������ ����� � ���� �����... �����, ��?..

arr{ DUP comb=> 0 DROPB }arr   \ ������ ������ ������� (touched)
                               \ � ���-��� ��������� ����� �� ��� � � ����������
DROP                           \ ����� ����� ������� �� �����, � ��� ����
SWAP ( touched comb )
seq{ seq{ DUP comb=> }seq
ENTER }seq3                    \ ��� ����� ��� ������������ �����.
NIP NIP                        \ ������� touched � comb: ��� ��� ������� � ��������

\ ����� ������� �� �������� �� ����� ����� ��������� �
\ �������� ����������:
\ touched comb 1
\ touched comb 2
\ ...
\ touched comb n

ENTER
arr{
2 PICK 2 PICK 2 PICK \ 3DUP
( touched comb i )
cycle
}arr
2DROPB
DUP 2 CELLS < ONFALSE          \ ������ ����� � ����� �� ������ �������� �� �����
CONT ;

: .cycles ( addr u -- ) ." (" BACK ." ) " TRACKING CELL iterateBy DUP @ . ;


\ ���������� ���. ���� �������� ������������
\ a � b -- ���� ���������
\ ���� ��� �������� ������ ���, �� ��� ��������� �������� (�. �. �������)
\ ���� ������, �� ��� ����� �������� �� ����� (������� � ������� � ���� �������)
\ �������������� ������ ��� ������ ����� ���� ������� �������� ����������
\ ��������� � ������ ����� �������� ���������.
: assign ( a b -- )
DUP 100 < IF \ ������ �� �������� � ����-� �������
1-
0x8B C,
DUP 0= IF DROP 100 = IF 0xD0 C, EXIT THEN 0xD8 C, EXIT THEN
SWAP 100 = IF 0x55 ELSE 0x5D THEN C, 1- CELLS C,
ELSE \ ������ �� ��������� �������� � �������
SWAP 1- SWAP
OVER 0= IF NIP 0x8B C, 100 = IF 0xC2 ELSE 0xC3 THEN C, EXIT THEN
0x89 C,
100 = IF 0x55 ELSE 0x5D THEN C, 1- CELLS C,
THEN ;

(
8BD8             MOV     EBX , EAX
8B5D00           MOV     EBX , 0 [EBP]
8B5D04           MOV     EBX , 4 [EBP]
8B5D08           MOV     EBX , 8 [EBP]

8BC3             MOV     EAX , EBX
895D00           MOV     0 [EBP] , EBX
895D04           MOV     4 [EBP] , EBX
895D08           MOV     8 [EBP] , EBX


8BD0             MOV     EDX , EAX
8B5500           MOV     EDX , 0 [EBP]
8B5504           MOV     EDX , 4 [EBP]
8B5508           MOV     EDX , 8 [EBP]

8BC2             MOV     EAX , EDX
895500           MOV     0 [EBP] , EDX
895504           MOV     4 [EBP] , EDX
895508           MOV     8 [EBP] , EDX
)

: tempInvert 100 = IF 101 ELSE 100 THEN ;

: cycle>assigns ( addr u -- list-xt ) PRO

LOCAL first OVER @ first ! \ ������ ������� ����������
LOCAL switch 100 switch !  \ ������������� ��������� ����������

seq{
*>
first @ switch @
<*>
SWAP CELL+ SWAP \ �������� ����� �� ������� �������� �����������
CELL / 1-
iterateByCellValues
 *>
switch @ tempInvert switch ! \ ����������� �������������
DUP switch @
<*> switch @ tempInvert OVER
<*
<*> switch @ first @ <*
2DROPB SWAP
}seq2 CONT ;

: .assigns ( list-xt -- )  ENTER 2DUP CR SWAP . ." =" . ;

: compileCycles ( list-xt -- ) cycle>assigns ENTER 2DUP assign ;
: compileComb ( addr -- ) addDeleted BACK 0 ?DO POSTPONE DROP LOOP TRACKING DUP drops @ BDROP cycles compileCycles ;



VARIABLE curComb \ ������� ����������, ��������� �� ������� ������-����������
S" " str>comb comb>arr HEAP-COPY curComb ! \ ������ ����������

: A! ( adrr arr -- ) DUP  @ FREE THROW  ! ;
\ ����� � ���������� ����������� �� ������,
\ �������������� ������ ���������� ������ ��� ������


VARIABLE beforeHere
VARIABLE hereAfter
hereAfter 0!

VARIABLE lastCombStarts

0
__ oldWord \ xt ����������� �����
__ combOp  \ ����� ���������� � ������
CONSTANT stackWord

: opt ( stackWord  -- ) \ ������� ���������������
beforeHere @ hereAfter @ = IF \ ���� ����� ���� �����-� �������� � 
                              \ ������ ���� �������� -- ���������,
                              \ ������ ��� ���������������� ��-���
                              \ � �� ����� ���������� � ���� ��-���.
curComb @
\ CR DUP .comb
SWAP combOp @
\ DUP .comb
START{
compose comb>arr
HEAP-COPY }EMERGE \ ����� � ��� START{ .. }EMERGE �� ����� � ���, �����
                  \ ������� ����-� ���������� �� ������ �������
\ DUP .comb
curComb A!
lastCombStarts @ DP !
curComb @ compileComb
ELSE combOp @ comb>arr HEAP-COPY
curComb A!  beforeHere @ lastCombStarts ! THEN ;

: OPTIMIZE
' DUP WordByAddr CREATED \ ���������� �����
HERE oldWord !  \ ��������� xt ������� �����
NextWord ( addr u ) \ ����������
str>comb comb>arr
HERE >R
stackWord ALLOT \ �������� ��������� � ��������� ������
( combA combU  R: struct )
HERE >R DUP ALLOT
R@ SWAP MOVE
R> R> combOp !
IMMEDIATE
DOES>
STATE @ IF \ ���������� ��� �������������?
HERE beforeHere ! \ ������ ������� "��"
DUP oldWord @ COMPILE, \ ����������� ����� "��-��������"
opt \ �������� ��� ���� ����������������
HERE hereAfter ! \ ������ ������� "�����"
ELSE
oldWord @ EXECUTE \ � ������ ������������� �� ���������� -- ������� ��� ����
THEN ;

EXPORT

OPTIMIZE SWAP 12
OPTIMIZE 2SWAP 2143
OPTIMIZE 2DROP 43
OPTIMIZE NIP 31
OPTIMIZE DROP 2
OPTIMIZE ROT 213
OPTIMIZE -ROT 132


\ seq -- ������ ���. ��������, ������� ����� TRUE, ���� �����-� ������� � comb ����������
: repeatedElems ( comb -- addr u ) PRO LOCAL touched
arr{
DUP depth CELLS DUP BALLOCATE DUP touched !
SWAP ERASE
comb=>
1- CELLS touched @ + DUP @
SWAP ON
}arr CONT ;

\ ���� �� ���������...
: removeDuplicates ( comb1 -- comb2 ) PRO LOCAL len LOCAL arr LOCAL runner LOCAL assigns
START{
DUP repeatedElems DUP len ! HEAP-COPY arr !
}EMERGE


START{
arr @ len @
CELL iterateBy
DUP @ ONTRUE
DUP -1000 SWAP !

DUP arr @ TUCK -
START{ CELL iterateBy DUP 1+! }EMERGE
DUP CELL+ arr @ len @ + OVER - 0 MAX
START{ CELL CR iterateBy DUP @ . DUP 1+! }EMERGE
}EMERGE

seq{ runner 0!
arr @ len @ CELL / iterateByCellValues
runner 1+!
DUP 0 > ONFALSE
runner @ OVER -1000 - 1+
2DROPB
}seq2 assigns !

arr @ runner !

arr{
comb=>
runner fetchCell DUP 0 > IF
OVER +
ELSE
-1000 - 1+
THEN
DROPB
}arr DUMP

CR
assigns @ START{ ENTER 2DUP SWAP . ." ->" . }EMERGE

arr @ FREEB DROP
CONT ;


\ 2dup repeatedElems DUMP
\ 2dup r

;MODULE

/TEST


ALSO stackOptimizer \ ������� ���������� ���� ����������

$> :NONAME BACK RET, TRACKING *> 1 <*> 2 <* DROPB *> 100 <*> 101 <* DROPB *> <*> BSWAP <* 2DUP assign ; HERE SWAP EXECUTE REST

$> swap .comb
$> S" 412" str>comb .comb
$> swap rot compose .comb
$> swap rot compose drop compose .comb
$> nip drop compose .comb
$> drop nip compose .comb
$> rot nip compose 2swap compose drop compose .comb
$> \ Check for stack elements' leaking in cycles
$> 40 30 20 10 swap cycles .cycles
: .s. DEPTH .SN S0 @ SP! ;
$> :NONAME 2swap swap compose cycles .cycles ; ENTER .s.
$> swap cycles cycle>assigns .assigns
$> swap rot compose nip compose cycles cycle>assigns .assigns
$> 4 3 2 1 :NONAME  2SWAP SWAP 2SWAP ; DUP REST ENTER .s.
$> 4 3 2 1 2SWAP SWAP 2SWAP .s.
$> 5 4 3 2 1 :NONAME SWAP ROT NIP ROT DROP ; DUP REST ENTER .s.
$> 5 4 3 2 1 SWAP ROT NIP ROT DROP .s.
$> 4 3 2 1 :NONAME 2SWAP SWAP ROT SWAP ; ENTER .s.
$> 4 3 2 1 2SWAP SWAP ROT SWAP .s.
$> 4 3 2 1 :NONAME ROT DROP -ROT ; ENTER .s.
$> 4 3 2 1 ROT DROP -ROT .s.
$> 4 3 2 1 :NONAME 2DROP DROP ; ENTER .s.
$> 4 3 2 1 2DROP DROP .s.
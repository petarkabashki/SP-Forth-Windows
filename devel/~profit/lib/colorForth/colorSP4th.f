\ colorlessForth ��� �����. ���� -- Chuck Moore � Terry Loveall.
\ ����� ���������� ���������. ������� ������ �������������.

\ ��� ����������� colorForth ��� "������� �������� �����, ���
\ ���������� ������������ ������". � ������ ����� ��������������
\ � ����� ������ ������� �������� ������� colorlessForth-�������
\ �� ����� �� ���������� ������: "� ����� ����������� �������������
\ (� ��������� �������� �������� ����������) �����, ��� ������ 
\ ���������� ���� ����� ������������ ���� ���������� 
\ ���������������?"

\ ������� ���������� ��� ���������� ����������� ���������
\ �������-������� ����-������� � ���� ���������� �����������:

\ ���������: �����, �����, �����.

\ ��� ���� ����� � ����� ���� ����� ������ ���������� ������� 
\ ����������� (������������ ����� ������� �������, ��������� 
\ ������� ���������� ������) ����������� ���������� �����������
\ ���������� ���������� (������� � ����� � ������� ����� 
\ ����� ���������� ���� �����).


\ ���������� ��� �������� ���:
\ �� ����� ������� ������� ���������� ����� (��������� � ������
\ ��������� ����� � ������ �� ��������� �� ����������� � SPF ���),
\ ������������� ������ �������� ��������� ����� � ������ ��� 
\ �������, ���� ��� ��� ������, �� ������������� ��������� 
\ ���������� ��������. ���� �� ���, �� �������� � �������� ���������
\ ��������:

\ ��� ������ �� "������" (������ ������, �������), ������������
\ ��������� ������:

\ : -- �����������
\ , -- ���������� ( COMPILE, )
\ . -- ���������� ������������ �������� ( BRANCH, ), ��������� �����������
\ ; -- ���������� ��������� �������� ( LIT, )
\ ' -- ��������� ������ ��� ����� �����, � �������� ����� �������� xt
\ | -- ������ � �������� ����� ( | )
\ # -- ���������� �����
\ $ -- ����������������� �����

\ : r          -->  r:
\ : r 12 ;     -->  r: 12; .
\ ' r          -->  r'
\ ' r COMPILE, -->  r' , --> r,
\ ['] r        -->  r;
\ ' r ,        -->  r,
\ : r 0x32 ;   -->  r: 32$; .

\ ����� ���� �������� ��� � "������" . , ; | ���� �� �������-�����
\ ������� ���� ��������� (���� ����) ����� �� �����.

\ ����� ������� ����� ���� �������� ���� ��������� �������������
\ ��������� �����������:
\ DUP. --> DUP, .

\ ��. ����� ~profit\lib\loveall.f

\ square: DUP, *.
\ 2x2: 2#; square, typeNumber.
\ 2x2

\ ������������� ������� �������� ��������� ��������� �����
\ ���������������, ���� ������ ����� ���, �� �������� ������,
\ ������� ��������� ����� �� ��������� ����� ����� � �������
\ ��� ������ � ��������� ���������� ��� ������ �����-"�����"
\ � �� ��� ��� ����� �� �������-��������� ������ ����� 
\ ���-������ �������.

\ ����� �������, � ���� ���������� colorlessForth'� ��������� �� 
\ ����� ����������� �� ������ STATE �� � IMMEDIATE .

\ � ����� �������� �� ������ ������������ ��������� � ������ 
\ ������������� �� � ����������� ��������� ���� �� ����� "�������"
\ ����� ������������ ��� ��������� ������ ������.

\ ��� �������� ����� ��� ���������� "��������" �������.

\ ��������, ��������� ����� "SWAP," ����� ������ �������� �� ����������
\ SWAP (����������� �����-������). ��� ���� ���� ����� "SWAP" �������
\ ���������� ��������� � ' SWAP (��� SWAP' , � �����������) ����� 
\ ������ �� ��� ����.

\ ��� ����� ���� -- ����� ���������� ����� � ������ "r:"
\ ��� ��������� ����������� ����� r

\ r::  bam" TYPE, r" :.

\ ��� ����� �������� ����������� ��������� ���������� ������
\ �����:

\ r.:  tail!" TYPE, r' BRANCH,.

\ ����� �������� ������ �������� 

\ TODO:
\ 1. ������� ������������� � cascaded.f
\ 2. ��������, ����� � ���������� all: ������� "����������" ����� �� nf-ext 
\ (�� ������ ����� ��������� ��������� ������ ���� addr u FALSE, ��� ��������
\ ��������� ������������ nf-ext)
\ 3. ������ ������ �� �������� (���� " �������, �� ��� ���� � �������������
\ ��������?)
\ 4. ������� �������� typeNumber
\ 5. ��������� ��������. ���� -- ������ ". ������ ���� ���� �������������,
\ ��� ��� �� ������������ ����������.

\ ������������ ���� � ����������� ��������:
\ �����������:  1#; typeNumber,    <--- CREATE ����������� 1 LIT, COMPILE .
\ �����������2: 2#; typeNumber,    <--- CREATE ����������� 2 LIT, COMPILE .
\ �����������3: 3#; typeNumber, .    <--- CREATE ����������� 3 LIT, COMPILE . RET,
\ �����������3: 3#; typeNumber.    <--- CREATE ����������� 3 LIT, ' . BRANCH,

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE NOT ~profit/lib/logic.f
REQUIRE (: ~yz/lib/inline.f
REQUIRE lastChar ~profit/lib/strings.f
REQUIRE number ~profit/lib/number.f
REQUIRE charTable ~profit/lib/chartable-eng.f
REQUIRE enqueueNOTFOUND ~pinka/samples/2006/core/trans/nf-ext.f
REQUIRE KEEP! ~profit/lib/bac4th.f
\ REQUIRE cascaded ~profit/lib/colorForth/cascaded.f

MODULE: colorSPF

: wordCode ( addr u -- ) SFIND NOT IF 2DROP -321 THROW  THEN ;
: numberOrWord ( addr u -- ) SFIND NOT IF
lastChar [CHAR] # = IF 10 BASE KEEP! CHAR- THEN CHAR+
lastChar [CHAR] $ = IF 16 BASE KEEP! CHAR- THEN CHAR+
number THEN ;

charTable colors

colors
all: -321 THROW ;
char: ' wordCode ;
char: , wordCode COMPILE, ;
\ char: : CREATED DOES> EXECUTE ;
char: : SHEADER ;
char: . wordCode BRANCH, ;
char: " SLIT, ; \ "
char: ; numberOrWord  LIT, ;
char: | numberOrWord , ;

(
ALSO cascaded
\ ����� ��������� ����������� ���������� ��������� ���������
\ �� ���������

NEW: CSPFWords
\ ������� ����� ������� ��� ���� CSPF
PREVIOUS )

: processWord ( addr u -- ) lastChar colors processChar ;

EXPORT

\ �������� NOTFOUND-�������� ��� ������ "::" -- ����� �� ����������� ������ vocabulary::word
: NOTFOUND
2DUP S" ::" COMPARE 0= IF processWord EXIT THEN 
NOTFOUND ;

: startColorSPF
(: ( addr u -- addr u false | i*x true ) processWord TRUE ;) enqueueNOTFOUND
\ [COMPILE] ]
\ ALSO CSPFWords DEFINITIONS
;

: typeNumber . ; \ ����� ����� ���� ���������� � ����� ��� �������� � ������������ � ���� ������ ..

;MODULE

/TEST
REQUIRE SEE lib/ext/disasm.f

startColorSPF

.: RET,.
;: LIT,.
|: ,.
,: COMPILE,.
": SLIT,.
:: SHEADER.

\ � ��������� ���� ��� ���� ���������� ( , ) ����� 
\ ������ �� ����� ��� IMMEDIATE-������, �� ����� 
\ �������� �������� "�� ����� ���������� if"
IF,:   TRUE, STATE, KEEP!, IF.
THEN,: TRUE, STATE, KEEP!, THEN.

\ INLINE-�������������� ����� (src/compiler/spf_inline.f)
RDROP,:   TRUE, STATE, KEEP!, RDROP.
?DUP,:    TRUE, STATE, KEEP!, ?DUP.
EXECUTE,: TRUE, STATE, KEEP!, EXECUTE.

>R,:  TRUE, STATE, KEEP!, >R.
R>,:  TRUE, STATE, KEEP!, R>.

>R:   >R, .
R>:   R>, .



\ ."' .": TRUE, STATE, KEEP!, , .

fact: ( x -- fx ) ?DUP, 0=, IF, 1; . THEN, DUP, 1-, fact, *.

$> SEE fact
$> 4 fact typeNumber

array: R>.

arr: array,
0| 1| 2| 3| 4| 5|

$> arr 6 CELLS DUMP
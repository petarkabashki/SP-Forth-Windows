\ ��������� ������, SPF 4.19
\ http://fforum.winglion.ru/viewtopic.php?t=1157

REQUIRE ON lib/ext/onoff.f
REQUIRE /STRING lib/include/string.f
REQUIRE ENUM ~nn/lib/enum.f
REQUIRE CASE lib/ext/case.f
REQUIRE NUMBER ~ygrek/lib/parse.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE >=  ~profit/lib/logic.f
REQUIRE state-table ~profit/lib/chartable.f
: symbols: �������: ;
: same-reaction POSTPONE ����-����� ; IMMEDIATE
\ ^-- ��������� �� ���������� � chartable.f

REQUIRE __ ~profit/lib/cellfield.f
S" ~pinka/lib/ext/requ.f" INCLUDED
REQUIRE ?EXIT ~mak/utils.f

: +TO ' >BODY STATE @ IF POSTPONE LITERAL POSTPONE +! ELSE +! THEN ; IMMEDIATE


\ ������������ ����� ����� � �������
0
ENUM null
ENUM number
ENUM string
ENUM expression
ENUM error
CONSTANT cellTypesCount

\ ��������� ������ � �������
0
__ cellType
__ cellContents
__ cellRefsCount \ ���-�� ������ ������
__ cellRefsArr \ ��������� �� ������ ������ ������
__ cellBRefsCount \ ���-�� �������� ������
__ cellBRefsArr \ ��������� �� ������ �������� ������
__ cellUnresolvedLinksCount \ ���-�� ������������� ������ ������
__ cellFilledBLinksCount \ ���-�� ����������� �������� ������ (����-�� � allot-bref-arrays, ������������ � fill-bref-arrays)
__ cellResult \ ��������� ���������� ������� (� ������ �������� ����� ����� �����)
__ cellResolved \ ��������� �� �������
CONSTANT spreadCell

\ �������� ������ ������� ���������� ��� ������� ��� ����� ����� �������:
5664
ENUM cellformat-error  \ ����������� ������ ������
ENUM typecast-error  \ ������ �����
ENUM number-error  \ ������ ����� �����, �������� �������
ENUM cycle-error  \ ����������, ����������� ������ (����������� �������)
ENUM reference-error  \ �������� ������ �� ������ (����� �� �������)
ENUM formula-error  \ ����������� ������ �������
DROP
0xC0000095 CONSTANT overflow-error  \ ������������
0xC0000094 CONSTANT zerodivide-error \ ������� �� ����

: cell-error! ( spreadCell' error-num -- )
OVER cellContents ! error SWAP cellType ! ;

0 VALUE spreadSheet \ ��������� �� �������
0 VALUE rows
0 VALUE cols

: rowscols ( -- n ) rows cols * ;
: initSpreadSheet ( -- ) rowscols spreadCell * DUP ALLOCATE THROW DUP TO spreadSheet SWAP ERASE ;
: spreadRowsCols ( -- addr n ) spreadSheet rowscols ;
: spreadAddr ( row col -- spreadCell' ) cols * + spreadCell * spreadSheet + ;
: bounds? ( row col -- ) 0 rows WITHIN SWAP 0 cols WITHIN AND NOT IF reference-error THROW THEN ;


cellTypesCount state-table print-cell0 ( spreadCell' type -- )
null asc: DROP ;
number asc: cellContents @ . ;
string asc: cellContents @ STR@ TYPE ;
expression asc: DUP cellResolved @ IF cellResult @ . ELSE DROP THEN ;
error asc: cellContents @ CASE
typecast-error   OF ." #type" ENDOF
zerodivide-error OF ." #zerodiv" ENDOF
overflow-error   OF ." #overflow" ENDOF
reference-error OF ." #reference" ENDOF
number-error   OF ." #number" ENDOF
cycle-error   OF ." #cycle" ENDOF
formula-error OF ." #formula" ENDOF
cellformat-error OF ." #cellformat-error" ENDOF
." #unknown" ENDCASE ;

: print-cell DUP cellType @ print-cell0 ;
: print-spreadSheet
spreadSheet ( spreadCell' )
rows 0 ?DO
cols 0 ?DO
DUP print-cell  9 EMIT
spreadCell +
LOOP CR LOOP DROP ;

: overflow? ( d -- ) DABS 2147483647. D> IF overflow-error THROW THEN ;

\ ������� ������ ������ � �������
MODULE: count-refs
VARIABLE counter
: cell_reference_occured ( row col -- ) 2DROP counter 1+! ;
Include expression.f
EXPORT
: count-refs-in-expression ( s -- n ) counter 0!  process-expression counter @ ;
;MODULE


\ ���������� ������� ������ ������
MODULE: fill-refs
0 VALUE runner
: cell_reference_occured ( row col -- )
2DUP bounds? spreadAddr
DUP cellBRefsCount 1+!
runner !  CELL +TO runner ;
Include expression.f
EXPORT
: fill-refs-in-array ( spreadCell' -- )
DUP cellRefsArr @ TO runner
cellContents @ process-expression ;
;MODULE

: allot-bref-arrays ( -- ) \ ������ �� ���� ����� ��� �������� �������� ������ ��� ���� ����� �����
spreadRowsCols 0 ?DO
DUP cellBRefsCount @ ?DUP 0<> IF
CELLS ALLOCATE THROW
OVER cellBRefsArr ! THEN
DUP cellFilledBLinksCount 0!
spreadCell + LOOP DROP ;

: fill-bref-arrays ( -- ) \ ���������� �������� �������� ������ ��� ���� ����� �����
spreadRowsCols 0 ?DO
DUP cellType @ error <> IF
DUP cellRefsCount @ CELLS OVER cellRefsArr @ TUCK + SWAP ?DO
DUP
I @ cellBRefsArr @ I @ cellFilledBLinksCount @ CELLS + !
I @ cellFilledBLinksCount 1+!
CELL +LOOP THEN
spreadCell + LOOP DROP ;

\ ���������� ������� � ������
MODULE: calc
256 state-table op-save ( char -- xt )
: add ( n1 n2 -- n1+n2 ) >R S>D R> S>D D+ 2DUP overflow? D>S ; symbol: + ['] add ;
:NONAME ( n1 n2 -- n1-n2 ) NEGATE add ; symbol: - LITERAL ;
:NONAME ( n1 n2 -- n1*n2 ) M* 2DUP overflow? D>S ; symbol: * LITERAL ;
:NONAME ( n1 n2 -- n1/n2 ) DUP 0= IF zerodivide-error THROW THEN / ; symbol: / LITERAL ;

: op-execute ( n1 xt n2 -- xt[n1,n2] ) SWAP EXECUTE ;
: cell_reference_occured ( row col -- n ) spreadAddr
cellResult @ ;
: nonnegative_number_occured ( n -- ... ) ; \ <-- ������� �� ��������� ���������� ����� -- ��� ���� � ����������
: operation_occured ( char -- 'xt ) >R op-execute R> op-save ;
: error_occured ( -- ) formula-error THROW ;
Include expression.f
EXPORT
: calc-cell ( spreadCell' -- n )
DUP cellType @ CASE
expression OF ['] NOOP SWAP cellContents @ process-expression op-execute ENDOF
    number OF cellContents @ ENDOF
    error OF DROP 0 ENDOF
typecast-error THROW ENDCASE ;
;MODULE

: resolve-cell ( spreadCell' -- ) \ ������� ������ ������� � ������
DUP cellResolved @ NOT
OVER cellUnresolvedLinksCount @ 0= AND IF
DUP cellResolved ON
DUP calc-cell OVER cellResult !
DUP cellBRefsCount @ CELLS SWAP cellBRefsArr @ TUCK + SWAP ?DO
-1 I @ cellUnresolvedLinksCount +!  I @ RECURSE     CELL +LOOP
ELSE DROP THEN ;

: calc-formulas ( -- ) \ ���������� ���� ������ �� �����
spreadRowsCols 0 ?DO
DUP ['] resolve-cell CATCH ?DUP IF cell-error! THEN
spreadCell + LOOP DROP ;

MODULE: mark-type \ ����� ������ ��������� � ������� ����������� ������
: cell_reference_occured ( row col -- )
spreadAddr DUP cellType @ CASE
expression OF ENDOF number OF ENDOF
error OF cellContents @ THROW ENDOF
typecast-error THROW 
ENDCASE DROP ;
Include expression.f
EXPORT
: mark-error-cell ( spreadCell' -- ) >R
R@ cellType @ expression = IF
R@ cellContents @ ['] process-expression CATCH ?DUP IF NIP R@ SWAP cell-error! ELSE
R@ cellResolved @ NOT IF R@ cycle-error cell-error! THEN THEN THEN RDROP ;
;MODULE


: mark-errors ( -- ) \ ������� ���������� ������ �� ����� ��� ������
spreadRowsCols 0 ?DO 
DUP mark-error-cell
spreadCell + LOOP DROP ;

\ ���������� ����� ����� (��-�������) � �������
\ �� ����� ����� ����� ������ ������� (spreadCell'), ������ ������������ ��� ������ (addr u)
\ � ������ ������ ���� ������ (char) ������� � ������� switch-�����������
256 state-table cellInput0 ( spreadCell' addr u char -- )

all: ( spreadCell' addr u  -- ) cellformat-error THROW ;

0 asc: ( spreadCell' addr u  -- ) 2DROP
-1 OVER cellUnresolvedLinksCount !
null SWAP cellType ! ;

symbols: 0123456789 ( spreadCell' addr u -- )
-TRAILING 0. 2SWAP >NUMBER NIP ( ... ud 0 | ... xd ~0 )
0<> IF number-error THROW THEN
2DUP overflow? D>S ( spreadCell' n )
2DUP SWAP cellContents !
OVER cellResult !
DUP cellUnresolvedLinksCount 0!
number SWAP cellType ! ;

symbol: ' ( spreadCell' addr u -- )
1 CHARS /STRING >STR OVER cellContents !
-1 OVER cellUnresolvedLinksCount !
string SWAP cellType ! ;

symbol: = ( spreadCell' addr u -- )
1 CHARS /STRING
>STR SWAP >R ( s R: spreadCell' )
DUP R@ cellContents !
count-refs-in-expression ( n R: spreadCell' )
DUP R@ cellRefsCount !
DUP R@ cellUnresolvedLinksCount !
CELLS ALLOCATE THROW
R@ cellRefsArr !
expression R@ cellType !
R> fill-refs-in-array ;

: cellInput ( spreadCell' addr u -- ) OVER C@ cellInput0 ;

\ ������ ������ �� �����������-���������� (������ ���� � ������ ���������! ������� ���� ����������� ��� ����� ������� � ��������)
: tabParse ( -- addr-z u ) 9 PARSE 2DUP + 0 SWAP C! ;
\ asciiz-������ ����� ��� ���� ����� ������ ������� ������� � ������ ������ ������ 
\ �������� ���� � (� ����� cellInput)


: ---------------tiny-excel--------------- ( -- )
REFILL DROP
tabParse NUMBER 0= ?EXIT TO rows
tabParse NUMBER 0= ?EXIT TO cols

initSpreadSheet
spreadSheet ( spreadCell' )

rows 0 ?DO 
REFILL 0= ?EXIT
cols 0 ?DO
DUP tabParse
['] cellInput CATCH ?DUP IF NIP NIP NIP OVER SWAP cell-error! THEN
\                          ^-- don't ask
spreadCell +
LOOP LOOP
DROP

allot-bref-arrays
fill-bref-arrays
calc-formulas
mark-errors
print-spreadSheet ;


\ ' ---------------tiny-excel--------------- MAINX ! 0 TO SPF-INIT? FALSE TO ?GUI S" tinyexcel.exe" SAVE BYE
\ \EOF

---------------tiny-excel--------------- \ ������� �� ����
1	2
=1/0

\ #zerodiv

---------------tiny-excel--------------- \ ������� ������� ����� ��� �����
2	2
9999999999	10
=B1*B1	3

\ #overflow       10
\ 100     3

---------------tiny-excel--------------- \ ������ ������ �� ������ (����� �� �������� �������)
4	2
1	=A5
'bubu	3
'bubu	3
'bubu	3


---------------tiny-excel--------------- \ ������ ���������
2	2
1	=A2
'bubu	3


---------------tiny-excel--------------- \ ������������ � �������
2	2
555555555	10
=A1*10	3

\ 555555555       10
\ #overflow       3


---------------tiny-excel--------------- \ ������������ ������ �����
2	2
55555rrrr	10
=B1*B1	3

\ #number       10
\ 100     3

---------------tiny-excel--------------- \ ����������� ������
2	2
1	=A2
=B1*B1	3

\ 1       #cycle
\ #cycle  3


---------------tiny-excel--------------- \ ������ ������:
3	4
12	=C2	3	'Sample
=A1+B1*C1/5	=A2*B1	=B3-C3	'Spread
'Test	=4-3	5	'Sheet

\ ��������� �����:
\ 12      -4      3       Sample
\ 4       -16     -4      Spread
\ Test    1       5       Sheet
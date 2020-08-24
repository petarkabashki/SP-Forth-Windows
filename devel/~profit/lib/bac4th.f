\ �������, ���� �� SPF
\ ��. ������ http://forth.org.ru/~mlg/index.html#bacforth
\ ����� ���� ������ ���� � ������������: <����� SPF>/devel/~mlg/index.html#bacforth


REQUIRE /TEST ~profit/lib/testing.f
\ REQUIRE >L ~profit/lib/lstack.f
REQUIRE >L ~profit/lib/~af/locstack.f
REQUIRE NOT ~profit/lib/logic.f
REQUIRE (: ~yz/lib/inline.f

MODULE: bac4th

\ �������������� ����������� ������������� �����, ��� ��� � SPF ��� �������� "����������"
: ?PAIRS <> IF -2007 THROW THEN ; \ �������� �� �������� ����������� ����������
: >RESOLVE2 ( dest -- ) HERE SWAP ! ; \ "������" ���������� ������ �����

: CALL, ( ADDR -- ) \ �������������� ���������� ADDR CALL
  ?SET SetOP 0xE8 C,
  DUP IF DP @ CELL+ - THEN ,    DP @ TO LAST-HERE
;

\ ��������� �������� ��� �������� �������� ����������� ����������
12345 CONSTANT $TART
5432 CONSTANT 8ACK
4523 CONSTANT N0T
466736473 CONSTANT a99reg4te

: (ADR) R> DUP CELL+ >R ; \ ���������� ��� �������� ���������� � ����� ����

EXPORT

\ ���������� ������� ���������� xt
: ENTER ( xt -- ) POSTPONE EXECUTE ; IMMEDIATE ( \ ��� ���� �����, �� ��� �������?
: ENTER           >R ;                           \ )

DEFINITIONS


: (NOT:)  R> RP@ >L  DUP @ >R CELL+ ENTER LDROP ;
: (-NOT)  L> RP! ;
: (-NOT2) R> L> RP! >R ;

EXPORT

: ONFALSE ( f -- ) IF RDROP THEN ;   \ ����� ���� f=true, �� ���� _����������_ ������ f=0
: ONTRUE ( f -- ) NOT IF RDROP THEN ; \ ����� ���� f=false

\ : R@ENTER, SetOP 0xFF C, 0x14 C, 0x24 C, ; ( \ CALL [ESP]
: R@ENTER, ['] R@ COMPILE, ['] EXECUTE COMPILE, ; \ )

\ : R>ENTER, SetOP 0x5B C, SetOP 0xFF C, 0xD3 C, ; ( \ POP EBX    CALL EBX
: R>ENTER, ['] R> COMPILE, ['] EXECUTE COMPILE, ;  \ )

: PRO R> R> >L ['] LDROP >R >R ;      \ ������ ������� ����������� ��� ��������, �������� � ������
\ : PRO R> R> >L ENTER [ HERE PRO1 ! ] LDROP ;

\ : CONT L> >R R@ ENTER R> >L ; (
: CONT L> >R [ R@ENTER, ] R> >L ; \ ��������� ����� � ����� ���� (� ����� ��� � ������ ���� PRO )

: RUSH ( xt -- )        \ ����������� ������� �� ������ �� �����
0x8B C, 0xD8 C,         \ MOV EBX, EAX
0x8B C, 0x45 C, 0x00 C, \ MOV EAX, 0 [EBP]
0x8D C, 0x6D C, 0x04 C, \ LEA EBP, 4 [EBP]
0xFF C, 0xE3 C,         \ JMP EBX
; IMMEDIATE

: RUSH> ( "name ) ?COMP ' BRANCH, ; IMMEDIATE \ ��-��, ��� GOTO...

\ ��������� ��������

\ �� ������� ���� ��� ������ �������, �� �������� ���� ����� �� ���� ���������� �������� ������� �����
\ : RESTB ( n --> n  / n <--  )  R>  OVER >R  ENTER   R> ; ( 
  : RESTB ( n --> n  / n <--  ) [
0x5B C,                 \ POP EBX
0x50 C,                 \ PUSH EAX
0xFF C, 0xD3 C,         \ CALL EBX
0x89 C, 0x45 C, 0xFC C, \ MOV -4 [EBP] , EAX
0x58 C,                 \ POP EAX
0x8D C, 0x6D C, 0xFC C, \ LEA EBP, -4 [EBP]
] ; \ )


\ ������ RESTB ��� ������� ��������
\ : 2RESTB ( d --> d  / d <--  ) R>  -ROT 2DUP 2>R ROT  ENTER   2R> ; (
: 2RESTB [
0x5B C,                 \ POP EBX
0xFF C, 0x75 C, 0x00 C, \ PUSH [EBP]
0x50 C,                 \ PUSH EAX
0xFF C, 0xD3 C,         \ CALL EBX
0x89 C, 0x45 C, 0xFC C, \ MOV -4 [EBP] , EAX
0x58 C,                 \ POP EAX
0x8D C, 0x6D C, 0xF8 C, \ LEA EBP, -8 [EBP]
0x8F C, 0x45 C, 0x00 C, \ POP [EBP]
] ; \ )

\ ������������ SWAP, �.�. ��������� SWAP � �� ������ � �� �������� ����,
\ ��������� ���� � ���������� ���������
: BSWAP  ( a b <--> b a )      SWAP [ R>ENTER, ]  SWAP ;
\ ����������: B-SWAP -- ��� Bactrackable SWAP , �� ����: "�������� SWAP"

\ SWAP ��� ������, �.�. �� ������ ���� ������ �� ������, �� �������� ����
\ -- ��������� SWAP.
: SWAPB  ( a b --> a b \  b a <-- a b )      [ R>ENTER, ]  SWAP ;
\ ����������: SWAP-B -- ��� SWAP when Backtracking, �� ����: "SWAP ��� ������"

\ ������������ DROP
: BDROP  ( n <--> )            R>  SWAP >R  ENTER  R> ;

\ DROP ��� ������, ���� ������ ����� ��������� ��������� �������� �� �����
\ � ����������� ���������, ������ ��� ��������� ����������� (���� seq{ }seq)
: DROPB  ( n --> n / <-- n )   [ R>ENTER, ] DROP ;

\ ������� DROP ��� ������
: 2DROPB ( n --> n / <-- n )   [ R>ENTER, ] 2DROP ;

\ �������������� �������� ���������� addr ��� ������
\ : KEEP   ( addr --> / <-- )    R> SWAP DUP @  2>R ENTER 2R> SWAP ! ; (
: KEEP [
0x5B   C,          \ POP     EBX
0x50   C,          \ PUSH    EAX
0x008B W,          \ MOV     EAX , [EAX]
0x50   C,          \ PUSH    EAX
0x458B W, 0x00 C,  \ MOV     EAX , 0 [EBP]
0x6D8D W, 0x04 C,  \ LEA     EBP , 4 [EBP]
0xD3FF W,          \ CALL    EBX
0x5B   C,          \ POP     EBX
0x5A   C,          \ POP     EDX
0x1A89 W,          \ MOV     [EDX] , EBX
] ; \ )

\ ������ �������� � ���������� addr � ��������������� ��� ������
\ : KEEP!     ( n addr --> / <-- )  R> OVER DUP @  2>R -ROT !  ENTER 2R> SWAP ! ; (
: KEEP!     ( n addr --> / <-- )  PRO DUP KEEP ! CONT ; \ )
\ � ~mlg ���� B! -- ������������� � KEEP! ����� ������ �������� �� �����

\ ������ �������� ��� ������ ( BACK .. TRACKING ), ���, ����� ������,
\ �������� ����� ������ ������������������ ������ ���� ����� ������� 
\ BACK ... TRACKING �� ���� ���������
: BACK  ?COMP  0 CALL, >MARK 8ACK ;  IMMEDIATE
: TRACKING ?COMP  8ACK ?PAIRS  RET, >RESOLVE1 ;  IMMEDIATE
\ BACK ... TRACKING -- ��� ������ (: ... ;) >R , � ��������,
\ (: ... ;) -- ��� ������ BACK ... TRACKING R>

\ ����������� ������ "����������"
: START{ ( -- org dest $TART )
?COMP
0 RLIT, >MARK
<MARK $TART
; IMMEDIATE

\ ����������� ����� ������ ���������� � ����� ����
: DIVE ?COMP
DUP $TART = IF OVER COMPILE, THEN
; IMMEDIATE
\ TODO: �������� ����������� ����������� � ������ ��������� ����������


\ ����������� ������ "����������"
: }EMERGE
?COMP
$TART ?PAIRS DROP
RET,
>RESOLVE2
; IMMEDIATE

\ �������������� �����
\ ����� ��� ����������� ������� ����� ��� ������ � �������� ����, ��� ������� �����
\ ������� �������� ��� ��������� (NOT: -NOT ��� CUT: -CUT)
: S| PRO BACK SP! TRACKING SP@ BDROP CONT ;

\ ������� ���������
: NOT:  ?COMP POSTPONE (NOT:) 0 ,  >MARK N0T ; IMMEDIATE
: -NOT  ?COMP N0T ?PAIRS POSTPONE (-NOT)  >RESOLVE2 ; IMMEDIATE

\ ��������, �������������� ������/�������� � ���������� ��������
: PREDICATE  ?COMP [COMPILE] NOT:  (: FALSE ;) RLIT, ; IMMEDIATE
: SUCCEEDS   ?COMP TRUE LIT, N0T ?PAIRS POSTPONE (-NOT2) >RESOLVE2 ; IMMEDIATE

\ ������� ��������, ���������� ����� ��� ��������� �������� ���������
: ALL [COMPILE] NOT: ; IMMEDIATE
: ARE [COMPILE] NOT: ; IMMEDIATE
\ ������-�� � mlg � �������� �������� ����������� OTHER ������ ��� (� ��������� ������� ������ ������� ������ ���� ��������):
\ : OTHER ?COMP  N0T ?PAIRS  >RESOLVE2 POSTPONE (-NOT) ; IMMEDIATE
\ �� ������ ���:
: OTHER [COMPILE] -NOT ;  IMMEDIATE
: WISE [COMPILE] -NOT ;  IMMEDIATE

\ ���������
: CUT:                           \ �������� ������ ����������� �����.
    R>  RP@ >L                   \ ���. ������� ����� �����.--> �� L-����
        BACK LDROP TRACKING      \ � ��� ������ - ������ ��� �������
    >R ;
: -CUT      R> L> RP! >R ;       \ ������ ����� �������� �� �������
: -NOCUT                         \ ������ �������, �� �� ����� ��������
    R>
      L> RP@ - >R                \ ��������� �������. ����� �������
      BACK R> RP@ + >L  TRACKING \ ������������ ��� ��� ������
    >R ;

\ ���� �����������
: *>   ?COMP  204  0 RLIT, >MARK  203 ;  IMMEDIATE
: <*>  ?COMP  203 ?PAIRS  0 RLIT, >MARK RET,  205 ROT
       >RESOLVE2  0 RLIT,  >MARK 203 ;  IMMEDIATE
: <*   ?COMP  203 ?PAIRS  0 RLIT, >MARK RET,  205 ROT
       >RESOLVE2  RET,  BEGIN  DUP 204 <> WHILE
       205 ?PAIRS  >RESOLVE2 REPEAT  DROP ; IMMEDIATE

\ ������� ��� ������� ���������, ��� ���������:
\ ��������� �������� ����������
\ ������� �������������� (������������, ������������ ���������� �������� ��� ���������)
\ ������� ������, ����� �������� � ���� PRO CONT ��� R> ENTER

: agg{ ( -- ) ?COMP
POSTPONE (ADR) HERE 0 , \ ������ �������� ����������
POSTPONE !
0 RLIT, >MARK
a99reg4te ;

\ ������ �������������� �������������� � ������ ������ �������� ����������
: {agg} ( intermed -- ) >R \ intermed -- ����� �������� �� ���������� ��������
DUP a99reg4te ?PAIRS       \ �� ����������
ROT DUP LIT, -ROT
POSTPONE @
R> COMPILE, ;
\ TODO: �������� ����������� ����������� � ������ ��������� ����������

\ �� ����� ���������� �� ����� ������ ������ �������� ������� ���� 
\ ���-���������� � ���������� (��������, ����������������, �������� � �.�.)
: }agg ( agg succ -- )
?COMP  >R >R
a99reg4te ?PAIRS
OVER
LIT, R> COMPILE,
RET, >RESOLVE2
LIT, R> COMPILE, ;

\ �������� ����������� ��������
: +{ ?COMP 0 LIT, agg{ ; IMMEDIATE
: }+ ?COMP ['] +! ['] @ }agg ; IMMEDIATE

\ ����������� ��������� ����� ����������� ��������
: MAX{ ?COMP 0 LIT, agg{ ; IMMEDIATE
: }MAX ?COMP (: DUP @ ROT MAX SWAP !  ;) ['] @ }agg ; IMMEDIATE

\ ������������ ����������� ��������
: *{ ?COMP 1 LIT, agg{ ; IMMEDIATE
: }* ?COMP (: DUP @ ROT * SWAP !  ;) ['] @ }agg ; IMMEDIATE

\ ���. ������������ ����������� ��������
: &{ ?COMP -1 LIT, agg{ ; IMMEDIATE
: }& ?COMP (: DUP @ ROT AND SWAP ! ;) ['] @ }agg ; IMMEDIATE

\ ���. �������� ����������� ��������
: |{ ?COMP 0 LIT, agg{ ; IMMEDIATE
: }| ?COMP (: DUP @ ROT OR SWAP ! ;) ['] @ }agg ; IMMEDIATE

\ ������ ������������� ����������� ������� ����������� ( +{ ... }+ � ������)
: {} ?COMP ['] NOOP {agg} ; IMMEDIATE

\ ���� AMONG  ...  EACH  ...  ITERATE
\ ����������� ���:
\ (among) (among>) {addr} ... (each) ... (iterate) addr: ���_��_������
: (AMONG)
    R>                      \ ����� (AMONG>)
    BACK L> DROP TRACKING     \ ��� ������ ������ ��������� ������ ���������
    RP@ >L                  \ ��������� ������ ������ ���������
    DUP >R                  \ (AMONG>): ����� ����� ��� �������� ���������
    9 + >R ;                \ ������ (AMONG>) , ��������� ��������
\   ^-- ��-�-�! � ��� ������?.. ���� ������������� ����� CALL (AMONG>)

: (AMONG>)
    R>                      \ ����� ������ �� ��� �� ������
    L> RP@ - >R             \ ��������� ��������� ������ ������
    BACK R> RP@ + >L
         TRACKING           \ ������������ ��� ������
    @ >R ;                  \ �������� ���������� �� ��� �� ������

: (EACH)
    R>                      \ ����� ���� �����
    RP@ >L                  \ ����� ����� ����� ������ ���������
    BACK L> DROP            \ ��� ������ ������ ����� ����� ������
         L@ RP! TRACKING    \  � ���� ������ ���������
    >R ;                    \ �������� ���������� ���� �����

: (ITERATE)
    RDROP                   \ ������ ����� ����, ������������ �� ������
    L> L>                   \ ��������� �� ������ � ����� ������ ���������
    2DUP RP@ - >R RP@ - >R  \ ��������� ��������� ������ ���������
    BACK L> DROP            \ ������ ����� ��������� ������ ������ �
         R> RP@ + R> RP@ +  \ ������������ ������ ���������
             >L >L TRACKING \ ��� ������
    OVER -                  \ ����� ����� � ����� ������ ���������
    RP@ >L                  \ ����� ����� ������ ������ ���������
    RP@ OVER - RP!          \ ������� ����� �� ����� ���������
    RP@ SWAP MOVE           \ ����������� ������ ���������
;                           \ EXIT �������� ���������� ���������

: FINIS   RDROP L> >R BACK R> >L TRACKING L@ CELL- @ >R ;
: AMONG   ?COMP POSTPONE (AMONG) POSTPONE (AMONG>) 0 , >MARK 207 ; IMMEDIATE
: EACH    ?COMP 207 ?PAIRS POSTPONE (EACH) 208 ; IMMEDIATE
: ITERATE ?COMP 208 ?PAIRS POSTPONE (ITERATE) >RESOLVE2 ; IMMEDIATE

;MODULE

/TEST

: EMPTY S0 @ SP! ;

\ REQUIRE SEE lib/ext/disasm.f
\ ���-�� ����� ��������� ���������� (��������� ��������, �� ���������� �����)...
VARIABLE a
VARIABLE b

: r
10 a KEEP!
a @ 1+ b KEEP!
." r2.a=" a @ .
." r2.b=" b @ . ;

: localsTest
5 a KEEP!
." r.a=" a @ .
r
." r.a=" a @ . ;
$> localsTest

: bt ." back" BACK ." ing" TRACKING ." track" ;
$> bt
: bt2 START{ ." back" }EMERGE ." tracking" ;
$> bt2

: INTSTO ( n <-->x ) PRO 0 DO I CONT DROP LOOP ; \ ���������� ����� �� 0 �� n-1
: 1-20 ( <-->x ) PRO 20 INTSTO CONT ; \ ����� ����� �� 1-�� �� 20-�
\ : 1-20  21 BEGIN DUP R@ ENTER DROP 1- ?DUP 0= UNTIL RDROP ;
: //2 PRO DUP 2 MOD ONFALSE CONT ; \ ���������� ������ ������ �����
: 1-20. 1-20 //2  DUP . ;
$> 1-20.
: 1-20X 1-20 ." X" ;
$> 1-20X
: 1-20X1-20x 1-20 1-20 ." X" ;
$> 1-20X1-20x

\ ������� ����������
: FACT  ( n -- x ) START{
DUP  2 < IF DROP 1 EXIT THEN
DUP  1- DIVE  * }EMERGE ;
$> 10 FACT .

: FACT2 ( n -- !n ) *{ INTSTO 1+ DUP }* ;
$> 10 FACT2 .

\ ������� ����� ���������
: FIB ( n -- f ) START{ DUP 3 < IF DROP 1 EXIT THEN DUP 1- DIVE SWAP 2 - DIVE + }EMERGE ;
$> 10 FIB .


: STACK  PRO  DEPTH 0  ?DO  DEPTH I - 1- PICK  CONT DROP LOOP ;  \ ����� ����
: STACK. STACK DUP . ;  \ �������� ����
$> 1 2 3 STACK.
$> EMPTY STACK.
$> 1 STACK. DROP

: DEPTH-b +{ STACK 1 }+ ;
$> 11 32 73 DEPTH-b . EMPTY

\ ����� true ���� �� ����� *����* ����� ������ 10-�
: Estack>10 PREDICATE STACK DUP 10 > ONTRUE DROP SUCCEEDS ;
\ DROP ����� ONTRUE ����� ��� �������� ��������� �������� �� ���������� STACK, ����� �� ��� ���� ��������?
\ ����� ���������� � ������ CUT: � PREDICATE ������ �� ������ ��������� � ���� ������ ����?
$> 1 2 Estack>10 . EMPTY
$> 1 20 Estack>10 . EMPTY

\ ����� true ���� �� ����� *���* ����� ������ 10-�
: Astack>10 PREDICATE ALL STACK ARE DUP 10 > ONTRUE OTHER DROP WISE SUCCEEDS ;
$> 1 2  Astack>10 . EMPTY
$> 1 20 Astack>10 . EMPTY
$> 20 30 Astack>10 . EMPTY

: stack-sum ( x1 x2 ... xn -- x1 x2 ... xn sum  )
+{ STACK DUP }+ ;
\ ����� �������� �� �����
$> 20 30 stack-sum . EMPTY
$> EMPTY stack-sum .

: stack-or |{ STACK DUP }| ;
$> TRUE FALSE FALSE stack-or . EMPTY
$> FALSE FALSE stack-or . EMPTY

: sempty NOT: STACK -NOT ." stack is empty" ;
$> EMPTY sempty
$> 1 sempty
EMPTY

: notF ( f -- ) NOT: DUP ONTRUE -NOT ." F" ; \ ���� f=false, �� ������� "F"
: notT ( f -- ) NOT: NOT: DUP ONTRUE -NOT -NOT ." T" ; \ ���� f=true, �� ������� "T"
: ps. ( f -- ) PREDICATE DUP ONTRUE SUCCEEDS . ; \ ������ ������� ���������� ��������
: pns. ( f -- ) PREDICATE NOT: DUP ONTRUE -NOT SUCCEEDS . ; \ ������� �������� ���������� ��������

: bool PRO *> TRUE <*> FALSE <* CONT DROP ;
: check bool *> CR DUP . ." notF=" notF <*> CR DUP . ." notT=" notT <*> CR DUP . ." ps.=" ps. <*> CR DUP . ." pns.=" pns. <* ;


: alter PRO
*> S" first" <*> S" second" <*
TYPE SPACE ;
$> alter

: firstInAlter PRO CUT:
*> S" first" <*> S" second" <* -CUT
TYPE ;
$> firstInAlter

\ ������� ���� ����������� ������������ AMONG  ...  EACH  ...  ITERATE
: SUBSETS
    AMONG   *> 1 <*> 2 <*> 5 <*   \ ��������� �� ����� �� ������� 1,2,5
    EACH    *> <*> DROP <*      \ ����� ������� � ���������, ����� ��� ����
                            \ DROP ������� ��-� ��������� �� �����
    ITERATE
        CR STACK. ;        \ ����������� ���� � ����� ������

\ ������� ���� �����������, �� ������ Dynamically Structured Codes
\ http://dec.bournemouth.ac.uk/forth/euro/ef99/gassanenko99b.pdf
: el  R@ ENTER DROP ;
: .{} CR ." { " BACK ." } " TRACKING   STACK DUP COUNT TYPE SPACE ;
: subsets C" first" el C" second" el C" third" el .{} ;
$> subsets
\ 02-05-2003 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ��������� � ���������� ��������� ���������� �������������� �����

\ �������� ��� ��� 4.17 - ��� ������ ���������� ������ �������������� 
\ spf_print.f � .\src\compiler. ������������ ��� ���� �� ��� 4.16
\ ---------------------------------------------------------------------------

          1024 CONSTANT #PAD    \
      10 CELLS CONSTANT #Enters \

\ ������ �����
USER SPD       			\ pad stack depth
USER-CREATE SPAD        ( #Enters) 10 CELLS     TC-USER-ALLOT

\ ������� ���������� �������������� - ����������� ����� PAD
USER-CREATE SYSTEM-PAD   4096 TC-USER-ALLOT

USER-CREATE PAD         ( #PAD   ) 1024         TC-USER-ALLOT

(  #PAD ) 1024
  CELL -- 'HLD
  CELL -- 'BASE
       CONSTANT #PADREC

: SDROP ( -- ) SPD @ CELL - 0 MAX SPD ! ;

: >SPAD ( a-addr --> ) CELL SPD +!   SPD @ SPAD + ! ;

: @BASE ( -- BASE ) SPD @ SPAD + @ 'BASE @ ;
: P-Off ( a-addr -- ) 'HLD DUP ! ;

    : CurrentPAD   ( -- a-addr ) SPD @ SPAD + @ ;

\ ---------------------------------------------------------------------------

    : HLD   ( --> ) CurrentPAD 'HLD ;

    : {#  ( D BASE --> D ) >R
          #PADREC ALLOCATE IF ABORT THEN

          DUP >SPAD
          DUP P-Off
              'BASE R> SWAP ! ;

    : #}  ( D --> D ASC # )
          HLD DUP @ TUCK - PAD SWAP   2DUP 2>R   CMOVE 2R>
          CurrentPAD FREE IF 0 SPD ! ABORT ELSE SDROP THEN ;

    : HOLD  ( C -- ) HLD @ [ 0 CHAR+ ] LITERAL -  DUP HLD !   C! ;
    : HOLDS ( ASC # -- ) HLD @ OVER -   DUP HLD !   SWAP CMOVE ;

    : SIGN  ( N -- ) 0< IF [CHAR] - HOLD THEN ;


    : >DIGIT ( N --> Char ) DUP 10 > IF 7 + THEN 48 + ;

    : #     ( D -- D ) 0 @BASE UM/MOD >R @BASE UM/MOD R> ROT >DIGIT HOLD ;

    : #S    ( D -- 0.0 ) BEGIN # 2DUP D0= UNTIL ;

USER places

    : $     ( D -- Char ) @BASE UM* >DIGIT ;

    : $S    ( N -- )
            places @
            IF $ OVER IF -1 places +! SWAP RECURSE ELSE NIP THEN
             ELSE DROP RDROP
            THEN HOLD ;

\ ---------------------------------------------------------------------------

USER BASE

    : HEX     16 BASE ! ;
    : DECIMAL 10 BASE ! ;
DECIMAL

    : <#  ( D -- ) BASE @ {# ;
    : #>  ( D -- ASC # ) #} 2SWAP 2DROP ;

\ ---------------------------------------------------------------------------

: D. ( d -- ) \ 94 DOUBLE
\ ������� d �� ������� � ��������� �������.
  DUP >R DABS <# #S R> SIGN #>
  TYPE SPACE
;

: . ( n -- ) \ 94
\ ���������� n � ��������� �������.
  S>D D.
;

: U. ( u -- ) \ 94
\ ���������� u � ��������� �������.
  U>D D.
;

: .0
  >R 0 <# #S #> R> OVER - 0 MAX DUP
    IF 0 DO [CHAR] 0 EMIT LOOP
    ELSE DROP THEN TYPE
;

: .TO-LOG ( n -- )
\ ���������� n � ��������� ������� � ���-����
  S>D DUP >R DABS <# BL HOLD #S R> SIGN #> TO-LOG
;

: >PRT
  DUP BL U< IF DROP [CHAR] . THEN
;

: PTYPE
  0 DO DUP C@ >PRT EMIT 1+ LOOP DROP
;

: DUMP ( addr u -- ) \ 94 TOOLS
  DUP 0= IF 2DROP EXIT THEN
  BASE @ >R HEX
  15 + 16 U/ 0 DO
    CR DUP 4 .0 SPACE
    SPACE DUP 16 0
      DO I 4 MOD 0= IF SPACE THEN
        DUP C@ 2 .0 SPACE 1+
      LOOP SWAP 16  PTYPE
  LOOP DROP R> BASE !
;

: (.") ( T -> )
  COUNT TYPE
;
' (.") TO (.")-CODE

: DIGIT ( C, N1 -> N2, TF / FF )
\ N2 - �������� ������ C ���
\ ����� � ������� ��������� �� ��������� N1
   SWAP
  DUP 58 <
      OVER 47 > AND
      IF \ within 0..9
         48 -
      ELSE
         DUP 64 >
         IF
           DUP 96 > IF 87 ELSE 55 THEN -
         ELSE 2DROP 0 EXIT THEN
      THEN
   TUCK > DUP 0= IF NIP THEN
;

: >NUMBER ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) \ 94
\ ud2 - ��������� �������������� �������� ������, �������� c-addr1 u1,
\ � �����, ��������� ����� � BASE, � ����������� ������ � ud1 �����
\ ��������� ud1 �� ����� � BASE. �������������� ������������ �����
\ ������� �� ������� ���������������� �������, ������� ������� "+" � "-",
\ ��� �� ������� �������������� ������.
\ c-addr2 - ����� ������� ��������������� ������� ��� ������� �������
\ �� ������ ������, ���� ������ ���� ��������� �������������.
\ u2 - ����� ����������������� �������� � ������.
\ ������������� �������� ���������, ���� ud2 ������������� �� �����
\ ��������������.
  BEGIN
    DUP
  WHILE
    >R
    DUP >R
    C@ BASE @ DIGIT 0=     \ ud n flag
    IF R> R> EXIT THEN     \ ud n  ( ud = udh udl )
    SWAP BASE @ UM* DROP   \ udl n udh*base
    ROT BASE @ UM* D+      \ (n udh*base)+(udl*baseD)
    R> 1+ R> 1-
  REPEAT
;

: ANSI>OEM ( addr u -- addr u )
  DUP ROT ( u u addr )
  PAD SWAP CharToOemBuffA DROP
  PAD SWAP
;
: OEM>ANSI ( addr u -- addr u )
  DUP ROT ( u u addr )
  PAD SWAP OemToCharBuffA DROP
  PAD SWAP
;

: SCREEN-LENGTH ( addr n -- n1 ) \ ��������-�����
\ ���� ����� ������ ��� ������ (��� ������)
\  - ����� ���������, ������� ������ ������ �� ������.
\ addr n  - ������. n1 ����� ��������� �� �����.
  0 -ROT OVER + SWAP ?DO
    I C@ 9 = IF 3 RSHIFT 1+ 3 LSHIFT
    ELSE 1+ THEN
  LOOP
;

\EOF

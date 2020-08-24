\ 20.Jan.2007 Sat 14:13 ruv
\ $Id: exc-dump.f,v 1.10 2007/07/26 17:25:09 ruv Exp $
( ���������� ���� ������ ���������� ����������:
  - ���������� � ������� ��������� ��������,
  - ����������� ��������� ���������� �������� ESP �� ������ ����������,
  - ��������� �������� �������������� ����������, ������������ � AT-EXC-DUMP.

  ������ ���������� ������ WordByAddr, 
  ������������� ENUM-STORAGES, ������ <EXC-DUMP> �� EXC-DUMP2

  ���������� ����� storage.f
)

REQUIRE NEW-STORAGE  ~pinka/spf/storage.f
REQUIRE [UNDEFINED] lib/include/tools.f

[DEFINED] AT-EXC-DUMP [IF] \EOF [THEN]


[UNDEFINED] FOR-WORDLIST [IF]
: FOR-WORDLIST  ( wid xt -- ) \ xt ( nfa -- )
  SWAP @ BEGIN  DUP WHILE ( xt NFA ) 2DUP 2>R SWAP EXECUTE 2R> CDR REPEAT  2DROP
;
[THEN]

MODULE: exc-dump-support

REQUIRE BIND-NODE ~pinka/samples/2006/lib/plain-list.f

USER STORAGE-LIST \ ������ ��������, ��������� �������

: excide-this ( -- ) \ ��������
  STORAGE-ID STORAGE-LIST FIND-LIST IF UNBIND-NODE DROP THEN
;
: enroll-this ( -- ) \ �������
  excide-this
  0 , HERE STORAGE-ID , STORAGE-LIST BIND-NODE
;

..: AT-FORMATING         enroll-this  ;..
..: AT-STORAGE-DELETING  excide-this  ;..

: (WITHIN-STORAGE) ( xt h -- xt ) \ for inner purpose only
  \ OVER DISMOUNT 2>R MOUNT EXECUTE 2R> MOUNT
  OVER STORAGE @ 2>R STORAGE ! CATCH R> STORAGE ! THROW R>
;

EXPORT

: ENUM-STORAGES ( xt -- ) \ xt ( h -- )
  >R FORTH-STORAGE R@ EXECUTE
  R> STORAGE-LIST ENUM-VALUES
;

DEFINITIONS

: WITHIN-STORAGES ( xt -- ) \ xt ( -- ) \ for inner purpose only
  ['] (WITHIN-STORAGE) ENUM-STORAGES DROP
;

: (NEAREST1) ( 0|nfa1 addr nfa2 -- 0|nfa1|nfa2 addr )
  DUP 0= IF DROP EXIT THEN
  \ ���������� xt (������ ������ ����, cfa @)
  >R OVER DUP IF NAME> THEN 1- OVER
  R@ NAME> 1- WITHIN IF NIP R> SWAP EXIT THEN RDROP
  \ 1- �.�. WITHIN ������� �����
;
: (NEAREST2) ( wid -- )
  ['] (NEAREST1) FOR-WORDLIST
;
: (NEAREST3) ( -- )
  ['] (NEAREST2) ENUM-FORTH-VOCS
;
: (NEAREST4) ( nfa1|0 addr -- nfa2|0 addr )
  ['] (NEAREST3) WITHIN-STORAGES
;

EXPORT

WARNING @  WARNING 0!

: NEAR_NFA ( addr -- nfa|0 addr )
  0 SWAP (NEAREST4)
;
: (WordByAddr) ( addr -- c-addr u )
  0 SWAP (NEAREST4)
  OVER 0= IF 2DROP S" <?not in the image>" EXIT THEN
  OVER - ABS 4096 U< IF COUNT EXIT THEN
  DROP S" <?not found>"
;
: WordByAddr ( addr -- c-addr u )
  ['] (WordByAddr) CATCH  ?DUP IF ."  EXC:" . DROP S" <?nested exception>" EXIT THEN
  255 UMIN
;

: STACK-ADDR. ( addr -- addr )
  DUP U. ." :  "
  DUP ['] @ CATCH IF DROP EXIT THEN
  DUP U. WordByAddr TYPE CR
;

WARNING !

: AT-EXC-DUMP ( -- ) ... ;

: EXC-DUMP2 ( exc-info -- ) 
  \ ��. �������������� ���������� � ������ SPF3 � SPF4.
  IN-EXCEPTION @ IF DROP EXIT THEN   TRUE IN-EXCEPTION !  BASE @ >R HEX

  ." EXCEPTION! "
  DUP @ ."  CODE:" U.
  DUP 3 CELLS + @ ."  ADDRESS:" DUP U.  ."  WORD:" WordByAddr TYPE SPACE

  ."  REGISTERS:"

  ( DispatcherContext ContextRecord EstablisherFrame ExceptionRecord  ExceptionRecord )
  DROP 2 PICK
  [ 8 CELLS 80 + \ FLOATING_SAVE_AREA
    11 CELLS +   \ ����� ����������� �������� � ���������, ������� � edi
  ] LITERAL + \ ���������� �������� ������ ������ ��������� (~ygrek)

  DUP 12 CELLS DUMP CR

  ." USER DATA: " TlsIndex@ U. ." THREAD ID: " 36 FS@ U.
  ." HANDLER: " HANDLER @ U. CR
  ." STACK: "
  DUP 6 CELLS + @ ( ebp )
  DUP 5 CELLS + BEGIN DUP ['] @ CATCH IF DROP ELSE 8 .0 SPACE THEN CELL- 2DUP U> UNTIL 2DROP
  ." ["
  DUP 5 CELLS + @ ( eax ) 8 .0 ." ]" CR

  ." RETURN STACK:" CR
  HANDLER @ DUP 0= IF DROP R0 @ THEN ( up-border ) >R
  6 CELLS + DUP @  SWAP  4 CELLS + @ ( a1 a2 )
  \ ����� ��������� ����� � up-border:
  2DUP U> IF SWAP THEN ( min max ) DUP R@ U< IF NIP ELSE DROP THEN ( low-border ) R>
  ( low-border up-border )
  2DUP U< IF OVER 25 CELLS + UMIN SWAP ELSE 2DROP R0 @ DUP 50 CELLS - THEN
  ( up low )
  BEGIN 2DUP U< 0= WHILE STACK-ADDR. CELL+ REPEAT 2DROP

  AT-EXC-DUMP
  ." END OF EXCEPTION REPORT" CR
  R> BASE !  FALSE IN-EXCEPTION !
;

' EXC-DUMP2 TO <EXC-DUMP>

;MODULE
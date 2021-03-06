WARNING 0!

VOCABULARY Sheduler
ALSO Sheduler DEFINITIONS

REQUIRE SYSTEMTIME lib/include/facil.f

: UNIT ( n -- )
\ ( n ) UNIT <name>
\ ᮧ����� ������� ����७�� <name>, ᮮ⢥�����饩 ��� n
\ <name> ( k -- k*n )
  CREATE , DOES> @ * ;


VOCABULARY TimeUnits
\ ������� ����७�� �६���
ALSO TimeUnits DEFINITIONS

1 UNIT ms
1000 ms UNIT sec
60 sec UNIT min
60 min UNIT hour

PREVIOUS DEFINITIONS

: GetDayTimeSMH ( -- sec min hour )
\ ⥪�饥 �६�
  TIME&DATE ( -- sec min hr day mt year )
  DROP DROP DROP
;

: SMH>Time ( sec min hour -- t )
\ ��ॢ�� �६��� � ��
  [ ALSO TimeUnits ]
    hour
    SWAP min +
    SWAP sec +
  [ PREVIOUS ]
;

: GetDayTime ( -- t )
\ ⥪�饥 �६� � ��
  GetDayTimeSMH
  SMH>Time
;

: TimeTo ( t1 t2 -- t3 )
\ �६��� �� t1 �� t2 � ��
  SWAP -
  DUP 0< IF
    [ ALSO TimeUnits ]
      24 hour +
    [ PREVIOUS ]
  THEN
;

: WaitFor ( t -- )
\ ��� �६��� t ��
  GetDayTime SWAP TimeTo PAUSE
;

0 VALUE thru
\ ���ࢠ� ����� �믮������� ����室���� ����⢨�.
0 VALUE hour
0 VALUE min
VARIABLE WaitTime

VOCABULARY Interface
\ ��������� ����䥩�:
\ do
\   ...
\ thru 5 sec
\
\ do
\   ...
\ every day at 12 hour 34 min
\ and
\ every hour at 34 min
\ ����� ���� do ... thru|every � and every|thru �।�⠢��� ᮡ�� ��⮪

ALSO Interface DEFINITIONS

\ VOCABULARY Commands
\ ᫮�� ��� ������ do ... thru|every
\ ALSO Commands DEFINITIONS
\ PREVIOUS
\ : ." POSTPONE ." ; IMMEDIATE
\ DEFINITIONS

VARIABLE do-xt
: do
  :NONAME
\  GET-ORDER
\  ONLY Commands
\  ALSO Interface
; IMMEDIATE

: end ( -- xt )
  STATE @ IF
\    SET-ORDER
    POSTPONE ;
    DUP do-xt !
  ELSE
    do-xt @
  THEN
;

: thru ( -- )
  end
  >R
  GET-ORDER
    ONLY TimeUnits 0 PARSE EVALUATE
    TO thru
  SET-ORDER
  :NONAME
  POSTPONE BEGIN
  R> POSTPONE LITERAL
  POSTPONE EXECUTE
  thru POSTPONE LITERAL
  POSTPONE PAUSE
  POSTPONE AGAIN
  POSTPONE ;
  TASK 0 SWAP START DROP
; IMMEDIATE

VOCABULARY everyVOC
ALSO everyVOC DEFINITIONS

: day ( min hour -- sec min hour )
  0 ROT ROT
;

: hour ( min hour -- sec min hour )
  DROP >R
  GetDayTimeSMH SWAP
  R@ < 0= IF
    1+
  THEN
  NIP
  0 SWAP
  R> SWAP
;

: min ( min hour -- sec min hour )
  2DROP
  GetDayTimeSMH ROT DROP
  SWAP 1+
  SWAP 0 ROT ROT
;

PREVIOUS DEFINITIONS

: every
  end >R
  GET-ORDER
  ONLY everyVOC
  ' WaitTime !
  SET-ORDER
  0 PARSE EVALUATE
  :NONAME
  POSTPONE BEGIN
  min POSTPONE LITERAL
  hour POSTPONE LITERAL
  WaitTime @ POSTPONE LITERAL
  POSTPONE EXECUTE
  POSTPONE SMH>Time
  POSTPONE WaitFor
  R> POSTPONE LITERAL
  POSTPONE EXECUTE
  1000 POSTPONE LITERAL
  POSTPONE PAUSE
  POSTPONE AGAIN
  POSTPONE ;
  TASK 0 SWAP START DROP
; IMMEDIATE

: WaitTime WaitTime ;

VOCABULARY SetTime
ALSO SetTime DEFINITIONS
PREVIOUS

: hour ( hour -- ) TO hour ;

: min ( min -- ) TO min ;

DEFINITIONS

: at
  GET-ORDER
  ONLY SetTime 0 PARSE EVALUATE
  SET-ORDER
;

PREVIOUS DEFINITIONS
PREVIOUS DEFINITIONS

\ \EOF

ALSO Sheduler Interface

do
  ." 2"
thru 2 sec

do
  ." 5"
thru 5 sec

do ." minute" every min

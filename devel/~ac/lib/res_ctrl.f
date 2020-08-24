( �������� ������������ �������� �� ����-�������� )
( Andrey Cherezov, 02.05.2001 )

WINAPI: GetCurrentThreadId KERNEL32.DLL
100000 VALUE RSIZE
VARIABLE RES-MUT
0 VALUE RTABLE

VECT vvWAIT
VECT vvRELEASE-MUTEX
VECT vvCREATE-MUTEX
' NOOP TO vvWAIT
' NOOP TO vvRELEASE-MUTEX
' DROP TO vvCREATE-MUTEX

0
CELL -- R_TYPE
CELL -- R_ID
CELL -- R_THREAD
CELL -- R_FROM
CONSTANT /R_SIZE

CREATE RRES HERE /R_SIZE DUP ALLOT ERASE

: FIND-FREE-RES ( -- addr flag )
  RTABLE DUP RSIZE + SWAP DO
    I R_TYPE @ 0= IF I UNLOOP TRUE EXIT THEN
  /R_SIZE +LOOP HERE FALSE
;
: +RES ( handle type -- )
  -1 RES-MUT @ vvWAIT 2DROP
  FIND-FREE-RES 
  IF >R
    R@ R_TYPE ! R@ R_ID !
    RP@ CELL+ CELL+ @ R@ R_FROM !
    GetCurrentThreadId R> R_THREAD !
  ELSE DROP ." +RES ERROR" THEN
  RES-MUT @ vvRELEASE-MUTEX DROP
;
: -RES ( handle type -- )
  -1 RES-MUT @ vvWAIT 2DROP
  RTABLE DUP RSIZE + SWAP DO
    2DUP I R_TYPE @ = SWAP I R_ID @ = AND
\    I R_THREAD @ GetCurrentThreadId = AND
    IF I /R_SIZE ERASE LEAVE THEN
  /R_SIZE +LOOP
  2DROP
  RES-MUT @ vvRELEASE-MUTEX DROP
;
: INIT-RTABLE
  S" ESERV2_RES" FALSE vvCREATE-MUTEX DROP RES-MUT !
  RSIZE ALLOCATE THROW TO RTABLE
  RTABLE RSIZE ERASE
;
: DUMP-RES ( -- )
  -1 RES-MUT @ vvWAIT 2DROP
  RTABLE DUP RSIZE + SWAP DO
    I R_TYPE @ ?DUP
    IF COUNT TYPE SPACE I R_ID @ . I R_THREAD @ . I R_FROM @ vWordByAddr TYPE CR THEN
  /R_SIZE +LOOP
  RES-MUT @ vvRELEASE-MUTEX DROP
  ." -----------------------------------" CR
;

CREATE FILE_RES C" FILE_RES" ",

: OPEN-FILE
  OPEN-FILE DUP 0= IF OVER FILE_RES +RES THEN
;
: CREATE-FILE
  CREATE-FILE DUP 0= IF OVER FILE_RES +RES THEN
;
: CLOSE-FILE
  DUP IF DUP FILE_RES -RES THEN
  CLOSE-FILE
;
: INCLUDE-FILE
  DUP >R INCLUDE-FILE
  R> FILE_RES -RES
;

(
INIT-RTABLE
S" test111" R/W CREATE-FILE . CR
S" test112" R/W CREATE-FILE . CR
DUMP-RES
CLOSE-FILE . CR
DUMP-RES
CLOSE-FILE . CR
DUMP-RES
)
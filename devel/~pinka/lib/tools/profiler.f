\ �������������. �� ver 0.3 �� ��������

\ �������� ������� ���������� ���� (profiler).  SPF3.70
\ example - � �����.

\ history
\ 11.1999,,, 02.2000
\ 06.07.2000  ver 0.1
\    - ������ ��� debug �� profile 
\    - ���� LAST @ ,������ LATEST (***) ( ����� � locals.f ��������� �������� � ������.)
\      / profiler.f ������ ����������� �� locals.f, ����� ������� ��� ���� � ���������� ����������� /
\    - ������� ������ ����  � ��������
\    - ����� ����������
\    - ���� 0 �������, �� �� ������� ������ ��� ����� �����.
\ 27.11.2000   ver 0.2
\    - ������� �� ��������� �������. ���������� ������������ ����������� � ������������.

\ 12.03.2001   ver 0.3
\    * ���� THROW  - ������� �������� timer-info �������� �����.
\    * �������� ��������� timer-info - ����� last_timer_info

\ 19.Nov.2002 Tue 01:02
\    * �������� ������ � ����� DU< 
\     see:
\        From: mlg 3 <m_l_g3@yahoo.com>
\        To: spf-dev@lists.sourceforge.net
\        Date: Sat, 9 Nov 2002 10:05:16 -0800 (PST)
\ 11.Dec.2003 Thu 11:17  * GetTimes ��������� ������: ( a u -- ... )

\ Copyright (C) R.P., 1999-2002

\  profile on    - �������� ���������� ���� �������  ( �� ��� ����. ����� �������� ������  )
\  profile off   - ��������� ���������� ���� ������� ( �� ��� ����. ����� ������ �� ��������)
\  timer on/off  - ���� ���������, �� ������ �� ��������������.
\  ResetProfiles - �������� ����������.
\  .AllStatistic - ���������� ���������� �� ������� ���������� ������� �����
\  ������  
\      Calls      Ticks      AverageTicks  Name     (Rets)
\ ���
\  Calls        - ���������� �������
\  Ticks        - ����� ����� ������ �����
\  AverageTicks - ������� ����� �� �����
\  Name         - ���
\  (Rets)       - ����� ��������������� ���������, ���� ��� ����������
\                 �� ����� �����. ��������� � ������� ����� ��������� ������ 
\                 �� ��������������� �������.
\                 ������ ����������� �� EXIT , THROW , ";"

\ ������ ��������� �� ������������� � ��������������� � ��������.
\ �.�. ���� ����� � ��������  ����� ���������  ���������� ��� �����
\ �������� ������������ � ������ �������, ��  ���������� ��� ����� ����� ����� 
\ �� �����.

\ �������������� ��������, ���� �������� profile �������� 
\ � �������� ���������� �����  � off  ��  on
\ �.�. �������� profile ����� �� ������ �� ����� ���������� ����� :)
\  ( ��������, �������������������  [ profile on ]   )

\ �������� AverageTicks  �������� DWORD. 
\ ���� ��������� �� �������, �� ��������� '-'
\ ��� ����� ���������, ���� ������� ����� ���������� �������� ~14 ��� ( �� 300 ���)
\ ( ���� �� ���� ����� D* D/ �� �� ���� �� ����� �����������  ;)
 

REQUIRE [DEFINED] lib\include\tools.f
REQUIRE U.R       lib\include\CORE-EXT.F
REQUIRE UD.RS     ~pinka\lib\print.f

.( ----- Loading profiler...) CR

: >NAME  ( CFA -- NFA )
    4 -  1- ( ������� �� ���������� ��������� ������ ***) 
    DUP >R  ( a ) \ �� ����� - ����� ���������� ������� �����
    BEGIN  ( a )
        1-  DUP C@   ( a b )
        OVER + R@  =  
    UNTIL   RDROP
;


(  � Pentium'� �������������� ���� ������� ������� RDTSC, ������������ �����
������ ��������� � ������� ������ �� ���� ����������. ��� ���� ������� $0F $31.
������� ���������� ������������� ����� � ��������� EDX:EAX. 
)

[DEFINED] TIMER@ [IF]

: GetTacts  S" TIMER@" EVALUATE ; IMMEDIATE   \ for jp-forth

[ELSE]

: GetTacts  ( -- tlo thi )
( see ~pinka\lib\TOOLS\GenTimer.f  )
[ BASE @ HEX   \ ��� SPF3x
 F  C, 31  C, 83  C, ED  C,
 8  C, 89  C, 55  C, 0  C,
 89  C, 45  C, 4  C,
BASE ! ] ;

[THEN]


VARIABLE profile  \ ����� �� ��������������� ��� ������� ��� ����������� ����.
VARIABLE timer    \ ����� �� ��������� ������ (�����, ������, ���).


: on  ( a -- )  -1 SWAP ! ;
: off ( a -- )   0! ;

\ - - - - -
 timer  on
 profile off
\ - - - - -

 VOCABULARY vocProfiler
 ALSO vocProfiler DEFINITIONS



0 VALUE List-First   \ ������ ������. ( ������� �� ������� ������������ � ������ � ����������)
0 VALUE List-Last    \ ��������� �������.


\ =============================================
\ �����������  �������

\ 5 CONSTANT offset1  \ �������� ����� HERE ����� ������������ ����� � NFA ����� �����
\ HEX F0F0F0F0 DECIMAL  CONSTANT timer-id  \ ������������� ����� � ��������.
HEX 56FAC6E3 DECIMAL  CONSTANT timer-id  \ ������������� ����� � ��������.


\ ��������� ������ ��� ������� �������������� �����.

  0
  4 -- id           \ = timer-id
  4 -- ^name         \ c-addr of word name
  8 -- ticks        \ �������� ������� ����������
  4 -- count-in     \ ������� ������
  4 -- count-out    \ ������� �������
  8 -- time-curr    \ ��������� ��� �����
  4 -- next         \ �������� � ������.
CONSTANT /timer_info


WORDLIST CONSTANT shadows

: article  ( -- a-timer_info ) \ name -- name 
( ������� ��������� ������ � timer_info )

  WARNING @  WARNING 0!
  GET-CURRENT  shadows SET-CURRENT
  >IN @  CREATE  
         LATEST >R
  >IN !
  SET-CURRENT
  WARNING !

  HERE
  /timer_info ALLOT  DUP /timer_info ERASE
  R> OVER ^name !  >R ( R: a-timer_info )
  timer-id  R@ id !

    List-Last IF
      R@ List-Last next !
      R@ TO List-Last
    ELSE
      R@ TO List-First
      R@ TO List-Last
    THEN
  RDROP
;

: timer_info ( a u -- a-timer_info | 0 )
\  DUP ID. CR
\ ��� �������� ����� ����� ������ ��������� �������.
  shadows SEARCH-WORDLIST
  IF EXECUTE ELSE 0 THEN
;

: last_timer_info  ( --  a-timer_info )
   shadows @ \ nfa last in shadows
   ?DUP IF NAME> EXECUTE  EXIT THEN
   ." address of timer_info = 0 " ABORT
;

: start-timer ( a-timer_info -- )
    timer @ 0= IF DROP EXIT THEN
    >R  GetTacts  R@ time-curr  2!
    R> count-in 1+!
;

: stop-timer  ( a-timer_info -- )
    timer @ 0= IF DROP EXIT THEN
    DUP >R time-curr 2@ DNEGATE  GetTacts D+
    R@ ticks 2@ D+  R@ ticks 2!  R>  count-out 1+!
;

: have-timer ( a u -- a-timer_info true | false )
    timer_info  ?DUP 0<>
;

\ |||||||||||||||||||||||||||||||
: (THROW)   ( ior  a -- )
    OVER IF stop-timer ELSE DROP THEN
;

: :: : ;
\ |||||||||||||||||||||||||||||||

\ ==========================================


: .border ( -- )
  SPACE [CHAR] | EMIT SPACE
;

: .ticks ( a-timer_info -- )
  ticks 2@  16 UD.RS  .border
;
: .calls ( a-timer_info -- )
  count-in  @  10  U.RS  .border
;
: .rets ( a-timer_info -- )
  count-out  @  ." ( " 10  U.R  ."  )"
;
: .name ( a-timer_info -- )
   ^name @
   DUP ID. SPACE
   ?IMMEDIATE  IF ." - Imed " THEN
;

: DU< ( d1 d2 -- f ) ( d1_lo d1_hi d2_lo d2_hi -- f )
\  ROT SWAP U> IF 2DROP FALSE EXIT THEN
\  U<
   ROT 2DUP = IF 2DROP U< ELSE U> NIP NIP THEN
;

: .average ( a-timer_info -- )
  >R
  R@ count-out @ DUP IF  ( n )
\     R@ ticks 2@ ROT  UM/MOD NIP

     R@ ticks 2@ ROT >R  ( R: n )
     2DUP R@ -1 UM* DU< 0= IF
       RDROP
       2DROP 13 SPACES ." -" .border RDROP EXIT
     THEN
       R> UM/MOD NIP
     
  THEN    14 U.RS  .border
  RDROP 
;

: .title  ( -- )
  CR  ."  Calls       Ticks              AverageTicks     Name     (Rets)"
;

: .result ( a-timer_info -- )
    DUP count-in  @ 0= IF DROP EXIT THEN \ ����� �� ���� ������ �� ���������� ����.
    CR
    DUP .calls
    DUP .ticks
    DUP .average
    DUP .name
    DUP count-in @  OVER count-out @ <>  
    IF DUP .rets THEN
    DROP
;


VARIABLE 'named?  \ ������, �������� ����:  ���� �� � ���������� ����������� ���.

 PREVIOUS DEFINITIONS   
 ALSO vocProfiler

\ ================================================================
\ Public - ������.

: GetTimes  (  a u -- d-ticks u-rets  true | false )
    have-timer IF
      DUP >R
        ticks 2@
      R> count-out  @
      TRUE  EXIT
   THEN  FALSE
;

: ResetProfiles  ( -- )
  List-First
  BEGIN
  DUP WHILE >R
    0 0  R@ ticks     2!
    0    R@ count-in  ! 
    0    R@ count-out !
    0 0  R@ time-curr 2!
    R> next @
  REPEAT DROP
;


\ ---------------------------------------------------------------
\ ����� ��� ����������

\ ������ �������. ������ ����� � �������� �� ��������������.
\ ( ����� ��������� ���������� �������� )
: .AllStatistic_o ( -- )  
  .title
  GET-ORDER
  0 DO
    @
    BEGIN  ( NFA )
      DUP 0 <>
    WHILE
      DUP COUNT have-timer IF
        .result
      THEN  CDR
    REPEAT  DROP
  LOOP CR
;

\ ����� �������. ������� ���  �� ������.
: .AllStatistic ( -- )
  .title
  List-First
  BEGIN
  DUP WHILE
    DUP .result
    next @
  REPEAT DROP CR
; ( � ver 0.2 ��� ����� ��� ������ ������� ForEach-Word
�� ������ ����� next ������� � ���������� � ������� ������, 
����� �� ��������... ;)


: .StatisticByCFA ( CFA_last_word -- )  \ 
  .title
    >NAME
    BEGIN  ( NFA )
      DUP 0 <>
    WHILE
      DUP COUNT have-timer IF  ( NFA a-timer_data  )
        .result
      THEN  CDR
    REPEAT  DROP  CR
;


\ ---------------------------------------------------------------
\ ��������������� ����, ���������� �� ����� � �������.

: EXIT
    profile @  IF    ( LAST @  timer_info)  last_timer_info
        POSTPONE LITERAL   POSTPONE stop-timer
    THEN
    POSTPONE EXIT
; IMMEDIATE


: THROW  ( errno -- )
    STATE @ 0= IF  THROW EXIT THEN
    profile @  IF
          last_timer_info
          POSTPONE LITERAL   POSTPONE (THROW)
    THEN 
    POSTPONE THROW
; IMMEDIATE

: : ( -- )
 profile @  IF
    article
    :  \ <== Attention!
    last_timer_info   POSTPONE LITERAL
    POSTPONE start-timer
    'named? on
    EXIT
 THEN :
;

:: ; ( -- )  
    profile @  IF
        'named? @ IF \ ����� ���������� :NONAME 
          last_timer_info
          POSTPONE LITERAL   POSTPONE stop-timer
          'named? off
        THEN
    THEN
    POSTPONE ;
; IMMEDIATE

 PREVIOUS

 profile on

.( ----- Profiler loaded and turned on.) CR

\ ---------------------------------------------------------------
\ Example
\ : test  ( -- )
\   ResetProfiles  t1 .AllStatistic  KEY DROP  
\   ResetProfiles  t2 .AllStatistic  KEY DROP
\ ;


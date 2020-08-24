\ $Id: weather.f,v 1.9 2008/12/21 15:17:40 ygreks Exp $
\ ������ �� http://www.gismeteo.ru

REQUIRE HEAP-ID ~pinka/spf/mem.f
REQUIRE XSLT ~ac/lib/lin/xml/xslt.f
REQUIRE $Revision: ~ygrek/lib/fun/kkv.f
REQUIRE replace-str- ~pinka/samples/2005/lib/replace-str.f
REQUIRE /STRING lib/include/string.f
REQUIRE FileLines=> ~ygrek/lib/filelines.f
REQUIRE HASH! ~pinka/lib/hash-table.f
REQUIRE LAMBDA{ ~pinka/lib/lambda.f
REQUIRE FINE-HEAD ~pinka/samples/2005/lib/split-white.f
REQUIRE UPPERCASE ~ac/lib/string/uppercase.f
REQUIRE %[ ~ygrek/lib/list/all.f
REQUIRE OCCUPY ~pinka/samples/2005/lib/append-file.f
REQUIRE list-ext ~ygrek/lib/list/ext.f
REQUIRE logger ~ygrek/lib/log.f
REQUIRE mtq ~ygrek/lib/multi/queue.f

( testing
0 VALUE ?check
: S-REPLY TYPE CR ;
: STR-REPLY STYPE CR ;
: STR-SAY STYPE CR ;
: current-msg-sender S" dsds" ;
: AT-CONNECT ... ;
\ )

MODULE: bot_plugin_gismeteo

0 VALUE h
0 VALUE q_

: SKIP-NAME PARSE-NAME 2DROP ;

: parse-city-code-name ( a u a1 u1 a2 u2 -- )
   [CHAR] ; PARSE
   [CHAR] ; PARSE
   [CHAR] ; PARSE
   -1 PARSE 2DROP ;

: load-city-codes ( a u -- )
   FileLines=> DUP STR@
    LAMBDA{
     parse-city-code-name ( a u a u a u )
     2DUP UPPERCASE
     2>R 2OVER 2R> h HASH!
     2DUP UPPERCASE h HASH!
    } EVALUATE-WITH ;

: load-gismeteo-city-codes
   S" plugins/gismeteo.txt"
   2DUP FILE-EXIST 0= IF
    S" http://bar.gismeteo.ru/gmbartlistfull.txt"
    GET-FILE DUP STR@ S" plugins/gismeteo.txt" OCCUPY STRFREE
   THEN
   load-city-codes ;

: find-city-code ( a u -- a u ) >STR DUP STR@ UPPERCASE DUP STR@ h HASH@ ROT STRFREE ;

%[
  %[ " ���" % " ������" % ]% %
  %[ " ���" % " �����-���������" % ]% %
  %[ " ���" % " �����������" % ]% %
]% VALUE short-cities

: short-city ( a u -- a1 u1 )
   short-cities LAMBDA{ list::car STR@ 2OVER COMPARE 0= } list::find
   IF list::cdar STR@ 2SWAP 2DROP ELSE DROP THEN ;

:NONAME 
  S" weather-getter" log_thread
  HEAP-GLOBAL
  DROP { | l }
  BEGIN
   q_ mtq::get -> l
   l list::car STR@ " http://informer.gismeteo.ru/xml/{s}_1.xml" >R
   R@ STR@ S" plugins/frc3.xsl" XSLT ( a u )
   R> STRFREE
   FINE-HEAD
   l list::cdar STR@ l list::cddar STR@ " {s}: ������ � ������ {s} {s}" STR-SAY
   S" BUG: MEMORY LEAK - NEED XSLT FREE" log::debug
   l ['] STRFREE list::free-with
  AGAIN
 ; TASK: getter

EXPORT

\ -----------------------------------------------------------------------

MODULE: BOT-COMMANDS-HELP
: !weather S" Usage: !weather <�����> - ������ �� http://www.gismeteo.ru/" S-REPLY ;
;MODULE

MODULE: BOT-COMMANDS

: !weather
    -1 PARSE FINE-HEAD FINE-TAIL
    DUP 0= IF 2DROP BOT-COMMANDS-HELP::!weather EXIT THEN
    short-city
    2DUP find-city-code
    DUP 0= IF 2DROP 2DROP current-msg-sender " {s}: ��� ������ ������!" STR-REPLY EXIT THEN
    %[ >STR % >STR % current-msg-sender >STR % ]% q_ mtq::put
    TRUE TO ?check
;
: !� !weather ;
: !w !weather ;
: !������ !weather ;

;MODULE

..: AT-CONNECT large-hash TO h mtq::new TO q_ 0 getter START DROP load-gismeteo-city-codes ;..

;MODULE

$Revision: 1.9 $ " -- gismeteo weather plugin {s} loaded." STYPE CR

\ -----------------------------------------------------------------------

\EOF \ testing

AT-CONNECT
S" ���������" find-city-code CR TYPE
BOT-COMMANDS::!weather ����
S" ���" short-city find-city-code CR TYPE

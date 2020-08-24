\ 05.Apr.2004  (p) ruvim@forth.org.ru
\ ��������� ������ � �����, ���������� ����������� (wildcards)  * ?
\ ������ �� ������� ������ ���� ~pinka\lib\mask.f
\ ( �� ��� ���������� ���� ~pig  ;-)

\ ������ ���������� ���������� ����������� ������� SPF4
\ $Id: like.f,v 1.5 2008/05/12 13:21:18 ruv Exp $

\ ����� LIKE � ULIKE ( a u  a-mask u-mask -- flag )
\  ������������  ������ a u  � ������,
\  ���������� TRUE ��� ������
\  � FALSE, ���� ������������� ����������.
\  Wildcards:
\  *  - ����� ���������� ����� ��������
\  ?  - ����� ������
\  \  - ������� "������������" ����������� ��������:
\       \\ -> \
\       \* -> *
\       \? -> ?
\       \q -> " ( ����������� ~pig )
\  �����������: ��� ��������� ������ ���������� ������ � �������� 
\  � ������ ����� ������� ����; ������������ SEARCH � COMPARE

REQUIRE SALLOC      ~pinka/lib/ext/alloc.f 
REQUIRE PARSE-AREA@ ~pinka/lib/ext/parse.f
REQUIRE UPPERCASE   ~ac/lib/string/uppercase.f 

: SEARCH&SKIP ( a u  a-subs u-subs -- a2 u2 true | a u false )
\ ������ � ������  a u  ���������  a-subs u-subs
\ ���� �������, ������� ����� ������ ����� ���������� ������ � true
\ ����� �������  a u false.
    DUP >R   SEARCH         IF
    SWAP R@ +  
    SWAP R@ -       TRUE    ELSE

    FALSE                   THEN
    RDROP
;
: MATCH-SIMPLE ( a u apat upat -- a1 u1 flag )
\ �����������  apat upat  c  a upat
\ ���� ���������, �������  a+upat u-upat true,
\ �����  a u  false
  DUP >R 
  2OVER ROT U< IF 2DROP RDROP FALSE EXIT THEN
  R@ TUCK COMPARE IF RDROP FALSE EXIT THEN
  SWAP R@ + SWAP R> -  TRUE
;

MODULE: WildCardsSupport

CHAR \ VALUE quote-char

\ GetChar ( -- char flag )

: IsCharWild ( c -- flag )
  DUP [CHAR] * = IF DROP TRUE EXIT THEN
  DUP [CHAR] ? = IF DROP TRUE EXIT THEN
  DROP FALSE
;
: NextPat ( -- a u )
\ ���� ��������� �� �������   (� ������� ��)
  GetChar AND IF CharAddr COUNT DUP 1+ >IN +! EXIT THEN
  CharAddr 0
\  CharAddr EndOfChunk IF 0 ELSE COUNT  DUP 1+ >IN +! THEN
;
: GetWild ( -- c true | false )
  GetChar 0= OR IF FALSE EXIT THEN
  CharAddr 1+ C@  TRUE
;
: QMatch ( a u -- a1 u1 f )
\ ������������ � ��������, ���������� '?'
  BEGIN
    NextPat DUP IF
      MATCH-SIMPLE 0= IF FALSE EXIT THEN
    ELSE 2DROP THEN
    GetWild
  WHILE
    [CHAR] ? =
  WHILE
    2 >IN +!
    DUP IF  SWAP 1+  SWAP 1- ELSE FALSE EXIT THEN
  REPEAT THEN TRUE
;
: QMatch2 ( a u -- a1 u1 f )
\ ��� ��������  �������� ��������� �����������
  2DUP PARSE-AREA@ 2>R
  QMatch IF 2SWAP 2DROP RDROP RDROP TRUE EXIT THEN
  2DROP 2R> SOURCE! FALSE
;
: Process(*) ( a u -- a1 u1 flag )
\ ���� �� ���-�������
  NextPat DUP 0= IF 2DROP TRUE EXIT THEN
  2>R
  BEGIN ( a u )
    2R@  SEARCH&SKIP
  WHILE
    QMatch2
    DUP IF EndOfChunk IF DROP DUP 0=  THEN THEN
  UNTIL TRUE ELSE FALSE THEN   RDROP RDROP
;
: Is(*) ( -- f )
  GetWild DUP IF DROP [CHAR] * = THEN
;
: (LIKE-MASK) ( a1 u1 -- a2 u2 flag )
  BEGIN
    Is(*)        IF
    2 >IN +!
    EndOfChunk IF TRUE EXIT THEN
    Process(*)   ELSE
    QMatch       THEN
    0= IF FALSE EXIT THEN
    EndOfChunk
  UNTIL DUP 0=
;

: store-char ( a p c -- a1 p1 )
\ p - ������ �� �������
  >R
  DUP 0= IF ( DROP  0) OVER C!  DUP 1+ SWAP THEN
  SWAP R> OVER C! 1+ SWAP
  DUP 1+!
;
: store-wild ( a p c -- a1 0 )
  >R DROP
  0  OVER C! 1+
  R> OVER C! 1+
  0
;
: ?quote ( c -- c | c2 )
  DUP quote-char = IF DROP
    >IN 1+! GetChar DROP
    DUP [CHAR] q = IF DROP [CHAR] " THEN
  THEN
;
: translate-mask ( -- a u )
\ ��������� �������� ������������� � ������ �� ����������
\ � ����-������� ������������ ����� 0.
  PAD 0
  BEGIN ( a p )
    GetChar
  WHILE ( a p c )
    DUP IsCharWild IF
    store-wild     ELSE
    ?quote
    store-char     THEN
    >IN 1+!
  REPEAT 2DROP
  PAD TUCK -
;
: LIKE-MASK1  ( a1 u1 -- flag ) 
\ ������ within EVALUATE-WITH
\ � PARSE-AREA - �����
  translate-mask SOURCE!
  (LIKE-MASK) NIP NIP
;

EXPORT

: LIKE ( a1 u1 a-mask u-mask -- flag )
  ['] LIKE-MASK1 EVALUATE-WITH
;
: ULIKE ( a1 u1 a-mask u-mask -- flag )
  2SWAP  TUCK SALLOC DUP >R SWAP 2DUP UPPERCASE
  2SWAP  TUCK SALLOC DUP >R SWAP 2DUP UPPERCASE
  LIKE
  R> FREE THROW  R> FREE THROW
;

;MODULE \ WildCardsSupport

 ( example
  S" Zbaabbb777778" S" ?b*7*8" LIKE .
  S" 012WebMaster" S" ???w??mas*" ULIKE .
  S" INBOX" S" INBOX*" ULIKE .
  S" http://blablabla.html?.newshub.eserv.ru/" S" http://*\?.*/"  ULIKE .
\ )

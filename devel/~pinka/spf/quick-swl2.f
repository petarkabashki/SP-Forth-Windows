\ 07.Jan.2004 ruv
\ 14.Feb.2004
\ $Id: quick-swl2.f,v 1.5 2008/06/01 16:59:09 ruv Exp $

( ���������� SPF [������� �� ����������!]
   ��������� ������� ����� �� ������� �� ���� ������������� ���-������.

  ���-������� ��������� �����������, �� SAVE �� �����������.

  �����������:
    ���-������� ������������� � ����� ���� ��������
    [����� �������� HEAP-ID  ~pinka/spf/mem.f]
    �������� ������, ���� �� ������ FREE-WORDLIST �� ������ TEMP-WORDLIST
)
( �������������� FREE-WORDLIST  � MARKER /���� �� ����/
  �������, ������� ���������� quick-swl.f �� ����, 
   ��� ��� ����� ����� ���� ������������ � ������������.
  [ � ��� �����, �� locals.f ]
  
  ��������/�������������/ +SWORD  � �������������� ����� ":" ";"

  �������� ������ SEARCH-WORDLIST - ����� ������ � ����������� �������� SPF
  ���������� ������ "����� �������" � ��������� �������
  ��� �������� ������ �� ������-���������.
)

REQUIRE HEAP-ID     ~pinka/spf/mem.f
REQUIRE [UNDEFINED] lib/include/tools.f
REQUIRE HASH!       ~pinka/lib/hash-table.f 

MODULE: QuickSWL-Support

EXPORT

 256 VALUE #WL-HASH
 \ ������ ���-������ ��� ����� ����������� ��������.
 \ ��� ������������� �� ����� AT-PROCESS-STARTING 
 \   ������ ������ ������� ��� 3*n, ��� n -����� ���� � �������.

DEFINITIONS

0 \ ext header  for wordlist
 1 CELLS -- .hash
 1 CELLS -- .last
 1 CELLS -- .wid
CONSTANT /exth
( exth ����� ���� wid ����� ������� .wid
  � �� wid ����� �������� exth
)

: wid-exth ( wid -- exth )
  3 CELLS +  \ ����������� ������ "����� �������"
  DUP @   DUP IF  NIP EXIT THEN  DROP
  ( ~wid )

  HEAP-ID >R  HEAP-GLOBAL
  /exth ALLOCATE THROW
  SWAP 2DUP !    ( exth ~wid )
  3 CELLS - OVER .wid ! ( exth )
  #WL-HASH  new-hash  OVER !
  R> HEAP-ID!
;
: WL-HASH ( wid -- hash-table )
  wid-exth .hash @
;
( ������, �.�. ������ ������������� ���-������� - ������ ���������� )

USER-VALUE hash

: update-hash ( exth -- )
  >R
  R@ .last  @
  R@ .wid @ @  ( l2 l )
  2DUP = IF 2DROP RDROP EXIT THEN
  \ ���� ������� ���� - 0 0 - ���� �����

  DUP CHAR+ C@ 12 = IF CDR THEN
  2DUP = IF 2DROP RDROP EXIT THEN
  \ �� ��������� ��������� �����, ���� ������ ( by HIDE )

  DUP R@ .last !
  R> .hash @ TO hash

  HEAP-ID >R  HEAP-GLOBAL

  0 >R
  ( l2 l )          BEGIN
  2DUP <>           WHILE
  DUP >R
  CDR DUP 0=        UNTIL THEN 2DROP
  ( )               BEGIN
  R> DUP            WHILE
  DUP COUNT 
  hash HASH!N       REPEAT DROP
  \ ��������� � ���-������� ���� � ��� �� �������, 
  \ � ������� ����� ����������� � �������

  R> HEAP-ID!
;

: update-wlhash ( wid -- )
  wid-exth update-hash
;

: update1-wlhash ( nfa wid -- )
  wid-exth DUP .last @     IF
  HEAP-ID >R  HEAP-GLOBAL
    .hash @    >R
    DUP COUNT  R> HASH!N
  R> HEAP-ID!               ELSE
  \ ����� ��� ��������� ������� ��� ����� �����������
  NIP update-hash           THEN
;


: reduce-hash ( last  wid  -- )
\ ��������� �� ���-������� ����� �� wid @ �� last
\ last ������ ����� ����� � ������� ������� wid
\ ( ��� MARKER ) ( ��� MARKER �� ��������, - 25.Mar.2004 )

  DUP wid-exth ?DUP 0= IF 2DROP EXIT THEN >R
  @ ( l2  l )
  OVER R@ .last  !
  R> .hash @ TO hash

  HEAP-ID >R  HEAP-GLOBAL

  ( l2 l )          BEGIN
  2DUP <>           WHILE
  DUP COUNT hash -HASH
  CDR DUP 0=        UNTIL THEN 2DROP

  R> HEAP-ID!
;

EXPORT

\ SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH

: QuickSWL ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ SWL
  WL-HASH ( c-addr u  h )
  HASH@N            IF
  DUP  NAME> 
  SWAP NAME>F C@
  &IMMEDIATE AND
  IF 1 ELSE -1 THEN ELSE
  0                 THEN
;
( ��� ��������� � MARKER ����� ���� �� � QuickSWL ���������,
   ��� ��������� ����� ��� ����� ���������� ���� ����������� ����� � ������� 
   [ ��� �� ������� HERE ], �� ����� �������� ����� �������� 
   ��� ��������� ������� � �������, �������� �� �� ���������� � ��.
)

: REFRESH-WLHASH ( wid -- )
\ �������� ���-������� ������� (�� ������, ���� ��� ����� ������������..)
\ �������������� ��������, ���� �� ����� ���������� REFRESH-WLHASH 
\  ���������� ����� �� ������� wid.
  DUP
  HEAP-ID >R  HEAP-GLOBAL

  wid-exth DUP
  .last 0!
  .hash @ clear-hash

  R> HEAP-ID!
  update-wlhash
;

: FREE-WORDLIST ( wid -- )
  DUP wid-exth DUP
   ( wid exth exth )
   HEAP-ID >R  HEAP-GLOBAL
     .hash @ del-hash
      FREE THROW
   R> HEAP-ID!

  FREE-WORDLIST
;

[DEFINED] MARKER [IF]

: MARKER
  WARNING @ >R WARNING 0!
    LATEST
    >IN @ >R  MARKER LATEST NAME>  R> >IN ! 
    ( last marker-xt )
    CREATE
     , , GET-CURRENT ,
  R> WARNING !

  DOES> 
    DUP 0 CELLS +  @ EXECUTE
        2 CELLS +  @ REFRESH-WLHASH
;
( ���� ����� ���� ��������������,
  �� ����� reduce-hash  ���������� ������ ��������� �����������..
)
[THEN]

[UNDEFINED] WL-#WORDS [IF]
: WL-#WORDS ( wid -- n )
  0 SWAP
  @     BEGIN
  DUP   WHILE
  SWAP 1+ SWAP
  CDR   REPEAT  DROP
;
[THEN]

DEFINITIONS

: erase-refer ( -- )
\ ( ���������� ERASE-IMPORTS )
\ ���-������� ������������, ����� ������ � ��,
\ ������� ����� ������� �������� ������ �� exth � ���������� ��������
\ ����� �� �������������. �� ���� ��������. 
  VOC-LIST @ BEGIN
  DUP        WHILE
  DUP CELL+ ( a wid )
  3 CELLS + 0!  \ ������ "����� �������"
  @          REPEAT  DROP
;

: update-hashes ( -- )
\ ���������� ���-������� ��� ���� �������� (�� ������ VOC-LIST)
  #WL-HASH >R
  VOC-LIST @ BEGIN
  DUP        WHILE
  DUP CELL+ ( a wid )
    DUP WL-#WORDS 3 *   16 UMAX   TO #WL-HASH
    \ DUP VOC-NAME. SPACE #WL-HASH . CR
  update-wlhash
  @          REPEAT  DROP
  R> TO #WL-HASH
;
( ���������� ���-������� �� ������� ������ � �������
  ������� ������������� ��� ����������������� � ���������������,
  �� ������������.

  ������������� ���������� ���� ������ �������� �� �����������
  �� ������ ������������� ����������...
)

VECT 0SWL  \ ����.-�� ������ QuickSWL  ��� ������� �������..

: 0SWL1 ( -- )
  erase-refer update-hashes
; ' 0SWL1 TO 0SWL

..: AT-PROCESS-STARTING 0SWL ;..

\ -------------------------------

USER LAST-WID

: LastWord2Hash ( -- )
  LAST @ LAST-WID @ update1-wlhash
;
: LatestWord2Hash ( -- )
  LATEST ?DUP IF GET-CURRENT update1-wlhash THEN
;

EXPORT

USER-VALUE NOW-COLON?

: +SWORD2 ( addr u wid -- )
  DUP LAST-WID !

  HERE LAST !
  HERE 2SWAP S", SWAP DUP @ , !

  NOW-COLON?            IF
  FALSE TO NOW-COLON?   ELSE
  LastWord2Hash         THEN
;

: : ( C: "<spaces>name" -- colon-sys ) \ 94
  TRUE TO NOW-COLON?
  :
;
: ;
    POSTPONE ;
    LatestWord2Hash
    ( ���� ���� NONAME, �� ����������� �����, ������� ��� ����
      - �������� �������. )
    FALSE TO NOW-COLON?
; IMMEDIATE



    [DEFINED] +SWORD1                           [IF]
    ' +SWORD2 TO +SWORD                         [ELSE]

    REQUIRE REPLACE-WORD lib/ext/patch.f
    ' +SWORD2 ' +SWORD REPLACE-WORD             [THEN]

0SWL  \ ����.��

    [DEFINED] SEARCH-WORDLIST1                  [IF]
    ' QuickSWL TO SEARCH-WORDLIST               [ELSE]

    REQUIRE REPLACE-WORD lib/ext/patch.f
    ' QuickSWL ' SEARCH-WORDLIST REPLACE-WORD   [THEN]

;MODULE

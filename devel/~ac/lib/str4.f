( 12.10.1999 ������� �. )
( ����������� 25.12.2000 )

( ������� ���������� ��-����� ���������� ��� �������������
  �������� ������������ �����. ��� ��������� ������� � �����
  Perl ��� PHP, �� ��������� � ������ ������ ������� �����
  ���������������� ����-�����, ������ Perl'�.

  �������� �����: 

  " ����� ������"

  ���:

  " �������������
    �����
    ������"

  � ������ ����� �������� ����������� ���������, �������
  ������ ������� ������ [��� ����� - addr u] ��� �����. ���������
  ���� �������� ���������� ������, �� ������������ ������, ��
  �������� ������������� ����� ���������� ����� ������, ���
  ���������� - ��� ��������� ��������� ������� �����. ����
  ���������� ��� �����, ������� ��� ������� � ������ ������,
  ���� ����, �� ������� ��� ������. ������������ ������ �����������
  � �� ����� �������� ������, ������ ���������� ����������. ����
  ������� �����, �� ��� ������������� � ������ � ���������� ������� 
  ���������. ������:

  : text S" �����" ;
  " �������������
    {text}
    ������"

  ������� �� �� ������, ��� � ���������� ������.

  ����� " [�������] ���������� ������ �� � ���� addr u, � � ����
  ������ ����� s, ������� ����� ������������� � addr u � �������
  �����

  STR@ [ s -- addr u ]

  ���� ����� " ������������ ������ �������������� �����������, ��
  ������ ������������� � �������� ������������� ����, � ����� ���������
  ��� ���������� ����������������� �����������. ��������:

  : TEST " �������������
    {text}
    ������" ;

  ��� ���������� TEST ��������� ����� �� ������, ��� � ����������
  �������.

  ��� ���������� ��������� � {} ������ ������������ ����������
  ������� ���������.

  ��� �������� �� �������� ����������� � ������������ ������,
  ������ s, ������������ ������ " , ���������� ����� �������������
  ������� �� ������ ������

  STRFREE [ s -- ]

  ��� �������� �������� ���� � ����� ������, ������� ������������
  �� STR@ �������� ������ ����� ����� ������������ � �������� Windows,
  ��������� ASCIIZ-�����.

  �������� ������ ������:

  ""  [ -- s ]

  ���������� ������ addr u � ����� ������ s:

  STR+ [ addr u s -- ]

  ���������� ������ s1 � ����� ������ s2 � ��������� s1:

  S+ [ s1 s2 -- ]

  ���� ������ ������, ����������� ��������, ��������� �������� �������,
  ����� ��� ������� � ������� {''}, � ����� ������ - {CRLF}. ��������:

  " �������������{CRLF}{text}
    ������"

  ������ �� �� ������, ��� � � ���������� �������.

  ���� ��� ���������� ��������� � {} ���������� ������ [throw], ��
  ��������� ���������, ����������� � ������, ����� "Error: ���_������".

  ������ ������� ���������� ��������� {} ������������ � ������, ����
  ������ {} ������������ ����� ��������� ��� ������� �������������
  ��������� ����������. ��� ����� ���������� ������ � ������ ����������,
  � � ������ ���������� ���������, ����� ����������� {} - ���. �������
  ����� ��������� ������. ��� �������������� ������ ������ � ����������
  ����������� ������������� ��������� ���������� ������ ����� ������
  ��������� ��������� ������������� ��������� ���������� ������ ������:
  {$���_����������}. ��������:

  : TEST { \ t }
    " abcd" -> t
    " 123{$t}123" STYPE
  ;

  ���������� ����� TEST ���������� 123abcd123.
  ������������������ ���� {$���} �������������� � ������ ����������
  � ���������� ������������������� {����� RP@ + @ STR@}, ��� "�����" -
  �������� ��������� ������������ � �����.

  ���� ��������� ���������� ����� �������� � ������ ��� �������� 
  ��������, �� ������������ {#���_����������}.

  ��� ������ �� ���������� ���������� ������ {} ����� ������������
  ����� S', ���������� �������� S", �� ������������ ��������� �������
  ��� ��������.

  ��� ������� ����������� ����� � ������ ����� ������������ ����� 
  FILE [ addr u -- addr1 u1 ], ����� addr u - ��� �����, � addr1 u1 -
  ��� ����������. ��������:

  " text1{S' filename.txt' FILE}text2"

  EVAL-FILE ������ �� �� �����, �� ��������� ��������� � {} ������ �����.
  EVAL-FILE ����� ������������ � ������ ������, ���������� �� EVAL-FILE.
  ��� ���������� ������ ����� INCLUDED, �� ���������������� ������
  ��������� ������ {}, � ������������ ������ ��� ���������.

  ��������� ���� ���� " "" STR+ STR@ STRFREE CRLF '' FILE EVAL-FILE
  ���������� ��� ������������� ���� ����������. ������������� �� ������������
  ������ ������������ � ���������� ����� ����� �� �������� 
  ������������� � �������� ��������.

  ������������ ����� ����� - ���� � �������� "�����" ������ ����������
  ������� 4��, ������������ ��������� ������ ������, ��� ��� ���������� -
  ����������, � �.�. ��� ������ ������ ����� ������ ������� �������� 4��
  ������������� �������������. � ��������� ���������� ������� ������
  �������� ����������� "���������". �������� ��������� �� ������ - s -
  ���������� ���������� �������� ��� ���� ��������� ��������. � ���
  ��������� �� ������� ���������� ��������� �� addr u �� �������������,
  �.� �� ���� ����� ��������� addr ����� ���������� ��� ���������
  ������������� ������. ����� �������� � ���������� ���� s, �, �����
  ����������, �������� ������ � ���� addr u ��������� STR@.

  ���������������� ������ ���������� - ����� 7��.

  25.12.2000
  ��������� ����-��������� ������� {n} � {s}. ���� ��� �����������
  � ����������� ������, �� �������� ��� ������� ������� �� �� ����������
  � �� �� EVALUATE, � �� ����� - �� ��� ��� ������ �� ". n - ������ �����,
  s - ������ addr u.
)
REQUIRE { ~ac/lib/locals.f
REQUIRE MEM ~ac/lib/memory/heap_enum.f
0
4 -- sType
4 -- sAsize
4 -- sSize
4 -- sState
4 -- sNewBuff
4 -- sWriteH
4 -- sReadH
CONSTANT /sHeader

: SALLOCATE
  ALLOCATE
;

USER STR-ID

: sAddr ( s -- addr )
  DUP sNewBuff @ ?DUP IF NIP EXIT THEN
  /sHeader +
;
: STR@ ( s -- addr u )
  DUP sAddr SWAP sSize @
;
: STRHERE ( s -- addr )
  STR@ +
;
: STRALLOT ( n s -- addr )
  { n s \ size a u ob -- addr }
  s STR@ NIP n + DUP
  /sHeader +  s sAsize @ <
  0= IF -> size
        size 2000 + SALLOCATE THROW
        s STR@ -> u -> a
        s sNewBuff @ -> ob
        DUP s sNewBuff !
        a u ROT SWAP MOVE
        ob ?DUP IF FREE THROW THEN
        size 2000 + s sAsize !
        size
     THEN
  s STRHERE
  SWAP s sSize !
  0 s STRHERE C!
;
: STR+ ( addr u s -- )
  { a u s -- }
  a u s STRALLOT u MOVE
;
: STR! ( addr u s -- )
  0 OVER sSize ! STR+
;
: STRBUF ( -- s )
  { \ s }
  4000 /sHeader + DUP SALLOCATE THROW -> s
  s OVER ERASE
  s sAsize !
  S" " s STR!
  s
;
: "" ( -- s )
  STRBUF
;
: STRFREE ( s -- )
  DUP sNewBuff @ ?DUP IF FREE THROW THEN
  FREE THROW
;
: STR_EVAL ( addr u s -- )
  { \ s sp tib >in #tib so si }
  -> s
  DUP 1 = \ �������� {s} {n}
  IF OVER C@ [CHAR] n = IF 2DROP 0 <# #S #> s STR+ EXIT THEN
     OVER C@ [CHAR] s = IF 2DROP s STR+ EXIT THEN
  THEN
  SP@ -> sp
  TIB -> tib  >IN @ -> >in  #TIB @ -> #tib SOURCE-ID -> so STR-ID -> si
  s STR-ID !
  \ ��� ���� � EVALUATE �� ��� �� ������ ������������ ��� TIB, ������� ���������
  ['] EVALUATE CATCH ?DUP
  IF NIP NIP S" (Error: " s STR+
     ABS 0 <# [CHAR] ) HOLD #S #>  s STR+
     tib TO TIB  >in >IN !  #tib #TIB ! so TO SOURCE-ID
  ELSE
     SP@ sp -
     \ �������=0, ���� ���������� ��� ����� - ����� � ����� ������
     IF 0 <# #S #> THEN
     s STR+
  THEN
  si STR-ID !
  sp SP! 2DROP
;
: (") ( addr u -- s )
  { \ tib >in #tib s sp base }
  TIB -> tib #TIB @ -> #tib >IN @ -> >in BASE @ -> base
  #TIB ! TO TIB >IN 0! DECIMAL
  STRBUF -> s
  BEGIN
    >IN @ #TIB @ <
  WHILE
    [CHAR] { PARSE
    s STR+
    [CHAR] } PARSE ?DUP
    IF s STR_EVAL
    ELSE DROP THEN
  REPEAT
  >in >IN ! #tib #TIB ! tib TO TIB base BASE !
  s
;
: _STRLITERAL ( -- s )
  R> DUP CELL+ SWAP @ 2DUP + CHAR+ >R
  (")
;
USER STRBUF_

: STRLITERAL ( addr u -- )
  \ ������ �� SLITERAL, �� ����� ������ �� ���������� 255
  \ � ������������� ������ ��� ���������� "���������������" �� (")
  STATE @ IF
             ['] _STRLITERAL COMPILE,
             DUP ,
             HERE SWAP DUP ALLOT MOVE 0 C,
             STRBUF_ @ STRFREE
          ELSE
             (")
          THEN
; IMMEDIATE

: CRLF
  LT 2
;
CREATE _S""" CHAR " C,
: ''
  _S""" 1
;

HEX
0BC ( 90, 98 � ������ locals) CONSTANT LOCALS_STACK_OFFSET
\ �������� ������ ��������� ���������� � ����� ( � ������ locals)
\ �������� ������ (� ����� locals)
\ �� ������ ���������� ����� (") ������ ����������������� �����������
DECIMAL

: STR@LOCAL ( addr u -- addr u )
  { \ tib >in #tib s sp }
  TIB -> tib #TIB @ -> #tib >IN @ -> >in
  #TIB ! TO TIB >IN 0!
  STRBUF -> s
  BEGIN
    >IN @ #TIB @ <
  WHILE
    [CHAR] { PARSE
    s STR+
    [CHAR] } PARSE ?DUP
    IF OVER C@ [CHAR] $ =
       IF 1- SWAP 1+ SWAP CONTEXT @ SEARCH-WORDLIST
          IF >BODY @ [ ALSO vocLocalsSupport ] LocalOffs [ PREVIOUS ] LOCALS_STACK_OFFSET +
             0 <# #S [CHAR] { HOLD #> s STR+
             S"  RP+@ STR@}" s STR+
          THEN
       ELSE OVER C@ [CHAR] # =
            IF 1- SWAP 1+ SWAP CONTEXT @ SEARCH-WORDLIST
               IF >BODY @ [ ALSO vocLocalsSupport ] LocalOffs [ PREVIOUS ] LOCALS_STACK_OFFSET +
                  0 <# #S [CHAR] { HOLD #> s STR+
                  S"  RP+@}" s STR+
               THEN
            ELSE S" {" s STR+ s STR+ S" }" s STR+ THEN
       THEN
    ELSE DROP THEN
  REPEAT
  TIB /sHeader - STRFREE
  >in >IN ! #tib #TIB ! tib TO TIB
  s DUP STRBUF_ ! STR@
;
: PARSE"
  { \ s a u }
  [CHAR] " PARSE
  2DUP + C@ [CHAR] " = 
  IF "" -> s s STR! s STR@ STR@LOCAL EXIT THEN \ ���� ������� �� ����� ������
  \ ����� ������ ��������� � ���� �������
  SOURCE-ID ?DUP
  IF FILE-SIZE THROW D>S ELSE 10000 THEN 
  DUP SALLOCATE THROW -> s
  s OVER ERASE
  s sAsize !
  s STR! CRLF s STR+
  BEGIN
    REFILL
  WHILE
    SOURCE '' SEARCH
    IF -> u -> a
       SOURCE u - s STR+
       SOURCE NIP u - CHAR+ >IN !
       s STR@ STR@LOCAL EXIT
    ELSE s STR+ CRLF s STR+ THEN
  REPEAT
  s STR@ STR@LOCAL
;
: " ( "ccc" -- )
  PARSE" POSTPONE STRLITERAL
; IMMEDIATE

: STYPE
  DUP STR@ TYPE
  STRFREE
;
: FILE ( addr u -- addr1 u1 )
  { \ f mem }
  R/O OPEN-FILE-SHARED IF DROP S" " EXIT THEN
   -> f
  f FILE-SIZE THROW D>S DUP SALLOCATE THROW -> mem
  mem SWAP f READ-FILE THROW
  f CLOSE-FILE THROW
  mem SWAP
;
: S'
  [CHAR] ' PARSE [COMPILE] SLITERAL
; IMMEDIATE

: EVAL-FILE ( addr u -- addr1 u1 )
  FILE (") STR@
;
: S! ( addr u var_addr -- )
  "" DUP ROT ! STR+
;
: S+
  OVER STR@ ROT STR+ STRFREE
;
: FREESTR1
  DUP CELL+ @ 4032 =
  IF
    DUP
    @ @ ['] SALLOCATE - 5 = IF ." *****" @ CELL+ DUP . FREE THROW ELSE ." =====" DROP THEN
  ELSE DROP THEN
;
: FREESTR
  ['] FREESTR1 THREAD-HEAP @ HeapEnum
;

(
\ : TEST { a b c } " 777{RP@ 180 DUMP HERE 0}888" STYPE ;
\ HEX 77 88 99 TEST

\ �����:

: TEST S" test" ;
" abc{TEST}123 5+5={5 5 +} Ok" STYPE CR

: TEST2 " abc{TEST}123 5+5={5 5 +} Ok {ZZZ} OK!" STYPE CR ;
TEST2

" 
  abc
  def
  {TEST}
  123
" 
STYPE

: TEST3  { \ n t k }
  9 -> n
  " abcd" -> t
  3 -> k
  " |123|{$t}|123|{#n}|123|{#k}|{S' file1.txt' EVAL-FILE}<End of file>" STYPE
;
TEST3
)
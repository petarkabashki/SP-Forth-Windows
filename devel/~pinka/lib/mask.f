\ ��������� ������ � �����, ���������� ����������� (wildcards)  * ?
\ for SPF
\ (c) Ruvim Pinka

\ ver 0.1 11.06.1999 
\ ver 0.4 18.03.2000
\ * ���������� ������������ ��������� ������  S" aaa" S" aaa*"
\ ver 0.5
\ + ������� � locals,  ��������� ��������� ���������.
\ ver 0.6  13.05.2000  
\ + ��������� ����������� ������� ����������� \* \? \\
\ * ���-�� ��� ��� ���� ���������� ���������� �������...


REQUIRE {              ~ac\lib\locals.f
REQUIRE [UNDEFINED]    lib\include\tools.f

CHAR \ VALUE quote-char

[UNDEFINED] WITHIN [IF]
: WITHIN ( n1|u1 n2|u2 n3|u3 -- flag ) \ 93 CORE EXT
  OVER - >R - R> U<
;
[THEN]


[UNDEFINED] UpCase [IF]
\ ���������� ������� ������� ������� ( ������ ��� ��������� ������)
: UpCase ( c1 -- c2 )
  DUP  [CHAR] a   [ CHAR z 1+ ] LITERAL  WITHIN
  IF   32 -  THEN
;
[THEN]


GET-CURRENT   TEMP-WORDLIST SET-CURRENT
( wid )

\ ��������� �������
: wc+
    S" wc  1+  -> wc   wclen  1-  -> wclen  " EVALUATE
; IMMEDIATE
: str+
    S" str 1+  -> str  strlen 1-  -> strlen " EVALUATE
; IMMEDIATE

GET-CURRENT SWAP SET-CURRENT ( wid )
DUP ALSO CONTEXT !

: WildCMP-U   { str strlen wc wclen  --  n }   \ case sensitive - non
\  addr1 u1  - ������
\  addr2 u2  - ����� ( ������)
\  n =  0,  ���� ������ �������� ��� ������,
\  n = -1,  - ���� ������������� ������ �� ������, �� ������ ������ �����.
\           - ���� �� ������, ������ ������ ������������� ������
\           ������ ����� ������� �������� ��������, ��� ��������������
\           ������ �����
\  n =  1   � ��������� �������, �.�.  ���� ������ ������������� ������
\           ������ ����� �� ������� �������� ��������, ��� ��������������
\           ������ �����.
\  ����� :
\           *  - ����� ���������� ����� ��������
\           ?  - ����� ������

    BEGIN
        wclen  1 < IF   
            strlen 0= IF  0 EXIT THEN  -1  EXIT  
        THEN

        strlen 0= IF
            wc C@ [CHAR] * =  IF 
                wc+  wclen 0= IF 0  EXIT THEN \ ���� * - ���������.
            THEN  -1  EXIT
        THEN

        wc C@  wc+
        DUP  [CHAR] *  = IF DROP

                wclen 0= IF  0 EXIT  THEN \ �����, ���� * - ��������� � �������

                BEGIN  \ ��������� �������� ���������� �����
                    str strlen  wc wclen  RECURSE  0=
                    IF   0 EXIT  THEN  \ ����� ����������
                    \ ��������� ������ � ������, ���� �� ������� ( �������������� * )
                    strlen 0= IF -1  EXIT THEN   str+
                AGAIN
        ELSE
        DUP  [CHAR] ?  = IF DROP    str+  ELSE
        DUP  quote-char = IF DROP  wc C@  wc+ THEN
            UpCase  str C@
            UpCase  2DUP  <> IF
               > IF  -1 EXIT    ELSE   1 EXIT   THEN  
            THEN 2DROP
            str+
        THEN THEN
    AGAIN
;

PREVIOUS  
FREE-WORDLIST

( example
  S" Zbaabbb777778" S" ?b*7*8" WildCMP-U .
  S" 012WebMaster" S" ???w??mas*" WildCMP-U .
  S" INBOX" S" INBOX*" WildCMP-U .
  S" http://blablabla.html?.newshub.eserv.ru/" S" http://*\?.*/"  WildCMP-U .
)

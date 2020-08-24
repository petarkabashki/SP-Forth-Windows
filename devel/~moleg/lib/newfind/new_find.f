\ 28-12-2006 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������� ��������� SFIND �� ����� ��������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ ������� ���������� ���������� ������ ����� ���������:
\ ( asc # --> asc # false | wid imm true )
\ �� ���� ������ ���������� ��� �����!
\ ���� ���������� ��������� ������ � ��������� false
\ ���� - ����� ����_immediate true

S" lib\include\tools.f" INCLUDED
\ ����� ������, �� ����� ����� ������� � ��� [IF]-� � �.�.

\ � ���4 - ��� ����� �������� �� ����� ����� - �������������
: ?IMMEDIATE ( NFA -> F ) NAME>F C@ &IMMEDIATE AND 0<> ;

\ ������� � ������� ����� ��������� ����� ����������
: nDROP ( [ .. ] n --> ) 1+ CELLS SP@ + SP! ;

\ ______________________________________________________________________________

\ ������ ����� � ������ �������������� �����.
\ ��� ��� ���������� ����� � ����� �� ������ ��������
: id>asc ( NFA --> asc # ) DUP 1+ SWAP C@ ;

\ �������� ���������� ������� � ������ �����
\ ��� ����� ������ ���, ���� ��������� ������ ��������� ������
: identify ( asc # nameid --> flag )
           id>asc 2SWAP COMPARE ;

\ �������� �� ������ ������������ ��������
\ ��������� ������� � id ������� ����� ����� ������ ������� ����, � �������
\ ���������� ������ �����. ������� ������ �� �����, ��� ��� �����������
\ �������� ��������� @ � ���.
: hashname ( asc # wid --> asc # link ) @ ;

\ ����� ����� � ��������� �������
\ ���� ������ ������� ����������, �� ���� ���� ����������� ������ �����.
: search-wordlist  ( asc # voc-id -- asc # false | xt imm_flag true )
                   hashname
                   BEGIN DUP WHILE
                         >R 2DUP R@ identify WHILE
                         R> CDR
                    REPEAT
                     2DROP R@ NAME>C @
                           R> ?IMMEDIATE TRUE
                   THEN ;

\ �� ����� ������ ��������, � ������� ����� ����� ����� � �� ���-��
\          � ������ - ������������� �����
\ �� ������ � ������ �������� ������ � false
\           � ������ ������ ���������� ����� ����� � ��� �����
\           immediate � true
: sfindin ( vidn ... vidb wida #  asc # --> asc # false | xt imm_flag true )
          ROT BEGIN DUP WHILE 1- >R  \ ���-�� �������� ��� ��������� �� R
                    ROT search-wordlist 0= WHILE \ ����� �� WHILENOT
                    R>
               REPEAT
                 R> -ROT 2>R nDROP 2R> TRUE
                 \ ������� ����� �� ������ 8) �� ��� ����� �����.
              THEN ;
\ sfindin ������ ������ ��� ����, ����� ����� ����������� ������ � ����������
\ ��������, � �� ������ � ���������.

\ ����� ����� � ���������
: sfind ( addr u -- addr u 0 | xt imm true )
        2>R GET-ORDER 2R> sfindin ;

\ ����� ����� �����, ��������������� ������� � ������
\ ����� ' � ������� ���������.
\ ���������� �����, � ������ ������������ ����� ��������� ����������
: ' ( "<spaces>name" -- xt )
    NextWord sfind
    IF DROP           \ ������� immediate ��� �� �����
     ELSE -321 THROW
    THEN ;

\ ����� �����, ���� �������� ������� �������������� ��� ����� � �������
\ ���������� �����������.
: ['] ( name | --> )
      ?COMP ' LIT,
      ; IMMEDIATE

\ ��������� ��������, �������� ���������� state
: stateact ( xt imm_flag --> )
           STATE @ > IF COMPILE, ELSE EXECUTE THEN ;

\ ���������������� �����, �������������� �������
\ ��������� ��������, �������� ��������� STATE
\ �������� ������� ������ �����, ��� ��� ��� ������� �����,
\ ��� ���� ������ �����, � �� ����� �� ����� �����.
: eval-name ( asc # --> )
            sfind IF stateact
                   ELSE -2003 THROW
                  THEN ;

\ ���������������� ������� ( ����� ��� ����� ) �������������� �������
\ ��������� ��������, �������� ��������� STATE
: eval-word ( asc # --> )
            sfind IF stateact
                   ELSE ?SLITERAL
                  THEN ;

\ ��� ������ ������ - � ��� ������� ������ �����, ���� ��� �� �������
\ �� ������ NOTFOUND, �� ��������� ��� - ����� �������� ������ �����.
\ ��� ������ � ������, ����, �������� ����� ��� ����� ���������, ��
\ ����� �� notfound ����� ���� ���������� �������, � ���� �� � ������
\ ������������ NOTFOUND-� ������� ������ �����, ���� ����� ��������
\ ���-�� ������ ���������. - ��� ���������� ������� ������ ����� (���
\ ������ �� ������� NOTFOUND-a), �� �����, �������� ������ ���������
\ ��� ���������� ���-�� �����. ��� ��������� ������� �������� �����
\ ��� ������� ������� ������� ��������� ������������ NOTFOUND � ���������
\ ������, � @ ?EXECUTE ��� ���. ���� ������ � ���, ��� ����� ����������
\ ����� ������������, � ��� ������������ ��� � ������ ����� �����
\ ��������������. ��� ��� � �� ������ �������, ���� �� � ����� �����������.

TRUE [IF] \ ��� ������� ����������� ������������

\ ������� � ��������� �����, ������ �� � ���?
\ �� ����� ������������, ���� ������� ��������, ��� �� ����� ���-��
\ ������������� ���� �� �����.
: notfound ( asc # --> )
           S" NOTFOUND" sfind
           IF DROP EXECUTE
            ELSE 2DROP ?SLITERAL
           THEN ;

\ ���������������� ������� ����� �� ��� ���, ���� �� �� ����������
\ ������, ���� �� �� NOTFOUND - �� ���� �� ������ ������ � �������:
\ : interpret  BEGIN NextWord DUP WHILE eval-word ?STACK REPEAT 2DROP ;

: interpret ( -> )
            BEGIN NextWord  DUP WHILE
                  ['] eval-name CATCH
                  IF notfound THEN
                  ?STACK
            REPEAT 2DROP ;


[ELSE] \ ��� � ���������� �������� ���������� ?sliteral & notfound

: notfound ( asc # --> )
           S" NOTFOUND" sfind
           IF DROP EXECUTE
            ELSE -2003 THROW
           THEN ;

: interpret ( -> )
            BEGIN NextWord DUP WHILE
                  ['] eval-word CATCH \ ��� ������� ��� ��� �����
                  IF notfound THEN    \ � ���� ����� NOTFOUND
                  ?STACK
            REPEAT 2DROP ;
[THEN]

\ EOF ������������� �� ����������� �����

\ ��� ��� ������������� �� ������ ���
: SEARCH-WORDLIST1 ( asc # voc-id -- asc # false | xt -1/1 )
                   search-wordlist

                   IF IF 1 ELSE -1 THEN \ ���� ���� ���� � ����� ������ ��-��
                    ELSE FALSE          \ ����, ��� ���� ������� ����������
                   THEN ;

: SFIND ( --> )
        2>R GET-ORDER 2R> sfindin
        IF IF 1 ELSE -1 THEN        \ �� �� �����.
         ELSE FALSE
        THEN ;

\ ������ ��� �������, ��� ��� ������� ��������
: EVAL-WORD ( asc # --> ) eval-name ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ������ ��������� ��������������� ����
  S" passed" TYPE
}test

\EOF �������� ������

CR CR S" �������� ������ � ������� � ������� search-wordlist" TYPE CR

: ok~ ." �������" ;

S" adas" 2DUP TYPE FORTH-WORDLIST search-wordlist
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" ok~" 2DUP TYPE FORTH-WORDLIST search-wordlist
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

IMMEDIATE
S" ok~" 2DUP TYPE FORTH-WORDLIST search-wordlist
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" ok~" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

VOCABULARY TEST
           ALSO TEST DEFINITIONS

S" ok~" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" sdad" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

: ~test ." �������" ;

S" ~test" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" ' ~test " TYPE ' ~test EXECUTE CR

S" eval-name " TYPE S" ~test" eval-name CR

IMMEDIATE S" eval-name " TYPE S" ~test" eval-name CR

: tev NextWord eval-name ; IMMEDIATE

: ~nott ." nott" ;

S" : test tev ~nott ; " TYPE : test tev ~nott ; CR
S" : testa tev ~test ; " TYPE : testa tev ~test ; CR

S" 12345678 eval-word " TYPE S" 12345678" eval-word . CR


interpret S" interpret " TYPE  ~test CR

\ � �������� ��� ��������.

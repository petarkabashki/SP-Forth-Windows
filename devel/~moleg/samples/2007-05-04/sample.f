\ 05-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������� ������ � �������� ��������� �� ������
\ (http://fforum.winglion.ru/viewtopic.php?p=7274#7274)

\ -- ������ ����� ����������� ���� ------------------------------------------

\ ����� ���������� >IN �����, �� ������ ���������� �����
: <back ( ASC # --> ) DROP TIB - >IN ! ;

\ �������� ������ � PAD - �������� � �������� <# #>
: BLANK  ( --> ) BL HOLD ;

\ �������� ��������� ���-�� �������� � PAD
: BLANKS ( n --> ) BEGIN DUP WHILE BLANK 1 - REPEAT DROP ;

\ �������� ����� � ������������ �� ����� ���������
: R+ ( r: a d: b --> r: a+b ) 2R> -ROT + >R >R ;

\ ������� TRUE ���� ����������� ������� a < ��� = b, ����� FALSE
: >= ( a b --> flag ) < 0= ;

\ ���������� ����� � ������ ������, ���������� ������(�) �������� ������
: nl ( --> asc # ) LT LTL @ ;

\ -- ������������ �������������� ������ -------------------------------------

        USER-VALUE buffer \ ����� ���������� ������
        USER-VALUE out>   \ ������� � ������� ����� ��������� ������ � �����

\ ���������� � ����� ������ asc # � ��� ���������
: >out ( asc # --> ) out> SWAP 2DUP + TO out> CMOVE ;

\ ���������� ������ � ����������� �������� ������
: save-result ( asc # --> ) >out nl >out ;

\ �������� ����� � ������ ��������� � ������ ������
: result> ( --> asc # ) buffer out> OVER - ;

\ ������������ ������
: free-result ( --> ) buffer IF buffer FREE THROW 0 TO buffer THEN ;

\ ������������� ������
: init-buffer ( # --> )
              free-result
              CELLS ALLOCATE THROW
              DUP TO buffer TO out> ;

\ -- ���������� ���� ������� ------------------------------------------------

        USER-VALUE regular  \ ���-�� ����������� �������� ����� �������
        USER-VALUE addons   \ ���-�� �������������� ��������

\ �������� ����������� ���-�� ���������� �������� ����� ����
\ ��������� ���������� �������� ����� ���� ��������.
: add-blanks ( --> )
             addons IF BLANK addons 1 - TO addons THEN
             regular BLANKS ;

\ ������������ ������ �� n �����, ������� ����� ������ ������� �����������
\ ���������� ���������� ��������.
: prepare ( [ asc # ] n str# p --> asc # )
          SWAP - OVER 1 = IF 2DROP EXIT THEN     \ ���� ����� ���� � ������

          OVER 1 - /MOD 1 + TO regular TO addons \ ������� ����������� �������

          >R <# BEGIN R@ WHILE   \ ���� ���� �����
                      HOLDS
                   -1 R+
                      R@ WHILE   \ ���� ����� �� ��������� � ������
                      add-blanks
                  REPEAT
                THEN
          R@ R> #> ;

        USER words# \ ������� ���� ��� ������� ������

\ ������� ����� ��� ����� ������
: collect ( asc # p --> [ asc # ] n str# p )
          >R DUP >R  1 words# !
          BEGIN NextWord DUP WHILE  \ ���� ���� ����� �� ������� ������
                DUP 1 + 2R@ ROT +
                TUCK >= WHILE       \ ���� ����� ����� ���� ������ p
                RDROP >R
                words# 1+!
              REPEAT
                DROP <back          \ ���� ����� ������ ����� - �����
                words# @ R> R> EXIT
          THEN
          2DROP words# @ R> RDROP DUP ;

\ ������������� �����, ��������� ����������� � buffer
: format-stream ( p --> )
                >R BEGIN NextWord DUP WHILE
                      R@ collect prepare
                      save-result
                   REPEAT 2DROP
                RDROP ;

\ ������������� �����
: format-text ( asc # p --> asc # )
              SAVE-SOURCE N>R
               >R DUP init-buffer SOURCE!
               R> format-stream
              NR> RESTORE-SOURCE
              result> ;

\ EOF -- test sectin --------------------------------------------------------

: ~- ( n --> ) BEGIN DUP WHILE ." -" 1 - REPEAT DROP CR ;

\ ��� ������� ������ �������������� ������.
: ft S" simple sample string with the simple sample text." 20
     DUP ~- format-text TYPE
     S" inside string can contain_very_long words larger than 'p' " 13
     DUP ~- format-text TYPE
     ;

\ ��������� ���������� ����� � ������
: source ( FileName # --> addr # )
         R/O OPEN-FILE THROW >R
           R@ FILE-SIZE THROW DROP
              DUP ALLOCATE THROW
           TUCK SWAP R@ READ-FILE THROW
         R> CLOSE-FILE THROW ;

S" test.txt" source 60 format-text TYPE

CR
ft

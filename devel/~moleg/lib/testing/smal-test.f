\ 27-04-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ��������� ����������� ������������ ����
\ ����������� �������.

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f

\ ����� ����� ��������� ������� �� �������� ������ �� ��� ���, ���� ��
\ �� �����������.
: NEXT-WORD ( --> asc # | asc 0 )
            BEGIN NextWord DUP 0= WHILE
                  DROP REFILL DUP WHILE
                  2DROP
               REPEAT
            THEN ;

\ ������� ������ ������ �� ��������� ����������
: SERROR ( asc # --> ) ER-U ! ER-A ! -2 THROW ;

\ 10-11-2006 ������� �������� ����������� ��������� ����������� EVAL-WORD
: eval-word
    SFIND ?DUP
    IF
         STATE @ =
         IF COMPILE, ELSE EXECUTE THEN
     ELSE
         S" NOTFOUND" SFIND
         IF EXECUTE
         ELSE 2DROP ?SLITERAL THEN
    THEN ;

\ ������ ����� � ������ ������� ������� asc #
: S: ( asc # --> ) SHEADER ] HIDE ;

\ ----------------------------------------------------------------------------

        \ ��������� ������ ������������
?DEFINED TESTING  USER TESTING ( --> addr )

        \ �������� �� ��������� ������� ����������� ��� ������
        USER-VECT is-delimiter ( --> flag )

        \ �������� ����������� ������ ������
        USER-VECT action ( asc # --> xj )

\ ����� ����������� �� ������� ������. � ������ ���������� �������� ������,
\ ���� ����������� �� ��� ��������, ������� ���������� ������.
: process-test ( --> )
               BEGIN NEXT-WORD DUP WHILE
                     2DUP is-delimiter WHILE
                     action
                 REPEAT 2DROP EXIT
               THEN
               S" section not finished" SERROR ;

\ ������� ������-������������ �������� ������
: test-delimiter ( --> asc # ) S" }test" ;

\ �������� �� ��������� ������� ����������� ��� ������ �����
: is-test-delimiter ( asc # --> false|nfalse ) test-delimiter COMPARE ;

\ �� ����� ������������ ���� ����� ����� ��������������
\ ���������������� ��� ������������.
\ ����� ������������ ������ �����������!
: test{ ( --> )
        TESTING @
         IF    ['] eval-word TO action
          ELSE ['] 2DROP TO action
         THEN
        ['] is-test-delimiter TO is-delimiter
        process-test ; IMMEDIATE

\ ���� ������������ �������� �� ������� ������, �� ������ �� �����-��
\ �������� ��������� ������ ������ ������������
test-delimiter S: ( --> ) S" testing delimiters unpaired!" SERROR ; IMMEDIATE

\ �������� ������ �� �������� ������ � �����������
: .S" ( / string" --> asc # )
      [COMPILE] S" 2DUP TYPE
      0x3E OVER - 0 MAX SPACES
      ; IMMEDIATE

FALSE WARNING !
\ ����� �� ������������� ��������� ����������
: REQUIRE  TESTING @ >R FALSE TESTING ! REQUIRE R> TESTING ! ;
: TESTED   FALSE WARNING ! \ ����� �� ������������ �������������� �� ����� �����
           TRUE TESTING ! DEPTH >R 2DUP INCLUDED
           DEPTH R> <> IF CR ."          stack leaking !!!" THEN 2DROP
           ;

: INCLUDED TESTING @ >R FALSE TESTING ! INCLUDED R> TESTING ! ;

: testing.. ." testing: " ; ' testing.. MAINX !
S" st.exe" SAVE BYE

\EOF -- �������� ������ ------------------------------------------------------

test{ : simple ." simple sample" CR ;
      simple
}test

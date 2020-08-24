\ 14-10-2006 ~mOleg for SPF4.17
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������������� ������������ ���������, ����.

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 REQUIRE ADDR      devel\~moleg\lib\util\addr.f
 REQUIRE IFNOT     devel\~moleg\lib\util\ifnot.f

FALSE WARNING !

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

\ ������ �������� -----------------------------------------------------------

\ ��������: ���� �� Create ������ ������ ���� ���������������� !!!

CREATE russian   \ ��������� �� ������� �����
\ CREATE english   \ select english messages

\ ���� ����� ����������� ��� ���� � ��� �����������
\ CREATE testing

\ -- �����, ������� �� ������� � ��� ----------------------------------------

\ �� �� ��� � : ������ ��� �������� �� ������� ����� ������ � ���� ������
\ �� ���������:   S" name" S: ��� ����� ;
?DEFINED S: : S: ( asc # --> ) SHEADER ] HIDE ;

\ ����� ����� ��������� ������� �� �������� ������ �� ��� ���, ���� �� �
\ �� �����������.
: NEXT-WORD ( --> asc #|0 )
            BEGIN NextWord DUP WHILENOT
                  DROP REFILL DUP WHILE
                  2DROP
               REPEAT
            THEN ;

\ ��� ����� ����� ��� � ���
: IS POSTPONE TO ; IMMEDIATE

\ ---------------------------------------------------------------------------

\ ��� ����� ����� ������������ ������ � ��������� �������
VOCABULARY tests
           ALSO tests DEFINITIONS

\ ������������ ���� ���� ��������� ������ ��������� ����� ������������
        USER-VECT is-delimiter
        USER-VECT action

\ �������� ����
: process ( --> )
          BEGIN NEXT-WORD DUP WHILE
                2DUP is-delimiter WHILE
               action
           REPEAT 2DROP EXIT
          THEN
          S" test section not finished" ER-U ! ER-A A! -2 THROW ;

\ ���� ����� ���������������� ������� � ���������
\ ������, ����� � ����������� ������� ������: �����-������ settings ?
: ?keyword ( asc # --> flag )
           SFIND
           IF DROP TRUE
            ELSE 2DROP FALSE
           THEN ;

\ ---------------------------------------------------------------------------

\ ���, ������� ���������� �������� ������
: test-delimiter  ( --> asc # ) S" ;test" ;

\ ��� �������, ��� ������ ��� ������ � �������� ������������ ����� SFIND
: is-test-delimiter ( asc # --> false|nfalse ) test-delimiter COMPARE ;

\ � ��� ������ ������������ 8)
: work-delimiter    ( --> asc # ) S" ;work" ;
: is-work-delimiter ( asc # --> false|nfalse ) work-delimiter COMPARE ;

\ � ��� ��������� ����������� � ����� ����32
: comm-delimiter    ( --> asc # ) S" comment;" ;
: is-comm-delimiter ( asc # --> false|nfalse ) comm-delimiter COMPARE ;

\ � ��� �������� ��������� ������
: rus-delimiter     ( --> asc # ) S" ;rus" ;
: is-rus-delimiter ( asc # --> false|nfalse ) rus-delimiter COMPARE ;
: eng-delimiter     ( --> asc # ) S" ;eng" ;
: is-eng-delimiter ( asc # --> false|nfalse ) eng-delimiter COMPARE ;

\ ---------------------------------------------------------------------------

        PREVIOUS DEFINITIONS
                 ALSO tests

\ �� ����� ������������ ���� ����� ����� ��������������
\ ���������������� ��� ������������.
\ ����� ������������ ������ �����������!
: test: S" testing" ?keyword
         IF    ['] eval-word IS action
          ELSE ['] 2DROP IS action
         THEN
        ['] is-test-delimiter IS is-delimiter
        process ; IMMEDIATE

\ ���� ������������ �������� �� ������� ������, �� ������ �� �����-��
\ �������� ��������� ������ ������ ������������
test-delimiter S: CR ." testing delimiters unpaired!" ABORT ; IMMEDIATE

\ �������� �������� �������� ������������, �� ���� �� ����� ������������
\ ������ ������ ����������� �� �����! �� � ������ ����� �����.
: work: S" testing" ?keyword
         IF    ['] 2DROP IS action
          ELSE ['] eval-word IS action
         THEN
        ['] is-work-delimiter IS is-delimiter
        process ; IMMEDIATE

work-delimiter S: CR ." working delimiters unpaired!" ABORT ; IMMEDIATE

\ ��������� ����������� � ����� ����32
: comment: ['] 2DROP IS action
           ['] is-comm-delimiter IS is-delimiter
           process ; IMMEDIATE

comm-delimiter S: CR ." comments unpaired!" ABORT ; IMMEDIATE


\ ��������� ������
: rus:  S" russian" ?keyword
         IF    ['] eval-word IS action
          ELSE ['] 2DROP IS action
         THEN
        ['] is-rus-delimiter IS is-delimiter
        process ; IMMEDIATE

: eng:  S" english" ?keyword
         IF    ['] eval-word IS action
          ELSE ['] 2DROP IS action
         THEN
        ['] is-eng-delimiter IS is-delimiter
        process ; IMMEDIATE

rus-delimiter S: CR ." ��������� ������ ������ rus!" ABORT ; IMMEDIATE
eng-delimiter S: CR ." eng section start is missed!" ABORT ; IMMEDIATE

        PREVIOUS


        ALSO tests DEFINITIONS

        0 VALUE marker  \ ���������� ������� �����
        0 VALUE tester  \ ���������� ������� ����� 8)

\ � ����� ������� ��������� ��������� �����?
: ?where ( delta --> )
         0< IF  rus: ." �� ����� ��������� ������ ��������" ;rus
                eng: ." Data stack overflow." ;eng
             ELSE
                rus: ." C� ����� ����� ������ ��������" ;rus
                eng: ." Data stack underflow." ;eng
            THEN ;

\ ���������, �� ���� �� ��������� �� �����
: ?changes ( 0x --> flag )
           tester marker - CELL / DUP >R >R
           BEGIN R> 1- DUP WHILE >R
                       0=  WHILE
            REPEAT rus: ." ��������� �� ������� ����� ������ " ;rus
                   eng: ." data stack contents is changed " ;eng
                   2R> -

                   rus: ." �������� " . ." -�� ��������." ;rus
                   eng: . ." -th value changed." ;eng

                   EXIT
           THEN RDROP RDROP
           ." �" ;

\ ���� �� ��������� �� �����?
: ?violations ( --> )
              SP@ marker - DUP
              IF ?where
               ELSE DROP ?changes
              THEN ;


        0 VALUE standoff \ �������� ����������� ��� �� ����� included

        PREVIOUS DEFINITIONS
                 ALSO tests

\ ---------------------------------------------------------------------------

\ ���������� ����������� included
: INCLUDED ( asc # --> )
           0x0D EMIT standoff DUP SPACES 3 + TO standoff

           2>R  SP@ TO tester
            0 0 0 0 0 0 0 0 0 0
           SP@ TO marker

           2R> ." including: " 2DUP TYPE 5 SPACES

           ['] (INCLUDED) CATCH

         standoff 3 - 0 MAX TO standoff

           IF rus: ." �������� �� ������� ����." CR ;rus
              eng: ." Can't make the library."   CR ;eng
              ERR-STRING TYPE

            ELSE ?violations
           THEN

    tester SP!
    0x0A EMIT ;

        PREVIOUS

\ ����� �� ������ ���.
: MARKER ( "<spaces>name" -- ) \ 94 CORE EXT
         HERE
         GET-CURRENT ,
         GET-ORDER DUP , 0 ?DO DUP , @ , LOOP
         CREATE ,
         DOES> @ DUP \ ONLY
         DUP @ SET-CURRENT CELL+
         DUP @ >R R@ CELLS 2* + 1 CELLS - R@ 0
         ?DO DUP DUP @ SWAP CELL+ @ OVER ! SWAP 2 CELLS - LOOP
         DROP R> SET-ORDER
         DP ! ;

TRUE WARNING !

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ ���� �� ��������������.
  S" passed" TYPE
}test

\ ---------------------------------------------------------------------------

\ ������ ���, ��� ����� ��������������, �� ��� ����, ����� ����� ��
\ �������� � ����-�������, ���������� ���� ������.
: testlib ( asc # --> )
          S" MARKER remove " EVALUATE
          INCLUDED
          S" remove" eval-word ;

comment:
     ������  ���  ������������ ���������� ���������� �� ���������� �
 �������  S"  path\name"  testlib.  ��  �����  ������ ����������� ��
 ������������  �������  �����  ����  �  ������,  ���� ����� ���� ���
 ������������.  ��  ����� ����� �������������� ��������, ����� �����
 �����������  �����������  �����������  ���������  ��  ����� ������:
 ������������\���������������  ����  ��������� ����� �� ������������
 �������  (  ����  ����� ����������� ��������� ����� �� �������, ���
 ������  �������(10  �����),  ����������  ���������  ���-��  ����� �
 included. ����� ����������� ���� ���������������� ��� ���������.
comment;

\ ---------------------------------------------------------------------------

test: \ ������������� ���� ���������, ���� ������������ ��������������� ����

 S" .\lib\include\core-ext.f" testlib
 S" .\lib\include\double.f"   testlib
 S" .\lib\include\string.f"   testlib
 S" .\lib\include\tools.f"    testlib
 S" .\lib\include\facil.f"    testlib

;test

comment:

����� �������� �������� ������� ����� ��� ���� ����� test: ;test
- �������� ��������������

comment;
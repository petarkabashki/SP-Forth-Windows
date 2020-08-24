\ 22-12-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���������� ����������� �������� ������. [IF] [IFNOT] [ELSE] [THEN]

 REQUIRE CS>         devel\~moleg\lib\util\csp.f
 REQUIRE NEXT-WORD   devel\~mOleg\lib\util\parser.f
 REQUIRE WHILENOT    devel\~moleg\lib\util\ifnot.f
 REQUIRE THIS        devel\~moleg\lib\util\useful.f
 REQUIRE ON-ERROR    devel\~moleg\lib\util\on-error.f
 REQUIRE ALIAS       devel\~moleg\lib\util\alias.f
 REQUIRE s"          devel\~moleg\lib\strings\string.f

        ALIAS 0! OFF
        ALIAS TO IS

VOCABULARY immediatest

        USER qcontrols

\ ���������� ��� ����� �� ������� ���������� � ������� qiff
: -undefined ( --> )
             BEGIN NEXT-WORD DUP WHILE  \ ���� �� ����� ������
                   [ ALSO immediatest CONTEXT @ PREVIOUS ] LITERAL
                   SEARCH-WORDLIST WHILENOT   \ ���� �� �������
               REPEAT EXECUTE EXIT
             THEN -1 THROW ;

\ � ������ ������ ������������ ����������
: qerrexit ( -->)
           CSDepth BEGIN DUP WHILE CSDrop 1 - REPEAT DROP
           qcontrols OFF ;

ALSO immediatest DEFINITIONS

        VECT [IF]       IMMEDIATE  ( flag / ... --> )
        VECT [IFNOT]    IMMEDIATE  ( flag / ... --> )
        VECT [THEN]     IMMEDIATE  ( --> )
        VECT [ELSE]     IMMEDIATE  ( --> | / ... )

\ ��� ����, ����� �������������� ��������� ����������� ����������:
\ ���������� �� ����� ������
: \ ( / ... eol] --> )
    [COMPILE] \ qcontrols @ IF -undefined THEN ; IMMEDIATE

\ ���������� �� ����������� �������� ������
: ( ( / ... bracket --> )
    [COMPILE] ( qcontrols @ IF -undefined THEN ; IMMEDIATE

ALSO FORTH THIS

\ ���������� ������ ���������� ����������� ������
: [THEN] ( --> )
         ['] [IF] CS@ =
         IF qcontrols @ -1 < IFNOT qcontrols OFF CSDrop EXIT-ERROR EXIT THEN
            1 qcontrols +! -undefined
          ELSE -1 THROW
         THEN ; IMMEDIATE

\ �������������� ������ ���������� ����������� ������.
\ ���� ����� �� [ELSE] �������������� - �� [ELSE] ����� ������������
\ ���� ����� �� [ELSE] ����������� - �� [ELSE] �������� ���������������.
: [ELSE] ( --> )
         ['] [IF] CS@ =
         IF qcontrols @ 1 + IFNOT FALSE qcontrols ! EXIT THEN
            qcontrols @ IFNOT TRUE qcontrols ! THEN
            -undefined
          ELSE -1 THROW
         THEN ; IMMEDIATE

\ �������� �������� ������ ���������� ����������� ������,
\ ���� flag ���� ����, ����� �� [IFNOT] �������������
\ ����� ����� ������������ �� ������ �������, ����������� �
\ ������� immediatest
: [IFNOT] ( flag --> )
          ['] [IF] CS@ =
          IF qcontrols @ IF -1 qcontrols +! -undefined EXIT THEN THEN
          0 <> DUP qcontrols ! ['] [IF] >CS
          ['] qerrexit ON-ERROR
               IF -undefined THEN ; IMMEDIATE

\ �������� �������� ������ ���������� ����������� ������,
\ ���� flag ������� �� ����, ����� �� [IF] �������������
\ ����� ����� ������������ �� ������ �������, ����������� �
\ ������� immediatest
: [IF] ( flag --> ) 0 = [COMPILE] [IFNOT] ; IMMEDIATE

 ALSO FORTH ' [IF]    PREVIOUS IS [IF]
 ALSO FORTH ' [IFNOT] PREVIOUS IS [IFNOT]
 ALSO FORTH ' [THEN]  PREVIOUS IS [THEN]
 ALSO FORTH ' [ELSE]  PREVIOUS IS [ELSE]

PREVIOUS

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 0 [IFNOT] 82704958 [ELSE] 36547236 [THEN] 82704958 <> THROW
  S" passed" TYPE
}test

\EOF ����������� ���� �����������������

 0 [IFNOT] s" ifnot test pased" [THEN] TYPE CR
 1 [IF] s" if test pased" [THEN] TYPE CR
 0 [IFNOT] s" ifnot-else test passed" [ELSE] s" ifnot-else test falied" [THEN] TYPE CR
 0 [IF] s" if-else test failed" [ELSE] s" if-else test pased" [THEN] TYPE CR
-1 [IF] -1 [IF] s" if-if-then test passed" [THEN] [THEN] TYPE CR
 0 [IF] [IFNOT] s" enclosure test failed" TYPE CR -1 THROW [THEN]
     [ELSE] s" enclosure test passed"
   [THEN] TYPE CR
 1 [IF] s" test " TYPE
     [ELSE] 1 [IF] s" 1 failed" TYPE -1 THROW [ELSE] s" 2 failed" TYPE -1 THROW [THEN]
            s" 3 failed" TYPE -1 THROW
   [THEN] s" passed" TYPE CR
: test0 ." test0 " [ 0 ] [IF] s" failed " [ELSE] s" passed " [THEN] TYPE ; test0 CR
: test1 SP@ >R s" test1 passed "
        [ 0 ] [IF] \ s" test1 failed A " [ELSE]
                   s" test1 failed B "
              [THEN] TYPE R> SP! ; test1 CR
: test2 [ 1 ] [IF] ( s" test2 failed "
               [ELSE] ) s" test2 passed "
              [THEN] TYPE ; test2 CR

\ lib\ext\caseins.f CaseInsensitive 0 [IF] [ElSe] s" case insensitive" TYPE CR [THEN]
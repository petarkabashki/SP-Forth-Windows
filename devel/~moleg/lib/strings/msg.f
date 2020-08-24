\ 2008-11-24 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ ������ �� ������� ���������

 REQUIRE ?DEFINED     devel\~moleg\lib\util\ifdef.f
 REQUIRE FILE>HEAP    devel\~moleg\lib\win\file2heap.f
 REQUIRE ROUND        devel\~moleg\lib\util\stackadd.f
 REQUIRE VAL          devel\~moleg\lib\parsing\number.f

\ ���������� ������ asc # �� ���������� ������ addr
?DEFINED SCOPY : SCOPY   ( asc # addr --> ) 2DUP C! 1 + SWAP CMOVE ;

\ ��������� ������ � ����������� ����� ������
?DEFINED >STDERR : >STDERR ( asc # --> ) H-STDERR WRITE-FILE DROP ;

\ ------------------------------------------------------------------------------

VOCABULARY Messages
           ALSO Messages DEFINITIONS

        USER msg-list \ ������ �� ��������� ��������� � ������
        USER-VALUE last-msg    \ ����� ���������� ���������� ���������

0 \ ������ ������ ���������
  CELL -- off_msgPrev  \ ����� ����������� ���������
  CELL -- off_msgName  \ ����� �������� ���������
     1 -- off_msgBody  \ ������ ��������� ������ �� ��������� �����
CONSTANT /msgRecord

\ �������� ����� ��������� � ������ ���������
: new-msg ( asc # msg --> )
          OVER /msgRecord + ALLOCATE THROW
          TUCK off_msgName !
          DUP >R off_msgBody SCOPY
          R@ msg-list change
          R> off_msgPrev ! ;

\ ����� ��������� � ������ ��������� �� ��� ������
: find-msg-num ( msg --> asc # true | msg false )
           >R msg-list @
           BEGIN DUP WHILE
                 DUP off_msgName @ R@ <> WHILE
               off_msgPrev @
             REPEAT RDROP off_msgBody COUNT TRUE EXIT
           THEN R> SWAP ;

\ ����� ����� ��������� �� ����������� ���������
: find-msg-body ( asc # --> msg | asc # false )
                2>R msg-list @
                BEGIN DUP WHILE
                      DUP off_msgBody COUNT 2R@ COMPARE WHILE
                      off_msgPrev @
                  REPEAT off_msgName @ RDROP RDROP EXIT
                THEN 2R> ROT ;

\ ����� ����� ��� ���������� ���������
: num-msg ( --> err )
          last-msg BEGIN 1 + DUP find-msg-num WHILE 2DROP REPEAT TO last-msg ;

\ ����� ��������� � ������ msg-list, ���������� ��� �����
\ ���� ��������� � ��������� �������� err �� �������, ���������� ������
: ~MESSAGE ( err --> ) find-msg-num IF ELSE 0 (D.) THEN TYPE ( >STDERR) ;

\ ���������� ��������� � ������� msg ���� flag ������� �� ����,
\ ��������� THROW � ����� msg, ���� ���� = 0 �������� �� �����������
: (ABORT) ( flag msg --> )
          SWAP IF DUP ~MESSAGE THROW ELSE DROP THEN ;

\ �� ����������� ������ asc # ���������� ����� ���������
: reffered ( asc # --> msg )
           find-msg-body DUP IF ELSE DROP num-msg DUP >R new-msg R> THEN ;

ALSO FORTH DEFINITIONS

\ ������������� ��� ���������
: NOTICE" ( / message" --> )
          ?COMP [CHAR] " PARSE reffered
          [COMPILE] LITERAL ; IMMEDIATE

\ ������� ��������� � ������
: ERROR" ( / message" --> )
         ?COMP [CHAR] " PARSE reffered
         [COMPILE] LITERAL POSTPONE DUP POSTPONE ~MESSAGE POSTPONE THROW
         ; IMMEDIATE

\ ������������� ���, � ������ ������ ��������� ��������� message
: ABORT" ( / message" --> )
         ?COMP [CHAR] " PARSE reffered
         [COMPILE] LITERAL POSTPONE (ABORT) ; IMMEDIATE

\ ������������� ���, ��������� ��������� message
: MESSAGE" ( / message" --> )
           [CHAR] " PARSE reffered
           STATE @ IF [COMPILE] LITERAL POSTPONE ~MESSAGE
                    ELSE DROP \ � ������ ������������� ���������
                              \ ����������� � ������ ���������
                   THEN ; IMMEDIATE

\ ��������� ��� ��������� � ���� � ��������� ������
: save-messages ( asc # --> )
                W/O CREATE-FILE THROW >R
                msg-list
                BEGIN @ DUP WHILE
                      DUP off_msgName @ 0 (D.) R@ WRITE-FILE THROW
                        S"  " R@ WRITE-FILE THROW
                        DUP off_msgBody COUNT R@ WRITE-FILE THROW
                        LT LTL @ R@ WRITE-FILE THROW
                    off_msgPrev
                REPEAT DROP R> CLOSE-FILE THROW ;

\ ��������� ������ ��������� � ������ �� ����� Asc #
: load-messages ( asc # --> flag ) FILE>HEAP
                IF SAVE-SOURCE N>R SOURCE! 0 >IN !
                   BEGIN NextWord DUP WHILE
                         OVER C@ [CHAR] \ =
                         IF 2DROP 13 PARSE 2DROP \ ������� ����������
                          ELSE VAL >R 13 PARSE R> new-msg
                         THEN
                         1 >IN +!
                   REPEAT 2DROP
                   NR> RESTORE-SOURCE
                 ELSE FALSE EXIT
                THEN TRUE ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ������������ ������
      S" devel\~mOleg\lib\strings\spf.msg" load-messages 0 = THROW
      : ttt NOTICE" sample test" ;
      : zzz NOTICE" sampled test" ;
      : vvv NOTICE" sample test" ;
      ttt vvv <> THROW \ ������, ���� ��������� �����������
      : test MESSAGE" passed" ;
      S" .\devel\~mOleg\lib\test.msg" save-messages
    test
}test
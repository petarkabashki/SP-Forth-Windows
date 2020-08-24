\ 2006-12-09 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� ����� ������������ � ������ ������� ����

 REQUIRE COMPILE  devel\~mOleg\lib\util\compile.f
 REQUIRE SeeForw  devel\~mOleg\lib\util\parser.f
 REQUIRE FRAME    devel\~mOleg\lib\util\stackadd.f

\ -- ��������� ----------------------------------------------------------------

?DEFINED char  1 CHARS CONSTANT char

\ -- ���������� ---------------------------------------------------------------

\ ��� ������ ��������� � ������������ ������
\ ������ ������������ � ������ �����
: \. ( --> ) 0x0A PARSE CR TYPE ;

\ ���������� �� ����� ������ (��� ���������� �������������� ������ ����)
: \? ( --> ) [COMPILE] \ ; IMMEDIATE

\ ����������� ���������� �������� ������ �
\ � ������� �� ������� ����� ��� ���������� � ������� �������� �
\ ��������� �������� ������, � ���������� � ������������ �����
\ ��������� ��������� ������� ������ ����� � ����� �����.
\ ����� ������� ���������� ����� ����������� ������ � �����������.
: \EOF  ( --> )
        SOURCE-ID DUP IF ELSE TERMINATE THEN
        >R 2 SP@ -2 CELLS + 0 R> SetFilePointer DROP
        [COMPILE] \ ;

\  -- ������� ------------------------------------------------------------------
\ �������� � ��������� ������ ����� ������� �������
: SEAL ( --> ) CONTEXT @ ONLY CONTEXT ! ;

\ �������� ������� ����������� ������� ���������
: WITH ( vid --> ) >R GET-ORDER NIP R> SWAP SET-ORDER ;

\ ������� ������� ������� � ������� ���������, ��������� �� ���
\ ������� �������.
: RECENT ( --> )
         GET-ORDER 1 -
           DUP IF NIP OVER SET-CURRENT SET-ORDER
                ELSE DROP
               THEN ;

\ ��������� vid ������� � ������� ��������� � CURRENT
: THIS ( --> ) CONTEXT @ SET-CURRENT PREVIOUS ;

\ �������� ������� ��� ������� �� ������� ���������
: UNDER ( --> ) GET-ORDER DUP 1 - IF >R SWAP R> THEN SET-ORDER ;

\ ��������� ������� ��������� ���������, �������� �������
: SaveOrder ( addr --> )
            >R GET-ORDER GET-CURRENT SWAP 1 + DUP
            1 + >R SP@ 2R> CELLS CMOVE nDROP ;

\ ������������ ����������� ��������� ���������, ������� �������
: LoadOrder ( addr --> )
            DUP >R @ 1 + FRAME CELLS >R SP@ R> R> -ROT CMOVE
            SWAP SET-CURRENT 1 - SET-ORDER ;

\ -- ������������� ������������ ���� ������� ----------------------------------

\ ������������� �� HERE n ���� ������, ��������� �� ������ char
: AllotFill  ( char n --> ) HERE OVER ALLOT -ROT FILL ;

\ ������������� �� HERE n ���� ������, ��������� �� ������
: AllotErase ( n --> ) 0 SWAP AllotFill ;

\ -----------------------------------------------------------------------------

\ ��������� �������� funct � ������� �� �������� namea .. namen,
\ ������������� �� ����� ������, ��������: ToAll VARIABLE aaa bbb ccc
: ToAll ( / funct namea ... namen --> )
        ' >R BEGIN SeeForw WHILE DROP
                   R@ EXECUTE
             REPEAT DROP RDROP ;

\ ������� ���� TRUE , ���� ������� ������� ESC
\ ��� ������� ����� ������ ������� ������ �������� ������� ���������
\ ���� ������ �������� �� ESC ������� - ������� FALSE ����� TRUE
: ?PAUSE ( --> flag )
         KEY? IF KEY 0x1B =
                 IF TRUE EXIT
                  ELSE KEY 0x1B =
                    IF TRUE EXIT THEN
                 THEN
              THEN FALSE ;

\ ��������� ����� �� ��� ���, ���� �� ����� ������ ����� �������
\ ������ �������������: : test ." ." ; PROCESS test
: PROCESS ( / name --> )
          ' >R BEGIN ?PAUSE WHILENOT
                     R@ EXECUTE
               REPEAT
            RDROP ;

\ ��������� ��������� ����� ��� ������ �� �����������
: GoAfter ( --> ) ' [COMPILE] LITERAL COMPILE >R ; IMMEDIATE

\ ��������� ���, ����� �������� ��������� � ������ ������ �� addr
: PERFORM ( addr --> ) @ EXECUTE ;

\ �������� �������� VECT ����������
: FROM ( / name --> cfa )
       ' 0x05 +
       STATE @ IF LIT, POSTPONE @
                ELSE @
               THEN ; IMMEDIATE

\ ������� ���������� ��� ��������� �� ������
: ECATCH ( xt --> err )
         FROM <EXC-DUMP> >R
         ['] NOOP TO <EXC-DUMP>
         CATCH
         R> TO <EXC-DUMP> ;


\ �� �� ��� � : ������ ��� �������� �� ������� ����� ������
\ � ���� ������ �� ���������. ������:  S" name" S: ��� ����� ;
?DEFINED S: : S: ( asc # --> ) SHEADER ] HIDE ;

\ ������� ������ ������ �� ��������� ����������
?DEFINED SERROR : SERROR ( asc # --> ) ER-U ! ER-A ! -2 THROW ;

\ ����� �� x ������ �� �������� a ��� b
: ANY ( x a b --> flag ) ROT TUCK = -ROT = OR ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
    VECT ZZZZ  ' DROP TO ZZZZ
    : test1 FROM ZZZZ ['] DROP <> ; test1 THROW
    : test2 ['] @ CATCH ;  12345 DUP HERE ! HERE test2 THROW <> THROW
  S" passed" TYPE
}test

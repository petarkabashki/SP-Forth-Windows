\ 22-02-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� DO LOOP ��� ��� - ������������ �������.

\ �������� ��� ������������� � ����������� lib\ext\locals.f
\ ����������, ����� ������� ���� ��������� ����� ���� �����������

 REQUIRE COMPILE   devel\~moleg\lib\util\compile.f

?DEFINED [IF] lib\include\tools.f

\ ---------------------------------------------------------------------------

\ �� ����� ��������� ����� 4-�� ���������.
\ ����� ������ �� �����
\ ������� ������ �����
\ ������� �����
\ ����� ������ �� LOOP �����

\ ������� ������� �������� �����
: I ( --> index )
    \ 2R> R@ -ROT 2>R
    8 RP+@ ;

\ ������� ������� �������� �����.
: J ( --> ext_index ) 24 RP+@ ;

\ ���������� ����� �� �����
: LEAVE ( --> ) RDROP RDROP RDROP RDROP ;

\ ����� �� ����� �� EXIT
: exitdo ( --> ) RDROP RDROP RDROP ;

\ ���������� ��������� ����� - ����������� ���� ��� �� �����
: (DO) ( up low --> ) R> -ROT 2>R ['] exitdo >R >R ;

\ ���������� �������� �����, �������� ������� ������ �� �����. �
: (+LOOP) ( n --> flag )
          DUP 0 < IF    2R> ROT R> + R@ OVER >R <
                   ELSE 2R> ROT R> + R@ OVER >R < 0=
                  THEN -ROT 2>R ;

\ ---------------------------------------------------------------------------

\ ������ ���������� �����, ��������������� ������� �����
: DO ( up low --> )
     ?COMP
     HERE 0 RLIT, 1 + \ �������� ������ ������ �� LEAVE
     0
     COMPILE (DO)
     [COMPILE] BEGIN ; IMMEDIATE

\ ������ ���������� ����� � ������������ - ���� up ������ low
\ ���������� ����� ����������
: ?DO ( up low -->  )
      ?COMP
      HERE 0 RLIT, 1 + \ �������� ������ ������ �� LEAVE
      COMPILE 2DUP COMPILE > [COMPILE] IF
      COMPILE (DO)
      [COMPILE] BEGIN ; IMMEDIATE

\ ����� ���������� ��� ���������� �����, �������� ���������� DO ��� ?DO
\ ���������� �������� ����� ������������ ���������� ��������
\ �������� ����� ������
: +LOOP ( n --> )
        ?COMP
        COMPILE (+LOOP)
        [COMPILE] UNTIL
                  COMPILE RDROP COMPILE RDROP COMPILE RDROP COMPILE RDROP

        DUP IF [COMPILE] ELSE COMPILE 2DROP COMPILE RDROP [COMPILE] THEN
             ELSE DROP
            THEN
        HERE SWAP !

        ; IMMEDIATE

\ ����� ���������� ��� ���������� �����, �������� ���������� DO ��� ?DO
\ ���������� �������� ����� = 1
: LOOP ( --> ) ?COMP 1 LIT, [COMPILE] +LOOP ; IMMEDIATE

\ ������ ��������� ����� �������� ������. UNLOOP ��������� ��� �������
\ ������ �������� ������ ����� ������� �� ����������� �� EXIT.
: UNLOOP ( --> ) R> RDROP RDROP RDROP RDROP >R ;

TRUE ?DEFINED vocLocalsSupport DROP FALSE
[IF]
   ALSO vocLocalsSupport DEFINITIONS ALSO FORTH
     : DO    FORTH::POSTPONE DO     [  4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
     : ?DO   FORTH::POSTPONE ?DO    [  4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
     : LOOP  FORTH::POSTPONE LOOP   [ -4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
     : +LOOP FORTH::POSTPONE +LOOP  [ -4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
   PREVIOUS PREVIOUS DEFINITIONS
[THEN]

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ : simple 10 DUP DUP 0 DO DROP I LOOP 1 + <> THROW ; simple
      : test?do DEPTH >R 0 0 ?DO I LOOP DEPTH R> <> THROW ; test?do
      : testlv 3 DO I LEAVE LOOP ;
      : testleave 10 testlv 3 <> THROW ; testleave
      : testij 10 3 DO 10 3 DO I J UNLOOP LEAVE LOOP LOOP <> THROW ; testij
      : testexit 10 1 DO 20 9 DO EXIT LOOP LOOP -1 THROW ; testexit

  S" passed" TYPE
}test

\ 18-05-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������� ������ � �������� ��������� �� ������
\ ������������� �������� ��������� � ������� � �������

\ -- �������� ����� ---------------------------------------------------------

\ �������� ����� � ������������ �� ����� ���������
: R+ ( r: a d: b --> r: a+b ) 2R> -ROT + >R >R ;

\ ������������� �� HERE n ���� ������, ��������� �� ������ char �
: ALLOTFILL ( n char --> ) HERE OVER ALLOT -ROT FILL ;

\ ��������� ����� base �� ��������� �������� n �
\ ������� ������������ ������������.
\ ������������ ������������ � ������� �������
: ROUND ( n base --> n ) TUCK 1 - + OVER / * ;

   0x09 CONSTANT tab_  \ ��� ������� ���������

\ -- ������������ �������������� ������ -------------------------------------

        USER-VALUE buffer  \ ����� ���������� ������
        USER-VALUE out>    \ ������� � ������� ����� ��������� ������ � �����

     20 CONSTANT tab-limit \ ���������� ������ ���������

   CREATE spaces_ tab-limit BL ALLOTFILL \ ������ ��������

\ ���������� � ����� ������ asc # � ��� ���������
: >out ( asc # --> ) DUP IF out> SWAP 2DUP + TO out> CMOVE ELSE 2DROP THEN ;
: c>out ( char --> ) out> TUCK C! 1 CHARS + TO out> ;

\ ������� � ����� ��������� ���-�� ��������
: gap ( # --> ) spaces_ SWAP tab-limit UMIN >out ;

\ �������� ����� � ������ ��������� � ������ ������
: result> ( --> asc # ) buffer out> OVER - ;

\ ������������ ������
: free-result ( --> ) buffer IF buffer FREE THROW 0 TO buffer THEN ;

\ ������������� ������
: init-buffer ( # --> )
              free-result
              CELLS ALLOCATE THROW
              DUP TO buffer TO out> ;

\ -- �������������� ��������� � ������� -------------------------------------

\ ��������� ���������� �������� �� ���� ��������� ��� �������� �������
: space# ( pos tab# --> spaces )
         TUCK OVER >R ROUND R> -
         DUP IF NIP ELSE DROP THEN ;

\ �������� �� ������ ���������, �������������� ��������� ��������
: piece ( src # char --> res # )
        >R OVER + OVER
        BEGIN 2DUP <> WHILE       \ ���� ���� ������� � ������
              DUP C@ R@ <> WHILE  \ ���� ������ �� ������
            1 CHARS +
          REPEAT
        THEN RDROP NIP OVER - ;

\ ��������� ������ �� ��� ��������� �� ������� char
: split ( src # char --> rest # res # )
        >R 2DUP R> piece TUCK 2>R - NIP 2R@ + SWAP 2R> ;

\ ������� ���������� ������� � �������� ������
: pos ( --> u ) out> buffer - ;

\ ������������� ��������� ������,
\ ���������� ������� ��������� � ������ � ���������
: tabs>spaces ( src # tab# --> res # )
              OVER init-buffer >R
              BEGIN tab_ split >out  DUP WHILE
                    pos R@ space# gap
                  SKIP1
              REPEAT RDROP 2DROP result> ;

\ -- �������������� �������� � ��������� ------------------------------------

        USER inpos \ ������� �������

\ ��������� ���������� �������� �� ������ ������
: count-spaces ( asc # --> res # n )
               0 >R OVER + SWAP
               BEGIN 2DUP <> WHILE     \ ���� �� ����� ������
                     DUP C@ BL = WHILE \ ���� �������
                   1 R+ 1 CHARS +
                 REPEAT
               THEN TUCK - R> ;

\ ������������� �������, ���� �������� � ���������
: convert-spaces ( pos n tab# --> )
                 >R BEGIN DUP WHILE
                          OVER R@ space#  2DUP < 0= WHILE
                          DUP inpos +!
                          TUCK - >R + R>
                        tab_ c>out
                      REPEAT SWAP DUP inpos +! gap
                    THEN RDROP 2DROP ;

\ ������������� ��������� ������ src #, ���������� �������
\ � ������ ���������� ��������� ������ ���������� �������
\ ������������������� ��������.
: spaces>tabs ( src # tab# --> res # )
              OVER init-buffer >R  0 inpos !
              BEGIN BL split DUP inpos +! >out  DUP WHILE
                    count-spaces inpos @
                    SWAP R@ convert-spaces
              REPEAT RDROP 2DROP result> ;

\ EOF -- �������� ������ ----------------------------------------------------

\ ��������� ���������� ����� � ������
: source ( FileName # --> addr # )
         R/O OPEN-FILE THROW >R
           R@ FILE-SIZE THROW DROP
              DUP ALLOCATE THROW
           TUCK SWAP R@ READ-FILE THROW
         R> CLOSE-FILE THROW ;

S" sample.txt" source
              2DUP TYPE 2DUP DUMP CR
8 tabs>spaces 2DUP TYPE 2DUP DUMP CR
8 spaces>tabs 2DUP TYPE DUMP CR


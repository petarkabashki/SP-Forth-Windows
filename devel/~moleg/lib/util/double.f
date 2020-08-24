\ 28-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � ������� ������� ������

 REQUIRE ADDR     devel\~moleg\lib\util\addr.f
 REQUIRE COMPILE  devel\~moleg\lib\util\compile.f
 REQUIRE ALIAS    devel\~moleg\lib\util\alias.f

\ -- �������� ����������� ----------------------------------------------------

 ALIAS 2DROP DDROP ( d --> )
 ALIAS 2DUP  DDUP  ( d --> d d )
 ALIAS 2SWAP DSWAP ( da db --> db da )

 ALIAS 2>R   D>R
 ALIAS 2R>   DR>
 ALIAS 2R@   DR@

\ ���������� �� ������� ����� ������� �����,
\ ����������� ��� ������� �� �� ������� �����
: DOVER ( da db --> da db da ) D>R DDUP DR> DSWAP ;

\ ������� ������ ������� �����, �� ������� �����
: DNIP ( da db --> db ) D>R DDROP DR> ;

\ ��������� ������� �����, ����������� �� ������� ����� ������ ��� ������ d
: DTUCK ( da db --> db da db ) DDUP D>R DSWAP D>R ;

\ -- ������ � ������� -------------------------------------------------------

 ALIAS 2@ D@ ( addr --> d )
 ALIAS 2! D! ( d addr --> )

\ ������������� ������� ����� �� ������� ���������
: D, ( d --> ) HERE 2 CELLS ALLOT D! ;

\ -- ���������, ����������, �������� ������� ����� --------------------------

\ ������� ���������� ���������� �������� ����� ������� �����
: DVARIABLE ( / name --> ) CREATE 0 0 D, DOES> ;

\ ������� ���������� ��������� ��� ����� ������� ����� d
: DCONSTANT ( d / name --> ) CREATE D, DOES> D@ ;

\ ����� ���������� �������� ����� �� VALUE ���������� ������� �����
: DVAL-CODE ( r: addr --> d ) R> A@ D@ ;

\ ����� ���������� �������� ����� � VALUE ���������� ������� �����
: DTOVAL-CODE ( r: addr d: d --> )
              R> [ CELL CFL + ] LITERAL - A@ D! ;

\ ������� ���������� VALUE ����������, �������� ����� ������� �����
: DVALUE ( d / name --> )
         HEADER
         COMPILE DVAL-CODE HERE >R 0 ,
         COMPILE DTOVAL-CODE ALIGN HERE R> A!
         D, ;

\ ����� ���������� �������� ����� �� VALUE ���������� ������� �����
: DUVAL-CODE ( r: addr --> d ) R> A@ TlsIndex@ + D@ ;

\ ����� ���������� �������� ����� � VALUE ���������� ������� �����
: DTOUVAL-CODE ( r: addr d: d --> )
               R> [ CELL CFL + ] LITERAL - A@ TlsIndex@ + D! ;

\ ������� ���������������� ���������� ���������� ������� �����
: USER-DVAL ( --> d )
            HEADER
            COMPILE DUVAL-CODE USER-HERE ,
            COMPILE DTOUVAL-CODE
            2 CELLS USER-ALLOT ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 1 DEPTH NIP
       1 2 2DUP DVALUE sample sample D= 0= THROW
       3 4 2DUP TO sample sample D= 0= THROW

       USER-DVAL simple
       4 5 2DUP TO simple  simple D= 0= THROW
       6 7 2DUP DCONSTANT proba proba D= 0= THROW
       7 8 2DUP DVARIABLE test test 2!  test 2@ D= 0= THROW
      DEPTH <> THROW
  S" passed" TYPE
}test

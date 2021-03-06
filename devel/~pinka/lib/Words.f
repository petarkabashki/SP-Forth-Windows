\ ===========================================================================
\ 03.01.2000, Ruvim Pinka
\ for SPForth3*

: ForEach-Word  ( xt wid -- )
\ ��������� xt ��� ������ ������ ������� wid 
\ ( �����������, wid @ - ���� NFA ���������� ����� )
\ xt ( i*x NFA - j*x )
    @
    BEGIN  ( xt NFA | xt 0 )
      DUP
    WHILE  ( xt NFA )
      2DUP 2>R SWAP EXECUTE 2R>
      CDR  ( xt NFA2 )
    REPEAT  2DROP
;

\ ===========================================================================
: >NAME  ( xt -- NFA|0 )  \ ����������� ������� �� ����������!
  0 (NEAREST-NFA) NIP \ ��� ����� ����� ���� �������, SPF4.19
;

\ ===========================================================================
\ 09.05.2000

REQUIRE LAMBDA{  ~pinka\lib\lambda.f 

: ReversLink ( nfa -- ) \  ������������� ����� ������� � ����������� ( ���������� � ������) ����
    DUP                 \ �������������� ��������, ���� � ������ ������ ��� ���� (�� ������).
    NAME>L DUP >R @   ( nfa nfa2 ) ( R: lfa )
    NAME>L DUP @ R> ! ( nfa lfa2 ) !
;
: ReversWL ( wid -- ) \  ������������� ������ ����
    >R  0 
    LAMBDA{ SWAP 1+ } R@ ForEach-Word ( i*x i )
    ?DUP IF 1- SWAP R> !   \ ������ � ������ ���������� ������ ��������� ����� (��������� - ���������)
    ELSE RDROP EXIT  THEN  \ �����, ���� ������ ����.
    BEGIN DUP WHILE
      1- SWAP ReversLink
    REPEAT DROP
;
\ ===========================================================================
\ $Id: Words.f,v 1.2 2007/11/11 19:59:11 ruv Exp $
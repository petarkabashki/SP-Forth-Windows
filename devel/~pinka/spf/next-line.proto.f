\ 05.Dec.2006 ruvim@forth.org.ru
\ $Id: next-line.proto.f,v 1.4 2006/12/25 19:51:14 ruv Exp $
\ �������� �������, �������������� �������� �����
\ arche

( xt_of_readout_data -- )
\ xt_of_readout_data ( a u1 -- a u2 ior )

: readout? ( a u1 -- a u2 flag )
  [ COMPILE, ] THROW DUP 0<>
;

VARIABLE B0  \ ������ ������
VARIABLE R   \ ��������� ������
VARIABLE W   \ ��������� ������
VARIABLE B9  \ ����� ������, �������
\ � ��������� ������������ � �������� ����� ������ :)

: BUF! ( a u -- ) OVER DUP B0 ! DUP R ! W !  + B9 ! ;
: BUF ( -- a u ) B0 @ B9 @ OVER - ;
: REST ( -- a u ) R @ W @ OVER - ;
: VACANT ( -- a u ) W @ B9 @ OVER - ;
: CARRY ( a u -- )  ( OVER B0 @ = IF 2DROP EXIT THEN ) BUF SEATED + W ! B0 @ R ! ;
: ELAPSE ( a u -- ) + R ! ;
: REST! ( a u -- ) DROP R ! ;
: REST+! ( a u -- ) + W ! ;
: ?UNBROKEN ( a u -- a u1 ) W @ B9 @ - 0= IF UNBROKEN THEN ;

: NEXT-LINE ( -- a u true | false )
  BEGIN  REST >CHARS SPLIT-LINE IF CHARS REST! TRUE EXIT THEN CHARS CARRY
  VACANT DUP WHILE readout? WHILE REST+! REPEAT THEN 2DROP
  REST DUP IF >CHARS ?UNBROKEN 2DUP CHARS ELAPSE TRUE EXIT THEN NIP ( false )
;
\ �.�. ����� -- ��� ���������� ���� ������, ������ ����� ������ �� ����������� �������!
\ ���� ������ ��������� � ����� (�� ����, � ������ ����� ��� ����), �� UNBROKEN �������.

: READOUT ( addr u -- addr u2 )
\ ������ �������� ������ �� ������;
\ �������� ���� ��, ��� ��� �� ���� NEXT-LINE
  OVER >R
  DUP REST ROT OVER ( u u-rest ) U< IF
  ( addr u a-rest u-rest ) ( R: addr )
    DROP OVER 2DUP ELAPSE R> SWAP MOVE EXIT
  THEN
  CROP- readout? DROP + R> TUCK -
;

\ 13.Dec.2005
\ 04.Nov.2006 Sat 21:37
\ $Id: split-white.f,v 1.1 2006/12/18 19:59:08 ruv Exp $

: IS-WHITE ( c -- flag )  \ or 'IsWhite' ?
  0x21 U<
;
: FINE-HEAD ( c-addr u -- c-addr1 u1 )
\ "�������� ������" - ���� ������ �� ������� ���������� �������� �������
  BEGIN DUP WHILE OVER C@ IS-WHITE WHILE SWAP CHAR+ SWAP 1- REPEAT THEN
;
: FINE-TAIL ( c-addr u -- c-addr u2 ) \ see also "-TRAILING"
\ "�������� �����" - ���� ������ �� ������� ���������� �������� � �����
  CHARS OVER + BEGIN 2DUP U< WHILE CHAR- DUP C@ IS-WHITE 0= UNTIL CHAR+ THEN OVER - >CHARS
;
: SPLIT-WHITE-FORCE ( c-addr u -- c-addr-left u-left  c-addr-right u-right )
\ 'FORCE' ������, ��� ��� �����
\ ���� ����������� �� ������, �� ������ ����� ����� ����� 0.
\ white ��� �� ����� ����� ���� (�.�., �� �������� � ������ �����)
  2DUP CHARS OVER + SWAP
  BEGIN 2DUP U> WHILE DUP CHAR+ SWAP C@ IS-WHITE UNTIL CHAR- THEN
  ( c-addr u  a2 a1 )
  DUP >R - >CHARS  DUP >R -  2R>
;
: -SPLIT-WHITE-FORCE ( c-addr u -- c-addr-left u-left  c-addr-right u-right )
\ ����� � �������� �����������,  ������� � ����� ������
\ ���� ����������� �� ������, �� ����� ����� ����� ����� 0.
\ ���� ������, �� �� �������� � ����� �����.
  2DUP CHARS OVER +
  BEGIN 2DUP U< WHILE CHAR- DUP SWAP C@ IS-WHITE UNTIL CHAR+ THEN
  ( c-addr u  c-addr c-addr1 )
  TUCK >R - >CHARS TUCK - R> SWAP
;
: UNBROKEN ( c-addr u -- c-addr u2 )
\ ���� � ����� ��� ���������� ��������, �� � ������ ��� �������,
\ �� ���������� ��������� ����� ��� ������������ � �����������.
  -SPLIT-WHITE-FORCE 2 PICK IF 2DROP EXIT THEN 2SWAP 2DROP
;

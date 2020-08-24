\ 14-01-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ DOES> �������� ��� ���
\ ��������������� ������� �� ������� ���������� DOES>A � ����� ������������.

 REQUIRE ADDR     devel\~moleg\lib\util\addr.f
 REQUIRE COMPILE  devel\~moleg\lib\util\compile.f

\ �� �����, ������� �������� ������������ � CREATE (������) �
: (DOES1) ( r: addr --> ) LATEST NAME> R> OVER - CFL - SWAP 1 + A! ;

\ ��� ����� ����������� �� ����� ������ ���� �� DOES> �
: (DOES2) ( --> addr )
          2R> EXECUTE \ ����� ������� �������
          \ 2R> >R    \ ����� ������������ �������
          ;

\ �� ����� ���������� ��������� ����� �� DOES> � ������� ������������   �
\ ������������ � ���� � CREATE : name CREATE data, DOES> ( --> 'data ) ;
: DOES> ( --> )  ?COMP  COMPILE (DOES1)  COMPILE (DOES2) ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ : sample CREATE , DOES> @ ;
      123 DUP sample abc  abc <> THROW
      234 DUP sample bcd  bcd <> THROW
  S" passed" TYPE
}test
\ 06-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ �������� ��� ������ �� �������� �����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

?DEFINED char  1 CHARS CONSTANT char

\ ������� ������ ������� ������
: EMPTY" ( --> asc # ) S" " ;

\ ������������� ������ � ������, ���������� ���� ������
: Char>Asc ( char --> asc # ) SYSTEM-PAD TUCK C! 0 OVER char + C! char ;

\ ��������� ������ asc # �� u �������� �� ������
: SKIPn ( asc # u --> asc+u #-u ) OVER MIN TUCK - >R + R> ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ CHAR � Char>Asc S" �" COMPARE 0<> THROW
      S" aksdjhf" 3 SKIPn S" djhf" COMPARE 0<> THROW
  S" passed" TYPE
}test

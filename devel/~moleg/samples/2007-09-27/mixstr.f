\ 27-09-2007 ~mOleg  SPF4.18
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���������� ����� ����� ��������� �������

 S" .\lib\ext\rnd.f" INCLUDED \ ���������� ��������� ��������������� �����

\ �������� ���������� �����, �� ���������� �� addr �� char,
\ ������ �������� �������
: ExBytes ( char addr --> oldchar ) DUP C@ -ROT C! ;

\ �������� �������� �������� ���� ����� ������ �������
: ChBytes ( addra addrb --> ) OVER C@ SWAP ExBytes SWAP C! ;

\ ���������� ���������� ������ ��������� �������
: mix ( asc # --> asc # )
      2DUP OVER + SWAP DO 2DUP CHOOSE + I ChBytes LOOP ;

\ ���������� ��� ������� ����� �������
: mmix ( asc # --> asc # )
       3 OVER < IF ELSE EXIT THEN  \  �� ����� ���� �������� � ������
       2DUP 1 -2 D+ mix 2DROP ;

\ ���������� ��������� ��������� ����������� ������, ����������� �� mixstr
: mixstr ( / asc --> )
         BEGIN NextWord DUP WHILE
               mmix TYPE SPACE
         REPEAT 2DROP CR ;

mixstr �� ����� ���� �� ��� ������ ��������� ����� � ������������� ���������.
mixstr �������� �� ��� ����� ����� ������������ , � ���� ������������ �������
mixstr ���� � �����


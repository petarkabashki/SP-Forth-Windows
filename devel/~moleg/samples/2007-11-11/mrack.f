 HEX

 \ ������� ������ ������ ������������� �����
 : dmk
 F 7 B 3 D 5 9 1 E 6 A 2 C 4 8 0
 10 ALLOCATE THROW
 10 0 DO DUP I +  ROT SWAP C! LOOP ;
 dmk VALUE ddmk

 : revarr_ ( c -- c' )
   \ ����� �� ����� ��������� �� ������������
   8 0 DO DUP 0x00000F AND SWAP 4 RSHIFT LOOP DROP
   \ ������������ ���������� � �������� ������� ������� �� ����������
   0 8 0 DO ddmk ROT + C@ I 4 * LSHIFT  + LOOP ;

 \ ���������� ����������� �������
 : revarr ( adr u -- )
   0 DO DUP I CELLS + DUP @ revarr_ SWAP ! LOOP DROP ;

DECIMAL
\ ������ ���������� ����� OLD-WORD �� NEW-WORD
\ ��� ��������������
( � ������ ������� ����� ����������� ������� �� �����)

BASE @ HEX
: JMP ( addr-to addr-from -- )
  >R
  0E9 R@ C!
  R@ 1+ CELL+ - R> 1+ !
;
BASE !

\ ' NEW-WORD ' OLD-WORD JMP

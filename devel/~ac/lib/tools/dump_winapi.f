: DUMP-WINAPI
  WINAPLINK @
  BEGIN
    DUP
  WHILE
    DUP CELL- CELL- @ ASCIIZ> TYPE ." :" \ ����� ������������ ������ ��� ����������
    DUP CELL- CELL- CELL - @ . ." :"
    DUP CELL- @ ASCIIZ> TYPE
    CR
    @
  REPEAT DROP
;
\ DUMP-WINAPI

\ �������� ���� �������� ��� ������ ����
\ CONST �����������
\   ���������0 ���������0
\   ...
\   ���������n ���������n
\ ;
\ ������ ����� ���� �� ������!

: CONST  
  BEGIN
    REFILL 0= ABORT" CONST without ;" 
    NextWord S" ;" COMPARE
  WHILE
    INTERPRET  0 >IN ! CONSTANT
  REPEAT ;

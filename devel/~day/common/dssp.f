\ ����������� ����������� � ����� DSSP.
\ �������� ������������������� � '������������' ���������
\ �� ��� � DSSP - �������� - �� ����� ����� ����������� ����� ������
\ ������ DSSP - ������� ������ ����� :)
\ �� � DSSP �� ���� ������������ ������ (��� ����� � ��� ������)
\ � ���� �� ���� ����� ������� ����������

\ ���� ����� �� ����� �� 0 �� ����������� ��������� �����
\ ������ ��� ������ ����������!

: IFN ( "word" -- )
  STATE @
  IF
    HERE ?BRANCH, >MARK
    ' COMPILE,
    >RESOLVE1
  ELSE -312 THROW 
  THEN
; IMMEDIATE


\ ���������� ��� ������ ������������� - ������� ����� - ��� ������
\ ������ - DEBUG @ IFDEF S" Warning! Debug mode."

: IFDEF
  STATE @ 0=
  IF
    1 PARSE ROT
    IF
       EVALUATE
    ELSE
       2DROP
    THEN
  ELSE DROP
  THEN
; IMMEDIATE


( \ ex:

: TEST ." IFN is Ok" ;
: TEST2 IFN TEST ;

-1 TEST2
0 TEST2
)

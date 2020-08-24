REQUIRE STR@ ~ac/lib/str5.f
REQUIRE [DEFINED] lib/include/tools.f
REQUIRE state-table ~profit/lib/chartable.f

\ "���������" (generic) ���������� ���������� �����
\ _���������_ � ������. �� ��������� �� ���� ���������� 
\ ������������� ��������� �������� ��������� �������:

\ -- ������ �� ������  \ cell_reference_occured
\ -- �������� �������� \ nonnegative_number_occured
\ -- ���������         \ operation_occured
\ -- ������            \ error_occured

\ ��������� ���������� ���� ������ ���� ������� ��������
\ �� ��������� ������ ����������� ������� ���������
\ ������ ���������� � ��� �� ������� � ����� �������
\ ����������� � �������� ������.
\ ���������� ������ ���������� ��� ������� ������������ �������


\ ���� ���� �� �������� ����������� � �� ������ ������������ � ���������,
\ ��� ���������� "�����������" �����-����������� (������ ���� ����������� ������):

[UNDEFINED] cell_reference_occured [IF] : cell_reference_occured ( row col -- ) 2DROP ; [THEN]
[UNDEFINED] nonnegative_number_occured [IF] : nonnegative_number_occured ( n -- ... ) DROP ; [THEN]
[UNDEFINED] operation_occured [IF] : operation_occured ( char -- ) DROP ; [THEN]
[UNDEFINED] error_occured [IF] : error_occured  ( -- ) ; [THEN]


\ ��� ��� ��������� �������� ���:
\      expression ::= '=' term {operation term}*
\      term ::= cell_reference | nonnegative_number
\      cell_reference ::= [A-Za-z][0-9] -- 
\      operation ::= '+' | '-' | '*' | '/'

\ ����� �� ���� �����, �� ����� �������� ���� ��������� ��������
state term
state cell_reference_Col \ �������� ���� �� ����� ���� ������� ������
state cell_reference_Row \ � ���� ������ ������
state nonnegative_number
state operation

0 VALUE col

term
all: error_occured ;  end-input: same-reaction ;
CHAR A CHAR Z range: rollback1  cell_reference_Col ;
CHAR z CHAR z range: same-reaction ;

symbols: 0123456789 rollback1  nonnegative_number ;


cell_reference_Col
all: error_occured ;  end-input: same-reaction ;
CHAR A CHAR Z range:  symbol [CHAR] A - TO col  cell_reference_Row ;
CHAR z CHAR z range:  symbol [CHAR] a - TO col  cell_reference_Row ;

cell_reference_Row
all: error_occured ;  end-input: same-reaction ;
symbols: 123456789  col symbol [CHAR] 1 - cell_reference_occured  operation ;

operation
all: error_occured ;  end-input: ;
symbols: +-*/  symbol operation_occured term ;

\ � ����. ��������� ���� ������������ ������ -- �������� �������� �� ����� (����������� �����) 
\ ����� �������� �������, �� ���� ���� ����� �� ���������� �� �� ���:
\ 1) "���������" �������� "�����-���������" (� ������ "�������������" ��������� �� ������� 
\ � chartable.f ��� ���)
\ 2) ���������� ������� ������� ������ ����� ����� ��� ���� ������ � �������� �� �����
nonnegative_number
all: nonnegative_number_occured rollback1  operation ;
end-input: nonnegative_number_occured ;
on-enter: 0 ;
symbols: 0123456789  10 * symbol [CHAR] 0 - + ;

: process-expression ( s -� ) STR@
1 TO ������-������� SWAP ���������-������
term -��������-���������� ;
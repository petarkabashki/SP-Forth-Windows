\ 25-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ��������, ���� ����� �� �������

\ ������� TRUE ���� ��������� ����� ������� � ���������
: ?WORD ( / token --> flag )
        SP@ >R  NextWord SFIND
        IF R> SP! TRUE
         ELSE R> SP! FALSE
        THEN ;

\ ���� ���� ����� ���� ���������� ����� �� ����� ������
: ADMIT ( flag --> ) IF ELSE [COMPILE] \ THEN ; IMMEDIATE

\ ��������� ��������� �� token ���, ���� token �� ������ � ���������
: ?DEFINED ( / token --> ) ?WORD 0 = [COMPILE] ADMIT ; IMMEDIATE

\ ��������� ��������� �� token ���, ���� token ������ � ���������
: N?DEFINED ( / token --> ) ?WORD [COMPILE] ADMIT ; IMMEDIATE

?DEFINED test{ \EOF

test{  FALSE ADMIT -1 THROW
       S" passed" TYPE }test

\EOF -- sample --------------------------------------------------------------

?DEFINED A@  : A@ @ ; : A! ! ; : A, , ; : ADDR CELL ;


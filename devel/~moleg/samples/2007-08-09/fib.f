\ 08-09-2007 ~mOleg
\ �� ������������� ����������� ����������

\ ����������� ������� ���������� n-���� ����� ���������
\ ������������ �������, ������� ���� ��� ������ ������������� ��������
\ ��� ���������� n-���� ����� ���������
: FIBr ( n -- n' )
       DUP 1 >
       IF DUP 1 -
      RECURSE SWAP 2 -
      RECURSE +
       THEN ;

\ ����������� ������� ���������� n-���� ����� ���������
\ ��� �������.
: FIBl ( n --> fib )
       DUP IF 1 - ELSE EXIT THEN
       0 1 ROT
       BEGIN DUP WHILE
             >R OVER + SWAP
             R> 1 -
       REPEAT
       DROP + ;

\ ����� ����� � ���� ������ n ��������
: .R ( n # --> )
     >R DUP >R ABS S>D <# #S R> SIGN #> R> OVER - 0 MAX SPACES TYPE ;

\ ��������� ��� ���������
: testl TIMER@ 2>R FIBl TIMER@ ROT 15 .R SPACE 2R> D- D. SPACE ;
: testr TIMER@ 2>R FIBr TIMER@ ROT 15 .R SPACE 2R> D- D. SPACE ;

\ ���������� ��� ��������� �� �������������
: test 47 0 DO CR I 4 .R
                  I testl
                  I testr
            LOOP ;

\EOF    ����� ������� ������ �������� � ���, ��� ��������� ������ ���������� ��
 ���������, ������, ��� ����� �� �������� ���� �����, ��� ������ ��� ����������
 ��������� ����� ��������� ���������� ������ ����������� ��������...  ����� ���
 ��,  ��������,  �����  ������  ����������  ������  ��������������  �����������
 ����������.


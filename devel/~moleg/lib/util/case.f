\ 02-12-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ����������� ������ CASE
\ � ������ ��������� ����������� ���������� CASE
\ � ������������ ���������� �� ����� �������������

 REQUIRE WHILENOT    devel\~moleg\lib\util\ifnot.f
 REQUIRE COMPILE     devel\~moleg\lib\util\compile.f
 REQUIRE CS>         devel\~moleg\lib\util\csp.f
 REQUIRE controls    devel\~moleg\lib\util\run.f

\ ������ �������� ������ ��������
: CASE ( n --> )
       STATE @ IFNOT init: THEN 5 controls +!
       !CSP COMPILE DUP ; IMMEDIATE

\ � ������� �� OF ������ ������� �� ��� ���������� �����,
\ � ���� �������� ����. ��������� ������������ ����� uOF
\ �� ������� � �����
: uOF ( flag --> )
      COMPILE OVER COMPILE SWAP [COMPILE] IF COMPILE 2DROP ; IMMEDIATE

\ ���� n = ��������, ����������� CASE ��������� ��� ������ �� ENDOF
\ ����� ���������� ������
: OF ( n --> ) COMPILE = [COMPILE] uOF ; IMMEDIATE

\ ��������� �������� ��������, �������� OF ��� uOF
: ENDOF ( --> ) [COMPILE] ELSE ; IMMEDIATE

\ ��������� ����������� CASE
: ENDCASE ( n n --> )
          ?COMP -5 controls +!
          COMPILE NIP COMPILE NIP
          BEGIN ?CSP WHILE [COMPILE] THEN REPEAT CSDrop
          controls @ IFNOT [COMPILE] ;stop THEN ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 3 CASE  0 OF 123456 ENDOF
              1 OF 092874 ENDOF
              2 = uOF 569871 ENDOF
              3 = uOF 576948 ENDOF
              4 OF 689299 ENDOF
              234234
         ENDCASE 576948 <> THROW

     : sample CASE  0 OF 123456 ENDOF
                    0 OF 092874 ENDOF
                    2 = uOF 569871 ENDOF
                    3 = uOF 576948 ENDOF
                    4 OF 689299 ENDOF
                   234234
              ENDCASE ;
     0 sample 123456 <> THROW
     1 sample 234234 <> THROW
     2 sample 569871 <> THROW

     \ �������� �� �����������
     2 CASE 2 OF 48570
                 CASE 48570 = uOF 0 ENDOF
                      -1
                 ENDCASE
              ENDOF
            -1
       ENDCASE THROW

  S" passed" TYPE
}test


\EOF
     � ����������� ��������� CASE  OF ENDOF ENDCASE ���� ����������
�����������, ������� ����������� � ���, ��� OF ������ ���������� ��������
�� ��������� � ����������. � ������������ ����������� ��� �����������
����������, � ����� ������ ���:

  : sample CASE  1 = uOF ." ����������� " ENDOF
                 2   OF ." ������� "     ENDOF
                 3 = uOF ." ����� "       ENDOF
                 5 < uOF ." ������� ��� ������� " ENDOF
                ." ������ "
           ENDCASE ." ������ ����" CR ;

  2 sample
  4 sample

����� ���� ������ �� ����������� ��������� �����, ���� ��� ���������� �������
����� ����� ���� ���, �� ��� � �� ����� ���������� ����. ������� ������ �����
������ � ���:

3 CASE 1 = uOF ." ����������� " ENDOF
       2 = uOF ." ������� "     ENDOF
       3 = uOF ." ����� "       ENDOF
       5 < uOF ." ������� ��� ������� " ENDOF
               ." ������ "
  ENDCASE

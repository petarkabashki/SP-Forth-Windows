\ 2008-06-16 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ �������� �������� � �������������� ������

  REQUIRE KEEPS devel\~moleg\lib\spf_print\pad.f

\ ���������� ������ ��������� � ������ ����, ��� ��� ����� ����� ����
\ ��� ���������� � �������������� ���������
: ?Size ( disp disp --> size ) 2DUP MAX -ROT MIN - ;

\ ������ �������� ��������� � ������ name
\ n - �����, �� �������� ������������� �������� ����
: struct ( n / name --> addr n n )
         NextWord <| [CHAR] / KEEP KEEPS |>
         CREATED HERE 0 , SWAP DUP
         DOES> @ ;

\ ������� ���� ������ # ����
: fld ( disp # --> disp ) NextWord CREATED OVER , + DOES> @ + ;

\ ��������� �������� ���������
: /struct ( addr u disp --> ) ?Size SWAP ! ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ -5 struct sample
            0 fld off_a
            2 fld off_b
            4 fld off_c
            1 fld off_d
       /struct

       /sample 7 <> THROW  \ ������� ��������� ������
       3 off_a -2 <> THROW \ ������� ���������� �������� ����
       5 off_b 0 <> THROW
       0 off_c -3 <> THROW
       2 off_d 3 <> THROW
  S" passed" TYPE
}test

\EOF - ������ �������� ��������� � �������������� ������
 -20 struct sample
 0 fld aaaa
10 fld bbbb
20 fld cccc
 0 fld dddd
/struct

� ������� ������� ����� ������� 5 ����: aaaa bbbb cccc dddd /sample
��������� ����� ����� ��������� ������ ���������

\ 03-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � ����.

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ ������� �����, ������������� � ����� ������� �����.
: ALIAS ( | BaseName AliasName --> ) ' NextWord SHEADER LAST-CFA @ ! ;

\ ALIAS - ��� ������� ��������� �����, ��������� � ����� �����.
\ � �������� ��������� ������� ����������:
\  : ;; ( --> ) [COMPILE] ; ; IMMEDIATE
\  ALIAS ; ;; IMMEDIATE
\ �� ��� �����������, ��� ALIAS ������ ������ ����� � ����� ��������
\ ������� �������.
\ ��������: ����� �������� ����� �� �����������, ��� ���, ���� �� ������
\ ������� ����� ����� ������������ ����������, ����������� ����� IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ : proba 0x123DFE76 ;
      ALIAS proba test        \ ��������� ��� test,
      test proba <> THROW     \ ������������� � ����� ����� proba
S" passed" TYPE
}test




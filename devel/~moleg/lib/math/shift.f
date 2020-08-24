\ 24-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ������ 32������ �����

 REQUIRE STREAM[   devel\~mOleg\lib\arrays\stream.f

\ �������� ������ ���������� ������ � ������ �� �������� �������
: BSWAP ( U --> U )  STREAM[ x0FC8 C3 ] ;

\ ���������� �������� ����� U �� ��������� ����� ��� �����
: ROL ( U # --> U ) STREAM[ x8AC8 8B4500 8D6D04 D3C0 C3 ] ;

\ ���������� �������� ����� U �� ��������� ����� ��� ������
: ROR ( U # --> U ) STREAM[ x8AC8 8B4500 8D6D04 D3C8 C3 ] ;

\ �������������� ����� ����� ����� U �� ��������� # ����� ���
: SAL ( U # --> U ) STREAM[ x8AC8 8B4500 8D6D04 D3F0 C3 ] ;

\ �������������� ����� ������ ����� U �� ��������� # ����� ���
: SAR ( U # --> U ) STREAM[ x8AC8 8B4500 8D6D04 D3F8 C3 ] ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 0x12345678 4 ROL 0x23456781 <> THROW
      0x12345678 4 ROR 0x81234567 <> THROW
      0xF0000000 3 SAR 0xFE000000 <> THROW
      0x70000001 3 SAL 0x80000008 <> THROW
  S" passed" TYPE
}test

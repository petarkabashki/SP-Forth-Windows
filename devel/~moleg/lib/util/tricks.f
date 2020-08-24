\ 14-10-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� �������� �����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ �������� ������� �������� ��� �����
: reslbit ( u --> u1 ) DUP 1 - AND ;

\ ����� ������� �������� ��� �����
: getlbit ( u --> mask ) DUP NEGATE AND ;

\ ����� ������� ���������� ��� �����
: getlz ( u --> mask ) DUP 1 + SWAP NEGATE AND ;

\ �������� ����� ��� ������� ������� ����� �����
: getlzm ( u --> mask ) DUP NEGATE AND 1 - ;

\ �������� ����� �� ������� �������� ��� � ��������� �� ��� ����
: getlbz ( u --> mask ) DUP 1 - XOR ;

\ �������������� ������� �������� ��� ������ �� ��� ������� ����
: sellbz ( u --> u1 ) DUP 1 - OR ;

\ ���������� ������� ������ ������� ���
: setmbit ( u --> u1 ) DUP 1 + OR ;

\ ��������� �� ���
\ : 2* ( u --> <<u ) DUP + ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 0x4234 reslbit 0x4230 <> THROW
      0x2340 getlbit 0x0040 <> THROW
      0x12FF getlz   0x0100 <> THROW
      0x3580 getlzm  0x007F <> THROW
      0x6230 getlbz  0x001F <> THROW
      0x9730 sellbz  0x973F <> THROW
      0xF457 setmbit 0xF45F <> THROW
  S" passed" TYPE
}test

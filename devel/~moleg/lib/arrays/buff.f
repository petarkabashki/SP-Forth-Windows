\ 19-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������������� ������������� ������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE ROUND    devel\~moleg\lib\util\stackadd.f

  \ ��������� ������
  0 CELL -- off-place     \ ������� ������� ���������� ������� � ������
    CELL -- off-limit     \ ���������� ������ ������
    0    -- off-space     \ ������ ������������ ������
  CONSTANT /buffer        \ ������ ������ ������

\ ������� ����� ��������� �����
: Buffer ( # --> buf )
         /buffer + 0x1000 ROUND  DUP ALLOCATE THROW
         0 OVER off-place !  >R /buffer - R@ off-limit ! R> ;

\ ������� ����� ������ ������ � ��� ���������� �����
: Buffer> ( buf --> asc # ) DUP off-space SWAP off-place @ ;

\ �������� ���������� ������ asc # � �����
: >Buffer ( asc # buf --> flag )
          2DUP off-place @ +
          OVER off-limit @ OVER >
          IF OVER off-place change
             + off-space SWAP CMOVE
             TRUE
           ELSE 2DROP 2DROP
             FALSE
          THEN ;

\ �������� ���������� ������.
: Clean ( buf --> ) 0 SWAP off-place ! ;

\ ���������� ������ ���������� �������
: Retire ( buf --> ) FREE THROW ;


?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ �������� ������������

  S" passed" TYPE
}test
\EOF -- �������� ������ -----------------------------------------------------

1 Buffer VALUE zzzz

S" s" BEGIN 2DUP zzzz >Buffer WHILE REPEAT 2DROP
zzzz Buffer> SWAP . .
zzzz Buffer> DUMP

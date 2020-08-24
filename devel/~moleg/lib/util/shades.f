\ 26-03-2005 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ � �������� ����������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

 0 CELL -- off_action
   CELL -- off_value
   CELL -- off_base
 CONSTANT shadow_rec

\ ������� ������� ������� ��� ����� base ����������� ��������� n
: Shadow ( Vect n Base / name --> )
         CREATE HERE shadow_rec ALLOT
                    TUCK off_base !
                    TUCK off_value !
                         off_action !
         DOES> ;

\ ��������� shadow ������: [����������][�����][������]
: pms ( addr --> n Port Vect )
      DUP  off_value @
      OVER off_base @
      ROT  off_action @ ;

\ ��������� ���������� �������� �������� � �������� �������
: Update ( addr --> ) pms EXECUTE ;

\ ���������� ��������� ���� � ������� ��������
: SetH ( mask addr --> ) off_value TUCK @ OR SWAP ! ;

\ �������� ��������� � ����� ���� � ������� ��������
: ResH ( mask addr --> ) off_value SWAP INVERT OVER @ AND SWAP ! ;

\ ������������� ��������� ���� �������� ��������
: FlipH ( mask addr --> ) off_value TUCK @ XOR SWAP ! ;

\ �������� �������� � ���������� - �������� ���������� �������� � ���������
\ ���������
: SET   ( mask addr --> ) TUCK SetH  Update ;
: RES   ( mask addr --> ) TUCK ResH  Update ;
: FLIP  ( mask addr --> ) TUCK FlipH Update ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 1 DEPTH NIP
      : simple ( --> n addr ) ;
      ' simple 0xFFFF 0x345678 Shadow sample
      sample Update 0x345678 <> THROW 0xFFFF <> THROW
      0xFF0000 sample SET 0x345678 <> THROW 0xFFFFFF <> THROW
      0x00AA00 sample RES 0x345678 <> THROW 0xFF55FF <> THROW
      0xFEDCBA sample FLIP 0x345678 <> THROW 0x18945 <> THROW
      DEPTH <> THROW
  S" passed" TYPE
}test

\EOF - �������� � ������ ������������� ---------------------------------------

\ ��� ������ � �������� ������� ������ ��������� ��������, ��� ���� �������,
\ ��������� ������ �� ������, �� ��� ���������� ����������, ������ ����������
\ ����� ����� � ������������.

\ ������ �������������:

: ~content CR ." � ������� " . ."  ��������: " . ;

HEX

   ' ~content FFFF 345678 Shadow test

    test Update
    FF0000 test SET     .(  ������ ���� FFFFFF )
    00AA00 test RES     .(  ������ ���� FF55FF )
    FEDCBA test FLIP    .(   ������ ����  18945 )
CR

\ ����� ������� ��� ���������� �������� �/� ��������� ������� �������,
\ � ������� ����� �������� ������ ��������� ���� ��� ������ ���, ��
\ ���������� ���������.
\ ������ ������ ����� ������������ �� ������ ��� ������ � ���������� 8)
\ ��������, ��� ������ � ���������� �� ������ ���� ����������� ��������
\ ��� �� ��������� ������ ������, �� � �� �� ����� ����� ��� �������
\ �������� ��� ��� ���� �������� 8)


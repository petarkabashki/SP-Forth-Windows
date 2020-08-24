\ 20-06-2005 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����������-�������� ������ �� ������ ��� ���

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE Unit:    devel\~moleg\lib\struct\struct.f

Unit: psLikeMarkers

: CELL+! ( addr --> ) DUP @ CELL + SWAP ! ;
: CELL-! ( addr --> ) DUP @ CELL - SWAP ! ;

        20 CONSTANT #markers
           USER     M0    \ ��� �����
           USER     MP    \ ���������

\ �������������� ���� ��������
F: init ( --> )
        [ #markers CELLS ] LITERAL DUP
        ALLOCATE THROW DUP M0 ! + MP ! ;F

\ ���������� ������� ����� �������� �� ����� �������� ��������
: Marks   ( --> n ) M0 @ MP @ - CELL / #markers + ;

\ ��������� �������� ���������� �������
: m-@     ( --> n ) Marks IF MP @ @ ELSE -1 THROW THEN ;

\ ������� ��������� ������ �� ����� �������� �� ���� ������
: m-pop   ( --> n ) Marks IF m-@ MP CELL+! ELSE -1 THROW THEN ;

\ ��������� �������� �� ����� ������ �� ���� ��������
: m-push  ( n --> )
          Marks #markers -
          IF MP DUP CELL-! @ !
            ELSE -1 THROW
          THEN ;
EndUnit

psLikeMarkers

: ClearToMark ( --> ) m-pop SP! ;
: DropMark    ( --> ) m-pop DROP ;
: AddMark     ( --> ) SP@ m-push ;
: CountToMark ( --> n ) SP@ m-@ SWAP - CELL / ;
: ClearMarks  ( --> ) M0 @ #markers CELLS + MP ! ;

init

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ AddMark 1 2 AddMark 3 4 5 CountToMark 3 <> THROW
      ClearToMark CountToMark 2 <> THROW
      2 <> THROW 1 <> THROW
  S" passed" TYPE
}test

\EOF
     ������ ������� ������������ ���� ������, ��� ������. ����� ���
������������� ������� � ����� ������ �������(ROLL, PICK), � ��� ���
���������� ������� ����������� ������ ����� ���� ��� :(

  AddMark     - ��������� ������� ����� ������ �� ������ ������ �������
  DropMark    - ������� ��������� ������
  ClearToMark - ������� ������� �������� �� ����� ������ �� ��������
                ������������ �� AddMark
  CountToMark - ���������� ������� ����� ������ �� ���������� ������������
                �������.
  ClearMarks  - �������� ���� ��������.

� ����������� ������� �������� �� ����� ����� ������. �������� ���
����� ������� �������, �� ��� �������, ��� � ����� ����� ��� ��������
������� ��������� ����. ��������������, ���� ����� ��������� ��������,
����� ���� ����������, �� �������� ������� ��� �������, ����� ������
� ���� ���������� ����������.

�������� �� �������� ������ ����� ������� ����.

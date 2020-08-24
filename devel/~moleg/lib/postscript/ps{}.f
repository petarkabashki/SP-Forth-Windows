\ 21-07-2004 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ���������� ���������� �������� ��� �����������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE Unit:    devel\~moleg\lib\struct\struct.f

: 1-! ( addr --> ) DUP @ 1 - SWAP ! ;

Unit: eArray

\ ----------------------------------------------------------------------------

      5 CONSTANT nesting

CREATE nStack 0 , nesting CELLS ALLOT

: n-- ( --> )
      nStack DUP @
      IF 1-!
       ELSE TRUE ABORT" nunderflow!"
      THEN ;

: n++ ( --> )
      nStack DUP @ nesting <
      IF 1+!
       ELSE TRUE ABORT" n overflow!"
      THEN ;

: nd  ( --> ) nStack @ ;
: na  ( --> ) nStack DUP @ CELLS + ;
: n>  ( --> ) na @ DP !  n-- ;
: >n  ( --> ) n++ HERE na ! ;

\ ----------------------------------------------------------------------------

    1000 CONSTANT def#

F: :def ( --> addr )
       def# ALLOCATE THROW
       >n DP ! :NONAME ;F

F: ;def ( addr --> addr )
       [COMPILE] ;
       HERE OVER - RESIZE THROW
       n> nd IF ] THEN
       ;F
EndUnit

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ ���� �� ��������������.
  S" passed" TYPE
}test

\EOF

\ ������ �������� ������������ �������
: { % ( --> addr )
    eArray :def ; IMMEDIATE

\ ��������� �������� ������������ �������
: } % ( addr --> obj )
    eArray ;def ; IMMEDIATE

\EOF

{ dup over + swap .. .  n n n } Perform Dispose
{ - �������� ���� ������������ ������
    ����������� �������� ����� �� ���� ������ � ��� �����
    �������������� ����� ���������� � ���� ����

} - ����������� exit
    ��������� ������� � ����� �������������
    ��������� ������ �����

����� ������� ��������� ������������ ����������� ��� �����.

����������� � ���, ��� ����� ������� ����� ���� ����������, �� ����
������ {} ����� ���� ������ {}

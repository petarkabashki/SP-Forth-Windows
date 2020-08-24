\ 02-12-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���� ���������� �����������

 REQUIRE NewStack  devel\~mOleg\lib\util\stack.f

VOCABULARY C-Stack
           ALSO C-Stack DEFINITIONS

        USER-VALUE CStack  \ CSP

    100 CONSTANT #CS       \ ���������� ������� ����� CS

\ ������� CSid
: CSP ( --> addr ) CStack DUP IF ELSE DROP #CS NewStack DUP TO CStack THEN ;

ALSO FORTH DEFINITIONS

\ ����������� ����� �� ������� ����� CS
: >CS ( u --> ) CSP PushTo ;

\ ����� ����� � ������� ����� CS
: CS> ( --> u ) CSP PopFrom ;

\ ��������� ����� � ������� ����� SC
: CS@ ( --> u ) CSP ReadTop ;

\ ������� ������� �������� � ������� CS
: CSDrop ( cs: u --> ) CSP DropTop ;

\ ����� � CS #-��� ��������
: CSPick ( # --> u ) CSP PickFrom ;

\ ���������� ������� CS
: CSDepth ( --> # ) CSP StackDepth ;

\ ��������� ������� ��������� SP � CS
: !CSP ( --> ) SP@ >CS ;

\ ��������� ������������� �� ����
: ?CSP ( -> flag ) SP@ CS@ <> ;

PREVIOUS PREVIOUS DEFINITIONS

?DEFINED test{ \EOF -- �������� ������� ---------------------------------------
        CSDepth 0 <> THROW
        123 >CS CS@ 123 <> THROW
        234 >CS CS@ 234 <> THROW
        345 >CS 2 CSPick 123 <> THROW
        CSDepth 3 = 0= THROW
        CS> 345 = 0= THROW
        CS> 234 = 0= THROW
        CS> 123 = 0= THROW
        !CSP SP@ CS@ <> THROW
        ?CSP THROW
test{


  S" passed" TYPE
}test




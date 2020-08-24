\ 04-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������������� �����

 REQUIRE ADDR     devel\~moleg\lib\util\addr.f
 REQUIRE FRAME    devel\~mOleg\lib\util\stackadd.f

 0 \ ��������� ����������� ����
   CELL -- StackTop    \ ��������� �� ��������� ������� �����
   CELL -- StackLimit  \ ���������� ������ �����
   CELL -- StackBottom \ ��������� �� ������ �����
 CONSTANT /NStack

\ ��������� ������ ����� �������� � u ����� � ������
: StackSize ( # --> u ) CELLS /NStack + ;

\ ��������� ������, ������ ������� ���������� addr ��� ���� �������� depth
: StackPlace ( depth addr --> stack )
             2DUP >R CELLS +
                  R> OVER StackBottom A!
             TUCK StackLimit !
             0 OVER StackTop ! ;

\ �������� ������� ���������� �����
: StackDepth ( stack --> n ) StackTop @ ;

\ �������� ����� ������� ������� �����
: TopAddr ( stack --> addr ) DUP StackDepth CELLS - ;

\ ��������� �� ������� �� ��������� ����� �� ��� �������
: ?Balanced ( stack --> flag ) DUP TopAddr OVER StackBottom A@ ROT 1 + WITHIN ;

\ �������� ������� ������� ���������� �����
: ReadTop ( stack --> n ) TopAddr @ ;

\ �������� ��������� # ������� �� ����� Stack
: PickFrom ( # Stack --> n ) TopAddr SWAP CELLS + @ ;

\ ����������� ��������� ������� ����� �� ��������� ���������� �����
: MoveTop ( stack u --> ) OVER StackTop +! ?Balanced 0= THROW ;

\ ������� ������� �������� � ������� ���������� �����
: DropTop ( stack --> ) -1 MoveTop ;

\ ������� ����� �� ���������� �����
: PopFrom ( stack --> n ) DUP ReadTop SWAP DropTop ;

\ ��������� ����� � ��������� ����
: PushTo ( n stack --> ) DUP 1 MoveTop TopAddr ! ;

\ ����������� ��������� ���������� # ��������� a,b,c,,x �� ���� stack
: CopyTo ( [ a b c .. x ] # stack --> [ a b c .. x ] # )
         2DUP StackTop ! DUP ?Balanced 0= THROW
         OVER >R
          TopAddr >R CELLS >R SP@ 2R> CMOVE
         R> ;

\ ����������� ��������� ���������� ��������� �� ����� ������ �� ��������� ����
: MoveTo ( [ a b c .. x ] # stack --> ) CopyTo nDROP ;

\ ���������� ��� ����������� ����� stack �� ������� ����� ������
: GetFrom ( stack --> a b c .. x # )
          DUP TopAddr SWAP StackDepth 2>R
          R@ FRAME >R SP@ R> SWAP
          2R> CELLS >R SWAP R> CMOVE ;

\ ������� ������������� ���� � ����
: NewStack ( depth --> stack ) DUP StackSize ALLOCATE THROW StackPlace ;

\ ���������� �����, ���������� ������
: KillStack ( stack --> ) StackBottom A@ FREE THROW ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 5 NewStack DUP ?Balanced 0= THROW KillStack
      5 NewStack VALUE stack
      123 stack PushTo stack ?Balanced 0= THROW
      234 stack PushTo stack ?Balanced 0= THROW
      345 stack PushTo stack ?Balanced 0= THROW
      456 stack PushTo stack ?Balanced 0= THROW
      567 stack PushTo stack ?Balanced 0= THROW
      567 stack ' PushTo CATCH 0= THROW 2DROP
      stack -1 MoveTop
      567 stack ReadTop <> THROW
      567 stack PopFrom <> THROW
      456 stack PopFrom <> THROW
      stack StackDepth 3 <> THROW
      stack PopFrom DROP stack PopFrom DROP stack PopFrom DROP
      stack ?Balanced 0= THROW
      stack ' PopFrom CATCH 0= THROW DROP
  S" passed" TYPE
}test

\EOF
     ������ ������ ���������� ������������ ������ �� ������������� ����.
��� ���� ������ ��� ����� ���� ���������� ��������� ��� ������ ����� ������.
��� �� ������ ������, ��� �����, ��� ������ ���������� �������. ��� ����,
����� �������� �� ������ ������ ��� ������������ ���� ����� � ������� ���
����. ������������ ������� ���:

������� ������� ���� ����������� �������:

 200 NewStack

� ���������� ���������� ����� ����� ( --> saddr )

 ������ ����� ��������� ����� ����� ����-������, ��������

 TO stack  \ �������, ��� VALUE ���������� stack ��� ������ ���� �������

�� � ������ ������ �������� �� ������ � ������� ���� PushTo PopFrom ReadTop..

���� �� ������� ������ ��� "����������" ����� ����� ����� �������
����������� ����� ����, �� ����� � ���, ��� ���� ���� ����� ��������������
������� �������.

�������, ��� ������ ��� ������ ����� ����� ���������, ������ �������
����� (������ � ���������). ����� ���-��� �������� �� ������������� ������
���� �� ����������, �� ���� ����� ������� �������������.

��, ���� ������ ����! �� ���� ��� ������� ����.

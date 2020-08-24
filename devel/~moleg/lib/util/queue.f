\ 21-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������������� �������

 REQUIRE ADDR     devel\~moleg\lib\util\addr.f
 REQUIRE MUTEX:   devel\~moleg\lib\mtask\mutex.f

  0 \ ��������� ������������ ������
    ADDR -- QueueBegin  \ ����� ������ �������, ���������� ��� �������
    ADDR -- QueueFirst  \ ����� ������������ �������� �� �������
    ADDR -- QueueLast   \ ����� ��� ���������� �������� � �������
    CELL -- QueueAccess \ ������������� ������� � �������
  CONSTANT /queue

\ ���������, ������� ������ ������� � ������
: QueueSize ( # --> u ) 1 + CELLS /queue + ;

\ ���������������� �������
: ResetQueue ( queue --> )
             DUP QueueBegin A@ TUCK OVER QueueFirst A! QueueLast A! ;

\ ����������� ������� ������ � # ����� ������� � ������ addr
\ ����� ������ ���� �������� ��������������
: PlaceQueue ( # addr --> queue )
             >R 1 + CELLS R@ +
             R> OVER A!
             DUP ResetQueue ;

\ ��������� ����� �� ������� (���� �����������)
: CheckQueue ( queue --> flag ) DUP QueueFirst A@ SWAP QueueLast A@ = ;

\ ��������� ��������� ������
: Shove ( queue --> )
        DUP QueueLast A@ CELL + 2DUP -
        IF ELSE DROP DUP QueueBegin A@ THEN SWAP QueueLast A! ;

\ ��������� ��������� ������
: Squeeze ( queue --> )
          DUP QueueFirst A@ CELL + 2DUP -
          IF ELSE DROP DUP QueueBegin A@ THEN SWAP QueueFirst A! ;

\ �������� �������� � ��������� �������
\ ����������, ���� ������� ���������
\ ��� ������������� ���������� ���������� ������� ��������
: PutTo ( n queue --> )
        DUP QueueAccess WaitUnlock
        TUCK QueueLast A@ !
        DUP Shove
        DUP CheckQueue
            IF DUP ResetQueue QueueAccess UnlockMutex -1 THROW THEN
        QueueAccess UnlockMutex ;

\ ������� �������� �� ��������� �������
\ ����������, ���� ������� �����.
\ ��� ������������� ���������� ���������� ������� ��������
: GetFrom ( queue --> n )
          DUP QueueAccess WaitUnlock
          DUP CheckQueue
              IF DUP ResetQueue QueueAccess UnlockMutex -1 THROW THEN
          DUP QueueFirst A@ @ SWAP DUP Squeeze QueueAccess UnlockMutex ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 3 HERE OVER QueueSize ALLOT
             PlaceQueue VALUE sample

       sample ' GetFrom CATCH 0= THROW DROP   \ ���������������
       1 sample PutTo  2 sample PutTo  3 sample PutTo
       4 sample ' PutTo CATCH 0= THROW 2DROP  \ ������������

       5 sample PutTo 6 sample PutTo 7 sample PutTo
       sample GetFrom 5 <> THROW
       sample GetFrom 6 <> THROW
       sample GetFrom 7 <> THROW

  S" passed" TYPE
}test

\EOF
     � �������� ��� ����������� ��� ��������������� ������� ����� ��������
�������, �� ��� ����� ��� ������?

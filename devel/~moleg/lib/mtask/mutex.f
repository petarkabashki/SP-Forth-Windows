\ 21-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 REQUIRE B,        devel\~mOleg\lib\util\bytes.f

\ ������� �������������� � ���, ��� ������ ��������
\ ���� ��������, ������������� ���� ���������, ���������� TRUE
\ ����� FALSE
: ?LockMutex ( addr --> flag )
             [ 0x8B B, 0xD8 B,       \ MOV addr , tos
               0xC7 B, 0xC0 B, -1 ,  \ MOV tos , # -1
               0x87 B, 0x03 B,       \ XCHG [addr] , tos
               0xF7 B, 0xD0 B,       \ NOT tos
             ] ;

\ ����������� ���������� ������
: UnlockMutex ( addr --> )
              [ 0x33 B, 0xD2 B,         \ XOR temp , temp
                0x87 B, 0x10 B,         \ XCHG [tos], temp
                0x8B B, 0x45 B, 0x00 B,
                0x8D B, 0x6D B, 0x04 B, \ dpop tos
              ] ;

\ ���� ������������ �������, ����� ���� ��� ����� �� �����
: WaitUnlock ( addr --> ) BEGIN DUP ?LockMutex UNTIL DROP ;

\ ������� ���������� �������
\ ��� ���������� ����� � ������ name � ���������� 'cfa ����� ����
\ ���������, ��� ������, ��������� � ��������� �������� ����������.
: MUTEX: ( / name --> )
         CREATE 0 ,
         ( 'cfa --> )
         DOES> DUP >R WaitUnlock
               ['] EXECUTE CATCH   \ ��� ����, ����� unlock ��� ��������
                   R> UnlockMutex
               THROW ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ VARIABLE res
         res ?LockMutex 0= THROW
         res ?LockMutex THROW
         res UnlockMutex
         res ?LockMutex 0= THROW
         res UnlockMutex
  S" passed" TYPE
}test

\EOF -- ���� ������ ---------------------------------------------------------

  MUTEX: sample

: test 100 0 DO I . 100 PAUSE LOOP ;

: testa ['] test sample ;

: testb CR ."  passed" CR ;


' testa TASK: proba

: zzzz  0 proba START        \ ����� proba ����� �� ����� ������� sample
        200 PAUSE ." zzzzzz "

        ['] testb sample     \ �� ��� ���, ���� sample �������, testb
                             \ ����� ������ � ��������
        ;

zzzz

\EOF

��� ������ � ������������� ������ ������ ���������� ���� ���������,
��� � ������� ������� ����������� ������.



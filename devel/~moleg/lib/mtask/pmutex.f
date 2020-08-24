\ 21-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������

 REQUIRE ?DEFINED   devel\~moleg\lib\util\ifdef.f
 REQUIRE B,         devel\~mOleg\lib\util\bytes.f
 REQUIRE ADDR       devel\~mOleg\lib\util\addr.f
 REQUIRE IFNOT      devel\~moleg\lib\util\ifnot.f
 REQUIRE AllotErase devel\~moleg\lib\util\useful.f
 REQUIRE STREAM[    devel\~moleg\lib\arrays\stream.f

\ ������� �������������� � ���, ��� ������ ��������
\ ���� ��������, ������������� ���� ���������, ���������� TRUE
\ ����� FALSE
: ?LockMutex ( addr --> flag ) STREAM[ x8BD8C7C0FFFFFFFF8703F7D0 ] ;

\ ����������� ���������� ������
: UnlockMutex ( addr --> ) STREAM[ x33D287108B45008D6D04 ] ;

\ ���� ������������ �������, ����� ���� ��� ����� �� �����
: WaitUnlock ( addr --> )
             BEGIN DUP ?LockMutex WHILENOT
                   1 PAUSE    \ ����� �� ����������� ����� ������� �� �����
             REPEAT DROP ;

 0
   CELL -- off_mutex \ ������ �������
   ADDR -- off_ident \ ������ ����� ���������� ���������������� ������
 CONSTANT /pmutex

\ ���������� ������� ������ � ������, ���� �� ������� ������� �������
\ ����� ���� ������������ ��������
: free-mutex ( 'pmutex --> )
             >R BEGIN R@ ?LockMutex WHILENOT
                      R@ off_ident @ TlsIndex@ = WHILENOT
                  1 PAUSE  ." ."
              REPEAT
             THEN R> UnlockMutex ;

\ ��������� ������� � ��������� taskid ������������ ������
: lock-mutex ( 'pmutex --> ) DUP WaitUnlock  TlsIndex@ SWAP off_ident A! ;

\ �� ���� �� ��, ��� � MUTEX: ������ ��������� ��� � id ������
\ (�� ���� ���������� ����� ��� ������) ������������ ������ � free-mutex,
\ ������� ����������� ����� ������ �������� ���������� � ����������� ������
: PMUTEX: ( / name --> )
          CREATE /pmutex AllotErase
          ( 'cfa --> )
          DOES> DUP >R lock-mutex
                ['] EXECUTE CATCH
                    R> free-mutex
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

\EOF

0 VALUE t1
0 VALUE t2

: testa ."  aaaaaa> " t1 1+ TO t1 500 PAUSE ." <aaaaa "  ;
: testb ."  bbbbbb> " t2 1+ TO t2 300 PAUSE ." <bbbbb "  ;

PMUTEX: proba

: ttt BEGIN ['] testa proba t1 . t2 . CR 0  PAUSE AGAIN ;
: eee BEGIN ['] testb proba t1 . t2 . CR 0  PAUSE AGAIN ;

' ttt TASK: testt
testt START
eee



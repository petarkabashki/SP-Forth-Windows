
\ TRY ( i*x i -- )
\  ...
\ TRAP ( -- i*x u ) \ u - 0 ���� ��� ��������� ��� ����� exception

\ : NDROP 1+ CELLS SP@ + SP! ;

: TRY ( x*i i -- )
\ ��������� ����� ������� CATCH u ���������� ����� ������ ��
\ ����� ���������.
   POSTPONE NRCOPY
   POSTPONE DROP
   0 BRANCH, >MARK HERE SWAP
; IMMEDIATE

: TRAP ( -- x*i u )
\ ������� ����������, ������������ i ����������, ����������� TRY
\ ���������� u - ����� ����������, 0 ���� �� ����.
   RET,
   1 >RESOLVE
\   S" LITERAL CATCH DUP IF R@ SWAP >R NDROP R> NR> ROLL ELSE NR> NDROP THEN" EVALUATE
   S" LITERAL CATCH TRAP-CODE" EVALUATE
; IMMEDIATE

(
: test
  1 2 3 3
  TRY
    DROP DROP DROP
    -2003 THROW
  TRAP
; test )
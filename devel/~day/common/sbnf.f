\ simple bnf-sorta parser

\ ��������� ����  16  0 <DIGITS>  ������ ���
\ ������� �������� ������������ ������ �� ������� ��������, �������
\ �� ����� ��������������� ������ (� ������ ������), �� �� ������ 0
\ � ������ ������ � �� ������ 16 (���� ������ 16, ������ ������ ������ ��
\ ������)

\ �������� ������� � ������ ������ �� ����� �������������� ��������, �� ��
\ ������ ��� MIN(u, max)

\ ���� ������� ���� ������ ��� min �� ������ 0, ����� -1.

: CHECK-SET ( addr u max min addr2 u2 -- addr2 u2 bool )
    >R >R >R OVER MIN >R SWAP R>
    0 >R \ D: addr u1 R: u2 addr2 min 0
    BEGIN
      DUP R@ >
    WHILE
      OVER R@ + C@
      2 CELLS RP+@
      3 CELLS RP+@       
      ROT 
      >R RP@ 1 SEARCH RDROP NIP NIP
      0= IF     \ ������ ����������� ������
           DROP SWAP
           R@ - SWAP R@ + SWAP 
           2R> 1+ < RDROP RDROP EXIT
         THEN
      R> 1+ >R
    REPEAT
    + SWAP R@ -
    2R> 1+ < RDROP RDROP
;

: <SIGN> ( addr u max min -- addr2 u2 bool )
    S" -+" CHECK-SET
;

: <EXP> ( addr u max min -- addr2 u2 bool )
    S" EeDd" CHECK-SET
;

: <DOT> ( addr u max min -- addr2 u2 bool )
    S" ." CHECK-SET
;

: <DIGITS> ( addr u max min -- addr2 u2 bool )
    S" 0123456789" CHECK-SET
;

\ example
\ �������� ������-����� �� ��������� :)

: ?FLOAT ( addr u -- bool )
    1   0 <SIGN>    >R
    16  0 <DIGITS>  >R
    1   0 <DOT>     >R
    16  0 <DIGITS>  >R
    1   1 <EXP>     >R
    1   0 <SIGN>    >R
    4   0 <DIGITS>  >R
    NIP 0= \ ����� ����� ����� ������ ���� ����� ������ - ���� ��� ������ error
    2R> 2R> 2R> R> AND
    AND AND AND AND AND
    AND
;


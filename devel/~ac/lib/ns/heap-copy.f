\ HEAP-COPY ��� SPF/Linux

: HEAP-COPY ( addr u -- addr1 )
\ ����������� ������ � ��� � ������� � ����� � ����
  DUP 0< IF 8 THROW THEN
  DUP 1+ ALLOCATE THROW DUP >R
  SWAP DUP >R MOVE
  0 R> R@ + C! R>
;

\ �������� ������������ ������ � �������
\ �. �������, 2001

: BINDATA ( a # "name" -- )
  CREATE
  R/O OPEN-FILE ABORT" ���� �� ������" >R
  HERE 100000 R@ READ-FILE THROW ALLOT
  R> CLOSE-FILE THROW
;
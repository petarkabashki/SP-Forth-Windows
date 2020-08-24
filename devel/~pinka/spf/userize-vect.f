\ 12.2007
( ����� USERIZE-VECT ����� ����� ��� ��� ������������� ����������� �������,
������� USER-������ � ��� �� ������, ����������� ��� � ���������� ������,
� ������ �������� ����������� ����������� � ��������� ������
� �� �� ������ �������� ���������� ��� ��-�������� ������������� 
���������� �������.
  �����, ������� ����� �������� ������� ���� ������ �������� ��� ������
� �� ������, ��� �� ����� ����� ����� ������.
  ������
    USERIZE-VECT TYPE
)

REQUIRE STR@ ~ac/lib/str5.f
REQUIRE {  lib/locals.f

: USERIZED-VECT ( name-a name-u -- )
  { | o }
  2DUP SFIND 0= IF -321 THROW THEN  DUP BEHAVIOR   DUP TO o
  2SWAP ( xt-v xt-o  a u ) 2DUP 2DUP 2DUP
  " USER-VECT {s}  TO {s}
  ..: AT-THREAD-STARTING {#o} TO {s} ;.. 
  ' {s} SWAP BEHAVIOR! " 
  \ STYPE CR EXIT
  DUP >R STR@ EVALUATE R> STRFREE
;
\ ��������, ��� � "..:" ���� ������������.

: USERIZE-VECT ( "name" -- )
  PARSE-NAME USERIZED-VECT
;


\EOF example

USERIZE-VECT TYPE
: TYPE2 S" T2: " TYPE1 TYPE1 ; \ ��� ������ �������� TYPE, ����� 
                                \ �� ������� ����������� ��������� ��������
:NONAME 
  S" test 1 passed " TYPE CR
  ['] TYPE2 TO TYPE
  S" test 2 passed " TYPE CR
; TASK 0 SWAP START DROP
50 PAUSE S" test 3 passed" TYPE CR

\ � �������� ������ ������� ����� �������, 
\ � ����� ����������� ������ "T2:"
\ � ������������ ������ ����� �������� ����������.

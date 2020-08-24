( ��������� WIN32_FIND_DATA ��� ��������� ����� ��� ��������.

  Filetime.f ��� ��������� ������� ����������� ����� ������� �����
  �����, ��� "������" � ��������� ����������� ������ � ����������.
  ������ ���������� ��������� ���������� - ��������� ������� filetime
  � ��� ���������, ����� ��� � ��� ������, ��� �� ��������. � �������
  ����������� ���/������ �������� �� filetime.f, c�. ������� ����.

)

REQUIRE ftLastWriteTime ~ac/lib/win/file/findfile-r.f 

: FOR-FILE1-PROPS ( addr u xt -- )

\ addr u - ��� ����� ��� ��������
\ xt ( addr u data -- ) - ��������� ���������� ��� 
\                         ��������� ������ �����/��������
\ �������������� ������ ���� ����, ���� �������� �� addr u.

  NIP SWAP
  /WIN32_FIND_DATA >CELLS 1+ RALLOT >R
  R@ SWAP FindFirstFileA ( xt id )
  DUP -1 = IF 2DROP ELSE FindClose DROP ( xt )
  R@ cFileName ASCIIZ> ( xt a u ) ROT R@ SWAP EXECUTE
  THEN RDROP
  /WIN32_FIND_DATA >CELLS 1+ RFREE
; 
: (FILENAME-FILETIME) ( 0 0 addr u data -- filetime )
  ftCreationTime 2@ SWAP 2>R
  2DROP 2DROP ( ������ addr u � 0 0 )
  2R>
;
: FILENAME-FILETIME ( addr u -- filetime ) \ UTC
  0 0 2SWAP ['] (FILENAME-FILETIME) FOR-FILE1-PROPS
;
: (FILENAME-FILETIME-W) ( 0 0 addr u data -- filetime )
  ftLastWriteTime 2@ SWAP 2>R
  2DROP 2DROP ( ������ addr u � 0 0 )
  2R>
;
: FILENAME-FILETIME-W ( addr u -- filetime ) \ UTC
  0 0 2SWAP ['] (FILENAME-FILETIME-W) FOR-FILE1-PROPS
;
: GET-FILETIME-WRITE-S FILENAME-FILETIME-W ;

\EOF
filetime.f
S" CVS" GET-FILETIME-WRITE-S UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
S" ." GET-FILETIME-WRITE-S UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
S" fileprop.f" GET-FILETIME-WRITE-S UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
S" fileprop.f" R/O OPEN-FILE-SHARED THROW GET-FILETIME-WRITE UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR

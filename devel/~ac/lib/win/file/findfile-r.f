( 26.01.03 �.�. )

\ ����������� ����� ��������� � ���������� 
\ ��������� �������� ��� ������� � ����������.
\ �������� ".." � "." � xt �� ����������.
\ �������� "." ����� ������������, ���� ������� TRUE FIND-FILES.. !
\ ����� ��������� xt ������ ��� ������ �����, ���� ������ �����
\ �������� ������ �� ���� "���_�����*".

\ xt ( addr u data flag -- ) - ��������� ���������� ��� ������� �����
\ addr u - ���� � ��� ����� ��� �������� (������ ��� open-file, etc)
\ flag=true, ���� �������, false ���� ����
\ data - ����� ��������� � ������� � ����� ��� ��������
\ ���� ��������� ��. � findile.f
\ ����� ������ xt ������ addr � ��������� data �������������,
\ �������, ���� xt ��������� ��������� ��� ������, ���� ����������.

REQUIRE FIND-FILES       ~ac/lib/win/file/findfile.f
REQUIRE {                ~ac/lib/locals.f
REQUIRE STR@             ~ac/lib/str5.f

USER FIND-FILES-RL    \ ������� ����������� 0-...
USER FIND-FILES-DEPTH \ ����������� �����������, 0 - ��� �����������,
                      \ 1 - ������ � ��������� ��������, ...
USER FIND-FILES..
USER FIND-FILES-U

USER FIND-FILES-USE-RET \ true, ���� ���� �������� xt ����� ��� ������
                        \ �� �������� (c data=0)

: IsNot..
  2DUP S" .." COMPARE 0<> ROT ROT S" ." COMPARE 0<> AND
;
: FIND-FILES-R ( addr u xt -- )
\ addr u - ��� �������� ��� ������
\ xt ( addr u data flag -- ) - ��������� ���������� ��� ������� �����

  { addr u xt \ addr2 data id f dir }

  FIND-FILES-RL @ 0= IF u FIND-FILES-U ! THEN
  addr u S" *" SEARCH NIP NIP
  addr u ROT IF " {s}" ELSE " {s}/*.*" THEN -> addr2
  /WIN32_FIND_DATA ALLOCATE THROW -> data
  data /WIN32_FIND_DATA ERASE
  data addr2 STR@ DROP FindFirstFileA -> id
  id -1 = IF data FREE DROP addr2 STRFREE EXIT THEN
  BEGIN
    data cFileName ASCIIZ> 2DUP IsNot.. FIND-FILES.. @ OR
    IF
      data dwFileAttributes @ FILE_ATTRIBUTE_DIRECTORY AND 0<> -> dir
      addr u " {s}/{s}" DUP -> f STR@ data dir xt EXECUTE
      dir
      IF FIND-FILES-RL 1+!
         FIND-FILES-RL @ FIND-FILES-DEPTH @ < FIND-FILES-DEPTH @ 0= OR
         data cFileName ASCIIZ> IsNot.. AND
         IF f STR@ xt RECURSE THEN
         FIND-FILES-RL @ 1- FIND-FILES-RL !
         FIND-FILES-USE-RET @
         IF f STR@ 0 dir xt EXECUTE THEN
      THEN
      f STRFREE
    ELSE 2DROP THEN
    data id FindNextFileA 0=
  UNTIL
  addr2 STRFREE
  id FindClose DROP
  data FREE DROP
;
: FIND-DIRS-R ( addr u xt -- )
\ addr u - ��� �������� ��� ������
\ xt ( addr u data -- ) - ��������� ���������� ��� ������� ��������

  { addr u xt \ addr2 data id f }

  addr u " {s}/*.*" -> addr2
  /WIN32_FIND_DATA ALLOCATE THROW -> data
  data /WIN32_FIND_DATA ERASE
  data addr2 STR@ DROP FindFirstFileA -> id
  id -1 = IF data FREE DROP addr2 STRFREE EXIT THEN
  BEGIN
    data cFileName ASCIIZ>
    2DUP 2DUP S" .." COMPARE 0<> ROT ROT S" ." COMPARE 0<> AND
    IF
      data dwFileAttributes @ FILE_ATTRIBUTE_DIRECTORY AND 0<>
      IF 
         addr u " {s}/{s}" DUP -> f STR@ data xt EXECUTE
         FIND-FILES-RL 1+!
         FIND-FILES-RL @ FIND-FILES-DEPTH @ < FIND-FILES-DEPTH @ 0= OR
         IF f STR@ xt RECURSE THEN
         FIND-FILES-RL @ 1- FIND-FILES-RL !
         f STRFREE
      ELSE 2DROP THEN
    ELSE 2DROP THEN
    data id FindNextFileA 0=
  UNTIL
  addr2 STRFREE
  id FindClose DROP
  data FREE DROP
;

\ ������ ������ ���� ���������
\ : TT NIP IF TYPE CR ELSE 2DROP THEN ;
\ ������ ���� ��������� �� ������� �� �������
\ : TT IF FIND-FILES-RL @ CELLS SPACES cFileName ASCIIZ> TYPE CR
\      ELSE DROP THEN 2DROP ;
\ 2 FIND-FILES-DEPTH !
\ : T S" c:\temp" ['] TT FIND-FILES-R ; T

\ ������ ������ ���� ���������
\ : TT DROP TYPE CR ;
\ : T S" c:" ['] TT FIND-DIRS-R ; T


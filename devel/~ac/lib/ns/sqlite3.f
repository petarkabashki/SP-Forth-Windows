( ~ac 23.08.2005
  $Id: sqlite3.f,v 1.5 2005/09/14 13:49:56 spf Exp $

  ����������� ������� SQLite3 ��� ������ [�� ����� �����] �
  �������� ������������ ����-�������. � ���������� �������
  �������� ��� ��������� ������������ ����� ��������������� 
  �����, ��� ������������� ������������� ����� SQL � ����������� API.

  �������������:
  ALSO SQLITE3_DB NEW: world.db3
  - ������� �������, ����������� � ���������� ����� ��, �������
  �� �� ���, � ��������� ���� ������� � �������� ������.
  ����� ���������� ����� ����� ������������ ��������� ����� -
  ��� �� ������������� ���������� � ����� ��� ������ � VIEWS �����
  ������������� ���, ��� ���� �� ��� ��� "����������" ����-�������.
  ���������� ��������� ������� �������� ������� ������� ���������
  ������ �� ��������� ������� ��������� ������� [��� VIEW],
  ��� ���� �� ��� ���� ���� ���������� ����� VOCABULARY, � ���������� 
  ����� ����� �������, ������� � ����. ����� � ������� �������
  �������� � ������ ������� ������� ��������� �� ROW-������� -
  ������� ����� ��� ���� ��������� ������ ��������� ���� �������,
  �� �������� ����� ������ ������������� ���������� �����.
  ����� � ������� ROW-������� ����� ������������, �������������� 
  ������� ���������� SELECT-��������.
  todo: ������� � ���� ������� ������ ������� � ������������.

  ����� ������� �������� ������:
  world.db3 Country CODE RU
  ������� � �������� ���������� ���� ��� �� ���������, ��� �
  SQL-������ "SELECT * FROM Country WHERE CODE='RU'"

  ����� "@" � "." � ���� ���������� �������������� ��� ����������
  � ������ ��������� �������� "����������� �����" ��������������.

  ���������� ��� � ���������, ������� ������� � ����� �� ���������.
)

REQUIRE db3_open     ~ac/lib/lin/sql/sqlite3.f 
REQUIRE ForEachDirWR ~ac/lib/ns/iterators.f

ALSO sqlite3.dll

: DB_RESET ( stmt -- )
\ db3_fin ���������� �� db3_cdr, ������� ���� �������� �����
\ ������ � ������, ���� ��������� �� ��������������
  db3_fin
;
: DB_CAR ( addr u sqh -- ppStmt )
  db3_car
;
: DB_CDR ( ppStmt -- ppStmt | 0 )
  db3_cdr
;
: DB_SELECT { addr u sqh wid -- ppStmt }
  addr u wid OBJ-NAME@  wid PAR@ OBJ-NAME@ 
  " SELECT * FROM {s} WHERE {s} LIKE '{s}'"
  STR@ 2DUP TYPE SPACE sqh DB_CAR
;
PREVIOUS

<<: FORTH SQLITE3_FIELD

: CAR DROP 0 ;

>> CONSTANT SQLITE3_FIELD-WL

: TABLE>FIELD ( addr u -- )
  TEMP-WORDLIST >R
  R@ OBJ-NAME!
  SQLITE3_FIELD-WL R@ CLASS!
  CONTEXT @ R@ PAR!
  R> CONTEXT !
;

<<: FORTH SQLITE3_ROW

: ?VOC DROP FALSE ;

: CAR { oid \ ppStmt -- item }
." SQLITE3_ROW CAR;"
  oid PAR@ PAR@ OBJ-DATA@ DUP \ sqh
  IF S" %" ROT oid DB_SELECT DUP 
     IF oid OBJ-DATA! oid
        ." OK!"
     THEN
  THEN
;
: NAME ( item -- addr u )
  ." SQLITE3_ROW NAME;"
  1 SWAP OBJ-DATA@ db3_col
;
: CDR ( item -- item )
  ." SQLITE3_ROW CDR;"
  DUP >R OBJ-DATA@ db3_cdr DUP R@ OBJ-DATA!
  IF R> ELSE RDROP 0 THEN
;
: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� ������ � oid='c-addr u' � ������� oid_par

\ ������� ���� � ������� ������, ����� �� ������ �������� ������ � ��...
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN
  
  oid PAR@ PAR@ OBJ-DATA@ DUP \ sqh
  IF c-addr u ROT oid DB_SELECT DUP 
     IF \ ������ ���� � �������� ������
        ( ������ � oid ��� � CONTEXT ?! - ������ �������� �������� ...)
        \ oid
        CONTEXT @
        OBJ-DATA! ['] NOOP 1
     THEN
  THEN
;
: . ( -- )
  0 CONTEXT @ ?DUP
  IF OBJ-DATA@ ?DUP 
     IF db3_dump
\       CONTEXT @ OBJ-DATA@ DB_RESET ( db3_fin ���������� �� db3_cdr )
       0 CONTEXT @ OBJ-DATA!
     THEN
  ELSE DROP THEN
;
: PREVIOUS PREVIOUS ;
: \ POSTPONE \ ;
: .. .. ;
>> CONSTANT SQLITE3_ROW-WL

: TABLE>ROW ( addr u -- )
  TEMP-WORDLIST >R
  R@ OBJ-NAME!
  SQLITE3_ROW-WL R@ CLASS!
  CONTEXT @ R@ PAR!
  R> CONTEXT !
;

<<: FORTH SQLITE3_TABLE

: ?VOC DROP FALSE ;

: SHEADER ( addr u -- )
  TYPE ." to implement - INSERT :)"
;
: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� � ������� ������� ���� � ������ c-addr u � �� oid � ������� ��� 
\ ������� (������� �������� � ���������� ������).

\ ������� ���� � ������� ������
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN

  oid OBJ-NAME@ NIP DUP
  IF \ ����� �������� �������� ������� �� �������� ������
     \ �.�. ������ �������� ��� ��������� ����
     DROP c-addr u TABLE>ROW ['] NOOP 1
  THEN
;
: PREVIOUS PREVIOUS ;
: \ POSTPONE \ ;
: .. .. ;

>> CONSTANT SQLITE3_TABLE-WL

: DB>TABLE ( addr u -- )
  TEMP-WORDLIST >R
  R@ OBJ-NAME!
  SQLITE3_TABLE-WL R@ CLASS!
  CONTEXT @ R@ PAR!
  R> CONTEXT !
;

<<: FORTH SQLITE3_DB

: ?VOC DROP TRUE ;

: CAR  { oid \ ppStmt -- item }
." SQLITE3_DB CAR;"
  oid OBJ-DATA@ \ sqh; ���� �� ���������� - ���������
  0= IF oid OBJ-NAME@ " {s}" STR@ db3_open oid OBJ-DATA! THEN

." open OK;"
  oid OBJ-DATA@ DUP
  IF \ ������� �������, ������ ����� �������� �������� �� �������-�������
     \ �.�. ������ ������ �������� � ���
     S" select name from SQLite_Master where type LIKE '%'"
     ROT DB_CAR ( ppstmt )
\     DROP
\     ALSO oid CONTEXT ! S" SQLite_Master" DB>TABLE
\     S" type" TABLE>ROW CONTEXT @ PREVIOUS SQLITE3_ROW::CAR

  THEN
;
: NAME ( item -- addr u )
  0 SWAP db3_col
;
: CDR ( item -- item )
  db3_cdr
;
: >WID ( item -- wid )
  ALSO S" name" TABLE>FIELD CONTEXT @ OBJ-DATA!
  CONTEXT @ PREVIOUS
;

: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� ������� � ������ c-addr u � �� oid � ������� ��� ������� �������.

\ ������� ���� � ������� ������
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN

  oid OBJ-DATA@ \ sqh; ���� �� ���������� - ���������
  0= IF oid OBJ-NAME@ " {s}" STR@ db3_open oid OBJ-DATA! THEN

  oid OBJ-DATA@ DUP
  IF \ ������� �������, ������ ����� �������� �������� �� �������-�������
     \ �.�. ������ ������ �������� � ���
     DROP c-addr u DB>TABLE ['] NOOP 1
  THEN
;
: PREVIOUS PREVIOUS ;
: \ POSTPONE \ ;
: .. .. ;
: WORDS ['] wid. CONTEXT @ ForEachDirWR ;
: \EOF \EOF ;

:>>

\EOF

ALSO SQLITE3_DB NEW: world.db3
WORDS
Country CODE RUS .
UKR .
BLR .
USA .
.. .. 
\ Country CODE ROS \ ���� -2003
CountryLanguage CountryCode RUS .
PREVIOUS ORDER

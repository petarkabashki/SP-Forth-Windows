\ �������� NS � ������� �� ������ � ���� ��������, �������� ������ � Windows

REQUIRE FIND-FILES-R      ~ac/lib/win/file/findfile-r.f 
REQUIRE ForEachDirWRstr   ~ac/lib/ns/iter.f
REQUIRE FileExists        ~ac/lib/win/file/file-exists.f

<<: FORTH FIL
>> CONSTANT FIL-WL

: DIR>DIR ( addr u -- )
  VOC-CLONE CONTEXT @ >R PREVIOUS
  R@ OBJ-NAME!
  CONTEXT @ R@ PAR!
  R> CONTEXT !
;
: DIR>FIL ( addr u -- )
  TEMP-WORDLIST >R
  R@ OBJ-NAME!
  FIL-WL R@ CLASS!
  CONTEXT @ R@ PAR!
  R> CONTEXT !
;

<<: FORTH DIR

: ?VOC ( item -- flag )
  OBJ-NAME@ DROP DUP
  cFileName ASCIIZ> 2DUP 
  S" .." COMPARE 0= ROT ROT S" ." COMPARE 0= OR IF DROP FALSE EXIT THEN
  dwFileAttributes @ FILE_ATTRIBUTE_DIRECTORY AND 0<>
;
: FULLPATH { s oid -- s }
\ �� ���� ����� �������� ������� ���������� ������ ����
  oid OBJ-NAME@
  OVER @ ABS 0x4000 < \ ��. ����
  IF DROP cFileName ASCIIZ>
     s oid PAR@ ?DUP IF RECURSE THEN ( addr u s )
     " \" OVER S+ STR+
  ELSE s STR+ THEN
  s
;
: CAR { oid \ data id item s pa -- item }
  TEMP-WORDLIST -> item
  ( HERE) PAD /WIN32_FIND_DATA item OBJ-NAME! \ ��������, "���" ��������!
  [ GET-CURRENT ] LITERAL item CLASS!
  oid item PAR!
  item OBJ-NAME@ DROP -> data
  data /WIN32_FIND_DATA ERASE
  data oid OBJ-NAME@  \ ���� ��� ��������, ���� WIN32_FIND_DATA
  OVER @ ABS 0x4000 < \ ���� ��� dwFileAttributes, � �� ������ ����� (���)...
  IF 2DROP "" DUP -> pa oid FULLPATH STR@ THEN
  " {s}\*.*" DUP -> s 
  STR@ \ 2DUP ." [" TYPE ." ]" CR
  DROP FindFirstFileA -> id
  s STRFREE pa ?DUP IF STRFREE THEN
  id -1 = IF ( data FREE DROP) item FREE-WORDLIST 0 EXIT THEN
  id item OBJ-DATA!
  item
;
: NAME ( oid -- addr u )
  OBJ-NAME@ DROP ( data ) cFileName ASCIIZ> 
;
: CDR { item1 -- item2 }
  item1 OBJ-NAME@ DROP item1 OBJ-DATA@ FindNextFileA
  IF item1
  ELSE item1 OBJ-DATA@ FindClose DROP item1 FREE-WORDLIST 0 THEN
;
: SHEADER ( addr u -- )
\ ������� ���� [��� ����� �������?] � ������ addr u � ������� DIR-���� "����������"
  GET-CURRENT OBJ-NAME@ " {s}\{s}" DUP >R
  STR@ 2DUP R/W CREATE-FILE THROW >R
  TEMP-WORDLIST >R
  R@ OBJ-NAME!
  FIL-WL R@ CLASS!
  R> R> SWAP >R
  R@ OBJ-DATA! \ �����
  GET-CURRENT R@ PAR!
  R> SET-CURRENT
  R> STRFREE
;
: SEARCH-WORDLIST { c-addr u oid \ f -- 0 | xt 1 | xt -1 }

\ ������� ���� � ������� ������
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN

  c-addr u oid OBJ-NAME@ " {s}\{s}" DUP -> f STR@ 2DUP
  IsDirectory IF DIR>DIR ['] NOOP 1 f STRFREE EXIT THEN
  2DUP FileExists IF DIR>FIL ['] NOOP 1 f STRFREE EXIT THEN
  2DROP f STRFREE FALSE
;
: WORDS "" ['] swid. CONTEXT @ ForEachDirWRstr ;
>> CONSTANT DIR-WL

\EOF

\ ALSO DIR NEW: D:\
<<: DIR D:\ac\spf4\devel\~ac\lib WORDS :>>

\EOF
ALSO DIR NEW: c:
WINDOWS system32 drivers etc hosts 
ORDER CONTEXT @ CLASS.
CONTEXT @ OBJ-NAME@ R/O OPEN-FILE THROW DUP . CLOSE-FILE THROW CR
\ �������� � ������:
\ Context: c:\WINDOWS\system32\drivers\etc\hosts FORTH
\ Current: FORTH
\ FIL2036
PREVIOUS

ALSO c: DEFINITIONS PREVIOUS CREATE TEST_FILE.TXT
ORDER
GET-CURRENT CLASS. GET-CURRENT OBJ-DATA@ DUP . CLOSE-FILE THROW CR
\ ������� ���� c:\TEST_FILE.TXT (������ "��������� ������")
\ � �������� � ������:
\ Context: FORTH
\ Current: c:\TEST_FILE.TXT
\ FIL2036
DEFINITIONS

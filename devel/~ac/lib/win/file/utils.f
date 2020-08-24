REQUIRE {               ~ac/lib/locals.f
REQUIRE />\             ~ac/lib/string/conv.f
REQUIRE STR@            ~ac/lib/str5.f
REQUIRE DLOPEN          ~ac/lib/ns/dlopen.f 
REQUIRE LoadInitLibrary ~ac/lib/win/dll/load_lib.f 
REQUIRE replace-str     ~pinka/samples/2005/lib/replace-str.f 
REQUIRE COMPARE-U       ~ac/lib/string/compare-u.f
REQUIRE WinNT?          ~ac/lib/win/winver.f
REQUIRE OPEN-FILE-SHARED-DELETE ~ac/lib/win/file/share-delete.f
REQUIRE FIND-FILES-R    ~ac/lib/win/file/findfile-r.f 

WINAPI: CreateDirectoryA     KERNEL32.DLL
WINAPI: RemoveDirectoryA     KERNEL32.DLL
WINAPI: GetCurrentDirectoryA KERNEL32.DLL

WINAPI: CopyFileA KERNEL32.DLL
WINAPI: MoveFileA KERNEL32.DLL
WINAPI: MoveFileExA  KERNEL32.DLL

1 CONSTANT MOVEFILE_REPLACE_EXISTING
2 CONSTANT MOVEFILE_COPY_ALLOWED

: IsDirectory ( addr u -- flag )
  DROP GetFileAttributesA DUP FILE_ATTRIBUTE_DIRECTORY AND
  0<> SWAP -1 <> AND
;
: DIRECTORY-EXISTS ( addr u -- flag ) IsDirectory ;
: PATH-EXISTS      ( addr u -- flag ) FILE-EXIST ;

: CREATE-DIRECTORY ( addr u -- ior )
  DROP 0 SWAP
  CreateDirectoryA ERR
;
: DELETE-DIRECTORY ( addr u -- ior )
  DROP
  RemoveDirectoryA ERR
;
: RENAME-FILE-OVER ( addr-old u-old adr-new u-new -- ior )
  DROP NIP SWAP MOVEFILE_REPLACE_EXISTING MOVEFILE_COPY_ALLOWED OR
  ROT ROT MoveFileExA ERR
;
: CREATE-FILE-PATH1
  BEGIN
    [CHAR] \ DUP SKIP PARSE 2DROP ( WORD DROP) >IN @ #TIB @ <
  WHILE
    0 TIB >IN @ + 1- C!
    0 TIB CreateDirectoryA DROP
    [CHAR] \ TIB >IN @ + 1- C!
  REPEAT
;
: CREATE-FILE-PATH ( addr u io -- handle ior )
  { a u i }
  0 a u + C!
  a u i CREATE-FILE
  IF DROP a u />\
     a u ['] CREATE-FILE-PATH1 EVALUATE-WITH
     a u i CREATE-FILE
  ELSE 0 THEN
;
: EndsWith.BL/ ( addr u -- flag )
\ ����� ������ � acTCP �� ������ ������������� ��������� � �������,
\ � ������ ���� "�������������", �.�. Windows �� ������ ��������
\ � ��������� ��������� ����� � ��������������� ������� - � ������� 
\ ��������� � �������, �������� ������� ���������������� � �������.

  DUP 1 < IF 2DROP FALSE EXIT THEN
  + 1- C@ >R
  R@ [CHAR] . =
  R@ [CHAR] / = OR
  R@ [CHAR] \ = OR
  R> BL = OR
;
: __FileExists ( addr u -- flag )
  2DUP EndsWith.BL/ IF 2DROP FALSE EXIT THEN
  R/O OPEN-FILE-SHARED ?DUP
  IF NIP DUP 2 =
        OVER 3 = OR
        OVER 206 = OR 
        SWAP 123 = OR
        0=
  ELSE CLOSE-FILE THROW TRUE
  THEN
;
: FileExists
  2DUP EndsWith.BL/ IF 2DROP FALSE EXIT THEN
  FILE-EXIST
;


: ;>_ ( addr u -- )
  0 ?DO DUP C@ [CHAR] ; = IF [CHAR] _ OVER C! THEN 1+ LOOP DROP
;

\ ======== ~pig 20.11.2004,26.12.2007 ========
\ ������������ ���� � �����
\ ���� ���� \dir1\dir2\..\dir3 ���������� � ���� \dir1\dir3
\ �������� ����������� �� acWEB/src/proto/http/isapi.f (~ac)
: NormalizePath ( addr u -- addr 1 u1 )
  2DUP S" \.." SEARCH ?DUP 0=			\ ���� ��� �������������?
  IF S" /.." SEARCH THEN 0=
  IF 2DROP EXIT THEN				\ ��� - �������� ��� ����
  OVER 3 + C@ is_path_delimiter 0=		\ �� ������� ������ ���� ��� ���� �����������
  IF 2DROP EXIT THEN				\ ��� - �������� ��� ���� (���-�� � ���� ������������, ����� �� �������)
  ( \dir1\dir2\..\dir3    \..\dir3 )
  SWAP >R DUP >R				\ ��������� ��������� �������
  ( \dir1\dir2\..\dir3   u   R: a u )
  -						\ �������� �������
  ( \dir1\dir2   R: a u )
  BEGIN
    2DUP + 1- C@ is_path_delimiter 0= OVER 0 > AND	\ ������ ���������� �������
  WHILE
    1-
  REPEAT
  2DUP +					\ ��������� �� ����� ����������
  ( \dir1\  \dir1\^   R: a u )
  R> 4 -					\ �������� \..\
  ( \dir1\  \dir1\^  u-4  R: a )
  R> 4 + SWAP
  ( \dir1\  \dir1\^  dir3 )
  DUP >R					\ ����� ��� ����������
  ( \dir1\  \dir1\^  dir3  R: u-4)
  ROT SWAP MOVE					\ ������� ������ ������
  ( \dir1\dir3    R: u-4)
  R> +						\ ����� ����� ������
  2DUP + 0 SWAP C!				\ ��������� ���������� �� ������ ������
  RECURSE					\ ���������, ��������� ����� ���� ��������� ���������
;

\ ������� �������� ������������ EXE ������������ EXE ��������
\ ������ ���� "..\"
\ �������� ���� ��� ��� ������� ����������
\ ��� �������� ����� �� ��������, �� � ��� ������
\ ��� fs.exe - �������� ���-������ � fs.ini
\ (������ �� � ����������� �����, ������� �����
\ � ����� �������� � fs.exe � ������������ ������)
VARIABLE $ModuleDirLevel
: ModuleDirLevel ( -- addr u ) $ModuleDirLevel @ STR@ ;
: SetModuleDirLevel ( addr u -- ) $ModuleDirLevel S! ;

: MakeFullNameRaw ( a u -- a1 u1 )
\ ���� [a u] - ������������� ��� �����(��������),
\ ��, ������ ��� ������������ ������������ exe-������ ��������,
\ ���� ��� ������ ��� � ������ ModuleDirLevel;
\ ���� [a u] - ��� � ����� �� �����, �� ������� ��� � ������ �����,
\ ��� ����������� exe-����� ��������.
\ ����� ������� [a u].

  DUP 2 < IF EXIT THEN				\ ������� �������� ���� - ������� ��� ����
  OVER DUP C@ is_path_delimiter SWAP CHAR+ C@ is_path_delimiter AND	\ ��� UNC-���� (\\server\share)?
  IF EXIT THEN					\ �� - ������� ��� ����
  OVER CHAR+ C@ [CHAR] : = IF EXIT THEN		\ ������������ ����� ����� - ������ ����
  ModuleDirName					\ ���� � ������ EXE
  2OVER DROP C@ is_path_delimiter		\ ���� ���������� � �����������?
  IF DROP 2 " {s}{s}" STR@ EXIT THEN		\ �� - �������� �� ���� � EXE ������ ����� �����
  " {s}{ModuleDirLevel}{s}" STR@		\ ������� ����
;
: MakeFullName ( a u -- a1 u1 ) >STR STR@ MakeFullNameRaw NormalizePath ;

VARIABLE CurDir

: CurrentDirectory ( -- addr u )
  CurDir @ ?DUP IF ASCIIZ> EXIT
                ELSE 5000 ALLOCATE THROW CurDir ! THEN
  CurDir @ 5000 GetCurrentDirectoryA >R
  0 CurDir @ R@ + C!
  CurDir @ R>
;

: \file ( addr u -- addr2 u2 )
\ �������� �� ����\�����_����� ������ ���_�����
  DUP 0 ?DO
    2DUP + I - 1- C@ DUP [CHAR] \ = SWAP [CHAR] / = OR
    IF + I - I UNLOOP EXIT THEN
  LOOP
;
\ : FileExists 2DUP TYPE SPACE FileExists DUP . CR ;

: (DLOPEN_ext)
  2DUP FileExists IF DLOPEN EXIT THEN

  2DUP ModuleDirName " {s}{s}" DUP >R STR@ FileExists R> STRFREE 
  IF DLOPEN EXIT THEN

  2DUP ModuleDirName " {s}ext\{s}" DUP >R STR@ 2DUP FileExists
  IF 2SWAP 2DROP LoadInitLibrary R> STRFREE THROW EXIT THEN
  2DROP R> STRFREE 

  2DUP ModuleDirName " {s}..\ext\{s}" DUP >R STR@ 2DUP FileExists
  IF 2SWAP 2DROP LoadInitLibrary R> STRFREE THROW EXIT THEN
  2DROP R> STRFREE 

\  LoadInitLibrary THROW
  2DROP 0
;
: DLOPEN_ext
  ['] (DLOPEN_ext) CATCH IF 2DROP 0 THEN \ DLOPEN �� �������� THROW
;

: ">Q ( addr u -- addr2 u2 )
  2DUP S' "' SEARCH NIP NIP 0= IF EXIT THEN
  " {s}" DUP " {''}" " &quot;" replace-str- STR@
;

\ ~pig 17.03.2008, 
\ ~ruv 10.06.2008 ������������� CONTAINS->CONTAINS-WORD

\ CONTAINS-WORD ��������� ��������� ����� � ������
\ � ������� �� SEARCH ����������� ��������� �� ���������, � ������ �����
\ ��������������� �� ������������
\ CONTAINS-WORD-U - ����������, �� ��������� �������������������

: (CONTAINS-WORD) ( "string" S" word" -- flag )
  2>R						\ ��������� ��������� �� ������� �����
  BEGIN
    NextWord DUP				\ ������� ��������� �����
  WHILE
    2R@ COMPARE 0=				\ ��� ������� �����?
    IF RDROP RDROP TRUE EXIT THEN		\ �� - ������ �� ������
  REPEAT
  2DROP RDROP RDROP FALSE			\ �� �������
;
: CONTAINS-WORD ( S" string" S" word" -- flag ) 2SWAP ['] (CONTAINS-WORD) EVALUATE-WITH ;

: (CONTAINS-WORD-U) ( "string" S" word" -- flag )
  2>R						\ ��������� ��������� �� ������� �����
  BEGIN
    NextWord DUP				\ ������� ��������� �����
  WHILE
    2R@ COMPARE-U 0=				\ ��� ������� �����?
    IF RDROP RDROP TRUE EXIT THEN		\ �� - ������ �� ������
  REPEAT
  2DROP RDROP RDROP FALSE			\ �� �������
;
: CONTAINS-WORD-U ( S" string" S" word" -- flag ) 2SWAP ['] (CONTAINS-WORD-U) EVALUATE-WITH ;

: CREATE-FILE-SHARED-NI ( c-addr u fam -- fileid ior )
\ shared, �� ��� ������������
  NIP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  CREATE_ALWAYS
  0 ( secur )
  3 ( share )  
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
: OPEN-FILE-SHARED-DELETE-NI ( c-addr u fam -- fileid ior )
  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  OPEN_EXISTING
  0 ( secur )
  WinNT? IF 7 ( share read/write/delete ) ELSE 3 THEN
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
: CREATE-FILE-SHARED-DELETE-NI ( c-addr u fam -- fileid ior )
  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  CREATE_ALWAYS
  0 ( secur )
  WinNT? IF 7 ( share read/write/delete ) ELSE 3 THEN
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;

: CREATE-FILE-SHARED-DELETE-ON-CLOSE-NI ( c-addr u fam -- fileid ior )
  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
    FILE_FLAG_DELETE_ON_CLOSE OR
  CREATE_ALWAYS
  0 ( secur )
  WinNT? IF 7 ( share read/write/delete ) ELSE 3 THEN
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
: CREATE-FILE-RSHARED-DELETE-ON-CLOSE-NI ( c-addr u fam -- fileid ior )
  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
    FILE_FLAG_DELETE_ON_CLOSE OR
  CREATE_ALWAYS
  0 ( secur )
  1 ( share read )
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
: DELETE-FD ( addr u data flag -- )
  NIP
  IF DELETE-DIRECTORY THROW
  ELSE DELETE-FILE THROW THEN
;
: (DELETE-DIRECTORY-R) ( addr u -- )
  ['] DELETE-FD FIND-FILES-R
;
: DELETE-DIRECTORY-R { addr u -- ior }
\ ���������� ������� �������
  addr u ['] (DELETE-DIRECTORY-R) CATCH ?DUP
  IF NIP NIP
  ELSE addr u DELETE-DIRECTORY THEN
;

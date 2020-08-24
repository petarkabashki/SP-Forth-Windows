\ �������� ����� � ����� ������ ��������� ���������������
\ � ���� ������� ���� �������� ����. �������� ��������
\ ���������� ����� �������� ���� �������.
\ �������� ������ � WinNT*

REQUIRE WinNT? ~ac/lib/win/winver.f

: OPEN-FILE-SHARED-DELETE ( c-addr u fam -- fileid ior )
  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  OPEN_EXISTING
  SA ( secur )
  WinNT? IF 7 ( share read/write/delete ) ELSE 3 THEN
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
: CREATE-FILE-SHARED-DELETE ( c-addr u fam -- fileid ior )
  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  CREATE_ALWAYS
  SA ( secur )
  WinNT? IF 7 ( share read/write/delete ) ELSE 3 THEN
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;

0x04000000 CONSTANT FILE_FLAG_DELETE_ON_CLOSE

: CREATE-FILE-SHARED-DELETE-ON-CLOSE ( c-addr u fam -- fileid ior )
\ � ������� �� ���������� ������� ����� �� ������ �����������
\ �������� ��������� �����, �� � ����������� �� ������������� ���
\ ��������������� �������� ��� �������� ���� ��� �������.
\ ��� ������ �� CREATE-FILE-SHARED-DELETE+(�����)DELETE-FILE ���
\ �������� �����-�����, �� ��������� �������� � ���� ���������� (������-������).

  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
    FILE_FLAG_DELETE_ON_CLOSE OR
  CREATE_ALWAYS
  SA ( secur )
  WinNT? IF 7 ( share read/write/delete ) ELSE 3 THEN
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
